# 条目 266：六维互无偏基与 Fourier 证书

本文解析条目 266 对应的两篇论文。正文依据本地 PDF 提取；公式中的特殊字符使用同目录 TeX 源码交叉核对。

- [The maximum number of mutually unbiased bases in dimension six](../preprints/The-maximum-number-of-mutually-unbiased-bases-in-dimension-six-September-24-2026/The-maximum-number-of-mutually-unbiased-bases-in-dimension-six-September-24-2026.pdf)
- [Exact Fourier certificates for complex Hadamard matrices of order six](../preprints/Exact-Fourier-certificates-for-complex-Hadamard-matrices-of-order-six-September-24-2026/Exact-Fourier-certificates-for-complex-Hadamard-matrices-of-order-six-September-24-2026.pdf)

## 1. 问题背景

在 $\mathbb C^d$ 中，两个正交归一基 $\mathcal B$ 和 $\mathcal C$ 称为互无偏基（mutually unbiased bases，MUB），如果任意 $b\in\mathcal B$、$c\in\mathcal C$ 都满足

$$
|\langle b,c\rangle|^2=\frac1d.
$$

这表示：如果系统处于一个基向量对应的纯态，用另一个基测量时，每个结果的概率都是 $1/d$。MUB 因此同时出现在量子态层析、量子密钥分发和互补测量设计中。令 $N(d)$ 为 $d$ 维中两两互无偏正交归一基的最大数量。一般上界是 $N(d)\le d+1$；当 $d$ 是素数幂时，已有达到 $d+1$ 的构造。六维是第一个非素数幂维数，不能直接套用这种有限域构造。

条目 266 包含两个相关但不同的问题：

1. 是否能在 $\mathbb C^6$ 中找到四个两两互无偏的正交归一基？主论文在指定计算契约下证明不能，因此 $N(6)=3$。
2. 六阶复 Hadamard 矩阵的特定 Fourier character sum 是否必然消失？第二篇论文证明，除了 Tao 的 cubic equivalence class 外，所有六阶复 Hadamard 矩阵都满足该消去性质，并由另一个精确证书得到 $N(6)\le5$。

两篇论文研究相同的测量结构，但证明路线不同；Fourier 消去定理本身不等价于 $N(6)=3$，也不能独自排除四组基。Fourier 论文使用纯整数/有理数证书；$N(6)=3$ 的主论文使用带明确数值计算契约的计算机辅助穷举。

| 结果 | 证明性质 | 最终得到的界 |
| --- | --- | --- |
| 三组基的显式构造 | 张量积与有限矩阵计算 | $N(6)\ge3$ |
| 排除四组任意复基 | 完整覆盖、数值误差界、图搜索与执行记录 | 条件契约下 $N(6)\le3$ |
| 排除七组完整家族 | 精确整数/有理数 moment certificate，加 completion theorem | $N(6)\le5$ |
| Fourier 消去 | 精确恒等式与 cubic alternative 分类 | 非 Tao 类的 $g_H(\pi\alpha)=0$ |

## 2. 基本代数化

先用一个共同酉变换把候选 MUB 家族的第一组基变成标准基。任何与标准基互无偏的第二组基都可以写成

$$
\frac{1}{\sqrt 6}H,
$$

其中 $H\in\mathbb C^{6\times6}$ 满足

$$
|H_{ij}|=1,\qquad HH^*=6I.
$$

这样的 $H$ 称为六阶复 Hadamard 矩阵。其列除以 $\sqrt6$ 后正交归一，每个坐标模长都是 $1/\sqrt6$，所以恰好对应一组与标准基互无偏的基。排除四组 MUB 就转化为：对任意这样的 $H$，标准基和 $H/\sqrt6$ 不能再扩展出两组基。

### 为什么一般上界是 $d+1$

一组基给出一个维数 $d-1$ 的无迹对角矩阵子空间。两组基互无偏时，这两个子空间在 Hilbert–Schmidt 内积下正交，因为

