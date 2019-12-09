int main(void)
{
	int a[5] = {1, 20, 3, 4, 5};
	int max_val = a[0];
	int i;

		for(i=1;i<sizeof(a)/sizeof(a[0]); i++){
			if(a[i]>max_val){
				max_val = a[i];
			}
		}
		return max_val;
}
