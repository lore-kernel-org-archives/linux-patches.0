Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029413;
	b=RFmgzdX49LImZCBRYBzBCLrcBO9Ckm25J0iBcH4CjkHwlInbja06Zv1oUgfE5eyLUizE
	 AnJX8J7ylSwMhluwflPoeJ11Ua1wTrP3dgAnosP7hhCDfTs75ZnJyznTfRgJZXypJjvZ1
	 88A6Y9loPTVsgRMSTGeDrUQ33vhoxNfyB3xdJ+tnHEnvOIiR7+bFwX902CJ77IHwiv3ls
	 qOtEFe2PA+JLdmrfJt1pMnMXcaCnEzqiYMy47SKTHsb/75b+JKacPQLAfrO3DlmNbmcCK
	 QbEJM6aDiL/TNTryn29yDVNN4iC2F/vQTYvkkwNneL2ouLy0kC6sF781Ybv7Ru5Y0uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8DG/Sa+d0bBsE9jBwfxJl9Bh6TNtr5PK7fOum5lx60M=;
	b=t5iYpSVWI9MdWhV9w6HhEzk+FmK+6uwWZL2rq+aDx/gNV1MygUdo5LpAmZasaf7Otw/f
	 kvjVZUSXHRdMkMXnXprebKisa1SxpZc0TqTV6thGZ+/uv0cWQ+eqM5Az4FPeIXiUHY3Gh
	 Gq2mz3nCEltun3pP5JRmwb3cG6CBoIAFSlzJH21il6HUoCMbY4LiX7R+YJsK+uCtBgMpd
	 GNnSGas+65T97c6f53e9xixy5jqUxa6KT1K5nLixe8EM77WX0X7wwf6/xN1LoJLYXGCAE
	 4C9rH3+53+wyVOFa7fNVoUYAXoquVZOhk2Jp6oczIYooJBndIvF++fD+yOI8FR/gQ9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c3niEjMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D155B606A31C;
	Wed, 18 Nov 2026 19:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c3niEjMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325301F000C7;
	Wed, 18 Nov 2026 19:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029413;
	bh=8DG/Sa+d0bBsE9jBwfxJl9Bh6TNtr5PK7fOum5lx60M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3niEjMhKdVJ+eUUYGb3jHoJGTS4vbW40HSrdu5/UF3QHwyBGqgIEx5uxDEluTI6r
	 Kbf6A8UcmiQmtZKMujvn4tF6ESOF6qmDVGwcAWzLorT138/q/+uDHFbaBQyYV5rKn1
	 NpoelEisrdjLF40394q/aCJ6vxdRScMAEryhZ5U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0341/1756] dmaengine: dw-axi-dmac: Fix CH_CFG2 channel priority position
Date: Wed, 18 Nov 2026 15:41:08 +0100
Message-ID: <20261118150021.850644815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d6e53f400af25..21adc030a7109 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -325,7 +325,7 @@ enum {
 #define CH_CFG2_H_TT_FC_POS		0
 #define CH_CFG2_H_HS_SEL_SRC_POS	3
 #define CH_CFG2_H_HS_SEL_DST_POS	4
-#define CH_CFG2_H_PRIORITY_POS		20
+#define CH_CFG2_H_PRIORITY_POS		15
 
 /**
  * DW AXI DMA channel interrupts
-- 
2.53.0



