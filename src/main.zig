//! This is the main demo module. It's not part of the library/API.
//! It's just a showcase to let users know how giz works.

const std = @import("std");
const mem = std.mem;
const heap = std.heap;

const giz = @import("./giz.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut();
    const w = stdout.writer();

    var giz_config: giz.config.Config = giz.config.default();

    // TODO Check if this config is working and ansi escape codes are actually not been written out
    if (!stdout.isTty()) {
        std.log.warn("your console is not a tty. disabling giz color mode.", .{});
        giz_config.color_mode = giz.config.ColorMode.no_color;
    }
    if (!stdout.supportsAnsiEscapeCodes()) {
        std.log.warn("your console doesn't support ansi escape codes. disabling giz color mode.", .{});
        giz_config.color_mode = giz.config.ColorMode.no_color;
    }

    // TODO add imperative API examples (multiple writes / state machine)
    // TODO add fluent API examples (inline style builder)

    // You can use this temporary stack buffer to avoid unnecessary allocations
    var tmpBuf: [100]u8 = undefined;

    try w.writeAll("┌─────────────────────────────────────────────┐\n");
    try w.writeAll("│ Chalk Demo - https://github.com/chalk/chalk │\n");
    try w.writeAll("└─────────────────────────────────────────────┘\n");

    // Full customization with fmtStyle, which writes to a buffer the scapings codes according to your styles
    try w.print("{s} ", .{try giz.fmtStyle(tmpBuf[0..], "bold", .{ .bold = true })});
    try w.print("{s} ", .{try giz.fmtStyle(tmpBuf[0..], "dim", .{ .dim = true })});
    try w.print("{s} ", .{try giz.fmtStyle(tmpBuf[0..], "italic", .{ .italic = true })});
    try w.print("{s} ", .{try giz.fmtStyle(tmpBuf[0..], "underline", .{ .underline = true })});
    try w.print("{s} ", .{try giz.fmtStyle(tmpBuf[0..], "inverse", .{ .inverse = true })});
    try w.print("{s}\n", .{try giz.fmtStyle(tmpBuf[0..], "strikethrough", .{ .strikethrough = true })});

    // Or you could use handy methods for common colors like red, green, blue, ...
    try w.print("{s} ", .{try giz.red(tmpBuf[0..], "red")});
    try w.print("{s} ", .{try giz.green(tmpBuf[0..], "green")});
    try w.print("{s} ", .{try giz.yellow(tmpBuf[0..], "yellow")});
    try w.print("{s} ", .{try giz.blue(tmpBuf[0..], "blue")});
    try w.print("{s} ", .{try giz.magenta(tmpBuf[0..], "magenta")});
    try w.print("{s} ", .{try giz.cyan(tmpBuf[0..], "cyan")});
    try w.print("{s} ", .{try giz.white(tmpBuf[0..], "white")});
    // TODO grey
    try w.print("{s}\n", .{try giz.black(tmpBuf[0..], "black")});

    // Background colors also have handy methods for common colors!
    try w.print("{s} ", .{try giz.bgRed(tmpBuf[0..], "bgRed")});
    try w.print("{s} ", .{try giz.bgGreen(tmpBuf[0..], "bgGreen")});
    try w.print("{s} ", .{try giz.bgYellow(tmpBuf[0..], "bgYellow")});
    try w.print("{s} ", .{try giz.bgBlue(tmpBuf[0..], "bgBlue")});
    try w.print("{s} ", .{try giz.bgMagenta(tmpBuf[0..], "bgMagenta")});
    try w.print("{s} ", .{try giz.bgCyan(tmpBuf[0..], "bgCyan")});
    try w.print("{s} ", .{try giz.bgWhite(tmpBuf[0..], "bgWhite")});
    // TODO grey
    try w.print("{s}\n\n", .{try giz.bgBlack(tmpBuf[0..], "bgBlack")});

    try w.writeAll("┌──────────────┐\n");
    try w.writeAll("│ Hicolor Demo │\n");
    try w.writeAll("└──────────────┘\n");

    // RGB's support demo
    try w.print("{s} ", .{try giz.fmtForegroundRGBStr(tmpBuf[0..], "247", "164", "29", "Zig")});
    try w.print("{s}\n", .{try giz.fmtBackgroundRGBStr(tmpBuf[0..], "247", "164", "29", "Zag")});

    try w.print("{s} ", .{try giz.fmtForegroundRGB(tmpBuf[0..], 247, 164, 29, "Zig")});
    try w.print("{s}\n\n", .{try giz.fmtBackgroundRGB(tmpBuf[0..], 247, 164, 29, "Zag")});

    try w.writeAll("┌────────────┐\n");
    try w.writeAll("│ Misc.      │\n");
    try w.writeAll("└────────────┘\n");

    // Full customization declarative API
    const ibmStyle: giz.Style = .{
        .fgColor = giz.Color.Yellow, // just .Yellow also works
        .bgColor = giz.Color.Blue, // just .Blue also works
        .bold = true,
        .underline = true,
    };
    try w.print("{s}\n\n", .{try giz.fmtStyle(tmpBuf[0..], "IBM Style", ibmStyle)});

    try w.writeAll("┌─────────────┐\n");
    try w.writeAll("│ Cursor Demo │\n");
    try w.writeAll("└─────────────┘\n");

    // TODO finish cursor implementation and demo
    // try giz.cursor.move(tmpBuf[0..], 0, 0);
    // try giz.cursor.up(tmpBuf[0..], 1);
    try w.writeAll("TODO\n");

    try giz.resetGraphics();
    std.log.info("Resetting works", .{});
}
