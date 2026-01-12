//! EVM SDK Wrapper for zig-to-yul
//! Source: z2y template (no Rust reference)
const sdk = @import("zig_to_yul").evm;

// SDK 模块
pub const types = sdk.types;
pub const storage = sdk.storage;
pub const event_decode = sdk.event_decode;
pub const event_encode = sdk.event_encode;
pub const event = sdk.event;
pub const builtins = sdk.builtins_stub;
pub const builtins_spec = sdk.builtins;
pub const abi = sdk.abi;
pub const precompile = sdk.precompile;
pub const rpc = sdk.rpc;
pub const contract = sdk.contract;
pub const tx = sdk.tx;

// 基础类型
pub const U256 = sdk.U256;
pub const Address = sdk.Address;
pub const Mapping = sdk.Mapping;
pub const EvmType = sdk.EvmType;

// 集合类型
pub const Set = sdk.Set;
pub const Array = sdk.Array;
pub const Option = sdk.Option;
pub const Stack = sdk.Stack;
pub const Queue = sdk.Queue;
pub const Deque = sdk.Deque;
pub const EnumMap = sdk.EnumMap;
pub const PackedStruct = sdk.PackedStruct;
pub const BytesBuilder = sdk.BytesBuilder;
pub const StringBuilder = sdk.StringBuilder;

// EVM Builtins (直接导出，编译器识别 evm.xxx 形式)
pub const caller = builtins.caller;
pub const callvalue = builtins.callvalue;
pub const timestamp = builtins.timestamp;
pub const require = builtins.require;
pub const assert = builtins.assert;