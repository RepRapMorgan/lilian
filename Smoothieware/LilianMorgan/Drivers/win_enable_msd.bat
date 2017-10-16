cd .. 
"Drivers\Patch\fnr.exe" --dir "%CD%" --cl --fileMask "config.*" --caseSensitive --find "msd_disable                                 true" --replace "#msd_disable                                 false"
pause
