Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062346;
	b=f8IKS8ZOJVhEK/yx5Qe1+Wo1D27W2+EzWFRMpvtVL5Ya+AworLuDQSOSKO/AdKPRCt5K
	 /8gd/GmssMT+DYaZ8zMwOkh69mL/8zz7HimNQStflDm3KPmahfFz1Dcci06l0xMYFItU1
	 Zyfo/WxDGOtbZHVvHiCtIVIhVtNiVJTfoNd/2iX0F8y1p0F0KlMHPMXoy5voIpAA5Rg6Y
	 30H7IEpL3GL0VvPB6JdeDmZtK3yjoZJXMJeXYGcZM8FelSjvvZQQ4rj3jhvIMKs6IYWkj
	 kvpKyCYdQ9zI/Kwhr5FoMnEVQ6YUrdZrQVbhKUovUvqEbL1BiPFYGi/i1DwA4Qjz3Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LtVSmj0BjaXYE/Ndkt/wwQ1OmTec3GfOFh2GA6mr8+I=;
	b=TIYmFTuoTGBF4KPB9sY+kDpF+96Cyv721uYsisp4r5o1gtBXrox+KHCiURtkUY0m8hWc
	 XzrqznNZ2N2x7xgip1bM2C8mXTYBRpYSaRIw19FLIArEjaBN7DZaK19gOzjYVsje+EEGb
	 Jz49JZSDJraqOTsyqzGRHO1FRoGyrvz8JXgOAP/uLdUMRNOyO/2t9Ibuzl4/pcxFjnTfP
	 1SozjY5AgBYgfYx5gL5MsIHqQqHbY7FnytscV9NiGf4pz98WBOuVkTXzd9jv6LSAThD+W
	 gT55QfCSCJXr5NAnxE60vV7d39nuCrb7/aYmkP46xSi0dqmh45/wfQe5xKzInobSPWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XEOEGOdo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A77606EEBF;
	Sat,  7 Nov 2026 14:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XEOEGOdo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A701F0089F;
	Sat,  7 Nov 2026 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062346;
	bh=LtVSmj0BjaXYE/Ndkt/wwQ1OmTec3GfOFh2GA6mr8+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEOEGOdoYi76kS9aTHbhjY1sftlwTZlPUNgImu11ML09SYeR6NtPEBglGLwt6+5Z1
	 /g1oDsBfMgMQDAndU/C25fYBgU66zTNKBDxU3xiuUzo4aeCS/DFDTbAdPjdQ5WdAsX
	 k7G7jsU5VqxA87k4gscE3/7ueXs9VvwuqI86mpQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1273/1536] f2fs: remove mappedtodisk flag usage in mmap write path
Date: Sat,  7 Nov 2026 08:54:49 -0500
Message-ID: <20261107135033.529084742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3bf6820130010..539b0324ccc49 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2174,7 +2174,6 @@ static int f2fs_read_single_page(struct inode *inode, struct folio *folio,
 got_it:
 	if ((map->m_flags & F2FS_MAP_MAPPED)) {
 		block_nr = map->m_pblk + block_in_file - map->m_lblk;
-		folio_set_mappedtodisk(folio);
 
 		if (!f2fs_is_valid_blkaddr(F2FS_I_SB(inode), block_nr,
 						DATA_GENERIC_ENHANCE_READ)) {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index df4bad21dcc71..5f5ccf2676964 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -207,12 +207,6 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	/* wait for GCed page writeback via META_MAPPING */
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
-	/*
-	 * check to see if the page is mapped already (no holes)
-	 */
-	if (folio_test_mappedtodisk(folio))
-		goto out_sem;
-
 	/* page is wholly or partially inside EOF */
 	if (((loff_t)(folio->index + 1) << PAGE_SHIFT) >
 						i_size_read(inode)) {
-- 
2.53.0



