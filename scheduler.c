#include <stdio.h>
#include <stdlib.h>

typedef struct {
    char name[10];
    int arrive;
    int burst;
    int priority;
    int start;
    int finish;
    int turnaround;
    float w_turn;
    int done;
} Process;

void fcfs(Process p[], int n) {
    printf("\n===== FCFS 调度结果 =====\n");
    int time = 0;
    for (int i = 0; i < n; i++) {
        if (time < p[i].arrive) time = p[i].arrive;
        p[i].start = time;
        p[i].finish = time + p[i].burst;
        p[i].turnaround = p[i].finish - p[i].arrive;
        p[i].w_turn = (float)p[i].turnaround / p[i].burst;
        time = p[i].finish;
    }
}

void sjf(Process p[], int n) {
    printf("\n===== SJF 调度结果 =====\n");
    int time = 0, count = 0;
    while (count < n) {
        int min = -1;
        for (int i = 0; i < n; i++) {
            if (p[i].arrive <= time && !p[i].done) {
                if (min == -1 || p[i].burst < p[min].burst) min = i;
            }
        }
        if (min == -1) { time++; continue; }
        p[min].start = time;
        p[min].finish = time + p[min].burst;
        p[min].turnaround = p[min].finish - p[min].arrive;
        p[min].w_turn = (float)p[min].turnaround / p[min].burst;
        p[min].done = 1;
        time = p[min].finish;
        count++;
    }
}

void print(Process p[], int n) {
    printf("进程\t到达\t服务\t开始\t完成\t周转\t带权周转\n");
    for (int i = 0; i < n; i++) {
        printf("%s\t%d\t%d\t%d\t%d\t%d\t%.2f\n",
               p[i].name, p[i].arrive, p[i].burst,
               p[i].start, p[i].finish, p[i].turnaround, p[i].w_turn);
    }
}

int main() {
    Process p[4] = {
        {"P1", 0, 4, 2},
        {"P2", 1, 3, 1},
        {"P3", 2, 5, 3},
        {"P4", 3, 2, 4}
    };
    int n = 4;

    fcfs(p, n);
    print(p, n);

    for (int i = 0; i < n; i++) p[i].done = 0;
    sjf(p, n);
    print(p, n);

    return 0;
}
