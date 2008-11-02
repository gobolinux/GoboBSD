export ROOT=
export bootstrapBase=${ROOT}/Programs/Bootstrap
export bootstrapVersion=1.0
export bootstrapDest=${bootstrapBase}/${bootstrapVersion}
export archivesDir=${ROOT}/Files/Compile/Archives
export sourcesDir=${ROOT}/Files/Compile/Sources

export PATH=${bootstrapDest}/bin:${ROOT}/Programs/Scripts/Current/bin${PATH:+:$PATH}
export LD_LIBRARY_PATH=${bootstrapDest}/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
