Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8FF2D8764;
	Wed,  4 Feb 2026 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217556; cv=none; b=RpIkpWitLATdvbD3IZ0YuLlqoyhZmtidKg4BDzQht842t17YXdAreef2ahRpx5Xa3puT+h9ROX95n0mrre/oPb68JByPH3LXZaDNytEMmBQjqEFaZjLgp3Y2tB4+qkUOio1lAcGqJt3ThY2tMzxTfSGcNZ1ugXsmQwp3n7PQUK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217556; c=relaxed/simple;
	bh=LAo/nwXj3ErhybTyYKfSOwFR/XT05yfwDs/2dNCqNlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hk7Ca/U+SW2VCD4okX4MwmXYsoug0aNf8GNRpkcD5oyNtrQRE4E65XKs0BBMs2HLe57MWsVaOpX/3dcuMkuPfrJI1fVYElnd/ODl8KTAmV8rVAtgQ1M9Ju9YP2KVLHVgP4ywazULrju5oy4jNsGaBqbyL/bcD81Mp3qax9WfLrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNXov7kT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNXov7kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5CDC4CEF7;
	Wed,  4 Feb 2026 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217556;
	bh=LAo/nwXj3ErhybTyYKfSOwFR/XT05yfwDs/2dNCqNlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNXov7kTF249ld8kCzHlcHcCMV4ibMnQ9WkiYYyyL+qBJv4g3Oxg61Vw+yZh7e5Ne
	 FNyHltyPXTRAHVCBMpE0IyKHEh6sQ3K+wTBzylPEUhghm21HlvSadek7BOrNnLHhWU
	 cLeFaQzTzaUe0+G/6b5SZySBjdQI1lckNqzb+fM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/280] btrfs: move flush related definitions to space-info.h
Date: Wed,  4 Feb 2026 15:36:30 +0100
Message-ID: <20260204143910.214944805@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f1e5c6185ca166cde0c7c2eeeab5d233ef315140 ]

This code is used in space-info.c, move the definitions to space-info.h.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: a11224a016d6 ("btrfs: fix memory leaks in create_space_info() error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h         | 59 ----------------------------------------
 fs/btrfs/delayed-inode.c |  1 +
 fs/btrfs/inode-item.c    |  1 +
 fs/btrfs/props.c         |  1 +
 fs/btrfs/relocation.c    |  1 +
 fs/btrfs/space-info.h    | 59 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 63 insertions(+), 59 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index da8986e0c4222..bd84a8b774a68 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2925,65 +2925,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 
-/*
- * Different levels for to flush space when doing space reservations.
- *
- * The higher the level, the more methods we try to reclaim space.
- */
-enum btrfs_reserve_flush_enum {
-	/* If we are in the transaction, we can't flush anything.*/
-	BTRFS_RESERVE_NO_FLUSH,
-
-	/*
-	 * Flush space by:
-	 * - Running delayed inode items
-	 * - Allocating a new chunk
-	 */
-	BTRFS_RESERVE_FLUSH_LIMIT,
-
-	/*
-	 * Flush space by:
-	 * - Running delayed inode items
-	 * - Running delayed refs
-	 * - Running delalloc and waiting for ordered extents
-	 * - Allocating a new chunk
-	 */
-	BTRFS_RESERVE_FLUSH_EVICT,
-
-	/*
-	 * Flush space by above mentioned methods and by:
-	 * - Running delayed iputs
-	 * - Committing transaction
-	 *
-	 * Can be interrupted by a fatal signal.
-	 */
-	BTRFS_RESERVE_FLUSH_DATA,
-	BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE,
-	BTRFS_RESERVE_FLUSH_ALL,
-
-	/*
-	 * Pretty much the same as FLUSH_ALL, but can also steal space from
-	 * global rsv.
-	 *
-	 * Can be interrupted by a fatal signal.
-	 */
-	BTRFS_RESERVE_FLUSH_ALL_STEAL,
-};
-
-enum btrfs_flush_state {
-	FLUSH_DELAYED_ITEMS_NR	=	1,
-	FLUSH_DELAYED_ITEMS	=	2,
-	FLUSH_DELAYED_REFS_NR	=	3,
-	FLUSH_DELAYED_REFS	=	4,
-	FLUSH_DELALLOC		=	5,
-	FLUSH_DELALLOC_WAIT	=	6,
-	FLUSH_DELALLOC_FULL	=	7,
-	ALLOC_CHUNK		=	8,
-	ALLOC_CHUNK_FORCE	=	9,
-	RUN_DELAYED_IPUTS	=	10,
-	COMMIT_TRANS		=	11,
-};
-
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int nitems, bool use_global_rsv);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 052112d0daa74..214168868ac08 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -14,6 +14,7 @@
 #include "qgroup.h"
 #include "locking.h"
 #include "inode-item.h"
