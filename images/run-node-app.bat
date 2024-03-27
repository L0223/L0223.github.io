@echo off
cd /d "F:\L0223\L0223.github.io\myblog\source\images"

:: 定义要删除的子文件夹1中的文件路径
SET "FILE_PATH_1=gallery\photos.json"
SET "FILE_PATH_2=gallery\photosInfo.json"

:: 删除第一个文件
del "%FILE_PATH_1%" 2>nul
if not exist "%FILE_PATH_1%" (
    echo The file %FILE_PATH_1% has been deleted successfully.
) else (
    echo The file %FILE_PATH_1% was not found or could not be deleted.
)

:: 删除第二个文件
del "%FILE_PATH_2%" 2>nul
if not exist "%FILE_PATH_2%" (
    echo The file %FILE_PATH_2% has been deleted successfully.
) else (
    echo The file %FILE_PATH_2% was not found or could not be deleted.
)

node "gallery\create.js"
pause