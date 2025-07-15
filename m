Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FE72E54B4;
	Tue, 15 Jul 2025 13:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585949; cv=none; b=kVVROWAiQHO6wUuc8MOBxMNCu0TTE8fRDt7plBklq2aqri1xaPXukKaPaBo1iiJQ8ljau7H9nFuY9jTlmU8r8TCOLouB9ZBZgK2L9y8v/W7BMK9/JTtxgvW40ptFLqrsoBNmlod4Od0cdAsd9XwM+2pBRmruFOyyEiGWUnUS+Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585949; c=relaxed/simple;
	bh=zgxZQsP3VSMeHjTne5SzrSkVCDLkqwhxwRAzFY0DEtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gyj1hK+XUIG9w72uinUmEOv3M1jSt4G+TgaZi10GWZcDeAiKB1XEbJDgt/c0KxekzXOsDkNmQOi/hS7sQvU6AbbBvLKNBH3Ss70sOTeCjLAqiKT/O8Y1IrULufJPdk9Y2h6HcWQs8rp5orTBOmBew15yAAiYu5gWo08rGLf5m/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JeebnhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JeebnhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC11DC4CEE3;
	Tue, 15 Jul 2025 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585949;
	bh=zgxZQsP3VSMeHjTne5SzrSkVCDLkqwhxwRAzFY0DEtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JeebnhEIVoA9kRk97S1g8HyCkI0lKt+q2j7EldDYOWUiy4Fr7ozZoqV/rEPraVuu
	 8NfJBcxnuxiyxgBeMflDjrGD3CDGKC2w+WJmNqJOp4xZrtPrGeL6vd/k+NwbA+hjz1
	 9y+l/uh1rkmcnlaaFwylP86oxIcEAuCG9QtpecDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/109] btrfs: remove redundant root argument from btrfs_update_inode_fallback()
Date: Tue, 15 Jul 2025 15:13:23 +0200
Message-ID: <20250715130801.566027128@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 0a5d0dc55fcb15da016fa28d27bf50ca7f17ec11 ]

The root argument for btrfs_update_inode_fallback() always matches the
root of the given inode, so remove the root argument and get it from the
inode argument.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 5f61b961599a ("btrfs: fix inode lookup error handling during log replay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h |  2 +-
 fs/btrfs/inode.c       | 12 ++++++------
 fs/btrfs/transaction.c |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ec6679a538c1d..c23c56ead6b23 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -488,7 +488,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct btrfs_inode *inode);
 int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, struct btrfs_inode *inode);
+				struct btrfs_inode *inode);
 int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct btrfs_inode *inode);
 int btrfs_orphan_cleanup(struct btrfs_root *root);
 int btrfs_cont_expand(struct btrfs_inode *inode, loff_t oldsize, loff_t size);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c80c918485547..218d15f5ddf73 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3077,7 +3077,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 			goto out;
 		}
 		trans->block_rsv = &inode->block_rsv;
-		ret = btrfs_update_inode_fallback(trans, root, inode);
+		ret = btrfs_update_inode_fallback(trans, inode);
 		if (ret) /* -ENOMEM or corruption */
 			btrfs_abort_transaction(trans, ret);
 		goto out;
@@ -3143,7 +3143,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 				 &cached_state);
 
 	btrfs_inode_safe_disk_i_size_write(inode, 0);
-	ret = btrfs_update_inode_fallback(trans, root, inode);
+	ret = btrfs_update_inode_fallback(trans, inode);
 	if (ret) { /* -ENOMEM or corruption */
 		btrfs_abort_transaction(trans, ret);
 		goto out;
@@ -4043,13 +4043,13 @@ int btrfs_update_inode(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, struct btrfs_inode *inode)
+				struct btrfs_inode *inode)
 {
 	int ret;
 
-	ret = btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, inode->root, inode);
 	if (ret == -ENOSPC)
-		return btrfs_update_inode_item(trans, root, inode);
+		return btrfs_update_inode_item(trans, inode->root, inode);
 	return ret;
 }
 
@@ -4327,7 +4327,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	btrfs_i_size_write(dir, dir->vfs_inode.i_size - fname.disk_name.len * 2);
 	inode_inc_iversion(&dir->vfs_inode);
 	dir->vfs_inode.i_mtime = inode_set_ctime_current(&dir->vfs_inode);
-	ret = btrfs_update_inode_fallback(trans, root, dir);
+	ret = btrfs_update_inode_fallback(trans, dir);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
 out:
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index aa03db69a0164..3989cb19cdae7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1860,7 +1860,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_i_size_write(BTRFS_I(parent_inode), parent_inode->i_size +
 						  fname.disk_name.len * 2);
 	parent_inode->i_mtime = inode_set_ctime_current(parent_inode);
-	ret = btrfs_update_inode_fallback(trans, parent_root, BTRFS_I(parent_inode));
+	ret = btrfs_update_inode_fallback(trans, BTRFS_I(parent_inode));
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
-- 
2.39.5



