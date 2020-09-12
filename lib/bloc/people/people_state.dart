import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_github_connect/bloc/User/User_model.dart';
import 'package:flutter_github_connect/bloc/User/model/event_model.dart';
import 'package:flutter_github_connect/bloc/User/model/gist_model.dart';
import 'package:flutter_github_connect/bloc/people/people_model.dart' as people;
import 'package:flutter_github_connect/model/pul_request.dart';

abstract class PeopleState extends Equatable {
  @override
  List<Object> get props => ([]);
}

class LoadedUserState extends PeopleState {
  final UserModel user;

  LoadedUserState({@required this.user});

  @override
  String toString() => 'LoadedUserState $user';

  factory LoadedUserState.next(
      {UserModel userModel, UserModel currentUserModel}) {
    currentUserModel.repositories.nodes.addAll(userModel.repositories.nodes);
    currentUserModel.repositories.pageInfo = userModel.repositories.pageInfo;
    return LoadedUserState(user: currentUserModel);
  }
}

class LoadingNextRepositoriesState extends LoadedUserState {
  final UserModel user;
  LoadingNextRepositoriesState(
    this.user,
  ) : super(user: user);
}

class LoadingFollowState extends PeopleState {}

class LoadingPullRequestState extends PeopleState {}

class LoadedFollowState extends PeopleState {
  final people.FollowModel followModel;

  LoadedFollowState(this.followModel);

  factory LoadedFollowState.next({people.FollowModel model, people.FollowModel currentFollowModel}) {
    currentFollowModel.nodes.addAll(model.nodes);
    currentFollowModel.pageInfo = model.pageInfo;
    return LoadedFollowState(currentFollowModel);
  }
}
class LoadingNextFollowState extends LoadedFollowState{
  LoadingNextFollowState(people.FollowModel followers) : super(followers);
}

class ErrorPeopleState extends PeopleState {
  final String errorMessage;

  ErrorPeopleState(this.errorMessage);

  @override
  String toString() => 'ErrorPeopleState';
}

class LoadedEventsState extends LoadedUserState {
  final UserModel user;
  final List<EventModel> eventList;

  LoadedEventsState({@required this.user, this.eventList}) : super(user: user);

  @override
  String toString() => 'LoadedUserState $user';
}

class LoadedPullRequestState extends LoadedEventsState {
  final UserModel user;
  final List<EventModel> eventList;
  final UserPullRequests pullRequestsList;

  LoadedPullRequestState({this.user, this.eventList, this.pullRequestsList})
      : super(user: user, eventList: eventList);

  factory LoadedPullRequestState.getNextRepositories(
      {UserModel userModel,
      List<EventModel> eventList,
      UserPullRequests currentpullRequestsList,
      UserPullRequests pullRequestsList}) {
    currentpullRequestsList.nodes.addAll(pullRequestsList.nodes);
    currentpullRequestsList.pageInfo = pullRequestsList.pageInfo;
    return LoadedPullRequestState(
        user: userModel,
        eventList: eventList,
        pullRequestsList: currentpullRequestsList);
  }

  @override
  String toString() => 'LoadedUserState $user';
}

class LoadingNextPullRequestState extends LoadedPullRequestState {
  final UserModel user;
  LoadingNextPullRequestState(
      this.user, List<EventModel> eventList, UserPullRequests pullRequestsList)
      : super(
            user: user,
            eventList: eventList,
            pullRequestsList: pullRequestsList);
}

class ErrorNextPullRequestState extends LoadedPullRequestState {
  final UserModel user;
  final String errorMessage;
  ErrorNextPullRequestState({
    this.errorMessage,
    this.user,
    List<EventModel> eventList,
    UserPullRequests pullRequestsList,
  }) : super(
            user: user,
            eventList: eventList,
            pullRequestsList: pullRequestsList);
}

class LoadedGitState extends PeopleState {
  final UserModel user;
  final List<EventModel> eventList;
  final Gists gist;

  LoadedGitState({this.user, this.eventList, this.gist});

  @override
  String toString() => 'LoadedUserState $user';

  factory LoadedGitState.next({Gists currenctGistModel, UserModel userModel, List<EventModel> eventList, Gists gistModel}) {
    currenctGistModel.nodes.addAll(gistModel.nodes);
    currenctGistModel.pageInfo = gistModel.pageInfo;
    print("New cursor is ${gistModel.pageInfo.endCursor}");
    return LoadedGitState(
        user: userModel,
        eventList: eventList,
        gist: currenctGistModel,);
  }
}

class LoadingNextGistState extends LoadedGitState {
  final Gists gist;

  LoadingNextGistState({this.gist, UserModel user, List<EventModel> eventList})
      : super(user: user, eventList: eventList, gist: gist);
}

class ErrorNextGistState extends LoadedGitState {
  final String errorMessage;
  ErrorNextGistState(
      {this.errorMessage,
      UserModel user,
      List<EventModel> eventList,
      Gists gist})
      : super(user: user, eventList: eventList, gist: gist);
}

class ErrorUserState extends PeopleState {
  final String errorMessage;

  ErrorUserState(this.errorMessage);

  @override
  String toString() => 'ErrorUserState';
}

class ErrorPullRequestState extends LoadedEventsState {
  final String errorMessage;
  final UserModel user;
  final List<EventModel> eventList;
  ErrorPullRequestState(this.errorMessage, {this.user, this.eventList})
      : super(user: user, eventList: eventList);

  @override
  String toString() => 'ErrorUserState';
}

class ErrorGitState extends LoadedEventsState {
  final String errorMessage;
  final UserModel user;
  final List<EventModel> eventList;
  ErrorGitState(this.errorMessage, {this.user, this.eventList})
      : super(user: user, eventList: eventList);

  @override
  String toString() => 'ErrorUserState';
}

class ErrorNextRepositoryState extends LoadedUserState {
  final String errorMessage;
  ErrorNextRepositoryState({UserModel user, this.errorMessage})
      : super(user: user);

  @override
  String toString() => 'ErrorUserState';
}
