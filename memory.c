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
