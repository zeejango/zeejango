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

const std = @import("std");
const c_web = @import("zeejango_c");
const find = std.mem.indexOf;
const eql = std.mem.eql;

pub const init = c_web.zeejangoinit;
pub const listen = c_web.zeejango_listener;

pub fn handle_maker(comptime myfunc: *const fn (x: []u8) []const u8) *const fn (ok: [*c]u8) callconv(.C) [*c]u8 {
    const myfunct = myfunc;
    return struct {
        fn nested(ok: [*c]u8) callconv(.C) [*c]u8 {
            const res = myfunct(std.mem.span(ok));
            const whatever: [*c]u8 = @constCast(res.ptr);
            return whatever;
        }
    }.nested;
}

const header_with_body = struct {
    header: []const u8,
    body: []const u8,
};

pub fn send(x: header_with_body) []const u8 {
    const allocator = std.heap.page_allocator;
    const dz = [_][]const u8{ x.header, "\n\n", x.body };
    const res = std.mem.concat(allocator, u8, &dz) catch return "server_error";
    return res;
}

pub const GET: i32 = 123;
pub const POST: i32 = 1234;

pub fn method(x: []const u8) i32 {
    if (find(u8, x, "GET /") != null) {
        return 123;
    } else {
        return 1234;
    }
}

pub const default_header: []const u8 = "HTTP/1.1 200 OK\nContent-Type: text/html";

const header_with_file = struct {
    header: []const u8,
    file_name: []const u8,
};

// fn readFile(path_file: []const u8) []const u8 {
//     const allocator = std.heap.page_allocator;
//     var file = std.fs.cwd().openFile(path_file, .{}) catch return "File not found!!! (error: type 1)";
//     defer file.close();

//     const fsz = (file.stat() catch return "File not found!!!! (error: type 2)").size;
//     var br = std.io.bufferedReader(file.reader());
//     var reader = br.reader();
//     const d: []const u8 = reader.readAllAlloc(allocator, fsz) catch return "File not found!!!! (error: type 2)";
//     return d;
// }

fn readFile(path_file: []const u8) []const u8 {
    var buf: [800000]u8 = undefined;
    buf = undefined;
    const content = std.fs.cwd().readFile(path_file, &buf) catch return "file not found";
    return content;
}

pub fn send_file(x: header_with_file) []const u8 {
    const allocator = std.heap.page_allocator;
    const dz = [_][]const u8{ x.header, "\n\n", readFile(x.file_name) };
    const res = std.mem.concat(allocator, u8, &dz) catch return "server_error";
    return res;
}

pub fn path(of: []u8, is: []const u8) bool {
    var res = std.mem.tokenizeAny(u8, of, " ");
    _ = res.next().?;
    const second_index = res.next().?;
    if (find(u8, second_index, "?") != null) { // it contains ? means its a request from user
        var resum = std.mem.tokenize(u8, second_index, "?");
        const the_thing_before_q_mark_after_slash = resum.next().?;
        if (std.mem.eql(u8, the_thing_before_q_mark_after_slash, is)) {
            return true;
        } else {
            return false;
        }
    }
    if (std.mem.eql(u8, second_index, is)) {
        return true;
    }
    return false;
}

pub const request = struct {
    pub fn get(of: []u8) []const u8 {
        var res = std.mem.tokenizeAny(u8, of, " ");
        _ = res.next().?;
        const second_index = res.next().?;
        if (find(u8, second_index, "?") != null) { // it contains ? means its a request from user
            var resum = std.mem.tokenize(u8, second_index, "?");
            _ = resum.next().?;
            const the_thing_after_q_mark = resum.next().?;

            return the_thing_after_q_mark;
        }
        return "";
    }

    pub fn post(_: []u8, _: []const u8) bool {
        return "I need to build the post request";
    }
};
