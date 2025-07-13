import os
from transformers import (
    AutoTokenizer,
    AutoModelForCausalLM,
    Trainer,
    TrainingArguments,
    DataCollatorForLanguageModeling,
)
from datasets import load_dataset
from datasets import load_from_disk, Dataset, DatasetDict


# 🧠 Load DeepSeek model and tokenizer
# model_name = "deepseek-ai/deepseek-llm-7b-base"
model_name = "/root/big/deepseek-llm-7b-base"
tokenizer = AutoTokenizer.from_pretrained(model_name, local_files_only=True, cache_dir="/root/big/deepseek-llm-7b-base/model_cache")
model = AutoModelForCausalLM.from_pretrained(model_name, local_files_only=True)

# 📚 Prepare dataset (use wikitext for example)
# dataset = load_dataset("wikitext", "wikitext-2-raw-v1")
# dataset = load_from_disk("/root/big/deepseek-llm-7b-base/dataset/wikitext-2-v1", "/root/big/deepseek-llm-7b-base/dataset/wikitext-2-raw-v1")
# dataset = Dataset.from_dict({
#     "text": [
#         "Hello, this is a sample sentence.",
#         "DeepSeek is a large language model.",
#         "Distributed training is powerful!"
#     ]
# })

# dataset_dict = DatasetDict({
#     "train": Dataset.from_dict({
#         "text": [
#             "Hello, this is a sample sentence.",
#             "DeepSeek is a large language model.",
#             "Distributed training is powerful!"
#         ]
#     }),
#     "validation": Dataset.from_dict({
#         "text": [
#             "Validation example 1.",
#             "Validation example 2."
#         ]
#     })
# })
# train_dataset = dataset_dict["train"]

dataset = load_dataset("parquet", data_files={
    "train": "/root/big/deepseek-llm-7b-base/dataset/wikitext-2-raw-v1/train-00000-of-00001.parquet",
    "validation": "/root/big/deepseek-llm-7b-base/dataset/wikitext-2-raw-v1/validation-00000-of-00001.parquet",
    "test": "/root/big/deepseek-llm-7b-base/dataset/wikitext-2-raw-v1/test-00000-of-00001.parquet",
})



tokenized = dataset.map(
    lambda x: tokenizer(x["text"], return_special_tokens_mask=True),
    batched=True,
    remove_columns=["text"],
)

# 🧩 Data collator
collator = DataCollatorForLanguageModeling(tokenizer=tokenizer, mlm=False)

# ⚙️ Training args (DeepSpeed JSON is external)
training_args = TrainingArguments(
    output_dir="/root/big/llm/ds-output",
    per_device_train_batch_size=1,
    gradient_accumulation_steps=4,
    num_train_epochs=1,
    save_steps=1000,
    save_total_limit=2,
    logging_steps=50,
    fp16=True,
    deepspeed="deepspeed_config.json",
    report_to="none",
    overwrite_output_dir=True,
)

# 🚀 HuggingFace Trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized["train"],
    eval_dataset=tokenized["validation"],
    tokenizer=tokenizer,
    data_collator=collator,
)

# 🔁 Train!
trainer.train()
