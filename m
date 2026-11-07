Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063345;
	b=tvFLQFVa+68T+cT+LFO45fTbF6TMeJYxIJxxfB2j4YKtSND1Xlt9RZ34uoq2XOYwNBWC
	 Mvt/c3AHahHnkNpNWU5UqbFYEB50ayWpl1BHi2qNJJ0WSLVOEVE5TYM9YKHFcqqUS+gEZ
	 Aw+BlnazHy9cN2fs8cU4Blzh4Qxf9wRq6Qkg7Gh0WVL3YcCjJEBBYaVLFnGtNYuPtWXjZ
	 f5bb4+RmSzR862+delIw1x5f0pi1CKQNTcZSi12BBEMI94qmu0lfLxddOMIU9VtdEcNel
	 2qkKKjkDlHWN0+vv1SXoirp6Zc81WsTjHkpWZqTlRfs4IRkKuXhvuXaCEYxRCPIZ3Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ct3nn3H9TvxgHsWKJcYD2reM/kfcsXmbkjEB0+cxErw=;
	b=HVuvsMDf+3JrPxrv87FNxjCsfB2X7WkUn568RtAQ5upJ+p0hGDUr8aqM84bPpAemH3+N
	 LVfZb6HRSrIkQenRRY08tzLuivkcOLhCHEjp2Z5jF6SwUjhNiOMYmFxLoq7Ha0KLCSz7B
	 A1HauuDZNPBuaByKnLTHVG48lLt5aY++/8eTvNKPqICbzJKqU2XHzP/cX/qt7OI1p88PF
	 bagLzINHwF891g3Wmv0gp0T7HxLzh0SdiTXdjE+0D7FFLNAfU4OkxsP+OZSKEcq+/cXJY
	 j/PoFsQcQUidpIsyYgIghWgb0HbyBCjHbJ66vOeRammPTAlb+A+/7rzp7+gIAX6eZWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1C04CkQI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14099606A32C;
	Sat,  7 Nov 2026 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1C04CkQI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B542C1F0089F;
	Sat,  7 Nov 2026 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063344;
	bh=Ct3nn3H9TvxgHsWKJcYD2reM/kfcsXmbkjEB0+cxErw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1C04CkQI20QNE0bbW/4RWb7kDJPR1tOxC+TGoWENe1SI0V+AcSvn3/r4DEoP4QF/Y
	 dzpwRFXXZKq4qPM6yHMCYbbNs5M4591SCr/xTfkAielMzD4pMbAunKumW4A255XDoi
	 3Ow+K6ExZf/7HMH+qZFL8okbG05JtmP+CbVZcKtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 527/869] f2fs: remove mappedtodisk flag usage in mmap write path
Date: Sat,  7 Nov 2026 08:53:29 -0500
Message-ID: <20261107134911.357353115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aa6a844ed34dd..52bdfb2785f06 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2186,7 +2186,6 @@ static int f2fs_read_single_page(struct inode *inode, struct folio *folio,
 got_it:
 	if ((map->m_flags & F2FS_MAP_MAPPED)) {
 		block_nr = map->m_pblk + block_in_file - map->m_lblk;
-		folio_set_mappedtodisk(folio);
 
 		if (!f2fs_is_valid_blkaddr(F2FS_I_SB(inode), block_nr,
 						DATA_GENERIC_ENHANCE_READ)) {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 49febaa660815..e5de7c3557260 100644
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



