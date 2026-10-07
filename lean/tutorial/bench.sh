#!/usr/bin/env bash
# 复现 README 第 5 课的所有计时数据。
# 用法：cd /home/ghost/Code/math/lean && bash tutorial/bench.sh
set -u

cd "$(dirname "$0")/.." || exit 1
[ -f lakefile.lean ] || { echo "请在 lean/ 目录下运行"; exit 1; }

echo "取出库搜索路径（避免每次 lake env 的几秒启动开销）..."
export LEAN_PATH
LEAN_PATH=$(lake env printenv LEAN_PATH 2>/dev/null)
echo "LEAN_PATH 条目数: $(printf '%s' "$LEAN_PATH" | tr ':' '\n' | wc -l)"
echo

# 取 3 次里最快的一次，减少噪声
bench() {
  local f="$1" best="" s e t i
  for i in 1 2 3; do
    s=$(date +%s.%N)
    lean "$f" >/dev/null 2>&1
    e=$(date +%s.%N)
    t=$(echo "$e - $s" | bc)
    if [ -z "$best" ] || [ "$(echo "$t < $best" | bc)" -eq 1 ]; then best=$t; fi
  done
  printf "  %-52s %6.2fs\n" "$f" "$best"
}

# 轮询 /proc 拿峰值内存
peak() {
  local f="$1" max=0 v pid
  lean "$f" >/dev/null 2>&1 &
  pid=$!
  while kill -0 "$pid" 2>/dev/null; do
    v=$(awk '/VmHWM/{print $2}' "/proc/$pid/status" 2>/dev/null)
    if [ -n "${v:-}" ] && [ "$v" -gt "$max" ]; then max=$v; fi
    sleep 0.05
  done
  wait "$pid" 2>/dev/null
  printf "  %-52s %5d MB\n" "$f" $((max / 1024))
}

echo "### 只用核心库（无 import）"
bench tutorial/01_terms_and_types.lean
bench tutorial/02_propositions_as_types.lean
bench tutorial/03_inductive_and_classes.lean
echo
echo "### 只写一行 import Mathlib，没有任何内容"
printf 'import Mathlib\n' > tutorial/_bench_empty.lean
bench tutorial/_bench_empty.lean
echo
echo "### import Mathlib + 真实内容"
bench tutorial/04_reading_repo_style.lean
bench tutorial/05_exercise.lean
echo
echo "### 本仓库真实文件"
bench ComparatorChallenges/KaplanskyDirectFiniteness.lean
bench OAI/Analysis/BiholderTransport/Main.lean
echo
echo "### 峰值内存"
peak tutorial/01_terms_and_types.lean
peak tutorial/_bench_empty.lean
rm -f tutorial/_bench_empty.lean
echo
echo "### 规模统计"
echo "  Mathlib 源码:      $(find .lake/packages/mathlib/Mathlib -name '*.lean' 2>/dev/null | wc -l) 个 .lean"
echo "  Mathlib olean:     $(find .lake/packages/mathlib/.lake/build/lib/lean -name '*.olean' 2>/dev/null | wc -l) 个, $(du -sh .lake/packages/mathlib/.lake/build/lib/lean 2>/dev/null | cut -f1)"
echo "  OAI/ 文件:         $(find OAI -name '*.lean' 2>/dev/null | wc -l) 个 .lean"
echo "  OAI.lean 的 import: $(grep -c '^import' OAI.lean) 行"
echo "  .lake 总体积:      $(du -sh .lake 2>/dev/null | cut -f1)"
