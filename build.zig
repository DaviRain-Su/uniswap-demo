//! Source: z2y template (no Rust reference)
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zig_to_yul = b.dependency("zig_to_yul", .{
        .target = target,
        .optimize = optimize,
    });

    const evm_mod = b.createModule(.{
        .root_source_file = b.path("src/evm.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zig_to_yul", .module = zig_to_yul.module("zig_to_yul") },
        },
    });

    // Provide root_source_file and module imports for --project.
    const contract_mod = b.createModule(.{
        .root_source_file = b.path("src/Contract.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "evm", .module = evm_mod },
        },
    });
    _ = contract_mod;

    const out_step = b.addSystemCommand(&.{
        "mkdir",
        "-p",
        "out",
    });

    const build_step = b.addSystemCommand(&.{
        "zig_to_yul",
        "build",
        "--project",
        ".",
        "--abi",
        "out/Contract.abi.json",
        "-o",
        "out/Contract.bin",
        "src/Contract.zig",
    });
    build_step.step.dependOn(&out_step.step);

    const abi_step = b.addSystemCommand(&.{
        "zig_to_yul",
        "compile",
        "--project",
        ".",
        "--abi",
        "out/Contract.abi.json",
        "-o",
        "out/Contract.yul",
        "src/Contract.zig",
    });
    abi_step.step.dependOn(&out_step.step);

    const contract_step = b.step("contract", "Build contract bytecode");
    contract_step.dependOn(&build_step.step);
    const abi_only_step = b.step("abi", "Generate ABI JSON");
    abi_only_step.dependOn(&abi_step.step);
    b.getInstallStep().dependOn(&build_step.step);
}