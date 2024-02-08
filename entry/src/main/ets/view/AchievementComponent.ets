import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { BadgePanel } from './BadgePanelComponent';
import { TitleBar } from './TitleBarComponent';
import Logger from '../common/utils/Logger';

@Component
export struct AchievementIndex {
  aboutToAppear(){
    Logger.debug('AchievementIndex', 'aboutToAppear')
  }

  onPageShow() {
    Logger.debug('AchievementIndex', 'onPageShow')
  }

  build() {
    Column({space: Const.DEFAULT_20}){
      TitleBar()
      BadgePanel()
    }
    .padding(Const.DEFAULT_10)
    .height(Const.FULL_HEIGHT)
    .width(Const.FULL_WIDTH)
    .backgroundColor($r('app.color.black'))
  }
}