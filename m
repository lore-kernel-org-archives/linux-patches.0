Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213674;
	b=OZjUxKa6skWoRmP4ywmaZ1Xi4QPhAeMV++QxphOt65XIjTC7kevKT1eF+eYKFOSitLLN
	 xVSw9ST14hSjTij3Wg1m/RayipBaopIH9bk5U43fugQRsHQGA4NXgfDXObDRkfg8dzObF
	 Ug9m2GtiouhhQ7nIavPxEiECLwDPrNojmOLHSokCPaXX9Xc6W9XIqiN0ItENfYNxyS7kg
	 IU5NBTB1u0z50/02kVhFwuUB4Qo4L2K6Z98Jli9Ci3nPamh+KEnIHcoRbUEJt0uWoZDU9
	 2FT/5bqoGXrBE3yRUdilrX7JHDk/KXV79yFTTtLndwbwaBzvG08csqufsCJ2NdaFruQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P/hBdoWfA+l147NHIq3GlHBPzT8a5Ei+oII1w75wS+I=;
	b=pY53FNyNcdHD5kVqDS71y3FV8yvoVUGD6rmyLLk211al4BLe4sAUvm2jkGuN2ZbPBDjF
	 SsoCoJh7mxMsDOt/aPFC5yAefsFOdJ2HIKYmQECTHX9+prF25n10wfls/fVEPtaoQhBxX
	 vHqiesB0n14lQpL3tzCotv/sOq2V9c8y3vT7YUNLEv1iD5jCsn/s/L9TEztpYW9vYeT/M
	 zCxCjW0i1sc5oTlE4xI4RiEGyvFGQPB+eHBk96jzPNNwSWlQwnP+jVXzxrZfOM+prcVOy
	 p0sdK+41BrqNDrtAb5lGBNujPs4xtSWw/QU4O0yUOkTNC08CVoZD5yOcvSw051vFWQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2rTBffde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D86606A324;
	Wed, 28 Oct 2026 18:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2rTBffde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC2F1F031E4;
	Wed, 28 Oct 2026 18:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213673;
	bh=P/hBdoWfA+l147NHIq3GlHBPzT8a5Ei+oII1w75wS+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2rTBffdev4dMaIAkgU8W1MbHZ1iSL+CG1euAhqfU/CMQ0bbaov7UbnoUaKuCL1tVs
	 g03oK7KW3iMeaiFpztoCeoH+BjSPFH1BPrCN8JSF61rC2KkvEXezaPN3lg/VNvQstn
	 UgzwlMyHMsM308dZJzU3AFPIAPRcBRHkqLDM6Xc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0590/1887] f2fs: fix to truncate meta inode pages forcely
Date: Wed, 28 Oct 2026 17:44:46 +0100
Message-ID: <20261028170512.847240961@linuxfoundation.org>
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

[ Upstream commit 9f0c4a46be1fe9b97dbe66d49204c1371e3ece65 ]

Below race case can cause data corruption:

Thread A				GC thread
					- gc_data_segment
					 - ra_data_block
					  - locked meta_inode page
- f2fs_inplace_write_data
 - invalidate_mapping_pages
 : fail to invalidate meta_inode page
   due to lock failure or dirty|writeback
   status
 - f2fs_submit_page_bio
 : write last dirty data to old blkaddr
					 - move_data_block
					  - load old data from meta_inode page
					  - f2fs_submit_page_write
					  : write old data to new blkaddr

Because invalidate_mapping_pages() will skip invalidating page which
has unclear status including locked, dirty, writeback and so on, so
we need to use truncate_inode_pages_range() instead of
invalidate_mapping_pages() to make sure meta_inode page will be dropped.

