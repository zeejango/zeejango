const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zeejango_example",
        .root_source_file = .{ .path = "examples/example.zig" },
        .target = target,
        .optimize = optimize,
    });
    const zeejango_module = b.addModule("zeejango", .{ .root_source_file = .{ .path = "src/zeejango.zig" } });
    exe.root_module.addImport("zeejango", zeejango_module);
    try b.modules.put(b.dupe("zeejango"), zeejango_module);

    const zeejango_module_c = b.addModule("zeejango_c", .{ .root_source_file = .{ .path = "src/zeejango_c.zig" } });
    zeejango_module.addImport("zeejango_c", zeejango_module_c);
    try b.modules.put(b.dupe("zeejango_c"), zeejango_module_c);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run_example", "Run the example 1");
    run_step.dependOn(&run_cmd.step);
}
