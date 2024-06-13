Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FFD6EB56;
	Thu, 13 Jun 2024 12:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281054; cv=none; b=dUxqZ0qRU3CXZaKirAqFsA/Aa6cyHcWV8FR4aYaPNJmud4d0cWgKHKXTSbjcFxJvEMb8bSZr1WQylkFpkNfqurLWvbqFnHQslBXqKwcQcxUouHrFWLmu7kjFfKFxBX6BxEh6bvBzlJHe7Eri/59KBmhKFQ7A4DfOSWUKEcXkqOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281054; c=relaxed/simple;
	bh=tfxXhEHshPOfSWOCeHL5slv7KCzDPJP5KGRvTFyRva8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdfD1zXQ3GHAeMOZb6e4V2o05IBORntebZZXuGWYHtN40XPjSm/z9YLtotzQKq1EPOYGaWiAGFeaqBfuqqOScAnnNmEwepkvcoynJT6OeGaqgWGN9iuCzkQxQ8Lr3EZOm72iA7xaK0p1+A3ewgcDu4nh22Q49UjNWUdmVrTdm2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ueo5CWuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ueo5CWuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DB7C2BBFC;
	Thu, 13 Jun 2024 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281054;
	bh=tfxXhEHshPOfSWOCeHL5slv7KCzDPJP5KGRvTFyRva8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ueo5CWuuT97XyCvnSioqRvYIqY+QOnZqyvM/Emn/i0M8FAnV3mzBP5HQ9g68w8hea
	 GWcBYdIuUfubDRlMJ/Pov65Eq+2C4KyvScNWEMEvvVU3NqBrijeMOtLINl6P/LiP0U
	 WVtP4LBc+NFbuj6BPNGqolf8s6fnZdQpJ572PmSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/317] ext4: remove unused parameter from ext4_mb_new_blocks_simple()
Date: Thu, 13 Jun 2024 13:32:22 +0200
Message-ID: <20240613113252.347724693@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit ad78b5efe4246e5deba8d44a6ed172b8a00d3113 ]

Two cleanups for ext4_mb_new_blocks_simple:
Remove unused parameter handle of ext4_mb_new_blocks_simple.
Move ext4_mb_new_blocks_simple definition before ext4_mb_new_blocks to
remove unnecessary forward declaration of ext4_mb_new_blocks_simple.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-10-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 3f4830abd236 ("ext4: fix potential unnitialized variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 137 +++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 70 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index de69929495a5a..099007ec774c7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5083,8 +5083,72 @@ static bool ext4_mb_discard_preallocations_should_retry(struct super_block *sb,
 	return ret;
 }
 
