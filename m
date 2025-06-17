Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08E32ED172;
	Tue, 17 Jun 2025 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175352; cv=none; b=CCCBEBXQYpkqlJRZbi2GIJlfOEIEjBWXx3DPlHc1VyKbXSES9VyVIPNtL/frZZdovZf4JV9VAd90au74mAFBWdBT69O2mq1v78ciT/OnoxxF7hbueatx5XpcV8aymeZhmyZ647ZTxi24rmewzTH/9HVJ2O/TWaOQy+tnsBgI01E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175352; c=relaxed/simple;
	bh=Hmq3mvD6MsbAFJL1hMj7wiNVXJQk8y10Vje6ThQDy/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZGIbUtLf0Rme5tkXorBF7j9GkHML6q84UXJqGZFI+ZtSw0pr5XmMK8WL9XurR7mg5l7TJ2KllsNKLB30QB9yixb0l4yGDo6G6ZcaqTtwqdICunCWzXcllXHHdQBe8Lxnz52CY7AFZObS9Q0rFiJ4srsdpGhieSecniV2qj2VZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+CsDbCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+CsDbCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D3FC4CEE3;
	Tue, 17 Jun 2025 15:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175351;
	bh=Hmq3mvD6MsbAFJL1hMj7wiNVXJQk8y10Vje6ThQDy/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+CsDbCdc7bayIGZeba+9XJoybUHEDmeFhkA+tLS8nWb2KtIDlP0yrfQOPjFA5m+j
	 Sq0XIlCg4CHscyFFpo5BDzRyZZq/TPEwYZiiemdVNZGa++AUW693Wu3po6yZsUwyJg
	 ktDJKriUjTw4txHlVDg6NSFSlUyKM0kU/ePweIbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/512] f2fs: clean up unnecessary indentation
Date: Tue, 17 Jun 2025 17:21:24 +0200
Message-ID: <20250617152424.365601993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 05d3273ad03fa5ea1177b4f3dfeeb6de4899b504 ]

No functional change.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 0c004dd5595b9..25d3cda9bd5a3 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -431,7 +431,6 @@ static inline void __set_free(struct f2fs_sb_info *sbi, unsigned int segno)
 	unsigned int secno = GET_SEC_FROM_SEG(sbi, segno);
 	unsigned int start_segno = GET_SEG_FROM_SEC(sbi, secno);
 	unsigned int next;
-	unsigned int usable_segs = f2fs_usable_segs_in_sec(sbi);
 
 	spin_lock(&free_i->segmap_lock);
 	clear_bit(segno, free_i->free_segmap);
@@ -439,7 +438,7 @@ static inline void __set_free(struct f2fs_sb_info *sbi, unsigned int segno)
 
 	next = find_next_bit(free_i->free_segmap,
 			start_segno + SEGS_PER_SEC(sbi), start_segno);
-	if (next >= start_segno + usable_segs) {
+	if (next >= start_segno + f2fs_usable_segs_in_sec(sbi)) {
 		clear_bit(secno, free_i->free_secmap);
 		free_i->free_sections++;
 	}
@@ -465,22 +464,31 @@ static inline void __set_test_and_free(struct f2fs_sb_info *sbi,
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



