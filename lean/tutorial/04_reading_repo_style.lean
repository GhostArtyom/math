import Mathlib

/-!
# 第 4 课：读懂本仓库风格的 Lean 代码

注意上面这一行：**`import` 必须是文件的第一条命令**。
Lean 里 `/-! … -/` 是"模块文档字符串"，它本身就是一条命令，
所以它不能写在 `import` 前面（写了会报
`invalid 'import' command, it must be used in the beginning of the file`）。
这就是为什么 Mathlib 的文件总是 `import` 在最上面。

（另外：本教程必须从 `lean/` 目录下用 `lake env lean tutorial/xx.lean` 运行，
因为 `lake env` 只在包含 lakefile 的目录里才会设置好库搜索路径。）

前三课的文件不 import 任何东西，编译 0.2 秒。
这一个文件只多了一行 `import Mathlib`——编译它需要几十秒。
第 5 课（README）用这个对比解释原因。

本课用 `ComparatorChallenges/KaplanskyDirectFiniteness.lean` 当标本，
逐字拆解它的每一个符号。
-/

-- ---------------------------------------------------------------
-- 标本一（原文）：
--
--   import Mathlib
--
--   namespace OAI
--
--   namespace KaplanskyCounterexample
--
--   def MainClaim : Prop :=
--     ∃ (K : Type) (_ : Field K) (_ : Fintype K) (_ : CharP K 2),
--       ∃ (G : Type) (_ : Group G) (_ : Group.FG G),
--         ∃ a b : MonoidAlgebra K G, a * b = 1 ∧ b * a ≠ 1
--
--   theorem main_theorem : MainClaim := by
--     sorry
--
--   end KaplanskyCounterexample
--   end OAI
-- ---------------------------------------------------------------

-- 逐行翻译：
--
-- ① `import Mathlib`
--    把整个 Mathlib 库拉进来（约 150 万行）。本仓库每个文件都这么干，
--    这是编译慢的头号原因，见第 5 课。
--
-- ② `namespace OAI` / `namespace X` / `end X`
--    纯命名空间隔离，让名字变成 `OAI.X.foo`。没有语义，只是避免重名。
--    读代码时可以先把 namespace 行脑内删掉。
--
-- ③ `def MainClaim : Prop := …`
--    定义一个**命题**（类型是 Prop）。注意它是 def 不是 theorem——
--    因为这里只是给命题起名字，没有证明它。
--    数学读法： "我们断言存在一个域 K，有限、特征 2，
--               和一个有限生成群 G，以及 a b 使得 ab=1 但 ba≠1。"
--
-- ④ `∃ (K : Type) (_ : Field K) (_ : Fintype K) (_ : CharP K 2), …`
--    这是本仓库最典型的写法。`∃` 后面连续绑定了四样东西：
--      (K : Type)        一个类型（不是元素！存在量词可以量化类型）
--      (_ : Field K)     下划线 = 这个假设后面用不到，不命名
--                        读作"K 是一个域"
--      (_ : Fintype K)   "K 是有限类型"（Fintype 不是 Prop 而是 Type，
--                        它是能枚举元素的**数据结构**，所以这不是纯命题）
--      (_ : CharP K 2)   "K 的特征是 2"
--    最后逗号后面的才是结论。所以整个 ∃ 是"存在满足这些条件的 K"。
--
-- ⑤ `MonoidAlgebra K G`  就是群代数 K[G]。
--    `∃ a b : MonoidAlgebra K G, a * b = 1 ∧ b * a ≠ 1`
--    读作"存在 a b，ab=1 而 ba≠1"——即 K[G] 不是 Dedekind 有限的。
--
-- ⑥ `theorem main_theorem : MainClaim := by sorry`
--    `sorry` = "此处省略证明"。Lean 会接受，但给出 warning，
--    并且在 `#print axioms` 里留下 `sorryAx` 痕迹。
--    ComparatorChallenges/ 里的文件几乎全是这种"只有陈述、没有证明"的
--    骨架——它们的用途是给外部检查器（comparator）当**命题规格**，
--    真正的证明在这个仓库的 OAI/ 目录里，或者根本不在这个仓库里。
--
-- ⑦ 注意 `: Prop :=` 和 `:= by` 的区别：
--       def MainClaim : Prop := …     定义的是"一个命题"
--       theorem main_theorem : MainClaim := by …  证明的是"那个命题"
--    分不清这两者，是初学者读这类文件最大的坑。

-- ---------------------------------------------------------------
-- 标本二：本仓库真实文件里随处可见的"陈述性"声明
--   把它们抄下来跑，能确认自己读对了。
-- ---------------------------------------------------------------

namespace OAI
namespace KaplanskyCounterexample

-- 复刻原文的命题（原样照抄，只是不写 sorry）
def MainClaim : Prop :=
  ∃ (K : Type) (_ : Field K) (_ : Fintype K) (_ : CharP K 2),
    ∃ (G : Type) (_ : Group G) (_ : Group.FG G),
      ∃ a b : MonoidAlgebra K G, a * b = 1 ∧ b * a ≠ 1

-- #check 可以验证"我抄下来的东西类型是 Prop"
#check MainClaim

-- 拆开一点点看：把内层单独拿出来，理解每一层的类型
#check fun (K : Type) => (Field K)
#check fun (K : Type) [Field K] => MonoidAlgebra K

-- ---------------------------------------------------------------
-- 标本三：一个真的能编译通过的 Mathlib 风格小定理
--   看 `by` 里面发生了什么。这才是"证明"该有的样子。
-- ---------------------------------------------------------------

-- Mathlib 里有现成的结论，用 #check 找名字是日常操作
#check Nat.add_comm
#check add_comm
#check Finset.sum_add_distrib
#check Irrational
#check Real.sqrt

-- `example` = 匿名的 theorem，只为了验证一件事，不留下名字。
-- 读到一个陌生证明时，把它拆成 example 逐句跑，是最快的理解方式。
example (a b c : ℕ) : a * (b + c) = a * b + a * c := by
  ring                    -- ring 处理交换环里的多项式恒等式

example (x : ℝ) : x ^ 2 - 1 = (x - 1) * (x + 1) := by
  ring

example (n : ℕ) : 2 * n = n + n := by
  omega                   -- omega 处理线性整数算术

-- 同一个结论的"可读性最好"写法：calc 链
example (x : ℝ) : (x + 1) ^ 2 = x ^ 2 + 2 * x + 1 := by
  calc (x + 1) ^ 2 = x ^ 2 + 2 * x * 1 + 1 ^ 2 := by ring
    _ = x ^ 2 + 2 * x + 1 := by ring

-- 经典数学里"两个实数相等当且仅当差为零"这种步骤，
-- 在 Lean 里通常是一个 `rw` 或 `nlinarith`。

end KaplanskyCounterexample
end OAI

-- ---------------------------------------------------------------
-- 标本四：本仓库的目录约定
-- ---------------------------------------------------------------
--   OAI/<学科>/<家族名>/<具体文件>.lean   真正的证明
--   OAI.lean                              把所有文件 import 一遍的"总入口"
--   ComparatorChallenges/<家族>.lean      只有命题 + sorry 的规格文件
--   ComparatorChallenges/<家族>.json      给 comparator 的检查配置
--   lakefile.lean                         包定义 + 40 多个 git 依赖
--
-- 想理解某个结果被形式化成了什么，读 ComparatorChallenges 的 .lean；
-- 想看它到底怎么证的，读 OAI/ 里同名家族的文件。
