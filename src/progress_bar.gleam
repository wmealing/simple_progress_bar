import gleam/io
import gleam/iterator
import gleam/erlang/process
// import gleam/option

pub type SimpleProgressBar {
  SimpleProgressBar(label: String, current: Int, max: Int)
}

pub fn main() {

  let bar = SimpleProgressBar(label: "Progress", current: 0, max: 20)

  iterator.range(1,20)
  |> iterator.map (fn (x) {
    process.sleep(500)
      update(x, bar)} )
  |> iterator.run()

  complete()
}


pub fn update(value, bar: SimpleProgressBar) {
  case should_update(bar, value) {
    True -> {
      let newbar = do_update(bar, value)
      True
    }
    _ -> {
      False
    }
  }
}

pub fn should_update(bar: SimpleProgressBar, value: Int) {
  let SimpleProgressBar(label: _label, current: current, max: max) = bar
  current + value <= max
}

fn do_update(bar: SimpleProgressBar, value) {
  let SimpleProgressBar(label: label, current: current, max: max) = bar

  let new_value = current + value

  io.print("\r")
  io.print(label <> ": [")

  iterator.repeat(" ")
  |> iterator.take(max)
  |> iterator.map(io.print)
  |> iterator.run()

  io.print("]")

  io.print("\r")

  io.print(label <> ": [")

  iterator.repeat("#")
  |> iterator.take(new_value)
  |> iterator.map(io.print)
  |> iterator.run()



  SimpleProgressBar(label: label, current: new_value, max: max)
}

pub fn complete() {
  io.println("\n")
}
