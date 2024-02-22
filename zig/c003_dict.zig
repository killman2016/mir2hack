/// c003_dict.zig
///
const std = @import("std");

const Dict = struct {
    english: []const u8,
    transation: []const u8,
    example: []const u8,
};

pub fn main() !void {
    const x = Dict{ .english = "hello", .transation = "你好", .example = "Hello, World!" };

    var buf: [256]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    var string = std.ArrayList(u8).init(fba.allocator());
    try std.json.stringify(x, .{}, string.writer());

    const file = try std.fs.cwd().createFile(
        "junk_file.txt",
        .{ .read = true },
    );
    defer file.close();

    const bytes_written = try file.writeAll(string.items);
    std.debug.print("bytes written: {any}", .{bytes_written});

    // var file2 = try std.fs.cwd().openFile(
    //     "file.txt",
    //     .{ .open = true },
    // );
    // defer file2.close();
    // const file_size = (try file2.stat()).size;
    // var buffer = try allocator.alloc(u8, file_size);
}
