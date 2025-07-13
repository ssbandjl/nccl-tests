# A6000 -> V100
[Sun Jul 13 09:01:36 2025] nvidia 0000:0a:00.0: probe with driver nvidia failed with error -1
[Sun Jul 13 09:01:36 2025] NVRM: The NVIDIA probe routine failed for 4 device(s).
[Sun Jul 13 09:01:36 2025] NVRM: None of the NVIDIA devices were initialized.
[Sun Jul 13 09:01:36 2025] nvidia-nvlink: Unregistered Nvlink Core, major device number 236


solution:
查看当前已安装:
apt list --installed|grep nvidia

删除原来的nvidia安装包:
sudo apt-get --purge remove nvidia* -y
sudo apt autoremove -y
reboot

# list advise nvidia gpu drivers
sudo ubuntu-drivers devices # 列出当前系统检测到的显卡设备，并推荐合适的驱动版本
sudo apt install nvidia-driver-575 (recommended) # install gpu driver
reboot
nvidia-smi # gpu topo, nvidia-smi
lspci -tv


apt-get install -y cuda-drivers (GPU Tesla V100驱动安装命令)
# install cuda(u24/A6000 and v100)
apt install nvidia-cuda-toolkit
nvcc --version



