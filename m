Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038352;
	b=fWV8YAFEdzysZhCFWrEi13H00uOAppOn7a2/znS8GQoqQwnf+c6sD8mkLR13QcsJdx1W
	 LQsd3Nok+CTjP6HRhqt1ArxeYpe4T9YusGi9WPf3qfLuoRf5x+Z6JmG9W/4qGVVpsLuC/
	 tZJN/iHmFbdWbkz20766UxXx0tdds1PKYgZZiDd4TFg58lPwouUcceDWHrrxqOswAHy8x
	 LzwiJ/5sgppVIuabOzqOnV8jYlqLhix7AiNKdjEolFd+OR+rw2lIXYfuBOdwt3o46E2DL
	 FnsuALomnfmUnWkHVw5hl0t6fTzo5tA9mgcUAX3JcU30agMaFNtNlHZbzlpiQgrRNZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yWBi8F0xnjGbRjtDhV+JO/2jlhuTbnrDAcSftw1zPtg=;
	b=sM1GnP5iAXwdnMqYk9WUEPwKVpyISg+qv74p8ZK95k6pPVPnTfdBBJr8ucbUjoGUDQAR
	 cziCqtM1LT+CexkZKej1rx5iNzO8r3ctfN121yeFAO/MX22GDMb4Out75spp4iEUPiVyc
	 zOIFgC4vHTyc/jTs1etOY1pR916+jX+EdkiYTYtIQmly+zrzQ9OphhgWg3dKm4iBOkVrA
	 CQD5jr7mHzqMXhEM1YJerBSSxEJDwnmAZ2U5wHcyjatULJpEKPek1YK2d66iHOu52i5v7
	 idthFVOldo/x6aQf/7aQKxvDtis7F+IboN66zM9CF/8omnNLptNDX6vyxinoNHhZCaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6YrN2KM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66D0606A32A;
	Wed, 18 Nov 2026 21:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6YrN2KM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310941F000C5;
	Wed, 18 Nov 2026 21:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038352;
	bh=yWBi8F0xnjGbRjtDhV+JO/2jlhuTbnrDAcSftw1zPtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6YrN2KMqfvjA0dWHD4yBXgcq4jcMUDEBUf2emKm2xU543H3vPWsBk34Vlwk0PEgS
	 PhnyP4HvUT2GSxT+YQ6INhWmemrNWWYi+mFrXQnMN1/voIeawuXiCzVRcmfyUDoehV
	 oFpBEC6SiqE4bUw9LaQABcPJJUWNfcvwc083/Y3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1714/3318] f2fs: remove mappedtodisk flag usage in mmap write path
Date: Wed, 18 Nov 2026 15:38:56 +0100
Message-ID: <20261118150413.288011098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>

[ Upstream commit b3c9843589257631bac18f30655e82d88970688a ]

PG_mappedtodisk was inherited from the nobh/buffer-head era.  However,
f2fs has no buffer heads and the flag is no longer meaningful.  The only
user of the flag is the "no holes" shortcut in f2fs_vm_page_mkwrite(),
which makes mmap write faults skip marking the folio dirty.  Moreover,
it causes the following race condition with filesystem freezing:

 CPU0 (write fault)     CPU1 (freeze_super)
 ----                   ----
 f2fs_vm_page_mkwrite()
 sb_start_pagefault()
 /* shortcut: no dirty */
 sb_end_pagefault()

                        sb_wait_write(SB_FREEZE_PAGEFAULT)
                        /* no waiter, passes */
                        sync_filesystem()
                        /* folio not dirty, skipped */

 finish_fault()
 /* PTE writable */
 fault_dirty_shared_page()
 folio_mark_dirty()
 /* dirty folio on a frozen fs */

It will also skip APP_MAPPED_IO iostat/REQ_TIME updates and post-EOF
folio zeroing.

Remove this shortcut in f2fs_vm_page_mkwrite() and stop setting it in
f2fs_read_single_page().

Reported-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/linux-f2fs-devel/496b913c-eb81-4fa8-be72-c6a06a10aba2@kernel.org/
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Fixes: fbfa2cc58d53 ("f2fs: add file operations")
Cc: stable@vger.kernel.org
Signed-off-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 1 -
 fs/f2fs/file.c | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6412cacf2d53c..28592d5267295 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2136,7 +2136,6 @@ static int f2fs_read_single_page(struct inode *inode, struct folio *folio,
 got_it:
 	if ((map->m_flags & F2FS_MAP_MAPPED)) {
 		block_nr = map->m_pblk + block_in_file - map->m_lblk;
-		folio_set_mappedtodisk(folio);
 
 		if (!f2fs_is_valid_blkaddr(F2FS_I_SB(inode), block_nr,
 						DATA_GENERIC_ENHANCE_READ)) {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7ec8d054bf1ee..f4863d7331802 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -215,12 +215,6 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	/* wait for GCed page writeback via META_MAPPING */
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
-	/*
-	 * check to see if the page is mapped already (no holes)
-	 */
-	if (folio_test_mappedtodisk(folio))
-		goto out_sem;
-
 	/* page is wholly or partially inside EOF */
 	if (((loff_t)(folio->index + 1) << PAGE_SHIFT) > isize) {
 		loff_t offset;
-- 
2.53.0