$$
\operatorname{tr}
\left[
\left(bb^*-\frac Id\right)
\left(cc^*-\frac Id\right)
\right]
=|\langle b,c\rangle|^2-\frac1d.
$$

全部无迹矩阵空间的维数是 $d^2-1$。若有 $k$ 组 MUB，就有 $k(d-1)\le d^2-1$，因此 $k\le d+1$。在六维，该计数只给 $7$，还远未达到需要证明的 $3$；论文需要额外的六维相位结构。

论文允许的等价变换包括行列置换、逐行或逐列乘以模为 $1$ 的复数、复共轭以及转置。这些操作分别对应基向量重排、相位选择、复共轭和交换描述方式，不会改变是否可扩展为 MUB 家族。

## 3. 主论文：证明 $N(6)=3$

### 3.1 结论

主论文的定理是：

> 在论文给出的算术与编译器条件下，新完成的完整执行证书排除 $\mathbb C^6$ 中的四组两两互无偏正交归一基。因此 $N(6)=3$。

这个上界是计算机辅助证明。论文给出了有限覆盖、逐层收缩、局部排除、记录文件和执行结果组成的完整证书链；下界 $N(6)\ge3$ 则来自 $\mathbb C^2\otimes\mathbb C^3$ 上的张量积构造。

### 3.2 第一步：有限 seed cover

对 $H$ 做行列相位调整，使第一行和第一列都变成 $1$，这一操作称为 dephasing。余下的 $5\times5$ 区域仍有 $25$ 个相位坐标，不能直接说整个矩阵只有九个自由参数。论文首先只覆盖前两行和前两列，其中去除已固定的第一行、第一列后共有九个 seed coordinates；右下 $4\times4$ 块留给下一阶段完成。

记 $e(t)=\exp(2\pi it)$，相位以周期为单位。论文使用置换、复共轭和转置等对称性为 seed 选代表，再用闭区间网格和正交性的必要条件，保证每个精确 Hadamard 矩阵的 seed 都落入有限个闭球之一。

浮点中心本身可以不是精确解。证明需要的是整个区域都被覆盖：判断“不可能”时，误差界必须对区域中的所有精确解有效。后续阶段把残差、范数和位移估计保存为认证记录；计算失败、达到搜索上限或无法证明覆盖的区域都必须保留为未解决记录。

主论文报告的 fresh run 在 2026 年 10 月 4 日完成，seed cover 处理 $151{,}744{,}086$ 个 pair，保留 $249{,}878$ 个 centers。这些数字是该次执行的证据，不是与硬件无关的复杂度定理。

### 3.3 Stage A：$2+4$ 分块完成 Hadamard

固定一个 seed 后，把 $H$ 按行列大小 $2+4$ 分块。上左、上右、左下块的相位已经由 seed 和位移控制，未知量主要集中在右下角的 $4\times4$ 块。

在通过认证检查的 seed center 处，上右块和左下块的共轭转置秩为二，它们在 $\mathbb C^4$ 中各有二维核。把未知的 $4\times4$ 块压缩到这两个核之间，得到一个 $2\times2$ 矩阵。Hadamard 方程把这个矩阵限制在 $\sqrt6$ 倍的酉极因子附近。随后：

- 用有限个闭单元覆盖二阶酉矩阵群 $U(2)$；
- 在每个单元中使用统一的 Taylor 余项界；
- 若残差或必要不等式不可能，则排除该单元；
- 若仍可能，则把该单元中的所有精确 Hadamard 解覆盖进新的认证相位球。

压缩把未知补全的核心搜索变成对 $U(2)$ 的有限覆盖。核的框架固定在 seed center，实际解与中心的偏移始终通过误差项控制，不要求中心是精确 Hadamard 矩阵。

### 3.4 Stage B：切向方向与 residual identity

