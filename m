Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F8F2210E1;
	Thu, 12 Dec 2024 16:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022476; cv=none; b=qHKUhT49AcSsGImmMWb85wkF4VpG0orcEOZQJGILfinogJw3GFtmOTqrfIu7yfixO2wHlsAYTACQTC9ODeQHOPStOyXtszVHgF652pd2wXxFo6yhY1rypZHnxpl/6ss7uO6cAbYkEqhh/PzD3Qt8GKO/wjavH+lxXpxCRHWHPiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022476; c=relaxed/simple;
	bh=7YoHu6uG+3pEo01h6hUzvgLUzwFNi8J02Q9G1G3pQa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7H9xDfSNTVW3XVyR/hDnInUmOfSlpODSkckEslxM4BCUIixKXHvqMZ7yGWPyrHcgD6GJHPOEULtb1v8vCt/5u225Vc3GQ3rOO4wb3W6hNhyZwFrW/zi8EU8JXn5aVrdQ7kTuIxegTdbFReuky2EXx0XosQKHzlMH85gvDnKPLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZO+AZ85P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZO+AZ85P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23C1C4CED0;
	Thu, 12 Dec 2024 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022476;
	bh=7YoHu6uG+3pEo01h6hUzvgLUzwFNi8J02Q9G1G3pQa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZO+AZ85P/Inq8o6440Sm70ad8fjhKUv1uIwyFt8u2kp/lPLqDNMgHbgcYPTeyaIMY
	 CeVyygBysLXK3jZu3C18Tsm2ac+FtVzFH4y1ptgxAqre6faAKbRBuiAIypu3bPcysQ
	 wUE+H0yIsfbMZeI5OFBVbTr6VVUhPFC67FE5A8xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/565] f2fs: remove the unused flush argument to change_curseg
Date: Thu, 12 Dec 2024 15:57:25 +0100
Message-ID: <20241212144321.359157472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 5bcd655fffaec24e849bda1207446f5cc821713e ]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 43563069e1c1 ("f2fs: check curseg->inited before write_sum_page in change_curseg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index cb37c711b1f61..3e5900ddb92b0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2729,7 +2729,7 @@ bool f2fs_segment_has_free_slot(struct f2fs_sb_info *sbi, int segno)
  * This function always allocates a used segment(from dirty seglist) by SSR
  * manner, so it should recover the existing segment information of valid blocks
  */
-static void change_curseg(struct f2fs_sb_info *sbi, int type, bool flush)
+static void change_curseg(struct f2fs_sb_info *sbi, int type)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
@@ -2737,9 +2737,7 @@ static void change_curseg(struct f2fs_sb_info *sbi, int type, bool flush)
 	struct f2fs_summary_block *sum_node;
 	struct page *sum_page;
 
-	if (flush)
-		write_sum_page(sbi, curseg->sum_blk,
-					GET_SUM_BLOCK(sbi, curseg->segno));
+	write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
 
 	__set_test_and_inuse(sbi, new_segno);
 
@@ -2778,7 +2776,7 @@ static void get_atssr_segment(struct f2fs_sb_info *sbi, int type,
 		struct seg_entry *se = get_seg_entry(sbi, curseg->next_segno);
 
 		curseg->seg_type = se->type;
-		change_curseg(sbi, type, true);
+		change_curseg(sbi, type);
 	} else {
 		/* allocate cold segment by default */
 		curseg->seg_type = CURSEG_COLD_DATA;
@@ -2953,7 +2951,7 @@ void f2fs_allocate_segment_for_resize(struct f2fs_sb_info *sbi, int type,
 		goto unlock;
 
 	if (f2fs_need_SSR(sbi) && get_ssr_segment(sbi, type, SSR, 0))
-		change_curseg(sbi, type, true);
+		change_curseg(sbi, type);
 	else
 		new_curseg(sbi, type, true);
 
@@ -3444,7 +3442,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 			if (need_new_seg(sbi, type))
 				new_curseg(sbi, type, false);
 			else
-				change_curseg(sbi, type, true);
+				change_curseg(sbi, type);
 			stat_inc_seg_type(sbi, curseg);
 		}
 	}
@@ -3705,7 +3703,7 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	/* change the current segment */
 	if (segno != curseg->segno) {
 		curseg->next_segno = segno;
-		change_curseg(sbi, type, true);
+		change_curseg(sbi, type);
 	}
 
 	curseg->next_blkoff = GET_BLKOFF_FROM_SEG0(sbi, new_blkaddr);
@@ -3733,7 +3731,7 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	if (recover_curseg) {
 		if (old_cursegno != curseg->segno) {
 			curseg->next_segno = old_cursegno;
-			change_curseg(sbi, type, true);
+			change_curseg(sbi, type);
 		}
 		curseg->next_blkoff = old_blkoff;
 		curseg->alloc_type = old_alloc_type;
-- 
2.43.0



