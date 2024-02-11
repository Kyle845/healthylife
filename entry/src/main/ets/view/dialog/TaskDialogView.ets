
import { TargetSettingDialog, RemindTimeDialog, FrequencyDialog } from './TaskSettingDialog';
import { BroadCast, BroadCastType } from '../../common/utils/BroadCast';
import Logger from '../../common/utils/Logger';
import { CommonConstants as Const } from '../../common/constants/CommonConstants';

export interface CustomDialogCallback {
  confirmCallback: Function;
  cancelCallback: Function;
}

@Component
export struct TaskDialogView {
  @State isShow: boolean = false;
  @Consume broadCast: BroadCast;

  targetSettingDialog: CustomDialogController = new CustomDialogController({
    builder: TargetSettingDialog(),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: Const.ZERO, dy: Const.MINUS_20 }
  });

  RemindTimeDialogController: CustomDialogController = new CustomDialogController({
    builder: RemindTimeDialog(),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: Const.ZERO, dy: Const.MINUS_20 }
  });

  FrequencyDialogController: CustomDialogController = new CustomDialogController({
    builder: FrequencyDialog(),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: Const.ZERO, dy: Const.MINUS_20 }
  });

  aboutToAppear() {
    Logger.debug('CustomDialogView', 'aboutToAppear');

    this.broadCast.on(BroadCastType.SHOW_TARGET_SETTING_DIALOG, () => {
      this.targetSettingDialog.open();
    })

    this.broadCast.on(BroadCastType.SHOW_REMIND_TIME_DIALOG, () => {
      this.RemindTimeDialogController.open();
    })

    this.broadCast.on(BroadCastType.SHOW_FREQUENCY_DIALOG, () => {
      this.FrequencyDialogController.open();
    })
  }

  aboutToDisappear() {
    Logger.debug('CustomDialogView', 'aboutToDisappear');
  }

  build() {}
}