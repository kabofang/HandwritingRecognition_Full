#include<stdio.h>
#define DIM 28
int main(int argc, char* argv[]) {
	if (argc != 2) {
		printf("Useage:command **.bmp");
		return -1;
	}
	FILE* fp;
	if (!(fp = fopen(argv[1], "r"))) {
		printf("bmp file open fail!");
		return -1;
	}
	char byte[4];
	double bmp[DIM][DIM];
	char mask = 1;
	double result[1] = { -1 };
	fseek(fp, 62, SEEK_SET);
	for (int i = DIM-1; i >= 0; i--) {
		byte[0] = getc(fp);
		byte[1] = getc(fp);
		byte[2]=getc(fp); 
		byte[3]=getc(fp);
		for (int j = 0; j < 3; j++)
			for (int k = 0; k <8; k++)
				bmp[i][j * 8 + k] = (byte[j] >> (7 - k)) & mask;
		for (int k = 0; k < 4; k++)
			bmp[i][3 * 8 + k] = (byte[3] >> (7 - k)) & mask;
	}
	FILE* fout = fopen("..\\IO\\ret", "w");
	for (int i = 0; i < DIM; i++)
		for (int j = 0; j < DIM; j++)
			fputc('0' + bmp[i][j], fout);
	fclose(fout);
	return 0;
}