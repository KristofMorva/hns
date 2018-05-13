del games_mp.log
del console_mp.log
del missingasset.csv
del mod.ff

xcopy animtrees ..\..\raw\animtrees /SY
xcopy ui ..\..\raw\ui /SY
xcopy ui_mp ..\..\raw\ui_mp /SY
xcopy mp ..\..\raw\mp /SY
xcopy maps ..\..\raw\maps /SY
xcopy english ..\..\raw\english /SY
xcopy shock ..\..\raw\shock /SY
xcopy soundaliases ..\..\raw\soundaliases /SY
xcopy sound ..\..\raw\sound /SY
xcopy xmodel ..\..\raw\xmodel /SY
xcopy xmodelparts ..\..\raw\xmodelparts /SY
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SY
xcopy weapons ..\..\raw\weapons /SY
xcopy vision ..\..\raw\vision /SY
xcopy fx ..\..\raw\fx /SY
copy /Y mod.csv ..\..\zone_source
copy /Y -mod.csv ..\..\zone_source\english\assetlist
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd ..\mods\ModWarfare
copy ..\..\zone\english\mod.ff

copy /Y mod.ff ..\hns