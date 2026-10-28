Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214797;
	b=jhEIilxH6XLSKVwp+aPqXz1dkkguTbLuWt57fXXCiJPqU8bGheIo34ItaK2JaGnTkekm
	 +1vFzx6V9OC4lXMqnZ3XJCBRPvE/LKLmM8LfJi39O6YpgXZflm9Ji07pukTVEDfxi6LJT
	 QPyB6BfQ6ShQnNlYAXg2SBjSywreW7tfHU7YuZbgdsrZT5W+NKGiBeD1aE9hZD77j9M0d
	 Nw/PD7yCreU5LsGUSblZg+e7fBfBjGH3sh4jfofNFHklQwDaC8FurHOgxAwWXwKa9bJLO
	 nja+rvJq1uJJ2kxFs1Ep/c2Na54J8qCzKvD3Jw5EJHT4UYs7PcQ+QMdnAWHY+Pd8oMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SM+i+CaDHFv4uXXTdYpR7ewVTJ5eiSjb1SdwgdAHkkk=;
	b=xjEbQ1LyDtG4tmJYpbZD49dZ71Pf22sWvR6/Yzbl8bOyxrSPDaGuSGZalXzv5TFF1P9O
	 xvXnvxJ+jO264mSL6VhlgFomwlmuMvaS47O+tlqj/xcDrNdGYrnPtKeZKpkC+vnspMaC0
	 OnkMTwHuBRYYYomZWgs5wvMtRbNugfNW4PQtiXGIqTn/ZnUNkroqJSp1vQkB/5Cy1bHvp
	 sxNI3BepO2A9Yns29DtS1x0PgYEcMhz6MymgOI1IwpXED5wttJqkoobraa8KS4qSoimym
	 U/M+uALsuqFbmuZmN9YesVEYj7tqFdUekf4ddLTCHfSeXfode1gjOHwLR5J7nh3wfMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fk3dhEN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A1D606B7EB;
	Wed, 28 Oct 2026 19:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fk3dhEN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC921F01825;
	Wed, 28 Oct 2026 19:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214796;
	bh=SM+i+CaDHFv4uXXTdYpR7ewVTJ5eiSjb1SdwgdAHkkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fk3dhEN1GP1wfhbthKGCPTQxC0YPczUZGJTqpNtV5+yjMP5pZYDA6Sh+aE9OwJuXE
	 zTKu4sB4PsimhVyZicklVcLpSzW5AHj/B5ujfbmIEGyYVGNt5smk571ii5H3VQql06
	 T0uRM1SCz3zP2+0lF8CfePU1j9SxHH1ytW1iYDlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0984/1887] btrfs: fix zero size inode with non-zero size after log replay
Date: Wed, 28 Oct 2026 17:51:20 +0100
Message-ID: <20261028170521.802800706@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5254d4181add9dfaa5e3519edd71cc8f752b2f85 ]

