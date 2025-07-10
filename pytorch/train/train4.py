import os
import torch
import torch.nn as nn
import torch.optim as optim
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP
from torch.utils.data import DataLoader, distributed
from torchvision import datasets, transforms

from torchvision.datasets.utils import download_url

# 替换 torchvision 默认的下载地址
datasets.MNIST.resources = [
    ('https://ossci-datasets.s3.amazonaws.com/mnist/train-images-idx3-ubyte.gz', 'f68b3c2dcbeaaa9fbdd348bbdeb94873'),
    ('https://ossci-datasets.s3.amazonaws.com/mnist/train-labels-idx1-ubyte.gz', 'd53e105ee54ea40749a09fcbcd1e9432'),
    ('https://ossci-datasets.s3.amazonaws.com/mnist/t10k-images-idx3-ubyte.gz', '9fb629c4189551a2d022fa330f9573f3'),
    ('https://ossci-datasets.s3.amazonaws.com/mnist/t10k-labels-idx1-ubyte.gz', 'ec29112dd5afa0611ce80d1b7f02629c'),
]

def setup():
    dist.init_process_group("nccl", init_method="env://")

def cleanup():
    dist.destroy_process_group()

class SimpleNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.net = nn.Sequential(
            nn.Flatten(),
            nn.Linear(28 * 28, 128),
            nn.ReLU(),
            nn.Linear(128, 10)
        )

    def forward(self, x):
        return self.net(x)

def main():
    setup()
    rank = dist.get_rank()
    local_rank = int(os.environ["LOCAL_RANK"])
    torch.cuda.set_device(local_rank)
    print(f"[Rank {rank}] World size: {dist.get_world_size()}, Local rank: {local_rank}, GPU count: {torch.cuda.device_count()}")

    transform = transforms.Compose([transforms.ToTensor()])
    dataset = datasets.MNIST(root="./data", train=True, download=True, transform=transform)
    sampler = distributed.DistributedSampler(dataset)
    dataloader = DataLoader(dataset, batch_size=64, sampler=sampler, num_workers=2)

    model = SimpleNN().cuda()
    model = DDP(model, device_ids=[local_rank])

    criterion = nn.CrossEntropyLoss()
    optimizer = optim.SGD(model.parameters(), lr=0.01)

    for epoch in range(1000):
        sampler.set_epoch(epoch)
        total_loss = 0
        for batch in dataloader:
            images, labels = batch[0].cuda(), batch[1].cuda()
            optimizer.zero_grad()
            output = model(images)
            loss = criterion(output, labels)
            loss.backward()
            optimizer.step()
            total_loss += loss.item()
        if rank == 0:
            print(f"[Rank {rank}] Epoch {epoch+1}, Loss: {total_loss:.4f}")

    cleanup()

if __name__ == "__main__":
    main()
