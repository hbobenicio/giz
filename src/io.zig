//! io is the module responsible for I/O writing API functions.
//! This is basically writing styles to a writer (aka output stream)
//! (which is an input for almost every function here).
//!
//! TODO Refator io module
const std = @import("std");

const Color = @import("./Color.zig").Color;

pub fn writeForegroundColor(w: *std.io.Writer, color: Color) !void {
    const color_code: []const u8 = foregroundColorEscapeCode(color);
    try w.print("{}{}{}", .{
        codes.EscapePrefix,
        color_code,
        codes.graphics.SetModeSuffix,
    });
}

pub fn setBackgroundColor(w: *std.io.Writer, color: Color) !void {
    const colorCode: []const u8 = backgroundColorEscapeCode(color);
    try w.print("{}{}{}", .{
        codes.EscapePrefix,
        colorCode,
        codes.graphics.SetModeSuffix,
    });
}
