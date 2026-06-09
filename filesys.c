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
