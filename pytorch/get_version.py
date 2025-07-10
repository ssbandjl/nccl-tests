# try.py

import torch

print("torch version",torch.__version__)
print("cuda_available:", torch.cuda.is_available(), ", distributed_nccl_available:", torch.distributed.is_nccl_available())
print("nccl version:",torch.cuda.nccl.version())
print("cuda version:", torch.version.cuda)       

cudnn_version = torch.backends.cudnn.version()
print("cuDNN version:", cudnn_version)
print("GPU_NUM:", torch.cuda.device_count(), "GPU_NAME:", torch.cuda.get_device_name(0))
