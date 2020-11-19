pub const ColorMode = enum {

    /// Omits all color scape codes
    no_color,

    /// Minimal color support with just standard colors
    /// (4 bit colors, 16 total. 8 foreground colors + 8 background colors)
    minimal,

    /// Basic color support. Besides standard colors, consider also:
    /// - High-Intensity colors (hicolors)
    /// - 216 RGB colors, where 0 <= red, green, blue <= 5 (giving a 6 x 6 x 6 matrix of colors)
    /// - Grayscale (24 steps)
    basic,

    /// True color support (16 millions colors)
    /// - Full RGB support
    truecolor,
};

pub const Config = struct {
    color_mode: ColorMode,
};

pub fn default() Config {
    return .{
        .color_mode = ColorMode.truecolor,
    };
}
