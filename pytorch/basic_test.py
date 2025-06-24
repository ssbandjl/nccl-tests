import torch

print("torch_version: ", torch.__version__)
print("cuda_available: ", torch.cuda.is_available())
print("cuda_nccl_version: ", torch.cuda.nccl.version())  # NCCL >= 2.8 should be available
