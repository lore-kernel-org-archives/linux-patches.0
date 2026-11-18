Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032241;
	b=tsMABKYO/tj4tqLZ2VIFhXJac52hpsrdHyFWEfNxQsUVtODJRrVpUGW+5gHWEHNbVnU5
	 NPsgYiomp+kOYMIwU3Fc8UoMUou7IZJejiXfcoSmDk2HVlvUsaIiwx1WeJAPjzNQr941t
	 4pUM1pFh7IMg4hqS+T26LwlNzg4DRNUsuw+SEkEC7zORbsauawV9vWFh+X6Dz4b6aMW8E
	 j5G6I1tSDlFK2iPNKq4TeVVrfwJiBzmcSp/H7Z/BuxgnIWsZ/NMZnL2OHX64rYvv6K2wG
	 zCV/iSOjx7DC3pb7rIfgXKyiHr5grfueWbhgNJf716Jq9rdZDgIdtUunhOL3sdspPRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=18xlYOrhudUEq4B5dgFAn/FT1pM6VzFW6ccwivmUo0c=;
	b=X5He5GMzUAv8ceUOrl0MhD0akDWFnTT/1WI6F4HQji1wPAgoXkOmWMyPT8pInH6G3j3o
	 IW6Nl+oMk1P/KsnG1sorlq+5VHMJ8WWkt4A9tgarpYwNcbrYQXOfH84Z+tHEthd62wBwS
	 fT1d9ZdHVJwp1thEkD1fat6DwZXhI4TKbpGk142gN/qEOv9L++DwNXUlvGRRwyhvbHQxW
	 4YLXKQffyHxDFMFonXMZB2R+EcgHjRQunYHYHG/UAD0dqktDno5dttlVcp2jgB7FXIXuK
	 VKCL06ZinJ6uN68uLkaYOoukMQm0WgIX3k6KY1nviDq+8iVkkW60Ut7HXJ8LMRZj26g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kQ1BTqp9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C589606A320;
	Wed, 18 Nov 2026 20:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kQ1BTqp9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DBD1F000C5;
	Wed, 18 Nov 2026 20:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032241;
	bh=18xlYOrhudUEq4B5dgFAn/FT1pM6VzFW6ccwivmUo0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQ1BTqp9YbsvbdAI7w9u02K8QKksM4y5KsHgHwsSqSwfbcMqAsqGtMveVs+Qgpq4D
	 giRVfzWbPymL2D7vT388r0rfL7yN3ICDh03inzGrKPYGGrVlDyaUWTm3DXotv/J4qP
	 X7u/WnycJ2Aqx9w33b5xESA550D9v3I6ZmTdKraM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1343/1756] btrfs: remove leftover EXTENT_UPTODATE clear from an inodes io_tree
Date: Wed, 18 Nov 2026 15:57:50 +0100
Message-ID: <20261118150102.802098126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit d2c41835fd284b73d61239ff5d637167f2563895 ]

After commit 52b029f42751 ("btrfs: remove unnecessary EXTENT_UPTODATE
state in buffered I/O path") we never set EXTENT_UPTODATE in an inode's
io_tree anymore, but we still have some code attempting to clear that
bit from an inode's io_tree. Remove that code as it doesn't do anything
anymore. The sole use of the EXTENT_UPTODATE bit is for the excluded
extents io_tree (fs_info->excluded_extents), which is used to track the
locations of super blocks, so that their ranges are never marked as free,
making them unavailable for extent allocation.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: bca2cf55a733 ("btrfs: drop the extent maps of the written part of a failed ordered extent")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-io-tree.h    |  7 -------
 fs/btrfs/inode.c             | 22 ++++++++++------------
 fs/btrfs/relocation.c        |  3 ---
 fs/btrfs/tests/inode-tests.c | 12 ++++--------
 4 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.h b/fs/btrfs/extent-io-tree.h
index 3553bcf822e9f..e17243c637171 100644
--- a/fs/btrfs/extent-io-tree.h
+++ b/fs/btrfs/extent-io-tree.h
@@ -196,13 +196,6 @@ int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   u32 bits, struct extent_state **cached_state);
 
