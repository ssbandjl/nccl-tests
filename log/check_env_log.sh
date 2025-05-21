root@gdr114:~# run_cmd "uname -r"

2025/05/21 09:35:00 s114 uname -r
6.11.0-26-generic

2025/05/21 09:35:00 s116 uname -r
6.11.0-19-generic
root@gdr114:~#

2025/05/21 09:36:13 s114 lspci |grep -i 'mellanox'
04:00.0 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
04:00.1 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
89:00.0 Ethernet controller: Mellanox Technologies MT2894 Family [ConnectX-6 Lx]
89:00.1 Ethernet controller: Mellanox Technologies MT2894 Family [ConnectX-6 Lx]

2025/05/21 09:36:13 s116 lspci |grep -i 'mellanox'
04:00.0 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
04:00.1 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
85:00.0 Ethernet controller: Mellanox Technologies MT2894 Family [ConnectX-6 Lx]
85:00.1 Ethernet controller: Mellanox Technologies MT2894 Family [ConnectX-6 Lx]
root@gdr114:~#

2025/05/21 09:36:50 s114 lspci |grep -i 'nvidia'
08:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 SXM2 16GB] (rev a1)
85:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 SXM2 16GB] (rev a1)

2025/05/21 09:36:50 s116 lspci |grep -i 'nvidia'
08:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 SXM2 16GB] (rev a1)
82:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 SXM2 16GB] (rev a1)
root@gdr114:~#

root@gdr114:~/bob/nccl-tests/build# run_cmd "nvidia-smi topo -m"

2025/05/21 09:40:05 s114 nvidia-smi topo -m
GPU0GPU1NIC0NIC1NIC2NIC3CPU AffinityNUMA AffinityGPU NUMA ID                                
GPU0     X     SYS    PHB    PHB    SYS    SYS    0-13,28-41    0        N/A
GPU1    SYS     X     SYS    SYS    PHB    PHB    14-27,42-55    1        N/A
NIC0    PHB    SYS     X     PIX    SYS    SYS                
NIC1    PHB    SYS    PIX     X     SYS    SYS                
NIC2    SYS    PHB    SYS    SYS     X     PIX                
NIC3    SYS    PHB    SYS    SYS    PIX     X                 

Legend:

  X    = Self
  SYS  = Connection traversing PCIe as well as the SMP interconnect between NUMA nodes (e.g., QPI/UPI)
  NODE = Connection traversing PCIe as well as the interconnect between PCIe Host Bridges within a NUMA node
  PHB  = Connection traversing PCIe as well as a PCIe Host Bridge (typically the CPU)
  PXB  = Connection traversing multiple PCIe bridges (without traversing the PCIe Host Bridge)
  PIX  = Connection traversing at most a single PCIe bridge
  NV#  = Connection traversing a bonded set of # NVLinks

NIC Legend:

  NIC0: rocep4s0f0
  NIC1: rocep4s0f1
  NIC2: rocep137s0f0
  NIC3: rocep137s0f1


2025/05/21 09:40:05 s116 nvidia-smi topo -m
    GPU0    GPU1    NIC0    NIC1    NIC2    NIC3    CPU Affinity    NUMA Affinity    GPU NUMA ID
GPU0     X     SYS    PHB    PHB    SYS    SYS    0-13,28-41    0        N/A
GPU1    SYS     X     SYS    SYS    PHB    PHB    14-27,42-55    1        N/A
NIC0    PHB    SYS     X     PIX    SYS    SYS                
NIC1    PHB    SYS    PIX     X     SYS    SYS                
NIC2    SYS    PHB    SYS    SYS     X     PIX                
NIC3    SYS    PHB    SYS    SYS    PIX     X                 

Legend:

  X    = Self
  SYS  = Connection traversing PCIe as well as the SMP interconnect between NUMA nodes (e.g., QPI/UPI)
  NODE = Connection traversing PCIe as well as the interconnect between PCIe Host Bridges within a NUMA node
  PHB  = Connection traversing PCIe as well as a PCIe Host Bridge (typically the CPU)
  PXB  = Connection traversing multiple PCIe bridges (without traversing the PCIe Host Bridge)
  PIX  = Connection traversing at most a single PCIe bridge
  NV#  = Connection traversing a bonded set of # NVLinks

NIC Legend:

  NIC0: mlx5_0
  NIC1: mlx5_1
  NIC2: mlx5_2
  NIC3: mlx5_3

root@gdr114:~/bob/nccl-tests/build# 

root@gdr114:~# run_cmd "nvidia-smi"

2025/05/21 09:56:31 s114 nvidia-smi
Wed May 21 09:56:31 2025       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 570.133.20             Driver Version: 570.133.20     CUDA Version: 12.8     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  Tesla V100-SXM2-16GB           Off |   00000000:08:00.0 Off |                    0 |
| N/A   29C    P0             20W /  300W |       5MiB /  16384MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
|   1  Tesla V100-SXM2-16GB           Off |   00000000:85:00.0 Off |                    0 |
| N/A   30C    P0             21W /  300W |       5MiB /  16384MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
                                                                                         
+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A            3486      G   /usr/lib/xorg/Xorg                        4MiB |
|    1   N/A  N/A            3486      G   /usr/lib/xorg/Xorg                        4MiB |
+-----------------------------------------------------------------------------------------+

2025/05/21 09:56:32 s116 nvidia-smi
Wed May 21 09:56:32 2025       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 550.144.03             Driver Version: 550.144.03     CUDA Version: 12.4     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  Tesla V100-SXM2-16GB           Off |   00000000:08:00.0 Off |                    0 |
| N/A   31C    P0             24W /  300W |       8MiB /  16384MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
|   1  Tesla V100-SXM2-16GB           Off |   00000000:82:00.0 Off |                    0 |
| N/A   30C    P0             20W /  300W |       8MiB /  16384MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
                                                                                         
+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A      2412      G   /usr/lib/xorg/Xorg                              4MiB |
|    1   N/A  N/A      2412      G   /usr/lib/xorg/Xorg                              4MiB |
+-----------------------------------------------------------------------------------------+
root@gdr114:~# 

root@gdr114:~# run_cmd "nvcc --version"

2025/05/21 17:05:20 s114 nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2023 NVIDIA Corporation
Built on Fri_Jan__6_16:45:21_PST_2023
Cuda compilation tools, release 12.0, V12.0.140
Build cuda_12.0.r12.0/compiler.32267302_0

2025/05/21 17:05:20 s116 nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2023 NVIDIA Corporation
Built on Fri_Jan__6_16:45:21_PST_2023
Cuda compilation tools, release 12.0, V12.0.140
Build cuda_12.0.r12.0/compiler.32267302_0