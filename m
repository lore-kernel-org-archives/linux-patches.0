Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048124;
	b=wuUPtF3Vm8wWQlJ2l5Iw/RE5++BcemCc9RTdTiC5hPziwpGUSZa+BKxOnWXXWHj0OrxC
	 9e/0YE7yCUjxSF7jliWHWP4c510dpytd5lmjiOOrvacH7sPvzNyIQExzEEG6oTqk4Dxz9
	 DCqD8y1rkVgYJOkA60FcmmHhjvFduGx68ZJ/hBaafcNYkUVtJl9NIzNhqrjhLFSjEwsFK
	 kqOC9b1ijv7QtXydKvezDTBHMQWOpjTOzEvCld/hq4OTkP42f+ngMQX1SNd0KQ4K9eeB3
	 in7XNlGiFE4ByRFjoTwYJmvLFjTR8r5VYsJJIfjKRnaQeIlxwLrNgukV9n2xzLDkZSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QCbs1SrK2MsMFTWYoJZ71PmxMIskTOoWjWHX3+9pLG0=;
	b=Wz/4TGHIFEn8/Pi2Qi+PBvTIgdsSZGtneTqr+mJ9/MuFpJ10thlGeI/mSjkmAy7p6AsR
	 d61sJ0hkGiP8v/ZNuAWZO7rXEW+3ErJ6y/C9eIOn5X9PjOV5j+MMLDvFy6BcDZvJMT740
	 B+/cMz3vuZqtwplkhD/1/o/b9nnUazqJF9FcyhCF+4gVP2Vgh77MCOA830QFjvCFLMkR3
	 nbLUvII/ATgFpjs/dvXf/9rm05fxFCEHUvgmZ3EYasKI/M1oArpdvxvNHIzTxjO7+acBy
	 Agjyn/GMVblCAY02vOHBZGo5df2Pcrnj5vMJ2BnQXFK9BN+GxVxJLtoh0cz4f7oBGYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDsq1cwW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE42606A325;
	Thu, 19 Nov 2026 00:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDsq1cwW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6814A1F000C4;
	Thu, 19 Nov 2026 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048123;
	bh=QCbs1SrK2MsMFTWYoJZ71PmxMIskTOoWjWHX3+9pLG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDsq1cwWtMTkr8chwf4v0uFBpqbYGM3c3nie6xFeeNwi5Q1tupGI0jeSP3eqNTLEW
	 KTanJ6PiHz9U99ZSAPHZi4+FBfUZx8dI51Z8aiWA6ZnjRSh0ZhJbJjyEZpxot3vQ9t
	 p70heC+kRqoHsxHOCeR3uxgXBpMGkhB/mUtUVsX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1883/2857] dmaengine: dw-axi-dmac: Fix CH_CFG2 channel priority position
Date: Wed, 18 Nov 2026 15:48:37 +0100
Message-ID: <20261118150309.034615139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2b49ba6355525..408ada52cc7a9 100644
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



