//! Giz - Ansi support for zig.
//! TODO Transform all TODO's of this project into github issues
//! TODO conform API to style guide: https://ziglang.org/documentation/master/#Names

const std = @import("std");
const os = std.os;
const fmt = std.fmt;
const Writer = std.fs.File.Writer;

pub const codes = @import("./codes.zig");
pub const cursor = @import("./cursor.zig");

// TODO is it ok to have a global stdout?
// TODO should'nt it be buffered? Is it already?
const stdout = std.io.getStdOut();

/// Color enumerates all suported colors.
/// TODO add 256 true color support
pub const Color = enum {
    Black,
    Red,
    Green,
    Yellow,
    Blue,
    Magenta,
    Cyan,
    White,
};

pub const Style = struct {
    fgColor: ?Color = null,
    bgColor: ?Color = null,
    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    inverse: bool = false,
    hidden: bool = false,
    strikethrough: bool = false,
    // TODO builder API
};

// TODO Consider reimplementing this with an array list and std.mem.join
// TODO Consider creating an init function with the separator parameter (which could be ';' or ':')
// TODO Consider renaming this to something more Opaque/Reusable and intuitive (like CsvBuilder...)
const EscapingSequence = struct {
    buf: [30]u8 = undefined,
    len: usize = 0,

    pub fn appendCode(self: *@This(), code: []const u8) std.fmt.BufPrintError!void {
        if (code.len + self.len > 30) {
            return error.NoSpaceLeft;
        }
        if (self.len > 0) {
            self.buf[self.len] = ';';
            self.len += 1;
        }
        std.mem.copy(u8, self.buf[self.len..30], code);
        self.len += code.len;
    }
    pub fn toSlice(self: *@This()) []const u8 {
        return self.buf[0..self.len];
    }
};

// TODO Fg and Bg styling can be done with just one escaping. Improve this function to use minimal escapings
pub fn fmtStyle(buf: []u8, str: []const u8, style: Style) std.fmt.BufPrintError![]u8 {
    var offset: usize = 0;
    var escapeSequence = EscapingSequence{};

    if (style.fgColor) |fgColor| {
        try escapeSequence.appendCode(foregroundColorEscapeCode(fgColor));
    }
    
    if (style.bgColor) |bgColor| {
        try escapeSequence.appendCode(backgroundColorEscapeCode(bgColor));
    }

    if (style.bold) {
        try escapeSequence.appendCode(codes.graphics.attr.Bold);
    }

    if (style.dim) {
        try escapeSequence.appendCode(codes.graphics.attr.Dim);
    }

    if (style.italic) {
        try escapeSequence.appendCode(codes.graphics.attr.Italic);
    }

    if (style.underline) {
        try escapeSequence.appendCode(codes.graphics.attr.Underline);
    }

    if (style.inverse) {
        try escapeSequence.appendCode(codes.graphics.attr.Inverse);
    }

    if (style.hidden) {
        try escapeSequence.appendCode(codes.graphics.attr.Hidden);
    }

    if (style.strikethrough) {
        try escapeSequence.appendCode(codes.graphics.attr.Strikethrough);
    }

    return fmt.bufPrint(buf, "{}{}{}{}{}", .{
        codes.EscapePrefix,
        escapeSequence.toSlice(),
        codes.graphics.SetModeSuffix,
        str,
        resetEscapeSequence(),
    });
}

// TODO consider if we will use this function. Is that worth it? (subslicing buf and double writing to memory doesn't seem a good payoff)
inline fn fmtGraphicsCode(buf: []u8, code: []const u8) std.fmt.BufPrintError![]u8 {
    return fmt.bufPrint(buf, "{}{}{}", .{
        codes.EscapePrefix,
        code,
        codes.graphics.SetModeSuffix,
    });
}

pub fn fmtForegroundRGB(buf: []u8, r: u8, g: u8, b: u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    var redBuf: [3]u8 = undefined;
    var greenBuf: [3]u8 = undefined;
    var blueBuf: [3]u8 = undefined;

    const redStr = try fmt.bufPrint(redBuf[0..], "{}", .{r});
    const greenStr = try fmt.bufPrint(greenBuf[0..], "{}", .{g});
    const blueStr = try fmt.bufPrint(blueBuf[0..], "{}", .{b});

    return fmtForegroundRGBStr(buf, redStr, greenStr, blueStr, str);
}

