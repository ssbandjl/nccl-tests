# pip install matplotlib
import pandas as pd
import matplotlib.pyplot as plt

# 读取你的数据
df = pd.read_csv("input.tsv", sep='\t')

# 将 size_byte 转换为 MB（可选）
df["size_MB"] = df["size_byte"] / (1024 * 1024)

# 开始绘图
plt.figure(figsize=(10, 6))
plt.plot(df["size_MB"], df["algbw_GBPS_xw"], label="algbw_GBPS_xw", marker='o')
plt.plot(df["size_MB"], df["algbw_GBPS_cx6"], label="algbw_GBPS_cx6", marker='s')

# 图形美化
plt.xscale('log', base=2)
plt.xlabel("Message Size (MB, log scale)")
plt.ylabel("Bandwidth (GB/s)")
plt.title("Bandwidth vs Message Size")
plt.grid(True, which="both", ls="--", lw=0.5)
plt.legend()
plt.tight_layout()

# 显示图
plt.show()
