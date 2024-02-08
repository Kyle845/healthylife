
import dataRdb from '@ohos.data.relationalStore';
import GlobalInfo from '../../../viewmodel/GlobalInfo';
import { CommonConstants as Const } from '../../constants/CommonConstants'
import RdbUtils from '../rdb/RdbUtils';
import Logger from '../../utils/Logger';

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
      }
    })
  }
}