pub fn fmtForegroundRGBStr(buf: []u8, r: []const u8, g: []const u8, b: []const u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    var escapeSeq = EscapingSequence{};
    try escapeSeq.appendCode(codes.color.fg.FgHiColorRGBPreffix);
    try escapeSeq.appendCode(r);
    try escapeSeq.appendCode(g);
    try escapeSeq.appendCode(b);
    const rgbCode: []const u8 = escapeSeq.toSlice();

    return fmt.bufPrint(buf, "{}{}{}{}{}", .{
        codes.EscapePrefix,
        rgbCode,
        codes.graphics.SetModeSuffix,
        str,
        resetForegroundEscapeSequence(),
    });
}

pub fn fmtBackgroundRGB(buf: []u8, r: u8, g: u8, b: u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    var redBuf: [3]u8 = undefined;
    var greenBuf: [3]u8 = undefined;
    var blueBuf: [3]u8 = undefined;

    const redStr = try fmt.bufPrint(redBuf[0..], "{}", .{r});
    const greenStr = try fmt.bufPrint(greenBuf[0..], "{}", .{g});
    const blueStr = try fmt.bufPrint(blueBuf[0..], "{}", .{b});

    return fmtBackgroundRGBStr(buf, redStr, greenStr, blueStr, str);
}

// TODO consider a numeric API for this
pub fn fmtBackgroundRGBStr(buf: []u8, r: []const u8, g: []const u8, b: []const u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    var escapeSeq = EscapingSequence{};
    try escapeSeq.appendCode(codes.color.bg.BgHiColorRGBPreffix);
    try escapeSeq.appendCode(r);
    try escapeSeq.appendCode(g);
    try escapeSeq.appendCode(b);
    const rgbCode: []const u8 = escapeSeq.toSlice();

    return fmt.bufPrint(buf, "{}{}{}{}{}", .{
        codes.EscapePrefix,
        rgbCode,
        codes.graphics.SetModeSuffix,
        str,
        resetBackgroundEscapeSequence(),
    });
}

fn fgStyle(buf: []u8, colorCode: []const u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fmt.bufPrint(buf, "{}{}{}{}{}", .{
        codes.EscapePrefix,
        colorCode,
        codes.graphics.SetModeSuffix,
        str,
        resetForegroundEscapeSequence(),
    });
}

fn bgStyle(buf: []u8, colorCode: []const u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fmt.bufPrint(buf, "{}{}{}{}{}", .{
        codes.EscapePrefix,
        colorCode,
        codes.graphics.SetModeSuffix,
        str,
        resetBackgroundEscapeSequence(),
    });
}

pub inline fn black(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fgStyle(buf, codes.color.fg.Black, str);
}

pub inline fn bgBlack(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return bgStyle(buf, codes.color.bg.Black, str);
}

pub inline fn red(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fgStyle(buf, codes.color.fg.Red, str);
}

pub inline fn bgRed(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return bgStyle(buf, codes.color.bg.Red, str);
}

pub inline fn green(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fgStyle(buf, codes.color.fg.Green, str);
}

pub inline fn bgGreen(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return bgStyle(buf, codes.color.bg.Green, str);
}

pub inline fn yellow(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fgStyle(buf, codes.color.fg.Yellow, str);
}

pub inline fn bgYellow(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return bgStyle(buf, codes.color.bg.Yellow, str);
}

pub inline fn blue(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fgStyle(buf, codes.color.fg.Blue, str);
}

pub inline fn bgBlue(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return bgStyle(buf, codes.color.bg.Blue, str);
}

pub inline fn magenta(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fgStyle(buf, codes.color.fg.Magenta, str);
}

pub inline fn bgMagenta(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return bgStyle(buf, codes.color.bg.Magenta, str);
}

pub inline fn cyan(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fgStyle(buf, codes.color.fg.Cyan, str);
}

pub inline fn bgCyan(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return bgStyle(buf, codes.color.bg.Cyan, str);
}

pub inline fn white(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return fgStyle(buf, codes.color.fg.White, str);
}

pub inline fn bgWhite(buf: []u8, str: []const u8) std.fmt.BufPrintError![]u8 {
    return bgStyle(buf, codes.color.bg.White, str);
}

