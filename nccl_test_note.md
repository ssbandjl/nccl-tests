# NCCL Test Node

# main stack
```c

int main(int argc, char* argv[])
...
#ifdef MPI_SUPPORT
  MPI_Init(&argc, &argv);
#endif
  TESTCHECK(run());
  return 0;
}
```


# open device stack
```c
#0  __pthread_kill_implementation (no_tid=0, signo=6, threadid=<optimized out>) at ./nptl/pthread_kill.c:44
#1  __pthread_kill_internal (signo=6, threadid=<optimized out>) at ./nptl/pthread_kill.c:78
#2  __GI___pthread_kill (threadid=<optimized out>, signo=signo@entry=6) at ./nptl/pthread_kill.c:89
#3  0x00007fffefc4527e in __GI_raise (sig=sig@entry=6) at ../sysdeps/posix/raise.c:26
#4  0x00007fffefc288ff in __GI_abort () at ./stdlib/abort.c:79
#5  0x00007fffe850ac74 in mlx5_alloc_context (ibdev=0x7fff5f7a8390, cmd_fd=49, private_data=0x0) at /root/project/rdma/rdma-core/providers/mlx5/mlx5.c:2631
#6  0x00007fffefbe9742 in verbs_open_device (device=0x7fff5f7a8390, private_data=0x0) at /root/project/rdma/rdma-core/libibverbs/device.c:345
#7  0x00007fffefbe97e0 in __ibv_open_device_1_1 (device=0x7fff5f7a8390) at /root/project/rdma/rdma-core/libibverbs/device.c:367
#8  0x00007ffff04ba1b9 in wrap_ibv_open_device (ret=0x7fffd6dd5a10, device=<optimized out>) at misc/ibvwrap.cc:122
#9  0x00007ffff04db7d3 in ncclIbInit (logFunction=0x7ffff045a5d0 <ncclDebugLog(ncclDebugLogLevel, unsigned long, char const*, int, char const*, ...)>, profFunction=0x7ffff04fa000 <ncclProfilerCallback(void**, int, void*, long, void*)>) at transport/net_ib.cc:611
#10 0x00007ffff04f7cb0 in netGetState (state=<synthetic pointer>, i=1) at plugin/net.cc:179
#11 ncclNetInit (comm=comm@entry=0x555556ba75a0) at plugin/net.cc:210
#12 0x00007ffff046baa8 in commAlloc (comm=comm@entry=0x555556ba75a0, parent=parent@entry=0x0, ndev=<optimized out>, rank=<optimized out>) at init.cc:335
#13 0x00007ffff0476245 in ncclCommInitRankFunc (job_=0x555556c24180) at init.cc:1407
#14 0x00007ffff0466d4b in ncclAsyncJobMain (arg=0x555556c24180) at group.cc:73
#15 0x00007fffefc9caa4 in start_thread (arg=<optimized out>) at ./nptl/pthread_create.c:447
#16 0x00007fffefd29c3c in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:78

```



# check GDR stack
```c
static ncclResult_t ncclCommInitRankFunc
static ncclResult_t initTransportsRank
ncclTopoGetSystem
static ncclResult_t ncclTopoProcessNet
static ncclResult_t ncclTopoPopulateNics


// Topo detection / System graph creation
NCCLCHECKGOTO(ncclTopoGetSystem(comm, &comm->topo), ret, fail);
// Compute paths between GPUs and NICs
NCCLCHECKGOTO(ncclTopoComputePaths(comm->topo, comm), ret, fail);
// Remove inaccessible GPUs and unused NICs
NCCLCHECKGOTO(ncclTopoTrimSystem(comm->topo, comm), ret, fail);
// Recompute paths after trimming
NCCLCHECKGOTO(ncclTopoComputePaths(comm->topo, comm), ret, fail);
// Init search
NCCLCHECKGOTO(ncclTopoSearchInit(comm->topo), ret, fail);
// Decide on comm's CPU architecture.
NCCLCHECKGOTO(ncclTopoComputeCommCPU(comm), ret, fail);
// Print final topology
NCCLCHECKGOTO(ncclTopoPrint(comm->topo), ret, fail);
timers[TIMER_INIT_TOPO] = clockNano() - timers[TIMER_INIT_TOPO];

```




# check GDR
The line of code:

```cpp
bool gdrSupport = (props.ptrdSupport & NCCL_PTR_CUDA) || (comm->dmaBufSupport && (props.ptrSupport & NCCL_PTR_DMABUF));

nccl:
bool gdrSupport = (props.ptrSupport & NCCL_PTR_CUDA) || (comm->dmaBufSupport && (props.ptrSupport & NCCL_PTR_DMABUF));
```

is part of **NCCL’s internal logic** to decide whether **GPUDirect RDMA (GDR)** is supported on a given network interface (`props`) for a particular communicator (`comm`).

---

## 🧠 Breakdown of the logic:

```cpp
gdrSupport = A || (B && C)
```

Where:

* `A = props.ptrdSupport & NCCL_PTR_CUDA`
* `B = comm->dmaBufSupport`
* `C = props.ptrSupport & NCCL_PTR_DMABUF`

---

### ✅ Explanation of each part

