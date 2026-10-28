Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213835;
	b=iD0VBnDZn8baaIxVLgorqIW1Qt99v/L38830m2VMJWvbXjnYjgMY4W3ZWI1IbxiSkpXO
	 VIJNfGJkjzViFwDgRsMduI3FDrpBcXQ2Aff5zxddl9smHMNxsriflJMRlaZqY0aIcyZp9
	 /9XAa43yl9BYFRgQHlsjl9wJ9X13dsoiUUeDOzCAJ6kf2LTHY6xru3ufVDxJ8NJCTMm4v
	 4DGIWJ2/cdBt0LVS5/UhZFlNEncjesRV4Qg/ENLkBR2bAy4ucl9iM0lmiK6Hm1k9zqxWo
	 GWMOoIdAhhej4hTH5YtIKFiau2Ndix2C6w25uUPt0zZerUieR5h1c/Lq18hnXG1Wp5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxbVJOBIaSZZXMc6UpCof2LDr/DecoTcXsu1dx73AOM=;
	b=xrKLqLzwFvEYWfVAKlXt2ldkxFWNj+NMkAzAXQNs87Bsm9UStM7V2bG+6AHF9y5CVKrT
	 L9+NdtpCcjn9DhtgG9TlFbJ5GBPCvsF+tnWlZT/NlFyyr/XvDDoRRO6gTKdeI5hkfKEwJ
	 ae1B6H035/wSUapCgeLMKU838cORoXijxFN34hnDREcNFWYmjn7mspJH/l45pm5Hptsl8
	 zfSbyZt5VdHOYifD6MBLZqTbcUZbS1mNzw8FyqYqEZ6N0mdWGvyKhCiD14tO4WId0GXnd
	 y1UPek5l1chnhNQLFwTsftCmLOfUswN/dsY+a5QhbFo48oBNq7XYpCt6GXkDcoJuNdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kDa2EVtc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA00606A31C;
	Wed, 28 Oct 2026 18:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kDa2EVtc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7221F01825;
	Wed, 28 Oct 2026 18:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213835;
	bh=xxbVJOBIaSZZXMc6UpCof2LDr/DecoTcXsu1dx73AOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDa2EVtckrfGaEHo0PsIaKmY0NAo3esxpMv86DbHKsFPYeK1qgG5MZka0yWm7gQOC
	 v/PfsiDc9PeQbikBzXZdT0vNmro7mAXNiEQ/YPBDBJafFKqjJ56Mv+6EHIoekMWcbA
	 ojnOYsVwvcxi8p976GGlzrovYsspqSbAJHy7ZjS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a306f914b4d01b3958fe@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0646/1887] btrfs: do not BUG_ON() when freeing tree block after error
Date: Wed, 28 Oct 2026 17:45:42 +0100
Message-ID: <20261028170514.110715239@linuxfoundation.org>
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

[ Upstream commit bb3868033a4cccff7be57e9145f2117cbdc91c11 ]

When freeing a tree block, at btrfs_free_tree_block(), if we fail to
create a delayed reference we don't deal with the error and just do a
BUG_ON(). The error most likely to happen is -ENOMEM, and we have a
comment mentioning that only -ENOMEM can happen, but that is not true,
because in case qgroups are enabled any error returned from
btrfs_qgroup_trace_extent_post() (can be -EUCLEAN or anything returned
from btrfs_search_slot() for example) can be propagated back to
btrfs_free_tree_block().

So stop doing a BUG_ON() and return the error to the callers and make
them abort the transaction to prevent leaking space. Syzbot was
triggering this, likely due to memory allocation failure injection.

