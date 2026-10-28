Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213671;
	b=cWHNTHm9RuYzDJnz5KJa1IDytoT5r7+XmYyaHwdkk9rInE23lY9nbdU8TIn/dJ5qk4Zi
	 vEqzZG46bsN47X3HTGJ5RhpVan19sD8MWUCZoa8mkqqhNF8Bk1RChlblBOW16kJEzaI40
	 tkxcdqX1EbAUNPr+GaKqVIxpTuDwrmdKeAzt2cTmTpF5NxZUrYUviTlL9Fow721uGoa4u
	 gA8rWjHMDMiI1Yobrvz+YWTUM2S7cOQGpJUaYSxx1q6Nsk14GZBbN8L3/MKADQKope7Mx
	 D6aGze4Ail5OTGMH5UbpdUr7BgMpaijIm4595T4dlb4FxE0QNy0Np+u7SsnsfpHF+PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fe+wwXoSBmxj9nI5kcMc+k6KriLGeiYDc6P2OfseOgA=;
	b=U8kDirEeya1g3gjIQ+7F/8eq+Q+1adG4ro9P0+3PJB/Db/3GbF7LJne9+hsJNtAa/BFp
	 ntnyvf83DOO68g6glc5VLAUeXmwHwD83hFvspe87u/8iK3CW7OGDL/kaAB4XP1AQCfin6
	 Jtl2zLIfcReAOGBp2morKHpA1Ulyb0OSRwwcnalKZq8uQ+wCOWw/bEGkyJKScwyDoMMpe
	 FtC+inR7W5w1RlpVsapcMsfxw74b2QqdM0kW7qlezAO8UBe1h6bzR1YjimDhNsFwVA6i4
	 da+80xaBUA/fi9JkcoqRLIGml0Ol9p1IrzooACYH9+cE3n3BZ1OCXUZmlSz/nyVcnsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SMx33Wvu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9A6606A31A;
	Wed, 28 Oct 2026 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SMx33Wvu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B7F1F01825;
	Wed, 28 Oct 2026 18:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213670;
	bh=fe+wwXoSBmxj9nI5kcMc+k6KriLGeiYDc6P2OfseOgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMx33Wvux40GeUdmtUXZmNTBGuqOXJrS5p6LMPHM1fEKs/8cBoCaT9Uiwm4lejqAJ
	 D+xUqvCNkDJE20VS3GcE2NG8FN6+p3HlXcNStdA2w7brLUVc09LJky7g7xjaBkXOxV
	 TWgMJE+PCIWzsn0D4w46XXExFl71Jy3eVmFb7TJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0589/1887] f2fs: introduce f2fs_invalidate_internal_cache() for cleanup
Date: Wed, 28 Oct 2026 17:44:45 +0100
Message-ID: <20261028170512.825136543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 4e4f1eb9949b10cb7d76370fd27d41f20ef2b32b ]

Just cleanup, no logic changes.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 9f0c4a46be1f ("f2fs: fix to truncate meta inode pages forcely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c    |  8 +++-----
 fs/f2fs/f2fs.h    |  7 +++++++
 fs/f2fs/gc.c      |  5 ++---
 fs/f2fs/segment.c | 14 ++++----------
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 94c46b1b04c5c..082e09be4e8a9 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1458,11 +1458,9 @@ static int __allocate_data_block(struct dnode_of_data *dn, int seg_type)
 	old_blkaddr = dn->data_blkaddr;
 	f2fs_allocate_data_block(sbi, NULL, old_blkaddr, &dn->data_blkaddr,
 				&sum, seg_type, NULL);
-	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO) {
-		invalidate_mapping_pages(META_MAPPING(sbi),
-					old_blkaddr, old_blkaddr);
-		f2fs_invalidate_compress_page(sbi, old_blkaddr);
-	}
+	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
+		f2fs_invalidate_internal_cache(sbi, old_blkaddr);
+
 	f2fs_update_data_blkaddr(dn, dn->data_blkaddr);
 	return 0;
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f72c28700ab7e..b077ba9bd0f2b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4601,6 +4601,13 @@ static inline bool f2fs_is_readonly(struct f2fs_sb_info *sbi)
 	return f2fs_sb_has_readonly(sbi) || f2fs_readonly(sbi->sb);
 }
 
+static inline void f2fs_invalidate_internal_cache(struct f2fs_sb_info *sbi,
+								block_t blkaddr)
+{
+	invalidate_mapping_pages(META_MAPPING(sbi), blkaddr, blkaddr);
+	f2fs_invalidate_compress_page(sbi, blkaddr);
+}
+
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
 #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 0254e3116e552..abb8f3c37b782 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1377,9 +1377,8 @@ static int move_data_block(struct inode *inode, block_t bidx,
 	memcpy(page_address(fio.encrypted_page),
 				page_address(mpage), PAGE_SIZE);
 	f2fs_put_page(mpage, 1);
-	invalidate_mapping_pages(META_MAPPING(fio.sbi),
-				fio.old_blkaddr, fio.old_blkaddr);
-	f2fs_invalidate_compress_page(fio.sbi, fio.old_blkaddr);
+
+	f2fs_invalidate_internal_cache(fio.sbi, fio.old_blkaddr);
 
 	set_page_dirty(fio.encrypted_page);
 	if (clear_page_dirty_for_io(fio.encrypted_page))
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index db126347ca057..6a8fbb0409ae6 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2298,8 +2298,7 @@ void f2fs_invalidate_blocks(struct f2fs_sb_info *sbi, block_t addr)
 	if (addr == NEW_ADDR || addr == COMPRESS_ADDR)
 		return;
 
-	invalidate_mapping_pages(META_MAPPING(sbi), addr, addr);
-	f2fs_invalidate_compress_page(sbi, addr);
+	f2fs_invalidate_internal_cache(sbi, addr);
 
 	/* add it into sit main buffer */
 	down_write(&sit_i->sentry_lock);
@@ -3369,11 +3368,8 @@ static void do_write_page(struct f2fs_summary *sum, struct f2fs_io_info *fio)
 reallocate:
 	f2fs_allocate_data_block(fio->sbi, fio->page, fio->old_blkaddr,
 			&fio->new_blkaddr, sum, type, fio);
-	if (GET_SEGNO(fio->sbi, fio->old_blkaddr) != NULL_SEGNO) {
-		invalidate_mapping_pages(META_MAPPING(fio->sbi),
-					fio->old_blkaddr, fio->old_blkaddr);
-		f2fs_invalidate_compress_page(fio->sbi, fio->old_blkaddr);
-	}
+	if (GET_SEGNO(fio->sbi, fio->old_blkaddr) != NULL_SEGNO)
+		f2fs_invalidate_internal_cache(fio->sbi, fio->old_blkaddr);
 
 	/* writeout dirty page into bdev */
 	f2fs_submit_page_write(fio);
@@ -3568,9 +3564,7 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		update_sit_entry(sbi, new_blkaddr, 1);
 	}
 	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO) {
-		invalidate_mapping_pages(META_MAPPING(sbi),
-					old_blkaddr, old_blkaddr);
-		f2fs_invalidate_compress_page(sbi, old_blkaddr);
+		f2fs_invalidate_internal_cache(sbi, old_blkaddr);
 		if (!from_gc)
 			update_segment_mtime(sbi, old_blkaddr, 0);
 		update_sit_entry(sbi, old_blkaddr, -1);
-- 
2.53.0



