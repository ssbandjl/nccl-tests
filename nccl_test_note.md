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


