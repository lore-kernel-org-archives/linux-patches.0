Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065180;
	b=o/Q6zGfvveSpgw3gDkFnWjv4V6M/aG1SC3xUCImE4MweO6A4kteF34p/kpeQaUIqozqz
	 dGz4392xfMeoBXth8UM3UeygvOHNUbnClSEfPLFAq9v9qOXqPUJQ0VZ2S3TNMTpuIDvtN
	 hYwGMbbuZYffFLImudZp2Q3APUBFUKG7uMaxOVLhu1gKCflwhkbvuA5Utdfrp2F7yI/2e
	 P5sxd2+1DIggUeqdVSEsuPVIqY6GBasJ8BYlSQ8uOVCqqH5v36huNkd18murls6n7GZIe
	 go02xgtZNbUIu34kNHjmPexmwH2UZYrhqj/HZnun7ERnL4M3Rmf8K5JVCl/R5GxlfDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yPZoaY62NB9bc4PfsQSv/emKxTuuc/6TyeJcNLKxOQ8=;
	b=R/VdokRVHghFaprgrJkmQdIFRM/XalnL45b9EVZ7tKEM2rirxK0BH2bOoeEtCi+QIiL+
	 cUgeiZAwfpThOd8mxP04ufA+4MUu8QVOzWDyo1vs3y7S/Dv5m+B0arQRAdN9lvaAnmheV
	 HwO2SAvzoMbx4PxVgwapbFKq+0B8zRy1ZhdwQW8oy4NowUcjLw5Y9d6XkJmZ4sh/04wFI
	 iE6pbACGk6K/4mFdy7z7Hck1XRRVR7WoFpEqHSyLx+kw+5kxcxe5tewLGkzbpHl+R2F7Y
	 WO+Xb7UZtayx2PYWXmb3HNIxbgVCFEQ11zfKpSwRgKNw45EvL3oFejwo4+9uUb/vFEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVoRrAhn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B9C606A33E;
	Sat,  7 Nov 2026 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVoRrAhn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5691F0089F;
	Sat,  7 Nov 2026 15:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065179;
	bh=yPZoaY62NB9bc4PfsQSv/emKxTuuc/6TyeJcNLKxOQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVoRrAhnvi5Qh+kW2DLA45VRmgCD13VzSX3Sq6GrgRLBvZTOgaSgsUMeqhqApy29Y
	 AF7sZ1Lz6moybYHEPlpUP6ZfTR7GxTr6z4FhKViheQhcrZm4402SQO0gbyeSkYS3Uv
	 CH08h7AF4W3YJwrq0MTpMDmjA5wFpn/wroclmE0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0985/1257] exfat: dirty all new pages when extending valid_size
Date: Sat,  7 Nov 2026 08:54:41 -0500
Message-ID: <20261107135006.568556610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit 03ac97285b699954fa7bc24f8b6cdc1830c94d28 ]

In the current code, exfat_zero_new_range() does not mark non-uptodate
pages as dirty, which may cause some blocks within a page to not be
written back.

This commit no longer checks each block in a non-uptodate page
individually. Instead, it reads the entire page back into the cache and
then writes it back as a whole. This allows concurrent writes and zeroing
operations to be synchronized using the folio lock.

Fixes: 1135704ed22f ("exfat: fix valid_size extension over a shared writable mapping")
Cc: stable@vger.kernel.org
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 108 ++++++++++++------------------------------------
 1 file changed, 26 insertions(+), 82 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 81eeb76ef94bf..8b551bb83676e 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -656,98 +656,42 @@ int exfat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 }
 
 /*
- * exfat_zero_new_range - zero [start, end) without overwriting uptodate blocks
+ * exfat_prepare_valid_range - populate and dirty folios covering [start, end)
  *
- * Uptodate blocks may contain data written through a shared mapping beyond
- * valid_size.
+ * Populate missing blocks via the read path, which zero-fills data
+ * beyond the current valid_size and skips uptodate blocks.
+ * Mark entire folios dirty so the newly valid range is written back.
+ *
+ * Call before advancing valid_size.
  */
