type color = Blue | Red | Green | White

type action = Randomize
type state = {
  moves: int,
  balls: array<array<color>>,
}

let reducer = (state, action) => {
  switch action {
  | Randomize => state
  }
}


@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, {
    moves: 0,
    balls: [
      [Blue, Blue, Blue, Blue],
      [Red, Red, Red, Red],
      [Green, Green, Green, Green],
      [White, White, White, White],
      [],
      [],
    ]
  })

  <div className="App">
    {React.string("Hello")}
  </div>
}
