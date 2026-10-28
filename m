Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209247;
	b=g0qFRa9KNSYn5XtTk+wrq46k5iVJ3HN2cBm0x2skigvju+WKIm/XbH3J0dfasY0CyPFe
	 XyzkpnP99vKTxb2OLXwg2x3xtmP18WfckHG1rcSZUBSWXGuRRP+X1TiOt7DBzcN5cpcuG
	 vwUYCwKEC7ov8JpXiHrDaFpLGAVjIi73gjFpBLaO7oKVHNuJwJvdPl4gd10nN3PgN2E7L
	 wEoI7z/giic8h7BExLcysgQVAWcXAYaisFU6b37jGoNMgGzDylG++mlNVREyduXxvMAu6
	 VTULCSNn3kR1y35GWnJDjsTnN/PZNdJaIGAOxsVqRP2cKjWBlzRI7rbS5z2SVmIooEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KkiZp/FkNl99OeawCYi1R05r8BrYgK2DbjzZwK6p9Zs=;
	b=oAATB9GRBHyx1e5YPXODPBmqk8Kt37dWREXo5ZuA7W9wgPx6JhlHPzB2Ro5eAFy6MXCm
	 o8PbDUzTNCScggzzgd9/l2K5defnn0uJn+coUrNPQ01Zha1i+mWRtUEWFCnHdtEISZA4j
	 1PVqEvLix6ig696qU1D70Sr25iurD+jKAl24L+06+rTypQGtWIwSjvFY53wLPkcGwE4Kr
	 sKxovcE1EWx6eh69UeLReZw3B7ibXfd233KmdHx1F7nkRt28o5Q2RBSVKL9b3gkRQGhVe
	 Iv66cjB5HdIK8tuI8PyOxvYUPUS6Ghll5C5vtZGTv0fYaC2txxMR3szCLp1jjjtuX6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4bYvVff;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFE9606A31A;
	Wed, 28 Oct 2026 17:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4bYvVff
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6181F01825;
	Wed, 28 Oct 2026 17:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209247;
	bh=KkiZp/FkNl99OeawCYi1R05r8BrYgK2DbjzZwK6p9Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4bYvVffM6laoNGIcb+k2EK/WqV8tv5NLnSguMl0vLeQ9tturnMQdmgkAHHBPxuIN
	 uROkfCHfCLBOzSuskRKsIyH7ZgSXorHlZ/b6nKzyPrss4Ws0IF+XDpIIQvdz38y/rG
	 pAE9gcyH6YvG4z75+lgWnEvcI1NwRK0r4aZ0eEbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 403/516] xfs: hoist recovered bmap intent checks out of xfs_bui_item_recover
Date: Wed, 28 Oct 2026 17:59:15 +0100
Message-ID: <20261028170013.027820581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit bc525cf455dac810d28f9edd379805dc249bc5a9 ]

When we recover a bmap intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_item.c | 74 +++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index a3b350437db26..88d28a862f52c 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -418,6 +418,49 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.cancel_item	= xfs_bmap_update_cancel_item,
 };
 
+/* Is this recovered BUI ok? */
+static inline bool
+xfs_bui_validate(
+	struct xfs_mount		*mp,
+	struct xfs_bui_log_item		*buip)
+{
+	struct xfs_map_extent		*bmap;
+	xfs_fsblock_t			startblock_fsb;
+	xfs_fsblock_t			inode_fsb;
+
+	/* Only one mapping operation per BUI... */
+	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+		return false;
+
+	bmap = &buip->bui_format.bui_extents[0];
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
+	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
+			XFS_INO_TO_FSB(mp, bmap->me_owner)));
+
+	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
+		return false;
+
+	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	case XFS_BMAP_MAP:
+	case XFS_BMAP_UNMAP:
+		break;
+	default:
+		return false;
+	}
+
+	if (startblock_fsb == 0 ||
+	    bmap->me_len == 0 ||
+	    inode_fsb == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    bmap->me_len >= mp->m_sb.sb_agblocks ||
+	    inode_fsb >= mp->m_sb.sb_dblocks ||
+	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process a bmap update intent item that was recovered from the log.
  * We need to update some inode's bmbt.
@@ -434,47 +477,24 @@ xfs_bui_item_recover(
 	struct xfs_mount		*mp = lip->li_mountp;
 	struct xfs_map_extent		*bmap;
 	struct xfs_bud_log_item		*budp;
-	xfs_fsblock_t			startblock_fsb;
-	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
 	xfs_exntst_t			state;
 	unsigned int			bui_type;
 	int				whichfork;
 	int				error = 0;
 
-	/* Only one mapping operation per BUI... */
-	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+	if (!xfs_bui_validate(mp, buip)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&buip->bui_format, sizeof(buip->bui_format));
 		return -EFSCORRUPTED;
+	}
 
-	/*
-	 * First check the validity of the extent described by the
-	 * BUI.  If anything is bad, then toss the BUI.
-	 */
 	bmap = &buip->bui_format.bui_extents[0];
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
-	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
-			XFS_INO_TO_FSB(mp, bmap->me_owner)));
 	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
 			XFS_ATTR_FORK : XFS_DATA_FORK;
 	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
-	switch (bui_type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		break;
-	default:
-		return -EFSCORRUPTED;
-	}
-	if (startblock_fsb == 0 ||
-	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
-		return -EFSCORRUPTED;
 
 	/* Grab the inode. */
 	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
-- 
2.53.0



