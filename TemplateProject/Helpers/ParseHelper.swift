//
//  ParseHelper.swift
//  Makestagram = Template Project
//  MakeSchool
//
//  Created by Caitlyn Chen on 6/29/15.
//

import Foundation
import Parse

// 1
class ParseHelper {
    
    // Following Relation
    static let ParseFollowClass       = "Follow"
    static let ParseFollowFromUser    = "fromUser"
    static let ParseFollowToUser      = "toUser"
    
    // Like Relation
    static let ParseLikeClass         = "Like"
    static let ParseLikeToPost        = "toPost"
    static let ParseLikeFromUser      = "fromUser"
    
    // Post Relation
    static let ParsePostUser          = "user"
    static let ParsePostCreatedAt     = "createdAt"
    
    // Flagged Content Relation
    static let ParseFlaggedContentClass    = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost   = "toPost"
    
    static let ParseCommentContentClass    = "Comment"
    static let commentFromUser = "comment"
    static let ParseCommentContentFromUser = "fromUser"
    static let ParseCommentContentToPost   = "toPost"
    
    // User Relation
    static let ParseUserUsername      = "username"
    
    
    // MARK: Following
    
    /**
    Fetches all users that the provided user is following.
    
    - parameter user: The user whose followees you want to retrieve
    - parameter completionBlock: The completion block that is called when the query completes
    */
//    static func getFollowingUsersForUser(user: PFUser, completionBlock: PFArrayResultBlock) {
//        let query = PFQuery(className: ParseFollowClass)
//        
//        query.whereKey(ParseFollowFromUser, equalTo:user)
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//    }
//    
    /**
    Establishes a follow relationship between two users.
    
    - parameter user:    The user that is following
    - parameter toUser:  The user that is being followed
    */
//    static func addFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
//        let followObject = PFObject(className: ParseFollowClass)
//        followObject.setObject(user, forKey: ParseFollowFromUser)
//        followObject.setObject(toUser, forKey: ParseFollowToUser)
//        
//        followObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
//    }
//    
    /**
    Deletes a follow relationship between two users.
    
    - parameter user:    The user that is following
    - parameter toUser:  The user that is being followed
    */
//    static func removeFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
//        let query = PFQuery(className: ParseFollowClass)
//        query.whereKey(ParseFollowFromUser, equalTo:user)
//        query.whereKey(ParseFollowToUser, equalTo: toUser)
//        
//        query.findObjectsInBackgroundWithBlock {
//            (results: [AnyObject]?, error: NSError?) -> Void in
//            
//            let results = results as? [PFObject] ?? []
//            
//            for follow in results {
//                follow.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
//            }
//        }
//    }
    
    // MARK: Users
    
    /**
    Fetch all users, except the one that's currently signed in.
    Limits the amount of users returned to 20.
    
    - parameter completionBlock: The completion block that is called when the query completes
    
    - returns: The generated PFQuery
    */
//    static func allUsers(completionBlock: PFArrayResultBlock) -> PFQuery {
//        let query = PFUser.query()!
//        // exclude the current user
//        query.whereKey(ParseHelper.ParseUserUsername,
//            notEqualTo: PFUser.currentUser()!.username!)
//        query.orderByAscending(ParseHelper.ParseUserUsername)
//        query.limit = 20
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//        
//        return query
//    }
    
