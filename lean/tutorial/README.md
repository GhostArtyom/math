# Lean 入门（从零开始）

这是给"没学过 Lean、但手上有一大堆 Lean 代码要读"的人写的。
配套文件是一个个可以真跑的小文件，从第 1 课按顺序读。

```sh
cd /home/ghost/Code/math/lean          # 必须在含 lakefile.lean 的目录下
lake env lean tutorial/01_terms_and_types.lean
```

> ⚠️ `lake env` 只在**包含 `lakefile.lean` 的目录**里才会设置好库搜索路径。
> 在子目录里执行 `lake env lean xx.lean` 会报
> `unknown module prefix 'Mathlib'`——这不是代码错，是路径错。
>
> 想跳过 `lake env` 的几秒启动开销：
> ```sh
> export LEAN_PATH=$(lake env printenv LEAN_PATH)
> lean tutorial/01_terms_and_types.lean    # 现在快得多
> ```

| 文件 | 内容 | 需不需要 Mathlib |
|---|---|---|
| `01_terms_and_types.lean` | 项与类型、函数、隐式参数、依值类型、宇宙 | 不需要 |
| `02_propositions_as_types.lean` | 命题即类型、项模式 vs 策略模式、逻辑连接词、常用 tactic | 不需要 |
| `03_inductive_and_classes.lean` | 归纳类型、结构体、类型类、`#print axioms` | 不需要 |
| `04_reading_repo_style.lean` | 逐字拆解本仓库的真实写法 | 需要 |
| `05_exercise.lean` | 自测：读懂就算入门的那段代码，逐句翻译 | 需要 |
| `bench.sh` | 复现第 5 课的所有计时数据 | — |

---

## 第 0 课：Lean 到底是什么

一句话：**Lean 是一个编程语言，同时是一个证明助手。**

它的世界观只有一条规则：

> 每个东西都有一个类型。命题是类型，证明是这个类型的项。
> "类型检查通过"就是"证明正确"。

这就是 **Curry–Howard 对应**。举例：

| 数学语言 | Lean 语言 |
|---|---|
| 命题 P | 类型 `P`（类型是 `Prop`） |
| P 的证明 | 类型 `P` 的一个项 `h : P` |
| P 蕴含 Q | 函数类型 `P → Q` |
| 证明 P→Q | 写一个函数：输入 `P` 的证明，返回 `Q` 的证明 |
| P 且 Q | `P ∧ Q`（一个归纳类型，只有一个构造子 `And.intro`） |
| 对所有 n 成立 | 依值函数类型 `(n : Nat) → P n` |
| 存在 n 使 P(n) | 归纳类型 `∃ n, P n`（构造子打包"见证 + 证明"） |

所以"读 Lean 代码"其实是在读**函数**，不是读逻辑推导。
想通这一点，满屏的 `→`、`fun`、`apply` 就都不吓人了。

Lean 的信任链非常短：所有东西最终由一个小内核（kernel）重新检查。
这是它能当"验证工具"用的原因，也是它慢的原因（见第 5 课）。

---

## 第 1 课：项与类型

打开 `01_terms_and_types.lean`。要点：

```lean
#check double            -- double : Nat → Nat       "问：这是什么类型？"
#eval double 21          -- 42                       "跑一下"
#print double            -- 看定义体
def double (n : Nat) : Nat := n + n
```

**读法**：`def 名字 (参数 : 类型) : 返回类型 := 表达式`

四个必须记住的括号含义：

| 写法 | 含义 | 你需不需要管 |
|---|---|---|
| `(α : Type)` | 显式参数 | 调用时要给 |
| `{α : Type}` | 隐式参数 | Lean 自动推断，一般不用管 |
| `[Add α]` | 类型类实例，自动搜索 | 报 `failed to synthesize` 时才要看 |
| `(h : p)` | 普通假设/参数 | 要管 |

**依值类型**是 Lean 比普通语言强的地方，也是它类型检查更难更慢的原因：

```lean
def Vec (α : Type) (n : Nat) : Type := Fin n → α
-- Vec Bool 3 和 Vec Bool 4 是两个完全不同的类型，不能互相赋值。
```

**宇宙**：`Nat : Type`，而 `Type : Type 1`。日常写数学不用管，
看到 `Type u` 里的 `u` 就是宇宙层级变量。

---

## 第 2 课：命题即类型

这是最需要换脑子的地方。同一个证明有两种写法，**完全等价**：