-static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
-				struct ext4_allocation_request *ar, int *errp);
+/*
+ * Simple allocator for Ext4 fast commit replay path. It searches for blocks
+ * linearly starting at the goal block and also excludes the blocks which
+ * are going to be in use after fast commit replay.
+ */
+static ext4_fsblk_t
+ext4_mb_new_blocks_simple(struct ext4_allocation_request *ar, int *errp)
+{
+	struct buffer_head *bitmap_bh;
+	struct super_block *sb = ar->inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_group_t group, nr;
+	ext4_grpblk_t blkoff;
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	ext4_grpblk_t i = 0;
+	ext4_fsblk_t goal, block;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+
+	goal = ar->goal;
+	if (goal < le32_to_cpu(es->s_first_data_block) ||
+			goal >= ext4_blocks_count(es))
+		goal = le32_to_cpu(es->s_first_data_block);
+
+	ar->len = 0;
+	ext4_get_group_no_and_offset(sb, goal, &group, &blkoff);
+	for (nr = ext4_get_groups_count(sb); nr > 0; nr--) {
+		bitmap_bh = ext4_read_block_bitmap(sb, group);
+		if (IS_ERR(bitmap_bh)) {
+			*errp = PTR_ERR(bitmap_bh);
+			pr_warn("Failed to read block bitmap\n");
+			return 0;
+		}
+
+		while (1) {
+			i = mb_find_next_zero_bit(bitmap_bh->b_data, max,
+						blkoff);
+			if (i >= max)
+				break;
+			if (ext4_fc_replay_check_excluded(sb,
+				ext4_group_first_block_no(sb, group) +
+				EXT4_C2B(sbi, i))) {
+				blkoff = i + 1;
+			} else
+				break;
+		}
+		brelse(bitmap_bh);
+		if (i < max)
+			break;
+
+		if (++group >= ext4_get_groups_count(sb))
+			group = 0;
+
+		blkoff = 0;
+	}
+
+	if (i >= max) {
+		*errp = -ENOSPC;
+		return 0;
+	}
+
+	block = ext4_group_first_block_no(sb, group) + EXT4_C2B(sbi, i);
+	ext4_mb_mark_bb(sb, block, 1, 1);
+	ar->len = 1;
+
+	return block;
+}
 
 /*
  * Main entry point into mballoc to allocate blocks
@@ -5109,7 +5173,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 
 	trace_ext4_request_blocks(ar);
 	if (sbi->s_mount_state & EXT4_FC_REPLAY)
-		return ext4_mb_new_blocks_simple(handle, ar, errp);
+		return ext4_mb_new_blocks_simple(ar, errp);
 
 	/* Allow to use superuser reservation for quota file */
 	if (ext4_is_quota_file(ar->inode))
@@ -5339,73 +5403,6 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	return 0;
 }
 
-/*
- * Simple allocator for Ext4 fast commit replay path. It searches for blocks
- * linearly starting at the goal block and also excludes the blocks which
- * are going to be in use after fast commit replay.
- */
-static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
-				struct ext4_allocation_request *ar, int *errp)
-{
-	struct buffer_head *bitmap_bh;
-	struct super_block *sb = ar->inode->i_sb;
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	ext4_group_t group, nr;
-	ext4_grpblk_t blkoff;
-	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
-	ext4_grpblk_t i = 0;
-	ext4_fsblk_t goal, block;
-	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-
-	goal = ar->goal;
-	if (goal < le32_to_cpu(es->s_first_data_block) ||
-			goal >= ext4_blocks_count(es))
-		goal = le32_to_cpu(es->s_first_data_block);
-
-	ar->len = 0;
-	ext4_get_group_no_and_offset(sb, goal, &group, &blkoff);
-	for (nr = ext4_get_groups_count(sb); nr > 0; nr--) {
-		bitmap_bh = ext4_read_block_bitmap(sb, group);
-		if (IS_ERR(bitmap_bh)) {
-			*errp = PTR_ERR(bitmap_bh);
-			pr_warn("Failed to read block bitmap\n");
-			return 0;
-		}
-
-		while (1) {
-			i = mb_find_next_zero_bit(bitmap_bh->b_data, max,
-						blkoff);
-			if (i >= max)
-				break;
-			if (ext4_fc_replay_check_excluded(sb,
-				ext4_group_first_block_no(sb, group) +
-				EXT4_C2B(sbi, i))) {
-				blkoff = i + 1;
-			} else
-				break;
-		}
-		brelse(bitmap_bh);
-		if (i < max)
-			break;
-
-		if (++group >= ext4_get_groups_count(sb))
-			group = 0;
-
-		blkoff = 0;
-	}
-
-	if (i >= max) {
-		*errp = -ENOSPC;
-		return 0;
-	}
-
-	block = ext4_group_first_block_no(sb, group) + EXT4_C2B(sbi, i);
-	ext4_mb_mark_bb(sb, block, 1, 1);
-	ar->len = 1;
-
-	return block;
-}
-
 static void ext4_free_blocks_simple(struct inode *inode, ext4_fsblk_t block,
 					unsigned long count)
 {
-- 
2.43.0



