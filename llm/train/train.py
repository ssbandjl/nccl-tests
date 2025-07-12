import os
from transformers import (
    AutoTokenizer,
    AutoModelForCausalLM,
    Trainer,
    TrainingArguments,
    DataCollatorForLanguageModeling,
)
from datasets import load_dataset

# 🧠 Load DeepSeek model and tokenizer
model_name = "deepseek-ai/deepseek-llm-7b-base"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

# 📚 Prepare dataset (use wikitext for example)
dataset = load_dataset("wikitext", "wikitext-2-raw-v1")
tokenized = dataset.map(
    lambda x: tokenizer(x["text"], return_special_tokens_mask=True),
    batched=True,
    remove_columns=["text"],
)

# 🧩 Data collator
collator = DataCollatorForLanguageModeling(tokenizer=tokenizer, mlm=False)

# ⚙️ Training args (DeepSpeed JSON is external)
training_args = TrainingArguments(
    output_dir="./ds-output",
    per_device_train_batch_size=1,
    gradient_accumulation_steps=2,
    num_train_epochs=1,
    save_steps=500,
    save_total_limit=2,
    logging_steps=10,
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
