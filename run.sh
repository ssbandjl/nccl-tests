# s114
Run on single node with 8 GPUs (`-g 2`), scanning from 8 Bytes to 128MBytes :
./build/all_reduce_perf -b 8 -e 128M -f 2 -g 2

# across 2 node:
mpirun -np 2 -H s114:1,s116:1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO \
    -x NCCL_IB_DISABLE=0 \
    -x LD_LIBRARY_PATH \
    --allow-run-as-root \
    ./build/all_reduce_perf -b 8 -e 1G -f 2 -g 1


# across 2 node, every node 2gpu:
mpirun -np 4 -H s114:2,s116:2 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  --allow-run-as-root \
  ./build/all_reduce_perf -b 8 -e 1G -f 2 -g 1

-np 4: total processes (GPUs)
-H node1:2,node2:2: 2 GPUs on each node
-g 1: 1 GPU per MPI rank
-f 2: float32
-b 8 -e 1G: range of message sizes
-bind-to none: tells MPI not to bind processes to specific CPU cores, allows the OS (and CUDA/NCCL runtime) to select the best core or GPU affinity dynamically — which is often preferable when each rank is using a dedicated GPU
-map-by slot: option tells mpirun to assign MPI ranks to "slots" in sequential order — typically meaning: 1 process per core (or per GPU, if applicable), filling all available "slots" before moving to the next node or socket.


# all gather
run_cmd "ip addr show"
ls /sys/class/net
export NCCL_SOCKET_IFNAME=^lo,^enp129

mpirun -np 4 -H s114:2,s116:2 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  -x NCCL_SOCKET_IFNAME=^enp129 \
  ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1

mpirun -np 4 -H 192.168.1.10:2,192.168.1.11:2 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  -x NCCL_SOCKET_IFNAME=^enp129 \
  ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1

mpirun -np 4 -H 192.168.2.10:2,192.168.2.11:2 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  -x NCCL_SOCKET_IFNAME=^enp129 \
  ./root/project/ai/nccl-tests/build/all_gather_perf -b 8 -e 1G -f 2 -g 1

export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib
gdb --args ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1


s114:
export NCCL_SOCKET_IFNAME=enp137s0f0np0
export NCCL_IB_GID_INDEX=3
export NCCL_DEBUG=TRACE
export NCCL_LAUNCH_MODE=GROUP
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/ddlib:/root/project/ai/nccl-tests/nccl/build/lib
export RANK=0
export WORLD_SIZE=2
export MASTER_ADDR=192.168.1.10
export MASTER_PORT=12345
./build/all_reduce_perf -b 8 -e 512M -f 2 -g 1


114
export RANK=0
export WORLD_SIZE=2
export NCCL_SOCKET_IFNAME=enp137s0f0np0
export CUDA_VISIBLE_DEVICES=0
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib
./build/all_reduce_perf -b 8 -e 512M -f 2 -g 1


116
export RANK=1
export WORLD_SIZE=2
export NCCL_SOCKET_IFNAME=enp4s0f0np0
export CUDA_VISIBLE_DEVICES=0
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib
./build/all_reduce_perf -b 8 -e 512M -f 2 -g 1



mpirun -np 2 --hostfile hostfile ./run_nccl.sh



mpirun -np 4 -H 192.168.1.10:2,192.168.1.11:2 \
  -bind-to none -map-by slot \
  --allow-run-as-root \
  /root/project/ai/nccl-tests/run_with_rdma.sh

# mpirun -np 4 --hostfile hostfile /root/project/ai/nccl-tests/run_with_rdma.sh

mpirun -np 4 -H 192.168.1.10:2,192.168.1.11:2 \
    -bind-to none -map-by slot \
    --allow-run-as-root \
    /root/project/ai/nccl-tests/run_with_rdma.sh

clear
export NCCL_DEBUG=TRACE
export NCCL_DEBUG_SUBSYS=NET
# export NCCL_NET_GDR_LEVEL=SYS
export NCCL_NET_GDR_LEVEL=2
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib

mpirun -np 4 -H 192.168.1.10:2,192.168.1.11:2 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x NCCL_NET_GDR_LEVEL=2 \
  -x NCCL_IB_HCA=mlx5_2 \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  -x NCCL_SOCKET_IFNAME=^enp129,^lo \
  /root/project/ai/nccl-tests/build/all_gather_perf -b 8 -e 1G -f 2 -g 1


mpirun -np 4 -H 192.168.1.10:2,192.168.1.11:2 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1

clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1