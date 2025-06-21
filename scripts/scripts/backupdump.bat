@echo off
SET PATH=%PATH%;C:\oraclexe\app\oracle\product\11.2.0\server\bin
SET ORACLE_SID=xe
SET HNAME=%hostname%
SET BASE_FOLDER="c:\oraclexe\app\oracle\product\11.2.0\admin\%ORACLE_SID%\dpdump"
SET DUMPFILE_FOLDER="c:\oraclexe\app\oracle\product\11.2.0\admin\%ORACLE_SID%\dpdump"
SET ARCHIVE_PROGRAM="C:\Program Files\7-Zip\7z.exe"

echo %HNAME%
SET DD=%date:~0,2%
SET MM=%date:~3,2%
SET YYYY=%date:~6,4%
SET T=%TIME: =0%
SET EXPORTDATE=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2% %T:~0,2%%T:~3,2%00

SET BASE_NAME=%YYYY%%MM%%DD%_%HNAME%_%ORACLE_SID%_fullexp
SET DUMPFILE_NAME=%BASE_NAME%.dmp
SET LOGFILE_NAME=%BASE_NAME%.log
SET BACKUP_FOLDER=%BASE_FOLDER%
SET BACKUP_FILENAME=%BASE_NAME%.zip

REM Script begin
REM expdp, full backup to "dpdir", flashback_time=systimestamp for consistency
expdp '/ as sysdba' full=y directory=DATA_PUMP_DIR dumpfile=%DUMPFILE_NAME% logfile=%LOGFILE_NAME% flashback_time=SYSTIMESTAMP
IF %ERRORLEVEL% NEQ 0 GOTO ERROR


%ARCHIVE_PROGRAM% a -tzip %BACKUP_FOLDER%\%BACKUP_FILENAME% %DUMPFILE_FOLDER%\%DUMPFILE_NAME% %DUMPFILE_FOLDER%\%LOGFILE_NAME%
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

DEL %DUMPFILE_FOLDER%\%DUMPFILE_NAME%
DEL %DUMPFILE_FOLDER%\%LOGFILE_NAME%

EXIT 0

:ERROR
EXIT 1