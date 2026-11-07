Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062350;
	b=njotXIkkKrUJ2/sgW+sOsmKjjuECuTP21JOvzwpiDNZwa0Gkh+MRf0YhwmIoao3HPjxb
	 q7RZU1G5m8z9DCc93mAqY5+FTM3SIM8JIspUKrUceBjJdlT72DUcRCuadFvorxTKJzdt7
	 jGkyCqGwundqWMc8fDGz78bACUdQjnGp+gwMF8Ct6CI0TZyBzwU1R1fx2EdjQnjrAVrax
	 /qV5Wly1sJxRgv2Ov2ejtXKwM+bqJmtD5gUcfNObIbVHL4wop/LIUTzmQg9XBq5s/h3KX
	 TdeoAYkN9KmQ0E6RwM/XWTpZFZNrnDtiyCdIUnXoT8GcCzx48QGk0ZSuXZqWTpji2sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IR6FwRtmO6B8R6xq0NuKmtz4UczWRkY9VAZWqFbv2TY=;
	b=3brAUCIjqMECCLwFZoCHh4/TVhNnT1xzc2YSKIZRYA2mUuax0Ic95bwOxBXOMLIBaGUj
	 VZGhyqbnG/Nx6eyP5K49L0lGOqv651jmkMPuZDKGy9k/H4ZEZuPfRhZEBE/5QwTzjSrNE
	 7z7w+SDPs9F9oGRw/WFei0txM4TPb81KkZbBDjhsaFp3D0CYXTr8RHk1ja3qwTYLa+q98
	 0/LhD/rK0eF/VYRXL2M4nWKlLacXqAq4JDUqaU6iRsjpuGcOaOaPVsTy+rSfnyvr7MmuZ
	 qfQKKZaYOaV7WjZnY2t3Bg2HBCVxACpKwqYB1Rg/a0+Z1uS7mVwL39V0AJYFqP+3kAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t2LkMjWz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1268606D82D;
	Sat,  7 Nov 2026 14:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t2LkMjWz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866C61F0089F;
	Sat,  7 Nov 2026 14:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062349;
	bh=IR6FwRtmO6B8R6xq0NuKmtz4UczWRkY9VAZWqFbv2TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2LkMjWzptfPdHo5U+EJwORDZkgslfv1qF3raJFeV6Ie4Yc8RT10OXvizP6SRTTD9
	 6EIVgNrKlxQQVqmeXrIl354c+mRodLrwZvnmN6XaKNH+tD3YUqV7DV6hU1qvA+cHtP
	 PukFjznaJudsfDySx+WUQAbtc14Woz4k3gi47C8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1275/1536] f2fs: read i_size once in f2fs_vm_page_mkwrite
Date: Sat,  7 Nov 2026 08:54:51 -0500
Message-ID: <20261107135033.589814935@linuxfoundation.org>
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

[ Upstream commit c04f209773ecb31e592cababce0d6658ee0b8d58 ]

f2fs_vm_page_mkwrite() reads i_size twice: once to check whether the
folio is partially beyond EOF, and once to calculate the offset for
folio_zero_segment(). But a concurrent buffered write can extend isize
and cause the following race condition to corrupt data:

buffered write writes [0,3500)

CPU0 (write fault)                        CPU1 (buffered write)
 ----                                     ----
 f2fs_vm_page_mkwrite()
 folio_lock(folio)
 if (((loff_t)(folio->index + 1) << PAGE_SHIFT) >
 i_size_read(inode))
 /* i_size_read() = 3500 */
                                           write(fd, buf, 200, 4096)
                                           /* writes into page1, does not
                                              wait for folio lock */
                                           i_size_write(inode, 4296)
 offset = i_size_read(inode) & ~PAGE_MASK
 /* i_size_read() = 4296, offset = 200 */
 folio_zero_segment(folio, offset, folio_size(folio))
 /* valid data [200, 3500) is zeroed */

Fix this by reading i_size once and using the same value for both the
EOF check and the zeroing offset.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261012030315.978375-1-zhaonanzhe%40xiaomi.com
Fixes: fbfa2cc58d53 ("f2fs: add file operations")
Cc: stable@vger.kernel.org
Signed-off-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5f5ccf2676964..e85d22daaafbc 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -123,6 +123,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dnode_of_data dn;
 	bool need_alloc = !f2fs_is_pinned_file(inode);
+	loff_t isize;
 	int err = 0;
 	vm_fault_t ret;
 
@@ -177,8 +178,14 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	filemap_invalidate_lock_shared(inode->i_mapping);
 
 	folio_lock(folio);
+	/*
+	 * A concurrent buffered write can extend isize, so we store isize in a
+	 * local variable to let the zeroing offset match the EOF check below.
+	 */
+	isize = i_size_read(inode);
+
 	if (unlikely(folio->mapping != inode->i_mapping ||
-			folio_pos(folio) > i_size_read(inode) ||
+			folio_pos(folio) > isize ||
 			!folio_test_uptodate(folio))) {
 		folio_unlock(folio);
 		err = -EFAULT;
@@ -208,11 +215,10 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
 	/* page is wholly or partially inside EOF */
-	if (((loff_t)(folio->index + 1) << PAGE_SHIFT) >
-						i_size_read(inode)) {
+	if (((loff_t)(folio->index + 1) << PAGE_SHIFT) > isize) {
 		loff_t offset;
 
-		offset = i_size_read(inode) & ~PAGE_MASK;
+		offset = isize & ~PAGE_MASK;
 		folio_zero_segment(folio, offset, folio_size(folio));
 	}
 	folio_mark_dirty(folio);
-- 
2.53.0