Reported-by: syzbot+a306f914b4d01b3958fe@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/000000000000fcba1e05e998263c@google.com/
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c           | 65 ++++++++++++++++++++++++++++----------
 fs/btrfs/ctree.h           |  8 ++---
 fs/btrfs/extent-tree.c     | 22 +++++++------
 fs/btrfs/free-space-tree.c | 10 ++++--
 fs/btrfs/ioctl.c           |  6 +++-
 fs/btrfs/qgroup.c          |  6 ++--
 6 files changed, 82 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 36f54f0f21d83..9e611f45b4b3c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -502,10 +502,16 @@ int btrfs_force_cow_block(struct btrfs_trans_handle *trans,
 		atomic_inc(&cow->refs);
 		rcu_assign_pointer(root->node, cow);
 
-		btrfs_free_tree_block(trans, btrfs_root_id(root), buf,
-				      parent_start, last_ref);
+		ret = btrfs_free_tree_block(trans, btrfs_root_id(root), buf,
+					    parent_start, last_ref);
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
+		if (ret < 0) {
+			btrfs_tree_unlock(cow);
+			free_extent_buffer(cow);
+			btrfs_abort_transaction(trans, ret);
+			return ret;
+		}
 	} else {
 		WARN_ON(trans->transid != btrfs_header_generation(parent));
 		btrfs_tree_mod_log_insert_key(parent, parent_slot,
@@ -524,8 +530,14 @@ int btrfs_force_cow_block(struct btrfs_trans_handle *trans,
 				return ret;
 			}
 		}
-		btrfs_free_tree_block(trans, btrfs_root_id(root), buf,
-				      parent_start, last_ref);
+		ret = btrfs_free_tree_block(trans, btrfs_root_id(root), buf,
+					    parent_start, last_ref);
+		if (ret < 0) {
+			btrfs_tree_unlock(cow);
+			free_extent_buffer(cow);
+			btrfs_abort_transaction(trans, ret);
+			return ret;
+		}
 	}
 
 	trace_btrfs_cow_block(root, buf, cow);
@@ -999,9 +1011,13 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		free_extent_buffer(mid);
 
 		root_sub_used(root, mid->len);
-		btrfs_free_tree_block(trans, btrfs_root_id(root), mid, 0, 1);
+		ret = btrfs_free_tree_block(trans, btrfs_root_id(root), mid, 0, 1);
 		/* once for the root ptr */
 		free_extent_buffer_stale(mid);
+		if (ret < 0) {
+			btrfs_abort_transaction(trans, ret);
+			goto enospc;
+		}
 		return 0;
 	}
 	if (btrfs_header_nritems(mid) >
@@ -1058,10 +1074,14 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			btrfs_tree_unlock(right);
 			del_ptr(root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
-			btrfs_free_tree_block(trans, btrfs_root_id(root), right,
-					      0, 1);
+			ret = btrfs_free_tree_block(trans, btrfs_root_id(root),
+						    right, 0, 1);
 			free_extent_buffer_stale(right);
 			right = NULL;
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, ret);
+				goto enospc;
+			}
 		} else {
 			struct btrfs_disk_key right_key;
 			btrfs_node_key(right, &right_key, 0);
@@ -1107,9 +1127,15 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		btrfs_tree_unlock(mid);
 		del_ptr(root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
-		btrfs_free_tree_block(trans, btrfs_root_id(root), mid, 0, 1);
+		ret = btrfs_free_tree_block(trans, btrfs_root_id(root), mid, 0, 1);
 		free_extent_buffer_stale(mid);
 		mid = NULL;
+		if (ret < 0) {
+			path->locks[level] = 0;
+			path->nodes[level] = NULL;
+			btrfs_abort_transaction(trans, ret);
+			goto enospc;
+		}
 	} else {
 		/* update the parent key to reflect our changes */
 		struct btrfs_disk_key mid_key;
@@ -4314,11 +4340,13 @@ static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
  * The path must have already been setup for deleting the leaf, including
  * all the proper balancing.  path->nodes[1] must be locked.
  */
-static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root,
-				    struct btrfs_path *path,
-				    struct extent_buffer *leaf)
+static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_path *path,
+				   struct extent_buffer *leaf)
 {
+	int ret;
+
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
 	del_ptr(root, path, 1, path->slots[1]);
 
@@ -4331,8 +4359,12 @@ static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	root_sub_used(root, leaf->len);
 
 	atomic_inc(&leaf->refs);
-	btrfs_free_tree_block(trans, btrfs_root_id(root), leaf, 0, 1);
+	ret = btrfs_free_tree_block(trans, btrfs_root_id(root), leaf, 0, 1);
 	free_extent_buffer_stale(leaf);
+	if (ret < 0)
+		btrfs_abort_transaction(trans, ret);
+
+	return ret;
 }
 /*
  * delete the item at the leaf level in path.  If that empties
@@ -4387,7 +4419,9 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			btrfs_set_header_level(leaf, 0);
 		} else {
 			btrfs_clean_tree_block(leaf);
-			btrfs_del_leaf(trans, root, path, leaf);
+			ret = btrfs_del_leaf(trans, root, path, leaf);
+			if (ret < 0)
+				return ret;
 		}
 	} else {
 		int used = leaf_space_used(leaf, 0, nritems);
@@ -4448,9 +4482,8 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 			if (btrfs_header_nritems(leaf) == 0) {
 				path->slots[1] = slot;
-				btrfs_del_leaf(trans, root, path, leaf);
+				ret = btrfs_del_leaf(trans, root, path, leaf);
 				free_extent_buffer(leaf);
-				ret = 0;
 			} else {
 				/* if we're still in the path, make sure
 				 * we're dirty.  Otherwise, one of the
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 16795e91aee29..90a6b36f8baf4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2888,10 +2888,10 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 					     int level, u64 hint,
 					     u64 empty_size,
 					     enum btrfs_lock_nesting nest);
-void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
-			   u64 root_id,
-			   struct extent_buffer *buf,
-			   u64 parent, int last_ref);
+int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
+			  u64 root_id,
+			  struct extent_buffer *buf,
+			  u64 parent, int last_ref);
 int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root, u64 owner,
 				     u64 offset, u64 ram_bytes,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9a3c304d76b40..a09ac37f7cf48 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3280,10 +3280,10 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
-			   u64 root_id,
-			   struct extent_buffer *buf,
-			   u64 parent, int last_ref)
+int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
+			  u64 root_id,
+			  struct extent_buffer *buf,
+			  u64 parent, int last_ref)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_ref generic_ref = { 0 };
@@ -3297,7 +3297,8 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	if (root_id != BTRFS_TREE_LOG_OBJECTID) {
 		btrfs_ref_tree_mod(fs_info, &generic_ref);
 		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret < 0)
+			return ret;
 	}
 
 	if (last_ref && btrfs_header_generation(buf) == trans->transid) {
@@ -3361,6 +3362,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		 */
 		clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
 	}
