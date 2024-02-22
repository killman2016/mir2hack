/// Reading a JSON config in Zig
/// https://www.openmymind.net/Reading-A-Json-Config-In-Zig/
/// c002_json.zig
const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // defer _ = gpa.deinit();
    defer std.testing.expect(gpa.deinit() == .ok) catch @panic("leak");

    const allocator = gpa.allocator();
    const parsed = try readConfig(allocator, ".\\config.json");
    defer parsed.deinit();

    const config = parsed.value;
    std.debug.print("root: {s}\nname: {s}\nage: {d}\n", .{ config.root, config.name, config.age });
    std.debug.print("money: {d:.2}\n", .{config.money});
}

fn readConfig(allocator: Allocator, path: []const u8) !std.json.Parsed(Config) {
    // 512 is the maximum size to read, if your config is larger
    // you should make this bigger.
    const data = try std.fs.cwd().readFileAlloc(allocator, path, 512);
    defer allocator.free(data);
    return std.json.parseFromSlice(Config, allocator, data, .{ .allocate = .alloc_always });
}

const Config = struct {
    root: []const u8,
    name: []const u8,
    age: u32,
    money: f32,
};

// example:
// config.json
// {
// 	"root": "..\\test\\config.json",
// 	"name": "Angela Chao",
// 	"age": 36,
// 	"money": 35.61
// }
