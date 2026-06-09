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
