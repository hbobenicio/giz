const std = @import("std");

// TODO Consider reimplementing this with an array list and std.mem.join
// TODO Consider not using this and using this instead:
// const fbs = std.io.fixedBufferStream(buf);
// const w = fbs.writer();
// w.writeAll
// TODO Consider creating an init function with the separator parameter (which could be ';' or ':')
// TODO Consider renaming this to something more Opaque/Reusable and intuitive (like CsvBuilder...)
// TODO Move this struct to its own module
pub const EscapingSequence = struct {
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