| Expression            | Meaning                                                         |
| --------------------- | --------------------------------------------------------------- |
| `props.ptrdSupport`   | Capabilities of the NIC for **direct access to GPU memory**     |
| `NCCL_PTR_CUDA`       | Flag indicating **direct CUDA buffer support** (typical GDR)    |
| `props.ptrSupport`    | Capabilities for **indirect buffer support**, e.g., via DMA-BUF |
| `NCCL_PTR_DMABUF`     | Flag indicating support for **DMA-BUF sharing**                 |
| `comm->dmaBufSupport` | NCCL communication context says **DMA-BUF is supported**        |
| `gdrSupport`          | Result: **true if GDR or DMA-BUF-based access is available**    |

---

### ✅ When `gdrSupport` is `true`

GDR is enabled if:

* The NIC supports direct CUDA buffer access (`NCCL_PTR_CUDA`)
  **OR**
* The NIC supports DMA-BUF (`NCCL_PTR_DMABUF`) **AND** NCCL runtime supports it (`dmaBufSupport`)

---

### 🔬 Practical meaning:

* If `props.ptrdSupport & NCCL_PTR_CUDA` → classic GPUDirect RDMA is available (e.g., via `nv_peer_mem`)
* If `comm->dmaBufSupport && (props.ptrSupport & NCCL_PTR_DMABUF)` → newer kernel-based DMA-BUF support is available (no need for `nv_peer_mem`)
* If both are false → fallback to host staging buffers (slower)

---

## 🛠️ How to influence this in practice

| To enable GDR            | Do this                                                      |
| ------------------------ | ------------------------------------------------------------ |
| Classic GDR (CUDA ptr)   | Install `nv_peer_mem`, disable IOMMU                         |
| DMA-BUF (modern kernels) | Kernel ≥ 5.11 + NVIDIA driver ≥ 515, no `nv_peer_mem` needed |
| Forcibly disable GDR     | `export NCCL_NET_GDR_LEVEL=0`                                |
| Debug capabilities       | Use `NCCL_DEBUG=INFO` and `NCCL_DEBUG_SUBSYS=NET`            |

---

## ✅ Summary

* This line determines whether GPUDirect RDMA is available via **direct CUDA ptr** or **DMA-BUF**
* It reflects NCCL's **capability negotiation between the NIC and GPU**
* You can influence it by setting up GDR kernel support (`nv_peer_mem` or DMA-BUF)

---

Let me know if you'd like help checking which path your system is using or forcing a particular GDR mode.





# PTR(Point Direct)
In NCCL's internal naming, **`ptrd`** typically stands for:

> **Pointer Direct** (as in **direct GPU pointer access**)

---

### 🔍 In Context: `props.ptrdSupport`

This field is used to describe whether a network interface (like an InfiniBand HCA) supports **direct access to device memory (GPU memory)** — which is required for **GPUDirect RDMA (GDR)**.

---

### ✅ Comparison: `ptrdSupport` vs. `ptrSupport`

| Field         | Meaning                                                                        |
| ------------- | ------------------------------------------------------------------------------ |
| `ptrdSupport` | Does this NIC support **direct** access to GPU memory (e.g., GPUDirect)?       |
| `ptrSupport`  | Does this NIC support **indirect** access (e.g., via DMA-BUF or host staging)? |

---

### 🧠 Related Constants

* `NCCL_PTR_HOST` → Host memory
* `NCCL_PTR_CUDA` → CUDA device memory (GPU)
* `NCCL_PTR_DMABUF` → DMA-BUF (for zero-copy GPU memory sharing)

So when you see:

```cpp
props.ptrdSupport & NCCL_PTR_CUDA
```

…it means:

> “This NIC can directly access CUDA device memory (e.g., via GPUDirect RDMA).”

---

### ✅ Summary

| Term          | Stands for     | Meaning                                                                         |
| ------------- | -------------- | ------------------------------------------------------------------------------- |
| `ptrd`        | Pointer Direct | Indicates **direct GPU memory access** by the NIC (GPUDirect)                   |
| `ptrdSupport` | Field          | Capabilities for direct pointer access (checked via flags like `NCCL_PTR_CUDA`) |

---

Let me know if you want to trace where `ptrdSupport` is populated in NCCL source — it's typically filled in by the `net` transport plugins (`net_ib.cc`, etc.).





# ncclTopoProcessNet
```c
  printf_ffl("ncclTopoProcessNet, name:%s\n", comm->ncclNet->name);
  NCCLCHECKGOTO(ncclTopoProcessNet(comm, xml, 0, dumpXmlFile, state,
    comm->ncclNet->getProperties, comm->ncclNet->makeVDevice, comm->ncclNet->devices, comm->ncclNet->name), ret, fail);
```



# Using network IB stack
```c
libnccl.so.2!ncclParamDmaBufEnable() (\root\project\ai\nccl-tests\nccl\src\init.cc:278)
libnccl.so.2!dmaBufSupported(ncclComm * comm) (\root\project\ai\nccl-tests\nccl\src\init.cc:282)
libnccl.so.2!commAlloc(ncclComm * comm, ncclComm * parent, int ndev, int rank) (\root\project\ai\nccl-tests\nccl\src\init.cc:362)
libnccl.so.2!ncclCommInitRankFunc(ncclAsyncJob * job_) (\root\project\ai\nccl-tests\nccl\src\init.cc:1409)
libnccl.so.2!ncclAsyncJobMain(void * arg) (\root\project\ai\nccl-tests\nccl\src\group.cc:73)
libc.so.6!start_thread(void * arg) (pthread_create.c:447)
libc.so.6!clone3() (clone3.S:78)
```


