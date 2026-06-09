apt update && apt install -y build-essential vim gdb
sed -i 's@archive.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list
sed -i 's@security.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list
apt update && apt install -y build-essential
gcc --version
cat > scheduler.c << 'EOF'
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
EOF

gcc scheduler.c -o scheduler
./scheduler
# 一键生成 操作系统课程设计 4个模块全部代码
cat > scheduler.c << 'EOF'
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
        p[min].turnaround = p[min].finish - p[i].arrive;
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
    Process p[4] = {{"P1",0,4,2},{"P2",1,3,1},{"P3",2,5,3},{"P4",3,2,4}};
    int n = 4;
    fcfs(p,n);print(p,n);
    for(int i=0;i<n;i++) p[i].done=0;
    sjf(p,n);print(p,n);
    return 0;
}
EOF

cat > memory.c << 'EOF'
#include <stdio.h>
void lru(int pages[], int n, int frames) {
    int mem[frames], count=0, time=0;
    for(int i=0;i<frames;i++) mem[i]=-1;
    printf("\n===== LRU 页面置换 =====\n");
    for(int i=0;i<n;i++){
        int find=-1;
        for(int j=0;j<frames;j++) if(mem[j]==pages[i]) {find=j;break;}
        if(find==-1){
            count++;
            int replace=0, max=0;
            for(int j=0;j<frames;j++){
                int last=0;
                for(int k=i-1;k>=0;k--) {if(mem[j]==pages[k])break;last++;}
                if(last>max) {max=last;replace=j;}
            }
            mem[replace]=pages[i];
        }
        printf("页号%d: 内存[",pages[i]);
        for(int j=0;j<frames;j++) printf("%d ",mem[j]);
        printf("]\n");
    }
    printf("缺页次数：%d，缺页率：%.2f%%\n",count,(float)count/n*100);
}
int main(){
    int pages[]={1,3,2,4,1,3,5,1,3,2,3,4};
    int n=sizeof(pages)/sizeof(int);
    lru(pages,n,3);
    return 0;
}
EOF

cat > sync.c << 'EOF'
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#define N 5
int buffer[N],in=0,out=0;
sem_t empty,full;
pthread_mutex_t mutex;
void *producer(void *arg){
    for(int i=1;i<=10;i++){
        sem_wait(&empty);
        pthread_mutex_lock(&mutex);
        buffer[in]=i;
        printf("生产：%d，位置：%d\n",i,in);
        in=(in+1)%N;
        pthread_mutex_unlock(&mutex);
        sem_post(&full);
        sleep(1);
    }
    return NULL;
}
void *consumer(void *arg){
    for(int i=1;i<=10;i++){
        sem_wait(&full);
        pthread_mutex_lock(&mutex);
        int data=buffer[out];
        printf("消费：%d，位置：%d\n",data,out);
        out=(out+1)%N;
        pthread_mutex_unlock(&mutex);
        sem_post(&empty);
        sleep(2);
    }
    return NULL;
}
int main(){
    pthread_t p,c;
    sem_init(&empty,0,N);
    sem_init(&full,0,0);
    pthread_mutex_init(&mutex,NULL);
    pthread_create(&p,NULL,producer,NULL);
    pthread_create(&c,NULL,consumer,NULL);
    pthread_join(p,NULL);
    pthread_join(c,NULL);
    sem_destroy(&empty);
    sem_destroy(&full);
    pthread_mutex_destroy(&mutex);
    return 0;
}
EOF

cat > filesys.c << 'EOF'
#include <stdio.h>
#include <string.h>
#define MAX 10
struct File{char name[20];int size;int used;}files[MAX];
void create(char name[],int size){
    for(int i=0;i<MAX;i++){
        if(!files[i].used){
            strcpy(files[i].name,name);
            files[i].size=size;
            files[i].used=1;
            printf("创建成功：%s\n",name);
            return;
        }
    }
    printf("磁盘已满！\n");
}
void del(char name[]){
    for(int i=0;i<MAX;i++){
        if(files[i].used && !strcmp(files[i].name,name)){
            files[i].used=0;
            printf("删除成功：%s\n",name);
            return;
        }
    }
    printf("文件不存在\n");
}
void list(){
    printf("\n文件列表：\n");
    for(int i=0;i<MAX;i++) if(files[i].used) printf("%s\t%dKB\n",files[i].name,files[i].size);
}
int main(){
    for(int i=0;i<MAX;i++) files[i].used=0;
    create("report.pdf",1024);
    create("code.c",50);
    list();
    del("code.c");
    list();
    return 0;
}
EOF