-static inline int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
-		u64 end, struct extent_state **cached_state)
-{
-	return __clear_extent_bit(tree, start, end, EXTENT_UPTODATE,
-				  cached_state, NULL);
-}
-
 static inline int clear_extent_dirty(struct extent_io_tree *tree, u64 start,
 				     u64 end, struct extent_state **cached)
 {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e4d0f87344fab..ff7dd3f16f4fc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3177,8 +3177,6 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		btrfs_end_transaction(trans);
 
 	if (ret || truncated) {
-		u64 unwritten_start = start;
-
 		/*
 		 * If we failed to finish this ordered extent for any reason we
 		 * need to make sure BTRFS_ORDERED_IOERR is set on the ordered
@@ -3190,10 +3188,6 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		if (ret)
 			btrfs_mark_ordered_extent_error(ordered_extent);
 
-		if (truncated)
-			unwritten_start += logical_len;
-		clear_extent_uptodate(io_tree, unwritten_start, end, NULL);
-
 		/*
 		 * Drop extent maps for the part of the extent we didn't write.
 		 *
@@ -3208,9 +3202,15 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		 * we don't mess with the extent map tree in the NOCOW case, but
 		 * for now simply skip this if we are the free space inode.
 		 */
-		if (!btrfs_is_free_space_inode(inode))
+		if (!btrfs_is_free_space_inode(inode)) {
+			u64 unwritten_start = start;
+
+			if (truncated)
+				unwritten_start += logical_len;
+
 			btrfs_drop_extent_map_range(inode, unwritten_start,
 						    end, false);
+		}
 
 		/*
 		 * If the ordered extent had an IOERR or something else went
@@ -7419,12 +7419,10 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 		 *    Since the IO will never happen for this page.
 		 */
 		btrfs_qgroup_free_data(inode, NULL, cur, range_end + 1 - cur, NULL);
-		if (!inode_evicting) {
+		if (!inode_evicting)
 			clear_extent_bit(tree, cur, range_end, EXTENT_LOCKED |
-				 EXTENT_DELALLOC | EXTENT_UPTODATE |
-				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG |
-				 extra_flags, &cached_state);
-		}
+					 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
+					 EXTENT_DEFRAG | extra_flags, &cached_state);
 		cur = range_end + 1;
 	}
 	/*
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 7d0d3279231e2..bdca67a2befc1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2828,9 +2828,6 @@ static noinline_for_stack int prealloc_file_extent_cluster(struct reloc_control
 		if (ret < 0)
 			return ret;
 
-		clear_extent_bits(&inode->io_tree, i_size,
-				  round_up(i_size, PAGE_SIZE) - 1,
-				  EXTENT_UPTODATE);
 		folio = filemap_lock_folio(mapping, i_size >> PAGE_SHIFT);
 		/*
 		 * If page is freed we don't need to do anything then, as we
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index c21536161c436..cdc1c85d59074 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -953,8 +953,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
 			       BTRFS_MAX_EXTENT_SIZE >> 1,
 			       (BTRFS_MAX_EXTENT_SIZE >> 1) + sectorsize - 1,
-			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
-			       EXTENT_UPTODATE, NULL);
+			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW, NULL);
 	if (ret) {
 		test_err("clear_extent_bit returned %d", ret);
 		goto out;
@@ -1021,8 +1020,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
 			       BTRFS_MAX_EXTENT_SIZE + sectorsize,
 			       BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1,
-			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
-			       EXTENT_UPTODATE, NULL);
+			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW, NULL);
 	if (ret) {
 		test_err("clear_extent_bit returned %d", ret);
 		goto out;
@@ -1054,8 +1052,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 
 	/* Empty */
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
-			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
-			       EXTENT_UPTODATE, NULL);
+			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW, NULL);
 	if (ret) {
 		test_err("clear_extent_bit returned %d", ret);
 		goto out;
@@ -1070,8 +1067,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 out:
 	if (ret)
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
-				 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
-				 EXTENT_UPTODATE, NULL);
+				 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW, NULL);
 	iput(inode);
 	btrfs_free_dummy_root(root);
 	btrfs_free_dummy_fs_info(fs_info);
-- 
2.53.0



