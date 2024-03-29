
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import Logger from '../common/utils/Logger';
import reminder from '../service/ReminderAgent';
import TaskInfoApi from '../common/database/tables/TaskInfoApi';
import { padTo2Digits } from '../common/utils/Utils';
import TaskInfo, { oneWeek } from './TaskInfo';
import { TaskMapById, RemindContentMap, ITaskItem } from '../model/TaskInitList';
import PublishReminderInfo from './PublishReminderInfo';

const publishReminder = reminder.publishReminder;
const cancelReminder = reminder.cancelReminder;
const hasNotificationId = reminder.hasNotificationId;
export const taskOriginData: ITaskItem[] = TaskMapById;

export const getAllTask = () => {
  return new Promise<TaskInfo[]>((resolve) => {
    TaskInfoApi.query(Const.GLOBAL_KEY, true, (res: TaskInfo[]) => {
      if (res?.length === 0) {
        Logger.warn('queryTaskList', 'has no data!!');
        resolve(res ?? []);
      }
      resolve(res);
    })
  })
}

const useReminder = (params: TaskInfo, context: Context) => {
  try {
    let publishReminderInfo = new PublishReminderInfo();
    publishReminderInfo.hour = Number(params?.startTime.split(':')[0]);
    publishReminderInfo.minute = Number(params?.startTime.split(':')[1]);
    publishReminderInfo.daysOfWeek = params?.frequency.split(',').map(item => Number(item));
    publishReminderInfo.title = RemindContentMap[params?.taskID - 1].title;
    publishReminderInfo.content = RemindContentMap[params?.taskID - 1].content;
    publishReminderInfo.notificationId = params?.taskID;
    publishReminder(publishReminderInfo, context);
  } catch (error) {
    Logger.error('publishReminder', JSON.stringify(error));
  }
}

const useCancelReminder = (reminderId: number, context: Context) => {
  try {
    cancelReminder(reminderId, context);
  } catch (error) {
    Logger.error('cancelReminder', JSON.stringify(error));
  }
}

const isHasNotificationId = (notificationId: number) => {
  return new Promise<boolean>((resolve) => {
    resolve(hasNotificationId(notificationId));
  });
}

export const addTask = (params: TaskInfo, context: Context) => {
  if (!params) {
    Logger.error('addTask', 'params is null!');
    return new Promise<number>((resolve) => {
      resolve(-1);
    });
  }
  return new Promise<number>(async (resolve, reject) => {
    Logger.info('TaskViewModel', 'addTask');
    if (params?.isOpen) {
      if (params?.isAlarm) {
        useReminder(params, context);
      } else {
        isHasNotificationId(params?.taskID).then((flag: boolean) => {
          if (flag) {
            useCancelReminder(params.taskID, context);
          }
        });
      }
    } else {
      isHasNotificationId(params?.taskID).then((flag: boolean) => {
        if (flag) {
          useCancelReminder(params.taskID, context);
        }
      });
    }
    TaskInfoApi.updateDataByDate(params, (flag: number) => {
      if (!flag) {
        Logger.error('insertTaskSetting', 'updateTaskSetting Error!');
        reject(flag);
      }
      resolve(flag);
    });
    let taskInfoStr = JSON.stringify(params);
    let taskInfo: TaskInfo = JSON.parse(taskInfoStr)
    taskInfo.date = new Date().toDateString();
    taskInfo.isDone = true;
    TaskInfoApi.updateDataByDate(taskInfo, (flag: number) => {
      if (!flag) {
        Logger.error('insertTaskSetting', 'updateTaskSetting Error!');
        reject(flag);
      }
      resolve(flag);
    })
  })
}

export const taskIndexDataInit = (taskInitList: ITaskItem[], taskInfoData: TaskInfo[]) => {
  const afterInitData = taskInitList.map((content) => {
    taskInfoData.forEach((item) => {
      if (item?.taskID === content?.taskID) {
        content.isOpen = item?.isOpen;
        content.targetValue = item?.targetValue;
        content.isAlarm = item?.isAlarm;
        content.startTime = item?.startTime;
        content.endTime = item?.endTime;
        content.frequency = item?.frequency;
      }
    });
    return content;
  });
  return afterInitData;
}

export const formatParams = (params: ITaskItem) => {
  return JSON.stringify(params);
}

export const initFrequencyString = (frequencyIdCollection: string) => {
  if (frequencyIdCollection === '') {
    return Const.EVERYDAY;
  }
  const frequencyIdArray: Array<number> = frequencyIdCollection.split(',').map(item => Number(item) - 1);
  const length = frequencyIdArray.length;
  if (length === 7) {
    return Const.EVERYDAY;
  }
  const frequencyString = frequencyIdArray.reduce((pre, current) => {
    return pre + ' ' + oneWeek[current];
  }, '')
  return frequencyString;
}

export function returnTimeStamp(currentTime: string) {
  const timeString = `${new Date().toDateString()} ${currentTime}`;
  return new Date(timeString).getTime();
}

export const formatTime = (value: TimePickerResult) => {
  let hour = value?.hour ? value?.hour : 8;
  let minute = value?.minute ? value?.minute : 0;
  return `${padTo2Digits(hour)}: ${padTo2Digits(minute)}`;
}

export const createDrinkRange = () => {
  const drinkRangeArr: Array<string> = []
  for (let i = Const.DRINK_STEP; i <= Const.DRINK_MAX_RANGE; i += Const.DRINK_STEP) {
    drinkRangeArr.push(`${i / Const.TIMES_100} L`);
  }
  return drinkRangeArr;
}

export const createAppleRange = () => {
  const appleRangeArr: Array<string> = [];
  for (let i = 1; i <= Const.EAT_APPLE_RANGE; i++) {
    appleRangeArr.push(`${i} 个`);
  }
  return appleRangeArr;
}