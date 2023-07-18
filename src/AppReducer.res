
@@warning("-44")
open Belt

type state<'a> = {
  moves: int,
  tubes: array<array<'a>>,
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

let click = (state, tube) => {
  switch state.current {
  | None => { ...state, current: Some(tube) }
  | Some(source) if source == tube => state
  | Some(source) => {
      moves: state.moves + 1,
      tubes: move(state.tubes, ~source, ~target=tube),
      current: None
    }
  }
}

let reducer = (state, action) => {
  switch action {
  | Click(tube) => click(state, tube)
  }
}

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
    tubes,
    moves: 0,
    current: None,
  }
}
