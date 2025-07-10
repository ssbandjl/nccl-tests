# train.py
import os
import torch
import torch.distributed as dist
import torch.nn as nn
import torch.optim as optim

def setup():
    dist.init_process_group(backend="nccl")

def cleanup():
    dist.destroy_process_group()

def main():
    setup()
    rank = dist.get_rank()
    local_rank = int(os.environ["LOCAL_RANK"])
    torch.cuda.set_device(local_rank)

    model = nn.Linear(10, 1).cuda()
    model = torch.nn.parallel.DistributedDataParallel(model, device_ids=[local_rank])

    data = torch.randn(32, 10).cuda()
    target = torch.randn(32, 1).cuda()

    criterion = nn.MSELoss()
    optimizer = optim.SGD(model.parameters(), lr=0.01)

    for _ in range(10000):
        optimizer.zero_grad()
        output = model(data)
        loss = criterion(output, target)
        loss.backward()
        optimizer.step()
        if rank == 0:
            print(f"Loss: {loss.item():.4f}")

    cleanup()

if __name__ == "__main__":
    main()
