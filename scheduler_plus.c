#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 100

typedef struct {
    char name[10];
    int arrive;
    int burst;
    int start;
    int finish;
    int turn;
    float w_turn;
    int rest;
} Proc;

// 动态时间片计算（核心优化点）
int get_dynamic_slice(Proc p) {
    int base = 2;
    return base + (p.burst / 5);
}

// 动态时间片轮转
void dynamic_rr(Proc p[], int n) {
    printf("\n===== 动态时间片轮转调度（优化版）=====\n");
    int i, time = 0, count = 0;
    int slice;

    while (count < n) {
        int exec = 0;
        for (i = 0; i < n; i++) {
            if (p[i].arrive <= time && p[i].rest > 0) {
                exec = 1;
                slice = get_dynamic_slice(p[i]);

                if (p[i].rest <= slice) {
                    time += p[i].rest;
                    p[i].finish = time;
                    p[i].turn = p[i].finish - p[i].arrive;
                    p[i].w_turn = (float)p[i].turn / p[i].burst;
                    p[i].rest = 0;
                    count++;
                } else {
                    time += slice;
                    p[i].rest -= slice;
                }
            }
        }
        if (!exec) time++;
    }

    float avg_t = 0, avg_w = 0;
    for (i = 0; i < n; i++) {
        printf("%s\t%d\t%d\t%d\t%d\t%.2f\n",
               p[i].name, p[i].arrive, p[i].burst, p[i].turn, p[i].finish, p[i].w_turn);
        avg_t += p[i].turn;
        avg_w += p[i].w_turn;
    }
    printf("平均周转时间：%.2f\n", avg_t / n);
    printf("平均带权周转时间：%.2f\n", avg_w / n);
}

// 自动生成随机进程
void auto_test() {
    printf("\n===== 自动性能测试（10个进程）=====\n");
    Proc p[10];
    int i;
    for (i = 0; i < 10; i++) {
        sprintf(p[i].name, "P%d", i);
        p[i].arrive = rand() % 10;
        p[i].burst = rand() % 10 + 1;
        p[i].rest = p[i].burst;
    }
    dynamic_rr(p, 10);
}

int main() {
    auto_test();
    return 0;
}
