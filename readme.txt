Fetch public JSON 
as arguments to the program and to look up all 
information related to the IOC(s) and provide 
the information in an user-friendly fashion.
Run Instruction
1.Download the zip and extract it. 

2. open test.rb and update the path in line number 9 to direct it to current honeyput.json file
3. 
open command prompt and go to project directory
	run command “gem install bundler” you might need sudo for permission rights
4. 
It will install all gems like rest-client and add dependencies like mime-types. 
Details in test.rb
5. once gems are install you can run the script 
	“ruby test.rb arg1 arg2 arg3 …” #arg1,arg2,arg3.. can be port
,url,IP,source,etc. 
