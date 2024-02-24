/// c006_dictdb.zig
///
/// 人有三个基本错误是不能犯的：
///
/// 一是 德薄而位尊，
/// 二是 智小而谋大，
/// 三是 力小而任重。
///
/// —— 南怀瑾
const std = @import("std");
const print = std.debug.print;

const DictDB = struct {
    english: []const u8 = undefined,
    transaction: []const u8 = undefined,
    example: []const u8 = undefined,

    const Self = @This();

    pub fn printMe(self: Self) void {
        const fields = @typeInfo(@TypeOf(self)).Struct.fields;
        inline for (fields) |field| {
            std.debug.print("\n{s:>12}: {any} = {s}", .{
                field.name,
                field.type,
                //field.default_value,
                @field(self, field.name),
            });
        }
    }

    inline fn getUserInput(self: *DictDB, comptime field_name: []const u8, comptime T: type) !bool {
        const stdin = std.io.getStdIn().reader();
        var buffer: [256]u8 = undefined;
        //const fbs = std.io.fixedBufferStream(T);
        print("Please input `{s:>12}: {any}` : ", .{ field_name, T });
        const result = if (stdin.readUntilDelimiterOrEof(&buffer, '\n') catch |err| switch (err) {
            error.StreamTooLong => blk: {
                //Skip to the delimiter in the reader, to fix parsing
                try stdin.skipUntilDelimiterOrEof('\n');
                break :blk &buffer;
            },
            else => return false,
        }) |input| {
            @field(self, field_name) = std.mem.trimRight(u8, input[0 .. input.len - 1], "\r");
            return false;
        } else {
            return true;
        };
        return result;
    }
};
pub fn main() !void {
    var db = DictDB{};

    const fields = @typeInfo(@TypeOf(db)).Struct.fields;
    inline for (fields) |field| {
        while (true) {
            if (try db.getUserInput(field.name, field.type) == false) break;
        }
    }

    db.printMe();
}

// output:
//
// Please input `     english: []const u8` : help
// Please input ` transaction: []const u8` : do sth for sb
// Please input `     example: []const u8` : please help me.
//
//      english: []const u8 = help
//  transaction: []const u8 = do sth for sb
//      example: []const u8 = please help me.

// Deprecated: use `streamUntilDelimiter` with FixedBufferStream's writer instead.
// Reads from the stream until specified byte is found. If the buffer is not
// large enough to hold the entire contents, `error.StreamTooLong` is returned.
// If end-of-stream is found, returns the rest of the stream. If this
// function is called again after that, returns null.
// Returns a slice of the stream data, with ptr equal to `buf.ptr`. The
// delimiter byte is written to the output buffer but is not included
// in the returned slice.

// pub fn readUntilDelimiterOrEof(self: Self, buf: []u8, delimiter: u8) anyerror!?[]u8 {
//     var fbs = std.io.fixedBufferStream(buf);
//     self.streamUntilDelimiter(fbs.writer(), delimiter, fbs.buffer.len) catch |err| switch (err) {
//         error.EndOfStream => if (fbs.getWritten().len == 0) {
//             return null;
//         },
//
//         else => |e| return e,
//     };
//     const output = fbs.getWritten();
//     buf[output.len] = delimiter; // emulating old behaviour
//     return output;
// }
