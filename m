Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214683;
	b=t5E56ItB3qHpkXLvLo0ulZo7bsU2o9Y+9/sPid93jakgFzvyNWPr7Hzn4wuFlLMbAono
	 ocu5fRaAmlQJSuoH6R7rERhDJfuWa+mzG2yzwU+9DRuzArXPm0EtLimGJo9NgXidGi5u0
	 AUIE+AXxm9c/UDpyn4irEeNGPhoR5nas0kUbw0FLtO38g6rGKWIg51Z/KVIDuTCQRmOKu
	 /YFwzADFKKxIln2+fXWebWGf/bfZQjItKaNsV61RBkLnpUmJ8DggRmzLGfMcuZ7t49k71
	 LszIxPdNlCP+v8esQ/1oSkKZyPQDmMaNNkequvlBbTREUV5bAT0qdwoqqtxgquq4Z6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vibJ4sXMlsm0k3DkAfCvuOEz9Eiys1xFT9xjG0nH9+o=;
	b=42MXyLpV+TuF9vpJh8BBypQaYaW9aHW2S8uibIgo/SDDh054CrfwlYUVo1zm//b7/EUV
	 BF7FBmeD4j7K/0WfUNBKlGrDMBsefE6xJMfFAyUaRwhmt2S4T6/J19IGxQP0tRObwgt0A
	 ChJRfed2EVtyrU1s7BSrqHiLTOX9g+9HVut39VHgZIW2J8JaKfeIrpc6/eNV+hlmXnPYf
	 3nXR/aedfFTCSfxPCqutomq+Q8wahxR9RbHi9B4GjBIrChdXqPdnZ0pxKsz5APoYbJhDC
	 xYdh+HiSYOweRcg7rxZYJy4EmtFSDLYuecDR26zxSYk9tFARVjxYWxyN//9NAHX2LeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6pDvbjp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF89606B7CF;
	Wed, 28 Oct 2026 19:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6pDvbjp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7541F01825;
	Wed, 28 Oct 2026 19:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214683;
	bh=vibJ4sXMlsm0k3DkAfCvuOEz9Eiys1xFT9xjG0nH9+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6pDvbjpUVQl+OBae80SRr6B9cjg9OVfPYGyxeGP3SKpaD2wl0d6Krx2q2O7ms9Li
	 xfyr99SbvYZvNZazsbJUTvssqtEtHLiCLgU4yk9hch9ba90dh5I/c5GbHOc75vscTj
	 8IyMBbN5iE2GK8L+72cHuxgperZnTwPWuXKzCUhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0943/1887] btrfs: log new dentries when logging parent dir of a conflicting inode
Date: Wed, 28 Oct 2026 17:50:39 +0100
Message-ID: <20261028170520.870002177@linuxfoundation.org>
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

[ Upstream commit 9573a365ff9ff45da9222d3fe63695ce562beb24 ]

If we log the parent directory of a conflicting inode, we are not logging
the new dentries of the directory, so when we finish we have the parent
directory's inode marked as logged but we did not log its new dentries.
As a consequence if the parent directory is explicitly fsynced later and
it does not have any new changes since we logged it, the fsync is a no-op
and after a power failure the new dentries are missing.

Example scenario:

  $ mkdir foo

  $ sync

  $rmdir foo

  $ mkdir dir1
  $ mkdir dir2

  # A file with the same name and parent as the directory we just deleted
  # and was persisted in a past transaction. So the deleted directory's
  # inode is a conflicting inode of this new file's inode.
  $ touch foo

  $ ln foo dir2/link

  # The fsync on dir2 will log the parent directory (".") because the
  # conflicting inode (deleted directory) does not exists anymore, but it
  # it does not log its new dentries (dir1).
  $ xfs_io -c "fsync" dir2

  # This fsync on the parent directory is no-op, since the previous fsync
  # logged it (but without logging its new dentries).
  $ xfs_io -c "fsync" .

  <power failure>

  # After log replay dir1 is missing.

Fix this by ensuring we log new dir dentries whenever we log the parent
directory of a no longer existing conflicting inode.

A test case for fstests will follow soon.

Reported-by: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/182055fa-e9ce-4089-9f5f-4b8a23e8dd91@gmail.com/
Fixes: a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ceb2a9556fe7b..e361a608f3ae9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5793,6 +5793,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 				  struct btrfs_log_ctx *ctx)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	const bool orig_log_new_dentries = ctx->log_new_dentries;
 	int ret = 0;
 
 	/*
@@ -5854,8 +5855,12 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 			 * dir index key range logged for the directory. So we
 			 * must make sure the deletion is recorded.
 			 */
+			ctx->log_new_dentries = false;
 			ret = btrfs_log_inode(trans, BTRFS_I(inode),
 					      LOG_INODE_ALL, ctx);
+			if (!ret && ctx->log_new_dentries)
+				ret = log_new_dir_dentries(trans, BTRFS_I(inode), ctx);
+
 			btrfs_add_delayed_iput(inode);
 			if (ret)
 				break;
@@ -5890,6 +5895,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 			break;
 	}
 
+	ctx->log_new_dentries = orig_log_new_dentries;
 	ctx->logging_conflict_inodes = false;
 	if (ret)
 		free_conflicting_inodes(ctx);
-- 
2.53.0