    /**
    Fetch users whose usernames match the provided search term.
    
    - parameter searchText: The text that should be used to search for users
    - parameter completionBlock: The completion block that is called when the query completes
    
    - returns: The generated PFQuery
    */
//    static func searchUsers(searchText: String, completionBlock: PFArrayResultBlock)
//        -> PFQuery {
//            /*
//            NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
//            Regex can be slow on large datasets. For large amount of data it's better to store
//            lowercased username in a separate column and perform a regular string compare.
//            */
//            let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername,
//                matchesRegex: searchText, modifiers: "i")
//            
//            query.whereKey(ParseHelper.ParseUserUsername,
//                notEqualTo: PFUser.currentUser()!.username!)
//            
//            query.orderByAscending(ParseHelper.ParseUserUsername)
//            query.limit = 20
//            
//            query.findObjectsInBackgroundWithBlock(completionBlock)
//            
//            return query
//    }
//    
//    static func timelineRequestforCurrentUser(range: Range<Int>, completionBlock: PFArrayResultBlock) {
//        let followingQuery = PFQuery(className: ParseFollowClass)
//        followingQuery.whereKey(ParseLikeFromUser, equalTo:PFUser.currentUser()!)
//        
//        let postsFromFollowedUsers = Post.query()
//        postsFromFollowedUsers!.whereKey(ParsePostUser, matchesKey: ParseFollowToUser, inQuery: followingQuery)
//        
//        let postsFromThisUser = Post.query()
//        postsFromThisUser!.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
//        
//        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
//        query.includeKey(ParsePostUser)
//        query.orderByDescending(ParsePostCreatedAt)
//        
//        query.skip = range.startIndex
//        query.limit = range.endIndex - range.startIndex
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//        
//    }
//    static func flagPost(user: PFUser, post: Post) {
//        let flagObject = PFObject(className: ParseFlaggedContentClass)
//        flagObject[ParseFlaggedContentFromUser] = user
//        flagObject[ParseFlaggedContentToPost] = post
//        
//        flagObject.saveInBackgroundWithBlock(nil)
//    }
//    
//    static func likePost(user: PFUser, post: Post) {
//        let likeObject = PFObject(className: ParseLikeClass)
//        likeObject[ParseLikeFromUser] = user
//        likeObject[ParseLikeToPost] = post
//        
//        likeObject.saveInBackgroundWithBlock(nil)
//    }
    
    
    static func commentPost(user: PFUser, post: Post, comment: String) {
        let commentObject = PFObject(className: ParseCommentContentClass)
        commentObject[commentFromUser] = comment
        commentObject[ParseCommentContentFromUser] = user
        commentObject[ParseCommentContentToPost] = post
        
        commentObject.saveInBackgroundWithBlock(nil)
    }
    
//    static func unlikePost(user: PFUser, post: Post) {
//        // 1
//        let query = PFQuery(className: ParseLikeClass)
//        query.whereKey(ParseLikeFromUser, equalTo: user)
//        query.whereKey(ParseLikeToPost, equalTo: post)
//        
//        query.findObjectsInBackgroundWithBlock {
//            (results: [AnyObject]?, error: NSError?) -> Void in
//            // 2
//            if let results = results as? [PFObject] {
//                for likes in results {
//                    likes.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
//                }
//            }
//        }
//    }
    
//    static func likesForPost(post: Post, completionBlock: PFArrayResultBlock) {
//        let query = PFQuery(className: ParseLikeClass)
//        query.whereKey(ParseLikeToPost, equalTo: post)
//        // 2
//        query.includeKey(ParseLikeFromUser)
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//    }
    
//    static func commentsForPost(post: Post, completionBlock: PFArrayResultBlock) {
//        let query = PFQuery(className: ParseCommentContentClass)
//        query.whereKey(ParseCommentContentToPost, equalTo: post)
//        // 2
//        query.includeKey(ParseCommentContentFromUser)
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//    }
    
//    static func flagsForPost(post: Post, completionBlock: PFArrayResultBlock) {
//        let query = PFQuery(className: ParseFlaggedContentClass)
//        query.whereKey(ParseFlaggedContentToPost, equalTo: post)
//        // 2
//        query.includeKey(ParseFlaggedContentFromUser)
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//    }
}

//extension PFObject : Equatable {
//    
//}

public func ==(lhs: PFObject, rhs: PFObject) -> Bool {
    return lhs.objectId == rhs.objectId
}
 