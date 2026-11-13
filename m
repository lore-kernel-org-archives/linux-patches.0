Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590156;
	b=YjFwBnxH0AvSZ7+kyu/zxNsiwDYsqdgsvX4uq6kfcB3uRsHKFx9Q6ZgU5OREqEIO0PA5
	 Htzj6CdYYGeXWMzgXRW09sQbqbxWTnii3Wu7D31gUIElds2v5k5uzYp1BxmZWdZk/HoWw
	 K7aSj+/dqUdtcobZOVxKhDJMLJV+LK4OFdaKm61IREUtd4A7YzI0Vu7W0XyMenOt1/VT8
	 9tVbiqI8zdMLgarXeEBYn1qyS7rC8k4vtSAtsrAequt+a5JiB0kjEsxpUNHGwVhG+KYuc
	 8KRH/9A+o4bwcyNzI7mGz4yNBhj0I0eHj5NKbRYUvOuzuBqm84B6YQel7R5yNTv8NPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M3H2vbrMI3ljoYE7dkuQ0xhz89rfVFwkrJuG3X6/EyI=;
	b=Yl4YcZEgal75q8L4vpigtpA3hnbtz3aNKC8V2FOghrQY6khjYUmaczRu0QTMh+T/0C9L
	 I1UTyH8LFa32axPLgDi5O8ECWlcFHkuWS8aAtMkECWpBVJM/Qwto9BhtZuJz+Or+Bkve4
	 Wmc2PPB69u900A7kD7X/Qn0d/HhgLZv5mHIkXNOJYePr8IlIZcOdqBdV87D6Bi+DuD5P0
	 zTSkJyZ4/GTsxoYf+ibIVD2Rmuwfs53o2+SJVu5s0QOQvdOAWinUf068P2FBdtHUwMXce
	 UZk5msXJK3dp0sy/RjkTLNUC6ksNF+QZgE1AdRuPlwlVhqttFH6OfcxnWTPXIvLlJ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KWnUs8sw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4762606D4AE;
	Fri, 13 Nov 2026 17:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KWnUs8sw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D581F000C4;
	Fri, 13 Nov 2026 17:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590156;
	bh=M3H2vbrMI3ljoYE7dkuQ0xhz89rfVFwkrJuG3X6/EyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWnUs8swlWuC2igxrB06Rr/3jJFRHbVHsQP9qxHS9pp1UA2BlynjCtpmRLz89C16e
	 FzDATESgh4s0lIwSfjZmcsYMW2mtRX5muDKqoif6gA3f+j66T7SZxUl18MoWDerDGr
	 AvKbVHbyGRcsEclrDrU01PjSJi6q5NBP8wMzwT/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/686] f2fs: dont use truncate_inode_pages_final() on live inodes
Date: Fri, 13 Nov 2026 10:45:02 -0500
Message-ID: <20261113153826.665846260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 8211ee75fb8f7..d6798d795e3d3 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2431,7 +2431,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 	fi->original_i_size = isize;
 	if (truncate) {
 		set_inode_flag(inode, FI_ATOMIC_REPLACE);
-		truncate_inode_pages_final(inode->i_mapping);
+		truncate_inode_pages(inode->i_mapping, 0);
 		f2fs_i_size_write(inode, 0);
 		isize = 0;
 	}
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 46f14f891843c..c0ec2715408e8 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -193,7 +193,7 @@ void f2fs_abort_atomic_write(struct inode *inode, bool clean)
 		return;
 
 	if (clean)
-		truncate_inode_pages_final(inode->i_mapping);
+		truncate_inode_pages(inode->i_mapping, 0);
 
 	release_atomic_write_cnt(inode);
 	clear_inode_flag(inode, FI_ATOMIC_COMMITTED);
-- 
2.53.0