+#include "space-info.h"
 
 #define BTRFS_DELAYED_WRITEBACK		512
 #define BTRFS_DELAYED_BACKGROUND	128
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index 5add022d3534f..ce5c51ffdc0d0 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -8,6 +8,7 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "print-tree.h"
+#include "space-info.h"
 
 struct btrfs_inode_ref *btrfs_find_name_in_backref(struct extent_buffer *leaf,
 						   int slot,
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 055a631276ce1..07f62e3ba6a51 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -10,6 +10,7 @@
 #include "ctree.h"
 #include "xattr.h"
 #include "compression.h"
+#include "space-info.h"
 
 #define BTRFS_PROP_HANDLERS_HT_BITS 8
 static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3fdf5519336f9..795df859cdbfc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -27,6 +27,7 @@
 #include "subpage.h"
 #include "zoned.h"
 #include "inode-item.h"
+#include "space-info.h"
 
 /*
  * Relocation overview
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index 99ce3225dd59d..fea2f93674e7c 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -5,6 +5,65 @@
 
 #include "volumes.h"
 
+/*
+ * Different levels for to flush space when doing space reservations.
+ *
+ * The higher the level, the more methods we try to reclaim space.
+ */
+enum btrfs_reserve_flush_enum {
+	/* If we are in the transaction, we can't flush anything.*/
+	BTRFS_RESERVE_NO_FLUSH,
+
+	/*
+	 * Flush space by:
+	 * - Running delayed inode items
+	 * - Allocating a new chunk
+	 */
+	BTRFS_RESERVE_FLUSH_LIMIT,
+
+	/*
+	 * Flush space by:
+	 * - Running delayed inode items
+	 * - Running delayed refs
+	 * - Running delalloc and waiting for ordered extents
+	 * - Allocating a new chunk
+	 */
+	BTRFS_RESERVE_FLUSH_EVICT,
+
+	/*
+	 * Flush space by above mentioned methods and by:
+	 * - Running delayed iputs
+	 * - Committing transaction
+	 *
+	 * Can be interrupted by a fatal signal.
+	 */
+	BTRFS_RESERVE_FLUSH_DATA,
+	BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE,
+	BTRFS_RESERVE_FLUSH_ALL,
+
+	/*
+	 * Pretty much the same as FLUSH_ALL, but can also steal space from
+	 * global rsv.
+	 *
+	 * Can be interrupted by a fatal signal.
+	 */
+	BTRFS_RESERVE_FLUSH_ALL_STEAL,
+};
+
+enum btrfs_flush_state {
+	FLUSH_DELAYED_ITEMS_NR	= 1,
+	FLUSH_DELAYED_ITEMS	= 2,
+	FLUSH_DELAYED_REFS_NR	= 3,
+	FLUSH_DELAYED_REFS	= 4,
+	FLUSH_DELALLOC		= 5,
+	FLUSH_DELALLOC_WAIT	= 6,
+	FLUSH_DELALLOC_FULL	= 7,
+	ALLOC_CHUNK		= 8,
+	ALLOC_CHUNK_FORCE	= 9,
+	RUN_DELAYED_IPUTS	= 10,
+	COMMIT_TRANS		= 11,
+};
+
 struct btrfs_space_info {
 	spinlock_t lock;
 
-- 
2.51.0



