pub fn checkResult(result: c_int) !void {
    if (result != 0) {
        return error.XGBoostError;
    }
}

pub fn boolToCInt(@"bool": bool) c_int {
    return if (@"bool") 0 else -1;
}

pub const c = @cImport({
    @cInclude("xgboost/c_api.h");
});
