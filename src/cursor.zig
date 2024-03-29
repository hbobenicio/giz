//! Cursor module is the API entry for cursor escapings

const std = @import("std");
const fmt = std.fmt;
const io = std.io;

const codes = @import("./codes.zig");

pub const Error = std.os.WriteError || std.fmt.BufPrintError;

// TODO Is it ok to use global stdout (thread-safety)?
// TODO consider passing a writer as argument (various possible sinks: stdout, stderr, membufs, etc)
const stdout = io.getStdOut();

pub fn move(buf: []u8, row: u32, col: u32) Error!void {
    // TODO assert min buf len?
    std.debug.assert(row <= 9999);
    std.debug.assert(col <= 9999);

    const escapeSequence = try fmt.bufPrint(buf, "{s}{s};{s}{s}", .{
        codes.EscapePrefix,
        row,
        col,
        codes.cursor.PositionSuffix1, // TODO Suffix1 or 2? what is the difference?!
    });

    _ = try stdout.write(escapeSequence);
}

pub fn up(buf: []u8, offset: u32) Error!void {
    // TODO assert min buf len?
    std.debug.assert(offset <= 9999);

    const escapeSequence = try fmt.bufPrint(buf, "{s}{s}{s}", .{
        codes.EscapePrefix,
        offset,
        codes.cursor.UpSuffix,
    });

    _ = try stdout.write(escapeSequence);
}

pub fn down(buf: []u8, offset: u32) Error!void {
    // TODO assert min buf len?
    std.debug.assert(offset <= 9999);

    const escapeSequence = try fmt.bufPrint(buf, "{s}{s}{s}", .{
        codes.EscapePrefix,
        offset,
        codes.cursor.DownSuffix,
    });

    _ = try stdout.write(escapeSequence);
}

pub fn forward(buf: []u8, offset: u32) Error!void {
    // TODO assert min buf len?
    std.debug.assert(offset <= 9999);

    const escapeSequence = try fmt.bufPrint(buf, "{s}{s}{s}", .{
        codes.EscapePrefix,
        offset,
        codes.cursor.ForwardSuffix,
    });

    _ = try stdout.write(escapeSequence);
}

pub fn backward(buf: []u8, offset: u32) Error!void {
    // TODO assert min buf len?
    std.debug.assert(offset <= 9999);

    const escapeSequence = try fmt.bufPrint(buf, "{s}{s}{s}", .{
        codes.EscapePrefix,
        offset,
        codes.cursor.BackwardSuffix,
    });

    _ = try stdout.write(escapeSequence);
}

pub fn savePosition(buf: []u8) Error!void {
    // TODO assert min buf len?
    const escapeSequence = try fmt.bufPrint(buf, "{s}{s}", .{
        codes.EscapePrefix,
        codes.cursor.SavePositionSuffix,
    });

    _ = try stdout.write(escapeSequence);
}

pub fn restorePosition(buf: []u8) Error!void {
    // TODO assert min buf len?
    const escapeSequence = try fmt.bufPrint(buf, "{s}{s}", .{
        codes.EscapePrefix,
        codes.cursor.RestorePositionSuffix,
    });

    _ = try stdout.write(escapeSequence);
}

pub fn eraseDisplay(buf: []u8) Error!void {
    // TODO assert min buf len?
    const escapeSequence = try fmt.bufPrint(buf, "{s}{s}", .{
        codes.EscapePrefix,
        codes.cursor.EraseDisplaySuffix,
    });

    _ = try stdout.write(escapeSequence);
}

pub fn eraseLine(buf: []u8) Error!void {
    // TODO assert min buf len?
    const escapeSequence = try fmt.bufPrint(buf, "{s}{s}", .{
        codes.EscapePrefix,
        codes.cursor.EraseLineSuffix,
    });

    _ = try stdout.write(escapeSequence);
}

// TODO add tests
