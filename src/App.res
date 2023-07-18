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

let colorToString = (color) => {
  switch color {
  | Blue => "blue"
  | Red => "red"
  | Green => "green"
  | White => "white"
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducerWithMapState(reducer, startBalls, init)

  let ballMake = (i, ball) => {
    <div key={Int.toString(i)}>
      {ball->colorToString->React.string}
    </div>
  }

  let tubeMake = balls => balls->Array.mapWithIndex(ballMake)->React.array
  let fieldMake = tubes => tubes->Array.map(tubeMake)->React.array

  let field = fieldMake(state.tubes)

  <div className="App">
    field
  </div>
}
