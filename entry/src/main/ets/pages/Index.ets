import { ProfileCard } from '../components/ProfileCard';
import { ThemeManager } from '../common/ThemeManager';

@Entry
@Component
struct Index {
  @State index: number = 0

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Row() {
          Text($r('app.string.home_title'))
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
          Blank()
          Image($r('app.media.theme_icon'))
            .width(28)
            .height(28)
            .onClick(() => ThemeManager.toggle())
        }
        .width('100%')

        Swiper() {
          ProfileCard({ name: 'Alex Chen', role: 'HarmonyOS Developer' })
            .padding({bottom: 28})
          ProfileCard({ name: 'Maria Lopez', role: 'UI Designer' })
            .padding({bottom: 28})
          ProfileCard({ name: 'Sam Patel', role: 'Product Manager' })
            .padding({bottom: 28})
        }
        .index($$this.index)
        .indicator(
          new DotIndicator()
            .color($r('app.color.divider'))
            .selectedColor($r('app.color.text_primary'))
        )
      }
      .width('100%')
      .padding(24)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .scrollBar(BarState.Off)
    .backgroundColor($r('app.color.page_bg'))
  }

}
