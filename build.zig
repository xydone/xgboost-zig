const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("xgboost", .{
        .root_source_file = b.path("src/root.zig"),

        .target = target,
        .optimize = optimize,

        .link_libc = true,
    });

    module.addIncludePath(b.path("libs/"));
    module.linkSystemLibrary("xgboost", .{});

    const mod_tests = b.addTest(.{
        .root_module = module,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}
