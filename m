Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01800101DE;
	Thu,  3 Jul 2025 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554135; cv=none; b=IHNTUdP7vTg5WZ3Fgn8NmGbMxT6qCNr/mGLOMfSWwhULsR83qlxDj8EYiakg8TypdWGHSDHCdN4ssocjZLIUXp/O40bihXtjc2krm9QIHE7jx/yQiwzRb39eG0qkp1MqQFZ+lw6KRw/vo12etlqpnaTvOs9wzzd8MB9diodNqJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554135; c=relaxed/simple;
	bh=Q0Qtm0RRwkuAJAYo3dsx8j/l4l8Q2vCOKrboWsu9268=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEE7L5zjC9YI21WKmlMpP83KEEQa06ny/gesJ+pZ33KOLu/mmv4W5uUXE0L9AQxanGU5vX4t5at8XZTzo5zRWxOlJYIH7/UrzQQmEMGZQNrz0GI+IH2hdkYNO9VEvkqw4+WRh800HYEiPt7tAvAPZCdIPGR8deL1FzjTO4ier/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9VRrFMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9VRrFMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34653C4CEE3;
	Thu,  3 Jul 2025 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554134;
	bh=Q0Qtm0RRwkuAJAYo3dsx8j/l4l8Q2vCOKrboWsu9268=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9VRrFMxufus5B+tSjMuR96brQ1v4YvPH7EnqVBwMUD6SuXgnRhJIrXzynzNXhAsA
	 VxEv+9eEbvBZjkqjbmGANW8TPVdYwjFtPDqdieJJSeFhFShDO3pVlfOked1AWCYJ0w
	 5vvJYRy07t06CjHd1ZAPmIk/W+YSqPlMwgcnmJTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/218] btrfs: use unsigned types for constants defined as bit shifts
Date: Thu,  3 Jul 2025 16:40:09 +0200
Message-ID: <20250703143958.382748692@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 05a6ec865d091fe8244657df8063f74e704d1711 ]

