cd ..
"Drivers\Patch\fnr.exe" --dir "%CD%" --cl --fileMask "config.*" --caseSensitive --find "#msd_disable                                 false" --replace "msd_disable                                 true"
pause
