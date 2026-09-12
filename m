Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4A4247280;
	Sat, 12 Sep 2026 11:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212279; cv=none; b=PchK6XIiCdVkG+7FhSl7FfH5GgcVaWBQgUtVNM5a+BXbDWUkON1hpGlGyphIfcDEFbCrqO9KpyM45FQap0xOf9meHrFdwR9dCrWbgn3LkpHihABvkXEEu8hY6HrLOzoS1JDXLzIPi6qKr88oZJ4k9RyQ2p6ig0ZlV32K/ziEIPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212279; c=relaxed/simple;
	bh=8+niCXjZmpDJB667jFym/BBefVEbtmOphD7JeNPmOYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLCkxYPDw0Oh75878uflZT3xqcB2KVGOcjQRCQGckwCSB0TR2UtpLibfBfqMdl77L5n1dceEDsd7V9IzzdwF5zhRrf8PeZlp9mCBh1+LrY3hipUlJrDGc74dfoJNLYJtjemyFpTRHkbzb8XNYJtt70bXg5nBoNNQ8z5Fgt20YZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRLVUJfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRLVUJfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308DD1F000FF;
	Sat, 12 Sep 2026 11:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212278;
	bh=JaeCxbfy8aS79Qc1mbNfHTFsueXyItCnKeVEKHieRSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRLVUJfxHLAVnR8J9n0ASz42K8wzYE3z+ca2Qv3mFkFjZhYWojmI7OkF7Ou9ncJJw
	 OXUo5MN+kgQVjbu3tbiP5ralnTCxef70fx8MUsveq3ABKNDJcDbOaAQPxUZmJwwVYg
	 BKbdWAfrCaVFfFfp5QTV3M92pSpx30HgVaP3cDtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1404/1518] octeontx2-af: Fix TL3/TL2 link config ENA clearing
Date: Sat, 12 Sep 2026 08:59:33 +0200
Message-ID: <20260912065655.306906869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7de06eb8284ac..adedca065210a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2436,8 +2436,8 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	int pf = rvu_get_pf(rvu->pdev, pcifunc);
 	u8 cgx_id = 0, lmac_id = 0;
 	u16 tl2_tl3_link_schq;
-	u8 link, link_level;
 	u64 cfg, bmap = 0;
+	u8 link_level;
 
 	if (!is_rvu_otx2(rvu)) {
 		/* Skip SMQ flush if pkt count is zero */
@@ -2469,7 +2469,6 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	link_level = rvu_read64(rvu, blkaddr, NIX_AF_PSE_CHANNEL_LEVEL) & 0x01 ?
 			NIX_TXSCH_LVL_TL3 : NIX_TXSCH_LVL_TL2;
 	tl2_tl3_link_schq = smq_flush_ctx->smq_tree_ctx[link_level].schq;
-	link = smq_flush_ctx->smq_tree_ctx[NIX_TXSCH_LVL_TL1].schq;
 
 	/* SMQ set enqueue xoff */
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
@@ -2479,13 +2478,13 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
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
@@ -2506,10 +2505,10 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
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



