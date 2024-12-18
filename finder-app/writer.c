#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>

int main(int argc, char* argv[]){
	
	char* fullfilepath;
	char* writestr;
	FILE* fp;
	
	//check if args are less than 2
	if(argc < 2)
		return 1;
	
	
	//full path to a file (including filename)
	fullfilepath = argv[1];
	writestr = argv[2];
	
	//assignment tells us to assume directories are already created
	
	//now open file and write to it
	fp = fopen(fullfilepath, "r+");
	if(!fp)
		return 1;
		
	fprintf(fp, writestr);
	
	fclose(fp);
	
	
	
	return 0;
}
