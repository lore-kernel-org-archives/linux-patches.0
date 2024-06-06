Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1911B1432;
	Thu,  6 Jun 2024 14:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683381; cv=none; b=M/S0IHNZk0Zr4FHq4pfsGcFUdutSUarxns3aAhbrbQgUaCZGIVDeCix+e9gG+BkT9+4UDfmVeB4bPLrsWUwRnPtm3OZ72Z1i3qTG6DQcbmcM/hgi/OVzY+6pFsdNQRMmP0+1UdVKDyKwC8QXFfv6JOGATASPFHRRTKhK73D7NuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683381; c=relaxed/simple;
	bh=1GrK1BZSm6tgj8cxlbRwa/0XajewwtEVV/kQNw0TdVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3GZcM3A58mkSeFG58nOU8IGFpr1yODuuSGX64ZtVaPqudweRYMvUnLgMUI0yVYWB+52wPscl2/KXzI77Psz77W+h+iZGaHrOAhOd92Y9GpW4mkW3prLG2+dQGZY5EXUxumnvWglbWq4S+R1EAAPxWs0ueHU1/t/OwSpOSzF9MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSCSZ+PZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSCSZ+PZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210FCC32781;
	Thu,  6 Jun 2024 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683381;
	bh=1GrK1BZSm6tgj8cxlbRwa/0XajewwtEVV/kQNw0TdVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSCSZ+PZDxM9i3m8GE8xcN155YRL99kMzDTH2yakw4DOk4RAYzizlbxTeWNXv2f3S
	 1AFruuzMvyW/SXdPQmKR5WGiY8+Lyay0UYC5s1KFh4pmiwGqO2deix6lVhfMXTOJaI
	 IaXB+DhOK6y81dKM17qqo++V1lCh9xhZFbQ7c5jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 264/473] ext4: remove unused parameter from ext4_mb_new_blocks_simple()
Date: Thu,  6 Jun 2024 16:03:13 +0200
Message-ID: <20240606131708.670674267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a7801d2a7d1b4..97f4563a97c8e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5608,8 +5608,72 @@ static bool ext4_mb_discard_preallocations_should_retry(struct super_block *sb,
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
@@ -5634,7 +5698,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 
 	trace_ext4_request_blocks(ar);
 	if (sbi->s_mount_state & EXT4_FC_REPLAY)
-		return ext4_mb_new_blocks_simple(handle, ar, errp);
+		return ext4_mb_new_blocks_simple(ar, errp);
 
 	/* Allow to use superuser reservation for quota file */
 	if (ext4_is_quota_file(ar->inode))
@@ -5864,73 +5928,6 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
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



