Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059600;
	b=p1gzTjgpPqebzdjwDFfZSC6jReA5rJclhcuIKAvfhdYdiG48NTZtLU6lkUb54cJ3Gk5x
	 BI36sXNUgqS45bKKwwz3YP2uOsBpbrN2n+yfqY5upwtCKBX5AEx+hyX9XnyGFyI1cmt8X
	 2nBcAUkGNDd9T1ZwT3Etz0zZs4hCARvMJKfLpol2gh8lW3fBXCQJd9zxwxu09BAwgOsQH
	 JdL4eXID0pgOolGiA5pQIXtXUZlnidjrXBY3/34xTdHo2N3tg0eh4kWIlET9DelBUuJ/P
	 RsPpTEV6V1VpfK+/u5iujLvde3IgvJKvwhOzBpTNRz7YxGMJCrKVNNXL/4eSGQOBk4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pyyRxmPkcrISqUgxAOZEyZ0aCVrG4rE0ANUR1r5i7K8=;
	b=eTfDv048nINqMf+YLwcxTmzP11Inlz2d78U9ErYJqpaPYfmIvJn0izosHDgn6zkNgoUD
	 V8s6Nu2MOF12x6uiv/IxIauikXMRlbHXRGLJdlF9npTUV7sfUP6szedKZ5LZGVdhOHAxc
	 ZL1zImX5wELaP4ubulqPBxKMWK81ZqRB2OLD0QMxFeF8Rcjk/gVwqCGhKZQ6stvS6UJhd
	 SXLVc/xJVkbei1Ar4QnZ9vsN7nVvz2DaPFoDGwAaSVqE1qmLIfhh7zYCHEkBFcydo+NKL
	 SAD4Azbjp1xvJ947o3f10FUS+ap/R373RjEwIxJd0AkJf+INbvZiaq45NQ5v1fHsP7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEGmQkDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD58C606A335;
	Thu, 19 Nov 2026 03:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEGmQkDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFD41F000CA;
	Thu, 19 Nov 2026 03:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059600;
	bh=pyyRxmPkcrISqUgxAOZEyZ0aCVrG4rE0ANUR1r5i7K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEGmQkDnhJE50joMMO0YEk0ksBpLktdqzU0NdnAH/OaI7nSCnKcJYqsceq40p152Q
	 S8ePO9oR7RZR9jb3xzS+0mADHrpSaU4mPBWJ+SFc/PKJFZyOwEauZ3XNM/D2IXKG9/
	 +SMh5wdNZfg/2J0vDV0vTTTas95+itwDpGjatGrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0900/1848] f2fs: remove mappedtodisk flag usage in mmap write path
Date: Wed, 18 Nov 2026 15:48:58 +0100
Message-ID: <20261118145954.454176556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted folio-based mappedtodisk flag removals to the page-based SetPageMappedToDisk() and PageMappedToDisk() helpers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 1 -
 fs/f2fs/file.c | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 512aeb6a0f989..97f84e0ef02a8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2144,7 +2144,6 @@ static int f2fs_read_single_page(struct inode *inode, struct page *page,
 got_it:
 	if ((map->m_flags & F2FS_MAP_MAPPED)) {
 		block_nr = map->m_pblk + block_in_file - map->m_lblk;
-		SetPageMappedToDisk(page);
 
 		if (!PageUptodate(page) && (!PageSwapCache(page) &&
 					!cleancache_get_page(page))) {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9c12691ace0b6..521c824fd8f5b 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -133,12 +133,6 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	/* wait for GCed page writeback via META_MAPPING */
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
-	/*
-	 * check to see if the page is mapped already (no holes)
-	 */
-	if (PageMappedToDisk(page))
-		goto out_sem;
-
 	/* page is wholly or partially inside EOF */
 	if (((loff_t)(page->index + 1) << PAGE_SHIFT) >
 						i_size_read(inode)) {
-- 
2.53.0



