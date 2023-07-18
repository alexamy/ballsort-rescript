@@warning("-44")
open Belt

type color = Blue | Red | Green | Violet

let startBalls = [
  Blue, Blue, Blue, Blue,
  Red, Red, Red, Red,
  Green, Green, Green, Green,
  Violet, Violet, Violet, Violet
]

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
  let make = (~colors, ~onClick) => {
    let balls = Array.mapWithIndex(colors, (i, color) => {
      <Ball color key={Int.toString(i)} />
    })

    <div onClick className="flex flex-col justify-end w-6 min-h-56 h-56 align-bottom cursor-pointer">
      {React.array(balls)}
    </div>
  }
}

module Field = {
  @react.component
  let make = (~tubes, ~dispatch) => {
    let tubes = Array.mapWithIndex(tubes, (index, colors) => {
      <Tube
        colors
        onClick={(_) => dispatch(AppReducer.Click(index))}
        key={Int.toString(index)}
      />
    })

    <div className="flex items-end space-x-3">
      {React.array(tubes)}
    </div>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducerWithMapState(
    AppReducer.reducer,
    startBalls,
    AppReducer.init,
  )

  <div className="App">
    <Field dispatch tubes={state.tubes} />
    <div>
      {React.string("Moves: ")}
      {React.int(state.moves)}
    </div>
  </div>
}
