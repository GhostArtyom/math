/-!
# 第 2 课：命题即类型，证明即项

这是 Lean 最需要"换个脑子"的地方：

  * 一个**命题** `P` 是一个类型（类型是 `Prop`）。
  * 一个**证明** `h : P` 就是这个类型的一个项。
  * "证明 P 蕴含 Q" = "写一个函数：给我一个 P 的证明，我还你一个 Q 的证明"。
  * 类型检查通过 = 证明正确。这是 Lean 里唯一的验证标准。

所以读 Lean 代码时，看到 `h : p → q` 不要读成"命题 p 推出 q"，
要读成"h 是一个函数，输入 p 的证明，输出 q 的证明"。
两者是同一件事——这就是 Curry–Howard 对应。

（开头的 set_option 只是关掉一个爱唠叨的 linter：像 `fun n => rfl` 这种
写法里 n 没被正文引用，Lean 会警告。本仓库的 lakefile 里也有一行
`leanOptions := #[⟨`autoImplicit, false⟩]`，那是在全局配置这类开关。）
-/

set_option linter.unusedVariables false

-- ---------------------------------------------------------------
-- 1. Prop：命题的类型
-- ---------------------------------------------------------------
#check True              -- True : Prop
#check 1 = 1             -- 1 = 1 : Prop
#check ∀ n : Nat, n + 0 = n   -- 一个 Prop

-- ---------------------------------------------------------------
-- 2. 同一个证明的两种写法：项模式 vs 策略模式
-- ---------------------------------------------------------------
-- 项模式（term mode）：直接写那个"证明项"
theorem t1 : 1 + 1 = 2 := rfl
theorem t2 : ∀ n : Nat, n + 0 = n := fun n => rfl

-- 策略模式（tactic mode）：用 by 进入，一行一行地改目标
theorem t2' : ∀ n : Nat, n + 0 = n := by
  intro n        -- 目标里的 ∀ 被去掉，n 进入上下文，目标变成 n + 0 = n
  rfl            -- rfl 证明"两边按定义相等"

-- 两者完全等价。`by` 只是"编译出证明项"的一种交互写法。
#print t2'               -- 可以看到 t2' 最终就是一个 fun n => rfl

-- ---------------------------------------------------------------
-- 3. 读纯项模式代码：它是函数，不是"逻辑推理"
-- ---------------------------------------------------------------
theorem t3 (n : Nat) : n + 0 = n := t2 n     -- 把 t2 当作函数调用

theorem imp_trans (p q r : Prop) (h1 : p → q) (h2 : q → r) (hp : p) : r :=
  h2 (h1 hp)             -- 读作：先 h1 hp 得到 q 的证明，再喂给 h2

-- 和写 `fun x => ...` 没区别。看到这种代码不要慌。

-- ---------------------------------------------------------------
-- 4. 逻辑连接词都是归纳类型（inductive type）
-- ---------------------------------------------------------------
#print And               -- And 是一个 inductive，只有一个构造子 And.intro
#print Or
#print Exists

-- And 的构造：把两个证明包起来。⟨_, _⟩ 是构造子的简写
theorem and_intro (p q : Prop) (hp : p) (hq : q) : p ∧ q := ⟨hp, hq⟩

-- And 的消去：用 .1 / .2 / .left / .right 取出来
theorem and_elim_left (p q : Prop) (h : p ∧ q) : p := h.1
theorem and_elim_right (p q : Prop) (h : p ∧ q) : q := h.2

-- 存在量词消去：rcases 把 ∃ 拆成"一个具体的见证 + 它满足性质"
theorem exists_use : ∃ n : Nat, n > 3 := ⟨4, by omega⟩

theorem exists_elim (P : Nat → Prop) (h : ∃ n, P n) : ∃ m, P (m + 0) := by
  rcases h with ⟨n, hn⟩     -- 拆开：得到见证 n 和证明 hn : P n
  exact ⟨n, by simpa using hn⟩

-- ---------------------------------------------------------------
-- 5. 否定：¬p 就是 p → False
--    "证明 p 是假的" = "给我 p 的证明，我推出矛盾"
-- ---------------------------------------------------------------
#check Not               -- Not : Prop → Prop
example (p : Prop) (h : ¬ p) (hp : p) : False := h hp

-- 反证法需要经典逻辑。Lean 默认是构造性的（直觉主义），
-- 也就是说：核心库（不 import 任何东西时）里拿不到排中律。
-- 想用经典推理要显式打开 Classical，或者直接 import Mathlib
--（Mathlib 里 `by_contra`、`push_neg` 等策略都随即可用）。
open Classical

-- 方式一：by_cases 分两种情况（这里靠 Classical 提供了 Decidable 实例）
example (p : Prop) : p ∨ ¬ p := by
  by_cases hp : p
  · exact Or.inl hp
  · exact Or.inr hp

-- 方式二：把双重否定消掉。¬¬p 就是 (p → False) → False，
-- 所以 Classical.byContradiction 正好能直接吃掉它。
example (p : Prop) (h : ¬ ¬ p) : p := Classical.byContradiction h

-- 方式三：用 apply 把它变回目标，再 intro 出矛盾
example (p : Prop) (h : ¬ ¬ p) : p := by
  apply Classical.byContradiction
  intro hp                 -- 现在上下文里有 hp : ¬p，目标是 False
  exact h hp

-- ---------------------------------------------------------------
-- 6. 常用策略速查（这个表背下来就能读懂本仓库 90% 的证明）
-- ---------------------------------------------------------------
--   intro h          把 ∀ / → 左边的假设搬进上下文，命名为 h
--   exact e          用项 e 直接关闭当前目标（类型必须匹配）
--   apply h          反向推：如果 h : P → Q 而目标是 Q，就把目标换成 P
--   rfl              证明按定义相等（a = a，或能归约成同一个东西）
--   rw [h]           把目标里的某处按等式 h 重写
--   simp             用一批已登记的引理疯狂化简，最常用也最慢
--   ring             化简交换环里的多项式等式（如 (a+b)^2 = a^2+2ab+b^2）
--   omega            线性整数/自然数算术的判定过程（Presburger）
--   linarith         线性实数/有理数算术
--   constructor      目标是 ∧ / ↔ / ∃ 时，拆成若干子目标
--   cases h          对 h 分情况（构造子逐个讨论）
--   induction n      归纳法
--   simpa using h    先 simp 一下再用 h
--   have h : P := …  引入一个中间结论
--   calc  … := …     写一串等式/不等式的链式推导（可读性最好）
--   sorry            承认这里没证（会有 warning）。本仓库的
--                    ComparatorChallenges/*.lean 大量使用它，
--                    因为那些文件的目的是"陈述命题"，不是给出证明。

-- 一个综合例子，五种写法达到同一目的
example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]

example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  subst h
  rfl

example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  simp [h]

example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  omega

example (a b : Nat) (h : a = b) : a + 1 = b + 1 := congrArg (· + 1) h
