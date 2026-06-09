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
