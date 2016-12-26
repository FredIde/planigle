import { Injectable } from '@angular/core';
import { Http, Headers, RequestOptions } from '@angular/http';
import { Observable } from 'rxjs/Observable';
import { Task } from '../models/task';

const baseUrl = 'api/stories/{story_id}/tasks';

@Injectable()
export class TasksService {
  constructor(private http: Http) { }

  create(task: Task): Observable<Task> {
    return this.createOrUpdate(task, this.http.post, '');
  }

  update(task: Task): Observable<Task> {
    return this.createOrUpdate(task, this.http.put, '/' + task.id);
  }

  delete(task: Task): Observable<Task> {
    return this.http.delete(baseUrl.replace(new RegExp('{story_id}'), '' + task.story_id) + '/' + task.id)
      .map((res: any) => res.json())
      .map((updatedTask: any) => {
        return new Task(updatedTask);
      });
  }

  private createOrUpdate(task: Task, method, idString): Observable<Task> {
    let headers: Headers = new Headers({ 'Content-Type': 'application/json' });
    let options: RequestOptions = new RequestOptions({ headers: headers });
    let record: any = {
      story_id: task.story_id,
      name: task.name,
      description: task.description,
      status_code: task.status_code,
      reason_blocked: task.reason_blocked,
      individual_id: task.individual_id,
      estimate: task.estimate == null ? '' : ('' + task.estimate),
      effort: task.effort == null ? '' : ('' + task.effort)
    };
    if (task.priority) {
      record['priority'] = task.priority;
    }
    let story_id: number = task.previous_story_id ? task.previous_story_id : task.story_id;
    return method.call(this.http, baseUrl.replace(new RegExp('{story_id}'), '' + story_id) + idString, {record: record}, options)
      .map((res: any) => res.json())
      .map((updatedTask: any) => {
        return new Task(updatedTask);
      });
  }
}