Stage A 得到的球通常还太大，无法直接排除两个额外基。Stage B 为每个球保存一组近似切向方向 $T$，并用 Hadamard 残差映射的导数估计精确解的位移：

$$
\delta=T\eta+\nu,
$$

其中 $\eta$ 是切向坐标，$\nu$ 是由残差恒等式控制的法向误差。具体而言，论文把不同两行的正交残差组成映射

$$
F_{ij}(P)=\frac1{2\pi i}\sum_{g=0}^5e(P_{ig}-P_{jg}),
\qquad0\le j<i\le5.
$$

$F(P)=0$ 当且仅当相位矩阵 $e(P)$ 是 Hadamard。其导数和二阶余项估计用于认证下面的单侧界：

$$
\|(I-TT^*)\delta\|
\le n_0+\mathrm{id}\,\|\delta\|+C\|\delta\|^2
$$

其中 $\mathrm{id}$ 是认证数据中的一个误差常数。随后只对切向坐标做细网格覆盖，并保留法向界，得到更小的球。数值方向不必精确正交，球也不必包含某个“已求出的根”；只要区域内所有精确解仍被覆盖即可，因此不需要常秩或光滑流形假设。

### 3.5 Stage C：把无偏向量变成图论排除

固定一个最终相位球。任何同时对标准基和 $H/\sqrt6$ 的测量结果均匀的向量都可以写成

$$
\frac1{\sqrt6}(1,e(\beta_1),\ldots,e(\beta_5)),
$$

其中整体相位已经归一化。论文用闭相位区间覆盖这些向量，并把每个小向量球作为图的顶点。

构造两张图：

- 图 $\mathcal O$ 的边表示两个向量仍可能正交；
- 图 $\mathcal U$ 的边表示两个向量的内积模平方仍可能为 $1/6$。

若存在两个额外的 MUB，每组各含六个向量，则必须在 $\mathcal O$ 中出现两个不相交的六点团（clique），且两组之间的全部 $36$ 条边都必须出现在 $\mathcal U$ 中。论文还证明这些向量必须具有不同的覆盖球标签，因此这个图条件是必要条件。对所有相位球执行有限图搜索并排除该模式，就排除了两组额外基。

所有额外向量对应同一个 Hadamard 矩阵，因此成对测试还保留共同的切向位移，不能让不同候选向量各自挑选不同的第二基来通过测试。任何图搜索上限或聚类失败都记录为未解决区域，进入 fallback；只有回退处理也完成且没有未解决记录时，才可形成排除结论。

### 3.6 执行契约

主论文的数值结论依赖明确的 machine arithmetic contract：

- binary64、round-to-nearest；
- 不使用 fast-math reassociation，关闭 floating-point contraction；
- 正确舍入的 square root 和指定的 gradual underflow 行为；
- 固定的 GCC/compiler/build 参数；
- 对生成的 binary 和源文件进行 hash 与 disassembly 检查；
- 每个 seed、refined ball、batch 和 fallback record 都必须被完整处理。

论文强调，一次程序正常退出并不自动等于数学证书。还必须核对输入记录、输出记录数、失败文件是否完整、batch 拼接是否一致、fallback 是否覆盖所有初始失败，以及最终 graph stage 是否没有 unresolved record。

主论文 §7.5 报告的记录链如下。这里仅摘录 PDF 报告，没有重新运行主论文的整个计算：

| 阶段 | 输入规模 | 输出记录 | 未解决记录 |
| --- | --- | --- | --- |
| seed cover | $151{,}744{,}086$ 对 | $249{,}878$ 个中心 | 不适用 |
| A 四个分片合计 | $249{,}878$ 个中心 | $3083$ | $0$ |
| B mid | $3083$ | $600$ | $0$ |
| B fine | $600$ | $22{,}379$ | $0$ |
| initial C | $22{,}379$ | 不适用 | $163$，全部为图搜索上限 |
| B fallback | $163$ | $1127$ | $0$ |
| final C 四个分片合计 | $1127$ | 不适用 | $0$ |

