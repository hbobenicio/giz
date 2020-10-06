const Color = @import("./Color.zig").Color;

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