echo "====================================="
echo "✅ 全部代码生成完成！"
echo "生成文件："
echo "1. scheduler.c  处理机调度"
echo "2. memory.c    内存管理"
echo "3. sync.c      进程同步"
echo "4. filesys.c   文件系统"
echo "====================================="
gcc scheduler.c -o scheduler && ./scheduler
gcc memory.c -o memory && ./memory
gcc sync.c -o sync -pthread && ./sync
gcc filesys.c -o filesys && ./filesys
sed -i 's/p\[i\].arrive/p\[min\].arrive/' scheduler.c
gcc scheduler.c -o scheduler && ./scheduler
cat > scheduler.c << 'EOF'
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
EOF

gcc scheduler.c -o scheduler && ./scheduler
gcc memory.c -o memory && ./memory
gcc sync.c -o sync -pthread && ./sync
gcc filesys.c -o filesys && ./filesys
# ==========================
# 最终版 处理机调度（FCFS+SJF+RR+优先级）
# ==========================
cat > scheduler_final.c << 'EOF'
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
EOF

# ==========================
# 最终版 内存管理（FIFO+LRU+FF+BF）
# ==========================
cat > memory_final.c << 'EOF'
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
EOF

# ==========================
# 最终版 进程同步（3个问题全齐）
# ==========================
cat > sync_all.c << 'EOF'
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#include <stdlib.h>

//============= 生产者消费者 =============
#define N5 5
int buf5[N5], in5=0, out5=0;
sem_t empty5, full5;
pthread_mutex_t mutex5;

void *p5(void *a) {
    for(int i=1;i<=5;i++) {
        sem_wait(&empty5);
        pthread_mutex_lock(&mutex5);
        buf5[in5]=i; printf("生产:%d\n",i);
        in5=(in5+1)%N5;
        pthread_mutex_unlock(&mutex5);
        sem_post(&full5); sleep(1);
    }
    return NULL;
}
void *c5(void *a) {
    for(int i=1;i<=5;i++) {
        sem_wait(&full5);
        pthread_mutex_lock(&mutex5);
        int d=buf5[out5]; printf("消费:%d\n",d);
        out5=(out5+1)%N5;
        pthread_mutex_unlock(&mutex5);
        sem_post(&empty5); sleep(2);
    }
    return NULL;
}

//============= 读者写者 =============
pthread_rwlock_t rwlock;
void *r(void *a) {
    int id=*(int*)a;
    pthread_rwlock_rdlock(&rwlock);
    printf("读者%d读\n",id); sleep(1);
    pthread_rwlock_unlock(&rwlock);
    return NULL;
}
void *w(void *a) {
    int id=*(int*)a;
    pthread_rwlock_wrlock(&rwlock);
    printf("写者%d写\n",id); sleep(2);
    pthread_rwlock_unlock(&rwlock);
    return NULL;
}

//============= 哲学家进餐（防死锁）=============
#define Np 5
pthread_mutex_t forkp[Np];
void *philo(void *a) {
    int id=*(int*)a;
    int L=id, R=(id+1)%Np;
    if(id==Np-1) {int t=L;L=R;R=t;}
    printf("哲学家%d思考\n",id); sleep(1);
    pthread_mutex_lock(&forkp[L]);
    pthread_mutex_lock(&forkp[R]);
    printf("哲学家%d吃饭\n",id); sleep(2);
    pthread_mutex_unlock(&forkp[R]);
    pthread_mutex_unlock(&forkp[L]);
    printf("哲学家%d结束\n",id);
    return NULL;
}

