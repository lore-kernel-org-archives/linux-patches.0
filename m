Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046422;
	b=gw6XJ51rvZAjjyeaJ3H8xU+6vRW1O8LhrTmjSNOxVe3VH1ZRU+NGCrPymQFxE8JVWQgm
	 gzVJuuhClqgdp0ChInpqNNXG3/9naUIp6kraYBwPKUD15TtfiVZnPK/p1WxlUQa7EY7Zi
	 1n2Mp2eJIP7pbHmY8Y4aQaEB9KKXo3oGKS08e4sJ86NDfByHjQDkcm1r20fdRUJ17SeHs
	 ED75EUgJJdxZh0AZabPUzQ61DyMVYR6Z/MI1S+VnkJ/ivy1xuNOQlg8aDcjXuk/olY5GF
	 KJsYdbvUvj+jneC6T4X1CcIZaudbx+uMQUi47u+nGxDGt8ATo+WVC35M25JwbSUrZSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hNRotaif4y6Jk7SMFQMk/7N8+NagZ1RPdPFYOuJ4Lv8=;
	b=LUvntpDMeVOOzWvOZhXQeI/HvpXPtJY6HeOccve2fNFzamzaIQBpC5X6JfzaMeok5x+h
	 yMVuSpq2popunXwZwwBRWP+nMapBHKTFNWAqIpPQ/yCkfHLj9vbOWInXpuranyEh5sgJc
	 4RxGCa1TT3poc5rM95eoKAROas2bS6WL7PjnleD1J3MXmP5RL4Z9l+rmcHbVamAlIjAQ7
	 v14R47CKygliO1c34sTxQ5Yop4ZMnsmcsf66H/urfdG8OCoUUK50iEV6SYGD3+t94LPQp
	 ZxjK1WLEvx3rcHuD5bjERuiSLbLHF4u2pBOGGY7XnLJk+Dl6Wc5n23sFunGb4pW4MJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q32Wx5Q1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6183A606A320;
	Thu, 19 Nov 2026 00:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q32Wx5Q1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9CC1F000C5;
	Thu, 19 Nov 2026 00:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046422;
	bh=hNRotaif4y6Jk7SMFQMk/7N8+NagZ1RPdPFYOuJ4Lv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q32Wx5Q1bReT+L7crUHeO+s1k3925V5EDoxil/Flx9yANIBgQJGAxKzTMnzD/bE75
	 OTJVDkgdPsY+jbk7QpdMjFX5J0/x4WTVVfOVi0A+y/widmU8lX4JaIPOIZGgD581fP
	 E1p5mmMs2brncsR0Utmubx+k0mpmnYXct+Iw4ZqM=
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
Subject: [PATCH 6.1 1275/2857] xfs: clamp the pNFS layout range to the maximum file size
Date: Wed, 18 Nov 2026 15:38:29 +0100
Message-ID: <20261118150247.423246631@linuxfoundation.org>
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
index 8ee7ca4201f0e..c51d29ef450d5 100644
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



