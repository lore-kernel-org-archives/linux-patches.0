Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F891EF0AE;
	Tue,  3 Dec 2024 15:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239257; cv=none; b=tM6qVc1ZWrIdx/Ogaj7NW07Tx+1lAOoWt6PuWyJRrU4ue70kQjwEysP8xkrpJvDBYanX2AaLYwfSbNAhBXejYz1oD8DaZ+4UYWFV5dkR3u/qZQKkwh7Y7nbRvPc0iHMJWnJDIU68JgR7R/gWT23LeX7UMFupqvOIAnhtBqp90u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239257; c=relaxed/simple;
	bh=PSRs6czze4vMuuUk1qLo7EQW6O+j2kiZ/EgxJzIRpFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQFCmGZU18jGr0vYsuBt5VZmZSSKrFQ3PndBh4aMVKQhCHt9gjZJTTMPSqBSQ0qri7Fs1fJaV/+JyD7oO4cMD75GGTdVjH2ggQEng0dHM0xjWfDKrRLdeNrIIbO7p9Vpj8reD+DZ7b+5T8vcqbReZc+5C0YHrWlwoeQNoAWs05c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWilrtft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWilrtft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66451C4CECF;
	Tue,  3 Dec 2024 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239256;
	bh=PSRs6czze4vMuuUk1qLo7EQW6O+j2kiZ/EgxJzIRpFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWilrtft8NkPoePMhSgsjVwCX/OizJ1BvGAVisHUZ7C+Kqqji89gucJtoV6emEqvX
	 7rW97Rv/FpymrTJbU2eG75dHuHPLhc2KCho21EhRJJxZUWDgB7NeSWobk4Mp1NHqXb
	 DnkMZ9Da9vJNnGtiNmv3n8GHcPsNAPcpUfTphHVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 552/817] phy: airoha: Fix REG_CSR_2L_RX{0,1}_REV0 definitions
Date: Tue,  3 Dec 2024 15:42:04 +0100
Message-ID: <20241203144017.455377450@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit e56272f2bb8314eb13b0eb0a4e8055831c700255 ]

Fix the following register definitions for REG_CSR_2L_RX{0,1}_REV0
registers:
- CSR_2L_PXP_VOS_PNINV
- CSR_2L_PXP_FE_GAIN_NORMAL_MODE
- CSR_2L_PXP_FE_GAIN_TRAIN_MODE

Fixes: d7d2818b9383 ("phy: airoha: Add PCIe PHY driver for EN7581 SoC.")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20240918-airoha-en7581-phy-fixes-v1-4-8291729a87f8@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-airoha-pcie-regs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-airoha-pcie-regs.h b/drivers/phy/phy-airoha-pcie-regs.h
index bb1f679ca1dfa..b938a7b468fee 100644
--- a/drivers/phy/phy-airoha-pcie-regs.h
+++ b/drivers/phy/phy-airoha-pcie-regs.h
@@ -197,9 +197,9 @@
 #define CSR_2L_PXP_TX1_MULTLANE_EN		BIT(0)
 
 #define REG_CSR_2L_RX0_REV0			0x00fc
-#define CSR_2L_PXP_VOS_PNINV			GENMASK(3, 2)
-#define CSR_2L_PXP_FE_GAIN_NORMAL_MODE		GENMASK(6, 4)
-#define CSR_2L_PXP_FE_GAIN_TRAIN_MODE		GENMASK(10, 8)
+#define CSR_2L_PXP_VOS_PNINV			GENMASK(19, 18)
+#define CSR_2L_PXP_FE_GAIN_NORMAL_MODE		GENMASK(22, 20)
+#define CSR_2L_PXP_FE_GAIN_TRAIN_MODE		GENMASK(26, 24)
 
 #define REG_CSR_2L_RX0_PHYCK_DIV		0x0100
 #define CSR_2L_PXP_RX0_PHYCK_SEL		GENMASK(9, 8)
-- 
2.43.0



