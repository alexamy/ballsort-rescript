@@warning("-44")
open Belt

type color = Blue | Red | Green | White
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
  White, White, White, White
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


@react.component
let make = () => {
  let (state, dispatch) = React.useReducerWithMapState(reducer, startBalls, init)

  <div className="App">
    {React.string("Hello")}
  </div>
}
