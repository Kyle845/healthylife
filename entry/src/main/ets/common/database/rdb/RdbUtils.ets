
import dataRdb from '@ohos.data.relationalStore';
import ColumnInfo from '../../../viewmodel/ColumnInfo';
import { RdbHelper } from './RdbHelper';
import { RdbHelperImp } from './RdbHlperImp';
import Logger from '../../utils/Logger';

let dbContext: Context;
let mDatabaseName: string = '';

export class RdbUtils {
  private rdbHelpers = new Map<string, RdbHelper>();

  initDb(context: Context, databaseName: string) {
    dbContext = context;
    mDatabaseName = databaseName;
  }

  createDb(): Promise<RdbHelper> {
    return new Promise<RdbHelper>((success, error) => {
    let dbName = mDatabaseName;
    if (!dbContext || !dbName || dbName.length === 0) {
      error("init err");
      return;
    }
    let dbHelper = this.rdbHelpers.get(dbName);
    if (!dbHelper) {
        Logger.info(`initRdb RdbUtils success`);
        let rdbHelper: RdbHelper = new RdbHelperImp(dbName);
        rdbHelper.getRdb(dbContext).then(data => {
          this.rdbHelpers.set(dbName, data);
          success(data);
        }).catch((err: Error) => {
          error(err);
        })
    } else {
      success(dbHelper);
    }
})
  }

}

let rdbUtils = new RdbUtils();

export default rdbUtils as RdbUtils;