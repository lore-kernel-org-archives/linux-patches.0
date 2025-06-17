Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507872ED15A;
	Tue, 17 Jun 2025 16:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176368; cv=none; b=YqxSpCNm0Wdo8GuwAsAXW5+ZN4mjHL7FuWsKCh34/j+Za9ORh+GRziXsfRgzUwTpp3n0FNaiJK2GWd8WcCMvYhWrAQ5ugRGlN7JUsr/kdCzBQaU5Uzr4UdaYuqkL2BeRbslGMoBYFOQT0Bqffey5nG8qCFYD89O6Qn+oVQ/v+xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176368; c=relaxed/simple;
	bh=dh4wnlTk2J/ifs9Am9vW3XLjMj5kBIuI+ChDPWS4XLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cv0Ss4b6uILeNnErBDuBCHs+rv42MBnIADxG3eArdOmrj9/iiczCxd8MwQW9d7i+XhuC5oXM2rNYw6nrLk5qTlgVKDVJ0H7uP/VgqLWNyOOZv/ayxSw+HtKwf1mTjShOeqnub7omw12PJQcrbmifodNhnZlaDng+cOYKwt/Jstg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIN42yUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIN42yUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71949C4CEE3;
	Tue, 17 Jun 2025 16:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176367;
	bh=dh4wnlTk2J/ifs9Am9vW3XLjMj5kBIuI+ChDPWS4XLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIN42yUSZ8b9x94WAdsg9QsTwqmpEDd6Q0RzOUOaoj2qnkuQUrYTjCsnkeERKUlQ4
	 xTjes34gu50oHKrcAY2UWL7mYhOdiooqiJI2SQJBZd4/VJ1ZtsdG5wGoEeZwJQNUvn
	 FjIsL5OgK3tngT7WmRcOi8KIL5mLKSVbFz+ImCCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 182/780] f2fs: clean up unnecessary indentation
Date: Tue, 17 Jun 2025 17:18:10 +0200
Message-ID: <20250617152458.882662533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 05d3273ad03fa5ea1177b4f3dfeeb6de4899b504 ]

No functional change.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: d26fecb03e1f ("f2fs: prevent the current section from being selected as a victim during GC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 0465dc00b349d..5fcb1f92d506f 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -429,7 +429,6 @@ static inline void __set_free(struct f2fs_sb_info *sbi, unsigned int segno)
 	unsigned int secno = GET_SEC_FROM_SEG(sbi, segno);
 	unsigned int start_segno = GET_SEG_FROM_SEC(sbi, secno);
 	unsigned int next;
-	unsigned int usable_segs = f2fs_usable_segs_in_sec(sbi);
 
 	spin_lock(&free_i->segmap_lock);
 	clear_bit(segno, free_i->free_segmap);
@@ -437,7 +436,7 @@ static inline void __set_free(struct f2fs_sb_info *sbi, unsigned int segno)
 
 	next = find_next_bit(free_i->free_segmap,
 			start_segno + SEGS_PER_SEC(sbi), start_segno);
-	if (next >= start_segno + usable_segs) {
+	if (next >= start_segno + f2fs_usable_segs_in_sec(sbi)) {
 		clear_bit(secno, free_i->free_secmap);
 		free_i->free_sections++;
 	}
@@ -463,22 +462,31 @@ static inline void __set_test_and_free(struct f2fs_sb_info *sbi,
 	unsigned int secno = GET_SEC_FROM_SEG(sbi, segno);
 	unsigned int start_segno = GET_SEG_FROM_SEC(sbi, secno);
 	unsigned int next;
-	unsigned int usable_segs = f2fs_usable_segs_in_sec(sbi);
+	bool ret;
 
 	spin_lock(&free_i->segmap_lock);
-	if (test_and_clear_bit(segno, free_i->free_segmap)) {
-		free_i->free_segments++;
-
-		if (!inmem && IS_CURSEC(sbi, secno))
-			goto skip_free;
-		next = find_next_bit(free_i->free_segmap,
-				start_segno + SEGS_PER_SEC(sbi), start_segno);
-		if (next >= start_segno + usable_segs) {
-			if (test_and_clear_bit(secno, free_i->free_secmap))
-				free_i->free_sections++;
-		}
-	}
-skip_free:
+	ret = test_and_clear_bit(segno, free_i->free_segmap);
+	if (!ret)
+		goto unlock_out;
+
+	free_i->free_segments++;
+
+	if (!inmem && IS_CURSEC(sbi, secno))
+		goto unlock_out;
+
+	/* check large section */
+	next = find_next_bit(free_i->free_segmap,
+			     start_segno + SEGS_PER_SEC(sbi), start_segno);
+	if (next < start_segno + f2fs_usable_segs_in_sec(sbi))
+		goto unlock_out;
+
+	ret = test_and_clear_bit(secno, free_i->free_secmap);
+	if (!ret)
+		goto unlock_out;
+
+	free_i->free_sections++;
+
+unlock_out:
 	spin_unlock(&free_i->segmap_lock);
 }
 
-- 
2.39.5