```lean
-- 项模式：直接写出那个证明项（它就是个函数）
theorem t2 : ∀ n : Nat, n + 0 = n := fun n => rfl

-- 策略模式：用 by 进入，一步步改目标
theorem t2' : ∀ n : Nat, n + 0 = n := by
  intro n
  rfl
```

`by` 不是"另一种逻辑"，它只是**通过交互方式把证明项拼出来**。
`#print t2'` 会告诉你真相：它就是一个 `fun n => Eq.refl (n + 0)`。

### 读代码时怎么读假设

```lean
theorem imp_trans (p q r : Prop) (h1 : p → q) (h2 : q → r) (hp : p) : r :=
  h2 (h1 hp)
```

不要读成"p 推出 q，q 推出 r，所以 r"，要读成：
**`h1` 是个函数，喂 `hp` 得到 `q` 的证明；再喂给 `h2` 得到 `r` 的证明。**
就是函数调用。Mathlib 里大量代码长这样，按函数读立刻通顺。

### 逻辑连接词都是归纳类型

```lean
#print And       -- 只有一个构造子 And.intro；消去用 h.1 / h.2
#print Or        -- 两个构造子 Or.inl / Or.inr；处理它必须 cases
#print Exists    -- 构造子打包 "见证 w" 和 "证明 p w"
```

### 必背 tactic 表（能读懂本仓库 90% 的证明）

| tactic | 作用 | 备注 |
|---|---|---|
| `intro h` | 把 `∀`/`→` 左边的假设搬进上下文 | |
| `exact e` | 用项 `e` 关闭目标 | 类型必须匹配 |
| `apply h` | 反向推：目标 `Q`，`h : P → Q`，目标变 `P` | |
| `rfl` | 证明按定义相等 | |
| `rw [h]` | 按等式 `h` 重写目标 | |
| `simp` | 用一批登记过的引理化简 | 最常用、也最慢 |
| `simp only [...]` | 只用指定的引理化简 | 比 `simp` 可控得多 |
| `ring` | 交换环里的多项式恒等式 | Mathlib |
| `omega` | 线性整数/自然数算术（Presburger） | 核心库也有 |
| `linarith` / `nlinarith` | 线性 / 非线性实数算术 | Mathlib |
| `norm_num` | 数值计算化简 | Mathlib |
| `constructor` | 拆开 `∧`/`↔`/`∃` 目标 | |
| `cases h` | 对 `h` 分情况 | |
| `induction n` | 归纳法 | |
| `have h : P := …` | 引入中间结论 | |
| `calc … := …` | 链式推导，可读性最好 | |
| `simpa using h` | 先 `simp` 再用 `h` | |
| `sorry` / `admit` | 承认这里没证 | 会留 `sorryAx` 痕迹 |

**经典逻辑要注意**：Lean 默认是构造性的。核心库里没有排中律，
要用得 `open Classical`。但只要你 `import Mathlib`，`by_contra`、
`push_neg`、`by_cases` 全都能直接用。

---

## 第 3 课：归纳类型、结构体、类型类

`Nat`、`And`、`Or`、`Exists` 都不是内置魔法，全都是 `inductive`：

```lean
inductive MyNat where
  | zero : MyNat
  | succ : MyNat → MyNat

def MyNat.add : MyNat → MyNat → MyNat
  | zero,   m => m
  | succ n, m => succ (add n m)
```

**模式匹配**（`| 模式 => 结果`）就是按构造子分情况。
**结构递归**：Lean 检查递归是否结构递减，保证不停机——
这就是为什么 Lean 里写不出死循环函数。

`structure` 是"只有一个构造子的归纳类型"，数学对象全靠它：

```lean
structure Point where
  x : Int
  y : Int

def p : Point := ⟨3, 4⟩      -- 或 { x := 3, y := 4 }
#eval p.x                     -- 点号记法：p.x 就是 Point.x p
def q := { p with x := 10 }   -- 函数式更新
```

**类型类**（方括号 `[...]`）是 Lean 的重载机制。`+` 也不是内置的，
它要求存在一个 `Add α` 实例。看到报错 `failed to synthesize instance`，
意思就是"没找到能处理这个类型的那个运算/性质"。

### 三个"看穿"命令（做形式化验证必备）

```lean
#print MyNat.add        -- 看定义体（模式匹配会被编译成 brecOn，别怕）
#check @MyNat.add       -- 看含全部隐式参数的完整签名
#print axioms MyNat.toNat
```

`#print axioms` 是最重要的一个。它回答：
**"这个结论到底依赖了哪些公理？"**

