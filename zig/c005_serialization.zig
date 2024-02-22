/// Custom JSON serialization in Zig
/// https://www.aolium.com/karlseguin/46252c5b-587a-c419-be96-a0ccc2f11de4
/// c005_serialization.zig
const std = @import("std");

const NumericBoolean = struct {
    value: bool,

    pub fn jsonStringify(self: NumericBoolean, out: anytype) !void {
        const json: u8 = if (self.value) 1 else 0;
        return out.write(json);
    }
};

pub const Raw = struct {
    value: ?[]const u8,

    pub fn init(value: ?[]const u8) Raw {
        return .{ .value = value };
    }

    pub fn jsonStringify(self: Raw, out: anytype) !void {
        const json = if (self.value) |value| value else "null";
        return out.print("{s}", .{json});
    }
};

// try std.json.stringify(.{
//   .id = row.text(0),
//   .title = row.nullableText(1),
//   .tags = Raw.init(row.nullableText(2)),
//   // ...
// }, .{}, writer);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //defer _ = gpa.deinit();
    defer std.testing.expect(gpa.deinit() == .ok) catch @panic("leak");

    const allocator = gpa.allocator();

    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    try std.json.stringify(.{
        .accept = NumericBoolean{ .value = true },
    }, .{}, arr.writer());

    std.debug.print("{s}\n", .{arr.items});

    //Outputting: {"accept":1}.
    try std.testing.expect(std.mem.eql(u8, arr.items, "{\"accept\":1}"));
    //std.testing.print("{}\n", .{mem.eql(u8, "hello", "h\x65llo")});      // true
    //std.testing.print("{}\n", .{mem.eql(u8, "💯", "\xf0\x9f\x92\xaf")}); // also true
}
