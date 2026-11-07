Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062358;
	b=Nr3QjW07kLiHbHWWhG2Ttg7vNEbLl4AesjFWDo4Hetd4xl9Kla9zDBHvgxv0IjgC2LYb
	 L+9q7CIG0KEkWAI42YR1Vx8fxnEGh/1l4YBi3AXn9EhxU4icyVPjxiVXtPf+DDYYMsPcD
	 b8t3HoSKJvhxDvouz8uOyBJPdTrqXGid8PuJ6uAsH7U3DAKgBkA/jJLjSsTLuv5I5veE5
	 UlRfkjRvPac3qxLhzkFUDVj+8N1SPmo3ZoovkYD5ZWSOKOIKzay5w5dS4hT+iHX2zjdod
	 TBgihjtpZTx8CkQFVg1H6bMgd0puYlYj7uS9o8qRiRtqgO1rVrOkPSlrHkGxrXJVykA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HyfBEsowucCwkyil6jO488kJGwufhUjGBDo8pgt48f0=;
	b=RKQdYSu5leywgWjE6LeJYmh0QPNAO63DCoTVqHKZLEaoyKxYZCrC83rL14XKiUlUyusV
	 D+JRvrzxmp4tjGvBDYrh235d+N9+EL+9P/RveLWGRCadFRSjJnlaTI5EjsJp9KWw4MB6U
	 7p1myI8jj6JUVmX+Z6RuRxazzdnX7iekt/lrhh7dFgAUwGVuDfLd3BWzisXbmoEbwO2x3
	 zNmW9QIWfOqR8yn4UIbRo+lZrn18RRH9V0Pp+lfSvqXc9ib4LJinu0ERp6i4s+4S0K3Vw
	 9+NSB69UjToc8WhYJm1KSPU7TxLXAI7/8UsIMIIEwnyXfj8J+KOoW2AXHCDYMzJ6X+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qLY1hVBE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC00606A32E;
	Sat,  7 Nov 2026 14:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qLY1hVBE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78C01F0089F;
	Sat,  7 Nov 2026 14:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062358;
	bh=HyfBEsowucCwkyil6jO488kJGwufhUjGBDo8pgt48f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qLY1hVBEJXJBUt/+3It2dhf/YHKt65MF01cP3z8k4+qoK9j3CEmht1xz7p4X/7MmG
	 KxSoFz8pNiAx7Og7MuzLxAUsYdoUeUlOwfUedtdmDoWCNQF2HCJo5dRfRHFK2h5Ru+
	 3fbRxkCwY/D7WEEKTD3CGbPMGi7+SIHdt6lULFyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1277/1536] f2fs: fix defragment writeback range truncation on 32-bit
Date: Sat,  7 Nov 2026 08:54:53 -0500
Message-ID: <20261107135033.645258649@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 92154fe28c3701bebf75176dc5522bec62519a8f ]

f2fs_defragment_range() flushes the range it is about to defragment:

	filemap_write_and_wait_range(inode->i_mapping,
				pg_start << PAGE_SHIFT,
				(pg_end << PAGE_SHIFT) - 1);

pg_start and pg_end are pgoff_t, 32 bits on 32-bit kernels, so both
shifts are evaluated in 32 bits and truncated before they are widened to
the loff_t parameters.  pg_end is only capped by the file's page count,
so for a file larger than 4 GiB the shift wraps.

For a 5 GiB file pg_end is 1310720 and the range collapses from
[0, 5 GiB) to [0, 1 GiB), leaving the rest of the dirty pages unwritten
before the blocks are moved.  For 8 GiB the shift yields 0, the minus one
makes it (loff_t)-1, and the range becomes [0, LLONG_MAX].

The matching call in f2fs_collapse_range() already casts:

	filemap_write_and_wait_range(inode->i_mapping,
				(loff_t)index << PAGE_SHIFT,
				((loff_t)pg_end << PAGE_SHIFT) - 1);

Do the same here.  On i386 the shift changes from "shl $0xc,%ecx" to
"shld", i.e. from a 32-bit shift to a double-precision one.

Cc: stable@kernel.org
Fixes: d323d005ac4a ("f2fs: support file defragment")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e85d22daaafbc..8b57b2feafa6d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2931,8 +2931,8 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 
 	/* writeback all dirty pages in the range */
 	err = filemap_write_and_wait_range(inode->i_mapping,
-						pg_start << PAGE_SHIFT,
-						(pg_end << PAGE_SHIFT) - 1);
+						(loff_t)pg_start << PAGE_SHIFT,
+						((loff_t)pg_end << PAGE_SHIFT) - 1);
 	if (err)
 		goto out;
 
-- 
2.53.0