# enable dmabuf
```c
NCCL_PARAM(DmaBufEnable, "DMABUF_ENABLE", 1);

// Detect DMA-BUF support
static ncclResult_t dmaBufSupported(struct ncclComm* comm) {
  if (ncclParamDmaBufEnable() == 0 || comm->ncclNet->regMrDmaBuf == NULL || ncclCudaLibraryInit() != ncclSuccess) return ncclInternalError;
#if CUDA_VERSION >= 11070
  int flag = 0;
  CUdevice dev;
  int cudaDriverVersion;
  CUDACHECK(cudaDriverGetVersion(&cudaDriverVersion));
  if (CUPFN(cuDeviceGet) == NULL || cudaDriverVersion < 11070) return ncclInternalError;
  CUCHECK(cuDeviceGet(&dev, comm->cudaDev));
  // Query device to see if DMA-BUF support is available
  (void) CUPFN(cuDeviceGetAttribute(&flag, CU_DEVICE_ATTRIBUTE_DMA_BUF_SUPPORTED, dev)); // check gpu dma_buf support
  if (flag == 0) return ncclInternalError;
  INFO(NCCL_INIT, "DMA-BUF is available on GPU device %d", comm->cudaDev);
  return ncclSuccess;
#endif
  return ncclInternalError;
}
```



# get property
```c
ncclResult_t ncclIbGetPhysProperties(int dev, ncclNetProperties_t* props) {
  struct ncclIbDev* ibDev = ncclIbDevs + dev;
  pthread_mutex_lock(&ibDev->lock);
  props->name = ibDev->devName;
  props->speed = ibDev->speed;
  props->pciPath = ibDev->pciPath;
  props->guid = ibDev->guid;
  props->ptrSupport = NCCL_PTR_HOST;
  if (ncclIbGdrSupport() == ncclSuccess) {
    props->ptrSupport |= NCCL_PTR_CUDA; // GDR support via nv_peermem
  }
  props->regIsGlobal = 1;
  if (ncclIbDmaBufSupport(dev) == ncclSuccess) {
    props->ptrSupport |= NCCL_PTR_DMABUF; // GDR support via DMA-BUF
  }
  props->forceFlush = 0;
  props->latency = 0; // Not set
  props->port = ibDev->portNum + ibDev->realPort;
  props->maxComms = ibDev->maxQp;
  props->maxRecvs = NCCL_NET_IB_MAX_RECVS;
  props->netDeviceType    = NCCL_NET_DEVICE_HOST;
  props->netDeviceVersion = NCCL_NET_DEVICE_INVALID_VERSION;
  props->maxP2pBytes = NCCL_MAX_NET_SIZE_BYTES;
  pthread_mutex_unlock(&ibDev->lock);
  return ncclSuccess;
}
```



# check dma_buf
`CU_DEVICE_ATTRIBUTE_DMA_BUF_SUPPORTED` is a **CUDA device attribute** introduced to let applications (like NCCL) **query whether a GPU supports DMA-BUF interop**, which is essential for enabling **GPUDirect-like communication via DMA-BUF**.

---

## 🔍 What it is

```cpp
CU_DEVICE_ATTRIBUTE_DMA_BUF_SUPPORTED = 113
```

* Introduced in **CUDA 11.7+**
* Available via the **CUDA Driver API**
* Used to check whether a **GPU supports exporting/importing memory via DMA-BUF**

---

## ✅ Usage in code

You can check this attribute with the CUDA Driver API:

```cpp
int value;
CUdevice dev;
cuDeviceGet(&dev, 0);  // Get first CUDA device
cuDeviceGetAttribute(&value, CU_DEVICE_ATTRIBUTE_DMA_BUF_SUPPORTED, dev);

if (value) {
    printf("DMA-BUF is supported on this GPU\n");
} else {
    printf("DMA-BUF is NOT supported\n");
}
```

---

## 🧠 When is this useful?

Apps like **NCCL, GDRCopy, RDMA libraries**, or **shared-GPU renderers** use this to determine whether they can:

* Export GPU memory as a **DMA-BUF file descriptor**
* Import memory from other devices/processes via DMA-BUF

If not supported, they fall back to other modes (e.g., `nv_peer_mem`, host staging).

---

## ⚙️ Requirements for `DMA_BUF_SUPPORTED = 1`

| Component         | Minimum Version                                                          |
| ----------------- | ------------------------------------------------------------------------ |
| **CUDA**          | 11.7+                                                                    |
| **NVIDIA Driver** | 515+                                                                     |
| **GPU Arch**      | Ampere (A100), Hopper (H100), some Turing, V100 may not support it fully |
| **Kernel**        | 5.11+ (for FD handling + RDMA FD support)                                |

---

## 🧪 How to check from command line

No direct `nvidia-smi` flag, but you can run a custom check with:

```bash
nvcc -o check_dma_buf check_dma_buf.cu
./check_dma_buf
```

Or let me know and I can give you a small full source file.

---

## ✅ Summary

| Attribute                               | Meaning                                                                   |
| --------------------------------------- | ------------------------------------------------------------------------- |
| `CU_DEVICE_ATTRIBUTE_DMA_BUF_SUPPORTED` | Indicates whether the GPU supports exporting/importing memory via DMA-BUF |
| Use case                                | Enables zero-copy GPU communication without `nv_peer_mem`                 |
| Required by                             | NCCL, RDMA apps, Vulkan/GL interop                                        |

---

Let me know if you want a working code snippet to test your current system’s support.



# XT_DPU For AI

# 术语

- NCCL_NET_GDR_LEVEL: 



# Env

