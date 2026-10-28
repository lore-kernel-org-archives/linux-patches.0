Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213577;
	b=tqBLM7ZcJcVuR0oUZsk7BvyZqiBCoV0RwjgPpthMgVxo8dFP4F7Ec6CL1QNbcUphDTYW
	 e8on2JVmeFb0obilz/RYDsGpAX117pXuQjIXRw8BdLHNECuMa+y00A0v7X595kajZYRSc
	 tZ9V7rxMA1tMfrTYDhkQYY7ncwfnB7iRsDUKjwJHv+U+xpxjP8NY9RYue+9u08Bcf+EiX
	 R0Gm82bO9vkyxDAGhRGqah60xr0626dQ29OjaMvFkz2ab6jhVULHVAE6WNgfboqto59oP
	 0nwAMZJH0ouyFrgTQQdLRQh6nBu7e42pwh0kx6Q/y0WjANIcqLDfUJnXzBYise2FLhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MkBvXziGp7D+F05/zh8hvc71q9UGFolN5h4aylxyHJs=;
	b=IlVjfpD++fTC3/RTYONQT6+WTbhPiXtjhz5OlRwbvdQ06BELkFigMOfnR1pq+ndbdhiR
	 3P4mno2Ds6fMdoKa5BsvLuz2M+zux/PJXL6EwRpTShz16eLtXYAFRH2BPFCOndF8ujtz3
	 wT0PsOcuK1DxHBTRviHYMUzimNyWvHl0JL5IwJDwrEhU26jfqUDNLNwYWbBtYJiwuqLU9
	 2USLwsvMUBj/TTH+U4Od2s9SeSPtlVv7gKVIynyjv5hZn1ataGZdGOXOkQDZI6QJpj73N
	 thKPG/ABXF4c41B1d5BRIHuQtHUfjYS7pEO1Rd1Ux4qmeHAS9eQ92Le8dwcSXHxcSqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZxj16Ml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975C606A31A;
	Wed, 28 Oct 2026 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZxj16Ml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82291F01825;
	Wed, 28 Oct 2026 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213577;
	bh=MkBvXziGp7D+F05/zh8hvc71q9UGFolN5h4aylxyHJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZxj16MlamKV027+ZqDoXruVkehvxcITopyLRH/fJPzp3KOxfIcasRpzbkjjOgwev
	 ewbQ34P6wx8gq9woalNe1VIpLjE0m4Cc5O+94C+AqCPAKJMnK2lK3sjCrAspmbqeln
	 YIGhXpMSVEHPFjgw6BqampedhvpQqdmvw4J6aqEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0555/1887] reiserfs: Avoid touching renamed directory if parent does not change
Date: Wed, 28 Oct 2026 17:44:11 +0100
Message-ID: <20261028170512.009814331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 49db9b1b86a82448dfaf3fcfefcf678dee56c8ed ]

The VFS will not be locking moved directory if its parent does not
change. Change reiserfs rename code to avoid touching renamed directory
if its parent does not change as without locking that can corrupt the
filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/namei.c | 54 ++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index fe840620fafae..0e6bf4f6a80f2 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1325,8 +1325,8 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 	struct inode *old_inode, *new_dentry_inode;
 	struct reiserfs_transaction_handle th;
 	int jbegin_count;
-	umode_t old_inode_mode;
 	unsigned long savelink = 1;
+	bool update_dir_parent = false;
 
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
@@ -1376,8 +1376,7 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 		return -ENOENT;
 	}
 
-	old_inode_mode = old_inode->i_mode;
-	if (S_ISDIR(old_inode_mode)) {
+	if (S_ISDIR(old_inode->i_mode)) {
 		/*
 		 * make sure that directory being renamed has correct ".."
 		 * and that its new parent directory has not too many links
@@ -1390,24 +1389,28 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 			}
 		}
 
-		/*
-		 * directory is renamed, its parent directory will be changed,
-		 * so find ".." entry
-		 */
-		dot_dot_de.de_gen_number_bit_string = NULL;
-		retval =
-		    reiserfs_find_entry(old_inode, "..", 2, &dot_dot_entry_path,
+		if (old_dir != new_dir) {
+			/*
+			 * directory is renamed, its parent directory will be
+			 * changed, so find ".." entry
+			 */
+			dot_dot_de.de_gen_number_bit_string = NULL;
+			retval =
+			    reiserfs_find_entry(old_inode, "..", 2,
+					&dot_dot_entry_path,
 					&dot_dot_de);
-		pathrelse(&dot_dot_entry_path);
-		if (retval != NAME_FOUND) {
-			reiserfs_write_unlock(old_dir->i_sb);
-			return -EIO;
-		}
+			pathrelse(&dot_dot_entry_path);
+			if (retval != NAME_FOUND) {
+				reiserfs_write_unlock(old_dir->i_sb);
+				return -EIO;
+			}
 
-		/* inode number of .. must equal old_dir->i_ino */
-		if (dot_dot_de.de_objectid != old_dir->i_ino) {
-			reiserfs_write_unlock(old_dir->i_sb);
-			return -EIO;
+			/* inode number of .. must equal old_dir->i_ino */
+			if (dot_dot_de.de_objectid != old_dir->i_ino) {
+				reiserfs_write_unlock(old_dir->i_sb);
+				return -EIO;
+			}
+			update_dir_parent = true;
 		}
 	}
 
@@ -1487,7 +1490,7 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 
 		reiserfs_prepare_for_journal(old_inode->i_sb, new_de.de_bh, 1);
 
-		if (S_ISDIR(old_inode->i_mode)) {
+		if (update_dir_parent) {
 			if ((retval =
 			     search_by_entry_key(new_dir->i_sb,
 						 &dot_dot_de.de_entry_key,
@@ -1535,14 +1538,14 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 							 new_de.de_bh);
 			reiserfs_restore_prepared_buffer(old_inode->i_sb,
 							 old_de.de_bh);
-			if (S_ISDIR(old_inode_mode))
+			if (update_dir_parent)
 				reiserfs_restore_prepared_buffer(old_inode->
 								 i_sb,
 								 dot_dot_de.
 								 de_bh);
 			continue;
 		}
-		if (S_ISDIR(old_inode_mode)) {
+		if (update_dir_parent) {
 			if (item_moved(&dot_dot_ih, &dot_dot_entry_path) ||
 			    !entry_points_to_object("..", 2, &dot_dot_de,
 						    old_dir)) {
@@ -1560,7 +1563,7 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 			}
 		}
 
-		RFALSE(S_ISDIR(old_inode_mode) &&
+		RFALSE(update_dir_parent &&
 		       !buffer_journal_prepared(dot_dot_de.de_bh), "");
 
 		break;
@@ -1593,11 +1596,12 @@ static int reiserfs_rename(struct user_namespace *mnt_userns,
 		savelink = new_dentry_inode->i_nlink;
 	}
 
-	if (S_ISDIR(old_inode_mode)) {
+	if (update_dir_parent) {
 		/* adjust ".." of renamed directory */
 		set_ino_in_dir_entry(&dot_dot_de, INODE_PKEY(new_dir));
 		journal_mark_dirty(&th, dot_dot_de.de_bh);
-
+	}
+	if (S_ISDIR(old_inode->i_mode)) {
 		/*
 		 * there (in new_dir) was no directory, so it got new link
 		 * (".."  of renamed directory)
-- 
2.53.0



