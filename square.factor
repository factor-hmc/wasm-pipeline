USING: accessors alien.c-types alien.data arrays destructors kernel
llvm.ffi llvm.wrappers sequences prettyprint ;
IN: llvm-square-example

! Adapted from the example in llvm.examples.sumfunc

: add-function ( module name type -- value )
    [ value>> ] 2dip LLVMAddFunction ;

: dump-module ( module -- )
    value>> LLVMDumpModule ;

: create-square-type ( -- type )
    LLVMInt32Type LLVMInt32Type 1array
    [ void* >c-array ] [ length ] bi 0 LLVMFunctionType ;

: create-square-body ( square -- )
    dup <builder> [
        value>>
        ! square builder
        swap dupd
        [ 0 LLVMGetParam ] [ 0 LLVMGetParam ] bi
        "tmp" LLVMBuildMul
        LLVMBuildRet drop
    ] with-disposal ;

: create-square-function ( -- )
    "test_module" <module> [
        [ "square" create-square-type add-function create-square-body ]
        [ verify-module ] [ dump-module ] tri
    ] with-disposal ;

MAIN: create-square-function
