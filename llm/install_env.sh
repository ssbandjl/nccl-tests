# server s114:
sudo apt install nfs-kernel-server
echo "/root/big/llm *(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
sudo exportfs -ra

# client
sudo apt install nfs-common
mkdir -p /root/big/llm
sudo mount s114:/root/big/llm /root/big/llm
ls -alh /root/big/llm


