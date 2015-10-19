# This dir: cd ~/berry/bbasaran/regression.test/
# see ./BENCHMARK for issues and manual fixes

# see MCP/cmd.sh
# NOTE: in bash functions, variables are in global scope/namespace!!

loop() {
    file=MCP/benchmarks
    for root in `cat $file`; do
        echo "Benchmark: $root"
        #ls -l $root
        cell=`cat MCP/$root/BENCHMARK_CELL`
        lib=`cat MCP/$root/BENCHMARK_LIB`
        view REF/$root $cell $lib
        view MCP/$root $cell $lib
        if [ "1" == "0" ]; then
            ln -s /berry/secure18/m1119/bbasaran/regression.test/MCP/$root/BENCHMARK_CELL ./REF/$root/
            ln -s /berry/secure18/m1119/bbasaran/regression.test/MCP/$root/BENCHMARK_LIB  ./REF/$root/
        fi
        #ls -d ./REF/$root
        #ls -d ./MCP/$root
        #diff ./REF/$root/BENCHMARK_CELL ./MCP/$root/BENCHMARK_CELL
        #diff ./REF/$root/BENCHMARK_LIB  ./MCP/$root/BENCHMARK_LIB
    done
}

view() {
    path=$1/output
    cell=$2
    lib=$3
    ls -d $path/libs/$lib/$cell
    info=$path/$cell/$cell.cellinfo
    grep layout $info
}
