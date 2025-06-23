Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E342AEE4;
	Mon, 23 Jun 2025 21:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715041; cv=none; b=U2nYoFEj0JHWJg45s8R5LxKbMxVHDakG16tR4G9trfG4ZUHz1cRFI6Km3eCiOULBKene5z/Y+GEy0O6tTP/+itTIcK6wxSn8IxB9PZRPfdGD50PmwIPGcXRrLD5jdAiO4igT80fPaT0Co9dUjKMq9kLGpFEsM4LDoZkLRzV2Y84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715041; c=relaxed/simple;
	bh=m2c7NNtOAO8hDRzvFOt4s5+J2tlGEpxOR/6crDljpyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiLZ4BzPhHyvTU9xwyc4WcQJawYFQ5mTi5D2kSfYoMxgZQ416O84bZyfxu93VObKKdfl/SEDGcf4fIXRcVy/RgUsnn7n3H9CZW5MIZsWCfITwr6CrLIqy805viyT/uGPZyl6+d1/QlxWxYytFEsOvq5yRQvX4zrQkuhjSELs3W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0qkY+s/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0qkY+s/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CFBC4CEED;
	Mon, 23 Jun 2025 21:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715040;
	bh=m2c7NNtOAO8hDRzvFOt4s5+J2tlGEpxOR/6crDljpyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0qkY+s/IihUU6po/Ie2Aqsb8L933FcGrwTDJxVWqmgK9yrte0fDesfX2lKNAtHJU
	 L7apZZEmcsBJZqjfDzY/qJpdzAzY99nmuq07Obto+a+O+YcaDqx4iII4GGT9snWn2H
	 V5R81oPnftncMAc5uF2A1PmO4QYHeZz5zCKX9ico=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wozizhi@huawei.com,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/508] xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code
Date: Mon, 23 Jun 2025 15:04:16 +0200
Message-ID: <20250623130650.457031945@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 6b35cc8d9239569700cc7cc737c8ed40b8b9cfdb ]

Use XFS_BUF_DADDR_NULL (instead of a magic sentinel value) to mean "this
field is null" like the rest of xfs.

Cc: wozizhi@huawei.com
Fixes: e89c041338ed6 ("xfs: implement the GETFSMAP ioctl")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 1efd18437ca4c..a0668a1ef1006 100644
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



