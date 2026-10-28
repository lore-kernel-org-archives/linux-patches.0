Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209250;
	b=30P/dm8GX4c5AWxlm+ubDfoBkeK1IuKm/n58jPZUis7AZLCw9fHxlKMMGV0kVxkmJaA7
	 7+XVfj3HDtnvjDaH8ZXAQGTmEcIb8ifKVsuD4rKC11TMvDHMJ9ji3GS6TgIleuwn6Pw+P
	 Bv2O8dHhvs5ZE2rc2IKmbcByj1Eqq19+BF2KUzieONJ2Bd+7XkClZwGT6NA29NHag66+0
	 Tn7tNfCcS0lcMmhzpRwSvOlb3SFPsk02S0jO29eVPt6PTfEu0OtTHw+b08hEsIJvxYI3r
	 78arm6OQCY0OLcMOMZyVMC8Dl+6N1YKAiK9WwW1mMfJKXqMnsaQ7INLisxgaGtMp65g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k/TWSqnMHjXtAwjlf6V7JcrtzdwOlV53mlNjM+azlGc=;
	b=K5vUN6m33ZEVBZm0F7QjIJDa+kyJbR3UiAkduhf+zzTmNo91gYtzxJq9TYEvChlpqB5f
	 OwhAWky57/sgvxydcm4WMRo17TTRRdZz5cNMH0wT/zUgymBBskArK+IcNNlrJKYYCFQSL
	 WSRCmRbE8bRoGN3+1ln3PSl2V7qelkWBp9uOj+ELSOePs+ICWnaGp5bjjwYBqgS+DvQsB
	 MlJWnFfD2kUCKJyGRy8iwlk46A4uMDuAPyDEVQuRXz/CId8VRugWDlKlLX9Lp4B2x8pVW
	 dclxsApqf6bx9G7TUYZMPj2qx0/slxQMRsdp0UQmHNgKLT4qr+RXfNkrQdU1f7qdjFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnsW2AjY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCF8606A31A;
	Wed, 28 Oct 2026 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnsW2AjY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0451F01825;
	Wed, 28 Oct 2026 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209249;
	bh=k/TWSqnMHjXtAwjlf6V7JcrtzdwOlV53mlNjM+azlGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnsW2AjYrckIFaiS09ZHVo6ZwxWykQqyBDkV+/8NT1FQbVhAgBgQniv8QItNqy3J9
	 xHP0RtGfGt/OBSwBI8kPn0UskHEALr+aLfNyhgqhLHAgbDwmjHCNTCDmHE3l2ZZbrY
	 mltnkNwICeyNJNXRjq0TZpTGDVVXHyZZA4dbEYFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 404/516] xfs: improve the code that checks recovered bmap intent items
Date: Wed, 28 Oct 2026 17:59:16 +0100
Message-ID: <20261028170013.051283566@linuxfoundation.org>
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

[ Upstream commit 67d8679bd3913d2c4ec5f32ade778881b93af766 ]

The code that validates recovered bmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_item.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 88d28a862f52c..5f1c2fda8e4ed 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -425,18 +425,12 @@ xfs_bui_validate(
 	struct xfs_bui_log_item		*buip)
 {
 	struct xfs_map_extent		*bmap;
-	xfs_fsblock_t			startblock_fsb;
-	xfs_fsblock_t			inode_fsb;
 
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return false;
 
 	bmap = &buip->bui_format.bui_extents[0];
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
-	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
-			XFS_INO_TO_FSB(mp, bmap->me_owner)));
 
 	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
 		return false;
@@ -449,13 +443,19 @@ xfs_bui_validate(
 		return false;
 	}
 
-	if (startblock_fsb == 0 ||
-	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
+	if (!xfs_verify_ino(mp, bmap->me_owner))
+		return false;
+
+	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
+		return false;
+
+	if (bmap->me_startblock + bmap->me_len <= bmap->me_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, bmap->me_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, bmap->me_startblock + bmap->me_len - 1))
 		return false;
 
 	return true;
-- 
2.53.0



