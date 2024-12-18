#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>

int main(int argc, char* argv[]){
	
	char* fullfilepath;
	char* writestr;
	FILE* fp;
	
	openlog("aeld", LOG_PID | LOG_CONS, LOG_USER);
	syslog(LOG_INFO, "Syslog started");

	
	//check if args are less than 2
	if(argc < 3){
		syslog(LOG_ERR, "Arguments are less than expected");
		return 1;
	}
	
	//full path to a file (including filename)
	fullfilepath = argv[1];
	writestr = argv[2];
	
	//assignment tells us to assume directories are already created
	
	//now open file and write to it
	fp = fopen(fullfilepath, "w+");
	if(!fp){
		syslog(LOG_ERR, "Cannot open the file");
		return 1;
	}
		
	fprintf(fp, "%s", writestr);
	
	
	syslog(LOG_INFO, "Performing cleanup before exit...");
	fclose(fp);
	closelog();
	
	
	
	return 0;
}