XW_ENV_BMC: https://wiki.nsv6.b122.top/pages/viewpage.action?pageId=41419386



## TOPO

```bash
root@gdr114:~/bob/nccl-tests/build# run_cmd "nvidia-smi topo -m"

2025/05/21 09:40:05 s114 nvidia-smi topo -m
	GPU0	GPU1	NIC0	NIC1	NIC2	NIC3	CPU Affinity	NUMA Affinity	GPU NUMA ID
GPU0	 X 	SYS	PHB	PHB	SYS	SYS	0-13,28-41	0		N/A
GPU1	SYS	 X 	SYS	SYS	PHB	PHB	14-27,42-55	1		N/A
NIC0	PHB	SYS	 X 	PIX	SYS	SYS				
NIC1	PHB	SYS	PIX	 X 	SYS	SYS				
NIC2	SYS	PHB	SYS	SYS	 X 	PIX				
NIC3	SYS	PHB	SYS	SYS	PIX	 X 				

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
	GPU0	GPU1	NIC0	NIC1	NIC2	NIC3	CPU Affinity	NUMA Affinity	GPU NUMA ID
GPU0	 X 	SYS	PHB	PHB	SYS	SYS	0-13,28-41	0		N/A
GPU1	SYS	 X 	SYS	SYS	PHB	PHB	14-27,42-55	1		N/A
NIC0	PHB	SYS	 X 	PIX	SYS	SYS				
NIC1	PHB	SYS	PIX	 X 	SYS	SYS				
NIC2	SYS	PHB	SYS	SYS	 X 	PIX				
NIC3	SYS	PHB	SYS	SYS	PIX	 X 				

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
```

## check gpu

```bash
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
```





# setup nccl for 4GPU and 4 NIC

To run **NCCL tests** efficiently on a machine with **4 GPUs** and **4 ConnectX-6 NICs (CX6)**, the goal is to map each GPU to a separate NIC to maximize bandwidth and avoid oversubscription.

Here’s a full setup guide for a **4-GPU, 4-NIC NCCL test environment**:

------

## ✅ Hardware & Assumptions

- 4 NVIDIA GPUs (e.g., A100, V100, etc.)
- 4 Mellanox ConnectX-6 NICs (each preferably in a dedicated PCIe slot)
- `nvidia-smi topo -m` shows correct PCIe and NVLink/NIC affinity
- Ubuntu OS with proper drivers:
  - NVIDIA driver + CUDA
  - Mellanox OFED
  - NCCL with UCX and/or libibverbs support

------

## 🔧 Step 1: Check GPU ↔ NIC Topology

Run:

```bash
nvidia-smi topo -m
```

Look for **close** connections between each GPU and NIC (ideally on same PCIe root complex or NUMA node).

Example layout:

|      | GPU0 | GPU1 | GPU2 | GPU3 | mlx5_0 | mlx5_1 | mlx5_2 | mlx5_3 |
| ---- | ---- | ---- | ---- | ---- | ------ | ------ | ------ | ------ |
| GPU0 | X    | NVL  | PHB  | PHB  | PIX    | SYS    | SYS    | SYS    |
| GPU1 | NVL  | X    | PHB  | PHB  | SYS    | PIX    | SYS    | SYS    |
| GPU2 | PHB  | PHB  | X    | NVL  | SYS    | SYS    | PIX    | SYS    |
| GPU3 | PHB  | PHB  | NVL  | X    | SYS    | SYS    | SYS    | PIX    |

Based on this, assign:

- GPU0 ↔ mlx5_0
- GPU1 ↔ mlx5_1
- GPU2 ↔ mlx5_2
- GPU3 ↔ mlx5_3

------

## 🔧 Step 2: Install Prerequisites

```bash
# NVIDIA + CUDA
sudo apt install -y nvidia-cuda-toolkit

# UCX + NCCL (recommended way)
git clone https://github.com/openucx/ucx.git
cd ucx && ./autogen.sh && ./contrib/configure-release --enable-mt && make -j && sudo make install

git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests && make MPI=0 CUDA_HOME=/usr/local/cuda

# OR install NCCL via conda/Docker/NVIDIA packages if not building from source
```

------

## 🧪 Step 3: Run NCCL Test (with 4 GPUs + 4 NICs)

Use `NCCL_SOCKET_IFNAME`, `NCCL_NET_GDR_LEVEL`, and optionally `UCX_NET_DEVICES` to bind properly:

```bash
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=eth0,eth1,eth2,eth3  # list your mlx NICs
export NCCL_NET_GDR_LEVEL=2                    # allow GPU-direct-RDMA
export UCX_NET_DEVICES=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_3:1  # optional, UCX-based

# Pin each GPU to a specific NIC (via CUDA_VISIBLE_DEVICES)
# Run all ranks locally using mpirun or launch script

./build/all_reduce_perf -b 8 -e 512M -f 2 -g 1
```

Or using 4 ranks manually (for tighter control):

```bash
CUDA_VISIBLE_DEVICES=0 ./build/all_reduce_perf -g 1 &
CUDA_VISIBLE_DEVICES=1 ./build/all_reduce_perf -g 1 &
CUDA_VISIBLE_DEVICES=2 ./build/all_reduce_perf -g 1 &
CUDA_VISIBLE_DEVICES=3 ./build/all_reduce_perf -g 1 &
```

To assign interfaces more precisely per GPU rank, use `UCX_NET_DEVICES` and `GOMP_CPU_AFFINITY` or `numactl`.

------

## 🧠 Tips

### Affinity Mapping

