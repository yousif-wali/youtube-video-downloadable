const std = @import("std");

/// Check if Python's `yt-dlp` is installed
fn yt_dlp_installed() bool {
    var process = std.process.Child.init(&[_][]const u8{"python3", "-m", "yt_dlp", "--version"}, std.heap.page_allocator);
    if (process.spawnAndWait()) |_| {
        return true; // ✅ `yt-dlp` is installed
    } else |_| {
        return false; // ❌ `yt-dlp` is missing
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    // ✅ Check if `yt-dlp` is installed
    if (!yt_dlp_installed()) {
        std.debug.print("🚨 Python's `yt-dlp` is not installed! Install it with:\n", .{});
        std.debug.print("\n    python3 -m pip install -U yt-dlp\n\n", .{});
        return;
    }

    // ✅ Ask user for YouTube URL
    try stdout.writeAll("Enter YouTube video URL: ");
    var url_buffer: [256]u8 = undefined;
    const url_bytes = try stdin.readUntilDelimiterOrEof(&url_buffer, '\n') orelse {
        std.debug.print("🚨 Error: No URL entered.\n", .{});
        return;
    };
    const url = std.mem.trimRight(u8, url_bytes, "\r\n");

    if (url.len == 0 or !std.mem.startsWith(u8, url, "http")) {
        std.debug.print("🚨 Error: Invalid URL format. Must start with http or https.\n", .{});
        return;
    }

    // ✅ Get available formats
    std.debug.print("\nFetching available formats...\n", .{});
    var list_formats = std.process.Child.init(
        &[_][]const u8{"python3", "-m", "yt_dlp", "--list-formats", url},
        allocator
    );

    list_formats.stdin_behavior = .Inherit;
    list_formats.stdout_behavior = .Inherit;
    list_formats.stderr_behavior = .Inherit;

    try list_formats.spawn();
    _ = list_formats.wait() catch std.debug.print("🚨 Error: Failed to fetch formats.\n", .{});

    // ✅ Ask user for download format
    try stdout.writeAll("\nEnter preferred format from the list above (or press Enter for best): ");
    var format_buffer: [16]u8 = undefined;
    const format_bytes = try stdin.readUntilDelimiterOrEof(&format_buffer, '\n') orelse "best";

    const format = if (format_bytes.len > 0)
        std.mem.trimRight(u8, format_bytes, "\r\n")
    else
        "best"; // Default format

    // ✅ Ensure 'zig-downloader' directory exists
    const download_folder = "../zig-downloader";
    std.fs.cwd().makeDir(download_folder) catch |err| {
        if (err != error.PathAlreadyExists) {
            std.debug.print("🚨 Error creating directory: {s}\n", .{@errorName(err)});
            return;
        }
    };

    // ✅ Call Python's `yt-dlp` to download the video
    std.debug.print("\nDownloading video from {s} in format {s}...\n", .{ url, format });

    var process = std.process.Child.init(
        &[_][]const u8{"python3", "-m", "yt_dlp", "-o", "./zig-downloader/%(title)s.%(ext)s", "-f", format, url},
        allocator
    );

    process.stdin_behavior = .Inherit;
    process.stdout_behavior = .Inherit;
    process.stderr_behavior = .Inherit;

    try process.spawn();
    _ = process.wait() catch std.debug.print("🚨 Error: Failed to execute yt-dlp.\n", .{});

    std.debug.print("\n✅ Download complete! Videos are saved in 'zig-downloader' folder.\n", .{});
}
