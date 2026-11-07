Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064753;
	b=TcybtuK4/A7oEHZYdbBcKGJlMXAPmGyOFKEgCvwpQtHU6RW/QqmpOJLEWMOJcgSGrklT
	 OI2JAEXDPu8QJtAel/9slz1yAUqUzL6WuDmMHaCx7e48snfHPK2xbqFDTyMSuQdbx2ido
	 LtuGh+CEsDP4CQkHwg4ByHNE6ulGS9VF0OSOcLRbwDMGYLtZtf5Qk7rfO74k3lwOckO6X
	 Gpj8ZI1kVhX4cm9AxpTnEraZfXJ9DYoRjw4rrj924Qey+A858sVneFb9Afro9LNImrZwe
	 6J2zxRcreONhY/3VG/F0K3z0vhG8PnpcN9OozqgotkGT4FJA4ZvzoY9uR40MP66YOGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BD2//g3ulO1XRe6+AotS4vtiSExoIk7vikd2dw2+DYU=;
	b=TpCngUmv/hL1BExg/9Fzy48L+o8zdhIiE3PF0Bn/qtYA1F0WybTVlhUN4kVfY3nK5Xjr
	 7Ev+REwR9VSVDiNEGXeOFVrUE4m7iQFlZ/BqtCmYP+ddVmRGw26mJvvc3wyleqpfPCgIY
	 0Uxop/0pDTbzKyRGEh7m9HiVvPSBJH8jPK6I1PLSe/EJX88YYZgTT9stm/3PIolxtuKmJ
	 NdwzbjCBTnF37IVWRkNTZGJrgqCi+88K3yUfLV4PiUCyDHJMQ5P8n+KBcQCQwu0/lBjUu
	 k2ngV1swlqzkh4e/p2Rip5D3pLxCtxdr1SBMmtbJSgOUCDuoiVwMAAGvhEFWaC0ZJ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WPXvXFy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06BF606A334;
	Sat,  7 Nov 2026 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WPXvXFy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1A51F0089F;
	Sat,  7 Nov 2026 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064752;
	bh=BD2//g3ulO1XRe6+AotS4vtiSExoIk7vikd2dw2+DYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WPXvXFy22lMVL6k4GEu8h+wnNqajtaVn1HQfT38BOqtuOV8/H2cW/krDi4zZnh/j
	 Z6iBMBObwoTVbqPo2b3UtWPwnJkUduLe6bVdjkkeJ4veLxC/RmB5HEKTOyF5E9pRMR
	 LAPbHu/+7lQ9EzOqJUSe1N8rZAk6OgNuB9DyX2jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0726/1257] f2fs: disallow mmap write and data-modifying fallocate on atomic files
Date: Sat,  7 Nov 2026 08:50:22 -0500
Message-ID: <20261107134959.314104627@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index da7564e4904f0..fd72eb4563de2 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -187,6 +187,17 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	file_update_time(vmf->vma->vm_file);
 	filemap_invalidate_lock_shared(inode->i_mapping);
 
+	/*
+	 * mmap stores bypass the COW inode and would break atomicity. Check
+	 * under invalidate_lock: f2fs_ioc_start_atomic_write() holds it while
+	 * flushing dirty folios and setting FI_ATOMIC_FILE, so either it sees
+	 * our dirty folio and writes it back, or we see the flag.
+	 */
+	if (unlikely(f2fs_is_atomic_file(inode))) {
+		err = -EOPNOTSUPP;
+		goto out_sem;
+	}
+
 	folio_lock(folio);
 	/*
 	 * A concurrent buffered write can extend isize, so we store isize in a
@@ -2107,9 +2118,11 @@ static long f2fs_fallocate(struct file *file, int mode,
 
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
@@ -2397,6 +2410,8 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 
 	f2fs_down_write(&fi->i_gc_rwsem[WRITE]);
 	f2fs_down_write(&fi->i_gc_rwsem[READ]);
+	/* serialize with f2fs_vm_page_mkwrite(), see the comment there */
+	filemap_invalidate_lock(inode->i_mapping);
 
 	/*
 	 * Should wait end_io to count F2FS_WB_CP_DATA correctly by
@@ -2452,6 +2467,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 	f2fs_i_size_write(fi->cow_inode, isize);
 
 out_unlock:
+	filemap_invalidate_unlock(inode->i_mapping);
 	f2fs_up_write(&fi->i_gc_rwsem[READ]);
 	f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 	if (ret)
-- 
2.53.0