The unsigned type is a recommended practice (CWE-190, CWE-194) for bit
shifts to avoid problems with potential unwanted sign extensions.
Although there are no such cases in btrfs codebase, follow the
recommendation.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1f2889f5594a ("btrfs: fix qgroup reservation leak on failure to allocate ordered extent")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.h               |  4 ++--
 fs/btrfs/direct-io.c             |  4 ++--
 fs/btrfs/extent_io.h             |  2 +-
 fs/btrfs/inode.c                 | 12 ++++++------
 fs/btrfs/ordered-data.c          |  4 ++--
 fs/btrfs/raid56.c                |  5 ++---
 fs/btrfs/tests/extent-io-tests.c |  6 +++---
 fs/btrfs/zstd.c                  |  2 +-
 8 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index e8c22cccb5c13..7dfcc9351bce5 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -427,8 +427,8 @@ struct btrfs_backref_node *btrfs_backref_alloc_node(
 struct btrfs_backref_edge *btrfs_backref_alloc_edge(
 		struct btrfs_backref_cache *cache);
 
-#define		LINK_LOWER	(1 << 0)
-#define		LINK_UPPER	(1 << 1)
+#define		LINK_LOWER	(1U << 0)
+#define		LINK_UPPER	(1U << 1)
 
 void btrfs_backref_link_edge(struct btrfs_backref_edge *edge,
 			     struct btrfs_backref_node *lower,
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index bd38df5647e35..71984d7db839b 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -151,8 +151,8 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 	}
 
 	ordered = btrfs_alloc_ordered_extent(inode, start, file_extent,
-					     (1 << type) |
-					     (1 << BTRFS_ORDERED_DIRECT));
+					     (1U << type) |
+					     (1U << BTRFS_ORDERED_DIRECT));
 	if (IS_ERR(ordered)) {
 		if (em) {
 			free_extent_map(em);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index fcb60837d7dc6..039a73731135a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -79,7 +79,7 @@ enum {
  *    single word in a bitmap may straddle two pages in the extent buffer.
  */
 #define BIT_BYTE(nr) ((nr) / BITS_PER_BYTE)
-#define BYTE_MASK ((1 << BITS_PER_BYTE) - 1)
+#define BYTE_MASK ((1U << BITS_PER_BYTE) - 1)
 #define BITMAP_FIRST_BYTE_MASK(start) \
 	((BYTE_MASK << ((start) & (BITS_PER_BYTE - 1))) & BYTE_MASK)
 #define BITMAP_LAST_BYTE_MASK(nbits) \
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 65517efd3433e..94664c1822930 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1249,7 +1249,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 	free_extent_map(em);
 
 	ordered = btrfs_alloc_ordered_extent(inode, start, &file_extent,
-					     1 << BTRFS_ORDERED_COMPRESSED);
+					     1U << BTRFS_ORDERED_COMPRESSED);
 	if (IS_ERR(ordered)) {
 		btrfs_drop_extent_map_range(inode, start, end, false);
 		ret = PTR_ERR(ordered);
@@ -1484,7 +1484,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 		free_extent_map(em);
 
 		ordered = btrfs_alloc_ordered_extent(inode, start, &file_extent,
-						     1 << BTRFS_ORDERED_REGULAR);
+						     1U << BTRFS_ORDERED_REGULAR);
 		if (IS_ERR(ordered)) {
 			unlock_extent(&inode->io_tree, start,
 				      start + ram_size - 1, &cached);
@@ -2081,8 +2081,8 @@ static int nocow_one_range(struct btrfs_inode *inode, struct folio *locked_folio
 
 	ordered = btrfs_alloc_ordered_extent(inode, file_pos, &nocow_args->file_extent,
 					     is_prealloc
-					     ? (1 << BTRFS_ORDERED_PREALLOC)
-					     : (1 << BTRFS_ORDERED_NOCOW));
+					     ? (1U << BTRFS_ORDERED_PREALLOC)
+					     : (1U << BTRFS_ORDERED_NOCOW));
 	if (IS_ERR(ordered)) {
 		if (is_prealloc)
 			btrfs_drop_extent_map_range(inode, file_pos, end, false);
@@ -9683,8 +9683,8 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	free_extent_map(em);
 
 	ordered = btrfs_alloc_ordered_extent(inode, start, &file_extent,
-				       (1 << BTRFS_ORDERED_ENCODED) |
-				       (1 << BTRFS_ORDERED_COMPRESSED));
+				       (1U << BTRFS_ORDERED_ENCODED) |
+				       (1U << BTRFS_ORDERED_COMPRESSED));
 	if (IS_ERR(ordered)) {
 		btrfs_drop_extent_map_range(inode, start, end, false);
 		ret = PTR_ERR(ordered);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 4ed11b089ea95..7baee52cac184 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -155,7 +155,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	u64 qgroup_rsv = 0;
 
 	if (flags &
-	    ((1 << BTRFS_ORDERED_NOCOW) | (1 << BTRFS_ORDERED_PREALLOC))) {
+	    ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC))) {
 		/* For nocow write, we can release the qgroup rsv right now */
 		ret = btrfs_qgroup_free_data(inode, NULL, file_offset, num_bytes, &qgroup_rsv);
 		if (ret < 0)
@@ -253,7 +253,7 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
  * @disk_bytenr:     Offset of extent on disk.
  * @disk_num_bytes:  Size of extent on disk.
  * @offset:          Offset into unencoded data where file data starts.
- * @flags:           Flags specifying type of extent (1 << BTRFS_ORDERED_*).
+ * @flags:           Flags specifying type of extent (1U << BTRFS_ORDERED_*).
  * @compress_type:   Compression algorithm used for data.
  *
  * Most of these parameters correspond to &struct btrfs_file_extent_item. The
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 39bec672df0cc..8afadf994b8c8 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -200,8 +200,7 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
 	struct btrfs_stripe_hash_table *x;
 	struct btrfs_stripe_hash *cur;
 	struct btrfs_stripe_hash *h;
-	int num_entries = 1 << BTRFS_STRIPE_HASH_TABLE_BITS;
-	int i;
+	unsigned int num_entries = 1U << BTRFS_STRIPE_HASH_TABLE_BITS;
 
 	if (info->stripe_hash_table)
 		return 0;
@@ -222,7 +221,7 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
 
 	h = table->table;
 
-	for (i = 0; i < num_entries; i++) {
+	for (unsigned int i = 0; i < num_entries; i++) {
 		cur = h + i;
 		INIT_LIST_HEAD(&cur->hash_list);
 		spin_lock_init(&cur->lock);
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 0a2dbfaaf49e2..de226209220fe 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -14,9 +14,9 @@
 #include "../disk-io.h"
 #include "../btrfs_inode.h"
 
-#define PROCESS_UNLOCK		(1 << 0)
-#define PROCESS_RELEASE		(1 << 1)
-#define PROCESS_TEST_LOCKED	(1 << 2)
+#define PROCESS_UNLOCK		(1U << 0)
+#define PROCESS_RELEASE		(1U << 1)
+#define PROCESS_TEST_LOCKED	(1U << 2)
 
 static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
 				       unsigned long flags)
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 866607fd3e588..c9ea37fabf659 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -24,7 +24,7 @@
 #include "super.h"
 
 #define ZSTD_BTRFS_MAX_WINDOWLOG 17
-#define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
+#define ZSTD_BTRFS_MAX_INPUT (1U << ZSTD_BTRFS_MAX_WINDOWLOG)
 #define ZSTD_BTRFS_DEFAULT_LEVEL 3
 #define ZSTD_BTRFS_MAX_LEVEL 15
 /* 307s to avoid pathologically clashing with transaction commit */
-- 
2.39.5



