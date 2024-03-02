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