-static int exfat_zero_new_range(struct inode *inode, loff_t start, loff_t end)
+static int exfat_prepare_valid_range(struct inode *inode, loff_t start,
+				    loff_t end)
 {
 	struct address_space *mapping = inode->i_mapping;
-	unsigned int blocksize = i_blocksize(inode);
-	loff_t pos = start;
-	int err;
-
-	while (pos < end) {
-		loff_t next = min_t(loff_t,
-				round_down(pos, PAGE_SIZE) + PAGE_SIZE, end);
-		struct folio *folio;
-		loff_t bpos;
-
-		folio = filemap_get_folio(mapping, pos >> PAGE_SHIFT);
-		if (IS_ERR(folio)) {
-			err = iomap_zero_range(inode, pos, next - pos, NULL,
-					       &exfat_iomap_ops, NULL, NULL);
-			if (err < 0)
-				return err;
-			pos = next;
-			continue;
-		}
+	loff_t next, pos = start;
+	struct folio *folio;
+	pgoff_t index;
 
-		if (folio_test_uptodate(folio)) {
-			folio_lock(folio);
-			if (folio->mapping == mapping)
-				folio_mark_dirty(folio);
-			folio_unlock(folio);
-			folio_put(folio);
-			pos = next;
-			continue;
-		}
+	if (pos >= end)
+		return 0;
 
-		/*
-		 * Zero not-uptodate block runs. iomap_zero_range() requires an
-		 * unlocked folio, so recheck ->mapping after each call.
-		 */
-		folio_lock(folio);
-		bpos = pos;
-		while (bpos < next) {
-			loff_t rstart, rend;
-
-			if (folio->mapping != mapping) {
-				folio_unlock(folio);
-				err = iomap_zero_range(inode, bpos, next - bpos,
-						NULL, &exfat_iomap_ops, NULL, NULL);
-				if (err < 0) {
-					folio_put(folio);
-					return err;
-				}
-				folio_lock(folio);
-				break;
-			}
-
-			if (iomap_is_partially_uptodate(folio,
-					offset_in_folio(folio, bpos), blocksize)) {
-				bpos += blocksize;
-				continue;
-			}
+	while (pos < end) {
+		index = pos >> PAGE_SHIFT;
+		next = min(((loff_t)index + 1) << PAGE_SHIFT, end);
 
-			rstart = bpos;
-			rend = min_t(loff_t, bpos + blocksize, next);
-			while (rend < next &&
-			       !iomap_is_partially_uptodate(folio,
-					offset_in_folio(folio, rend), blocksize))
-				rend = min_t(loff_t, rend + blocksize, next);
+		balance_dirty_pages_ratelimited(mapping);
 
-			folio_unlock(folio);
-			err = iomap_zero_range(inode, rstart, rend - rstart,
-					NULL, &exfat_iomap_ops, NULL, NULL);
-			if (err < 0) {
-				folio_put(folio);
-				return err;
-			}
-			folio_lock(folio);
-			bpos = rend;
-		}
+		folio = read_mapping_folio(mapping, index, NULL);
+		if (IS_ERR(folio))
+			return PTR_ERR(folio);
 
-		/*
-		 * Dirty only a fully uptodate folio. Dirtying a partial folio could
-		 * write uninitialised cache contents over valid on-disk blocks.
-		 */
-		if (folio->mapping == mapping && folio_test_uptodate(folio))
+		folio_lock(folio);
+		if (folio->mapping == mapping) {
 			folio_mark_dirty(folio);
+			pos = next;
+		}
 		folio_unlock(folio);
 		folio_put(folio);
-		pos = next;
 	}
 
 	return 0;
@@ -783,7 +727,7 @@ static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size)
 		if (gap_start < new_valid_size)
 			unmap_mapping_range(inode->i_mapping, gap_start,
 					new_valid_size - gap_start, 0);
-		ret = exfat_zero_new_range(inode, gap_start, new_valid_size);
+		ret = exfat_prepare_valid_range(inode, gap_start, new_valid_size);
 		filemap_invalidate_unlock(inode->i_mapping);
 		if (ret) {
 			filemap_invalidate_lock(inode->i_mapping);
@@ -965,7 +909,7 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 			 * fault populated its folio and iomap_page_mkwrite()
 			 * will dirty it.
 			 */
-			err = exfat_zero_new_range(inode, ei->zeroed_size,
+			err = exfat_prepare_valid_range(inode, ei->zeroed_size,
 					fault_page_start);
 			if (err < 0) {
 				inode_unlock(inode);
-- 
2.53.0



