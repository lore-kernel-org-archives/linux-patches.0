Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216046;
	b=IQkjM5iBYGafj2n4I0oUrmZYn/hjnOA9hbSUPY9Gk9Lp4FWW32FR9pFf3AIk1fy2lMDp
	 MIszhfRz/iywNcSC4OfbJvGB2rfZFI/lRss0/Z4kBjAXngJcsd/SDFj4JJLSAcdKi9sK9
	 +TigosLmXfe4BhKYMK2Jcg+i/1AegFnYF0LtRrq32HrZJUIlkrL3+kbXY8Qwio4sfQgHG
	 8WGtcs/8aYxxTJAWVzL41O8y5u5gf/fZtFttTKUhwUlKaWjOkDWoWkFDLw9Z70Wm1a080
	 SvpBvu5L5IAB/2GZ0/Ut52sIcXjiSYZtq1q4d9lcPEGakh66qxTRYPNby6yzuTgnC7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eijxIneHUALZ3Q09z7BSuje2Di/xdYP1vvIzqGiO22Y=;
	b=gDhqT4LoWO7ArH9sKtSRfAnql/tjkS78CxTgkb4eauleDQpHS8rmwHUIw15dkVV8RB+8
	 RBDKRnoio/njfwlkh2Wb/KbCTD5Fp0CVJKFWMsDWNzBcVEpGw7dg8Tqbty7wLTaLX1znj
	 pkvGHCKgTq2mBy3sutfU0yogtKPst+vP4jDR6/JgO4BXFksxuTa75UKICaExw0SOoW41/
	 2B+SDP2ooEpVAoYFbjjXP21uhHAkjEBcaT/aQ8GlUjFCrVSWy5Gjk/hDojpwNIvYsQ7ip
	 Yw/SDBAhvXF145kUfqx9ryyn6VW711gzJRQeMtat7bC+F2Z8IIlNUlJ2LELNT/FFtlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CYzmWngR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93041606A31A;
	Wed, 28 Oct 2026 19:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CYzmWngR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06911F01825;
	Wed, 28 Oct 2026 19:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216046;
	bh=eijxIneHUALZ3Q09z7BSuje2Di/xdYP1vvIzqGiO22Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYzmWngRqyPwQ5sHT1UatCcmYywZUw+j6HgKWFKLNTnrU9nQqfTR6JoKIhQCNRL+B
	 mIyPg3QsqkTEZqRFPDzwOCWZ7R440eDonioBqhCZmvzwtdluL94e59ixHwV0ISeI1d
	 G8Nv9YaO12VA/IeZUSVgi8tqbBA6mfiMqEsZxAbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1423/1887] btrfs: rename err to ret in btrfs_recover_relocation()
Date: Wed, 28 Oct 2026 17:58:39 +0100
Message-ID: <20261028170531.840502385@linuxfoundation.org>
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
index 7def1a16fd488..f3e597d5eb6e3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4245,7 +4245,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	struct reloc_control *rc = NULL;
 	struct btrfs_trans_handle *trans;
 	int ret2;
-	int err = 0;
+	int ret = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -4257,16 +4257,16 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
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
@@ -4277,7 +4277,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
 		reloc_root = btrfs_read_tree_root(fs_info->tree_root, &key);
 		if (IS_ERR(reloc_root)) {
-			err = PTR_ERR(reloc_root);
+			ret = PTR_ERR(reloc_root);
 			goto out;
 		}
 
@@ -4288,13 +4288,13 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
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
@@ -4312,12 +4312,12 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
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
@@ -4326,7 +4326,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
 	trans = btrfs_join_transaction(rc->extent_root);
 	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+		ret = PTR_ERR(trans);
 		goto out_unset;
 	}
 
@@ -4346,15 +4346,15 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
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
@@ -4364,8 +4364,8 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 		btrfs_put_root(fs_root);
 	}
 
-	err = btrfs_commit_transaction(trans);
-	if (err)
+	ret = btrfs_commit_transaction(trans);
+	if (ret)
 		goto out_unset;
 
 	merge_reloc_roots(rc);
@@ -4374,14 +4374,14 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
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
@@ -4392,14 +4392,14 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 
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



