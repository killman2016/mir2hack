/// reference https://cstutorialpoint.com/c-programming-examples/
///
const std = @import("std");
const print = std.debug.print;
const PI: f32 = 3.14;

const Circle = struct {
    radius: f32 = undefined,

    pub fn new(radius: f32) Circle {
        return Circle{ .radius = radius };
    }

    pub fn init(self: *Circle, radius: f32) void {
        self.*.radius = radius;
    }

    pub fn getArea(self: Circle) f32 {
        return PI * self.radius * self.radius;
    }

    pub fn getCircleference(self: Circle) f32 {
        return 2 * PI * self.radius;
    }

    pub fn printMe(self: Circle) void {
        print("Radius of Circle is : {d:.2}\n", .{self.radius});
        print("Area of Circle is : {d:.2}\n", .{self.getArea()});
        print("Circleference of Circle is : {d:.2}\n\n", .{self.getCircleference()});
    }
};

pub fn main() !void {
    const fr: f32 = @floatFromInt(4);
    const aoc: f32 = PI * fr * fr;
    const coc: f32 = 2 * PI * fr;

    var c = Circle.new(8.0);
    c.printMe();

    var c1 = Circle{};
    c1.init(6.0);
    c1.printMe();

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
        else => fr = @as(f32, 0),
    }

    const aoc: f32 = PI * fr * fr;
    const coc: f32 = 2.0 * PI * fr;
    print("Radius of Circle is : {d:.2}\n", .{radius});
    print("Area of Circle is : {d:.2}\n", .{aoc});
    print("Circleference of Circle is : {d:.2}\n\n", .{coc});
}

fn get_float32() !f32 {
    const stdin = std.io.getStdIn().reader();
    // Adjust the buffer size depending on what length the input
    // will be or use "readUntilDelimiterOrEofAlloc"
    var buffer: [256]u8 = undefined;
    print("Enter the radius: ", .{});
    if (try stdin.readUntilDelimiterOrEof(buffer[0..], '\n')) |value| {
        // We trim the line's contents to remove any trailing '\r' chars
        const line = std.mem.trimRight(u8, value[0 .. value.len - 1], "\r");
        return try std.fmt.parseFloat(f32, line);
    } else {
        return @as(f32, 0);
    }
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
            u32 => try std.fmt.parseInt(number_type, line, 10),
            else => @as(number_type, 0),
        };
    } else {
        return @as(number_type, 0);
    }
}
