{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
module Github.Data.GitData where

import Github.Data.Definitions

import Control.DeepSeq          (NFData (..))
import Control.DeepSeq.Generics (genericRnf)
import Data.Data                (Data, Typeable)
import Data.Text                (Text)
import Data.Time                (UTCTime)
import Data.Vector              (Vector)
import GHC.Generics             (Generic)

data Commit = Commit {
   commitSha       :: !Text
  ,commitParents   :: !(Vector Tree)
  ,commitUrl       :: !Text
  ,commitGitCommit :: !GitCommit
  ,commitCommitter :: !(Maybe SimpleOwner)
  ,commitAuthor    :: !(Maybe SimpleOwner)
  ,commitFiles     :: !(Vector File)
  ,commitStats     :: !(Maybe Stats)
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Commit where rnf = genericRnf

data Tree = Tree {
   treeSha      :: !Text
  ,treeUrl      :: !Text
  ,treeGitTrees :: !(Vector GitTree)
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Tree where rnf = genericRnf

data GitTree = GitTree {
  gitTreeType  :: !Text
  ,gitTreeSha  :: !Text
  -- Can be empty for submodule
  ,gitTreeUrl  :: !(Maybe Text)
  ,gitTreeSize :: !(Maybe Int)
  ,gitTreePath :: !Text
  ,gitTreeMode :: !Text
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData GitTree where rnf = genericRnf

data GitCommit = GitCommit {
   gitCommitMessage   :: !Text
  ,gitCommitUrl       :: !Text
  ,gitCommitCommitter :: !GitUser
  ,gitCommitAuthor    :: !GitUser
  ,gitCommitTree      :: !Tree
  ,gitCommitSha       :: !(Maybe Text)
  ,gitCommitParents   :: !(Vector Tree)
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData GitCommit where rnf = genericRnf

data Blob = Blob {
   blobUrl      :: !Text
  ,blobEncoding :: !Text
  ,blobContent  :: !Text
  ,blobSha      :: !Text
  ,blobSize     :: !Int
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Blob where rnf = genericRnf

data Tag = Tag {
   tagName       :: !Text
  ,tagZipballUrl :: !Text
  ,tagTarballUrl :: !Text
  ,tagCommit     :: !BranchCommit
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Tag where rnf = genericRnf

data Branch = Branch {
   branchName   :: !Text
  ,branchCommit :: !BranchCommit
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Branch where rnf = genericRnf

data BranchCommit = BranchCommit {
   branchCommitSha :: !Text
  ,branchCommitUrl :: !Text
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData BranchCommit where rnf = genericRnf

data Diff = Diff {
   diffStatus       :: !Text
  ,diffBehindBy     :: !Int
  ,diffPatchUrl     :: !Text
  ,diffUrl          :: !Text
  ,diffBaseCommit   :: !Commit
  ,diffCommits      :: !(Vector Commit)
  ,diffTotalCommits :: !Int
  ,diffHtmlUrl      :: !Text
  ,diffFiles        :: !(Vector File)
  ,diffAheadBy      :: !Int
  ,diffDiffUrl      :: !Text
  ,diffPermalinkUrl :: !Text
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData Diff where rnf = genericRnf

data NewGitReference = NewGitReference {
   newGitReferenceRef :: !Text
  ,newGitReferenceSha :: !Text
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData NewGitReference where rnf = genericRnf

data GitReference = GitReference {
   gitReferenceObject :: !GitObject
  ,gitReferenceUrl    :: !Text
  ,gitReferenceRef    :: !Text
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData GitReference where rnf = genericRnf

data GitObject = GitObject {
   gitObjectType :: !Text
  ,gitObjectSha  :: !Text
  ,gitObjectUrl  :: !Text
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData GitObject where rnf = genericRnf

data GitUser = GitUser {
   gitUserName  :: !Text
  ,gitUserEmail :: !Text
  ,gitUserDate  :: !UTCTime
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData GitUser where rnf = genericRnf

data File = File {
   fileBlobUrl   :: !Text
  ,fileStatus    :: !Text
  ,fileRawUrl    :: !Text
  ,fileAdditions :: !Int
  ,fileSha       :: !Text
  ,fileChanges   :: !Int
  ,filePatch     :: !Text
  ,fileFilename  :: !Text
  ,fileDeletions :: !Int
} deriving (Show, Data, Typeable, Eq, Ord, Generic)

instance NFData File where rnf = genericRnf