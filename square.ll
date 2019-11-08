; ModuleID = 'test_module'
source_filename = "test_module"

define i32 @square(i32) {
entry:
  %tmp = mul i32 %0, %0
  ret i32 %tmp
}