Use `hwloc-ls` or `lstopo` to verify device placement. Map NICs and GPUs by NUMA node for best locality.

### RoCE / IB Optimization (CX6-specific)

Ensure RoCE is enabled properly on NIC:

```bash
mlxconfig -d <pci_id> set ROCE=1 ROCE_V2=1
```

Set MTU to 9000 and configure priority flow control (PFC) if in RoCE mode.

### Useful env variables

```bash
export NCCL_TOPO_DUMP_FILE=nccl_topo.xml  # to debug NCCL topology
export UCX_TLS=rc,sm,self                 # for UCX layer
```

------

## 🧪 NCCL Test Example Output

```text
# nThread 1 nGpus 4 minBytes 8 maxBytes 536870912 step: 2(factor) warmup iters: 5 iters: 20 validation: 1
#
# Using devices
#   Rank  0 Pid 12345 on host0 device  0 [0x04] Tesla A100-SXM4-40GB
#   Rank  1 Pid 12346 on host0 device  1 [0x06] Tesla A100-SXM4-40GB
#   Rank  2 Pid 12347 on host0 device  2 [0x0A] Tesla A100-SXM4-40GB
#   Rank  3 Pid 12348 on host0 device  3 [0x0C] Tesla A100-SXM4-40GB
```

------

## ✅ Summary

| Task                 | How                                                      |
| -------------------- | -------------------------------------------------------- |
| Map GPU to NIC       | Use `nvidia-smi topo -m` and `hwloc`                     |
| Install dependencies | CUDA, UCX, NCCL, OFED                                    |
| Run test             | Use `all_reduce_perf` with correct env vars              |
| Debug NCCL transport | Enable `NCCL_DEBUG=INFO` and check `NCCL_TOPO_DUMP_FILE` |

------

If you’d like a helper script to automatically launch 4 NCCL ranks with GPU-NIC pinning, or test `NCCL_IB_HCA` directly for RDMA path, let me know — I can generate one for you.





## nvcc version

```c
root@gdr114:~/project/ai/nccl-tests# nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2023 NVIDIA Corporation
Built on Fri_Jan__6_16:45:21_PST_2023
Cuda compilation tools, release 12.0, V12.0.140
Build cuda_12.0.r12.0/compiler.32267302_0
```



## nccl test alloc context stack

```c
mlx5_alloc_context(), /root/project/rdma/rdma-core/providers/mlx5/mlx5.c:2620, MLX5 Alloc context
Stack trace (depth: 12):
/root/project/rdma/rdma-core/build/lib/libmlx5-rdmav57.so(+0x73b60)[0x7cc281742b60]
/root/project/rdma/rdma-core/build/lib/libmlx5-rdmav57.so(+0x73c6f)[0x7cc281742c6f]
/root/project/rdma/rdma-core/build/lib/libibverbs.so(verbs_open_device+0x99)[0x7cc2961b6742]
/root/project/rdma/rdma-core/build/lib/libibverbs.so(ibv_open_device+0x21)[0x7cc2961b67e0]
/lib/x86_64-linux-gnu/libnccl.so.2(+0xb9a49)[0x7cc296ab9a49]
/lib/x86_64-linux-gnu/libnccl.so.2(+0xd9d62)[0x7cc296ad9d62]
/lib/x86_64-linux-gnu/libnccl.so.2(+0xf7bc2)[0x7cc296af7bc2]
/lib/x86_64-linux-gnu/libnccl.so.2(+0x69888)[0x7cc296a69888]
/lib/x86_64-linux-gnu/libnccl.so.2(+0x74bf5)[0x7cc296a74bf5]
/lib/x86_64-linux-gnu/libnccl.so.2(+0x64deb)[0x7cc296a64deb]
/lib/x86_64-linux-gnu/libc.so.6(+0x9caa4)[0x7cc29629caa4]
/lib/x86_64-linux-gnu/libc.so.6(+0x129c3c)[0x7cc296329c3c]
```



要在 **两个节点之间运行 NCCL Tests 而不使用 MPI**（即不依赖 `mpirun` 或 `mpiexec`），可以使用 NCCL 自带的 **socket-based launch 机制**，这通常通过设置一组环境变量来完成。





# run nccl test without mpi(but use rdma)



------

## ✅ 目标：2 节点运行 NCCL Test（不使用 MPI）

这种方式适用于 NCCL P2P 或 Ring 通信测试，也便于自定义环境（比如 RDMA-only，或非 MPI 系统）。

------

## 🧩 节点定义

假设：

- **Node 1 IP**: `192.168.1.10`（rank 0）
- **Node 2 IP**: `192.168.1.11`（rank 1）
- 每个节点有 1 块 GPU

------

## ✅ 环境变量设置（必要）

在 **每个节点上**启动 NCCL Test 进程之前，设置如下环境变量：

| 变量名                   | 含义                                 |
| ------------------------ | ------------------------------------ |
| `NCCL_SOCKET_IFNAME`     | 网络接口名（如 `eth0`、`ib0`）       |
| `NCCL_DEBUG=INFO`        | 打印 NCCL 调试信息                   |
| `NCCL_IB_HCA`            | 限制使用的 IB 设备（如 `mlx5_0`）    |
| `NCCL_IB_GID_INDEX`      | GID 索引，RDMA 需要时设置            |
| `NCCL_P2P_DISABLE=1`     | （可选）禁止 P2P，用于纯 socket 通信 |
| `NCCL_LAUNCH_MODE=GROUP` | 推荐模式                             |
| `NCCL_DEBUG_SUBSYS=ALL`  | （可选）更详细调试信息               |

