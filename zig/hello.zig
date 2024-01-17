const std = @import("std");

pub fn main() void {
	std.debug.print("Hello, world!\n", .{});
}

// zig build-exe hello.zig -O ReleaseSmall -fstrip -fsingle-threaded -target x86-windows-msvc
//
// hello.exe 2,560 bytes
//
// file hello.exe
//
// hello.exe; PE32 executable for MS Windows (console) Intel 80386 32-bit
//
// Dump of file hello.exe
// 
// File Type: EXECUTABLE IMAGE
// 
//   Section contains the following imports:
// 
//     KERNEL32.dll
//                 402048 Import Address Table
//                 402038 Import Name Table
//                      0 time date stamp
//                      0 Index of first forwarder reference
// 
//                    0  ExitProcess
//                    0  GetLastError
//                    0  WriteFile
// 
//   Summary
// 
//         1000 .data
//         1000 .rdata
//         1000 .reloc
//         1000 .text

// zig vs tcc

// hello-tcc.c
// tcc -m32 -o hello-tcc.exe hello-tcc.c
// 
// #include <stdio.h>
// 
// void main() {
//         printf("Hello, World!\n");
// }
//
//  hello-tcc.exe  2,048 bytes
//
//Dump of file hello-tcc.exe
//
//File Type: EXECUTABLE IMAGE
//
//  Section contains the following imports:
//
//    msvcrt.dll
//                40204C Import Address Table
//                402080 Import Name Table
//                     0 time date stamp
//                     0 Index of first forwarder reference
//
//                   0  printf
//                   0  __argc
//                   0  __argv
//                   0  _environ
//                   0  _XcptFilter
//                   0  memset
//                   0  __set_app_type
//                   0  _controlfp
//                   0  __getmainargs
//                   0  exit
//
//    kernel32.dll
//                402078 Import Address Table
//                4020AC Import Name Table
//                     0 time date stamp
//                     0 Index of first forwarder reference
//
//                   0  SetUnhandledExceptionFilter
//
//  Summary
//
//        1000 .bss
//        1000 .rdata
//        1000 .text
