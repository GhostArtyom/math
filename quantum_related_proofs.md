# 量子计算、量子信息与泛量子主题证明

本文根据仓库目录、`CONTENTS.md`、`overview.tex`、`preprints/` 和 `lean/docs/` 的交叉检索整理。这里的“证明内容”包括两类：一类是仓库对论文结果的目录说明和论文稿；另一类是已经列入 Lean 形式化目录的定理。两者不能混为一谈：论文条目描述的是论文声称的完整结果，Lean 条目通常只覆盖其中一个主定理、辅助定理或较弱版本。下文会单独说明这种范围差异。

## 总览

仓库中确实有一组直接属于量子计算和量子信息的结果：量子电路复杂性、QMA-hardness、量子因式分解、QAOA、量子信道容量、纠缠与 PPT 信道、玻色系统的熵不等式、纠缠博弈的并行重复，以及互无偏基。另有一组属于泛量子主题：量子多体系统、拓扑相与谱隙、玻色-爱因斯坦凝聚、BFSS 矩阵量子力学、共形网和量子场论。它们共同覆盖了“算法—复杂性—信息传输—纠缠—多体物理—量子场论”这条链条。

需要特别注意：以下条目中只有标有“Lean 已形式化”的部分能直接在 Lean 项目中作为已登记的形式化结果追踪；没有该标记的条目目前在仓库中主要表现为论文/目录材料，不能据此声称其完整证明已经形式化。

## 一、量子算法与量子复杂性

### 1. QAC⁰ 中的奇偶性下界（条目 274）

- **论文 PDF：** [Product-projection localization](preprints/Product-projection-localization-and-the-QAC0-parity-lower-bound-September-24-2026/paper.pdf)；[Regular trajectories and quantum parity](preprints/Regular-trajectories-pruning-and-quantum-parity-September-24-2026/paper.pdf)

- **问题：** Moore 猜想关注固定深度量子电路能否计算奇偶函数：电路可以使用任意单比特门和无界扇出的 Toffoli 门，量子比特数至多为输入长度的多项式，辅助比特从 $\ket{0}$ 开始，最后只测量一个输出比特。
- **结论：** 这类电路不能以固定的正优势计算奇偶性；输出相对随机猜测的优势可以被压到任意指定的正数以下。
- **方法：** 核心是对“输入与一个产品态只相差少数位”的子空间做产品投影局部化。对固定深度 $d$，证明电路 $U$ 把零失配子空间送入大失配子空间的矩阵块范数满足 $\lVert [M\ge N^t]U[M=0]\rVert\le e^{-N^s}$（$0\le s<t$）；这里允许存在未计数但彼此纠缠的辅助寄存器。证明中把无界扇出 Toffoli 写成 $I-2P$ 的产品投影反射，逐层展开并做外层归纳；再用 $p(D)$ 近似零失配投影，配合逆电路和有限次失配阈值 bootstrap，把所有轨迹压到低失配区。最后选取互补 Hadamard 产品态，将奇偶性变成输出零概率的 Fourier 系数；若存在固定优势，该系数应保持为正，但局部化估计使其趋于零，从而得到矛盾。
- **影响：** 这不是只针对某一种门表的下界，而是在多项式辅助比特、任意单比特门、无界扇出 Toffoli 和只测量一个输出的模型中同时成立，因而明确了常深度量子电路的表达能力边界。论文还把同一机制推广到优势为 $1/(\log n)^\gamma$ 的严格多数，以及互补输出概率和 Dicke 态制备等任务，说明“丢弃垃圾寄存器”或只保留测量结果并不能绕过全局奇偶信息的障碍。
- **Lean 已形式化：** `lean/docs/274.md`；包括一般正优势下界、常深度下界和多项式规模特化。论文中的全部轨迹传播细节并未都作为独立 Comparator 定理列出。

### 2. 连续 Coulomb 能量的 QMA-hardness（条目 275）

- **论文 PDF：** [Binary nuclear charges](preprints/Continuum-Coulomb-hardness-with-binary-nuclear-charges-September-24-2026/Continuum-Coulomb-hardness-with-binary-nuclear-charges-September-24-2026.pdf)；[Unit nuclear charges](preprints/QMA-hardness-of-continuum-Coulomb-energy-with-unit-nuclear-charges-September-24-2026/QMA-hardness-of-continuum-Coulomb-energy-with-unit-nuclear-charges-September-24-2026.pdf)

- **问题：** 研究三维连续空间中多电子 Coulomb 哈密顿量的基态能量能否被有效近似，特别是在核位置为有理数、核电荷为 1、电子数为多项式规模等受限条件下是否仍然困难。
- **结论：** 该近似问题具有 QMA-hardness（QMA 困难性）；允许用二进制编码任意正整数核电荷的版本也成立。
- **方法：** 归约先把量子验证电路的逻辑比特嵌入一组彼此分离的连续势阱：阱的位置和深度用有理数精确给出，电子的空间轨道、费米子反对称性和自旋自由度共同承担编码。随后用阱间隧穿实现 Pauli 项和局部门，利用 Coulomb 相互作用、交换项以及辅助电子产生惩罚项；二进制核电荷版本直接编码多比特整数，单位核电荷版本则通过复制、几何缩放和额外阱把电荷限制降到 $1$。证明逐项控制离散模型到连续模型的谱误差、反对称子空间泄漏和核间相互作用，并在最后加入能量平移和间隔放大，使 YES/NO 两种情形之间保持至少 $1$ 的 promise gap，且粒子数、坐标位数和输出精度都是多项式规模。
- **影响：** 结果把量子计算复杂性与第一性原理电子结构计算直接连接起来：即使模型只含三维连续 Coulomb 势、有理核位置、单位核电荷和多项式电子数，基态能量近似仍可能达到 QMA-hard。它说明连续变量并不会自动消除组合复杂性，也为量子化学算法的“最坏情形不可避免”提供了复杂性理论基准。
- **Lean 已形式化：** `lean/docs/275.md` 和 `lean/ComparatorChallenges/ContinuumCoulombHardness.lean`；覆盖二进制核电荷和单位核电荷两个硬度陈述。

