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