+	return 0;
 }
 
 /* Can return -ENOMEM */
@@ -5533,7 +5535,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 				 struct walk_control *wc)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	int ret;
+	int ret = 0;
 	int level = wc->level;
 	struct extent_buffer *eb = path->nodes[level];
 	u64 parent = 0;
@@ -5628,12 +5630,14 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			goto owner_mismatch;
 	}
 
-	btrfs_free_tree_block(trans, btrfs_root_id(root), eb, parent,
-			      wc->refs[level] == 1);
+	ret = btrfs_free_tree_block(trans, btrfs_root_id(root), eb, parent,
+				    wc->refs[level] == 1);
+	if (ret < 0)
+		btrfs_abort_transaction(trans, ret);
 out:
 	wc->refs[level] = 0;
 	wc->flags[level] = 0;
-	return 0;
+	return ret;
 
 owner_mismatch:
 	btrfs_err_rl(fs_info, "unexpected tree owner, have %llu expect %llu",
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 9e966e8876f58..8c6b21531cf51 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1292,10 +1292,14 @@ int btrfs_delete_free_space_tree(struct btrfs_fs_info *fs_info)
 	btrfs_tree_lock(free_space_root->node);
 	btrfs_clean_tree_block(free_space_root->node);
 	btrfs_tree_unlock(free_space_root->node);
-	btrfs_free_tree_block(trans, btrfs_root_id(free_space_root),
-			      free_space_root->node, 0, 1);
-
+	ret = btrfs_free_tree_block(trans, btrfs_root_id(free_space_root),
+				    free_space_root->node, 0, 1);
 	btrfs_put_root(free_space_root);
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
+		return ret;
+	}
 
 	return btrfs_commit_transaction(trans);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e278da90888e1..bc1f605e55a20 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -696,6 +696,8 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	ret = btrfs_insert_root(trans, fs_info->tree_root, &key,
 				root_item);
 	if (ret) {
+		int ret2;
+
 		/*
 		 * Since we don't abort the transaction in this case, free the
 		 * tree block so that we don't leak space and leave the
@@ -706,7 +708,9 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 		btrfs_tree_lock(leaf);
 		btrfs_clean_tree_block(leaf);
 		btrfs_tree_unlock(leaf);
-		btrfs_free_tree_block(trans, objectid, leaf, 0, 1);
+		ret2 = btrfs_free_tree_block(trans, objectid, leaf, 0, 1);
+		if (ret2 < 0)
+			btrfs_abort_transaction(trans, ret2);
 		free_extent_buffer(leaf);
 		goto out;
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e80d73ad08103..e927111567fa2 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1325,9 +1325,11 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	btrfs_tree_lock(quota_root->node);
 	btrfs_clean_tree_block(quota_root->node);
 	btrfs_tree_unlock(quota_root->node);
-	btrfs_free_tree_block(trans, btrfs_root_id(quota_root),
-			      quota_root->node, 0, 1);
+	ret = btrfs_free_tree_block(trans, btrfs_root_id(quota_root),
+				    quota_root->node, 0, 1);
 
+	if (ret < 0)
+		btrfs_abort_transaction(trans, ret);
 
 out:
 	btrfs_put_root(quota_root);
-- 
2.53.0



