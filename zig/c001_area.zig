const std = @import("std");
const print = std.debug.print;
const PI: f32 = 3.14;

pub fn main() !void {
    const fr: f32 = @floatFromInt(4);
    const aoc: f32 = PI * fr * fr;
    const coc: f32 = 2 * PI * fr;

    print("radius = {d:.2} area = {d:.2} circleference = {d:.2}\n", .{ fr, aoc, coc });

    while (true) {
        const ur: f32 = get_number(f32) catch continue;
        if (ur == 0) break;
        printArea(ur);
    }
}

fn printArea(radius: anytype) void {
    var fr: f32 = undefined;

    switch (@TypeOf(radius)) {
        u32, i32 => fr = @floatFromInt(radius),
        f32 => fr = radius,
        else => fr = 0,
    }

    const aoc: f32 = PI * (fr * fr);
    const coc: f32 = 2 * PI * fr;

    print("Area of Circle is : {d:.6}\n", .{aoc});
    print("Circleference of Circle is : {d:.6}\n", .{coc});
}

// We can read any arbitrary number type with number_type
fn get_number(comptime number_type: type) !number_type {
    const stdin = std.io.getStdIn().reader();
    print("Enter the radius ({any}): ", .{number_type});
    // Adjust the buffer size depending on what length the input
    // will be or use "readUntilDelimiterOrEofAlloc"
    var buffer: [256]u8 = undefined;

    // Read until the '\n' char and capture the value if there's no error
    if (try stdin.readUntilDelimiterOrEof(buffer[0..], '\n')) |value| {
        // We trim the line's contents to remove any trailing '\r' chars
        const line = std.mem.trimRight(u8, value[0 .. value.len - 1], "\r");

        return switch (number_type) {
            f32 => try std.fmt.parseFloat(number_type, line),
            //u32 => std.fmt.parseInt(number_type, line, 10) catch return error.InvalidCharacter,
            u32 => try std.fmt.parseInt(number_type, line, 10),
            else => @as(number_type, 0),
        };
    } else {
        return @as(number_type, 0);
    }
}
