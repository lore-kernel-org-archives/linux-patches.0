Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B19547CA62;
	Sat, 12 Sep 2026 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219136; cv=none; b=lYDBfv85rFBcd/7FgAHA/A46Di4ErxcqB7VID8HswZDJuiwCC9qtLU9P8YdUW9YgmQh2G+kQdjR1wCCNzNrGq80eVBQmUZH85IIjNbwypnpQGnYANx1exWXSz23y+w/csPjinGa8tKW2gjUL9l1m8q8JArhzePVi9bkEkvaSx6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219136; c=relaxed/simple;
	bh=4/4EgLwG9VM/TtOQi4H7n8VvhVCF6YEt+/6tDF0NCks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1UDKFd4PtmkBmqRYV9OBtlRUVNuDVlh2qxny1V2CR9Y4kFZq0ApvNl4BblSAYBHPOMGY3/miizsS+o8NDa7Hws5K2QcUxOdONU91rcjjjqcU8JECs43hCIsu4OP9uUDLOUeUCcwNkDnorFGViZXCjpjiQv33XMFReJp6keoJhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6LgD7AE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6LgD7AE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ADA1F000FF;
	Sat, 12 Sep 2026 13:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219135;
	bh=5lXucf473kC1W8OwfvN9M/Qmqc5ExJqOdHUCFQwUNLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6LgD7AEUPrhXCJa5t8XynOJl33KHqA779z5o+Lwe0TYOjjqgCudrzo0vzFO19CkA
	 ljqW+OxT2m7uWF5D0SpxdwwhzHkGUgyHzacQfACGbrWuAG5g8Xl8MriOrO8OW8D3so
	 Bvkr31ejkDwdAAZwOtsja2RaLK/Fsvxc91/PXCYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1287/1376] octeontx2-af: Fix TL3/TL2 link config ENA clearing
Date: Sat, 12 Sep 2026 09:01:53 +0200
Message-ID: <20260912065636.221725986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f9b7263eeb376..74be2012ec04e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2370,8 +2370,8 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id = 0, lmac_id = 0;
 	u16 tl2_tl3_link_schq;
-	u8 link, link_level;
 	u64 cfg, bmap = 0;
+	u8 link_level;
 
 	if (!is_rvu_otx2(rvu)) {
 		/* Skip SMQ flush if pkt count is zero */
@@ -2403,7 +2403,6 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	link_level = rvu_read64(rvu, blkaddr, NIX_AF_PSE_CHANNEL_LEVEL) & 0x01 ?
 			NIX_TXSCH_LVL_TL3 : NIX_TXSCH_LVL_TL2;
 	tl2_tl3_link_schq = smq_flush_ctx->smq_tree_ctx[link_level].schq;
-	link = smq_flush_ctx->smq_tree_ctx[NIX_TXSCH_LVL_TL1].schq;
 
 	/* SMQ set enqueue xoff */
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
@@ -2413,13 +2412,13 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
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
@@ -2440,10 +2439,10 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
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



