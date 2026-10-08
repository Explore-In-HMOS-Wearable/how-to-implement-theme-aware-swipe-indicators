// A regular component: no state, no theme code. Every color comes from resources,
// so it switches automatically when the color mode changes.
@Component
export struct ProfileCard {
  name: string = '';
  role: string = '';

  build() {
    Row({ space: 16 }) {
      Text(this.name.charAt(0))
        .width(48)
        .height(48)
        .borderRadius(24)
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.on_accent'))
        .backgroundColor($r('app.color.accent'))

      Column({ space: 4 }) {
        Text(this.name)
          .fontSize(17)
          .maxLines(1)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.role)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
    .borderRadius(16)
    .backgroundColor($r('app.color.card_bg'))
    .border({ width: 1, color: $r('app.color.divider') })
  }
}
