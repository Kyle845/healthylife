
import TaskDetail from '../view/task/TaskDetailComponent';
import { CommonConstants as Const } from '../common/constants/CommonConstants';

@Entry
@Component
struct TaskEdit {
  build() {
    Row() {
      Navigation() {
        Column() {
          TaskDetail()
        }
        .width(Const.THOUSANDTH_1000)
        .height(Const.THOUSANDTH_1000)
      }
      .size({ width: Const.THOUSANDTH_1000, height: Const.THOUSANDTH_1000 })
      .title(Const.EDIT_TASK_TITLE)
      .titleMode(NavigationTitleMode.Mini)
    }
    .height(Const.THOUSANDTH_1000)
    .backgroundColor($r('app.color.primaryBgColor'))
  }
}