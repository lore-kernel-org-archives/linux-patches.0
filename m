Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046949;
	b=TxaovMJCIYXxT6NZNpJallJS6xCc/YRF5Ram31Sc9hmmezvxz7zd0CJjKlL3rp4nIQj8
	 Gdz05/hQGur4G4Cwb4Imhk4yX/LBc7Gg/cGySrFcvrhigF20crLleSDYmc1WqDOKj2xg9
	 pKpeuLQjgVfgs4r71V3MlCYqmvrumtAX8ItdeyxAp1Gn009BCFdT8+15cuCGGes2kb52M
	 qd97EKIp+cLADjIF49L9SqJLVDJZIlgtYhiPPE4wJcMnjc6uRig2onH70kCRNhVFg6JAk
	 PCI8Bwn1A/QFMOPLtrnodsM4ZjPvHJfutYuxT6bu2UqzPl6++4iyjAnNUnsnUXKlj+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZCKlc5qPgEeDzqFG0R6HbItRag9pYoW/0K44wo8j/9A=;
	b=PFznjnKuyc92vIQLCez3n3n1ENqKNuI+uebYo0FTJyTbFukg5Z5Tn7afaY9JdLOWGK/H
	 1w0dvcnRTt5yzXH8fKLZTTLVRh3ywlrWekm/75G3VAgYPPEal8yC2pbrRUPcGufSZE9yI
	 cL6IDddLASvqfj5XFCnAD08oqLn6l+3ghK1UsnVDcpukdxnJkNq7fmqbuy3Xd+QJQ72oO
	 DL999C2qnK7HBt+GeqrR+K1wk2vY7Rc6NZJ4NHpJTr2KXEPEx7duwMGDfPwzMMgyGWjcW
	 V5i5eaw5YpCohfR56luJDd4mdZiHiLT28y6N8VtOOt3Arzk9tFeVC/s0fH4B4wr4e6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uh+lDcUZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FAB606A32C;
	Thu, 19 Nov 2026 00:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uh+lDcUZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEE71F000C4;
	Thu, 19 Nov 2026 00:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046949;
	bh=ZCKlc5qPgEeDzqFG0R6HbItRag9pYoW/0K44wo8j/9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uh+lDcUZQU0sDPR9+U+RfqOtg6UGiW43yLOTxiS185MOJd6MzXUPdLWybEfkhTRt9
	 RM96mVWAXKqVKH5bITLVMKOoRn6AYm2QdA8QLUutcPAFUL3k3HRZfjfeNMggTWkJZT
	 jKGPVH0uPbWLnQ4e5FQNS5fOTpvr8huThIxaBbpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1462/2857] f2fs: disallow mmap write and data-modifying fallocate on atomic files
Date: Wed, 18 Nov 2026 15:41:36 +0100
Message-ID: <20261118150253.953472007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 06dfe4a7eb696d868b196c2a49873142f19bd862 ]

Stores through a shared writable mapping and fallocate with
FALLOC_FL_PUNCH_HOLE, FALLOC_FL_ZERO_RANGE, FALLOC_FL_COLLAPSE_RANGE or
FALLOC_FL_INSERT_RANGE do not go through ->write_begin, so they bypass
the COW inode and modify the original inode directly. Reject them while
the file is in atomic write mode, as fallocate already does for pinned
and compressed files. A write fault gets SIGBUS and fallocate gets
-EOPNOTSUPP.

fallocate without these flags only preallocates blocks and stays
allowed.

f2fs_vm_page_mkwrite() cannot take inode_lock, so check the flag under
invalidate_lock, and hold invalidate_lock in
f2fs_ioc_start_atomic_write() from the flush until the flag is set.
Otherwise a fault could check the flag, then start_atomic_write could
flush and set the flag, and the fault would dirty the folio afterwards.

Cc: stable@kernel.org
Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: replaced the shared out_unlock cleanup with explicit invalidate_lock releases on all error exits ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8f94cd81944f1..b5a6f37dbc04a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -102,6 +102,18 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 
 	file_update_time(vmf->vma->vm_file);
 	filemap_invalidate_lock_shared(inode->i_mapping);
+
+	/*
+	 * mmap stores bypass the COW inode and would break atomicity. Check
+	 * under invalidate_lock: f2fs_ioc_start_atomic_write() holds it while
+	 * flushing dirty pages and setting FI_ATOMIC_FILE, so either it sees
+	 * our dirty page and writes it back, or we see the flag.
+	 */
+	if (unlikely(f2fs_is_atomic_file(inode))) {
+		err = -EOPNOTSUPP;
+		goto out_sem;
+	}
+
 	lock_page(page);
 	if (unlikely(page->mapping != inode->i_mapping ||
 			page_offset(page) > i_size_read(inode) ||
@@ -1882,9 +1894,11 @@ static long f2fs_fallocate(struct file *file, int mode,
 
 	/*
 	 * Pinned file should not support partial truncation since the block
-	 * can be used by applications.
+	 * can be used by applications. Atomic files should not either, since
+	 * these modify the original inode directly and break atomicity.
 	 */
-	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode)) &&
+	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode) ||
+	     f2fs_is_atomic_file(inode)) &&
 		(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
 			FALLOC_FL_ZERO_RANGE | FALLOC_FL_INSERT_RANGE))) {
 		ret = -EOPNOTSUPP;
@@ -2168,6 +2182,8 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 		goto out;
 
 	f2fs_down_write(&fi->i_gc_rwsem[WRITE]);
+	/* serialize with f2fs_vm_page_mkwrite(), see the comment there */
+	filemap_invalidate_lock(inode->i_mapping);
 
 	/*
 	 * Should wait end_io to count F2FS_WB_CP_DATA correctly by
@@ -2178,6 +2194,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 			  inode->i_ino, get_dirty_pages(inode));
 	ret = filemap_write_and_wait_range(inode->i_mapping, 0, LLONG_MAX);
 	if (ret) {
+		filemap_invalidate_unlock(inode->i_mapping);
 		f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 		goto out;
 	}
@@ -2187,6 +2204,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 		/* Create a COW inode for atomic write */
 		pinode = f2fs_iget(inode->i_sb, fi->i_pino);
 		if (IS_ERR(pinode)) {
+			filemap_invalidate_unlock(inode->i_mapping);
 			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 			ret = PTR_ERR(pinode);
 			goto out;
@@ -2195,6 +2213,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 		ret = f2fs_get_tmpfile(mnt_userns, pinode, &fi->cow_inode);
 		iput(pinode);
 		if (ret) {
+			filemap_invalidate_unlock(inode->i_mapping);
 			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 			goto out;
 		}
@@ -2209,6 +2228,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 
 		ret = f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
 		if (ret) {
+			filemap_invalidate_unlock(inode->i_mapping);
 			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 			goto out;
 		}
@@ -2223,6 +2243,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 	stat_inc_atomic_inode(inode);
 
 	set_inode_flag(inode, FI_ATOMIC_FILE);
+	filemap_invalidate_unlock(inode->i_mapping);
 	f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 
 	f2fs_update_time(sbi, REQ_TIME);
-- 
2.53.0



