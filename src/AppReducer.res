
@@warning("-44")
open Belt

type color = Blue | Red | Green | Violet

let startBalls = [
  Blue, Blue, Blue, Blue,
  Red, Red, Red, Red,
  Green, Green, Green, Green,
  Violet, Violet, Violet, Violet
]

let randomizeTubes = () => {
  let colors = Array.shuffle(startBalls)
  [
    Array.slice(colors, ~offset=0, ~len=4),
    Array.slice(colors, ~offset=4, ~len=4),
    Array.slice(colors, ~offset=8, ~len=4),
    Array.slice(colors, ~offset=12, ~len=4),
    [],
    []
  ]
}

type state= {
  moves: int,
  wins: int,
  tubes: array<array<color>>,
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
    | 4 => {
        let firstBall = balls[0]->Option.getExn
        let onlyFirst = Js.Array2.filter(balls, v => v == firstBall)
        Array.length(onlyFirst) == 4
      }
    | _ => false
    }
  })
}

let processClick = (state, ~source, ~target) => {
  let { wins, moves, tubes } = state
  let tubes = move(tubes, ~source, ~target)
  let isWin = isWin(tubes)

  switch isWin {
  | true => {
      tubes: randomizeTubes(),
      wins: wins + 1,
      moves: 0,
      current: None,
    }
  | false => {
      tubes,
      wins,
      moves: moves + 1,
      current: None,
    }
  }
}

let isEmpty = (tubes, index) => {
  let tube = tubes->Array.get(index)->Option.getExn
  Array.length(tube) == 0
}

let isRestrictedMove = (tubes, source, target) => {
  let sourceBall = tubes[source]->Option.getExn->Array.get(0)
  let targetBall = tubes[target]->Option.getExn->Array.get(0)

  switch (sourceBall, targetBall) {
  | (Some(b1), Some(b2)) if b1 != b2 => true
  | (None, _) => true
  | _ if source === target => true
  | _ => false
  }
}

let click = (state, target) => {
  switch state.current {
  | None if isEmpty(state.tubes, target) => state
  | None => { ...state, current: Some(target) }
  | Some(source) if isRestrictedMove(state.tubes, source, target) => state
  | Some(source) => processClick(state, ~source, ~target)
  }
}

let reducer = (state, action) => {
  switch action {
  | Click(tube) => click(state, tube)
  }
}

let init = () => {
  {
    wins: 0,
    moves: 0,
    current: None,
    tubes: randomizeTubes(),
  }
}
