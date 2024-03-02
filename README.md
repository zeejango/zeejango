# EXTREMELY FAST BACKEND FRAMEWORK FOR ZIG!!!! 
# EXTREMELY EASY AS WELL!!!!
- **The library is written from scratch!**

## 🙏🙏 Please contribute/support to this project.
- **[Buy me some coffee](https://www.buymeacoffee.com/rohanvashisht)**
- **[Join Discord](https://discord.gg/MY27CVbhBQ)**

**Important points to note:**
- zig version required: 0.12.x.
- doesn't work on windows.
## Run example:
- Simply open terminal and run:
    - `git clone https://github.com/zeejango/zeejango`
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
    .url = "https://github.com/zeejango/zeejango/archive/refs/tags/0.0.1.tar.gz",
    .hash = "1220e93849b6e90bc8e7186be4000a1a5ce00d0d6441685b37015d223578d495602e",
} 
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
    return zeejango.send(.{
                .header = zeejango.default_header,
                .body = "<h1>Hello from Zeb!</h1>",
            });
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
