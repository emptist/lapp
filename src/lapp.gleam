import gleam/dynamic/decode
import gleam/int
import gleam/list
import lustre.{application, start}
import lustre/attribute.{height, src, width}
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html.{button, div, img, p, text}
import lustre/event
import rsvp

pub fn main() {
  let app = application(init, update, view)
  let assert Ok(_) = app |> start("#app", Nil)
  // let _ = app |> start("#app", Nil)

  Nil
}

type Model {
  Model(total: Int, cats: List(Cat))
}

type Cat {
  Cat(id: String, url: String)
}

fn init(_args) -> #(Model, Effect(Msg)) {
  let model = Model(total: 0, cats: [])

  #(model, effect.none())
}

type Msg {
  UserClickedAddCat
  UserClickedRemoveCat
  ApiReturnedCats(Result(List(Cat), rsvp.Error))
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserClickedAddCat -> #(Model(..model, total: model.total + 1), get_cat())

    UserClickedRemoveCat -> #(
      Model(total: model.total - 1, cats: list.drop(model.cats, 1)),
      effect.none(),
    )

    ApiReturnedCats(Ok(cats)) -> #(
      Model(..model, cats: list.append(model.cats, cats)),
      effect.none(),
    )

    ApiReturnedCats(Error(_)) -> #(model, effect.none())
  }
}

fn get_cat() -> Effect(Msg) {
  let decoder = {
    use id <- decode.field("id", decode.string)
    use url <- decode.field("url", decode.string)

    decode.success(Cat(id:, url:))
  }
  let url = "https://api.thecatapi.com/v1/images/search"
  let handler = rsvp.expect_json(decode.list(decoder), ApiReturnedCats)

  rsvp.get(url, handler)
}

fn view(model: Model) -> Element(Msg) {
  div([], [
    div([], [
      button([event.on_click(UserClickedAddCat)], [text("Add cat")]),
      p([], [text(int.to_string(model.total))]),
      button([event.on_click(UserClickedRemoveCat)], [
        text("Remove cat"),
      ]),
    ]),
    div([], {
      list.map(model.cats, fn(cat) {
        img([
          src(cat.url),
          width(400),
          height(400),
        ])
      })
    }),
  ])
}
