const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const giz_exe = b.addExecutable("giz", "src/main.zig");
    giz_exe.setTarget(target);
    giz_exe.setBuildMode(mode);
    giz_exe.install();

    const run_cmd = giz_exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Test Step
    const tests = b.addTest("./tests.zig");
    tests.setBuildMode(mode);
    const test_step = b.step("test", "Run all the tests");
    test_step.dependOn(&tests.step);
}
