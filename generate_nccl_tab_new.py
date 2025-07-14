# python3 -m venv ~/venvs/nccl-env
# source ~/venvs/nccl-env/bin/activate
# pip install pandas

# source ~/deepseek-env/bin/activate
import pandas as pd

# 读取 tab 分隔的表格
# df = pd.read_csv("input.tsv", sep='\t', header=None)
# df = pd.read_csv("input.tsv", delim_whitespace=True, header=None)
df = pd.read_csv("input.tsv", sep=r'\s+', header=None)
expected_cols = 13
if df.shape[1] < expected_cols:
    raise ValueError(f"输入文件列数不足，实际只有 {df.shape[1]} 列，预期至少 {expected_cols} 列。")

xw_test = True
# xw_test = False
if xw_test:
  df.columns = ["size_byte", "count", "type", "redop", "root", "time_us_xw", "algbw_GBPS_xw", "busbw_xw", "wrong", "in_place_time", "in_place_algbw", "in_place_busbw", "in_place_wrong"]
  df_filtered = df[["size_byte", "time_us_xw", "algbw_GBPS_xw", "busbw_xw"]]
else:
  df.columns = ["size_byte", "count", "type", "redop", "root", "time_us_cx6", "algbw_GBPS_cx6", "busbw_cx6", "wrong", "in_place_time", "in_place_algbw", "in_place_busbw", "in_place_wrong"]
  df_filtered = df[["size_byte", "time_us_cx6", "algbw_GBPS_cx6", "busbw_cx6"]]




# print(df)
print(df_filtered.to_string(index=False))
# print(df_filtered.to_csv(index=False))
# print(df_filtered.to_excel(index=False))
# print(df_filtered.to_csv(sep='\t', index=False))

# # 示例：选择指定列
# df_selected = df[['Name', 'Age']]

# # 示例：筛选条件，比如只保留 Age > 25 的行
# df_filtered = df_selected[df_selected['Age'] > 25]

# # 打印结果
# print(df_filtered)

# # 保存为新的 tab 分隔文件
# df_filtered.to_csv("output.tsv", sep='\t', index=False)
