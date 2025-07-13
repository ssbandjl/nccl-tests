cd ~
rm -rf deepseek-env
python3 -m venv deepseek-env
source ~/deepseek-env/bin/activate
pip install --upgrade pip

pip install torch torchvision torchaudio
pip install -U transformers datasets accelerate peft sentencepiece
pip install deepspeed
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
# pip install ninja
# DS_BUILD_FUSED_ADAM=1 DS_BUILD_CPU_ADAM=1 pip install deepspeed

deactivate

# config nfs for share ds file
# nfs client:
mount s114:/root/big/deepseek-llm-7b-base /root/big/deepseek-llm-7b-base

NCCL_DEBUG=INFO NCCL_IB_DISABLE=0 NCCL_NET_GDR_LEVEL=2 NCCL_SOCKET_IFNAME=eth0 \
torchrun --nproc_per_node=1 --nnodes=2 --node_rank=<0 or 1> --master_addr=<ip> --master_port=23456 \
    ./your_train_script.py


torchrun \
  --nproc_per_node=1 \
  --nnodes=2 \
  --node_rank=<0 or 1> \
  --master_addr=<node0-ip> \
  --master_port=23456 \
  train.py \
  --model_name_or_path deepseek-ai/deepseek-llm-7b-base \
  --deepspeed deepspeed_config.json \
  --per_device_train_batch_size 1 \
  --gradient_accumulation_steps 2 \
  --output_dir ./ds-output \
  --fp16