这表示失败记录被保守地回退处理，而不是被直接当作“不存在”。

### 3.7 下界：三组 MUB 的显式构造

把 $\mathbb C^6$ 识别为 $\mathbb C^2\otimes\mathbb C^3$。在 $\mathbb C^2$ 中取

$$
A_0=I_2,\qquad
A_1=\frac1{\sqrt2}\begin{pmatrix}1&1\\1&-1\end{pmatrix},
\qquad
A_2=\frac1{\sqrt2}\begin{pmatrix}1&1\\i&-i\end{pmatrix}.
$$

这是三组 Pauli 型基，不同基之间的内积模平方都是 $1/2$。在 $\mathbb C^3$ 中取

$$
\omega=e^{2\pi i/3},\quad
F=\frac1{\sqrt3}(\omega^{jk})_{j,k=0}^2,\quad
D=\operatorname{diag}(1,\omega,\omega),\quad
B_0=I_3,\ B_1=F,\ B_2=DF.
$$

由 $1+\omega+\omega^2=0$ 以及有限三项和，可验证不同基之间的内积模平方为 $1/3$。令

$$
U_r=A_r\otimes B_r
$$

给出 $\mathbb C^6$ 中的三组基。因为

$$
U_r^*U_s=(A_r^*A_s)\otimes(B_r^*B_s),
$$

当 $r\ne s$ 时，每个矩阵元的模平方都是 $(1/2)(1/3)=1/6$。因此 $N(6)\ge3$，与主论文上界合起来得到 $N(6)=3$。

## 4. Fourier 论文

### 4.1 Character sum

对六阶复 Hadamard 矩阵 $H$ 和 balanced charge $a\in\mathbb Z^6$（即 $\sum_i a_i=0$），定义

$$
g_H(a)=\frac16\sum_{k=0}^{5}\prod_{i=0}^{5}H(i,k)^{a_i}.
$$

balanced 条件使 $g_H(a)$ 不受单独给每一列乘相位的影响。行相位则会把整个和乘上一个单位复数，所以“等于零”这一性质同样不变。正交性给出

$$
g_H(e_i-e_j)=0\qquad(i\ne j).
$$

论文研究的特殊 charge 是

$$
\alpha=(1,1,1,-1,-1,-1).
$$

在这个位置，

$$
g_H(\alpha)=\frac16\sum_{k=0}^5
\frac{H(0,k)H(1,k)H(2,k)}
{H(3,k)H(4,k)H(5,k)}.
$$

它检测的是三行相位乘积对另外三行乘积的高阶平衡，无法直接由任意两行正交推出。论文的核心就是把这个高阶条件从低阶正交关系中提取出来。

### 4.2 Fourier vanishing 定理

设 $\omega=e^{2\pi i/3}$，Tao 的 cubic matrix 可具体写成 $T_{ij}=\omega^{t_{ij}}$，其中

$$
(t_{ij})=
\begin{pmatrix}
0&0&0&0&0&0\\
0&0&1&2&2&1\\
0&1&0&1&2&2\\
0&2&1&0&1&2\\
0&2&2&1&0&1\\
0&1&2&2&1&0
\end{pmatrix}.
$$

指数 $2$ 与 $-1$ 对三次单位根相同。非初始五个指标上的指数 $1$ 形成一个五环。直接检查任意两行的比值，每种三次单位根各出现两次，就得到行正交；逐元素平方是 $\overline T$，同样 Hadamard。

论文证明：

> 如果六阶复 Hadamard 矩阵 $H$ 不等价于 $T$，那么对任意坐标置换 $\pi$，都有 $g_H(\pi\alpha)=0$。

