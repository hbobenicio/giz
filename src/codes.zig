//! Codes module groups all ANSI escape codes.
//!
//! # References
//! - https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
//! - https://en.wikipedia.org/wiki/ANSI_escape_code
//! - https://gist.github.com/XVilka/8346728
//! - https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
//! - http://ascii-table.com/ansi-escape-sequences.php
//! - http://ascii-table.com/ansi-escape-sequences-vt-100.php

/// Esc represents the Ansi Escape code.
pub const Esc: []const u8 = "\x1b";

/// EscapePrefix represents the common "Esc[" escaping prefix pattern.
pub const EscapePrefix: []const u8 = Esc ++ "[";

/// Reset represents the reset code. All text attributes will be turned off.
pub const Reset: []const u8 = "0";

/// cursor is a namespace struct that groups all cursor ansi escape codes
pub const cursor = struct {

    // TODO Investigate the difference between 'H' and 'f' suffixes.
    /// Moves the cursor to the specified position (coordinates).
    /// If you do not specify a position, the cursor moves to the home position at the upper-left corner of the screen (line 0, column 0). This escape sequence works the same way as the following Cursor Position escape sequence.
    pub const PositionSuffix1: []const u8 = "H";
    pub const PositionSuffix2: []const u8 = "f";

    /// Moves the cursor up by the specified number of lines without changing columns.
    /// If the cursor is already on the top line, ANSI.SYS ignores this sequence. 
    pub const UpSuffix: []const u8 = "A";

    /// Moves the cursor down by the specified number of lines without changing columns.
    /// If the cursor is already on the bottom line, ANSI.SYS ignores this sequence.
    pub const DownSuffix: []const u8 = "B";

    /// Moves the cursor forward by the specified number of columns without changing lines.
    /// If the cursor is already in the rightmost column, ANSI.SYS ignores this sequence. 
    pub const ForwardSuffix: []const u8 = "C";

    /// Moves the cursor back by the specified number of columns without changing lines.
    /// If the cursor is already in the leftmost column, ANSI.SYS ignores this sequence.
    pub const BackwardSuffix: []const u8 = "D";

    /// Saves the current cursor position.
    /// You can move the cursor to the saved cursor position by using the Restore Cursor Position sequence.
    pub const SavePositionSuffix: []const u8 = "s";

    /// Returns the cursor to the position stored by the Save Cursor Position sequence.
    pub const RestorePositionSuffix: []const u8 = "u";

    /// Clears the screen and moves the cursor to the home position (line 0, column 0). 
    pub const EraseDisplaySuffix: []const u8 = "2J";

    /// Clears all characters from the cursor position to the end of the line (including the character at the cursor position).
    pub const EraseLineSuffix: []const u8 = "K";
};

pub const graphics = struct {
    /// GraphicsSuffix represents the suffix used for graphics escaping.
    ///
    /// Calls the graphics functions specified by the following values.
    /// These specified functions remain active until the next occurrence of this escape sequence.
    /// Graphics mode changes the colors and attributes of text (such as bold and underline) displayed on the screen.
    pub const SetModeSuffix: []const u8 = "m";

    pub const attr = struct {
        // TODO namespace conflicts 
        pub const AttrReset: []const u8 = "0";
        
        pub const Bold: []const u8 = "1";
        pub const Dim: []const u8 = "2";
        pub const Italic: []const u8 = "3";
        pub const Underline: []const u8 = "4";
        // TODO 5? 6?
        pub const Inverse: []const u8 = "7";
        pub const Hidden: []const u8 = "8";
        pub const Strikethrough: []const u8 = "9";
    };
};

/// color namespace groups all color codes.
pub const color = struct {
    /// fg namespace groups all foreground color codes.
    pub const fg = struct {
        pub const Black: []const u8 = "30";
        pub const Red: []const u8 = "31";
        pub const Green: []const u8 = "32";
        pub const Yellow: []const u8 = "33";
        pub const Blue: []const u8 = "34";
        pub const Magenta: []const u8 = "35";
        pub const Cyan: []const u8 = "36";
        pub const White: []const u8 = "37";
        // Next arguments are `5;<n>` for Hicolors (0-255) or `2;<r>;<g>;<b> for Custom RGB`
        // example: "\x1b[38;5;80m"
        pub const FgHiColor: []const u8 = "38";
        pub const FgReset: []const u8 = "39";

        pub const FgHiColorPreffix: []const u8 = FgHiColor ++ ";5";
        pub const FgHiColorRGBPreffix: []const u8 = FgHiColor ++ ";2";
    };
    /// bg namespace groups all background color codes.
    pub const bg = struct {
        pub const Black: []const u8 = "40";
        pub const Red: []const u8 = "41";
        pub const Green: []const u8 = "42";
        pub const Yellow: []const u8 = "43";
        pub const Blue: []const u8 = "44";
        pub const Magenta: []const u8 = "45";
        pub const Cyan: []const u8 = "46";
        pub const White: []const u8 = "47";
        // Next arguments are `5;<n>` for Hicolors (0-255) or `2;<r>;<g>;<b> for Custom RGB`
        // example: "\x1b[38;5;80m"
        pub const BgHiColor: []const u8 = "48";
        pub const BgReset: []const u8 = "49";

        pub const BgHiColorPreffix: []const u8 = BgHiColor ++ ";5";
        pub const BgHiColorRGBPreffix: []const u8 = BgHiColor ++ ";2";
    };
};

pub inline fn resetEscapeSequence() []const u8 {
    return EscapePrefix ++ Reset ++ graphics.SetModeSuffix;
}

pub inline fn resetForegroundEscapeSequence() []const u8 {
    return EscapePrefix ++ color.fg.FgReset ++ graphics.SetModeSuffix;
}

pub inline fn resetBackgroundEscapeSequence() []const u8 {
    return EscapePrefix ++ color.bg.BgReset ++ graphics.SetModeSuffix;
}
