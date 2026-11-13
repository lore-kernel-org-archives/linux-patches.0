Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591173;
	b=vmVBibr/a0XXcwKnsIW64oMhVwFBl0mgLIgRNTcvJtTArGrhRxsYwzMyOozIpuGaIl8v
	 CG8gF1E6T2IYF08558h+ZSDDMdOunCXGAd0HpKlYVP+uVUc5PZ066w1dKqf9s7HQLTRBX
	 xjQbT459reoDYiAyt/2Myr2zRBlc6z75GOUHDI31/2JmTgZZVyJXhVDqAycWVtazC8tbC
	 JehPI5pSeuSDvYg5mQzevMmIGx+p+91HwHmVs9MCAaKqnVQFlsTY0ghVjL+jV61252MH5
	 +O32mk6PoIXOc31BKlLTYt5lBZUfqUkD0qiru0DO6K+pRKX5QNNObzZliuKU5i4XSdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=acQkx1QaRP9BMIFB9jGPgBCZlG7/PD78Z+d9DAM4VBU=;
	b=Jx0rxQYmcACOnAtgvRtpLr+vp8QNh8wiEvPcZMq8dDuIht+AztXFRM0EvXpxWiX38X+L
	 8aKp/6NEQm1pPgwSJsgMVl6eWoOJdVXbezg+rOlfHklqr+zfHl2Knr9783yxRw2AGoDA5
	 1XXOhfxdMUDAq3aULpWeZDE8NgbqXJlfM1+uSBYRRPVfJJ0yi/pJnrfDR7Zd6y4sBEr1/
	 GacaDYZJKe5zqHfyHQhZ2u2NWRvN8u1df9TZzCtq0KkCuXibrJGcfpL/t4wo6bxnPRsKK
	 eA5Q+mC6qLBgteeZR/SI3AYOpdRiVIEh9xopS2OxOTLYdD7xUZZNldSKQjGamCWlTDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5XoykDy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534BC6073FD7;
	Fri, 13 Nov 2026 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5XoykDy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031831F000C5;
	Fri, 13 Nov 2026 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591173;
	bh=acQkx1QaRP9BMIFB9jGPgBCZlG7/PD78Z+d9DAM4VBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5XoykDyM6fj2ZVZlJvU0EUKiLNFJxd20RdfbCZYLDefAFMBww/8kAYUNkiFrwekp
	 M9OuO5tbVo0ON0fhKT1kNEgub1MOX9iw++J3E4eOJ2SHcC8fa9B4pXc46u79e073ne
	 j+qH0gyJNNY5BEGMkjaG2vLT6NRAycb56Txk74bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 313/670] xfs: clamp the pNFS layout range to the maximum file size
Date: Fri, 13 Nov 2026 10:47:57 -0500
Message-ID: <20261113153822.510059074@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 29f3c1be4e554c9dbc66e13333034e0947477cb6 ]

xfs_fs_map_blocks() lets two bad layout ranges through. An offset of
2^63 or more is negative and passes "offset > limit". A length above
the limit, such as NFS4_UINT64_MAX, wraps "offset > limit - length"
and stays unclamped. With NFS4_UINT64_MAX, a read layout is built from
an uninitialized mapping.

Reject a negative offset and one at the limit, and clamp the length.
This needs "xfs: cap the block count of xfs_iomap_write_direct() at one
extent".

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index a222410812ac4..fa027574d6de1 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -168,10 +168,9 @@ xfs_fs_map_blocks(
 	if (!write)
 		limit = max(limit, round_up(i_size_read(inode),
 				     inode->i_sb->s_blocksize));
-	if (offset > limit)
+	if (offset < 0 || offset >= limit)
 		goto out_unlock;
-	if (offset > limit - length)
-		length = limit - offset;
+	length = min_t(u64, length, limit - offset);
 
 	error = filemap_write_and_wait(inode->i_mapping);
 	if (error)
-- 
2.53.0