------

## ✅ 启动命令（在每个节点分别执行）

### 🧷 Node 1（rank 0）:

```bash
export NCCL_SOCKET_IFNAME=enp137s0f0np0
export NCCL_IB_GID_INDEX=3
export NCCL_DEBUG=TRACE
export NCCL_LAUNCH_MODE=GROUP
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl/build/lib
export RANK=0
export WORLD_SIZE=2
export MASTER_ADDR=192.168.1.10
export MASTER_PORT=12345
./build/all_reduce_perf -b 8 -e 512M -f 2 -g 1
```

------

### 🧷 Node 2（rank 1）:

```bash
export NCCL_SOCKET_IFNAME=eth0
export NCCL_DEBUG=INFO
export NCCL_LAUNCH_MODE=GROUP

export RANK=1
export WORLD_SIZE=2
export MASTER_ADDR=10.0.0.1  # rank 0 的地址
export MASTER_PORT=12345

./build/all_reduce_perf -b 8 -e 512M -f 2 -g 1
```

------

## ✅ 防火墙和端口说明

确保两个节点之间：

- 能够通过 `MASTER_ADDR:MASTER_PORT` 通信
- 防火墙未阻止通信（如 `ufw`, `firewalld`）

------

## ✅ NCCL 跨节点通信方式（非 MPI）

这实际上启用了 NCCL 的 socket/net plugin，或 IB plugin，作为底层传输。你无需用 MPI，只要环境变量配置正确，NCCL 会自动建立连接。

------

## ✅ 验证是否跨节点运行成功

你应该在 `NCCL_DEBUG=INFO` 输出中看到日志类似：

```text
rank 0 connected to rank 1 via NET/IB or NET/Socket
```

------

## ✅ 可选调优（IB 相关）

如果使用的是 InfiniBand 网络，还可以加上：

```bash
export NCCL_NET_GDR_LEVEL=0        # 禁用 GPU Direct RDMA
export NCCL_IB_CUDA_SUPPORT=0      # 禁用 CUDA support for IB
export NCCL_IB_DISABLE=0           # 确保未禁用 IB plugin
export NCCL_IB_GID_INDEX=3         # RoCE 时指定正确 GID 索引
```

------

## 📌 小结

| 要点                   | 说明                                                    |
| ---------------------- | ------------------------------------------------------- |
| 不用 MPI               | 只需设置 `RANK`、`WORLD_SIZE`、`MASTER_ADDR` 等环境变量 |
| 每个节点单独启动进程   | 启动顺序无所谓，通信建立靠 NCCL 内部                    |
| 通信方式自动选择       | NCCL 会自动选择 socket/IB/SHM，按 plugin 顺序           |
| 可加 `NCCL_DEBUG` 调试 | 确认连接、选择的 plugin、错误日志等                     |

------

如果你告诉我你打算使用的是 TCP 还是 RoCE、IB，我可以提供更加具体的设置。是否希望我为你写一个两个节点的运行脚本？





# query gpu arch

你可以通过几种方法在本地查询当前系统上 **GPU 的架构信息（compute capability / SM 架构）**，以便正确设置编译器参数如 `NVCC_GENCODE`。

------

## ✅ 方法 1：使用 `nvidia-smi` + 手动查表

```bash
nvidia-smi --query-gpu=name --format=csv,noheader
```

示例输出：

```
NVIDIA A100-SXM4-40GB
```

然后根据官方文档/下表查出对应的架构（SM）：

| GPU 名称   | 架构代号 | Compute Capability |
| ---------- | -------- | ------------------ |
| V100       | Volta    | 7.0                |
| T4         | Turing   | 7.5                |
| A100       | Ampere   | 8.0                |
| RTX 3090   | Ampere   | 8.6                |
| L40 / L40S | Ada      | 8.9                |
| H100       | Hopper   | 9.0                |

------

## ✅ 方法 2：使用 `deviceQuery` 工具（推荐）

来自 CUDA 示例：

```bash
cd /usr/local/cuda/samples/1_Utilities/deviceQuery
make
./deviceQuery
```

输出中会包含：

```text
CUDA Capability Major/Minor version number:    8.0
```

这表示当前 GPU 的 compute capability 是 `8.0`（即 `compute_80` / `sm_80`）。

------

## ✅ 方法 3：使用 `nvidia-smi` + `cuda` 工具脚本（更程序化）

```bash
nvidia-smi -L
```

然后使用 `cudaComputeCapability` python 工具或 nvml API 做自动映射（适合脚本化环境）。

------

## ✅ 方法 4：使用 Python 脚本（`pycuda` 或 `torch`）

### 用 PyTorch：

```python
import torch
cc = torch.cuda.get_device_capability()
print(f"Compute Capability: {cc[0]}.{cc[1]}")
```

### 用 PyCUDA：

```python
import pycuda.driver as cuda
cuda.init()
dev = cuda.Device(0)
print("Compute capability:", dev.compute_capability())
```

------

## ✅ 方法 5：NVML 库（C/C++ 或 Python）

通过 NVML 可以获取设备名称和 ID，再匹配 compute capability。

------

## ✅ 小结

| 方法                    | 是否推荐 | 优点                    |
| ----------------------- | -------- | ----------------------- |
| `nvidia-smi` + 手动查表 | ✅        | 快速                    |
| `deviceQuery`           | ✅✅       | 精准，官方              |
| `torch/pycuda`          | ✅        | 脚本中集成方便          |
| NVML API                | ✅        | 企业/调度系统自动化支持 |

