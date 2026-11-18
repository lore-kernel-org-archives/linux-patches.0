Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054538;
	b=G6tXFd75Sy1SWzMsg0OfM5goN29CdjLA96ATOI53zJyKm+P7u8ztUVpMnIAF8ONxQk2j
	 8elKNBLRS4dVyyErpdQjjpk+b/CpaZUsSDDIhtO7uAfUvlSWv55G1XkTt4Vd6XOATXPA3
	 gn+2rHV2d+qPwAnWGKJCIaIEEj9zaOFSvlj9mOPOTa6ya0c4GQl+xvH50O0bZ1Lh7TadR
	 jkyXprio8uT+V2KBotkSBR+03AdUcTxg3qquHubgf+bVNBFN8GqlnoDejOCZxVHjCwxVr
	 +CGwYjIzIePEKQUQyM5OZkTuWitoVXUIKr34ZXaVz+0TViiI1JkacuDM/fAFiktsh6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M/gaf7ck+cl5dB/zi52Q5UPHlWBe6m3cWlLj35++ghc=;
	b=iKtt0wMWEnFj2NpoiBzrevRNxmhMPTKk7/9HZiavT+gx7DlxoZwEIKv+Q28yMnzCY9Zt
	 fmXUd7JvzuypOPEVZrwaHM5w29YR1rr2FZOGb6Z29iiEO6oCafQuw/wa+OspHHnE3FQa5
	 FGaFFF5g5T2qBKXN/KKoehCE2XtWxBsjfIP9e6fHHxEmgQMrS0+H3AeqSRddr9cxe0eo/
	 UQSWUTs8CCw13G9gdUj8X4A5qBTVcf2Q+91GBIvIeTBCXMZCnvFzJhquZosGKozjNmavL
	 IrzDoZCpLvzzMxqmy7R0Dr1a2cLoSOmAeD7+9MjO2jcGcEYAGlZEsW/ep7AoXXXFO9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JAxk02Ff;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA74D606A32C;
	Thu, 19 Nov 2026 02:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JAxk02Ff
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B6E1F000C5;
	Thu, 19 Nov 2026 02:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054538;
	bh=M/gaf7ck+cl5dB/zi52Q5UPHlWBe6m3cWlLj35++ghc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAxk02Ffa8/LFlgFpg+TDlCKUbVgSIr5TghJ1gW2Uxxks/4MSkHYcbYbrr23QnTJh
	 ypclqkP6PVqtQA2aCbQ1e30OI4fIGcwWnY68n0JUZUFy50pJUO5HIwa29ygJTWmXai
	 Gn/Q1ZYT1ekINgxTg3pKHbMIPoIu7O2OUFTWQiL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daejun Park <daejun7.park@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1310/2214] xfs: cap the block count of xfs_iomap_write_direct() at one extent
Date: Wed, 18 Nov 2026 15:49:46 +0100
Message-ID: <20261118150103.910744013@linuxfoundation.org>
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

[ Upstream commit 66d1ce09ebd72709f8d739630c39f440445173fd ]

xfs_iomap_write_direct() reserves blocks for the whole count in an
unsigned int. For a pNFS layout the client chooses that count, and an
RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.

xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
the count at that. nfsd asks again for the rest. The other callers get
the same mapping as before.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Replaced XFS_MAX_BMBT_EXTLEN with the equivalent MAXEXTLEN macro in the added code and comment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 093758440ad53..920ce54d00055 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -202,6 +202,14 @@ xfs_iomap_write_direct(
 
 	ASSERT(count_fsb > 0);
 
+	/*
+	 * xfs_bmapi_write() maps at most MAXEXTLEN blocks in one
+	 * mapping, so don't reserve blocks for more. A pNFS layout range
+	 * comes from a client, and its block count may not even fit the
+	 * 32-bit reservation. The caller maps the rest with a later call.
+	 */
+	count_fsb = min_t(xfs_filblks_t, count_fsb, MAXEXTLEN);
+
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-- 
2.53.0