这解决了 Matolcsi、Ruzsa 和 Weiner 提出的 Fourier-vanishing conjecture，而且不要求 $H$ 属于预先参数化的 Hadamard family。

### 4.3 第一层证书：非负平均迫使二分支

论文通过平均不同的行列抽样，把 character-sum 乘积写成有限个矩（moments）。抽样限制行、列指标互异的部分称为 injective moments。展开乘积时按重复列指标的分组分类；对于含一对 $+1/-1$ 指数的行，正交性又把该矩改写为行合并后的矩。这形成可精确消元的线性关系，包括“已经占满六行，没有第七条可抽样行”的边界关系，而不是假设存在一个七阶矩阵。

在这些关系上，论文构造辅助表达式 $L_H$。其具体数据是

$$
w=(-3,-2,0,1,2,2),\qquad
L_H=-g_H(w)+\sum_{j=1}^4c_jg_H(a_j)g_H(w-a_j),
$$

$$
\begin{aligned}
a_1&=(-1,-1,0,0,1,1),&
a_2&=(-2,0,0,0,1,1),\\
a_3&=(-1,-1,0,1,0,1),&
a_4&=(-1,-1,0,1,1,0),
\end{aligned}
\qquad(c_1,c_2,c_3,c_4)=(2,1,1,1).
$$

再对两个 charge

$$
q_{\mathrm{cross}}=(2,0,0,-2,0,0),\qquad
q_{\mathrm{same}}=(2,-2,0,0,0,0)
$$

分别证明

$$
3\left\langle |L_{\widetilde H}|^2\right\rangle_H
+\left\langle |g_{\widetilde H}(\alpha)g_{\widetilde H}(q)|^2\right\rangle_H=0.
$$

这里的平均遍历有限的行排列等操作，每个项都有正权重。$L_H$ 是 PDF §3.3 给出的固定辅助表达式；它的作用是把要证明的消去嵌入一个可核验的平方和恒等式。每一项都是非负数，所以对于每个行排列，都有

$$
g_H(\alpha)g_H(q_{\mathrm{cross}})=0,\qquad
g_H(\alpha)g_H(q_{\mathrm{same}})=0.
$$

如果某个排列下 $g_H(\pi\alpha)\ne0$，就能推出所有 $i\ne j$ 都有

$$
g_H\bigl(2(e_i-e_j)\bigr)=0.
$$

这等价于 $H^{\circ2}$ 的不同行正交，因此它也是 Hadamard 矩阵；这里 $H^{\circ2}$ 指逐元素平方，不是矩阵乘积 $H^2$。于是得到二分支：

1. 所有排列的 $g_H(\pi\alpha)$ 都为 $0$；
2. $H$ 和 entrywise square $H^{\circ2}$ 都是 Hadamard。

### 4.4 结构论证：分类 cubic alternative

若 $H$ 与 $H^{\circ2}$ 都是 Hadamard，取两行的逐元素比值 $v=(v_0,\ldots,v_5)$。两个 Hadamard 条件给出

$$
p_1(v)=\sum_i v_i=0,\qquad p_2(v)=\sum_i v_i^2=0.
$$

Newton 恒等式先给 $e_1=e_2=0$；再由 $|v_i|=1$ 得到 $e_{6-k}=e_6\overline{e_k}$，故 $e_4=e_5=0$。于是

$$
\prod_{i=0}^5(z-v_i)=z^6-e_3z^3+e_6.
$$

其中 $e_k$ 是 $v$ 的第 $k$ 个初等对称多项式。这个六次多项式实际上是 $z^3$ 的二次式，所以六个行比值只能由两组三次单位根的旋转组成。立方后若有两个不同值，它们各出现三次；若两组重合，则同一个值出现六次。

论文对 $H$ 做 dephasing，比较各行立方后非 $1$ 值的位置，证明非恒定行必须具有相同的三点支撑。若存在非平凡 $3+3$ 分块，两个行类在三维子空间中的限制会相互正交且各至少二维，这是不可能的。因此 dephased 矩阵所有元素的立方都为 $1$。