### 3. 精确量子因式分解（条目 279）

- **论文 PDF：** [Exact quantum factoring](preprints/Exact-quantum-factoring-over-a-fixed-finite-gate-set-September-25-2026/main.pdf)

- **问题：** 能否用一个统一的量子算法，对任意整数 $N\ge 2$ 输出完整素因数分解，并把成功概率做到严格等于 1，而不只是让错误概率随规模变小。
- **结论：** 在固定的有限常数规模门集上，存在统一的多项式时间量子电路，能够对所有输入以概率 1 输出正确的完整素因数分解。
- **方法：** 算法先对模 $m$ 的单位 $a$ 做阶试验；相位寄存器不用任意精细旋转，而是用四相位 step state 和一段复指数的分段线性插值来产生可检验的相位信息。论文为每个候选阶构造 dyadic majorant，计算有界多项式片段的 exact power sums，并用两个校正分支把真正阶的概率质量调整为严格相等；返回检验只保留真阶的正倍数。因式分解本身递归地产生 $p-1$ 的素因数分解，使用改造后的确定性 primality test 和 occurrence tree 控制候选树规模；所有延迟检验与均匀猜测都设计成相同保留质量，先得到精确成功率 $1/4$，再用 sign reflection 和 exact amplitude amplification 将成功率提升到 $1$。整个过程只使用固定的 $H,T,T^\dagger,\mathrm{CNOT}$ 门，并显式验证门数、辅助比特和候选表均为多项式。
- **影响：** 结果把“统一算法”“固定有限门集”和“概率严格等于一”同时放进同一个可证明的量子电路模型，为 exact quantum computation 提供了一个具体而非渐近的范例。它不声称经典因式分解因此变得容易，也不代表当前硬件上实用；真正的影响在于澄清了 Shor 型相位估计并非获得零错误保证的唯一途径，并展示了如何用精确概率账本和幅度放大消除尾部错误。
- **Lean 已形式化：** `lean/docs/279.md` 和 `lean/ComparatorChallenges/ExactQuantumFactoring.lean`；形式化明确记录固定有限门集、统一性、多项式资源和概率一结论。

### 4. QAOA 与 SK 模型最优值（条目 281）

- **论文 PDF：** [QAOA and the SK ground-state energy](preprints/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026.pdf)；[Full support of the SK order parameter](preprints/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/main.pdf)

- **问题：** 量子近似优化算法（QAOA）能否在高斯零场 Sherrington–Kirkpatrick（SK）自旋玻璃模型中达到基态能量的渐近最优值，即 Parisi 值；极限次序是先让系统规模趋于无穷，再提高算法深度。
- **结论：** 存在有限深度且不依赖具体系统实例的确定角度，使 QAOA 能量在热力学极限中逼近 SK 模型的 Parisi 基态能量。
- **方法：** 证明先把 Parisi 极小子对应的标量扩散、终端鞅和曲率积分写成有限 Gaussian calculation；在大度正则树的根 Hilbert 空间中实现这些有限计算，并用有界奇函数产生 QAOA 所需的 cost/mixer 角度。为防止量子线路反馈，论文按 sender、receiver、helper 类型安排自旋，并用 sender--receiver--helper--sender 的交换子路径合成纵向场，再通过 cost echo、选择性旋转和大相干位移移除辅助场。固定深度 word 在高 girth 正则树上先逼近目标，再用树到 SK 的高斯恒等式把能量极限送到 Parisi 值；另给出正温路线作为交叉验证。
- **影响：** 这证明了在“先取热力学极限、再让深度趋于无穷”的精确次序下，QAOA 确实可以逼近 SK 的 Parisi ground-state energy，给长期存在的渐近最优性猜想提供了严格实例，并导出大度随机正则图 MaxCut 的 leading-order 结论。结果没有给出有限规模误差、深度的显式上界或角度的高效搜索程序，因此影响主要是理论可达性，而非立即的算法工程保证。
- **Lean 已形式化：** `lean/docs/281.md`；形式化覆盖 SK 变分值恒等式、有限高斯和逼近及零温 Parisi 极小子的支撑性质，但不单独断言 QAOA 电路能量收敛。

### 5. 预言机辅助的统一酉综合（条目 283）

- **论文 PDF：** [Polynomial-time unitary synthesis](preprints/Polynomial-Time-Unitary-Synthesis-from-a-Boolean-Oracle-October-5-2026/paper.pdf)

