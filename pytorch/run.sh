apt install python3-pip
apt install python3.12-venv
python3 -m venv ~/pytorch-venv
source ~/pytorch-venv/bin/activate
pip3 install torch torchvision torchaudio 
python3 -c "import torch; print('torch_version:', torch.__version__); print('cuda_available:', torch.cuda.is_available()); print('nccl_version:', torch.cuda.nccl.version())"
