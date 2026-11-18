Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016002;
	b=akaqfzSJgJbdWO81FfSKhpzVEOuPxznrH/2IFbgg9HVl1U8QOvhRTO+MK6/Sbk64+Iro
	 5gVD7q0s6pLIWDWSNWRJB0wix2x8jYhdziL/GCNJHrOqHK4PA5/WrOHimRIhzlXBacZox
	 vSYkgJY/ZjNbhQvBs7NEZ9crDhUv/KiwWXEkgrvTAST9S30sd5BXAJDzNHW4JUBqW+zj9
	 /vYMoQpdoid7vc5RpQVFr0pnvUs3KV6XpmsJbFkIQz7ichK5dg1h5O/u61ZplgbV9rOxV
	 xORsc5Du5ykUQAknBE5Gq34blqK5Yq1aPaJMxHqixDbmc/P69jzEu0spE+MonZ2sRZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2E7SN7By022BkTHWYWKFYwnNN5DIvaF3LZdJIactWfw=;
	b=evG0GmCjd2prks40P/2BAI7ZF5uD4GYXtuAcq4e6d/YJxy3B/wE96Kuykl5MguHbItX6
	 8tdNdGbb1c9RRLel0jMh+k5uDYXA1nZmqo+3p6zWrD+z8zikYKf8MlAjNRAAOUAfxyr8o
	 kS5rtskB4hlrrZpNrWhH4qj4AlSRNFT41CBM5i8gfGZ7E37kmev5LrmTtqqcFVivLoLKA
	 HynuR6Tmes6HgGVnPhrFfpXfTnEH0Uq6oii8zfvZ175IzRX4LXgXpDaCGhflNVV1gBOi6
	 86vsZhLrb1jV2kLXeL7f/MoTKDiUDXGqzeeCZNh7CMwmV3wFNyka7s5VYVqMTSYotjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0X38Ntb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3D2606A31C;
	Wed, 18 Nov 2026 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0X38Ntb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB071F000C4;
	Wed, 18 Nov 2026 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016002;
	bh=2E7SN7By022BkTHWYWKFYwnNN5DIvaF3LZdJIactWfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0X38NtbeCVEsWjUXT3hS8XE02asxAVw9zNR3TfrKwCPPjd8Cuw+6GhFA4c/6YxMf
	 Gwnh4lA90YrXPb/eKEuVWCivDmv505ob5qdEfSXbxUXBniDV8nSw8fjsz1eo52cHiV
	 H0056wu5X8pL6JRLBBkGOyztatzza0e3og9oQko4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0373/2651] dmaengine: dw-axi-dmac: Fix CH_CFG2 channel priority position
Date: Wed, 18 Nov 2026 15:26:53 +0100
Message-ID: <20261118150301.262694907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 039316c42f059..da706bff3f124 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -326,7 +326,7 @@ enum {
 #define CH_CFG2_H_TT_FC_POS		0
 #define CH_CFG2_H_HS_SEL_SRC_POS	3
 #define CH_CFG2_H_HS_SEL_DST_POS	4
-#define CH_CFG2_H_PRIORITY_POS		20
+#define CH_CFG2_H_PRIORITY_POS		15
 
 /**
  * DW AXI DMA channel interrupts
-- 
2.53.0



