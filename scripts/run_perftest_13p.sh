export LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib
export HUGE_PAGE_NUM=100
export XT_CQ_INLINE_CQE=0
ibv_devices
ibv_devinfo

root@gdr114:~/project/ai/nccl-tests# ib_write_lat -d xtrdma_0 -F -s
ib_write_lat: /root/project/rdma/dpu_user_rdma/build/lib/libmlx5.so.1: version `MLX5_1.25' not found (required by ib_write_lat)


# perftest config share obj so
find / -name libmlx5.so.1|while read file;do echo $file;readelf -sW $file|grep MLX5_1.25;done

# we find /root/project/rdma/rdma-core/build/lib/libmlx5.so.1 have MLX5_1.25
root@gdr114:~/project/rdma/sdn/perftest# ls -alh /root/project/rdma/rdma-core/build/lib/libmlx5.so.1
lrwxrwxrwx 1 root root 20 May 23 20:58 /root/project/rdma/rdma-core/build/lib/libmlx5.so.1 -> libmlx5.so.1.25.58.0

root@gdr114:~/project/rdma/sdn/perftest# ls -alh /root/project/rdma/dpu_user_rdma/build/lib/libmlx5.so.1
lrwxrwxrwx 1 root root 20 Jun 24 10:41 /root/project/rdma/dpu_user_rdma/build/lib/libmlx5.so.1 -> libmlx5.so.1.24.52.0

rm -f /root/project/rdma/dpu_user_rdma/build/lib/libmlx5.so.1
ln -s /root/project/rdma/rdma-core/build/lib/libmlx5.so.1.25.58.0 /root/project/rdma/dpu_user_rdma/build/lib/libmlx5.so.1

objdump -T /usr/lib/libmlx5.so.1 | grep MLX5_1.25

root@gdr114:~/project/ai/nccl-tests# ib_write_lat -d xtrdma_0 -F -s
ib_write_lat: symbol lookup error: /lib/x86_64-linux-gnu/libmlx5.so.1: undefined symbol: ibv_cmd_create_cq_ex2, version IBVERBS_PRIVATE_34

root@gdr114:~/project/ai/nccl-tests# /root/project/rdma/sdn/perftest/ib_write_bw -d xtrdma_0 -F -s
/root/project/rdma/sdn/perftest/ib_write_bw: symbol lookup error: /lib/x86_64-linux-gnu/libmlx5.so.1: undefined symbol: ibv_cmd_create_cq_ex2, version IBVERBS_PRIVATE_34


# backup /lib/x86_64-linux-gnu/libmlx5.so.1
root@gdr114:/lib/x86_64-linux-gnu# ls -alh libmlx5.so.1
lrwxrwxrwx 1 root root 20 Sep  8  2024 libmlx5.so.1 -> libmlx5.so.1.25.54.0

cd /lib/x86_64-linux-gnu
rm -f libmlx5.so.1
ln -s /root/project/rdma/rdma-core/build/lib/libmlx5.so.1.25.58.0 libmlx5.so.1

root@gdr114:/lib/x86_64-linux-gnu# /root/project/rdma/sdn/perftest/ib_write_bw -d xtrdma_0 -F -a 192.168.1.11
/root/project/rdma/sdn/perftest/ib_write_bw: /root/project/rdma/dpu_user_rdma/build/lib/libibverbs.so.1: version `IBVERBS_PRIVATE_57' not found (required by /lib/x86_64-linux-gnu/libmlx5.so.1)
root@gdr114:/lib/x86_64-linux-gnu# 

# modify rdma user driver Cmakelist.txt
set(IBVERBS_PABI_VERSION "57")
./build.sh
rm -f /root/project/rdma/dpu_user_rdma/build/lib/libmlx5.so.1
ln -s /root/project/rdma/rdma-core/build/lib/libmlx5.so.1.25.58.0 /root/project/rdma/dpu_user_rdma/build/lib/libmlx5.so.1



