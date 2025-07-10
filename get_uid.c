// get_unique_id.c
#include <stdio.h>
#include <nccl.h>

int main() {
    ncclUniqueId id;
    ncclGetUniqueId(&id);
    fwrite(&id, sizeof(id), 1, stdout);
    return 0;
}