------

如果你告诉我 `nvidia-smi` 输出的 GPU 型号，我可以直接告诉你 `compute_xx` 是多少，并帮你生成 `NVCC_GENCODE` 参数。需要我帮你查吗？



# show stack file and line

```c
addr2line -e /root/project/ai/nccl/build/lib/libnccl.so.2 0xba1b9
```



# nccl open device stack

```c
void* ncclAsyncJobMain(void* arg) {
  struct ncclAsyncJob* job = (struct ncclAsyncJob*)arg;
  job->result = job->func(job);
  if (job->result != ncclSuccess) {
    INFO(NCCL_INIT,"%s:%d -> %d [Async thread]", __FILE__, __LINE__, job->result);
  }
  __atomic_store_n(&job->state, ncclGroupJobDone, __ATOMIC_RELEASE);
  return arg;
}
```

```c
static ncclResult_t ncclCommInitRankFunc(struct ncclAsyncJob* job_) {
  struct ncclCommInitRankAsyncJob* job = (struct ncclCommInitRankAsyncJob*)job_;
  ncclComm_t comm = job->comm;
  ncclResult_t res = ncclSuccess;
  int archMajor, archMinor;
  size_t maxLocalSizeBytes = 0;
  int cudaDev = job->cudaDev;
  int* parentRanks = NULL;
  int cudaArch;
  int maxSharedMem = 0;
  double sum_timers = 0;
  uint64_t timers[TIMERS_INIT_COUNT] = {0};
  unsigned long long commIdHash;

  timers[TIMER_INIT_TOTAL] = clockNano();
  CUDACHECKGOTO(cudaSetDevice(cudaDev), res, fail);
  CUDACHECKGOTO(cudaDeviceGetAttribute(&maxSharedMem, cudaDevAttrMaxSharedMemoryPerBlockOptin, cudaDev), res, fail);
  CUDACHECKGOTO(cudaDeviceGetAttribute(&archMajor, cudaDevAttrComputeCapabilityMajor, cudaDev), res, fail);
  CUDACHECKGOTO(cudaDeviceGetAttribute(&archMinor, cudaDevAttrComputeCapabilityMinor, cudaDev), res, fail);
  cudaArch = 100*archMajor + 10*archMinor;

  timers[TIMER_INIT_KERNELS] = clockNano();
  NCCLCHECK(ncclInitKernelsForDevice(cudaArch, maxSharedMem, &maxLocalSizeBytes));
  // Set the maximum kernel stack size of all kernels to avoid
  // a CUDA memory reconfig on load (c.f. NVSHMEM issue)
  if (maxLocalSizeBytes > 0 && ncclParamSetStackSize() == 1) {
    TRACE(NCCL_INIT, "Setting cudaLimitStackSize to %zu", maxLocalSizeBytes);
    CUDACHECKIGNORE(cudaDeviceSetLimit(cudaLimitStackSize, maxLocalSizeBytes));
  }
  timers[TIMER_INIT_KERNELS] = clockNano() - timers[TIMER_INIT_KERNELS];

  if (job->parent) {
    NCCLCHECKGOTO(ncclCalloc(&parentRanks, job->parent->nRanks), res, fail);
    NCCLCHECKGOTO(commGetSplitInfo(comm, job->parent, job->color, job->key, &job->nranks, &job->myrank, parentRanks), res, fail);
    // Negative color does not create a new comm object. We needed to take part in the allgather, but we're done now.
    if (job->color == NCCL_SPLIT_NOCOLOR) goto exit;
    timers[TIMER_INIT_ALLOC] = clockNano();
    NCCLCHECKGOTO(commAlloc(comm, job->parent, job->nranks, job->myrank), res, fail); // init network
    timers[TIMER_INIT_ALLOC] = clockNano() - timers[TIMER_INIT_ALLOC];
    // child hash obtained from (parent hash, split count, color)
    uint64_t hacc[2] = {1, 1};
    eatHash(hacc, &job->parent->commHash);
    eatHash(hacc, &job->splitCount);
    eatHash(hacc, &job->color);
    comm->commHash = digestHash(hacc);
    INFO(NCCL_INIT, "%s comm %p rank %d nranks %d cudaDev %d nvmlDev %d busId %lx parent %p splitCount %d color %d key %d- Init START", job->funcName,
         comm, comm->rank, comm->nRanks, comm->cudaDev, comm->nvmlDev, comm->busId, job->parent, job->splitCount, job->color, job->key);
    timers[TIMER_INIT_BOOTSTRAP] = clockNano();
    NCCLCHECKGOTO(bootstrapSplit(comm->commHash, comm, job->parent, job->color, job->key, parentRanks), res, fail);
    timers[TIMER_INIT_BOOTSTRAP] = clockNano() - timers[TIMER_INIT_BOOTSTRAP];
    // debug info, no commId was used
    commIdHash = 0;
  } else {
    timers[TIMER_INIT_ALLOC] = clockNano();
    NCCLCHECKGOTO(commAlloc(comm, NULL, job->nranks, job->myrank), res, fail);
    timers[TIMER_INIT_ALLOC] = clockNano() - timers[TIMER_INIT_ALLOC];
    // obtain a unique hash using the first commId
    comm->commHash = commIdHash = getHash(job->commId->internal, NCCL_UNIQUE_ID_BYTES);
    INFO(NCCL_INIT, "%s comm %p rank %d nranks %d cudaDev %d nvmlDev %d busId %lx commId 0x%llx - Init START", job->funcName,
         comm, comm->rank, comm->nRanks, comm->cudaDev, comm->nvmlDev, comm->busId, commIdHash);
    timers[TIMER_INIT_BOOTSTRAP] = clockNano();
    NCCLCHECKGOTO(bootstrapInit(job->nId, (struct ncclBootstrapHandle*)job->commId, comm), res, fail);
    timers[TIMER_INIT_BOOTSTRAP] = clockNano() - timers[TIMER_INIT_BOOTSTRAP];
  }
```



