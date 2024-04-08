@echo off
:: 处理相册gallery
cd /d "F:\L0223\L0223.github.io\myblog\source\images"
call "run-node-app.bat"
echo "run-node-app.bat has been executed."

pause

::复制粘贴至photos

cd /d "F:\L0223\L0223.github.io\myblog\source"

:: 定义要删除的photos中的文件路径
SET "FILE_PATH_1=photos\photos.json"

:: 定义要复制的文件路径和目标路径
SET "SOURCE_FILE_PATH=images\gallery\photos.json"
SET "TARGET_FILE_PATH=photos\photos.json"

:: 删除子文件夹photos中的一个文件
del "%FILE_PATH_1%" 2>nul
if not exist "%FILE_PATH_1%" (
    echo The file %FILE_PATH_1% has been deleted successfully.
) else (
    echo The file %FILE_PATH_1% was not found or could not be deleted.
)

:: 将images/gallery/中的文件复制到photos中
copy "%SOURCE_FILE_PATH%" "%TARGET_FILE_PATH%" /y
if not exist "%TARGET_FILE_PATH%" (
    echo Failed to copy the file from subfolder1 to subfolder2.
    goto End
) else (
    echo The file has been copied successfully from subfolder1 to subfolder2.
)

pause