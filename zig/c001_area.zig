/// reference https://cstutorialpoint.com/c-programming-examples/
///
const std = @import("std");

//Most of the time, it is more appropriate to write to stderr
const print = std.debug.print;

const PI: f32 = 3.14;

const Circle = struct {
    radius: f32 = undefined,

    fn new(radius: f32) Circle {
        return Circle{ .radius = radius };
    }

    fn init(self: *Circle, radius: f32) void {
        self.*.radius = radius;
    }

    fn getArea(self: Circle) f32 {
        return PI * self.radius * self.radius;
    }

    fn getCircleference(self: Circle) f32 {
        return 2 * PI * self.radius;
    }

    fn printMe(self: Circle) !void {
        // Write to stdout
        const stdout = std.io.getStdOut().writer();
        const strRadius = "Radius of Circle is";
        const strArea = "Area of Circle is";
        const strCircleference = "Circleference of Circle is";
        const strFormat = "{s:>26} : {d:10.2}\n";
        try stdout.print(strFormat, .{ strRadius, self.radius });
        try stdout.print(strFormat, .{ strArea, self.getArea() });
        try stdout.print(strFormat ++ "\n", .{ strCircleference, self.getCircleference() });
    }
};

pub fn main() !void {
    const fr: f32 = @floatFromInt(4);
    const aoc: f32 = PI * fr * fr;
    const coc: f32 = 2 * PI * fr;

    var c = Circle.new(8.0);
    try c.printMe();

    var c1 = Circle{};
    c1.init(6.0);
    try c1.printMe();

    const strPrompt =
        \\Radius        = {d:18.2}
        \\Area          = {d:18.2}
        \\Circleference = {d:18.2}
    ;
    print(strPrompt ++ "\n\n", .{ fr, aoc, coc });

    while (true) {
        const radius: f32 = get_number(f32) catch |err| {
            print("error2: {any}\n", .{err});
            continue;
        };

        if (radius < 0) {
            continue;
        } else if (radius == 0) {
            break;
        } else {
            printArea(radius);
        }
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
    print("       Radius of Circle is : {d:18.2}\n", .{radius});
    print("         Area of Circle is : {d:18.2}\n", .{aoc});
    print("Circleference of Circle is : {d:18.2}\n\n", .{coc});
}

fn get_float32() !f32 {
    const stdin = std.io.getStdIn().reader();
    // Adjust the buffer size depending on what length the input
    // will be or use "readUntilDelimiterOrEofAlloc"
    var buffer: [256]u8 = undefined;

    const strPrompt = "Enter the radius: ";
    print("{s:>26} :", .{strPrompt});

    if (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |value| {
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
    //print("Enter the radius ({any}): ", .{number_type});

    const strPrompt = "Enter the radius";
    print("{s} : ", .{strPrompt});

    // Adjust the buffer size depending on what length the input
    // will be or use "readUntilDelimiterOrEofAlloc"
    var buffer: [128]u8 = undefined;

    if (stdin.readUntilDelimiterOrEof(&buffer, '\n') catch |err| switch (err) {
        error.StreamTooLong => blk: {
            try stdin.skipUntilDelimiterOrEof('\n');
            break :blk &buffer;
        },
        else => |e| {
            print("error1: {any}, {any}\n", .{ e, buffer });
            return e;
        },
    }) |value| {
        const line = std.mem.trimRight(u8, value[0 .. value.len - 1], "r");
        print("line = {s}, value = {s}\n", .{ line, value });
        return switch (number_type) {
            f32 => try std.fmt.parseFloat(number_type, line),
            u32 => try std.fmt.parseInt(number_type, line, 10),
            else => @as(number_type, 0),
        };
    } else {
        return @as(number_type, 0);
    }
    // // Read until the '\n' char and capture the value if there's no error
    // if (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |value| {
    //     // We trim the line's contents to remove any trailing '\r' chars
    //     const line = std.mem.trimRight(u8, value[0 .. value.len - 1], "\r");
    //
    //     return switch (number_type) {
    //         f32 => try std.fmt.parseFloat(number_type, line),
    //         u32 => try std.fmt.parseInt(number_type, line, 10),
    //         else => @as(number_type, 0),
    //     };
    // } else {
    //     return @as(number_type, 0);
    // }
}
