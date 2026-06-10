#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

#define NUM 20

pthread_mutex_t mutex;
int buf = 0;

void *producer(void *arg) {
    pthread_mutex_lock(&mutex);
    buf++;
    printf("生产：%d\n", buf);
    pthread_mutex_unlock(&mutex);
    return NULL;
}

void *consumer(void *arg) {
    pthread_mutex_lock(&mutex);
    buf--;
    printf("消费：%d\n", buf);
    pthread_mutex_unlock(&mutex);
    return NULL;
}

int main() {
    pthread_t pro[NUM], con[NUM];
    pthread_mutex_init(&mutex, NULL);

    printf("\n===== 高并发压力测试（20生产者+20消费者）=====\n");
    int i;
    for (i = 0; i < NUM; i++) {
        pthread_create(&pro[i], NULL, producer, NULL);
        pthread_create(&con[i], NULL, consumer, NULL);
    }

    for (i = 0; i < NUM; i++) {
        pthread_join(pro[i], NULL);
        pthread_join(con[i], NULL);
    }

    printf("最终缓冲值：%d\n", buf);
    pthread_mutex_destroy(&mutex);
    return 0;
}
