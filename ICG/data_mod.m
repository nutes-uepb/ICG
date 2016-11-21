dos('copy Device_0_Volts.xls Device_0_Volts_.xls');
dos('ren Device_0_Volts.xls data.txt');
%wholefile = fileread('data.txt');
%newfiledata = strrep(wholefile,',','.');
%newfiledata = strrep(newfiledata,'E-3','');
%fileid = fopen('data.txt','w');  
%fprintf(fileid,'%s',newfiledata);
A = txt2mat('data.txt','ReplaceChar',{',','.'}  ,'NumericType','double');
format long
Z = A(1:end,1);
ECG = A(1:end,2);
dos('ren Device_0_Volts_.xls Device_0_Volts.xls');
dos('del data.txt');
%clear('A', 'ans', 'fileid', 'wholefile', 'newfiledata');
fclose('all');