SQL> l
  1* select to_char((trunc(sysdate)+level/24),'hh24:mi') , level from dual connect by level <= 24
SQL> /

TO_CH      LEVEL                                                                
----- ----------                                                                
01:00          1                                                                
02:00          2                                                                
03:00          3                                                                
04:00          4                                                                
05:00          5                                                                
06:00          6                                                                
07:00          7                                                                
08:00          8                                                                
09:00          9                                                                
10:00         10                                                                
11:00         11                                                                

TO_CH      LEVEL                                                                
----- ----------                                                                
12:00         12                                                                
13:00         13                                                                
14:00         14                                                                
15:00         15                                                                
16:00         16                                                                
17:00         17                                                                
18:00         18                                                                
19:00         19                                                                
20:00         20                                                                
21:00         21                                                                
22:00         22                                                                

TO_CH      LEVEL                                                                
----- ----------                                                                
23:00         23                                                                
00:00         24                                                                

24 linhas selecionadas.

SQL> spool off;
