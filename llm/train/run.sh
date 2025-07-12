python3 -m venv deepseek-env
source ~/deepseek-env/bin/activate
deactivate

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


