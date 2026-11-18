Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048235;
	b=Ks/87Y+xxv1jB/+vZzMtkeNZ1DAtVdyOlxUop8rXBJTvqNjvVNY3o5hIN1KgRgOUynIt
	 5aIC43V+qxgzCzx3jUYiXRqudCg2gWiE3XBK8VuQLnNs3AnglAGCNRenORyBUKzkMbT8c
	 igU7fGinLcuMxwhlNOGQFryE704y3dP8QHINZIcB9R57+CONxzXPlafH0FxPbQ+XYQZ2F
	 BYcStvG2xjkRqXzy2jPiyj+pEZqy3PJ2uGZOp0Y3s+0iOTIXSW9fod+TEFwnDZZzh6Eyt
	 wAjvnkCsWP7/hazgWAznqPKuhdKZHW7oXmtjgPeVx5rR8cEjr52CCeqI5XoFyXEhTyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KyU1p/XwG5dJettAg7OAlIRHHfji/JvXiQL+l0nQNzg=;
	b=JOOyiGlMTZ5SzBVhk0MELOonyjkP7JOxYoV/yt8O6MGQpF6erGO0eBpSTdoHBf8o67yR
	 cu28W7SizasHSwW8Cnu/AkLa/xel4mJ74c0PWtNsjHbwqHkEKQZfzcW7ShmxKM3/MNzgn
	 2T4o+4uXoxidFY4wmMZGhJgM1xn763FzN8KNZ4BsrWZE43JmWOs0SyxxWh+CLdCh9zIMW
	 +W9rtImzWV/uDF3ALjOP6WmAb2JFBP2xz83rbYdJ38irNQDxaSiDK2no4GSeQhtFTG0yU
	 Z0H2YSBaS9OaXVAwl71co6J/jKFjUuXw4XnS1XYn4rPgUa2GK9/UJWUyeaQ76lPjm2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yYL0TJWI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847C560A2627;
	Thu, 19 Nov 2026 00:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yYL0TJWI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0FD1F000C4;
	Thu, 19 Nov 2026 00:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048235;
	bh=KyU1p/XwG5dJettAg7OAlIRHHfji/JvXiQL+l0nQNzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYL0TJWIMNf4nHeTB7wWcprImG+5GbIfJLpK50HUabnn67WP4th1H2P9we6k8LmcQ
	 CUiP/ILJRCijMRCJFCK4dNQDxQ/BGCO00pCNB2kzzgVKSV8wA7d6MDCjkxC0leYEth
	 58smIgzs36/4JW+lZiBjQVud4xK8MDHxWNcs2h2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1922/2857] fs/ntfs3: take run_lock when freeing offs_folio in ni_decompress_file
Date: Wed, 18 Nov 2026 15:49:16 +0100
Message-ID: <20261118150310.413756561@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit ad39d8d90fa0fd99b2714d4c84c6f4e1c399f1f4 ]

attr_wof_frame_info() allocates, caches and dereferences
ni->file.offs_folio under down_write(&ni->file.run_lock).
ni_decompress_file() frees the same folio with folio_put() without
taking run_lock. When a WOF externally-compressed file is opened for
write, ni_decompress_file() can drop the last reference while a
concurrent O_RDONLY reader is dereferencing the folio in
attr_wof_frame_info(), leading to a use-after-free:

 BUG: KASAN: use-after-free in attr_wof_frame_info (fs/ntfs3/attrib.c:1619)
 Read of size 4 at addr ffff8880120c9000 by task exploit
 Call Trace:
  attr_wof_frame_info (fs/ntfs3/attrib.c:1619)
  ni_read_frame (fs/ntfs3/frecord.c:2421)
  ni_read_folio_cmpr (fs/ntfs3/frecord.c:1916)
  ntfs_read_folio (fs/ntfs3/inode.c:648)
  read_pages (mm/readahead.c:181)
  page_cache_ra_unbounded (mm/readahead.c:292)
  force_page_cache_ra (mm/readahead.c:364)
  page_cache_sync_ra (mm/readahead.c:573)
  filemap_get_pages (mm/filemap.c:2688)
  filemap_read (mm/filemap.c:2806)
  generic_file_read_iter (mm/filemap.c:2994)
  ntfs_file_read_iter (fs/ntfs3/file.c:842)
  vfs_read (fs/read_write.c:574)
  __x64_sys_pread64 (fs/read_write.c:773)

Take run_lock around the folio_put(), as is done for every other
access to ni->file.offs_folio.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 41a92cca03b0b..7f54f5c712471 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2471,10 +2471,13 @@ int ni_decompress_file(struct ntfs_inode *ni)
 
 	/* Clear cached flag. */
 	ni->ni_flags &= ~NI_FLAG_COMPRESSED_MASK;
+	/* offs_folio is accessed under run_lock in attr_wof_frame_info(). */
+	down_write(&ni->file.run_lock);
 	if (ni->file.offs_folio) {
 		folio_put(ni->file.offs_folio);
 		ni->file.offs_folio = NULL;
 	}
+	up_write(&ni->file.run_lock);
 	mapping->a_ops = &ntfs_aops;
 
 out:
-- 
2.53.0



