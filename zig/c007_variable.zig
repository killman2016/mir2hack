/// c007_variable.zig
/// 如果你感觉写代码不快乐
/// 那么一定不是给自己写的🤡
///
const std = @import("std");

const DictDB = struct {
    name: []const u8 = undefined,
    age: u8 = 0,
    money: f32 = 0,

    const Self = @This();

    pub fn printMe(self: Self) void {
        const fields = @typeInfo(@TypeOf(self)).Struct.fields;
        inline for (fields) |field| {
            std.debug.print("{s}: {any} = {any}\n", .{
                field.name,
                field.type,
                //field.default_value,
                @field(self, field.name),
            });
        }
    }

    pub fn setFieldValue(self: *Self, comptime field_name: []const u8, comptime T: type, value: T) void {
        @field(self.*, field_name) = value;
    }

    inline fn getUserInput(self: *Self, comptime field_name: []const u8, comptime T: type) !bool {
        const stdin = std.io.getStdIn().reader();
        var buffer: [128]u8 = undefined;

        std.debug.print("Please input `{s}` : ", .{field_name});

        const result = if (stdin.readUntilDelimiterOrEof(&buffer, '\n') catch |err| switch (err) {
            error.StreamTooLong => blk: {
                //Skip to the delimiter in the reader, to fix parsing
                try stdin.skipUntilDelimiterOrEof('\n');
                break :blk &buffer;
            },
            else => return false,
        }) |input| {
            const line = std.mem.trimRight(u8, input[0 .. input.len - 1], "\r");
            return switch (T) {
                f32, f64, f80 => {
                    @field(self, field_name) = try std.fmt.parseFloat(T, line);
                    return true;
                },
                u8, u16, u32, usize => {
                    @field(self, field_name) = try std.fmt.parseInt(T, line, 10);
                    return true;
                },
                []const u8 => {
                    @field(self, field_name) = line;
                    return true;
                },
                else => {
                    std.debug.print("T = {any}\n", .{T});
                    return false;
                },
            };
        } else {
            return false;
        };
        return result;
    }
};
pub fn main() !void {
    var db = DictDB{};
    // pub const StructField = struct {
    //     name: [:0]const u8,
    //     type: type,
    //     default_value: ?*const anyopaque,
    //     is_comptime: bool,
    //     alignment: comptime_int,
    // };

    const fields = @typeInfo(@TypeOf(db)).Struct.fields;
    inline for (fields) |field| {
        while (true) {
            if (try db.getUserInput(field.name, field.type) == true) break;
        }
    }

    db.printMe();

    //const A = error{One};
    //const B = error{Two};
    //try std.testing.expect((A || B) == error{ Two, One });
}
