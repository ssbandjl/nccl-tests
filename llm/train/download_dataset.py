from datasets import load_dataset

# 下载 wikitext-2-raw-v1（默认包括 train/validation/test）
# dataset = load_dataset("wikitext-2-v1", "wikitext-2-raw-v1")
dataset = load_dataset("wikitext", "wikitext-2-raw-v1")

# 保存到磁盘，例如：
dataset.save_to_disk("/root/big/deepseek-llm-7b-base/wikitext-2-raw-v1")
