
import { AchievementDialog } from './AchievementDialog';
import { TaskDetailDialog } from './TaskDetailDialog';
import { BroadCast, BroadCastType } from '../../common/utils/BroadCast';
import { TaskItem } from '../../model/TaskInitList';
import TaskInfo from '../../viewmodel/TaskInfo';
import Logger from '../../common/utils/Logger';

export class CustomDialogCallback {
  confirmCallback: Function = () => {};
  cancelCallback: Function = () => {};
}

@Component
export struct CustomDialogView {
  @State isShow: boolean = false;
  @Provide achievementLevel: number = 0;
  @Consume broadCast: BroadCast;
  @Provide currentTask: TaskInfo = TaskItem;
  @Provide dialogCallBack: CustomDialogCallback = new CustomDialogCallback();

  achievementDialog: CustomDialogController = new CustomDialogController({
    builder: AchievementDialog(),
    autoCancel: true,
    customStyle: true
  });

  taskDialog: CustomDialogController = new CustomDialogController({
    builder: TaskDetailDialog(),
    autoCancel: true,
    customStyle: true
  });

  aboutToAppear() {
    Logger.debug('CustomDialogView', 'aboutToAppear');
    this.broadCast.on(BroadCastType.SHOW_ACHIEVEMENT_DIALOG, (achievementLevel: number) => {
      Logger.debug('CustomDialogView', 'SHOW_ACHIEVEMENT_DIALOG');
      this.achievementLevel = achievementLevel;
      this.achievementDialog.open();
    });

    this.broadCast.on(BroadCastType.SHOW_TASK_DETAIL_DIALOG,
      (currentTask: TaskInfo, dialogCallBack: CustomDialogCallback) => {
        Logger.debug('CustomDialogView', 'SHOW_TASK_DETAIL_DIALOG');
        this.currentTask = currentTask || TaskItem;
        this.dialogCallBack = dialogCallBack;
        this.taskDialog.open();
      });
  }

  aboutToDisappear() {
    Logger.debug('CustomDialogView', 'aboutToDisappear');
  }

  build(){}
}
