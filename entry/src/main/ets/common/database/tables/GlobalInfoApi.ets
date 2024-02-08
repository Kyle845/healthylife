
import dataRdb from '@ohos.data.relationalStore';
import GlobalInfo from '../../../viewmodel/GlobalInfo';
import { CommonConstants as Const } from '../../constants/CommonConstants'
import RdbUtils from '../rdb/RdbUtils';
import Logger from '../../utils/Logger';
import call from '@ohos.telephony.call';

class GlobalInfoApi {
  insertData(globalInfo: GlobalInfo, callback: Function): void {
    const valueBucket = generateBucket(globalInfo);
    RdbUtils.insert('GlobalInfo', valueBucket).then(result => {
      callback(result);
    });
    Logger.info('GlobalInfoTable', 'Insert globalInfo finished.');
  }

  updateData(globalInfo: GlobalInfo, callback: Function): void {
    const valueBucket = generateBucket(globalInfo);
    let predicates = new dataRdb.RdbPredicates(Const.GLOBAL_INFO.tableName ? Const.GLOBAL_INFO.tableName : '');
    predicates.equalTo('id', 0);
    RdbUtils.update(valueBucket, predicates).then((result: number) => {
      callback(result);
    });
    Logger.info('GlobalInfoTable', 'Update globalInfo finished');
  }

  query(callback: Function): void {
    let predicates = new dataRdb.RdbPredicates(Const.GLOBAL_INFO.tableName ? Const.GLOBAL_INFO.tableName : '');
    predicates.equalTo('id', 0);
    RdbUtils.query(predicates).then(resultSet => {
      let count = resultSet.rowCount;
      if (count === 0) {
        Logger.info('GlobalInfoTable', 'query no results!');
        let result = new GlobalInfo('', '', 0, '');
        callback(result);
      } else {
        let result = new GlobalInfo('', '', 0, '');
        resultSet.goToFirstRow();
        result.firstDate = resultSet.getString(resultSet.getColumnIndex('firstDate'));
        result.lastDate = resultSet.getString(resultSet.getColumnIndex('lastDate'));
        result.checkInDays = resultSet.getDouble(resultSet.getColumnIndex('checkInDays'));
        result.achievements = resultSet.getString(resultSet.getColumnIndex('achievements'));
        callback(result);
      }
    })
  }
}

function generateBucket(globalInfo: GlobalInfo): dataRdb.ValuesBucket {
  let valueBucket = {} as dataRdb.ValuesBucket;
  Const.GLOBAL_INFO.columns?.forEach((item: string) => {
    if (item === 'id') {
      valueBucket[item] = 0;
    } else {
      switch (item) {
        case 'firstDate':
          valueBucket[item] = globalInfo.firstDate;
          break;
        case 'lastDate':
          valueBucket[item] = globalInfo.lastDate;
        case 'checkInDays':
          valueBucket[item] = globalInfo.checkInDays;
          break;
        case 'achievements':
          valueBucket[item] = globalInfo.achievements;
          break;
        default:
          break;
      }
    }
  });
  return valueBucket;
}

let globalInfoApi = new GlobalInfoApi();

export default globalInfoApi as GlobalInfoApi;