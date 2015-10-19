loop() {
    for i in `cat file`; do
	pushd $i
	pwd
	popd
    done
}

func() {
    tar cf test.tar testdir
}

untar() {
    pushd $1
    pwd
    ls
    mkdir tmp
    cd tmp
    gtar -zxf ../*.tar.gz
}
