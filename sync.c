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
