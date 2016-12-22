import { Injectable } from '@angular/core';
import { Http, Headers, RequestOptions } from '@angular/http';
import { Observable } from 'rxjs/Observable';
import { Story } from './story';
import { StoryValue } from './story-value';

const baseUrl = 'api/stories';

@Injectable()
export class StoriesService {
  constructor(private http: Http) { }

  getStories(release, iteration, team, individual, status): Observable<Story[]> {
    let queryString = '?';
    if (release !== 'All') {
      queryString += 'release_id=' + (release ? release : '') + '&';
    }
    if (iteration !== 'All') {
      queryString += 'iteration_id=' + (iteration ? iteration : '') + '&';
    }
    if (team !== 'All') {
      queryString += 'team_id=' + (team ? team : '') + '&';
    }
    if (individual !== 'All') {
      queryString += 'individual_id=' + (individual ? individual : '') + '&';
    }
    if (status !== 'All') {
      queryString += 'status_code=' + status + '&';
    }
    queryString = queryString.substring(0, queryString.length - 1);
    return this.http.get(baseUrl + queryString)
      .map(res => res.json())
      .map((stories: Array<any>) => {
        let result: Array<Story> = [];
        if (stories) {
          stories.forEach((story) => {
            result.push(
              new Story(story)
            );
          });
        }
        this.setRanks(result);
        return result;
      });
  }

  create(story: Story): Observable<Story> {
    return this.createOrUpdate(story, this.http.post, '');
  }

  update(story: Story): Observable<Story> {
    return this.createOrUpdate(story, this.http.put, '/' + story.id);
  }

  delete(story: Story) {
    return this.http.delete(baseUrl + '/' + story.id);
  }

  setRanks(stories: Array<Story>) {
    this.setRank(stories, 'rank', 'priority');
    this.setRank(stories, 'user_rank', 'user_priority');
  }

  private createOrUpdate(story: Story, method, idString): Observable<Story> {
    let headers = new Headers({ 'Content-Type': 'application/json' });
    let options = new RequestOptions({ headers: headers });
    let record = {
      name: story.name,
      description: story.description,
      status_code: story.status_code,
      reason_blocked: story.reason_blocked,
      project_id: story.project_id,
      release_id: story.release_id,
      iteration_id: story.iteration_id,
      team_id: story.team_id,
      individual_id: story.individual_id,
      effort: story.effort == null ? '' : ('' + story.effort),
      acceptance_criteria: story.acceptance_criteria_string
    };
    if (story.priority) {
      record['priority'] = story.priority;
    }
    story.story_values.forEach((storyValue: StoryValue) => {
      record['custom_' + storyValue.story_attribute_id] = storyValue.value;
    });
    return method.call(this.http, baseUrl + idString, {record: record}, options)
      .map(res => res.json())
      .map((response: any) => {
        return new Story(response.record);
      });
  }

  private setRank(stories: Array<Story>, rankAttribute: string, priorityAttribute: string) {
    let sorted: Array<Story> = stories.concat([]); // copy array
    sorted.sort(function(a: Story, b: Story): number {
      return a[priorityAttribute] - b[priorityAttribute];
    });
    let rank = 1;
    sorted.forEach((story) => {
      if (story.status_code !== 3 && story[priorityAttribute]) { // not done
        story[rankAttribute] = rank;
        rank++;
      }
    });
  }
}
