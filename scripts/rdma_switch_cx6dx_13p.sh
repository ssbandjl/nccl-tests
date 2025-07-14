# backup switch to 13p
mkdir -p /root/big/module/rdma_backup
cd /lib/modules/`uname -r`/updates/dkms/
mv ib_*.ko /root/big/module/rdma_backup/
mv rdma*.ko /root/big/module/rdma_backup/

cd /lib/modules/`uname -r`/kernel/drivers/infiniband/core



# switch to cx6dx
cp /root/big/module/rdma_backup/* /lib/modules/`uname -r`/updates/dkms/
dkms status
reboot
cd /lib/modules/`uname -r`/updates/dkms/
insmod ib_core.ko
insmod ib_uverbs.ko
insmod mlx5_ib.ko
lsmod|grep ib
lsmod|grep rdma
ibdev2netdev


