rem change to the server directory
cd server
echo starting lua code server
echo http doesn't work because of TCP/IP Bugs in eLUA
start /MIN lua e2srv.lua
rem echo start a log server in order to get the output of print routet to the server
rem start /MIN lua e2log.lua
cd ..
cd editor
echo start ruby web server for the editor
echo sinatra is great. A few lines of code for such a great functionality
start /MIN cmd /c "c:\Program Files (x86)\Ruby192\bin\ruby.exe" -rubygems webdevice.rb
cd ..
