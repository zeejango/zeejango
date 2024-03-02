// Copyright (c) 2024 Rohan Vashisht

// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

const net = @cImport(@cInclude("arpa/inet.h"));
const stdio = @cImport(@cInclude("stdio.h"));
const stdlib = @cImport(@cInclude("stdlib.h"));
const string = @cImport(@cInclude("string.h"));
const unistd = @cImport(@cInclude("unistd.h"));
const std = @import("std");

// How I made this?
// implicite type-conversions were too difficult to implement.
// hence I `zig translate-c`'ed my C code.
// and reversed generated the generated zig file and created this file:

const zeejango_structure = extern struct {
    server_fd: c_int,
    address_struct: net.struct_sockaddr_in,
    address_length: c_int,
};

pub fn zeejangoinit(port: c_int) callconv(.C) zeejango_structure {
    var server_file_descriptor: c_int = undefined;
    var address_struct: net.struct_sockaddr_in = undefined;
    const address_length: c_int = @as(c_int, @bitCast(@as(c_uint, @truncate(@sizeOf(net.struct_sockaddr_in)))));
    if ((blk: {
        const tmp = net.socket(@as(c_int, 2), @as(c_int, 1), @as(c_int, 0));
        server_file_descriptor = tmp;
        break :blk tmp;
    }) == @as(c_int, 0)) {
        stdio.perror("socket failed");
        stdlib.exit(@as(c_int, 1));
    }
    address_struct.sin_family = 2;
    address_struct.sin_addr.s_addr = @as(i32, @bitCast(@as(c_int, 0)));
    address_struct.sin_port = @as(c_ushort, @bitCast(@as(c_short, @truncate(if (stdio.__builtin_constant_p(port) != 0) @as(c_int, @bitCast(@as(c_uint, @as(c_ushort, @bitCast(@as(c_ushort, @truncate(((@as(c_uint, @bitCast(@as(c_uint, @as(c_ushort, @bitCast(@as(c_short, @truncate(port))))))) & @as(c_uint, 65280)) >> @intCast(8)) | ((@as(c_uint, @bitCast(@as(c_uint, @as(c_ushort, @bitCast(@as(c_short, @truncate(port))))))) & @as(c_uint, 255)) << @intCast(8))))))))) else @as(c_int, @bitCast(@as(c_uint, stdlib._OSSwapInt16(@as(u16, @bitCast(@as(c_short, @truncate(port))))))))))));
    if (net.bind(server_file_descriptor, @as([*c]net.struct_sockaddr, @ptrCast(@alignCast(&address_struct))), @as(net.socklen_t, @bitCast(@as(c_uint, @truncate(@sizeOf(net.struct_sockaddr_in)))))) < @as(c_int, 0)) {
        stdio.perror("bind failed");
        stdlib.exit(@as(c_int, 1));
    }
    if (net.listen(server_file_descriptor, @as(c_int, 300)) < @as(c_int, 0)) {
        stdio.perror("listen");
        stdlib.exit(@as(c_int, 1));
    }
    var ini: zeejango_structure = undefined;
    ini.server_fd = server_file_descriptor;
    ini.address_struct = address_struct;
    ini.address_length = address_length;
    return ini;
}

pub const FunctionPtr = ?*const fn ([*c]u8) callconv(.C) [*c]u8;

pub fn zeejango_listener(arg_y: zeejango_structure, func: FunctionPtr) callconv(.C) void {
    var y = arg_y;
    var new_socket: c_int = undefined;
    while (true) {
        if ((blk: {
            new_socket = net.accept(y.server_fd, @as([*c]net.struct_sockaddr, @ptrCast(@alignCast(&y.address_struct))), @as([*c]net.socklen_t, @ptrCast(@alignCast(&y.address_length))));
            break :blk new_socket;
        }) < @as(c_int, 0)) {
            stdio.perror("accept");
            // stdlib.exit(@as(c_int, 1));
            std.c.exit(1);
        }
        var buffer: [30000]u8 = [1]u8{
            0,
        } ++ [1]u8{0} ** 29999;
        _ = unistd.read(new_socket, @as(?*anyopaque, @ptrCast(@as([*c]u8, @ptrCast(@alignCast(&buffer))))), @as(usize, @bitCast(@as(c_long, @as(c_int, 30000)))));
        _ = stdio.printf("%s\n", @as([*c]u8, @ptrCast(@alignCast(&buffer))));
        const responce: [*c]u8 = func.?(@as([*c]u8, @ptrCast(@alignCast(&buffer))));
        _ = unistd.write(new_socket, @as(?*const anyopaque, @ptrCast(responce)), string.strlen(responce));
        _ = unistd.close(new_socket);
    }
}

// can someone please give me the alternatives to these functions of C ?
// stdio's perror()
// stdlib's builtin_const_p()
// stdlib's exit()
// unistd's write()
// unistd's read()
// unistd's close()
// stdlib's osswap_16
