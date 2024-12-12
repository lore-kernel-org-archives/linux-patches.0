Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF3513CA93;
	Thu, 12 Dec 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024139; cv=none; b=gB+G58k3+s0ByeKtVRSrRozk/cp6kr2nXMguo4z8Wwt7GHUScJBQPlwsePStegBvlvQfoMl7flyJhM91AXLlOusuKP4GQ7ujZmR3OFuF1m9jEKTzw5fiknNgthLDeL+rFLlKYh6xPANSs/iLIjf0aa4ZJACecPzI0IXDcK/bCQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024139; c=relaxed/simple;
	bh=vVeB7miqlCkwI5SI1C9yJWVAtp3glL5+TJAWM+tWv94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwgBW4zYFt8J5NY83tD0hrk38kys5TPqwuWvdrWUX5oKSOMBW7Js/8LoyBQl5XGcRz6cAq3nY5/uBGwQRZHN9+OPTL8NtNPsFEpQ2rQpHVmCOpvq1CIo6pn3BHgDtn6jmcn60H0PzMFerCKY+9Px9OEA9v1YHSKnLBjD52d1X54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaQO3u1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaQO3u1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A5AC4CECE;
	Thu, 12 Dec 2024 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024139;
	bh=vVeB7miqlCkwI5SI1C9yJWVAtp3glL5+TJAWM+tWv94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaQO3u1/yBI8v6w6HfB/2sIgu/CNAYwxnAo55c1KnmoyEPGrft6L5Lls8AJxmvpnP
	 Bif7yjlzQ1WPuPo3bRG0XY7bNMShrdFU0URSUYkdnn+XXIYmIE88rfnLv0gfNYnxAk
	 6NkQ/rRqG4lhHUQiefIALr7XfkA2nciBePlUFwF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/459] f2fs: remove the unused flush argument to change_curseg
Date: Thu, 12 Dec 2024 15:58:57 +0100
Message-ID: <20241212144301.429020137@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
index 7d6f2ee2f0177..d99c9e6a0b3e4 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2683,7 +2683,7 @@ bool f2fs_segment_has_free_slot(struct f2fs_sb_info *sbi, int segno)
  * This function always allocates a used segment(from dirty seglist) by SSR
  * manner, so it should recover the existing segment information of valid blocks
  */
-static void change_curseg(struct f2fs_sb_info *sbi, int type, bool flush)
+static void change_curseg(struct f2fs_sb_info *sbi, int type)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
@@ -2691,9 +2691,7 @@ static void change_curseg(struct f2fs_sb_info *sbi, int type, bool flush)
 	struct f2fs_summary_block *sum_node;
 	struct page *sum_page;
 
-	if (flush)
-		write_sum_page(sbi, curseg->sum_blk,
-					GET_SUM_BLOCK(sbi, curseg->segno));
+	write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
 
 	__set_test_and_inuse(sbi, new_segno);
 
@@ -2732,7 +2730,7 @@ static void get_atssr_segment(struct f2fs_sb_info *sbi, int type,
 		struct seg_entry *se = get_seg_entry(sbi, curseg->next_segno);
 
 		curseg->seg_type = se->type;
-		change_curseg(sbi, type, true);
+		change_curseg(sbi, type);
 	} else {
 		/* allocate cold segment by default */
 		curseg->seg_type = CURSEG_COLD_DATA;
@@ -2907,7 +2905,7 @@ void f2fs_allocate_segment_for_resize(struct f2fs_sb_info *sbi, int type,
 		goto unlock;
 
 	if (f2fs_need_SSR(sbi) && get_ssr_segment(sbi, type, SSR, 0))
-		change_curseg(sbi, type, true);
+		change_curseg(sbi, type);
 	else
 		new_curseg(sbi, type, true);
 
@@ -3393,7 +3391,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 			if (need_new_seg(sbi, type))
 				new_curseg(sbi, type, false);
 			else
-				change_curseg(sbi, type, true);
+				change_curseg(sbi, type);
 			stat_inc_seg_type(sbi, curseg);
 		}
 	}
@@ -3624,7 +3622,7 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	/* change the current segment */
 	if (segno != curseg->segno) {
 		curseg->next_segno = segno;
-		change_curseg(sbi, type, true);
+		change_curseg(sbi, type);
 	}
 
 	curseg->next_blkoff = GET_BLKOFF_FROM_SEG0(sbi, new_blkaddr);
@@ -3651,7 +3649,7 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	if (recover_curseg) {
 		if (old_cursegno != curseg->segno) {
 			curseg->next_segno = old_cursegno;
-			change_curseg(sbi, type, true);
+			change_curseg(sbi, type);
 		}
 		curseg->next_blkoff = old_blkoff;
 	}
-- 
2.43.0