Fixes: 6aa58d8ad20a ("f2fs: readahead encrypted block during GC")
Fixes: e3b49ea36802 ("f2fs: invalidate META_MAPPING before IPU/DIO write")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c    |  5 +++--
 fs/f2fs/f2fs.h          | 28 +++++++++++++++++++++++++++-
 fs/f2fs/segment.c       |  5 ++---
 include/linux/f2fs_fs.h |  1 +
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 49000b1a7a653..84fc60d843bc2 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1609,8 +1609,9 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	 */
 	if (f2fs_sb_has_encrypt(sbi) || f2fs_sb_has_verity(sbi) ||
 		f2fs_sb_has_compression(sbi))
-		invalidate_mapping_pages(META_MAPPING(sbi),
-				MAIN_BLKADDR(sbi), MAX_BLKADDR(sbi) - 1);
+		f2fs_bug_on(sbi,
+			invalidate_inode_pages2_range(META_MAPPING(sbi),
+				MAIN_BLKADDR(sbi), MAX_BLKADDR(sbi) - 1));
 
 	f2fs_release_ino_entry(sbi, false);
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b077ba9bd0f2b..f18e380967678 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4601,10 +4601,36 @@ static inline bool f2fs_is_readonly(struct f2fs_sb_info *sbi)
 	return f2fs_sb_has_readonly(sbi) || f2fs_readonly(sbi->sb);
 }
 
+static inline void f2fs_truncate_meta_inode_pages(struct f2fs_sb_info *sbi,
+					block_t blkaddr, unsigned int cnt)
+{
+	bool need_submit = false;
+	int i = 0;
+
+	do {
+		struct page *page;
+
+		page = find_get_page(META_MAPPING(sbi), blkaddr + i);
+		if (page) {
+			if (PageWriteback(page))
+				need_submit = true;
+			f2fs_put_page(page, 0);
+		}
+	} while (++i < cnt && !need_submit);
+
+	if (need_submit)
+		f2fs_submit_merged_write_cond(sbi, sbi->meta_inode,
+							NULL, 0, DATA);
+
+	truncate_inode_pages_range(META_MAPPING(sbi),
+			F2FS_BLK_TO_BYTES((loff_t)blkaddr),
+			F2FS_BLK_END_BYTES((loff_t)(blkaddr + cnt - 1)));
+}
+
 static inline void f2fs_invalidate_internal_cache(struct f2fs_sb_info *sbi,
 								block_t blkaddr)
 {
-	invalidate_mapping_pages(META_MAPPING(sbi), blkaddr, blkaddr);
+	f2fs_truncate_meta_inode_pages(sbi, blkaddr, 1);
 	f2fs_invalidate_compress_page(sbi, blkaddr);
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 6a8fbb0409ae6..4b13e04c6e608 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3462,8 +3462,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 	}
 
 	if (fio->post_read)
-		invalidate_mapping_pages(META_MAPPING(sbi),
-				fio->new_blkaddr, fio->new_blkaddr);
+		f2fs_truncate_meta_inode_pages(sbi, fio->new_blkaddr, 1);
 
 	stat_inc_inplace_blocks(fio->sbi);
 
@@ -3653,7 +3652,7 @@ void f2fs_wait_on_block_writeback_range(struct inode *inode, block_t blkaddr,
 	for (i = 0; i < len; i++)
 		f2fs_wait_on_block_writeback(inode, blkaddr + i);
 
-	invalidate_mapping_pages(META_MAPPING(sbi), blkaddr, blkaddr + len - 1);
+	f2fs_truncate_meta_inode_pages(sbi, blkaddr, len);
 }
 
 static int read_compacted_summaries(struct f2fs_sb_info *sbi)
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 1373c037255d9..bf834b801b55b 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -27,6 +27,7 @@
 
 #define F2FS_BYTES_TO_BLK(bytes)	((bytes) >> F2FS_BLKSIZE_BITS)
 #define F2FS_BLK_TO_BYTES(blk)		((blk) << F2FS_BLKSIZE_BITS)
+#define F2FS_BLK_END_BYTES(blk)		(F2FS_BLK_TO_BYTES(blk + 1) - 1)
 
 /* 0, 1(node nid), 2(meta nid) are reserved node id */
 #define F2FS_RESERVED_NODE_NUM		3
-- 
2.53.0