- **问题：** 能否选取一个布尔预言机，使统一的量子预言机电路对每个 $n$ 比特酉通道都能实现 diamond norm 误差至多 $1/2$ 的近似。
- **结论：** 在允许目标相关信息由预言机提供的模型中，固定门集可以实现多项式资源的常误差通用酉综合。
- **方法：** 对目标酉 $U$ 做递归降维，把它写成块矩阵 $\begin{bmatrix}A&B\\C&D\end{bmatrix}$；用随机对角符号和 Walsh 变换选择分支，使 $\lVert D\rVert\le3/4$，并通过反馈传递函数 $F=A+BZ(I-DZ)^{-1}C$ 保持酉性。截断几何级数构造近等距 encoder/decoder，phase averaging 消去不同次数项；再用频率向量 $(1,i,\ldots,i^L)$ 的 power sums 编码多重集合，配合相干擦除和 amplitude amplification 实现递归拼接。最后把受控任意单比特门编译到固定 $H,T,T^\dagger,\mathrm{CNOT}$ 集，逐层累积误差并用 isometry 估计转成对任意 reference system 都成立的 diamond norm $\le1/2$。
- **影响：** 结果给出 Aaronson--Kuperberg 型问题的常误差正面答案：每个目标酉都存在一个布尔预言机，使统一构造器的门数、量子比特数、查询次数和查询长度均为输入规模的多项式。它同时严格区分“查询宽度/真值表长度”和“预言机能否被经典高效生成”，因此是存在性与可实现性之间边界的清晰例子。
- **Lean 形式化状态：** 在 `overview.tex`、`CONTENTS.md` 和论文目录中有条目，但在本次检索的 `lean/docs/` 和 `lean/formalization.yaml` 中没有找到对应的已登记 Comparator 形式化。

### 6. 随机查询与量子查询的近四次分离（条目 284）

- **论文 PDF：** [Nearly quartic query separation](preprints/A-Nearly-Quartic-Separation-Between-Randomized-and-Quantum-Query-Complexity-October-5-2026/quartic-query-separation.pdf)

- **问题：** 对总布尔函数，随机化查询复杂度 $R(f)$ 与量子查询复杂度 $Q(f)$ 之间已有四次量级的通用关系；需要判断这个指数能否改进为三次或更低。
- **结论：** 存在一族总布尔函数，使 $R(f)$ 相对于 $Q(f)$ 的分离任意接近四次，因此任何指数严格小于 4 的统一幂律上界都不可能成立。
- **方法：** 构造函数 $F_{k,m}$：每个输入列含一个长 bit string 和 certificate cells，partial pointer/address 机制先定位候选位置，再要求该列全为一、地址有效，且 certificate 指向其他每一列中的零；设计保证最多一个 winner。量子算法用相干 workspace 做候选 tournament，在只有 winner 比较可靠的 promise 外区域仍保持有界误差，再用 amplitude amplification 在 $\sqrt m$ 规模短名单中搜索；经典下界则在每列植入一个隐藏零，随机擦除或填充一列，任何自适应算法都必须找到被改动的位置或相应 certificate，direct-product 论证累加这些猜测成本。论文同时证明一般上界 $R(f)=O((1+Q(f))^4)$，从而把上下界指数精确对齐到 $4$。
- **影响：** 这否定了总布尔函数上“经典查询复杂度至多是量子复杂度三次”的猜想，并证明四次指数是 sharp barrier，而不是证明技术造成的松弛。构造中的 winner comparison、短名单和 certificate 设计可复用于其他 query separation；目前的近四次结果仍带有对数因子，且下界族按固定 $k\ge2$ 给出。
- **Lean 形式化状态：** 本次检索未发现对应 `lean/docs/` 或 `formalization.yaml` 条目；目前应视为论文/目录结果。

## 二、量子信道、熵与纠缠

### 7. 无可蒸馏密钥的纠缠与 PPT-square 反例（条目 272）

- **论文 PDF：** [Entanglement with zero distillable secret key](preprints/Entanglement-with-zero-distillable-secret-key-in-local-dimension-ten-September-27-2026/paper.pdf)

- **问题：** 是否存在含有纠缠、但在指定局部测量仪器与双向公开通信协议下不能蒸馏出秘密密钥的量子态；以及两个 PPT 信道复合后是否必然成为纠缠破坏信道。
- **结论：** 在 $\mathbb C^{10}\otimes\mathbb C^{10}$ 中存在满足相应条件的纠缠态，并且 PPT-square 猜想有反例：PPT 信道的复合不必然是纠缠破坏的。
- **方法：** 先给出 $10\times10$ 局部维的显式整数矩阵，拼成态和两张 PPT map 的 Choi 矩阵；逐项检查正性、偏转置正性和 trace-preserving 归一化，并用 range 中不存在非零 product vector 的显式几何证书证明态确实纠缠、复合 Choi 仍非零纠缠。零密钥部分把任意允许的有限或可数轮 LOCC transcript、保留的 reference system 和 Eve 的 purification 一并纳入，利用 privacy test 与 product-vector range 条件给出与理想 bit 至少 $1/10$ 的距离下界。随后把两图 PPT 例子嵌入一个 $21\times21$ 的 trace-preserving PPT channel，直接验证其平方不是 entanglement-breaking。
- **影响：** 结果把“存在纠缠”与“能蒸馏出秘密密钥”严格分开：即使 Eve 保留 purification、通信轮数和维数都不预先有界，也可以有 $K_D=0$ 的纠缠态。它同时给出 unrestricted PPT-square 猜想和同一信道平方命题的低维显式反例，改变了对 bound entanglement、PPT 资源和量子密码转化能力的理解；论文没有声称维数 $10$ 或 $21$ 是最小的。
- **Lean 已形式化：** `lean/docs/272.md`；覆盖两个十维 PPT 映射的非纠缠破坏复合、相应 Choi 矩阵性质，以及 $21\times21$ 保迹 PPT 信道平方的反例。论文的零密钥协议本身不在选定形式化范围内。

### 8. 玻色系统的熵-光子数不等式（条目 273）

- **论文 PDF：** [Entropy photon-number inequality](preprints/The-entropy-photon-number-inequality-September-24-2026/paper.pdf)

- **问题：** 两个相互独立且能量有限的玻色系统输入透射率为 $\eta$ 的分束器后，输出的熵光子数是否至少为两路输入熵光子数的加权平均。
- **结论：** 对含 $n$ 个模式的状态 $\rho$，定义 $N(\rho)=g^{-1}(S(\rho)/n)$ 后，有
  $$N(\rho_C)\ge\eta N(\rho_A)+(1-\eta)N(\rho_B).$$