int main() {
    printf("===== 生产者消费者 =====\n");
    pthread_t pt,ct;
    sem_init(&empty5,0,N5); sem_init(&full5,0,0);
    pthread_mutex_init(&mutex5,NULL);
    pthread_create(&pt,NULL,p5,NULL);
    pthread_create(&ct,NULL,c5,NULL);
    pthread_join(pt,NULL); pthread_join(ct,NULL);

    printf("\n===== 读者写者 =====\n");
    pthread_rwlock_init(&rwlock,NULL);
    pthread_t r1,r2,w1; int a1=1,a2=2,a3=1;
    pthread_create(&r1,NULL,r,&a1);
    pthread_create(&r2,NULL,r,&a2);
    pthread_create(&w1,NULL,w,&a3);
    pthread_join(r1,NULL); pthread_join(r2,NULL); pthread_join(w1,NULL);

    printf("\n===== 哲学家进餐 =====\n");
    pthread_t pid[Np]; int id[Np];
    for(int i=0;i<Np;i++) pthread_mutex_init(&forkp[i],NULL);
    for(int i=0;i<Np;i++) {id[i]=i; pthread_create(&pid[i],NULL,philo,&id[i]);}
    for(int i=0;i<Np;i++) pthread_join(pid[i],NULL);
    return 0;
}
EOF

# ==========================
# 最终版 文件系统（创建+读写+删除+空闲管理）
# ==========================
cat > filesys_final.c << 'EOF'
#include <stdio.h>
#include <string.h>
#define MAX 10
#define FREE 0
#define USED 1

typedef struct {
    char name[20];
    char content[100];
    int size;
    int state;
} File;

File disk[MAX];

void init() {for(int i=0;i<MAX;i++) disk[i].state=FREE;}
int findFree() {for(int i=0;i<MAX;i++) if(disk[i].state==FREE) return i; return -1;}

void create(char *name, int size) {
    int i=findFree();
    if(i==-1) {printf("磁盘满\n"); return;}
    strcpy(disk[i].name,name); disk[i].size=size; disk[i].state=USED;
    printf("创建:%s\n",name);
}

void write(char *name, char *data) {
    for(int i=0;i<MAX;i++) {
        if(disk[i].state==USED && !strcmp(disk[i].name,name)) {
            strcpy(disk[i].content,data);
            printf("写入成功\n"); return;
        }
    }
}

void del(char *name) {
    for(int i=0;i<MAX;i++) {
        if(disk[i].state==USED && !strcmp(disk[i].name,name)) {
            disk[i].state=FREE; printf("删除:%s\n",name); return;
        }
    }
}

void list() {
    printf("\n文件列表：\n");
    for(int i=0;i<MAX;i++) {
        if(disk[i].state==USED)
            printf("%s size:%d content:%s\n",
                   disk[i].name,disk[i].size,disk[i].content);
    }
}

int main() {
    init();
    create("report.pdf",1024);
    write("report.pdf","操作系统课程设计");
    create("code.c",50);
    write("code.c","#include ...");
    list();
    del("code.c");
    list();
    return 0;
}
EOF

echo "
=============================================
✅ 【最终完整版】全部生成完成！
文件清单：
1. scheduler_final.c   调度（4种算法+动态输入）
2. memory_final.c      内存（FIFO/LRU/FF/BF）
3. sync_all.c          同步（3大问题全齐+防死锁）
4. filesys_final.c     文件系统（增删读写+空闲管理）
=============================================
"
gcc scheduler_final.c -o s && ./s
gcc memory_final.c -o m && ./m
gcc sync_all.c -o sync -pthread && ./sync
gcc filesys_final.c -o f && ./f
cat > sync_all.c << 'EOF'
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#include <stdlib.h>

//============= 生产者消费者 =============
#define N5 5
int buf5[N5], in5=0, out5=0;
sem_t empty5, full5;
pthread_mutex_t mutex5;

