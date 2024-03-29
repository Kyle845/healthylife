import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import {
  columnDayInfoList,
  columnGlobalInfoList,
  columnTaskInfoList,
  columnFormInfoList
} from '../model/RdbColumnModel';
import RdbUtils from '../common/database/rdb/RdbUtils';
import Logger from '../common/utils/Logger';
import FormUtils from '../common/utils/FormUtils';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { GlobalContext } from '../common/utils/GlobalContext';

export default class EntryAbility extends UIAbility {

  private static TAG: string = 'EntryAbility';

  async onCreate(want, launchParam) {
    GlobalContext.getContext().setObject('want', want);
    GlobalContext.getContext().setObject('launchParam', launchParam);
    RdbUtils.initDb(this.context, Const.RDB_NAME.dbName ? Const.RDB_NAME.dbName : '');
    await RdbUtils.createDb();
    RdbUtils.createTable(Const.DAY_INFO.tableName ? Const.DAY_INFO.tableName : '', columnDayInfoList).then(() => {
      Logger.info(`RdbHelper createTable dayInfo success`);
    }).catch((err: Error) => {
      Logger.error(`RdbHelper dayInfo err : ${JSON.stringify(err)}`);
    });

    RdbUtils.createTable(Const.GLOBAL_INFO.tableName ? Const.GLOBAL_INFO.tableName : '', columnGlobalInfoList).then(() => {
      Logger.info(`RdbHelper createTable globalInfo success`);
    }).catch((err: Error) => {
      Logger.error(`RdbHelper globalInfo err : ${JSON.stringify(err)}`);
    });

    RdbUtils.createTable(Const.TASK_INFO.tableName ? Const.TASK_INFO.tableName : '', columnTaskInfoList).then(() => {
      Logger.info(`RdbHelper createTable taskInfo success`);
    }).catch((err: Error) => {
      Logger.error(`RdbHelper taskInfo err : ${JSON.stringify(err)}`);
    });

    RdbUtils.createTable(Const.FORM_INFO.tableName ? Const.FORM_INFO.tableName : '', columnFormInfoList)
      .catch((err: Error) => {
        Logger.error(`RdbHelper formInfo err : ${JSON.stringify(err)}`);
      });
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    GlobalContext.getContext().setObject('isForeground', true);
    windowStage.loadContent('pages/SplashPage', (err, data) => {
      if (err.code) {
        Logger.error('windowStage', 'Failed to load the content. Cause: ' + JSON.stringify(err));
        return;
      }
      Logger.info('windowStage', 'Succeeded in loading the content. Data: ' + JSON.stringify(data));
    });
  }

  onForeground() {
    GlobalContext.getContext().setObject('isForeground', true);
    GlobalContext.getContext().setObject('taskListChange', false);
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onBackground() {
    FormUtils.backgroundUpdateCard(GlobalContext.getContext().getObject('taskListChange') as boolean);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    GlobalContext.getContext().setObject('abilityWant', want);
    GlobalContext.getContext().setObject('launchParam', launchParam);
  }
}