每个非初始行、列中三种单位根各出现两次。把额外的 $1$ 移到对角线后，另外五个指标上的 $\omega$ 位置形成一个无向二度图。五个顶点的简单二度图只能是五环，于是得到 Tao 矩阵 $T$。结合上一步二分支，非 Tao 类只能满足全部 Fourier 消去。

### 4.5 第二个 exact certificate：排除七组 MUB

Fourier 论文还处理七组 MUB 的完整家族排除问题。假设存在七组 MUB，则每两组基之间的归一化过渡矩阵

$$
H_{rs}(i,k)=\sqrt6\,\langle b_{r,i},b_{s,k}\rangle
$$

都是 Hadamard 矩阵。论文把不同过渡矩阵的 character sums 组织成 mixed moments，即共享基标签与抽样规则下的混合矩。

对单个过渡矩阵，使用行列正交性；对不同矩阵，使用无偏性给出的内积恒等式；对完整七基家族，使用七个五维无迹对角子空间在 $35$ 维无迹矩阵空间中正交分解的投影恒等式。不同基向量的约束经过共享列抽样，进入同一 Gram 矩阵，保留了仅检查单个矩阵时会遗漏的相容性。

先用精确 character identities 排除完整家族中出现 Tao cubic transition 的情形；其余 transition 都满足 Fourier 消去。接着构造六个显式正二次型：有限 character functions 的 Gram 矩阵必半正定，系数矩阵 $Z_\lambda$ 用精确 Schur 补计算认证为正定。

这不只是针对单个 Hadamard 的消去，而是使用基之间的混合约束。精确代数消元后，每个二次型的总和写为 $f+\sum_\rho\beta_\rho X_\rho$，其中实际 moments 满足 $|X_\rho|\le1$。常数项 $f$ 的负值严格压过全部剩余系数的绝对值之和，得到

$$
5\sum_\lambda 10^{15-e_\lambda}
\mathbb E\bigl(Y_\lambda^*Z_\lambda Y_\lambda\bigr)
\le
\frac{-613302797399911+179721388988719}{6480}
= -\frac{2007321335237}{30}<0.
$$

左边按构造必须非负，右边严格为负，矛盾。因此不存在七组 MUB。Weiner completion theorem 说明：$\mathbb C^d$ 中的 $d$ 组 MUB 可以扩展到 $d+1$ 组；若六维有六组，就可以补成已排除的七组。因此

$$
N(6)\le5.
$$

这个五基上界是 Fourier 论文的精确整数/有理数证书；它与主论文的 $N(6)=3$ 是不同层级的结果。

### 4.6 证书核验

Fourier 论文的 verifier 使用 Python 标准库和 assertions，执行两类有限检查：

1. 用模素数消元寻找候选线性替换，再用有理数重构提出替换规则；
2. 清除分母后，用整数乘法逐项检查这些规则是否确实由已知 moment equations 推出，并认证六个系数矩阵的正性与最终严格负界。

本次实际运行 [verification/run.py](../preprints/Exact-Fourier-certificates-for-complex-Hadamard-matrices-of-order-six-September-24-2026/verification/run.py)，其先检查验证器的 SHA-256，再运行精确断言。输出与 PDF 附录 A 完全一致：

```text
rank table: 8871 909 897
rank table: 46041 3429 2767
-613302797399911/6480 179721388988719/6480 5000000000000000
```

两行 rank table 分别列出使用的方程数、moment 坐标数和用于替换的独立见证行数；最后一行给出常数项、其余系数绝对值之和以及统一缩放因子。它们是有限算术核验的结果。验证器不假设实际 moment values 是有理数，只检查替换对任意满足已知线性关系的实 moment vector 成立。

## 5. 影响与形式化范围

