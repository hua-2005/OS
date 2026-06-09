#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
    int rem;
} Process;

void fcfs(Process p[], int n) {
    printf("\n===== FCFS 调度 =====\n");
    int time = 0;
    for (int i=0;i<n;i++) {
        if (time < p[i].arrive) time = p[i].arrive;
        p[i].start = time;
        p[i].finish = time + p[i].burst;
        p[i].turnaround = p[i].finish - p[i].arrive;
        p[i].w_turn = (float)p[i].turnaround / p[i].burst;
        time = p[i].finish;
    }
}

void sjf(Process p[], int n) {
    printf("\n===== SJF 调度 =====\n");
    int time=0, cnt=0;
    while(cnt<n) {
        int sel=-1;
        for(int i=0;i<n;i++) {
            if(p[i].arrive<=time && !p[i].done) {
                if(sel==-1 || p[i].burst < p[sel].burst) sel=i;
            }
        }
        if(sel==-1) {time++; continue;}
        p[sel].start = time;
        p[sel].finish = time + p[sel].burst;
        p[sel].turnaround = p[sel].finish - p[sel].arrive;
        p[sel].w_turn = (float)p[sel].turnaround/p[sel].burst;
        p[sel].done=1; time=p[sel].finish; cnt++;
    }
}

void priority(Process p[], int n) {
    printf("\n===== 优先级调度(小值优先) =====\n");
    int time=0, cnt=0;
    while(cnt<n) {
        int sel=-1;
        for(int i=0;i<n;i++) {
            if(p[i].arrive<=time && !p[i].done) {
                if(sel==-1 || p[i].priority < p[sel].priority) sel=i;
            }
        }
        if(sel==-1) {time++; continue;}
        p[sel].start=time;
        p[sel].finish=time+p[sel].burst;
        p[sel].turnaround=p[sel].finish-p[sel].arrive;
        p[sel].w_turn=(float)p[sel].turnaround/p[sel].burst;
        p[sel].done=1; time=p[sel].finish; cnt++;
    }
}

void rr(Process p[], int n, int slice) {
    printf("\n===== RR 时间片轮转(片长=%d) =====\n", slice);
    int time=0, cnt=0;
    for(int i=0;i<n;i++) p[i].rem = p[i].burst;
    while(1) {
        int done=1;
        for(int i=0;i<n;i++) {
            if(p[i].rem>0 && p[i].arrive<=time) {
                done=0;
                if(p[i].rem == p[i].burst) p[i].start=time;
                if(p[i].rem > slice) {
                    time+=slice; p[i].rem-=slice;
                } else {
                    time+=p[i].rem; p[i].rem=0;
                    p[i].finish=time;
                    p[i].turnaround=p[i].finish-p[i].arrive;
                    p[i].w_turn=(float)p[i].turnaround/p[i].burst;
                    cnt++;
                }
            }
        }
        if(done) break;
    }
}

void print(Process p[], int n) {
    printf("进程\t到达\t服务\t优先级\t开始\t完成\t周转\t带权周转\n");
    for(int i=0;i<n;i++) {
        printf("%s\t%d\t%d\t%d\t%d\t%d\t%d\t%.2f\n",
               p[i].name,p[i].arrive,p[i].burst,p[i].priority,
               p[i].start,p[i].finish,p[i].turnaround,p[i].w_turn);
    }
}

void reset(Process p[], int n) {
    for(int i=0;i<n;i++) {
        p[i].start=p[i].finish=p[i].turnaround=p[i].done=p[i].rem=0;
        p[i].w_turn=0;
    }
}

int main() {
    int n, slice;
    printf("请输入进程数：");
    scanf("%d", &n);
    Process p[n];
    for(int i=0;i<n;i++) {
        printf("进程 %d 到达时间 服务时间 优先级：", i+1);
        sprintf(p[i].name, "P%d", i+1);
        scanf("%d%d%d", &p[i].arrive, &p[i].burst, &p[i].priority);
    }
    printf("请输入RR时间片大小：");
    scanf("%d", &slice);

    fcfs(p,n); print(p,n); reset(p,n);
    sjf(p,n); print(p,n); reset(p,n);
    priority(p,n); print(p,n); reset(p,n);
    rr(p,n,slice); print(p,n);
    return 0;
}
