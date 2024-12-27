import gleam/string

pub fn replace(
  in format_string: String,
  replace label: String,
  with data: a,
) -> String {
  let to_replace = "{" <> label <> "}"
  string.replace(
    in: format_string,
    each: to_replace,
    with: string.inspect(data),
  )
}
