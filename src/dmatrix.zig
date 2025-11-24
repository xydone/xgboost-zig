handle: DMatrixHandle,

pub const DMatrix = @This();
pub const DMatrixHandle = c.DMatrixHandle;
pub const DataIterHandle = c.DataIterHandle;

pub fn deinit(self: DMatrix) void {
    const result = c.XGDMatrixFree(self.handle);
    checkResult(result) catch @panic("Freeing matrix failed");
}

pub fn initFromFile(file_name: []const u8, silent: bool) DMatrix {
    var dmatrix_handle: DMatrixHandle = undefined;
    const result = c.XGDMatrixCreateFromFile(
        file_name,
        boolToCInt(silent),
        &dmatrix_handle,
    );

    try checkResult(result);

    return .{ .handle = dmatrix_handle };
}

pub fn initFromURI(
    allocator: std.mem.Allocator,
    config: []const u8,
) DMatrix {
    const c_config = try allocator.dupeZ(u8, config);
    defer allocator.free(c_config);

    var dmatrix_handle: DMatrixHandle = undefined;

    const result = c.XGDMatrixCreateFromURI(
        c_config,
        &dmatrix_handle,
    );

    try checkResult(result);

    return .{ .handle = dmatrix_handle };
}

pub fn initFromColumnar(
    allocator: std.mem.Allocator,
    data: []const u8,
    config: []const u8,
) DMatrix {
    const c_data = try allocator.dupeZ(u8, data);
    defer allocator.free(c_data);

    const c_config = try allocator.dupeZ(u8, config);
    defer allocator.free(c_config);

    var dmatrix_handle: DMatrixHandle = undefined;

    const result = c.XGDMatrixCreateFromColumnar(
        c_data,
        c_config,
        &dmatrix_handle,
    );

    try checkResult(result);

    return .{ .handle = dmatrix_handle };
}

pub fn initFromMatrix(
    data: []f32,
    rows: u64,
    cols: u64,
    missing: f32,
    options: struct {
        /// Leave null for no OpenMP
        thread_count: ?u32,
    },
) DMatrix {
    var dmatrix_handle: DMatrixHandle = undefined;

    const result = blk: {
        if (options.thread_count) |thread_count| {
            break :blk c.XGDMatrixCreateFromMat_omp(
                data,
                rows,
                cols,
                missing,
                &dmatrix_handle,
                thread_count,
            );
        } else {
            break :blk c.XGDMatrixCreateFromMat(
                data.ptr,
                rows,
                cols,
                missing,
                &dmatrix_handle,
            );
        }
    };

    try checkResult(result);

    return .{ .handle = dmatrix_handle };
}

pub fn setFloatInfo(self: DMatrix, field: []const u8, array: []f32) !void {
    const result = c.XGDMatrixSetFloatInfo(self.handle, field.ptr, array.ptr, array.len);

    try checkResult(result);
}

//pub extern fn XGDMatrixCreateFromCSR(indptr: [*c]const u8, indices: [*c]const u8, data: [*c]const u8, ncol: u64, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromDense(data: [*c]const u8, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromCSC(indptr: [*c]const u8, indices: [*c]const u8, data: [*c]const u8, nrow: u64, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromCudaColumnar(data: [*c]const u8, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromCudaArrayInterface(data: [*c]const u8, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromDataIter(data_handle: DataIterHandle, callback: ?*const XGBCallbackDataIterNext, cache_info: [*c]const u8, missing: f32, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGProxyDMatrixCreate(out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromCallback(iter: DataIterHandle, proxy: DMatrixHandle, reset: ?*const DataIterResetCallback, next: ?*const XGDMatrixCallbackNext, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGQuantileDMatrixCreateFromCallback(iter: DataIterHandle, proxy: DMatrixHandle, ref: DataIterHandle, reset: ?*const DataIterResetCallback, next: ?*const XGDMatrixCallbackNext, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGExtMemQuantileDMatrixCreateFromCallback(iter: DataIterHandle, proxy: DMatrixHandle, ref: DataIterHandle, reset: ?*const DataIterResetCallback, next: ?*const XGDMatrixCallbackNext, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGProxyDMatrixSetDataCudaArrayInterface(handle: DMatrixHandle, data: [*c]const u8) c_int;

