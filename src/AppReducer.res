
@@warning("-44")
open Belt

type color = Blue | Red | Green | Violet

type state<'a> = {
  moves: int,
  wins: int,
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

let isWin = (tubes) => {
  Array.every(tubes, (balls) => {
    switch Array.length(balls) {
    | 0 => true
    | length => {
        let firstBall = balls[0]->Option.getExn
        let onlyFirst = Js.Array2.filter(balls, v => v == firstBall)

        length == Array.length(onlyFirst)
      }
    }
  })
}

let click = (state, target) => {
  let targetTube = state.tubes->Array.get(target)->Option.getExn
  let isEmpty = Array.length(targetTube) == 0

  switch state.current {
  | None if isEmpty => state
  | None => { ...state, current: Some(target) }
  | Some(source) if source == target => state
  | Some(source) => {
      let tubes = move(state.tubes, ~source, ~target)
      let isWin = isWin(tubes)

      {
        tubes: isWin ? tubes : tubes,
        wins: state.wins + (isWin ? 1 : 0),
        moves: state.moves + 1,
        current: None,
      }
    }
  }
}

let reducer = (state, action) => {
  switch action {
  | Click(tube) => click(state, tube)
  }
}

let randomizeTubes = (colors) => {
  let colors = Array.shuffle(colors)
  [
    Array.slice(colors, ~offset=0, ~len=4),
    Array.slice(colors, ~offset=4, ~len=4),
    Array.slice(colors, ~offset=8, ~len=4),
    Array.slice(colors, ~offset=12, ~len=4),
    [],
    []
  ]
}

let startBalls = [
  Blue, Blue, Blue, Blue,
  Red, Red, Red, Red,
  Green, Green, Green, Green,
  Violet, Violet, Violet, Violet
]

let init = (colors) => {
  {
    wins: 0,
    moves: 0,
    current: None,
    tubes: randomizeTubes(colors),
  }
}
