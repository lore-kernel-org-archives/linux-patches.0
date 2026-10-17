Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDAB3A1E92;
	Sat, 17 Oct 2026 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259737; cv=none; b=HPtS2MY0vLso6YFUXJZUmi4HmaFD1q9xK8SUfYZ/KXQEXtJCLvqYcMgq/P9oYR1RP+JY34lzkHYLmzSZm4ABVqrFJs4aJh90JyRZkkt4R4qxS8ynO7xBwaSB+/fhLRmfewgn5o+RdOiXZdwywCSQd1ZQJIDfosJbMtd9X64QDHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259737; c=relaxed/simple;
	bh=N0KFqabIM62REu2hJreLA0INysUA5BMKnFqErlpxHU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/G85btwdBWuNV9am7WiFw5etk0F1y1I4rDVyjv8kJCePPcgfo56A6Xo3mId1kffe7U4w8XXXUfpBfkSeVxFGXQQFw5/7jwwLGmc6MiFNtwwypQy700lgixXHgvDM7x8zXJ6FCVJ1EyXkBfD/BlDuYhKemlEVhCxiGdgjo0EZGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGuJmalx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGuJmalx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85031F000C4;
	Sat, 17 Oct 2026 17:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259736;
	bh=THjgEqWahjmM9CBFt2FD7zawvieQXwqcc165IkH/mNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGuJmalxb3KlVVfkohB8wLi6sSPqABEh8UPiqh4QFW8C1Ic7B/6V+tPIVNo9LC13A
	 J17IvrLmKWXvXevi8RIlEryOLh48PsnLyf/P0CX3kfZBHn5NWOv86yotyXEBerEZ2Q
	 WwIK+pmPcNaVyvrs7DndPJ0aEEgFzxlsZ94d12CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1312/1674] btrfs: rename err to ret in btrfs_recover_relocation()
Date: Sat, 17 Oct 2026 17:59:44 +0200
Message-ID: <20261017160504.821098379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit ced1b1bd214fab463f35438c63d9bc6b1a743cae ]

Fix coding style: rename the return variable to 'ret' in the function
btrfs_recover_relocation instead of 'err'.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 6d8ba4572922 ("btrfs: drop recovered reloc root refs on recovery failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 56 +++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0e29da8704752..c66508671eebf 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4205,7 +4205,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	struct reloc_control *rc = NULL;
 	struct btrfs_trans_handle *trans;
 	int ret2;
-	int err = 0;
+	int ret = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -4217,16 +4217,16 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	key.offset = (u64)-1;
 
 	while (1) {
-		err = btrfs_search_slot(NULL, fs_info->tree_root, &key,
+		ret = btrfs_search_slot(NULL, fs_info->tree_root, &key,
 					path, 0, 0);
-		if (err < 0)
+		if (ret < 0)
 			goto out;
-		if (err > 0) {
+		if (ret > 0) {
 			if (path->slots[0] == 0)
 				break;
 			path->slots[0]--;
 		}
-		err = 0;
+		ret = 0;
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		btrfs_release_path(path);
@@ -4237,7 +4237,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
 		reloc_root = btrfs_read_tree_root(fs_info->tree_root, &key);
 		if (IS_ERR(reloc_root)) {
-			err = PTR_ERR(reloc_root);
+			ret = PTR_ERR(reloc_root);
 			goto out;
 		}
 
@@ -4248,13 +4248,13 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 			fs_root = btrfs_get_fs_root(fs_info,
 					reloc_root->root_key.offset, false);
 			if (IS_ERR(fs_root)) {
-				err = PTR_ERR(fs_root);
-				if (err != -ENOENT)
+				ret = PTR_ERR(fs_root);
+				if (ret != -ENOENT)
 					goto out;
-				err = mark_garbage_root(reloc_root);
-				if (err < 0)
+				ret = mark_garbage_root(reloc_root);
+				if (ret < 0)
 					goto out;
-				err = 0;
+				ret = 0;
 			} else {
 				btrfs_put_root(fs_root);
 			}
@@ -4272,12 +4272,12 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
 	rc = alloc_reloc_control(fs_info);
 	if (!rc) {
-		err = -ENOMEM;
+		ret = -ENOMEM;
 		goto out;
 	}
 
-	err = reloc_chunk_start(fs_info);
-	if (err < 0)
+	ret = reloc_chunk_start(fs_info);
+	if (ret < 0)
 		goto out_end;
 
 	rc->extent_root = btrfs_extent_root(fs_info, 0);
@@ -4286,7 +4286,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
 	trans = btrfs_join_transaction(rc->extent_root);
 	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+		ret = PTR_ERR(trans);
 		goto out_unset;
 	}
 
@@ -4306,15 +4306,15 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 		fs_root = btrfs_get_fs_root(fs_info, reloc_root->root_key.offset,
 					    false);
 		if (IS_ERR(fs_root)) {
-			err = PTR_ERR(fs_root);
+			ret = PTR_ERR(fs_root);
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			btrfs_end_transaction(trans);
 			goto out_unset;
 		}
 
-		err = __add_reloc_root(reloc_root);
-		ASSERT(err != -EEXIST);
-		if (err) {
+		ret = __add_reloc_root(reloc_root);
+		ASSERT(ret != -EEXIST);
+		if (ret) {
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			btrfs_put_root(fs_root);
 			btrfs_end_transaction(trans);
@@ -4324,8 +4324,8 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 		btrfs_put_root(fs_root);
 	}
 
-	err = btrfs_commit_transaction(trans);
-	if (err)
+	ret = btrfs_commit_transaction(trans);
+	if (ret)
 		goto out_unset;
 
 	merge_reloc_roots(rc);
@@ -4334,14 +4334,14 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
 	trans = btrfs_join_transaction(rc->extent_root);
 	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+		ret = PTR_ERR(trans);
 		goto out_clean;
 	}
-	err = btrfs_commit_transaction(trans);
+	ret = btrfs_commit_transaction(trans);
 out_clean:
 	ret2 = clean_dirty_subvols(rc);
-	if (ret2 < 0 && !err)
-		err = ret2;
+	if (ret2 < 0 && !ret)
+		ret = ret2;
 out_unset:
 	unset_reloc_control(rc);
 	reloc_chunk_end(fs_info);
@@ -4352,14 +4352,14 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
 	btrfs_free_path(path);
 
-	if (err == 0) {
+	if (ret == 0) {
 		/* cleanup orphan inode in data relocation tree */
 		fs_root = btrfs_grab_root(fs_info->data_reloc_root);
 		ASSERT(fs_root);
-		err = btrfs_orphan_cleanup(fs_root);
+		ret = btrfs_orphan_cleanup(fs_root);
 		btrfs_put_root(fs_root);
 	}
-	return err;
+	return ret;
 }
 
 /*
-- 
2.53.0