/// maybe replace this to a static table from Color enum to Color codes
pub fn foregroundColorEscapeCode(color: Color) []const u8 {
    return switch (color) {
        Color.Black => codes.color.fg.Black,
        Color.Red => codes.color.fg.Red,
        Color.Green => codes.color.fg.Green,
        Color.Yellow => codes.color.fg.Yellow,
        Color.Blue => codes.color.fg.Blue,
        Color.Magenta => codes.color.fg.Magenta,
        Color.Cyan => codes.color.fg.Cyan,
        Color.White => codes.color.fg.White,
    };
}

/// maybe replace this to a static table from Color enum to Color codes
pub fn backgroundColorEscapeCode(color: Color) []const u8 {
    return switch (color) {
        Color.Black => codes.color.bg.Black,
        Color.Red => codes.color.bg.Red,
        Color.Green => codes.color.bg.Green,
        Color.Yellow => codes.color.bg.Yellow,
        Color.Blue => codes.color.bg.Blue,
        Color.Magenta => codes.color.bg.Magenta,
        Color.Cyan => codes.color.bg.Cyan,
        Color.White => codes.color.bg.White,
    };
}

pub fn setForegroundColor(color: Color) !void {
    const colorCode: []const u8 = foregroundColorEscapeCode(color);
    const w = stdout.writer();
    try w.print("{}{}{}", .{
        codes.EscapePrefix,
        colorCode,
        codes.graphics.SetModeSuffix,
    });
}

pub fn setBackgroundColor(color: Color) !void {
    const colorCode: []const u8 = backgroundColorEscapeCode(color);
    const w = stdout.writer();
    try w.print("{}{}{}", .{
        codes.EscapePrefix,
        colorCode,
        codes.graphics.SetModeSuffix,
    });
}

// TODO writer anytype
pub fn resetGraphics() !void {
    const escapeSequence: []const u8 = comptime resetEscapeSequence();
    try writeSequence(escapeSequence);
}

fn writeSequence(escapeSequence: []const u8) !void {
    const writtenBytes: usize = try stdout.write(escapeSequence);
    if (writtenBytes != escapeSequence.len) {
        return error.WriteError;
    }
}

pub inline fn resetEscapeSequence() []const u8 {
    return codes.EscapePrefix ++ codes.Reset ++ codes.graphics.SetModeSuffix;
}

pub inline fn resetForegroundEscapeSequence() []const u8 {
    return codes.EscapePrefix ++ codes.color.fg.FgReset ++ codes.graphics.SetModeSuffix;
}

pub inline fn resetBackgroundEscapeSequence() []const u8 {
    return codes.EscapePrefix ++ codes.color.bg.BgReset ++ codes.graphics.SetModeSuffix;
}

test "foreground colors" {
    const w = std.io.getStdErr().writer();

    try setForegroundColor(Color.Red);
    _ = try stdout.write("red");
    try resetGraphics();

    // TODO if this buffer is shared between an expression (for example: one w.print with multuple formats),
    // then this will break.
    var tmpBuf: [100]u8 = undefined;

    try w.print(" {}", .{ try green(&tmpBuf, "green") });
    try w.print(" {}", .{ try yellow(&tmpBuf, "yellow") });
    try w.print(" {}", .{ try blue(&tmpBuf, "blue") });
    try w.print(" {}", .{ try magenta(&tmpBuf, "magenta") });
    try w.print(" {}", .{ try cyan(&tmpBuf, "cyan") });
    try w.print(" {}", .{ try white(&tmpBuf, "white") });
    // TODO grey
    try w.print(" {}", .{ try black(&tmpBuf, "black") });
}

test "background colors" {
    const w = std.io.getStdErr().writer();

    try setBackgroundColor(Color.Red);
    _ = try stdout.write("red");
    try resetGraphics();

    // TODO if this buffer is shared between an expression (for example: one w.print with multuple formats),
    // then this will break.
    var tmpBuf: [100]u8 = undefined;

    try w.print(" {}", .{ try bgGreen(&tmpBuf, "bgGreen") });
    try w.print(" {}", .{ try bgYellow(&tmpBuf, "bgYellow") });
    try w.print(" {}", .{ try bgBlue(&tmpBuf, "bgBlue") });
    try w.print(" {}", .{ try bgMagenta(&tmpBuf, "bgMagenta") });
    try w.print(" {}", .{ try bgCyan(&tmpBuf, "bgCyan") });
    try w.print(" {}", .{ try bgWhite(&tmpBuf, "bgWhite") });
    // TODO grey
    try w.print(" {}", .{ try bgBlack(&tmpBuf, "bgBlack") });
}
