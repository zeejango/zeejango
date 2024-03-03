# Extremely fast backend framework for Zig programming language!
# Extremely easy as well!
- **This library is written from scratch!**

## 🙏🙏 Please contribute/support to this project.
- **[Buy me some coffee](https://www.buymeacoffee.com/rohanvashisht)**
- **[Join Discord](https://discord.gg/MY27CVbhBQ)**

**Important points to note:**
- zig version required: 0.12.x.
- doesn't work on windows.
## Run example:
- Simply open terminal and run:
    - `git clone https://github.com/zeejango/zeejango.git`
    - `cd zeejango`
    - `zig build run_example`

## Use it in your own project:
- Simply open terminal and run:
    - `mkdir zeejango_proj`
    - `cd zeejango_proj`
    - `zig init`
- Inside `build.zig.zon` file and inside `.dependencies` it type:


```zig
.zeejango = .{
    .url = "https://github.com/zeejango/zeejango/archive/refs/tags/v0.0.2.tar.gz",
    .hash = "12203ad98bfdc21c9aad97b0c61eb9a1fdc429a666cb54a0ac55261c2732d5bc691c",
},
```
- inside `build.zig` file add this:
```zig
exe.root_module.addImport("zeejango", b.dependency("zeejango", .{}).module("zeejango"));
```
- inside `main.zig` present inside src directory add this:
```zig
const std = @import("std");
const zeejango = @import("zeejango");

fn handle(req: []u8) []const u8 {
    if (zeejango.method(req) == zeejango.GET) {
        if (zeejango.path(req, "/")) {
            return zeejango.send(.{
                .header = zeejango.default_header,
                .body = "<h1>Hello from Zeejango!</h1><a href='/view_file'>Click to see a html file.</a>",
            });
        } else if (zeejango.path(req, "/view_file")) {
            // create a viewfile.html inside a folder named html
            return zeejango.send_file(.{
                .header = zeejango.default_header,
                .file_name = "./html/viewfile.html",
            });
        } else if (zeejango.path(req, "/submit")) {
            return zeejango.send(.{
                .header = zeejango.default_header,
                .body = zeejango.request.get(req),
            });
        } else {
            return zeejango.send(.{
                .header = zeejango.default_header,
                .body = "<h1>404!</h1>",
            });
        }
    }
    return "server error";
}

pub fn main() !void {
    std.debug.print("Listening at http://localhost:8012.", .{});
    zeejango.listen(
        zeejango.init(8012),
        zeejango.handle_maker(handle),
    );
}


```
- Run: `zig build run`
- In your browser open [localhost:8012](http://localhost:8012)
- Enjoy zeejango!!!!!