When logging that an inode exists, as part of logging a new name or
logging new dir entries for a directory, we always set the generation of
the logged inode item to 0. This is to signal during log replay (in
overwrite_item()), that we should not set the i_size since we only logged
that an inode exists, so the i_size of the inode in the subvolume tree
must be preserved (as when we log new names or that an inode exists, we
don't log extents).

This works fine except when we have already logged an inode in full mode
or it's the first time we are logging an inode created in a past
transaction, that inode has a new i_size of 0 and then we log a new name
for the inode (due to a new hardlink or a rename), in which case we log
an i_size of 0 for the inode and a generation of 0, which causes the log
replay code to not update the inode's i_size to 0 (in overwrite_item()).

An example scenario:

  mkdir /mnt/dir
  xfs_io -f -c "pwrite 0 64K" /mnt/dir/foo

  sync

  xfs_io -c "truncate 0" -c "fsync" /mnt/dir/foo

  ln /mnt/dir/foo /mnt/dir/bar

  xfs_io -c "fsync" /mnt/dir

  <power fail>

After log replay the file remains with a size of 64K. This is because when
we first log the inode, when we fsync file foo, we log its current i_size
of 0, and then when we create a hard link we log again the inode in exists
mode (LOG_INODE_EXISTS) but we set a generation of 0 for the inode item we
add to the log tree, so during log replay overwrite_item() sees that the
generation is 0 and i_size is 0 so we skip updating the inode's i_size
from 64K to 0.

Fix this by making sure at fill_inode_item() we always log the real
generation of the inode if it was logged in the current transaction with
the i_size we logged before. Also if an inode created in a previous
transaction is logged in exists mode only, make sure we log the i_size
stored in the inode item located from the commit root, so that if we log
multiple times that the inode exists we get the correct i_size.

A test case for fstests will follow soon.

Reported-by: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/af8c15fa-4e41-4bb2-885c-0bc4e97532a6@gmail.com/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 99 +++++++++++++++++++++++++++++----------------
 1 file changed, 65 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e361a608f3ae9..c7697a77e770c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4200,24 +4200,34 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    u64 logged_isize)
 {
 	struct btrfs_map_token token;
+	u64 gen = BTRFS_I(inode)->generation;
 	u64 flags;
 
 	btrfs_init_map_token(&token, leaf);
 
 	if (log_inode_only) {
-		/* set the generation to zero so the recover code
-		 * can tell the difference between an logging
-		 * just to say 'this inode exists' and a logging
-		 * to say 'update this inode with these values'
+		/*
+		 * Set the generation to zero so the recover code can tell the
+		 * difference between a logging just to say 'this inode exists'
+		 * and a logging to say 'update this inode with these values'.
+		 * But only if the inode was not already logged before.
+		 * We access ->logged_trans directly since it was already set
+		 * up in the call chain by btrfs_log_inode(), and data_race()
+		 * to avoid false alerts from KCSAN and since it was set already
+		 * and one can set it to 0 since that only happens on eviction
+		 * and we are holding a ref on the inode.
 		 */
-		btrfs_set_token_inode_generation(&token, item, 0);
+		ASSERT(data_race(BTRFS_I(inode)->logged_trans) > 0);
+		if (data_race(BTRFS_I(inode)->logged_trans) < trans->transid)
+			gen = 0;
+
 		btrfs_set_token_inode_size(&token, item, logged_isize);
 	} else {
-		btrfs_set_token_inode_generation(&token, item,
-						 BTRFS_I(inode)->generation);
 		btrfs_set_token_inode_size(&token, item, inode->i_size);
 	}
 
+	btrfs_set_token_inode_generation(&token, item, gen);
+
 	btrfs_set_token_inode_uid(&token, item, i_uid_read(inode));
 	btrfs_set_token_inode_gid(&token, item, i_gid_read(inode));
 	btrfs_set_token_inode_mode(&token, item, inode->i_mode);
@@ -5033,42 +5043,63 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int logged_inode_size(struct btrfs_root *log, struct btrfs_inode *inode,
-			     struct btrfs_path *path, u64 *size_ret)
+static int get_inode_size_to_log(struct btrfs_trans_handle *trans,
+				 struct btrfs_inode *inode,
+				 struct btrfs_path *path, u64 *size_ret)
 {
 	struct btrfs_key key;
+	struct btrfs_inode_item *item;
 	int ret;
 
 	key.objectid = btrfs_ino(inode);
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
-	ret = btrfs_search_slot(NULL, log, &key, path, 0, 0);
-	if (ret < 0) {
-		return ret;
-	} else if (ret > 0) {
-		*size_ret = 0;
-	} else {
-		struct btrfs_inode_item *item;
+	/*
+	 * Our caller called inode_logged(), so logged_trans is up to date.
+	 * Use data_race() to silence any warning from KCSAN. Once logged_trans
+	 * is set, it can only be reset to 0 after inode eviction.
+	 */
+	if (data_race(inode->logged_trans) == trans->transid) {
+		ret = btrfs_search_slot(NULL, inode->root->log_root, &key, path, 0, 0);
+	} else if (inode->generation < trans->transid) {
+		path->search_commit_root = true;
+		path->skip_locking = true;
+		ret = btrfs_search_slot(NULL, inode->root, &key, path, 0, 0);
+		path->search_commit_root = false;
+		path->skip_locking = false;
 
-		item = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				      struct btrfs_inode_item);
-		*size_ret = btrfs_inode_size(path->nodes[0], item);
-		/*
-		 * If the in-memory inode's i_size is smaller then the inode
-		 * size stored in the btree, return the inode's i_size, so
-		 * that we get a correct inode size after replaying the log
-		 * when before a power failure we had a shrinking truncate
-		 * followed by addition of a new name (rename / new hard link).
-		 * Otherwise return the inode size from the btree, to avoid
-		 * data loss when replaying a log due to previously doing a
-		 * write that expands the inode's size and logging a new name
-		 * immediately after.
-		 */
-		if (*size_ret > inode->vfs_inode.i_size)
-			*size_ret = inode->vfs_inode.i_size;
+	} else {
+		*size_ret = 0;
+		return 0;
 	}
 
+	/*
+	 * If the inode was logged before or is from a past transaction, then
+	 * its inode item must exist in the log root or in the commit root.
+	 */
+	ASSERT(ret <= 0);
+	if (WARN_ON_ONCE(ret > 0))
+		ret = -ENOENT;
+
+	if (ret < 0)
+		return ret;
+
+	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			      struct btrfs_inode_item);
+	*size_ret = btrfs_inode_size(path->nodes[0], item);
+	/*
+	 * If the in-memory inode's i_size is smaller then the inode size stored
+	 * in the btree, return the inode's i_size, so that we get a correct
+	 * inode size after replaying the log when before a power failure we had
+	 * a shrinking truncate followed by addition of a new name (rename / new
+	 * hard link). Otherwise return the inode size from the btree, to avoid
+	 * data loss when replaying a log due to previously doing a write that
+	 * expands the inode's size and logging a new name immediately after.
+	 */
+	if (*size_ret > inode->vfs_inode.i_size)
+		*size_ret = inode->vfs_inode.i_size;
+
 	btrfs_release_path(path);
 	return 0;
 }
@@ -6573,7 +6604,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			ret = drop_inode_items(trans, log, path, inode,
 					       BTRFS_XATTR_ITEM_KEY);
 	} else {
-		if (inode_only == LOG_INODE_EXISTS && ctx->logged_before) {
+		if (inode_only == LOG_INODE_EXISTS) {
 			/*
 			 * Make sure the new inode item we write to the log has
 			 * the same isize as the current one (if it exists).
@@ -6587,7 +6618,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			 * (zeroes), as if an expanding truncate happened,
 			 * instead of getting a file of 4Kb only.
 			 */
-			ret = logged_inode_size(log, inode, path, &logged_isize);
+			ret = get_inode_size_to_log(trans, inode, path, &logged_isize);
 			if (ret)
 				goto out_unlock;
 		}
-- 
2.53.0



