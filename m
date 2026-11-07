Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064439;
	b=mYLeGJwgxE7EmNXNdDFlwU4Gp2LRnCx6aMRMzmKFOvTwNqFyjmDv2ayS+/ltnMAm3jgu
	 WK4Y4hXwCGktfeI3MRhlSOLOqR480+GaGb+74SYP3bou1spLGASZ15Dsqd1nbU6gAgWfu
	 cCtWsYwJ9n62OYk3hvfzNQjHwA7CHdGD6LKDJK3npBUuHGpfdDQcROP8JBO4queC/cmKL
	 meBBuyqJSkABEdTC3nUVz0pSS9OREMYF8IIFrQsU9slKyhKaSYPN8TpP2Mq6jkf+Ypxr7
	 eajddlnhN8dslqvqQMUw2wMBjTbc+c1aWrOFQ2cHGHv3A/EFEWkgwK7kyspq4WQyXGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VOPCnKBntPSPPcjB8Rj8/EPv4RPygdHCG2iuYWOOMKw=;
	b=VBNlr8TnxaOlhRaS0popy57VYnOA4v46RJmC483s+xWLVW/X3bvhFK5QERrELtyLm3wX
	 +ZmIlYxtvFZ62yBJWoC+4Y0dGOpIiJewXS1Bucp/rty99tldSchV1eeFZ+LPeLOETzXDL
	 CG3j8QvmpKXYoJgnIwsVsAYJeHbASLD2qDPxpF76LbohCa8+Zi64IjA5lbaonOnR/v/Sj
	 0ybZNFBIDCnnl29bL956ENc6CsryKaZu98qu26L2gbnlhGqU17CbcuWUTnDVmgpFvdXnz
	 1AWZ08rUbUk2gdH8jgnjvKnjqilnX1JrGbOJbj/eG1A8NTbMMZ6Ne2nQHwfAGEaS+qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tHLb/OZC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC5A606A9DB;
	Sat,  7 Nov 2026 15:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHLb/OZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC57F1F0089F;
	Sat,  7 Nov 2026 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064439;
	bh=VOPCnKBntPSPPcjB8Rj8/EPv4RPygdHCG2iuYWOOMKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHLb/OZCcnnRKoyM2c33+eLs7TFmImyuUj3ZO2eIhHcExvmpGYISrvyq1RNuIAIUv
	 2la/pKWMuNh4l49Pi4SwyaFXWPvSCwF72WDlgwoCsGLF3DzfvPxG9NluJDYlJFRp/u
	 Ciggcq7xfm6jx8A0p3Ahx/19zuJd/aCiS8ie1Lxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0485/1257] dmaengine: sh: rz-dmac: Fix off-by-one in residue lmdesc lookup
Date: Sat,  7 Nov 2026 08:46:21 -0500
Message-ID: <20261107134952.839368220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

[ Upstream commit 9db8e502b34bc1df8078abd0169a4fa0624de3bb ]

lmdesc->nxla is the address of the next descriptor, so comparing it
against CRLA, which is the address of the current descriptor,
finds the descriptor before the active one, not the active one.
The residue loops below then summed one lmdesc too many on top of
that.

Compare each descriptor's own address to CRLA instead, and add tb
after advancing to the next lmdesc.

Fixes: 21323b118c16 ("dmaengine: sh: rz-dmac: Add device_tx_status() callback")
Fixes: 172bfb57481c ("dmaengine: sh: rz-dmac: Add cyclic DMA support")
Cc: stable@vger.kernel.org
Suggested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260922092037.224884-1-claudiu.beznea@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/rz-dmac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sh/rz-dmac.c b/drivers/dma/sh/rz-dmac.c
index ca76f1bb45c41..fdd7131e890ab 100644
--- a/drivers/dma/sh/rz-dmac.c
+++ b/drivers/dma/sh/rz-dmac.c
@@ -937,7 +937,7 @@ static u32 rz_dmac_calculate_residue_bytes_in_vd(struct rz_dmac_chan *channel,
 	struct rz_dmac *dmac = to_rz_dmac(chan->device);
 	u32 residue = 0, i = 0;
 
-	while (lmdesc->nxla != crla) {
+	while (rz_dmac_lmdesc_addr(channel, lmdesc) != crla) {
 		lmdesc = rz_dmac_get_next_lmdesc(channel->lmdesc.base, lmdesc);
 		if (++i >= DMAC_NR_LMDESC)
 			return 0;
@@ -948,13 +948,13 @@ static u32 rz_dmac_calculate_residue_bytes_in_vd(struct rz_dmac_chan *channel,
 		u32 start_lmdesc_addr = rz_dmac_lmdesc_addr(channel, desc->start_lmdesc);
 
 		while (lmdesc->nxla != start_lmdesc_addr) {
-			residue += lmdesc->tb;
 			lmdesc = rz_dmac_get_next_lmdesc(channel->lmdesc.base, lmdesc);
+			residue += lmdesc->tb;
 		}
 	} else {
 		while (lmdesc->chcfg & CHCFG_DEM) {
-			residue += lmdesc->tb;
 			lmdesc = rz_dmac_get_next_lmdesc(channel->lmdesc.base, lmdesc);
+			residue += lmdesc->tb;
 		}
 	}
 
-- 
2.53.0



