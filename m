Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698D615A85A;
	Sat, 12 Sep 2026 15:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226191; cv=none; b=COj5DWnfuhYOjZoeLsa4F/ZmBBMjfUI+YURnV8nLgw8aJm74DbDaJPyw6TfqlMpkI2LPIe1koWlHxTJxFyYK8EyE1Ki5L+sJgab7QBqWaK8oL/Bak8JnD6LbTfvcHWcC72S47m7JeVa2c4Mb4tqY/XJ+ZC8+aTXHzJzxdQP9nG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226191; c=relaxed/simple;
	bh=UT8Mm8y0qzrmYOaUO2GjENyDY/JAf3jhC5ICBx8gdyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIUxjxZmRIKtKr+PBPGBuoXJAQ7c3kRArIEPshJBxUKqnmAtKLxL676qz5DLWd1xC85IYQOwaB7ViV7aF+m1JD7c0ovJ6d06fxJph/xiYnU5Ygm0yurpJT01IT6UXtKlitOkwdULLDVqAftlLW6SBq180wSa+2aKN3bmoMkSe8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwFwjOnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwFwjOnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E18F1F000FF;
	Sat, 12 Sep 2026 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226190;
	bh=ST1uKYZg5UqwuHqLr2sVtoQ03rmQpMHpmOq+GAIPw0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwFwjOnUrDOd90riqn3NeCEamlujurj8ODiOzKrsa0qNSEntFfY3dfdLpLqBJtuEn
	 XnrAEKNy8DPu05LW8+w8tBmUKmwxiSNazYGG/chdK5p9+BGD0WUgfT3tFUn3JEd+O7
	 UrozoOftwFE4N1T8nxHaNblndUgucSUB7VucnbEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1351/1424] octeontx2-af: Fix TL3/TL2 link config ENA clearing
Date: Sat, 12 Sep 2026 09:03:03 +0200
Message-ID: <20260912065637.518174055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Naveen Mamindlapalli <naveenm@marvell.com>

[ Upstream commit 9edf8d4876e8a2471e66f54d36208eaff2858392 ]

Clear and restore the ENA bit for each TL3/TL2 link entry during
SMQ flush instead of repeatedly using the same link index.

Fixes: 019aba04f08c ("octeontx2-af: Modify SMQ flush sequence to drop packets")
Signed-off-by: Nitin Shetty J <nshettyj@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260821055445.2517568-1-nshettyj@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 095c339166b51..d07deeb53a53e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2252,8 +2252,8 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id = 0, lmac_id = 0;
 	u16 tl2_tl3_link_schq;
-	u8 link, link_level;
 	u64 cfg, bmap = 0;
+	u8 link_level;
 
 	if (!is_rvu_otx2(rvu)) {
 		/* Skip SMQ flush if pkt count is zero */
@@ -2285,7 +2285,6 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	link_level = rvu_read64(rvu, blkaddr, NIX_AF_PSE_CHANNEL_LEVEL) & 0x01 ?
 			NIX_TXSCH_LVL_TL3 : NIX_TXSCH_LVL_TL2;
 	tl2_tl3_link_schq = smq_flush_ctx->smq_tree_ctx[link_level].schq;
-	link = smq_flush_ctx->smq_tree_ctx[NIX_TXSCH_LVL_TL1].schq;
 
 	/* SMQ set enqueue xoff */
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
@@ -2295,13 +2294,13 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	/* Clear all NIX_AF_TL3_TL2_LINK_CFG[ENA] for the TL3/TL2 queue */
 	for (i = 0; i < (rvu->hw->cgx_links + rvu->hw->lbk_links); i++) {
 		cfg = rvu_read64(rvu, blkaddr,
-				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link));
+				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, i));
 		if (!(cfg & BIT_ULL(12)))
 			continue;
 		bmap |= BIT_ULL(i);
 		cfg &= ~BIT_ULL(12);
 		rvu_write64(rvu, blkaddr,
-			    NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link), cfg);
+			    NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, i), cfg);
 	}
 
 	/* Do SMQ flush and set enqueue xoff */
@@ -2322,10 +2321,10 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 		if (!(bmap & BIT_ULL(i)))
 			continue;
 		cfg = rvu_read64(rvu, blkaddr,
-				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link));
+				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, i));
 		cfg |= BIT_ULL(12);
 		rvu_write64(rvu, blkaddr,
-			    NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link), cfg);
+			    NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, i), cfg);
 	}
 
 	/* clear XOFF on TL2s */
-- 
2.53.0