- 输出 `'X' does not depend on any axioms` → 完全构造性证明，最干净
- 只有 `propext`、`Classical.choice`、`Quot.sound` → 标准经典数学，可接受
- 出现 **`sorryAx`** → **这个结论没被证明**，是靠 `sorry`/`admit` 撑着的

---

## 第 4 课：读懂本仓库的风格

打开 `04_reading_repo_style.lean`，它逐字拆解了
`ComparatorChallenges/KaplanskyDirectFiniteness.lean`。

### 本仓库的目录约定

| 路径 | 是什么 |
|---|---|
| `OAI/<学科>/<家族>/<文件>.lean` | 真正的证明主体 |
| `OAI.lean` | 总入口，把 902 个顶层模块 import 一遍 |
| `ComparatorChallenges/<家族>.lean` | **只有命题 + `sorry` 的规格文件** |
| `ComparatorChallenges/<家族>.json` | 给 comparator 的检查配置 |
| `lakefile.lean` | 包定义 + 30 个 git 依赖 |
| `tutorial/` | 本教程（不在 lakefile 的 globs 里，不影响 `lake build`） |

**最重要的一条**：`ComparatorChallenges/` 里 405 个文件有 404 个含 `sorry`。
它们的作用是给外部检查器当**命题规格**，不是证明。
想理解某个结果被形式化成了什么 → 读 `ComparatorChallenges/`；
想看它到底怎么证的 → 读 `OAI/` 里同家族的文件。

### `def X : Prop := …` vs `theorem x : X := by …`

这是初学者最大的坑：

```lean
def MainClaim : Prop := ∃ K, Field K ∧ …    -- 定义"一个命题"（没证明它）
theorem main_theorem : MainClaim := by sorry -- 证明"那个命题"（这里没证）
```

### 一个实用习惯

读到一个陌生证明时，**把它拆成 `example` 逐句跑**，是最快的理解方式：

```lean
example (a b c : ℕ) : a * (b + c) = a * b + a * c := by ring
```

### 检查一批文件里有多少没证

```sh
grep -rl 'sorry\|admit' OAI --include='*.lean' | wc -l
```

本仓库现状：`OAI/` 里 `sorry` 有 **0** 个，但 `admit` 有 **514** 个文件
（`admit` 就是 `sorry` 的别名，痕迹同样是 `sorryAx`）。
所以别只看有没有 `sorry`。

---

## 第 5 课：为什么 Lean 编译要这么久

先用 `bench.sh` 复现（数字来自本机实测；系统有负载时会有 ±20% 波动）：

| 场景 | 耗时（最快一次） | 峰值内存 |
|---|---|---|
| 只 import 核心库（第 1–3 课） | **0.4 – 0.6 s** | **约 390 MB** |
| **只写一行 `import Mathlib`，无任何内容** | **7.5 – 9 s** | **约 5 900 MB** |
| 第 4 课（`import Mathlib` + 内容） | 7.5 – 9 s | — |
| `ComparatorChallenges` 规格文件（内容几乎为空） | 7.5 – 9 s | — |
| 真实 `OAI/` 证明文件 | 约 6.3 s | — |
| 本仓库单文件构建（421 个样本实测） | 中位数 **16 s**，均值 **19.2 s**，最大 **69 s** | — |

注意一个反直觉的现象：**规格文件（`sorry`）比真实证明文件还慢**。
因为规格文件的类型（`∃ K, Field K ∧ Fintype K ∧ CharP K 2 ∧ …`）
需要解大量类型类，而"加载 Mathlib"那 7.5 秒在两者里是一样的。

**结论一句话：那 7.5 秒几乎全是"加载 Mathlib"，你文件里的内容本身不花时间。**

再看规模：

| 项 | 数值 |
|---|---|
| Mathlib 源码 | 8 529 个 `.lean`，**2 327 634 行** |
| Mathlib 编译产物 | 8 548 个 `.olean`，**6.1 GB** |
| `import Mathlib` 加载的模块数 | ~8 500 个（全部） |
| 本仓库 `OAI/` | **121 734** 个 `.lean` 文件，1.7 GB |
| `.lake/` 总体积 | **24 GB** |
| `lakefile.lean` 的 git 依赖 | 30 个（mathlib、TauCeti、carleson…） |

### 为什么加载就要 7.5 秒、6 GB 内存？

