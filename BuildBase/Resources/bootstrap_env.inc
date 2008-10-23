ROOT=
bootstrapBase=${ROOT}/Programs/Bootstrap
bootstrapVersion=1.0
bootstrapDest=${bootstrapBase}/${bootstrapVersion}

export PATH=${bootstrapDest}/bin:${bootstrapScriptsDir}/tmptools/bin:${ROOT}/Programs/Scripts/Current/bin${PATH:+:$PATH}
export LD_LIBRARY_PATH=${bootstrapDest}/lib:${bootstrapScriptsDir}/tmptools/lib:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
