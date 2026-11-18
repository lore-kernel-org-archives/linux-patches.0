Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059104;
	b=nt/5JwNT5lNxVTZTY9Dr8y+sjAH/7q0uxVyF41ZcStvkqn1PlnRON2gqnh9oM4y/GEWg
	 KnLBO/FB7Q360l03jHuYvkd++nbqML/z0tD5CJ0mtRhkK1B0hzdnbC0c/i64I0nNbrXy8
	 yuMXmpGzfIPaTNXos6mup9U+/8Ri3L09PVVYnPMcQTqqQAuc6TOJxLiIOcfj0CM3ttkr0
	 YvRC3IoIkklFtSofdcbcS10OUiy3ZGzpmrgSSzajnW2oIX8jvkcYEnxhbm/ULnS/zHID2
	 GMk/W0YhtBWYNMDLzZisMKWwwmy0j078pr/COZwyaLDOguBt5eEvQpUMj/+YTpSGNkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UXW8iDH9V1FP6+v+RBGMWwHY6wbQp7tYt4YTOj0J578=;
	b=NnSzP7ZBx+980zwE/GpU8b7tyT++jHGRkNN66LoSFZlNhSN/SuR9L3ISyIeXXFqCDcDv
	 CTVoaYraY+otUpqhxuRaVi4j16OmCT6DWMGiDSqwdgxHXlE7qsRAznTwlnM2V4Amn1+2U
	 8lZF4pVKbCn43hHZCFf4rpptJdg1PFEVX88rmVwkQ2E2c/IFoVwXBWIkX5UxJa66G4ir3
	 F56u0T2YuKf14r6PTcXfYFC0506sKpnN6kcT50LZOBr6G6vwzEr31ceEXLu6z0Lmcz3wP
	 O7/R3R+8NVV34pSMdLCfmIOtNjrSJ6IWZrJXHtYatrV+ssai40cvJbA0+qJx5d08GTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V6/2oeQh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9585F606A325;
	Thu, 19 Nov 2026 03:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6/2oeQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32B91F000C4;
	Thu, 19 Nov 2026 03:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059104;
	bh=UXW8iDH9V1FP6+v+RBGMWwHY6wbQp7tYt4YTOj0J578=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6/2oeQhin/Bgrx3TGvlPWP0IomK5xWLnLqbwhF6g141EezCNpUcNRfSOg35C8IB8
	 yUBpUdrBG4/v3TJAtHTOsnDU2hjuTNj6XQJBqzi1vv/U1tWWEeB6f/nvjto5jiD0BX
	 KXY5wYxSBmRZ9OBv62HHPQM/+0C1TpDq9CEHZQUE=
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
Subject: [PATCH 5.10 0724/1848] xfs: clamp the pNFS layout range to the maximum file size
Date: Wed, 18 Nov 2026 15:46:02 +0100
Message-ID: <20261118145946.319217461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8b82249b48110..e02a6b84c609c 100644
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



