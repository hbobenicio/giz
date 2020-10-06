//! fmt is the module responsible for formatting API functions.
//! This is basically applying formatting to a buffer
//! (which is an input for almost every function here).
//!
//! TODO Refator fmt module
const std = @import("std");

test "testing fmt.io.fixedBufferStream" {
    var buffer: [50]u8 = undefined;
    const writer = std.io.fixedBufferStream(&buffer).writer();
    try writer.writeAll("abc");
    try writer.writeAll("def");
    std.testing.expectEqualStrings("abcdef", buffer[0..6]);
}