void *p5(void *a) {
    for(int i=1;i<=5;i++) {
        sem_wait(&empty5);
        pthread_mutex_lock(&mutex5);
        buf5[in5]=i; printf("生产:%d\n",i);
        in5=(in5+1)%N5;
        pthread_mutex_unlock(&mutex5);
        sem_post(&full5); sleep(1);
    }
    return NULL;
}
void *c5(void *a) {
    for(int i=1;i<=5;i++) {
        sem_wait(&full5);
        pthread_mutex_lock(&mutex5);
        int d=buf5[out5]; printf("消费:%d\n",d);
        out5=(out5+1)%N5;
        pthread_mutex_unlock(&mutex5);
        sem_post(&empty5); sleep(1);
    }
    return NULL;
}

//============= 读者写者（多读者+多写者用例）=============
pthread_rwlock_t rwlock;

void *reader(void *a) {
    int id=*(int*)a;
    pthread_rwlock_rdlock(&rwlock);
    printf("读者%d 开始读\n",id);
    sleep(2); // 延长读取时间，方便观察并发
    printf("读者%d 读完\n",id);
    pthread_rwlock_unlock(&rwlock);
    return NULL;
}

void *writer(void *a) {
    int id=*(int*)a;
    pthread_rwlock_wrlock(&rwlock);
    printf("写者%d 开始写\n",id);
    sleep(2); // 延长写入时间，方便观察独占
    printf("写者%d 写完\n",id);
    pthread_rwlock_unlock(&rwlock);
    return NULL;
}

//============= 哲学家进餐（防死锁）=============
#define Np 5
pthread_mutex_t forkp[Np];
void *philo(void *a) {
    int id=*(int*)a;
    int L=id, R=(id+1)%Np;
    if(id==Np-1) {int t=L;L=R;R=t;} // 最后一位反向拿叉子防死锁
    printf("哲学家%d 思考\n",id); sleep(1);
    pthread_mutex_lock(&forkp[L]);
    pthread_mutex_lock(&forkp[R]);
    printf("哲学家%d 吃饭\n",id); sleep(2);
    pthread_mutex_unlock(&forkp[R]);
    pthread_mutex_unlock(&forkp[L]);
    printf("哲学家%d 结束\n",id);
    return NULL;
}

int main() {
    printf("===== 生产者消费者 =====\n");
    pthread_t pt,ct;
    sem_init(&empty5,0,N5); sem_init(&full5,0,0);
    pthread_mutex_init(&mutex5,NULL);
    pthread_create(&pt,NULL,p5,NULL);
    pthread_create(&ct,NULL,c5,NULL);
    pthread_join(pt,NULL); pthread_join(ct,NULL);

    printf("\n===== 读者写者（多读者+多写者用例）=====\n");
    pthread_rwlock_init(&rwlock,NULL);
    pthread_t r1,r2,r3,r4,w1,w2;
    int a1=1,a2=2,a3=3,a4=4,b1=1,b2=2;
    // 同时创建多个读者和写者，观察执行顺序
    pthread_create(&r1,NULL,reader,&a1);
    pthread_create(&r2,NULL,reader,&a2);
    pthread_create(&w1,NULL,writer,&b1);
    pthread_create(&r3,NULL,reader,&a3);
    pthread_create(&w2,NULL,writer,&b2);
    pthread_create(&r4,NULL,reader,&a4);
    pthread_join(r1,NULL); pthread_join(r2,NULL);
    pthread_join(r3,NULL); pthread_join(r4,NULL);
    pthread_join(w1,NULL); pthread_join(w2,NULL);

    printf("\n===== 哲学家进餐 =====\n");
    pthread_t pid[Np]; int id[Np];
    for(int i=0;i<Np;i++) pthread_mutex_init(&forkp[i],NULL);
    for(int i=0;i<Np;i++) {id[i]=i; pthread_create(&pid[i],NULL,philo,&id[i]);}
    for(int i=0;i<Np;i++) pthread_join(pid[i],NULL);
    return 0;
}
EOF

gcc sync_all.c -o sync -pthread && ./sync
