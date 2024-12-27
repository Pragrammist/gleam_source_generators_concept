/// That code of how source generator will be used
/// 
/// Code that generate code will place in another project
/// in src/source_generator
/// so you can import another exteranl source generators and use it in project
/// idealy src/source_generator should compile in rust code
/// but for time it may be executable in erlang
/// source generator functions can be called through cli
/// 
/// with gleam cli tool you can manualy call certain source generator functions
/// also it's import to cli add some ability of rollback if source generation have not been worked correctly
/// I think cli just need save prev state for every source generator function
/// 
/// you can generate code for function, for type and for existing module
/// also you can generate new modules
/// for type, function and existing module generation it can be configure bu @generate attriube
/// but for generating new modules it need be configure in gleam.toml
/// 
import gleam/io

pub fn main() {
  io.println("Hi mom")
}

pub type SomeCoolType {
  SomeCoolTypeRecord(
    cool_str: String,
    cool_int: Int,
    another_cool_type: AnotherCoolType,
  )
}

pub type AnotherCoolType {
  AnotherCoolTypeRecord(yet_cool: String)
}

///@generate(
/// fun_for_generation: "generate_json_deserelazation",
/// place_generation: Inner
/// // It's necessary to pass type and record
/// // here's impossible to determine record type in empty function
/// parameters:[
///  #("AnotherCoolType": "AnotherCoolTypeRecord")
///  #("SomeCoolType": "SomeCoolTypeRecord"),
/// ]
///)
pub fn deserelize_json(input: String) -> SomeCoolType {
  todo
}

///@generate(
/// fun_for_generation: "generate_json_serelazation",
/// place_generation: Below  
///)
pub type SomeSerelizedType

/// doc comment in source_generator.gleam
pub type PlaceGeneration {
  Inner
  Replace
  Above
  Below
}
///------Some random/gleam/module --------
/// @generate(
///   fun_for_generation: "generate_some_fn_and_types_in_module"
/// )
/// //So due to this attribute in module generate_some_fn_and_types_in_module generate code in module 
/// 
///------Some random/gleam/module --------
