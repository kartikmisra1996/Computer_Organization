extern int MAX_2(int x, int y);

int main(void)
{
	int a[5] = {100, 20, 3, 4, 5};
	int max_val = a[0];
	int i;

	for(i=1;i<sizeof(a)/sizeof(a[0]); i++){
		if(MAX_2(a[i], a[i-1])> max_val){
			max_val= MAX_2(a[i], a[i-1]);
		}
	}
	return max_val;
}
