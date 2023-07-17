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

  {
    moves: 0,
    tubes: [
      balls->Array.slice(~offset=0, ~len=4),
      balls->Array.slice(~offset=4, ~len=4),
      balls->Array.slice(~offset=8, ~len=4),
      balls->Array.slice(~offset=12, ~len=4),
      [],
      []
    ],
  }
}


@react.component
let make = () => {
  let (state, dispatch) = React.useReducerWithMapState(reducer, startBalls, init)

  Js.log(state)

  <div className="App">
    {React.string("Hello")}
  </div>
}
