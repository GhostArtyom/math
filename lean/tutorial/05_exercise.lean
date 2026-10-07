import Mathlib

/-!
# 第 5 课：自测

README 里最后那段"读懂就算入门"的代码，就是这个文件。
它同时演示了两件最有用的技巧：

  1. 读陌生证明的最快方法 —— 把它拆开、跑起来、看目标状态
  2. `#print axioms` —— 确认它真的被证明了，而不是靠 sorry 撑着

## 逐句翻译

```lean
theorem foo {n : ℕ} (h : 0 < n) : ∃ k : ℕ, n = k + 1 := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp h)
  exact ⟨k, rfl⟩
```

* `{n : ℕ}`     隐式参数。调用者不用给 n，Lean 从 h 的类型里推出来。
* `(h : 0 < n)` 显式假设。`0 < n` 里两个都是 Nat，`<` 通过类型类解析。
* `∃ k : ℕ, n = k + 1`
                 目标是一个 Prop。注意 `∃` 绑定的名字 k 后面还要用。
* `Nat.pos_iff_ne_zero.mp h`
                 `h : 0 < n`，`.mp` 取出正向，得到 `h' : n ≠ 0`。
                 这种 `xxx_iff_yyy.mp / .mpr` 是 Mathlib 里最常见的调用形式。
* `Nat.exists_eq_succ_of_ne_zero h'`
                 得到 `∃ k, n = k + 1`。
* `obtain ⟨k, rfl⟩ := …`
                 把存在量词拆开：见证叫 k，证明是 `n = k + 1`。
                 这里模式写的是 `rfl` 而不是变量名——`obtain` 会把它当作
                 **重写规则**，就地用 `k + 1` 替换掉目标里所有的 `n`。
                 这是本仓库里随处可见的惯用法。
* `exact ⟨k, rfl⟩`
                 `⟨_, _⟩` 是 `Exists.intro` 的简写：
                 打包"见证 k"+"证明 rfl"（重写后目标正好是 k+1 = k+1）。
-/

namespace OAI
namespace Tutorial

theorem foo {n : ℕ} (h : 0 < n) : ∃ k : ℕ, n = k + 1 := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp h)
  exact ⟨k, rfl⟩

-- 确认上面这个定理没有依赖任何公理（连经典逻辑都没用上）
#print axioms foo

-- 对比一下：如果这里写 sorry，输出就会变成含有 'sorryAx'
-- 自己去试：把上面那个 foo 换成 sorry，重跑，看 #print axioms 的输出。
--
-- 这也是检查本仓库任意结论是否真的被证明的标准手法:
--     #print axioms OAI.SomeFamily.main_theorem

end Tutorial
end OAI