- **方法：** 论文先用 Gibbs variational principle、number cutoff 和能量紧性把无限维问题约化到有限能量状态，再对分束器加入一个小 thermal port，构造带相对熵和四阶 number penalty 的严格负最小值。四-weight interpolation、parallel-sum/Kubo--Ando 运算和 Stieltjes 表示给出可比较的 quadratic forms；在正则化最小点利用 entropy Hessian、metric estimate 和 stationarity cancellation 排除负方向，最后去掉 thermal port 与正则化参数。整个过程中只使用被动线性混合和熵的变分性质，因此输入各模式内部可以任意纠缠；广播信道部分再把同一不等式逐端口应用。
- **影响：** 这解决了有限能量、多模式且允许内部模式纠缠的 entropy photon-number inequality，而非只处理独立单模输入。由此可推出热衰减器的 constrained minimum-output entropy、纯损耗 bosonic broadcast channel 的容量区域以及相应的热态最优性，为无限维玻色通信提供统一的熵工具。
- **Lean 已形式化：** `lean/docs/273.md` 和 `lean/ComparatorChallenges/EntropyPhotonNumber.lean`；登记的形式化主结论是不等式本身，论文中的容量推论未全部纳入。

### 9. 广义振幅阻尼信道的经典容量（条目 276）

- **论文 PDF：** [Classical capacity of generalized amplitude damping](preprints/Classical-capacity-and-entropy-inequalities-for-generalized-amplitude-damping-September-24-2026/paper.pdf)

- **问题：** 需要完全确定量子比特广义振幅阻尼信道在任意阻尼强度和热占据参数下的无辅助经典容量，并判断多次使用时是否需要正则化。
- **结论：** 最优编码可由两个纯态组成的信号系综达到，相关 Holevo 容量、最小输出熵和正则化无辅助容量在张量积使用下可加；在该范围内，纠缠输入不会提高无辅助经典容量。
- **方法：** 证明的核心是对任意纯 $n$-qubit 输入建立逐站点熵下界：若第 $j$ 个局部激发概率为 $p_j$，则输出熵至少为 $\sum_j e(p_j)$，其中 $e(p)=g(\det\mathcal A(\ket\psi\bra\psi))$。单步证明把首个 qubit 写成两列 Kraus block，应用 rectangular thermal zero-block matrix inequality，再用 log-det 积分、joint convexity 和 coordinate-sign averaging；对 thermal extension 则混合两个具有相同 corner-mass product 的 zero-block factorization，并用熵凹性保持界。迭代得到最小输出熵可加；另一方面用对角熵和 subadditivity 控制平均输出熵，上下界共同把 Holevo 优化化成标量最大化，二态纯态对 $\phi_\pm=\sqrt{1-p}\ket0\pm\sqrt p\ket1$ 达到等号。相同的一步估计还能带任意有限维 partner，从而推出更强的加性。
- **影响：** 结果在所有阻尼强度和热占据参数下给出 generalized amplitude damping channel 的精确无辅助经典容量，并排除 block-entangled signal 的额外收益。与只证明 $\mathcal A^{\otimes n}$ 可加相比，任意有限维 partner 的版本还说明该信道在更广泛复合通信架构中没有隐藏的正则化增益；最小输出熵等价式也为后续信道比较和数值优化提供了可计算基准。
- **Lean 已形式化：** `lean/docs/276.md` 和 `lean/ComparatorChallenges/AmplitudeDamping.lean`；形式化覆盖同一信道的多次使用和标量最大值，但不包括与任意不同伙伴信道的全部扩展结论。

### 10. 有限维纠缠博弈的阈值并行重复（条目 277）

- **论文 PDF：** [Threshold parallel repetition](preprints/Threshold-parallel-repetition-for-finite-dimensional-entangled-games-September-25-2026/paper.pdf)

- **问题：** 若一个有限两方非局域博弈的纠缠值为 $v<1$，独立重复 $k$ 次后，允许任意有限维且跨轮次相关的联合纠缠策略时，赢得至少 $v+\delta$ 比例轮次的概率是否指数衰减。
- **结论：** 该超额获胜概率随重复次数指数下降；定理允许任意相关的问题分布，也不要求单次最优策略达到上确界。
- **方法：** 对重复策略选取测试坐标集 $C$，在条件事件“$C$ 中全部获胜”下用 resolvent purification 保持各答案概率，再按固定顺序暴露 Alice 的问题、随后暴露 Bob 的问题。谱分箱和相对熵把条件化造成的代价压成 $\tau=(\log(1/p)+|C|\log d)/m$，Song 的 conditioning estimate 控制未测试坐标的平均胜率；然后从二元胜负指标中 with replacement 抽样短测试集，把 conditioning bound 转移成阈值事件。对固定问题分布，按正支撑的连通分量选参考态并做 root rounding，可把通用 $\delta^5$ 指数改善为依赖分布常数的 $\delta^3$。
- **影响：** 结果首次在任意有限两方博弈、任意相关且可含零项的问题分布、任意有限维跨轮次纠缠策略下，直接控制“赢得至少某个比例”的阈值事件，而不只控制全胜事件。这为非局域博弈、device-independent protocol 和量子密码中的误差放大提供通用工具；论文给出 universal fifth-power rate，固定分布还有 cubic rate，Lean 登记的 $\delta^{13}$ 版本则是更保守的形式化陈述。
- **Lean 已形式化：** `lean/docs/277.md` 和 `lean/ComparatorChallenges/EntangledGames.lean`；形式化给出通用的 $δ^{13}$ 级速率，论文中针对固定问题分布的更强立方速率不在选定陈述中。

