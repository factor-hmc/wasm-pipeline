# wasm-pipeline
test of compilation to wasm through llvm

# Included Files

All of the files here can be generated from the singular Factor file, except for the `html` file. They are included as references.

# Compiling From Scratch

Thanks to [this page](https://dassur.ma/things/c-to-webassembly/) for help with compilation.

1. Make some changes to the LLVM FFI for Factor. The first is sort of a hack, the second can be rolled 
into a PR to improve the FFI (so you may not need to do it).

If on MacOS, change the prelude to accommodate your location of the LLVM dynamic library

```forth
<< "llvm" {
    { [ os linux? ] [ "LLVM-3.9" find-so [ cdecl add-library ] [ drop ] if* ] }
    { [ os macosx? ] [ "/usr/local/opt/llvm/lib/libLLVM.dylib" cdecl add-library ] }
    [ drop ]
} cond
>>
```

Add the following code to the FFI near the `! Builders` section so you have the multiply function.

```forth
! Builders
! ...
FUNCTION: LLVMValueRef LLVMBuildMul ( LLVMBuilderRef Builder,
                                      LLVMValueRef LHS,
                                      LLVMValueRef RHS,
                                      c-string Name )
```

2. Run the Factor executable on the given file and redirect its output 
(which is on STDERR since it's debug) to a file. Note that I left blanks on the path.

```bash
factor-path-here/factor your-path-here/square.factor 2> square.ll
```

3. Create an object file using LLVM

`-march=wasm32` specifies that it's compiling to 32-bit WASM.
`-filetype=obj` is self-explanatory.

```bash
llc -march=wasm32 -filetype=obj square.ll
```

4. Compile using the WASM compiler

```bash
wasm-ld --no-entry --export-all -o square.wasm square.o
```

5. Open in the provided HTML file.

If you put different names you may need to change the name of the referenced file in the HTML.
