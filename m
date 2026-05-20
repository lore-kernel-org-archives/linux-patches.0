Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7AA36494B;
	Wed, 20 May 2026 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296799; cv=none; b=AskslQwiXc5HKCHf8+G7qJphYqtZcPjWainMTBMJODy3OVZXDeKc/M0DQEr/naipMuytmcb+OuOS+p2NXJ1Pv/epEo37loWDFIEE/y6lg9pFGx2BcTP1JB6sDraTN1WB+Hc0A7L7VBnbRV0FxkD+xMZkXew9uIVgLUzBf0QvKZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296799; c=relaxed/simple;
	bh=VZv13RkwTKnuzZgEfIfjNsRbXeqBQh88cri/ja1zC20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNzpmDLx8Atam9uUoaWVUs2PhaOvu+WUCs11AB87glSFNBGrd0IghXNxcoHlhk62QwX0bPonK0DDepqeHRLDcJQogvlEeUbytrwcS0F5sqXXOZUr+AQby56K8w5cMspWnxW+gKWTFo6ckuaw+ryAv2dUV+EYB4G88yRX2eF2Vlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7n2oR5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7n2oR5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC041F000E9;
	Wed, 20 May 2026 17:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296798;
	bh=7isUPM1BGnfr3WQ5+E/KeMyXMZUjWdMe3MXhSYPo38g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7n2oR5dq1ekuPTov54MyMw6tEHWdqB773R38P24pnE1bsg0HtrWPrz6K6LQ87x2h
	 AwWVSIQUTRu0LsFti0AbLXUvocuWHEzWHMeRMgvqZLPxRI0vPPX1NxTikOfbxWNMMc
	 FMNA5HVORHj0QW5isbmXB/NmLvgnrt5aoEOtWKpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengping Zhang <aquapinn@qq.com>,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0936/1146] net: airoha: fix typo in function name
Date: Wed, 20 May 2026 18:19:46 +0200
Message-ID: <20260520162209.419167503@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengping Zhang <aquapinn@qq.com>

[ Upstream commit aebf15e8eb09b01e99f043e9f5d423798aac9d32 ]

Corrected the typo in the function name from
 `airhoa_is_lan_gdm_port` to `airoha_is_lan_gdm_port`. This change ensures
 consistency in the API naming convention.

Signed-off-by: Zhengping Zhang <aquapinn@qq.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/tencent_E4FD5D6BC0131E617D848896F5F9FCED6E0A@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e070aac63b42 ("net: airoha: Do not wake all netdev TX queues in airoha_qdma_wake_netdev_txqs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 2 +-
 drivers/net/ethernet/airoha/airoha_eth.h | 2 +-
 drivers/net/ethernet/airoha/airoha_ppe.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 4b804ca927819..8819e24283abc 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -76,7 +76,7 @@ static void airoha_set_macaddr(struct airoha_gdm_port *port, const u8 *addr)
 	struct airoha_eth *eth = port->qdma->eth;
 	u32 val, reg;
 
-	reg = airhoa_is_lan_gdm_port(port) ? REG_FE_LAN_MAC_H
+	reg = airoha_is_lan_gdm_port(port) ? REG_FE_LAN_MAC_H
 					   : REG_FE_WAN_MAC_H;
 	val = (addr[0] << 16) | (addr[1] << 8) | addr[2];
 	airoha_fe_wr(eth, reg, val);
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index c9d1abda47768..46f4197007074 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -630,7 +630,7 @@ u32 airoha_rmw(void __iomem *base, u32 offset, u32 mask, u32 val);
 #define airoha_qdma_clear(qdma, offset, val)			\
 	airoha_rmw((qdma)->regs, (offset), (val), 0)
 
-static inline bool airhoa_is_lan_gdm_port(struct airoha_gdm_port *port)
+static inline bool airoha_is_lan_gdm_port(struct airoha_gdm_port *port)
 {
 	/* GDM1 port on EN7581 SoC is connected to the lan dsa switch.
 	 * GDM{2,3,4} can be used as wan port connected to an external
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 684c8ae9576f1..f2af45f7d66d4 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -331,7 +331,7 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 			/* For downlink traffic consume SRAM memory for hw
 			 * forwarding descriptors queue.
 			 */
-			if (airhoa_is_lan_gdm_port(port))
+			if (airoha_is_lan_gdm_port(port))
 				val |= AIROHA_FOE_IB2_FAST_PATH;
 			if (dsa_port >= 0)
 				val |= FIELD_PREP(AIROHA_FOE_IB2_NBQ,
-- 
2.53.0



