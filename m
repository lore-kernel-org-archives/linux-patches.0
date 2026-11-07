Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065132;
	b=3B/xnj/rMT/VacQaYwJUokNqpcyL962HU/uDpm/yYG3ul4uEo7YYQWONSgDH7Y2GMjMh
	 lNKAnWH4kCL1lljZe/aPlBk3KHypqjjACzWRFamZdNvCgmB/f3FO+iR4NtmelgJa43MZF
	 WqNedh6pnpeVDqeqK1WlD2RbzHixT3N/Sx3GAOz57hGprqkWKIZOWjQAWgMw3RZ2QRTE8
	 A/IpD91jfbXgQaC8Ja1Gqk80fY0ntOTb5Lcm+bMBcVsf1UNu0S5Vw+MuRXGAMt1xolmPS
	 a8KFwwrN63zzp3IcGdPnfCTVAiA46B3RM7aFButms0U9F/m95MEQuaUo9uxkP3BrifA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=alMPjnPMlHg+mep7bkouJT6UbZisnct09uuI9KEqhao=;
	b=wD97egciIe56iBDiEuqv5evp7OLOAOmbMZoEjlDQ31TFYTBAmsDmm5ope8/ShAS5WzTh
	 GFtCn4F2P9+PCm43InhuBIuFZ1o8SRbwz4nOP56wZ/TeSEBr8mDlMcwuqjLcF/FGjGPLp
	 +506iMqSvgKz4qxNDxwqLSUiOjbkDxhq/Td2z5hulumhOc1ENLKnhYt4fZt+kWBljVegE
	 Dn9BakdCeYUsAc+naDphwn6tFxrRP1OWwUmi/JDBG49uiL1EYVdXH1BPMJU4UZfarMXKK
	 sxcbcJJPbWmZzlJBUzetSs9qML+7IYLrAdokHmr3+bVB84JJdlEP5abF7AfWi4ZNlYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFCyAhMi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF68E606A32D;
	Sat,  7 Nov 2026 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFCyAhMi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ADF1F0089F;
	Sat,  7 Nov 2026 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065131;
	bh=alMPjnPMlHg+mep7bkouJT6UbZisnct09uuI9KEqhao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFCyAhMiD/e6ftMHG1SbLcmiYsy/qWYX75c7Myq6p/DNdq5GLtBv/n/o4FLNVSwta
	 qiqbZrT+Lf6aygg3wB1XNvRTxDZPgRPHtipG/yOiu34t/JZ4MT/smdu5jlxgD9WPy1
	 ufiv2CN9HauSERf4M9fWW9HmkwQhLT7FGZQlUiao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0952/1257] f2fs: dont use truncate_inode_pages_final() on live inodes
Date: Sat,  7 Nov 2026 08:54:08 -0500
Message-ID: <20261107135005.639360896@linuxfoundation.org>
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

[ Upstream commit 74bbd6ada01f91fcad60608e0417bf45a9fa99e6 ]

truncate_inode_pages_final() is meant to be called from ->evict_inode.
It sets AS_EXITING on the mapping, and nothing ever clears it, to tell
the VM that the inode is going away.

f2fs calls it in two places where the inode stays live:

 - F2FS_IOC_START_ATOMIC_REPLACE uses it to drop the page cache of the
   original inode before setting i_size to 0. The atomic write then
   goes on through this inode.

 - f2fs_abort_atomic_write() uses it to drop the uncommitted data. It
   is called on eviction, but also on the last writer's close in
   f2fs_release_file(), from f2fs_file_flush() when the atomic writer
   exits, from F2FS_IOC_ABORT_ATOMIC_WRITE and when
   F2FS_IOC_COMMIT_ATOMIC_WRITE fails.

Other processes may still have the file open or mapped in all of these
cases. The mapping then stays marked as exiting for as long as the
inode is in memory. This stops reclaim from storing workingset shadow
entries for it and breaks any code that assumes an exiting mapping has
no users left.

All we need in both places is to drop the page cache, so use
truncate_inode_pages(mapping, 0) instead. The eviction path is not
affected, because f2fs_pre_evict_inode() still calls
truncate_inode_pages_final() after f2fs_abort_atomic_write().

Cc: stable@kernel.org
Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Fixes: 41e8f85a75fc ("f2fs: introduce F2FS_IOC_START_ATOMIC_REPLACE")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c    | 2 +-
 fs/f2fs/segment.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index fd72eb4563de2..c477e6d153145 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2460,7 +2460,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 	fi->original_i_size = isize;
 	if (truncate) {
 		set_inode_flag(inode, FI_ATOMIC_REPLACE);
-		truncate_inode_pages_final(inode->i_mapping);
+		truncate_inode_pages(inode->i_mapping, 0);
 		f2fs_i_size_write(inode, 0);
 		isize = 0;
 	}
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 381b0a9875946..f3a73b6c24c3f 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -194,7 +194,7 @@ void f2fs_abort_atomic_write(struct inode *inode, bool clean)
 		return;
 
 	if (clean)
-		truncate_inode_pages_final(inode->i_mapping);
+		truncate_inode_pages(inode->i_mapping, 0);
 
 	release_atomic_write_cnt(inode);
 	clear_inode_flag(inode, FI_ATOMIC_COMMITTED);
-- 
2.53.0



