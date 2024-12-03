Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A951EF0AE;
	Tue,  3 Dec 2024 15:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239251; cv=none; b=bCtOS9VKrHkakJddFFWweJzRSAJe/DUGWcxg2MECeIP7MKWcWZlMeBs1zc7ZXXJIewf3fHJ6f5+r1f3oFXYRlPWgDBThbD94pEmMXCMcenSDvZd7GhAE8K92JDu9w2gSeGwc1w4XSLaT+Ewi79lD/IyjZB31lzX9A9XwDHcARnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239251; c=relaxed/simple;
	bh=Ae9kU7rAy5kVVecw+x2mhn3ul/19m9SvpaQqAhoeLas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HF+UMmPWO2Lb1sLGyLQ5MMihZImLDfJTLDklumBgo7xW84h/MAqjA/D4gaTuvJezprqhDqVAuFRYWhobqNYGvhcD/6sPS4YHPsKw0R3LktAiheJW2zxhWwmuG6pgbgsMDdZciK917b8zCWFp2EvjOW/m2zxGX9tOBbUgRM1rr3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPaXc4eN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPaXc4eN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A545C4CECF;
	Tue,  3 Dec 2024 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239250;
	bh=Ae9kU7rAy5kVVecw+x2mhn3ul/19m9SvpaQqAhoeLas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPaXc4eNCeW3dhfWwUxt9SLm00HUqB+tOi6G05yH54nyUyo6W4M8XGTyEYzj1LRkU
	 lCc48zOEm7efYgW/X1CgpgnBq/8YWJvtXo0Lln6dv9p7gD9QBdRjhZQt3o3HRy1F5l
	 YB2eq4tx6kUDup5soa07P/ChJR+HHVxk+8WcVexI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 550/817] phy: airoha: Fix REG_PCIE_PMA_TX_RESET config in airoha_pcie_phy_init_csr_2l()
Date: Tue,  3 Dec 2024 15:42:02 +0100
Message-ID: <20241203144017.375798783@linuxfoundation.org>
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

[ Upstream commit f9c5d6369d3e8e36b7beb15e86b1ef0911ace85f ]

Fix typos configuring REG_PCIE_PMA_TX_RESET register in
airoha_pcie_phy_init_csr_2l routine for lane0 and lane1

Fixes: d7d2818b9383 ("phy: airoha: Add PCIe PHY driver for EN7581 SoC.")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20240918-airoha-en7581-phy-fixes-v1-2-8291729a87f8@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-airoha-pcie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-airoha-pcie.c b/drivers/phy/phy-airoha-pcie.c
index 3113be0a0e5b6..3e5f49d9942a6 100644
--- a/drivers/phy/phy-airoha-pcie.c
+++ b/drivers/phy/phy-airoha-pcie.c
@@ -468,9 +468,9 @@ static void airoha_pcie_phy_init_csr_2l(struct airoha_pcie_phy *pcie_phy)
 				 PCIE_SW_XFI_RXPCS_RST | PCIE_SW_REF_RST |
 				 PCIE_SW_RX_RST);
 	airoha_phy_pma0_set_bits(pcie_phy, REG_PCIE_PMA_TX_RESET,
-				 PCIE_TX_TOP_RST | REG_PCIE_PMA_TX_RESET);
+				 PCIE_TX_TOP_RST | PCIE_TX_CAL_RST);
 	airoha_phy_pma1_set_bits(pcie_phy, REG_PCIE_PMA_TX_RESET,
-				 PCIE_TX_TOP_RST | REG_PCIE_PMA_TX_RESET);
+				 PCIE_TX_TOP_RST | PCIE_TX_CAL_RST);
 }
 
 static void airoha_pcie_phy_init_rx(struct airoha_pcie_phy *pcie_phy)
-- 
2.43.0