因为 Lean 的 `.olean` 不是一个"编译好的机器码文件"，而是
**整个逻辑环境（所有定义、定理、类型类实例、记号）的序列化快照**。
`import Mathlib` 意味着把这 8 548 个快照全部反序列化进内存，常驻。

Lean 每次要判断"这两个东西相等吗"（defeq 检查），就要在这个巨大的
环境里查定义、展开、做类型类搜索。环境越大，单次查找越慢。
**这就是为什么 Mathlib 项目的编译是 O(环境大小) 而不是 O(文件大小)。**

### 编译一个文件到底发生了什么

1. **Elaboration（精化）**：把 `by` 里的 tactic 一步步执行，猜隐式参数，
   解类型类，做 unification。这是最慢的一步，因为依值类型的
   unification 和类型类搜索**在一般情况下是不可判定的**，只能搜索+回溯。
2. **内核复查（kernel checking）**：精化产物是一个证明项，
   由一个小内核重新逐条验证。`ring`、`simp`、`norm_num` 这类
   "重" tactic 产生的证明项可以极其巨大（几十 MB 到 GB 级），
   内核必须全部重新检查。
3. **序列化**：把新的环境写成 `.olean`。

第 1、2 步的时间和"环境里有多少东西可用"强相关——这正是 Mathlib 的代价。

### 本仓库为什么更慢

- **单文件 10–70 秒**：这些文件用了大量 `simp`/`ring`/`nlinarith`/
  大 `calc` 链。tactic 是**搜索过程**，不是查表。
- **改一个引理，下游全部重建**：依赖是传递的 DAG。
  `OAI.lean` 一个入口 import 902 个模块，动一处就可能重建一大片。
- **120 000+ 个文件 + 24 GB 编译产物**：`lake build` 是从零重跑
  整个 12 000+ 模块的图，按中位数 16 秒算就是**几十小时**。
- **mmap 限制**：本仓库 `lean/README.md` 特意提到
  `vm.max_map_count` 太小会导致编译失败——因为 Lean 用 mmap
  加载 olean，文件数量一多就撞上内核的映射数量上限。

### 实操建议（能省掉大量等待）

1. **先拉预编译产物，别自己编 Mathlib**
   ```sh
   cd /home/ghost/Code/math/lean
   lake exe cache get        # 下载 Mathlib 已编译的 olean
   ```
   这就是 `.lake/mathlib-cache` 和 `02-cache.log` 在做的事。
2. **千万不要删 `.lake/`**：那 24 GB 换的是几十小时。
3. **编译具体目标，别 `lake build`**
   ```sh
   lake build OAI.Analysis.BiholderTransport.Main
   ```
4. **用窄 import 而不是 `import Mathlib`**（这只是省事的写法）：
   ```lean
   import Mathlib.Analysis.SpecialFunctions.Log.Basic
   ```
5. **检查结论是否真的被证明**（本仓库尤其重要）：
   ```lean
   #print axioms OAI.SomeFamily.main_theorem
   ```
   见到 `sorryAx` 就是没证。
6. **`-j` 并行要小心**：每个 Lean 进程峰值可能占 6 GB，
   `lake build -j 4` 就是 24 GB。
7. **交互式开发用编辑器（VS Code + Lean 4 扩展），不要反复 `lake build`**：
   扩展会在你打字时就告诉你目标状态（goal state），
   这比"改一行、等 20 秒"快几个数量级。

---

## 自测：读懂下面这段代码就算入门了

```lean
import Mathlib

namespace OAI

theorem foo {n : ℕ} (h : 0 < n) : ∃ k : ℕ, n = k + 1 := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp h)
  exact ⟨k, rfl⟩

end OAI
```

逐句翻译：

- `import Mathlib` — 拉进整个库（编译要 7.5 秒，见第 5 课）
- `{n : ℕ}` — 隐式参数：调用时由 `h` 反推出 `n`
- `(h : 0 < n)` — 显式假设
- `∃ k : ℕ, n = k + 1` — 目标是一个 `Prop`
- `by` — 进入策略模式
- `obtain ⟨k, rfl⟩ := …` — 把 `Nat.exists_eq_succ_of_ne_zero` 提供的事实
  拆开：得到见证 `k`，并用 `rfl` 把 `n` 就地替换成 `k + 1`
- `exact ⟨k, rfl⟩` — 用 `Exists.intro` 构造子打包"见证 `k`"和"证明 `rfl`"

如果你能自己讲出上面这些，就已经能读本仓库 90% 的代码了。
剩下的 10% 是数学内容，不是 Lean 语法。