//pub extern fn XGProxyDMatrixSetDataColumnar(handle: DMatrixHandle, data: [*c]const u8) c_int;

//pub extern fn XGProxyDMatrixSetDataCudaColumnar(handle: DMatrixHandle, data: [*c]const u8) c_int;

//pub extern fn XGProxyDMatrixSetDataDense(handle: DMatrixHandle, data: [*c]const u8) c_int;

//pub extern fn XGProxyDMatrixSetDataCSR(handle: DMatrixHandle, indptr: [*c]const u8, indices: [*c]const u8, data: [*c]const u8, ncol: u64) c_int;

//pub extern fn XGDMatrixSliceDMatrix(handle: DMatrixHandle, idxset: [*c]const c_int, len: u64, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixSliceDMatrixEx(handle: DMatrixHandle, idxset: [*c]const c_int, len: u64, out: [*c]DMatrixHandle, allow_groups: c_int) c_int;

//pub extern fn XGDMatrixSaveBinary(handle: DMatrixHandle, fname: [*c]const u8, silent: c_int) c_int;

//pub extern fn XGDMatrixSetInfoFromInterface(handle: DMatrixHandle, field: [*c]const u8, data: [*c]const u8) c_int;

//pub extern fn XGDMatrixSetUIntInfo(handle: DMatrixHandle, field: [*c]const u8, array: [*c]const c_uint, len: u64) c_int;

//pub extern fn XGDMatrixSetStrFeatureInfo(handle: DMatrixHandle, field: [*c]const u8, features: [*c][*c]const u8, size: u64) c_int;

//pub extern fn XGDMatrixGetStrFeatureInfo(handle: DMatrixHandle, field: [*c]const u8, size: [*c]u64, out_features: [*c][*c][*c]const u8) c_int;

//pub extern fn XGDMatrixSetDenseInfo(handle: DMatrixHandle, field: [*c]const u8, data: ?*const anyopaque, size: u64, @"type": c_int) c_int;

//pub extern fn XGDMatrixGetFloatInfo(handle: DMatrixHandle, field: [*c]const u8, out_len: [*c]u64, out_dptr: [*c][*c]const f32) c_int;

//pub extern fn XGDMatrixGetUIntInfo(handle: DMatrixHandle, field: [*c]const u8, out_len: [*c]u64, out_dptr: [*c][*c]const c_uint) c_int;

//pub extern fn XGDMatrixNumRow(handle: DMatrixHandle, out: [*c]u64) c_int;

//pub extern fn XGDMatrixNumCol(handle: DMatrixHandle, out: [*c]u64) c_int;

//pub extern fn XGDMatrixNumNonMissing(handle: DMatrixHandle, out: [*c]u64) c_int;

//pub extern fn XGDMatrixDataSplitMode(handle: DMatrixHandle, out: [*c]u64) c_int;

//pub extern fn XGDMatrixGetDataAsCSR(handle: DMatrixHandle, config: [*c]const u8, out_indptr: [*c]u64, out_indices: [*c]c_uint, out_data: [*c]f32) c_int;

//pub extern fn XGDMatrixGetQuantileCut(handle: DMatrixHandle, config: [*c]const u8, out_indptr: [*c][*c]const u8, out_data: [*c][*c]const u8) c_int;

pub const XGDMatrixCallbackNext = fn (DataIterHandle) callconv(.c) c_int;

pub const DataIterResetCallback = fn (DataIterHandle) callconv(.c) void;

const c = @import("common.zig").c;
const checkResult = @import("common.zig").checkResult;
const boolToCInt = @import("common.zig").boolToCInt;

const std = @import("std");
