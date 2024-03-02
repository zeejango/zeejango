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
    - `git clone https://github.com/RohanVashisht1234/zeejango`
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
    .url = "https://github.com/zeejango/zeejango/archive/refs/tags/0.0.2.tar.gz",
    .hash = "12207e29a5cbaf3f474285a325480c71964da24d7f1d9f1509bf03340fe595ecd0d7",
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
