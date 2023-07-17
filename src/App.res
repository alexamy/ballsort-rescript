type color = Blue | Red | Green | White

type action = Randomize
type state = {
  moves: int,
  balls: array<array<color>>,
}

let shuffle = (array) => {
  let result = []
  let copy = Js.Array2.copy(array)

  while Js.Array2.length(copy) > 0 {
    let index = Js.Math.random_int(0, Js.Array2.length(copy))
    let value = Js.Array2.spliceInPlace(copy, ~pos=index, ~remove=1)
    Js.Array2.push(result, value)->ignore
  }

  result
}

let reducer = (state, action) => {
  switch action {
  | Randomize => state
  }
}

let defaultState = {
  moves: 0,
  balls: [
    [Blue, Blue, Blue, Blue],
    [Red, Red, Red, Red],
    [Green, Green, Green, Green],
    [White, White, White, White],
    [],
    [],
  ]
}


@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, defaultState)

  <div className="App">
    {React.string("Hello")}
  </div>
}
