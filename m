Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752F713BC0C;
	Mon, 23 Dec 2024 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970376; cv=none; b=YgqeMREQ6fyVuVxfr+tmjRiNInAap2pjEMg6tGAZMByly1pUdGyyuqBRshQD/oJHlBXoXa3q+Q0VwrwPybPpMuaul7GG2fIWR7uffscEmgO4qrm2CmQr+rbq+BdHwq2kFGxy9aZfFB4D2oJzj/62YyUmMZ/2YMHg4mhAIbs4Jww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970376; c=relaxed/simple;
	bh=/nrgwxh2+rZijnk24K0U15WjVTKfCLnHaeDZql+4tAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLiTd0w2Bp5vfBTxYhIkdL80NejUh9oj0Kk+6RxdpvrxRkIJ/xm3Nh8DuEOhPzCTdi7uMFUjizyrRxrhthl0+/7/QQs+XAx1uTysuyuKgA+DySgCZjDdDfjb1Jn16AfgAz6O2rBnICvTP4FLDcb+2R4t+oROSqVKx37Cb2oVtKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPdDc+Tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPdDc+Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96BBC4CED3;
	Mon, 23 Dec 2024 16:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970376;
	bh=/nrgwxh2+rZijnk24K0U15WjVTKfCLnHaeDZql+4tAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPdDc+TwCksBxvJYWXjSbDfJiW624aXFOAAKdgpaF2BtxNtIFDv7C7tqDIhy1cmnR
	 OVoy1GsVUgB2tCj6Abn0ACOtdOJNyg3jctkXonDi8pwYRuXrbi+s1ih+N/XPWHC/wn
	 fyGzGDuYUMe+AEUZwyBculfpw+avigZBawxPGxI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wozizhi@huawei.com,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/116] xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code
Date: Mon, 23 Dec 2024 16:58:23 +0100
Message-ID: <20241223155400.865442578@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 6b35cc8d9239569700cc7cc737c8ed40b8b9cfdb upstream.

Use XFS_BUF_DADDR_NULL (instead of a magic sentinel value) to mean "this
field is null" like the rest of xfs.

Cc: wozizhi@huawei.com
Fixes: e89c041338ed6 ("xfs: implement the GETFSMAP ioctl")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 85953dbd4283..7754d51e1c27 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -252,7 +252,7 @@ xfs_getfsmap_rec_before_start(
 	const struct xfs_rmap_irec	*rec,
 	xfs_daddr_t			rec_daddr)
 {
-	if (info->low_daddr != -1ULL)
+	if (info->low_daddr != XFS_BUF_DADDR_NULL)
 		return rec_daddr < info->low_daddr;
 	if (info->low.rm_blockcount)
 		return xfs_rmap_compare(rec, &info->low) < 0;
@@ -986,7 +986,7 @@ xfs_getfsmap(
 		info.dev = handlers[i].dev;
 		info.last = false;
 		info.pag = NULL;
-		info.low_daddr = -1ULL;
+		info.low_daddr = XFS_BUF_DADDR_NULL;
 		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)
-- 
2.39.5



