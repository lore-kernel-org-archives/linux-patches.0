Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053482;
	b=gB3mo5WY43O+YKzaXGz2IDgmEOpOLAmRMQOURJDoap2Vday+QH0/dQL7Hj0EHjRxBgLi
	 QDihfb0Hl4vh3X3n5jFnmNox6DJ2rs8H92q/PnQccTXAuqF1Zkv9I1cFToM07l2RhD2LG
	 /uOb1hC/Q7yQM5JPX2GNmO4w2rPrF7GEy31jmTHrSC9YfLwUvr8qAgfxksuqvkqRosPPl
	 oLfeclzmlbVtZPVJbae3CJIa/SPN7bsLnZewTFt6Y17p3+YTa0Y6UE46dtw4+8Pn7xSI9
	 91/oV7py7wcsf2txZsSFPH/5ihmAKNSGqXwCXDJMxdnEMi4WlNtHTYuDk29JDR93mxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+1LoJGI80mzHT0Q5PZHJiDpaOea6k28cDtEHqHBmtcU=;
	b=vX219SPNoXT3rb16z1ammaOwC09rU4S+2Pky5BXcJfFEYzDTs0BCXScFBOA9zGDfy08j
	 TsV5fs0fcqA5s+MG5xp6JPT01UT+uhF+AGJomkX0uQmKbUpoKuLLi8p4jqlQcv1ugqSUb
	 CpnWvbxA48fCiVhww/Cu0AWQKWVaky8vUvT1kc0xfnBaORb2X7SsFsalGWk+yRysa3Icg
	 vZRMhZN7y2iZF3vrz4+uOL/UccKPHv6aGc9cR/6kSce9o3Srz8VpnJfhUE8Ph8WaY3bya
	 wPyHe9GjnFur3HqWcEUGPHOmYWOAKJA3SiXt0gJEUWXLnUP8DS+6E34c7PKwh8hljNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcsD9TSP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87C0606A325;
	Thu, 19 Nov 2026 01:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcsD9TSP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454851F000C5;
	Thu, 19 Nov 2026 01:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053481;
	bh=+1LoJGI80mzHT0Q5PZHJiDpaOea6k28cDtEHqHBmtcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcsD9TSP7qzZ42uHzZBV+/k/KOO0uU3kYEPaB21kHP6dcch5msL8BV5Um8DyLU7kf
	 bKn3LzwNt3RaLt9neFxv6RLdt9l+ndRM/cYeh5zWWovOdbAKytOnYBtpc6OArve4La
	 DAJuE5WXIt/iHG/mtRMlRpDzv+Nl/W0Gr5tzx4mg=
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
Subject: [PATCH 5.15 0895/2214] xfs: clamp the pNFS layout range to the maximum file size
Date: Wed, 18 Nov 2026 15:42:51 +0100
Message-ID: <20261118150048.087533471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7f950cf39e4d4..0bf547d730990 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -124,10 +124,9 @@ xfs_fs_map_blocks(
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



