Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590984;
	b=WX7p+DcOBudh4HzjkbmOpvMZv5Tqu6AX9jrFjecxeVhaT+bpR6keoYycYB7YK2/YTNsG
	 DmoCpY3iZyxs/QideFq2C8k0/ZXI4GDXjR1+9zI1uyJxdcza3wPMniSIBIFuoEkoYw5S4
	 FzNUcjSVF/67z5WnvQayhLpBdfvckVwmUN0a02xqJ20mFpxQnpVPJj06a0OjlO81aQCvi
	 L0wH5BgKWfXumO3NcueaZ5FtKtLqw2xXLzee/QbTVt0lw1bl8DQ022s7uCbEwn8Mw/o/n
	 P08PyqBN642CTfrqCfraWcdSmHiCJwLuPb2F+mzGEfGC5D55YOBM5qlzH8cKITOe6tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QaJYTdZiH/sr4QbYIa9qOgMvoGiVV+HwjuA5Ju9aoBE=;
	b=jZ8rK2+z+Ftl51cSt7rFFceU5G4c8pbLiV6Fnurnqo1SIMFQRoqWE6dzK33utJG50Jdw
	 9hK3x8golV9I9eUA8x+wW84hY14KS3Mpsiu/AMVUipdIbKGqhQNBYH+8CMELPAkyTfyvS
	 KWrKUhA6aYrVFS0YD3Ca0NUz1W7RVbMzGtp4okiurS6IOoL4S1UuPvqgc0bzZKn13/4P2
	 BUs8/uVuBpLj7wvfSABqxdMDq5rWWe30aJqDRIOSh7r57M0AieRy5ETfyuyXDSfRRWBuc
	 ix6qaV7Gw/zUJlIAF/hnac8F+rMF4lFx8RELJU+Jxz438D5o2zloOALLaDTsLgt0h1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jxd1A/om";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E9260703DF;
	Fri, 13 Nov 2026 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jxd1A/om
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7613D1F000C4;
	Fri, 13 Nov 2026 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590983;
	bh=QaJYTdZiH/sr4QbYIa9qOgMvoGiVV+HwjuA5Ju9aoBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jxd1A/omWkEEpjdm/6hAR5MjPtYdzZ9yHeiRu5O3WmFXXVSf2LhivdNV5s9PvBTKo
	 VfYyLme/3JsYF0Mjck7hEO8DJXtiOo+xz6MY0pdzW5WMw3eQ8aHsOfRl4GfM4v6f2N
	 K0JqJHjM47/087p4NFCJbExNFUJYdB8j5qgjzrzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/670] f2fs: dont use truncate_inode_pages_final() on live inodes
Date: Fri, 13 Nov 2026 10:45:24 -0500
Message-ID: <20261113153817.533893136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index cd6e69f09e183..d0d47fc2762cb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2383,7 +2383,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 	fi->original_i_size = isize;
 	if (truncate) {
 		set_inode_flag(inode, FI_ATOMIC_REPLACE);
-		truncate_inode_pages_final(inode->i_mapping);
+		truncate_inode_pages(inode->i_mapping, 0);
 		f2fs_i_size_write(inode, 0);
 		isize = 0;
 	}
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 49146476882b1..1ef87b212681e 100644
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



