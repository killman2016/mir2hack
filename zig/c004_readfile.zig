/// c004_readfile.zig
/// 
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //defer _ = gpa.deinit();
    defer std.testing.expect(gpa.deinit() == .ok) catch @panic("leak");

    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage:\n\tc004_readfile.exe junk_file.txt", .{});
        return;
    }
    const file = try std.fs.cwd().openFile(args[1], .{});
    const file_content = try file.readToEndAlloc(allocator, 1024 * 1024); // 1MB max read size
    defer allocator.free(file_content);

    std.debug.print("{s}", .{file_content});
}
