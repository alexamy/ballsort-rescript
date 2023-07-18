@@warning("-44")
open Belt

type color = Blue | Red | Green | Violet
type tube = array<color>

type state = {
  moves: int,
  tubes: array<tube>,
}

type action = Move

let reducer = (state, action) => {
  switch action {
  | Move => state
  }
}


let startBalls = [
  Blue, Blue, Blue, Blue,
  Red, Red, Red, Red,
  Green, Green, Green, Green,
  Violet, Violet, Violet, Violet
]

let init = (balls) => {
  let balls = Array.shuffle(balls)
  let tubes = [
    Array.slice(balls, ~offset=0, ~len=4),
    Array.slice(balls, ~offset=4, ~len=4),
    Array.slice(balls, ~offset=8, ~len=4),
    Array.slice(balls, ~offset=12, ~len=4),
    [],
    []
  ]

  {
    moves: 0,
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

let ballMake = (i, ball) => {
  <div
    key={Int.toString(i)}
    style={{ background: colorToHex(ball) }}
    className="w-6 h-6 box-border mb-1 shrink-0 rounded-full border-2 border-black"
  />
}

module Tube = {
  @react.component
  let make = (~balls) => {
    <div className="flex flex-col w-8 justify-center align-bottom border-2">
      {balls->Array.mapWithIndex(ballMake)->React.array}
    </div>
  }
}

module Field = {
  @react.component
  let make = (~tubes) => {
    let tubes = Array.mapWithIndex(tubes, (i, tube) => {
      <Tube key={Int.toString(i)} balls={tube} />
    })

    <div className="flex space-x-3">
      {React.array(tubes)}
    </div>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducerWithMapState(reducer, startBalls, init)

  <div className="App">
    <Field tubes={state.tubes} />
  </div>
}