```c
static ncclResult_t commAlloc(struct ncclComm* comm, struct ncclComm* parent, int ndev, int rank) {
  if (ndev < 1) {
    WARN("invalid device count (%d) requested", ndev);
    return ncclInvalidArgument;
  }
  if (rank >= ndev || rank < 0) {
    WARN("rank %d exceeds ndev=%d", rank, ndev);
    return ncclInvalidArgument;
  }

  ncclMemoryStackConstruct(&comm->memPermanent);
  ncclMemoryStackConstruct(&comm->memScoped);
  comm->destructorHead = nullptr;
  comm->rank = rank;
  comm->nRanks = ndev;

  NCCLCHECK(ncclNetPluginLoad(comm));
  NCCLCHECK(ncclNetInit(comm));
  ...
```





```c
static ncclResult_t netGetState(int i, enum ncclNetState* state) {
  pthread_mutex_lock(&netLock);
  if (ncclNetStates[i] == ncclNetStateInit) {
    int ndev;
    if (ncclNets[i]->init(ncclDebugLog, ncclProfilerCallback) != ncclSuccess) ncclNetStates[i] = ncclNetStateDisabled;
    else if (ncclNets[i]->devices(&ndev) != ncclSuccess || ndev <= 0) ncclNetStates[i] = ncclNetStateDisabled;
    else ncclNetStates[i] = ncclNetStateEnabled;
  }
  *state = ncclNetStates[i];
  pthread_mutex_unlock(&netLock);
  return ncclSuccess;
}
```



```c
ncclResult_t ncclIbInit(ncclDebugLogger_t logFunction, ncclProfilerCallback_t profFunction) {
  ncclResult_t ret = ncclSuccess;
  ncclProfilerFunction = profFunction;
  if (ncclParamIbDisable()) return ncclInternalError;
  static int shownIbHcaEnv = 0;
  if(wrap_ibv_symbols() != ncclSuccess) { return ncclInternalError; }

  if (ncclNIbDevs == -1) {
    pthread_mutex_lock(&ncclIbLock);
    wrap_ibv_fork_init();
    if (ncclNIbDevs == -1) {
      ncclNIbDevs = 0;
      ncclNMergedIbDevs = 0;
      if (ncclFindInterfaces(ncclIbIfName, &ncclIbIfAddr, MAX_IF_NAME_SIZE, 1) != 1) {
        WARN("NET/IB : No IP interface found.");
        ret = ncclInternalError;
        goto fail;
      }

      // Detect IB cards
      int nIbDevs;
      struct ibv_device** devices;

      // Check if user defined which IB device:port to use
      const char* userIbEnv = ncclGetEnv("NCCL_IB_HCA");
      if (userIbEnv != NULL && shownIbHcaEnv++ == 0) INFO(NCCL_NET|NCCL_ENV, "NCCL_IB_HCA set to %s", userIbEnv);
      struct netIf userIfs[MAX_IB_DEVS];
      bool searchNot = userIbEnv && userIbEnv[0] == '^';
      if (searchNot) userIbEnv++;
      bool searchExact = userIbEnv && userIbEnv[0] == '=';
      if (searchExact) userIbEnv++;
      int nUserIfs = parseStringList(userIbEnv, userIfs, MAX_IB_DEVS);

      if (ncclSuccess != wrap_ibv_get_device_list(&devices, &nIbDevs)) { ret = ncclInternalError; goto fail; }

      for (int d=0; d<nIbDevs && ncclNIbDevs<MAX_IB_DEVS; d++) {
        struct ibv_context * context;
        dump_stack();
        if (ncclSuccess != wrap_ibv_open_device(&context, devices[d]) || context == NULL) {
          WARN("NET/IB : Unable to open device %s", devices[d]->name);
          continue;
        }
```



# nccl test main

```c
#pragma weak ncclTestEngine=allGatherEngine
是 GCC 的弱符号机制，用于在链接时为某个符号（变量或函数）指定一个默认实现。
```



# NCCL 源码分析

https://blog.csdn.net/KIDGIN7439/article/details/126712106



## NCCL ENV

https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/env.html





# GPU v100不支持DMA_BUF
![img](C:\Users\bin.CHINACHINA\AppData\Local\Temp\企业微信截图_17479841535597.png)




# build
2,安装 nvidia-cuda-toolkit

 apt install nvidia-cuda-toolkit

3，安装openmpi
apt install openmpi-bin libopenmpi-dev

4，安装nccl-test
export CUDA_HOME=/usr/lib/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export MPI_HOME=/usr/include/x86_64-linux-gnu/openmpi/
ln -s /usr/bin/nvcc /usr/lib/cuda/bin/nvcc

注意，如上的路径要根据自己的实际情况修改

git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-test
make MPI=1 MPI_HOME=$MPI_HOME CUDA_HOME=$CUDA_HOME NCCL_HOME=$NCCL_HOME

