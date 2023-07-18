@@warning("-44")
open Belt

type color = Blue | Red | Green | Violet
type tube = array<color>

type state = {
  moves: int,
  tubes: array<tube>,
  current: option<int>,
}

type action =
| Click(int)

let move = (tubes, ~source, ~target) => {
  Array.mapWithIndex(tubes, (i, tube) => {
    if i === source {
      Array.sliceToEnd(tube, 1)
    } else if i === target {
      let top = tubes[source]->Option.getExn->Array.get(0)
      switch top {
      | Some(ball) => Array.concat([ball], tube)
      | None => tube
      }
    } else {
      tube
    }
  })
}

let reducer = (state, action) => {
  switch action {
  | Click(tube) => {
      moves: state.moves + 1,
      current: Option.isSome(state.current) ? None : Some(tube),
      tubes: switch state.current {
        | Some(source) => move(state.tubes, ~source, ~target=tube)
        | None => state.tubes
      }
    }
  }
}


let startBalls = [
  Blue, Blue, Blue, Blue,
  Red, Red, Red, Red,
  Green, Green, Green, Green,
  Violet, Violet, Violet, Violet
]

let init = (colors) => {
  let colors = Array.shuffle(colors)
  let tubes = [
    Array.slice(colors, ~offset=0, ~len=4),
    Array.slice(colors, ~offset=4, ~len=4),
    Array.slice(colors, ~offset=8, ~len=4),
    Array.slice(colors, ~offset=12, ~len=4),
    [],
    []
  ]

  {
    moves: 0,
    current: None,
    tubes,
  }
}

let colorToHex = (color) => {
  switch color {
  | Blue => "#0097e6"
  | Red => "#c23616"
  | Green => "#44bd32"
  | Violet => "#8c7ae6"
  }
}

module Ball = {
  @react.component
  let make = (~color) => {
    <div
      style={{ background: colorToHex(color) }}
      className="w-6 h-6 box-border mb-1 shrink-0 rounded-full border-2 border-black"
    />
  }
}

module Tube = {
  @react.component
  let make = (~colors, ~index) => {
    let balls = Array.mapWithIndex(colors, (i, color) => {
      <Ball color key={Int.toString(i)} />
    })

    <div className="flex flex-col w-6 align-bottom">
      {React.array(balls)}
    </div>
  }
}

module Field = {
  @react.component
  let make = (~tubes) => {
    let tubes = Array.mapWithIndex(tubes, (index, colors) => {
      <Tube colors index key={Int.toString(index)} />
    })

    <div className="flex items-end space-x-3 h-56">
      {React.array(tubes)}
    </div>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducerWithMapState(reducer, startBalls, init)

  <div className="App">
    <Field tubes={state.tubes} />
    <div>
      {React.string("Moves: ")}
      {React.int(state.moves)}
    </div>
  </div>
}
