Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054984;
	b=ZDZ2FFnl8pMsmMssFM7n81ttiLDZAwgLhVTu2HwUCIy4z03yuifoh0PGOAPP/LyPVe/5
	 p1Rt4cDb6mo51E7FebL+f/kTdIPDQSGsS6amquZoFC2NFuskXwDkoBcl+bieJCZMe98QB
	 6Bvj11PFNpGu+OMkK+NO1BwnfWt0Cw/FW4i4eGd7kb5XeSniWPBz08yo00Wg8Hh1TWJqc
	 MdSLUY+escSh53YRFZONO/bt6i74sVo15nuOGOWMpbynr6y4N0GhJIFv/nkxWafgQFIZB
	 N2ROQXMy5YKeX4HmjGfjsFlyhwEu3ROqM13nLYFP0zmkF3ONqfET7RV0hDK/nQUr3Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PdSY4JojCeZMhZ2ACtHlr5pNO7qYlAgtShEHCJekkWQ=;
	b=hBQohGrBYsn9uwRKMqUtM9A4DYvaA8UR/94BlOBMhiPm9BDlT4aNvrKzvY/ARapYdxTq
	 T3ziWYmdXy/tupBlQLzZ/4S44Apcwerb1DsHT8lnE4m1DD3JvKn6Jj+lzg8qSrBhCaZga
	 xCuKYvQ4nceH1WjBUnlqBDuzv8WDIV+MKR8SzY+djNMoWonzVBr0GN2DVz5vR+h+jDxtW
	 6k5dhiVpqGSYY8FJXI+sCKmZ8jhYQP5VNGd50RzB1eC+la0D+q05Q2tgwje4v0Z1MhXuU
	 dxRH27VU+6H//JOAY/mcHAHuaPlkDGrRJBv0syJYOd6mNm7OKslcufL/tvoDfDpY9vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZIl5Ddv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233E0606A320;
	Thu, 19 Nov 2026 02:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZIl5Ddv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788B01F000C4;
	Thu, 19 Nov 2026 02:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054984;
	bh=PdSY4JojCeZMhZ2ACtHlr5pNO7qYlAgtShEHCJekkWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZIl5DdvyFZJoNvpO3d60WAuKZ2RhvjkBK2Jkr5U4OsN2xQirSzxjOiz8FyFLK5EH
	 NSr7oZat/wNGERKLJSMz7G9XF0S5cd2VL58Fv00iDjc21zXNjWNOR/X2Wl05hbWn0p
	 QvkNuendAhD71di89hRbY+KsnEvNrmUkboRxJFfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1462/2214] dmaengine: dw-axi-dmac: Fix CH_CFG2 channel priority position
Date: Wed, 18 Nov 2026 15:52:18 +0100
Message-ID: <20261118150109.543448330@linuxfoundation.org>
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

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit 2a9013c20c46216b92ff09e2283b5244a91c59da ]

The CH_CFG2 channel priority field occupies bits 51:47 of the 64-bit
channel configuration register, corresponding to bits 19:15 of CH_CFG2_H.

The driver currently shifts the priority value by 20, programming the
wrong bits. Use bit 15 as the field position.

Fixes: 824351668a41 ("dmaengine: dw-axi-dmac: support DMAX_NUM_CHANNELS > 8")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260902-dma-fix-v3-3-414c6449fbcc@ultrarisc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
index a51e35df996ec..a84945d2a508c 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -321,7 +321,7 @@ enum {
 #define CH_CFG2_H_TT_FC_POS		0
 #define CH_CFG2_H_HS_SEL_SRC_POS	3
 #define CH_CFG2_H_HS_SEL_DST_POS	4
-#define CH_CFG2_H_PRIORITY_POS		20
+#define CH_CFG2_H_PRIORITY_POS		15
 
 /**
  * DW AXI DMA channel interrupts
-- 
2.53.0



