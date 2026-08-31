Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C604478E47;
	Mon, 31 Aug 2026 13:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184515; cv=none; b=bfLhYzMH5odKiOc3G6K6IGE07trKR6U2C8supEC6JRQFkzNZR9+vgDmshOHRFWLSj+Hs6C0Th9DVkaMMj+OKBf8stcHDOVFQr+9D+LyuzrodkpHFT+zu9Mj5WoZ3mVb4X086mPXY1pc2CK4ik9J/wUarvXUzkpK9CBlRURP7X/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184515; c=relaxed/simple;
	bh=PiTboCl1U4nNqC5Q96JwcWVz1UIDV4lr++j7r2xMZWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwRJuQIYIu0RigtdAeFLXMmBfWc51IEw7fK/bTBE/PEcspEd5mw6CTZL7tuELmCIWlYoZDDLJH8pq20N/9UUl2F40SJ/DuBS/oXuj5WV0E45KrU+MkECoY1J6EfhgwJIyxu7pl5bTRnyoN31yZc3ylkh/ftjYApGYaff5fDZy84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1fHpi1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1fHpi1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AD71F000E9;
	Mon, 31 Aug 2026 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184513;
	bh=reWWljgqBputjdP8hYp8ukArv36IrWP2ceUB1HqeWbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1fHpi1AJRCSj9/M/Lzt0W1NmrX3PfJX3cgorCqwNhN0OQVzmoTbMmkGSwYZKEpPu
	 dGt0eqkfMYQGl6l24AeQ4VB4VKnyVKgr2mq02s26VlRqfqeFDsci17olOs0IH84fmV
	 pArJ3ewlIPuWVSvR73cB6UmhU8OCwnaplbJzhYAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 35/91] ext4: make state in ext4_mb_mark_bb to be bool
Date: Mon, 31 Aug 2026 15:34:23 +0200
Message-ID: <20260831133401.554671128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit d2f7cf40ea89b486fb7a25f5ab9a5d3ce26fb4bb ]

As state could only be either 0 or 1, just make it bool.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230928160407.142069-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d8b8dd3530bf ("ext4: propagate errors from fast commit range replay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h        |    2 +-
 fs/ext4/extents.c     |    4 ++--
 fs/ext4/fast_commit.c |    8 ++++----
 fs/ext4/mballoc.c     |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2940,7 +2940,7 @@ extern int ext4_group_add_blocks(handle_
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
 extern void ext4_process_freed_data(struct super_block *sb, tid_t commit_tid);
 extern void ext4_mb_mark_bb(struct super_block *sb, ext4_fsblk_t block,
-		       int len, int state);
+			    int len, bool state);
 static inline bool ext4_mb_cr_expensive(enum criteria cr)
 {
 	return cr >= CR_GOAL_LEN_SLOW;
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -6207,13 +6207,13 @@ int ext4_ext_clear_bb(struct inode *inod
 				for (j = 0; j < path->p_depth; j++) {
 
 					ext4_mb_mark_bb(inode->i_sb,
-							path[j].p_block, 1, 0);
+							path[j].p_block, 1, false);
 					ext4_fc_record_regions(inode->i_sb, inode->i_ino,
 							0, path[j].p_block, 1, 1);
 				}
 				ext4_free_ext_path(path);
 			}
-			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, 0);
+			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, false);
 			ext4_fc_record_regions(inode->i_sb, inode->i_ino,
 					map.m_lblk, map.m_pblk, map.m_len, 1);
 		}
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1838,7 +1838,7 @@ static int ext4_fc_replay_add_range(stru
 			 * at the end of the FC replay using our array of
 			 * modified inodes.
 			 */
-			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, 0);
+			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, false);
 			goto next;
 		}
 
@@ -1907,7 +1907,7 @@ ext4_fc_replay_del_range(struct super_bl
 		if (ret > 0) {
 			remaining -= ret;
 			cur += ret;
-			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, 0);
+			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, false);
 		} else {
 			remaining -= map.m_len;
 			cur += map.m_len;
@@ -1966,12 +1966,12 @@ static void ext4_fc_set_bitmaps_and_coun
 				if (!IS_ERR(path)) {
 					for (j = 0; j < path->p_depth; j++)
 						ext4_mb_mark_bb(inode->i_sb,
-							path[j].p_block, 1, 1);
+							path[j].p_block, 1, true);
 					ext4_free_ext_path(path);
 				}
 				cur += ret;
 				ext4_mb_mark_bb(inode->i_sb, map.m_pblk,
-							map.m_len, 1);
+							map.m_len, true);
 			} else {
 				cur = cur + (map.m_len ? map.m_len : 1);
 			}
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4121,7 +4121,7 @@ out_err:
  * blocks in bitmaps and update counters.
  */
 void ext4_mb_mark_bb(struct super_block *sb, ext4_fsblk_t block,
-			int len, int state)
+		     int len, bool state)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_group_desc *gdp;
@@ -6158,7 +6158,7 @@ ext4_mb_new_blocks_simple(struct ext4_al
 	}
 
 	block = ext4_group_first_block_no(sb, group) + EXT4_C2B(sbi, i);
-	ext4_mb_mark_bb(sb, block, 1, 1);
+	ext4_mb_mark_bb(sb, block, 1, true);
 	ar->len = 1;
 
 	*errp = 0;