## 三、量子态、测量与量子多体系统

### 11. 二维有隙面积律与 PEPS 近似（条目 265）

- **论文 PDF：** [Two-dimensional area law](preprints/A-two-dimensional-area-law-from-a-global-spectral-gap-September-24-2026/paper.pdf)；[Polynomial PEPS approximation](preprints/Polynomial-PEPS-approximation-of-gapped-square-grid-ground-states-September-24-2026/paper.pdf)

- **问题：** 二维有限范围局域 Hamiltonian 的唯一有隙基态是否必然满足纠缠熵面积律，以及能否用多项式键维的投影纠缠对态（PEPS）近似表示。
- **结论：** 在统一谱隙和受控局域相互作用的假设下，基态纠缠熵满足面积律，并存在全局向量误差至多 $L^{-1}$ 的多项式键维 PEPS 近似。
- **方法：** 面积律证明先用全局谱隙控制嵌套矩形上的负对数边缘谱，再用正的、分别湮灭基态且具有快速空间尾的 quasilocal operators 构造 collar。对多个 ground-state copies 做 symmetric-tensor-power filtering，在分区移动时比较 filtered vector 的对数范数；scanner 以随机日程穿过 collar，使被切开的相互作用概率很小，同时把信息增益与激发能量放在同一个插值估计中。比较范数后得到远离边界的 conditional mutual information 衰减，再用典型谱子空间、局部极分解和几何排序放大到任意逆多项式误差，最后用两族区域的 entropy chain rule 取消内部熵，得到边界线性项。PEPS companion 进一步把这些 collar/patch 估计变成 dyadic party 分配：patch 投影给出多项式大小的内部基，compression 将无限 Schmidt 资源替换成多项式 product-operator sum，routing 后回到原方格网。
- **影响：** 结果在只假设整个有限系统有唯一全局谱隙的条件下证明二维面积律，不要求子区域有隙、frustration-free 或平移不变；这扩大了面积律可以适用的模型范围。PEPS 结论给出 bond dimension $CL^c$、全局向量误差 $L^{-1}$ 的存在性近似，说明二维有隙基态具有多项式张量网络描述；论文仍不声称这些 tensor 能被高效找出或收缩，因此影响是表示复杂度保证，而非现成算法。
- **Lean 形式化状态：** `overview.tex` 和 `CONTENTS.md` 有完整论文条目，但本次检索未发现相应 `lean/docs/265.md` 或登记的 Comparator 文件；不能把论文结果当作已完成 Lean 形式化。

### 12. 六维互无偏基与复 Hadamard 矩阵（条目 266）

- **论文 PDF：** [Maximum number of mutually unbiased bases](preprints/The-maximum-number-of-mutually-unbiased-bases-in-dimension-six-September-24-2026/The-maximum-number-of-mutually-unbiased-bases-in-dimension-six-September-24-2026.pdf)；[Exact Fourier certificates](preprints/Exact-Fourier-certificates-for-complex-Hadamard-matrices-of-order-six-September-24-2026/Exact-Fourier-certificates-for-complex-Hadamard-matrices-of-order-six-September-24-2026.pdf)

- **问题：** 六维复 Hilbert 空间中最多能有多少个互无偏正交基（MUB），以及六阶复 Hadamard 矩阵具有什么 Fourier 消去性质。
- **结论：** 论文目录报告维数六的最大 MUB 数量为 $N(6)=3$；相关认证计算排除四组基，Lean 则形式化了一个五基上界模型和 Fourier 辅助引理。
- **方法：** MUB 论文先把第一组基标准化，把第二组基写成任意六阶 complex Hadamard matrix，并用 rephasing 固定行列自由度。Stage A 将矩阵按 $2+4$ 分块，用固定 kernel 把未知 $4\times4$ 块压到 $2\times2$，再对 $U(2)$ 做有限 seed-ball 覆盖和 Taylor 余项界；Stage B 用 tangent directions 与 residual identities 反复收缩球。Stage C 对 unbiased vectors 做 phase-bin 覆盖，生成正交/互无偏图，最后在带安全裕量的闭区间单元上排除两组不相交的六团。并行的 Fourier certificate 只用整数/有理数：把 character-sum 乘积按重复行列指标分组，加入 absolute-square 辅助项，用 Newton identities 将非零情形逼到 Tao cubic class，再用有限平均排除完整 MUB 家族；整个浮点部分带 compiler/binary64 合约和 fresh execution fallback。
- **影响：** 认证计算给出六维中最多三组 MUB 的结构边界，Fourier 证书还独立给出七组 MUB 的上界五，并证明六阶 Hadamard 矩阵在所有排列处的 character sum 消失。对量子态层析、有限维测量设计和基于 MUB 的 QKD，这意味着可用的完美互无偏测量数受到严格限制；但其可信度依赖可复核的算术/编译器执行契约，Lean 当前形式化的是较弱的五基模型和辅助 Fourier 引理。
- **Lean 已形式化：** `lean/docs/266.md`。必须保留范围差异：当前登记的 Lean 结果是模型中的五基上界和 Fourier 辅助引理，不是论文声称的“四基完全排除”或完整 $N(6)=3$。

### 13. 稀薄硬球 Bose 气体的凝聚（条目 267）

