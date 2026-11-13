Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585671;
	b=LOsAe6er9nhVQse30aAqvq9V0/0+8Apl/JoFMsArk+TlPn/cjWGkDb/+2m1jh4xVDwza
	 kc//MEInh/A4oU3J1Dxbnw0gzgWl1UX1QjW1v9ZTRd9pJjeF1SgvDNzi6ZtLQKdlLGAit
	 iq04yIfnWbdK7HHmQMchrNl6/x3iTmPlvFEjZoi4vT7kd1lp/4w4O0crFEOqKhKBwBSO9
	 sL0aGlhw3vkrDD6MRDWPdW4NsREIh3IZkAq0pb03Zy4L8864g9mMuJ6cVt4R5FKfGQHG9
	 URmYTh5sq9Lc3YIpKkeL7+34qZ0FCgyDRFdHBAvqSNvpEYesR7yYOJm4siMiKgWZ6Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JyQBgxCWSqYwugDUnRs9eJqhAj7hdkBix4HVdJAUIt8=;
	b=qpUuk/e9T4Cbtc66UsJqtBcbmLPqfFkJdWrcVt2v5n9F1kbMP9kPVTgN0ajnRhVfC/nZ
	 v7U1zC5VQZcT11zQc1y6oN0AEqq0q+J77iH5dfThXBC209mDOiN16wgwj+0IlfkPRUqiu
	 pW8W/3l+ReEJcMuFU8Ti7jD2+RJmGRvcFTu3sQO3wbkaleBzAdUQD3TqD8GTb+J21P/tC
	 TOjH1218OGch/xk3PuWyrHKdNOJYktncWmw4X1OljLYGgA9ztMQoanuCaIUYOLuEkGuHf
	 pJpK8LKGtiqdFmloRDqPBwI7OiZhD3tXcEl4c8K9VZqN6cPIlERLeCu5iq+HuOeMFzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mV3SCVZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0993606B2DB;
	Fri, 13 Nov 2026 16:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mV3SCVZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFC21F000C4;
	Fri, 13 Nov 2026 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585671;
	bh=JyQBgxCWSqYwugDUnRs9eJqhAj7hdkBix4HVdJAUIt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mV3SCVZaXBDQzrzXdqHGVYjWWH3yQ8qR5vTvT1X6kFPE2x6lGKWkwoc88BLBMPIy
	 bUMwNOPkympZtwIqmvPcHheWyqcV89imw1p9EPq7euqlYViriODXe+xCfg9rSVfXem
	 F2n4CseZfDeS66d/SwtG2bzgcXysmrV/drtAeMyQ=
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
Subject: [PATCH 7.3 285/507] xfs: cap the block count of xfs_iomap_write_direct() at one extent
Date: Fri, 13 Nov 2026 10:49:49 -0500
Message-ID: <20261113153804.899502885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 93826ca74b6be..373ff0e64f145 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -285,6 +285,14 @@ xfs_iomap_write_direct(
 
 	ASSERT(count_fsb > 0);
 
+	/*
+	 * xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks in one
+	 * mapping, so don't reserve blocks for more. A pNFS layout range
+	 * comes from a client, and its block count may not even fit the
+	 * 32-bit reservation. The caller maps the rest with a later call.
+	 */
+	count_fsb = min_t(xfs_filblks_t, count_fsb, XFS_MAX_BMBT_EXTLEN);
+
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-- 
2.53.0



