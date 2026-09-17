Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C814ABBDB;
	Thu, 17 Sep 2026 19:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671675; cv=none; b=fL57sX+pKSOE0rVkiZZ/BAGbUm2M5RRFLuFffpy0Lvy22dNj/s5K6oX1X/4RPMk7j0BLyC5wz7EF6q8rw+Q9HViv1a7DWHAdH1K0idETSlYqFV7RVmcKCP4hqx5PCeC4rwzUgjTC7WslqmWiRVvTegLf7PRs87X123uuqnxIo1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671675; c=relaxed/simple;
	bh=OX1iLRq7nU/wmY3kgJ4oeLmD9QpLgFb1GDLL2Ehf/Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bB6t2a8+d/9SYl0TH9VehJA9GK/caLPpzhC+uDKU9Cu96LnD43JJGRzWvo5t0yAyIjiLkEMmKs6Pds3tqBAmKQfu1jsWK2h44tx1wXvCtnECrgKhSRBrQ6ctyydMPFQ/frKa2Vn+5jZGUmKZAXPOpLx48VNt5f42rqHFoHGcfww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAWZWcZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAWZWcZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B209D1F00898;
	Thu, 17 Sep 2026 19:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671642;
	bh=XoGiZ3q15UjfpX72MDezwfeMg46TSmQ5cRK0fUG98Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAWZWcZsWka8BHDL0TZqSVirJXPG0FPq7KTCsqlDdfZdzVa+7t2zZBLr9V6mBal38
	 5YN+HwSuc5RnSrgrnhhFcZa4nRVX02nZJQet05uUKJcFcgT5Ai6ZIfF+zhq0o/hvPS
	 vGEZ2Brd20hBwBDGr9AZtfvIHClN7d88xMHEv7J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1042/1102] btrfs: move btrfs_alloc_write_mask() into fs.h
Date: Thu, 17 Sep 2026 16:16:25 +0100
Message-ID: <20260917151606.952285612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 378f25d3fc429ad001fa686f615df5c0f9cd47e1 ]

Currently btrfs_alloc_write_mask() is defined in ctree.h but it's not
related at all to the btree data structure, so move it into fs.h.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 15f7c86215e8 ("btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h |    6 ------
 fs/btrfs/fs.h    |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -7,7 +7,6 @@
 #define BTRFS_CTREE_H
 
 #include "linux/cleanup.h"
-#include <linux/pagemap.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
 #include <linux/mutex.h>
@@ -506,11 +505,6 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(c
 	return BTRFS_MAX_ITEM_SIZE(info) - sizeof(struct btrfs_dir_item);
 }
 
-static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
-{
-	return mapping_gfp_constraint(mapping, ~__GFP_FS);
-}
-
 void btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info, u64 start, u64 end);
 int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 			 u64 num_bytes, u64 *actual_bytes);
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -18,6 +18,7 @@
 #include <linux/rwsem.h>
 #include <linux/semaphore.h>
 #include <linux/list.h>
+#include <linux/pagemap.h>
 #include <linux/radix-tree.h>
 #include <linux/workqueue.h>
 #include <linux/wait.h>
@@ -893,6 +894,11 @@ struct btrfs_fs_info {
 #define inode_to_fs_info(_inode) (BTRFS_I(_Generic((_inode),			\
 					   struct inode *: (_inode)))->root->fs_info)
 
+static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
+{
+	return mapping_gfp_constraint(mapping, ~__GFP_FS);
+}
+
 static inline u64 btrfs_get_fs_generation(const struct btrfs_fs_info *fs_info)
 {
 	return READ_ONCE(fs_info->generation);


