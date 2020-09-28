//! This is the main demo module. It's not part of the library/API.
//! It's just a showcase to let users know how giz works.

const std = @import("std");
const mem = std.mem;
const heap = std.heap;

const giz = @import("./giz.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut();
    const w = stdout.writer();

    // TODO instead of abording execution if no TTY, just pass down a NoColor config to giz,
    // so escaping colors should not be emitted. This would be handy to have as 
    if (!stdout.isTty()) {
        std.log.err("error: your console is not a tty", .{});
        return error.DeviceIsNotTTY;
    }
    if (!stdout.supportsAnsiEscapeCodes()) {
        std.log.err("error: your console doesn't support ansi escape codes", .{});
        return error.DeviceDoesNotSupportAnsiEscapeCodes;
    }

    // TODO add some API to set options for color mode: NoColor | 8bit | 256bit
    // TODO add imperative API examples

    var tmpBuf: [100]u8 = undefined;

    // Chalk Demo
    try w.print("{} ", .{try giz.fmtStyle(tmpBuf[0..], "bold", .{ .bold = true })});
    try w.print("{} ", .{try giz.fmtStyle(tmpBuf[0..], "dim", .{ .dim = true })});
    try w.print("{} ", .{try giz.fmtStyle(tmpBuf[0..], "italic", .{ .italic = true })});
    try w.print("{} ", .{try giz.fmtStyle(tmpBuf[0..], "underline", .{ .underline = true })});
    try w.print("{} ", .{try giz.fmtStyle(tmpBuf[0..], "inverse", .{ .inverse = true })});
    try w.print("{}\n", .{try giz.fmtStyle(tmpBuf[0..], "strikethrough", .{ .strikethrough = true })});
    try w.print("{} ", .{try giz.red(tmpBuf[0..], "red")});
    try w.print("{} ", .{try giz.green(tmpBuf[0..], "green")});
    try w.print("{} ", .{try giz.yellow(tmpBuf[0..], "yellow")});
    try w.print("{} ", .{try giz.blue(tmpBuf[0..], "blue")});
    try w.print("{} ", .{try giz.magenta(tmpBuf[0..], "magenta")});
    try w.print("{} ", .{try giz.cyan(tmpBuf[0..], "cyan")});
    try w.print("{} ", .{try giz.white(tmpBuf[0..], "white")});
    // TODO grey
    try w.print("{}\n", .{try giz.black(tmpBuf[0..], "black")});
    try w.print("{} ", .{try giz.bgRed(tmpBuf[0..], "bgRed")});
    try w.print("{} ", .{try giz.bgGreen(tmpBuf[0..], "bgGreen")});
    try w.print("{} ", .{try giz.bgYellow(tmpBuf[0..], "bgYellow")});
    try w.print("{} ", .{try giz.bgBlue(tmpBuf[0..], "bgBlue")});
    try w.print("{} ", .{try giz.bgMagenta(tmpBuf[0..], "bgMagenta")});
    try w.print("{} ", .{try giz.bgCyan(tmpBuf[0..], "bgCyan")});
    try w.print("{} ", .{try giz.bgWhite(tmpBuf[0..], "bgWhite")});
    // TODO grey
    try w.print("{}\n", .{try giz.bgBlack(tmpBuf[0..], "bgBlack")});

    // Full customization declarative API
    const ibmStyle: giz.Style = .{
        .fgColor = giz.Color.Yellow, // just .Yellow also works
        .bgColor = giz.Color.Blue, // just .Blue also works
        .bold = true,
        .underline = true,
    };
    try w.print("{}\n", .{try giz.fmtStyle(tmpBuf[0..], "IBM Style", ibmStyle)});

    // TODO finish cursor implementation
    // try giz.cursor.move(tmpBuf[0..], 0, 0);
    // try giz.cursor.up(tmpBuf[0..], 1);

    try giz.resetGraphics();
    std.log.info("Resetting works", .{});
}
