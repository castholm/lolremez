const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "lolremez",
        .target = target,
        .optimize = optimize,
    });
    if (exe.target.isWindows()) {
        exe.want_lto = false;
    }
    exe.linkLibCpp();
    exe.addIncludePath(.{ .path = "lol/include" });
    exe.defineCMacro("PACKAGE_VERSION", "\"0.7\"");
    exe.addCSourceFiles(&.{
        "src/lolremez.cpp",
        "src/solver.cpp",
    }, &.{
        "-std=c++17",
        "-Wall",
        "-Wextra",
    });

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    run_exe.step.dependOn(b.getInstallStep());
    run_exe.addArgs(b.args orelse &.{"--help"});

    const run_tls = b.step("run", "Run LolRemez");
    run_tls.dependOn(&run_exe.step);
}
