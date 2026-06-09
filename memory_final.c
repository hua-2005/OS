#include <stdio.h>
#include <string.h>
#define MAX 10

typedef struct {int size, used;} Block;
Block mem[MAX];
int mcnt=0;

void ff(int size) {
    for(int i=0;i<mcnt;i++){
        if(!mem[i].used && mem[i].size>=size) {
            mem[i].used=1;
            printf("FF分配成功：大小=%d\n", size);
            return;
        }
    }
    mem[mcnt].size=size; mem[mcnt++].used=1;
    printf("FF分配新块：%d\n", size);
}

void bf(int size) {
    int sel=-1, min=9999;
    for(int i=0;i<mcnt;i++){
        if(!mem[i].used && mem[i].size>=size && mem[i].size<min) {
            min=mem[i].size; sel=i;
        }
    }
    if(sel!=-1) {mem[sel].used=1; printf("BF分配成功\n"); return;}
    mem[mcnt].size=size; mem[mcnt++].used=1; printf("BF分配新块\n");
}

void fifo(int pages[], int n, int f) {
    int frame[f], idx=0, cnt=0;
    memset(frame,-1,sizeof(frame));
    printf("\n===== FIFO页面置换 =====\n");
    for(int i=0;i<n;i++) {
        int find=0;
        for(int j=0;j<f;j++) if(frame[j]==pages[i]) find=1;
        if(!find) {
            cnt++; frame[idx]=pages[i]; idx=(idx+1)%f;
        }
        printf("页%d: ",pages[i]);
        for(int j=0;j<f;j++) printf("%d ",frame[j]);
        printf("\n");
    }
    printf("缺页:%d 缺页率:%.2f\n",cnt,(float)cnt/n*100);
}

void lru(int pages[], int n, int f) {
    int frame[f], cnt=0;
    int time[f], clk=0;
    memset(frame,-1,sizeof(frame));
    memset(time,-1,sizeof(time));
    printf("\n===== LRU页面置换 =====\n");
    for(int i=0;i<n;i++) {
        int find=-1;
        for(int j=0;j<f;j++) if(frame[j]==pages[i]) find=j;
        if(find==-1) {
            cnt++;
            int rep=0;
            for(int j=1;j<f;j++) if(time[j]<time[rep]) rep=j;
            frame[rep]=pages[i]; time[rep]=clk++;
        } else time[find]=clk++;
        printf("页%d: ",pages[i]);
        for(int j=0;j<f;j++) printf("%d ",frame[j]);
        printf("\n");
    }
    printf("缺页:%d 缺页率:%.2f\n",cnt,(float)cnt/n*100);
}

int main() {
    printf("===== 动态分区分配 =====\n");
    ff(10); ff(20); bf(15);
    printf("===== 页面置换 =====\n");
    int pages[]={1,3,2,4,1,3,5,1,3,2,3,4};
    int n=sizeof(pages)/sizeof(int);
    fifo(pages,n,3);
    lru(pages,n,3);
    return 0;
}
