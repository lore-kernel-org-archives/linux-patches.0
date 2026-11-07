Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064745;
	b=jqz7g/kZzzkR1ZNrpWBw6DtvBnFe523HhRqRLwGijGpR/kDKJ9dBpNpzQ7zw0UZJ8bLC
	 7jsYEjBPwZa/XEVR21+VdVL31wo+opTZ6UNZ5Uqx6DBm0K4ZAK2SeGRpUkl5UOl0QlVsc
	 G5gPkfUDL7kb/F2kN7ilsWB5BjKzR9Dap7VhbgeZ8PAOMsB3msydqeWiMgzTOarZT1sLk
	 K0+REAHtZZcXbxTUJfgVvlnaS167eJuoS/NtP5Fp8e3kRf2dr/PUMuAqPvZkfZ/achLxy
	 860DEzF5QdagOmea0gYx7edwdd1E67wtpVAAANgDjPBP++q1Sc9DMka2KpqCJnxauvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cFp5w3IiAfY/nj0UwDPXTtXQIPeQ8EC1M8sfu6tXK7k=;
	b=1m0SQT9L/V1ENiw8cS1U1c0ZyJPAGXfDClF/2898ILP6r/+83Am5941+/trKaiv8RduZ
	 ZDka26pBET4jr+KYY2ZvOm8IdUV4xqFd+fX79zhmKFkuOmowEjbW337LpMqJ0uPim/pUs
	 9RXUoKeerN36F7TMA01odQu4+l7yw4+W5vDCb4jOUKC+0dWirKF6dq3qL/Tz66ABi1y54
	 8Sd2l+Qzt4fnwjY4eQZCmlzxrYWChSPdXfXjo/Iv8pUT2jPDU+NXoXOpf9NZenvU6scNx
	 IwO+G46kKs5P5/AfTFewQ6QAWJklgeXdsHtnHIg0ot2BVFnywt2PINJh48AxDsb58bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cqdL4kXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5EA606D81C;
	Sat,  7 Nov 2026 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cqdL4kXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35341F0089F;
	Sat,  7 Nov 2026 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064745;
	bh=cFp5w3IiAfY/nj0UwDPXTtXQIPeQ8EC1M8sfu6tXK7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqdL4kXsyz+gT52Q45IuErDPhtJAWwO45rfa+uNLaAagqhSP90ZotVt3kAq+hxN2V
	 iqdCdTgFdZIvGwFl9XtiB+kRUY/AORz5LgOOXJyWIReqzp5Rbgo31+OrM2eSZFjSDY
	 4g6luSMlVFxsxA0CFdRROQuE4B2x6J71Q4yt8ln8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0720/1257] f2fs: remove mappedtodisk flag usage in mmap write path
Date: Sat,  7 Nov 2026 08:50:16 -0500
Message-ID: <20261107134959.147828771@linuxfoundation.org>
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
index 5a4af37b358d3..c9a1bb07a5b32 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2260,7 +2260,6 @@ static int f2fs_read_single_page(struct inode *inode, struct fsverity_info *vi,
 got_it:
 	if ((map->m_flags & F2FS_MAP_MAPPED)) {
 		block_nr = map->m_pblk + block_in_file - map->m_lblk;
-		folio_set_mappedtodisk(folio);
 
 		if (!f2fs_is_valid_blkaddr(F2FS_I_SB(inode), block_nr,
 						DATA_GENERIC_ENHANCE_READ)) {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5bd908799e7d5..b391ced41edda 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -217,12 +217,6 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
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



