{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
module Github.Data.Issues where

import Github.Data.Definitions
import Github.Data.Id           (Id)
import Github.Data.PullRequests

import Control.DeepSeq          (NFData (..))
import Control.DeepSeq.Generics (genericRnf)
import Data.Data                (Data, Typeable)
import Data.Text                (Text)
import Data.Time                (UTCTime)
import Data.Vector              (Vector)
import GHC.Generics             (Generic)

data Issue = Issue {
   issueClosedAt    :: Maybe UTCTime
  ,issueUpdatedAt   :: UTCTime
  ,issueEventsUrl   :: Text
  ,issueHtmlUrl     :: Maybe Text
  ,issueClosedBy    :: Maybe SimpleOwner
  ,issueLabels      :: (Vector IssueLabel)
  ,issueNumber      :: Int
  ,issueAssignee    :: Maybe SimpleOwner
  ,issueUser        :: SimpleOwner
  ,issueTitle       :: Text
  ,issuePullRequest :: Maybe PullRequestReference
  ,issueUrl         :: Text
  ,issueCreatedAt   :: UTCTime
  ,issueBody        :: Maybe Text
  ,issueState       :: Text
  ,issueId          :: Id Issue
  ,issueComments    :: Int
  ,issueMilestone   :: Maybe Milestone
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Issue where rnf = genericRnf

data NewIssue = NewIssue {
  newIssueTitle     :: Text
, newIssueBody      :: Maybe Text
, newIssueAssignee  :: Maybe Text
, newIssueMilestone :: Maybe Int
, newIssueLabels    :: Maybe (Vector Text)
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData NewIssue where rnf = genericRnf

data EditIssue = EditIssue {
  editIssueTitle     :: Maybe Text
, editIssueBody      :: Maybe Text
, editIssueAssignee  :: Maybe Text
, editIssueState     :: Maybe Text
, editIssueMilestone :: Maybe Int
, editIssueLabels    :: Maybe (Vector Text)
} deriving  (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData EditIssue where rnf = genericRnf

data Milestone = Milestone {
   milestoneCreator      :: SimpleOwner
  ,milestoneDueOn        :: Maybe UTCTime
  ,milestoneOpenIssues   :: Int
  ,milestoneNumber       :: Int
  ,milestoneClosedIssues :: Int
  ,milestoneDescription  :: Maybe Text
  ,milestoneTitle        :: Text
  ,milestoneUrl          :: Text
  ,milestoneCreatedAt    :: UTCTime
  ,milestoneState        :: Text
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Milestone where rnf = genericRnf

data IssueLabel = IssueLabel {
   labelColor :: Text
  ,labelUrl   :: Text
  ,labelName  :: Text
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData IssueLabel where rnf = genericRnf

data IssueComment = IssueComment {
   issueCommentUpdatedAt :: UTCTime
  ,issueCommentUser      :: SimpleOwner
  ,issueCommentUrl       :: Text
  ,issueCommentHtmlUrl   :: Text
  ,issueCommentCreatedAt :: UTCTime
  ,issueCommentBody      :: Text
  ,issueCommentId        :: Int
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData IssueComment where rnf = genericRnf

data EventType =
    Mentioned     -- ^ The actor was @mentioned in an issue body.
  | Subscribed    -- ^ The actor subscribed to receive notifications for an issue.
  | Unsubscribed  -- ^ The issue was unsubscribed from by the actor.
  | Referenced    -- ^ The issue was referenced from a commit message. The commit_id attribute is the commit SHA1 of where that happened.
  | Merged        -- ^ The issue was merged by the actor. The commit_id attribute is the SHA1 of the HEAD commit that was merged.
  | Assigned      -- ^ The issue was assigned to the actor.
  | Closed        -- ^ The issue was closed by the actor. When the commit_id is present, it identifies the commit that closed the issue using “closes / fixes #NN” syntax.
  | Reopened      -- ^ The issue was reopened by the actor.
  | ActorUnassigned    -- ^ The issue was unassigned to the actor
  | Labeled       -- ^ A label was added to the issue.
  | Unlabeled     -- ^ A label was removed from the issue.
  | Milestoned    -- ^ The issue was added to a milestone.
  | Demilestoned  -- ^ The issue was removed from a milestone.
  | Renamed       -- ^ The issue title was changed.
  | Locked        -- ^ The issue was locked by the actor.
  | Unlocked      -- ^ The issue was unlocked by the actor.
  | HeadRefDeleted -- ^ The pull request’s branch was deleted.
  | HeadRefRestored -- ^ The pull request’s branch was restored.
  deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData EventType where rnf = genericRnf

-- | Issue event
data Event = Event {
   eventActor     :: !SimpleOwner
  ,eventType      :: !EventType
  ,eventCommitId  :: !(Maybe Text)
  ,eventUrl       :: !Text
  ,eventCreatedAt :: !UTCTime
  ,eventId        :: !Int
  ,eventIssue     :: !(Maybe Issue)
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Event where rnf = genericRnf

-- | A data structure for describing how to filter issues. This is used by
-- @issuesForRepo@.
data IssueLimitation =
      AnyMilestone -- ^ Issues appearing in any milestone. [default]
    | NoMilestone -- ^ Issues without a milestone.
    | MilestoneId Int -- ^ Only issues that are in the milestone with the given id.
    | Open -- ^ Only open issues. [default]
    | OnlyClosed -- ^ Only closed issues.
    | Unassigned -- ^ Issues to which no one has been assigned ownership.
    | AnyAssignment -- ^ All issues regardless of assignment. [default]
    | AssignedTo String -- ^ Only issues assigned to the user with the given login.
    | Mentions String -- ^ Issues which mention the given string, taken to be a user's login.
    | Labels [String] -- ^ A list of labels to filter by.
    | Ascending -- ^ Sort ascending.
    | Descending -- ^ Sort descending. [default]
    | Since UTCTime -- ^ Only issues created since the specified date and time.
    | PerPage Int -- ^ Download this many issues per query
  deriving (Eq, Ord, Show, Typeable, Data, Generic)

instance NFData IssueLimitation where rnf = genericRnf