- **量子测量设计：** 在主论文契约下，六维最多三组 MUB，不能取得素数幂维数中的完整 MUB 体系。这限制了层析或协议中“所有测量基都完美互无偏”的设计空间；不意味着六维无法做完整态层析，也不意味着 QKD 的密钥率直接由这个数量决定。
- **Hadamard 矩阵分类：** Fourier 消去把六阶 Hadamard 的高阶 character sum 与 Tao cubic class 联系起来，证明只有这个特殊等价类才可能出现非消去行为。
- **计算机辅助证明：** 主论文展示了如何把连续相位空间、浮点误差、有限覆盖和图搜索包装成可审计的 one-sided certificate；换编译器、换 binary64 行为或只运行部分阶段，都不能直接继承原结论。
- **Lean 范围：** [lean/docs/266.md](../lean/docs/266.md) 对应的是 Fourier vanishing、五基上界和 cube-fiber cancellation 辅助引理；它没有形式化主论文的四基 computer-assisted exclusion，也没有单独在 Lean 中建立完整的 $N(6)=3$ 执行证书。

主论文还给出一个确切的代数推论：对应基下的无迹对角矩阵构成 $\mathfrak{sl}_6(\mathbb C)$ 的 Cartan 子代数，MUB 条件等价于 Killing 正交。因此，在相同计算契约下、且要求对同一个标准共轭转置封闭时，这类两两 Killing 正交的 Cartan 子代数最多三个。这个伴随封闭条件不能省略。

## 6. 本次核验的范围

本次直接读取了两份 PDF，并核对源码与 Lean 入口。Fourier 精确验证程序已运行完成、退出码为零，支持其两项 invariant-moment 算术证书；它不等于自动验证论文每个数学论证。

当前主论文目录只有 PDF、README 和 build 源码，未找到 PDF §7 引用的 `verification/code/`、`verification/computation/` 和完整 native execution archive。因此本文没有复跑四基排除的 C++ pipeline；上面的运行计数和 $N(6)=3$ 来自论文报告，并保留其算术、编译器与完整执行条件。

OAI 的 [Main.lean](../lean/OAI/Analysis/MutuallyUnbiased/Main.lean) 中，`fourier_and_family_bound` 通过已有实现组合 Fourier 消去和五基上界。Comparator 文件是定义目标陈述的接口，带占位证明；实际实现应追踪 OAI 模块。本次没有重新编译完整 Lean 项目。

## 7. 原文定位

| 阅读目标 | PDF 位置 |
| --- | --- |
| 问题、计算机辅助主定理及历史 | MUB 主论文 §1，定理 1.1 |
| 三组基的构造及 Cartan 推论 | MUB 主论文 §1.3、§1.4 |
| 九相位 seed 完整覆盖 | MUB 主论文 §2 |
| $U(2)$ 补全与 Root certificates | MUB 主论文 §3、§4 |
| 切向收缩与覆盖保留 | MUB 主论文 §5 |
| 向量覆盖与两个六团排除 | MUB 主论文 §6 |
| 运行契约、最终记录、浮点误差界 | MUB 主论文 §7、附录 A |
| Character 定义和 Fourier 主定理 | Fourier 论文 §1、§2，定理 1.1 |
| 平方和二分支、cubic 分类 | Fourier 论文 §3、§4 |
| 排除七基的混合证书 | Fourier 论文 §5、§6，定理 1.2 |
| 精确消元与验证器 | Fourier 论文 §7、附录 A |

## 8. 阅读时应注意

1. “$N(6)=3$”来自主论文的完整 execution contract；“$N(6)\le5$”来自 Fourier 论文的 exact certificate，不能把两者混写成同一个证明。
2. 主论文中的 binary64 和 compiler assumptions 是定理假设的一部分，fresh execution 是证明链的一环。
3. Lean 形式化证明的是论文结果的选定子集，而不是 PDF 中全部几何、数值和执行细节。
