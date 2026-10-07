/-!
# 第 3 课：归纳类型、结构、类型类

前两课的 `Nat`、`And`、`Or` 都不是"内置魔法"，它们全都是用同一个机制
定义的：`inductive`。数学对象在 Lean 里就是归纳类型 + 函数。

这一课解决"读不懂"的三个最大来源：
  1. 模式匹配 / 递归定义（`def f | pat => ...`）
  2. `structure` 与点号记法（`p.x`、`h.1`）
  3. 方括号 `[...]` 里的类型类（Mathlib 代码里满屏都是）
-/

-- ---------------------------------------------------------------
-- 1. 自己定义一个自然数。注意：这和 Lean 内置的 Nat 是同一个形状。
--    读法：MyNat 有两个构造子，zero 不带参数，succ 带一个 MyNat。
-- ---------------------------------------------------------------
inductive MyNat where
  | zero : MyNat
  | succ : MyNat → MyNat
deriving Repr

-- 模式匹配 + 结构递归：Lean 会检查递归是否"结构递减"，
-- 保证不会死循环（这也是为什么 Lean 里不可能写出不停机的函数）
namespace MyNat

def add : MyNat → MyNat → MyNat
  | zero,   m => m
  | succ n, m => succ (add n m)

def ofNat : Nat → MyNat
  | 0     => zero
  | n + 1 => succ (ofNat n)

def toNat : MyNat → Nat
  | zero   => 0
  | succ n => toNat n + 1

end MyNat

#eval MyNat.toNat (MyNat.add (MyNat.ofNat 2) (MyNat.ofNat 3))   -- 5

-- 归纳证明：目标里有 `induction n with` 之后，每个构造子一个分支，
-- 递归参数会自动带来归纳假设（ih）
theorem MyNat.add_zero (n : MyNat) : MyNat.add n MyNat.zero = n := by
  induction n with
  | zero => rfl
  | succ n ih =>
    show MyNat.succ (MyNat.add n MyNat.zero) = MyNat.succ n
    rw [ih]

-- 注意这里 `show` 的作用：把目标改写成"按定义展开后"的形式，
-- 好让下一步 rw 看得清楚。读代码时 `show` 常常是"作者在帮你解释"。

-- ---------------------------------------------------------------
-- 2. structure：就是"带命名字段的构造子"，数学里的"有序对/记录"
--    它其实也是 inductive，只是只有一个构造子。
-- ---------------------------------------------------------------
structure Point where
  x : Int
  y : Int
deriving Repr, DecidableEq

-- 两种构造方式：⟨_, _⟩ 或 { x := _, y := _ }
def origin : Point := ⟨0, 0⟩
def p : Point := { x := 3, y := 4 }

#check Point.mk          -- mk 是构造子
#eval p.x                -- 点号记法 p.x 就是 Point.x p
#check Point.x           -- Point.x : Point → Int

-- 函数式更新：{ 旧值 with 字段 := 新值 }
def shiftX (q : Point) (d : Int) : Point := { q with x := q.x + d }

#eval (shiftX p 10).x    -- 13

-- `where` 语法：定义时直接写字段，读起来像声明（Mathlib 里很常见）
def q : Point where
  x := 1
  y := 2

-- 等式证明：字段相等的两个 Point 相等
example : p = { x := 3, y := 4 } := rfl
example : p.x = 3 := rfl

-- ---------------------------------------------------------------
-- 3. 类型类（type class）：方括号 [...] 里的东西
--
--    这是 Lean 里"重载"的机制。`+` 不是内置的，
--    它要求存在一个 `Add α` 的实例，然后调用它的 add 方法。
-- ---------------------------------------------------------------
#check (1 + 1 : Nat)

-- 自己定义一个小类型类
class MySize (α : Type) where
  size : α → Nat

instance : MySize Nat where
  size n := n

instance : MySize Bool where
  size b := if b then 1 else 0

-- [MySize α] 读作"假设 α 有 MySize 实例"，Lean 会自动找到它
def describe {α : Type} [MySize α] (a : α) : String :=
  s!"size = {MySize.size a}"

#eval describe 42
#eval describe true

-- #synth 问"这个实例能推导出来吗"；#check 一个实例名也能看它长什么样
#synth MySize Bool
#check (inferInstance : MySize Nat)

-- 读 Mathlib 代码时的关键直觉：
--   (α : Type)       显式参数，必须给
--   {α : Type}       隐式参数，靠推断
--   [Add α]          类型类假设：自动搜索实例
--   [Fact (0 < n)]   类型类形式的"前提假设"
-- 例如 Mathlib 的除法签名大致是
--   HDiv.hDiv : (a b : α) → [HDiv α] → α
-- 所以遇到 "failed to synthesize instance" 报错，
-- 意思就是"我没有找到能处理这个类型的那个运算/性质"。

-- ---------------------------------------------------------------
-- 4. 读代码时怎么快速看懂一个定义？三个命令
-- ---------------------------------------------------------------
#print MyNat.add        -- 看定义体（含模式匹配编译成的东西）
#check @MyNat.add       -- 看带全部（含隐式）参数的签名
#print axioms MyNat.toNat   -- 看这个定义依赖了哪些公理（重要！）
-- 最后一个命令在做形式化验证时非常关键：如果输出里有
-- `sorryAx`，说明这个结论是靠 sorry 撑着的；
-- 如果只有 `propext`、`Classical.choice`、`Quot.sound`，
-- 那就是标准的经典数学三个公理，可以接受。

#print axioms MyNat.add_zero