- **论文 PDF：** [Positive-temperature condensation](preprints/Bose-Einstein-condensation-at-positive-temperature-in-the-dilute-hard-sphere-gas-October-5-2026/positive-temperature-hard-spheres.pdf)；[Momentum distribution and depletion](preprints/Quantum-Depletion-and-Momentum-Distribution-in-the-Dilute-Hard-Sphere-Bose-Gas-October-5-2026/Quantum-Depletion-in-the-Dilute-Hard-Sphere-Bose-Gas.pdf)；[Fixed bounded repulsive potentials](preprints/Quantum-Depletion-for-Fixed-Bounded-Repulsive-Potentials-October-5-2026/fixed-repulsion-quantum-depletion.pdf)；[Density-uniform condensate bound](preprints/A-density-uniform-condensate-bound-for-dilute-Bose-gases-September-27-2026/paper.pdf)；[Ground-state condensation](preprints/Ground-state-condensation-in-the-dilute-hard-sphere-gas-September-24-2026/paper.pdf)

- **问题：** 三维稀薄硬球 Bose 气体在热力学极限下是否发生 Bose–Einstein 凝聚，以及零温凝聚态的量子耗尽是否服从 Bogoliubov 渐近律。
- **结论：** 在稀薄参数 $\rho a^3$ 受控时，系统具有零动量轨道占据的凝聚下界；零温耗尽的首项按 $\frac{8}{3\sqrt{\pi}}\sqrt{\rho a^3}$ 标度。
- **方法：** 正温论文在固定密度的盒子中先做热力学极限，再把硬球排斥写成散射长度 $a$ 控制的局部能量代价；通过 localization、slab decomposition 和 defect-region 估计，把高动量和稀有高密度区的贡献隔离，证明零动量轨道的占据比例有正的 uniform 下界。零温论文使用 Dyson/Jastrow 型 trial state、IMS localization、canonical particle-number 分解和动量空间的长短路径估计，先求总能量和 kinetic-energy 误差，再识别非零动量占据；在 $\rho a^3\to0$ 时提取 $\frac{8}{3\sqrt\pi}\sqrt{\rho a^3}$ 的 depletion 首项。配套结果把硬球替换为 fixed bounded repulsive potentials，并给出对密度更均匀的 condensate bound。
- **影响：** 这些结果把正温 BEC、零温凝聚和量子耗尽放进同一稀薄极限框架：宏观零动量占据由散射长度控制，非零动量尾部则出现 Bogoliubov 预言的首项。对实验和数值而言，这提供了可比较的 condensate fraction、momentum distribution 与 interaction strength 基准；对理论而言，density-uniform 和 bounded-potential 版本扩大了结果从理想硬球模型到一般短程排斥的适用范围。Lean 目前仍只覆盖基态凝聚下界。
- **Lean 已形式化：** `lean/docs/267.md` 和 `lean/ComparatorChallenges/HardSphere.lean`；已形式化的是稀薄硬球气体的基态凝聚下界，正温凝聚和完整 Bogoliubov 动量分布不在选定陈述内。

### 14. 自旋一 Heisenberg 链的 Haldane gap（条目 268）

- **论文 PDF：** [Periodic spin-one Haldane gap](preprints/The-periodic-spin-one-Haldane-gap-September-24-2026/paper.pdf)；[Boundary-field gap](preprints/A-boundary-field-gap-for-the-spin-one-Heisenberg-chain-September-24-2026/paper.pdf)

- **问题：** 纯反铁磁自旋一 Heisenberg 链在偶数周期环上是否保持统一正谱隙；带端点场的奇数开放链是否也具有 uniform gap 和非平凡拓扑指标。
- **结论：** 有限尺寸谱隙下界可推广到热力学极限；带端点场的开放链具有统一谱隙，边界态拓扑指标为 $-1$。
- **方法：** 周期链部分把自旋一 Heisenberg Hamiltonian 的有限体积谱问题转化为可复核的 transfer/bootstrap 估计：先处理小尺寸基准，再控制 odd/even 规模、局部激发和周期拼接，得到与系统长度无关的正 gap，并把该下界传到热力学极限。开放链部分在端点加入特定 boundary field，分别构造 bulk transfer、边界 trial state 和有限温度稳定性估计；再通过局部化/拓扑 sector 的连续延拓计算边界指标，证明奇数链保留非平凡边缘结构且指标为 $-1$。
- **影响：** 结果把 Haldane gap 从数值和物理猜想提升为周期链与边界链的 uniform spectral statement，并同时说明 bulk gap 与 boundary topological response 可以共存。它为一维量子物态的 SPT 分类提供了严格样本：体内激发保持代价，端点却携带可检测的自由度；这也为有限链数值结果外推到热力学极限提供了可核对的谱隙基准。
- **Lean 形式化状态：** 目录中有论文和完整结果说明，但没有找到对应的 `lean/docs/268.md`；目前按论文材料记录。

### 15. Laughlin 态的统一谱隙（条目 269）

- **论文 PDF：** [Uniform stability of the spherical Laughlin gap](preprints/Uniform-Stability-of-the-Spherical-Laughlin-Gap-October-5-2026/uniform-stability-spherical-laughlin-gap.pdf)；[Fock-space inequality](preprints/A-Fock-space-inequality-and-the-Laughlin-spectral-gap-September-24-2026/A-Fock-space-inequality-and-the-Laughlin-spectral-gap-September-24-2026.pdf)

