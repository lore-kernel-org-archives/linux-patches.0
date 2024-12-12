Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B014C235C35;
	Thu, 12 Dec 2024 16:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019700; cv=none; b=dfqgj7caRS3AiHUfk8KR2NlWKdvKIH3/bogvQtmMh86WKOHTLSFmN/VZCgimxV2lKni682L3amQo/S0DZHkUAVmQdoC24InPWOuz2LtSuOr7EQjFiPduk26AYIHSMBdaZDYm0GgpWXa57CrXDyZSF1DT07tJshpPMjHlPCCWO4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019700; c=relaxed/simple;
	bh=BF1s25z8AUeULLNC6tTulsv8lt8N1bRDyGuJhTZFZ+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqFc7dHLTIVpqvxoRECS7lN75cYk5xeHcjkN3P1uNT2vjENOSceNJmryFx5G3vW3SnADUh7+EnErNIx0ReY9ObdeNyGPhP8Y3jwKBbHD9ii+z3b3L5O+F8FsmxoEZitcnK0fFd2x5iTIGFLVu25m6MOrdlsG43phlbQqglXiVHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjpXJY3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjpXJY3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990C2C4CECE;
	Thu, 12 Dec 2024 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019700;
	bh=BF1s25z8AUeULLNC6tTulsv8lt8N1bRDyGuJhTZFZ+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjpXJY3x+ap+RS7+IWWO3L9JnCOhJBpC8I+6nGTtWj9lPOdzQic96/1BE1E4SKNWn
	 NnjCEnm0/r+kySxq9w54Ggjnee+1oMIp5vYDVsnp3cz5lu+E6NsKC2DQAucS18HQKr
	 y8it5gghtJJ53uOwRY+tppe70wl5F0WMlFURDHaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 275/772] f2fs: remove the unused flush argument to change_curseg
Date: Thu, 12 Dec 2024 15:53:40 +0100
Message-ID: <20241212144401.272059707@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index a40322964c1e0..884b3d9d1de62 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2666,7 +2666,7 @@ bool f2fs_segment_has_free_slot(struct f2fs_sb_info *sbi, int segno)
  * This function always allocates a used segment(from dirty seglist) by SSR
  * manner, so it should recover the existing segment information of valid blocks
  */
-static void change_curseg(struct f2fs_sb_info *sbi, int type, bool flush)
+static void change_curseg(struct f2fs_sb_info *sbi, int type)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
@@ -2674,9 +2674,7 @@ static void change_curseg(struct f2fs_sb_info *sbi, int type, bool flush)
 	struct f2fs_summary_block *sum_node;
 	struct page *sum_page;
 
-	if (flush)
-		write_sum_page(sbi, curseg->sum_blk,
-					GET_SUM_BLOCK(sbi, curseg->segno));
+	write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
 
 	__set_test_and_inuse(sbi, new_segno);
 
@@ -2715,7 +2713,7 @@ static void get_atssr_segment(struct f2fs_sb_info *sbi, int type,
 		struct seg_entry *se = get_seg_entry(sbi, curseg->next_segno);
 
 		curseg->seg_type = se->type;
-		change_curseg(sbi, type, true);
+		change_curseg(sbi, type);
 	} else {
 		/* allocate cold segment by default */
 		curseg->seg_type = CURSEG_COLD_DATA;
@@ -2890,7 +2888,7 @@ void f2fs_allocate_segment_for_resize(struct f2fs_sb_info *sbi, int type,
 		goto unlock;
 
 	if (f2fs_need_SSR(sbi) && get_ssr_segment(sbi, type, SSR, 0))
-		change_curseg(sbi, type, true);
+		change_curseg(sbi, type);
 	else
 		new_curseg(sbi, type, true);
 
@@ -3287,7 +3285,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 			if (need_new_seg(sbi, type))
 				new_curseg(sbi, type, false);
 			else
-				change_curseg(sbi, type, true);
+				change_curseg(sbi, type);
 			stat_inc_seg_type(sbi, curseg);
 		}
 	}
@@ -3550,7 +3548,7 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	/* change the current segment */
 	if (segno != curseg->segno) {
 		curseg->next_segno = segno;
-		change_curseg(sbi, type, true);
+		change_curseg(sbi, type);
 	}
 
 	curseg->next_blkoff = GET_BLKOFF_FROM_SEG0(sbi, new_blkaddr);
@@ -3578,7 +3576,7 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
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



