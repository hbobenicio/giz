//! io is the module responsible for I/O writing API functions.
//! This is basically writing styles to a writer (aka output stream)
//! (which is an input for almost every function here).
//!
//! TODO Refator io module
const std = @import("std");

const codes = @import("./codes.zig");
const color = @import("./Color.zig");
const Color = color.Color;

pub inline fn printResetGraphics(writer: anytype) !void {
    try writer.print("{}", .{codes.resetEscapeSequence()});
}

pub inline fn printResetForeground(writer: anytype) !void {
    try writer.print("{}", .{codes.resetForegroundEscapeSequence()});
}

pub inline fn printResetBackground(writer: anytype) !void {
    try writer.print("{}", .{codes.resetBackgroundEscapeSequence()});
}

pub fn printForegroundColor(writer: anytype, c: Color) !void {
    const color_code: []const u8 = color.colorToForegroundCode(c);
    try writer.print("{}{}{}", .{
        codes.EscapePrefix,
        color_code,
        codes.graphics.SetModeSuffix,
    });
}

pub fn printBackgroundColor(writer: anytype, c: Color) !void {
    const colorCode: []const u8 = color.colorToBackgroundCode(c);
    try writer.print("{}{}{}", .{
        codes.EscapePrefix,
        colorCode,
        codes.graphics.SetModeSuffix,
    });
}

test "printForegroundColor works" {
    const TestCase = struct {
        input_text: []const u8,
        input_color: Color,
    };

    const test_cases = [_]TestCase {
        TestCase{ .input_text = "printForegroundColor works for red", .input_color = Color.Red },
        TestCase{ .input_text = "printForegroundColor works for green", .input_color = Color.Green },
        TestCase{ .input_text = "printForegroundColor works for blue", .input_color = Color.Blue },
    };

    const buf_size: usize = 100;
    for (test_cases) |tc| {
        var buf: [buf_size]u8 = [_]u8{0} ** buf_size;
        const writer = std.io.fixedBufferStream(&buf).writer();

        try printForegroundColor(writer, tc.input_color);
        try writer.writeAll(tc.input_text);
        try printResetForeground(writer);

        // Ouput must contain the Ansi Escape code for the input color, the input text and
        // the correct reset escaping suffix
        std.testing.expect(std.mem.indexOf(u8, buf[0..], color.colorToForegroundCode(tc.input_color)) != null);
        std.testing.expect(std.mem.indexOf(u8, buf[0..], tc.input_text) != null);
        std.testing.expect(std.mem.indexOf(u8, buf[0..], codes.resetForegroundEscapeSequence()) != null);
    }
}

test "printBackgroundColor works" {
    const TestCase = struct {
        input_text: []const u8,
        input_color: Color,
    };

    const test_cases = [_]TestCase {
        TestCase{ .input_text = "printBackgroundColor works for red", .input_color = Color.Red },
        TestCase{ .input_text = "printBackgroundColor works for green", .input_color = Color.Green },
        TestCase{ .input_text = "printBackgroundColor works for blue", .input_color = Color.Blue },
    };

    const buf_size: usize = 100;
    for (test_cases) |tc| {
        var buf: [buf_size]u8 = [_]u8{0} ** buf_size;
        const writer = std.io.fixedBufferStream(&buf).writer();

        try printBackgroundColor(writer, tc.input_color);
        try writer.writeAll(tc.input_text);
        try printResetBackground(writer);

        // Ouput must contain the Ansi Escape code for the input color, the input text and
        // the correct reset escaping suffix
        std.testing.expect(std.mem.indexOf(u8, buf[0..], color.colorToBackgroundCode(tc.input_color)) != null);
        std.testing.expect(std.mem.indexOf(u8, buf[0..], tc.input_text) != null);
        std.testing.expect(std.mem.indexOf(u8, buf[0..], codes.resetBackgroundEscapeSequence()) != null);
    }
}