- **问题：** 填充因子 $1/3$ 的球面费米 Laughlin $V_1$ Hamiltonian 是否随粒子数增加保持统一谱隙，以及弱有界标量无序是否破坏唯一基态。
- **结论：** 未扰动模型满足统一谱隙不等式；在适当小的扰动范围内，大系统仍保持唯一基态和统一扰动阈值。
- **方法：** Fock-space 论文把球面 $V_1$ interaction 写成 pair-annihilation operators 的平方和，建立全 Fock 空间、粒子数无关的 coercive inequality $H_Q^2\ge\gamma H_Q$，再把它限制到固定磁通 $q=3(N-1)$ 的 $N$-fermion sector，识别唯一零空间为 Laughlin polynomial。uniform-stability 论文在最低 Landau level 中加入有界实标量一体势，先用上述 gap 和 ground-space pinning 控制投影扰动，再以 resolvent/contour 和有限尺寸 Schrieffer--Wolff 型比较保持唯一基态与 uniform gap；常数只依赖扰动范数和模型参数。
- **影响：** 结果说明 $1/3$ 填充的 Laughlin 相不仅在理想 $V_1$ Hamiltonian 中有 particle-number independent gap，而且对弱有界 scalar disorder 仍保持唯一基态和正的稳定阈值。这为分数量子 Hall 拓扑相的谱稳定性、有限尺寸数值 extrapolation 和准粒子激发分离提供严格基准；Lean 目前主要覆盖未扰动的 Fock/sphere gap inequality。
- **Lean 已形式化：** `lean/docs/269.md`，并列出 `Laughlin.lean`、`LaughlinGap.lean`、`LaughlinFock.lean`、`LaughlinPlanar.lean`。选定形式化主要覆盖未扰动 Fock 空间/球面谱隙不等式，扰动后唯一基态的完整论证不全部在其中。

### 16. BFSS 矩阵量子力学的阈值束缚态（条目 270）

- **论文 PDF：** [Unique threshold bound state](preprints/The-unique-threshold-bound-state-of-the-SU-N-BFSS-model-September-24-2026/paper.pdf)；[Positive eigenvalues for SU(2)](preprints/Positive-eigenvalues-of-the-relative-SU-2-BFSS-Hamiltonian-October-5-2026/positive-eigenvalues-relative-su2-bfss.pdf)

- **问题：** 去除质心后的未变形 $\mathrm{SU}(N)$ BFSS 模型对每个有限 $N\ge2$ 是否恰有一个可归一化零能态；$N=2$ 是否还存在无界正能离散态。
- **结论：** 结果解决了 BFSS 模型的阈值束缚态计数问题，并单独厘清了 $N=2$ 情形的正能谱，避免把正能束缚态的排除结论错误地推广到该情形。
- **方法：** 阈值束缚态论文先在规范约化后的配置空间上闭包 supercharge quadratic form，利用代数恒等式把零能问题转为超荷共同核的 cohomological/index 计数。massive-index、fast-analysis 和 lift sections 逐步控制非紧矩阵方向的渐近，排除额外可归一化零模，再用 induction/counting 处理一般 $N$ 的唯一性。对相对 $\mathrm{SU}(2)$，固定一个非零 commuting direction $u$，把其余 16 个 transverse 坐标视为频率约 $|u|$ 的振子；Spin(9) sector 和高权分解排除低振子层，得到正能离散本征值并证明其向无穷增长。
- **影响：** 结果一方面给出每个有限 $N\ge2$ 恰有一个 threshold bound state 的计数，另一方面说明 $N=2$ 的相对模型仍有无界的正能离散谱，从而修正把“没有正能束缚态”的早期 BFSS 直觉直接推广到所有 sector 的做法。它为矩阵模型的非微扰态计数、M 理论多体解释和超对称量子力学的谱分析提供了更精细的基准。
- **Lean 形式化状态：** 有论文和目录条目，但本次检索未找到对应 `lean/docs/270.md` 或已登记 Comparator。

### 17. 量子 Heisenberg 铁磁体的自发磁化与 Bloch 定律（条目 271）

- **论文 PDF：** [Bloch's law](preprints/Blochs-Law-for-Finite-Range-Heisenberg-Ferromagnets-in-Three-Dimensions-October-5-2026/bloch-law-heisenberg.pdf)；[First lattice correction](preprints/The-first-lattice-correction-to-Blochs-law-October-5-2026/first-lattice-correction-bloch-law.pdf)；[Spherical magnetization law](preprints/The-spherical-magnetization-law-for-the-three-dimensional-quantum-Heisenberg-ferromagnet-October-5-2026/spherical-magnetization.pdf)；[Spontaneous magnetization](preprints/Spontaneous-magnetization-in-the-quantum-Heisenberg-ferromagnet-September-24-2026/paper.pdf)

- **问题：** 三维量子 Heisenberg 铁磁体在低正温下是否存在自发磁化，以及磁化亏损是否服从精确的 $T^{3/2}$ Bloch 定律和首个晶格修正。
- **结论：** 系统在低温下保持自发磁化，磁化具有由一磁振子色散决定的 Bloch 低温渐近式，并可得到各向异性有限程耦合下的精确系数。
- **方法：** 证明从有限体积 dynamics 出发，利用 finite-range interaction 的 Lieb--Robinson 型控制和 sparse pin/loop geometry 构造无限体积极限；exposure、transport 与 leakage 估计确保稀疏固定点不会改变热力学量。随后在平移不变 KMS states 中分析一-magnon dispersion，先得到 pressure 的低温展开，再用零场处右导数把压力差转换为磁化；loop/capacity correction 计算首个晶格项。spherical magnetization 版本不把不同自旋分量当作可交换变量，而是在总自旋 sector 中联合控制其统计，得到球面对称的低温律。
- **影响：** 结果严格确认三维有限程量子 Heisenberg 铁磁体的低温自发磁化，并给出各向异性耦合下 Bloch $T^{3/2}$ 项及首个 lattice correction 的解析系数。球面版本还说明非对易分量的联合磁化仍可得到精确渐近，从而把经典 spin-wave 直觉提升为 KMS/热力学压力框架中的定理；Lean 已覆盖自发磁化和 KMS 平衡态的核心版本。
- **Lean 已形式化：** `lean/docs/271.md` 和 `lean/ComparatorChallenges/Heisenberg.lean`；形式化覆盖低温自发磁化和 KMS 平衡态，Bloch 精确系数等论文扩展不是该 Comparator 的主结论。

## 四、量子场论、共形结构与相关数学

### 18. 量子几何 Langlands（条目 069）

- **论文 PDF：** [Global quantum geometric Langlands](preprints/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026/quantum-langlands.pdf)

- **问题：** 在不可约有理移位层级 $c\in\mathbb C\setminus\mathbb Q$ 下，能否建立连接群与 Langlands 对偶群之间的非分歧 de Rham 量子几何 Langlands 等价。
- **结论：** 结果构造了双方扭曲 $D$-模派生范畴之间、与 Langlands 对偶相容的范畴等价。
- **方法：** 证明先在 irrational level 下处理 twisted $D$-module categories 的 foundations、pseudo-identity 和 Whittaker pairing；用局部 Kac--Moody/$W$-algebra duality 比较单点及多标记点的 localization functors，再通过 Ran 空间上的 moving-point、collision 和 factorization 兼容性把局部比较提升到曲线全局。核心 period comparison 给出 $J_sR_s\simeq\mathrm{Id}$；有限 pole approximations、Kummer deformation 和 weight bound 证明该恒等式在所有非根单位的参数上延拓。最后用两侧的 Plancherel identities 将 localization quotient 互相 factor，得到逆函子，并追踪 global forms、所有 connected components、central characters 和 central torsor actions。
- **影响：** 结果在任意非有理（包括非实）层级 $c$ 上建立完整的 unramified quantum geometric Langlands equivalence，并明确 dual level 为 $-1/(rc)$，同时不丢失全局形式和连通分支。这为量子 Langlands、几何表示论和规范理论中的 electric--magnetic duality 提供全局范畴模型；“量子”在此是扭曲 $D$-模和层级参数的数学含义，与量子计算或量子信息中的算法问题不同。
- **Lean 形式化状态：** 本次检索没有找到对应 `lean/docs/069.md` 或已登记 Comparator。

### 19. 强有理酉顶点算子代数与共形网（条目 280）

- **论文 PDF：** [Strongly rational unitary VOAs and conformal nets](preprints/Strongly-rational-unitary-vertex-operator-algebras-and-conformal-nets-September-25-2026/paper.pdf)

- **问题：** 强有理且酉的顶点算子代数（VOA）能否构造出完全有理的共形网，以及 VOA 模块与共形网有限指标 sector 是否具有一致的酉 braided tensor 结构。
- **结论：** 论文建立了从 VOA 的能量界和强局部性到局部共形网构造的桥梁，并把模块表示论与共形网 sector 理论联系起来；Lean 当前覆盖其中的前置构造结果。
- **方法：** 证明先从 unitary VOA 的 invariant form 和 grading 得到 smeared field 的 energy bounds，再用 annulus estimates 控制不同区间的解析延拓；强局部性保证同一圆周上 disjoint intervals 的场对易。对闭包后的局部代数做 vacuum representation 与局部化，得到 conformal net；随后在 module 上构造相容的 Hilbert 完备化，检查 intertwiner 的融合乘积、正性和有限 index。comparison/exhaustion 部分把 VOA module 的 sector functor 与 net 的 representation functor 互相恢复，避免把仅有的形式级 bijection 误当成范畴等价。
- **影响：** 结果把强有理酉 VOA 的代数数据转成局部共形网的 operator-algebraic 数据，并为模块、融合和 sector 的对应提供可追踪的构造路径。这使二维 CFT 的分类可以在“顶点代数”和“局部网”两种语言之间迁移，也为局部扩张、有限指数和量子场论模型的比较提供共同框架；Lean 目前只覆盖能量界、强局部性和基本 net 构造。
- **Lean 已形式化：** `lean/docs/280.md` 和 `lean/ComparatorChallenges/VertexAlgebraNet.lean`；Lean 选定结果只覆盖能量界、强局部性和不可约共形网的构造，不包括完整有理性、所有模块酉化和 braided tensor 等全部论文结论。

### 20. 四维 QFT 中从尺度到局部共形（条目 282）

- **论文 PDF：** [Scale and conformal symmetry](preprints/Scale-and-conformal-symmetry-in-four-dimensional-operational-quantum-field-theory-September-26-2026/main.pdf)

- **问题：** 在有界局部网、场重构、正能量和离散缩放谱等假设下，四维量子场论中的尺度对称是否必然增强为局部共形对称。
- **结论：** 对满足这些假设的一类理论，尺度对称可以推出 local conformal symmetry；结论是局部的，不声称整个有界网上存在全局共形作用。
- **方法：** 论文先在有界局部网内定义 dilatation current，并把离散、下有界且有限重数的 scaling spectrum 用 dispersion relations 转成有限的 scaling support。null-current 部分证明尺度流的 trace defect 是一个局部零范数/可消去的 current；随后用 charges and cones 将其改写为保持平移、Lorentz 荷不变的 improvement。short-products 和 reconstruction 章节在同一 causally commuting net 中恢复原场、伴随场及其尖锐局部化乘积，最后逐项验证 special-conformal currents 的 local Ward identities。
- **影响：** 结果在明确的谱离散性、有限 scaling support、正能量和局部网可实现性假设下，把 scale symmetry 推进为 local conformal symmetry，并得到 symmetric, conserved, traceless stress tensor。它缩小了四维 QFT 中 scale-but-not-conformal 的可能范围，同时刻意把局部 Ward 恒等式与整个 bounded net 上的 global conformal action 分开，避免把局部结论过度外推。
- **Lean 形式化状态：** 本次检索未找到相应 `lean/docs/282.md` 或 Comparator；当前是论文/目录结果。
