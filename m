Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A6523CE;
	Tue,  3 Dec 2024 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241853; cv=none; b=O9S2s2LmMGBJDFUEfbrFkCTXdHuZ7JFJrsPc6sPj/BKWkplYrVuut8zbhM/F+jR9aKi7LappSxGq0IHgbSYI66F9ItI0cAour4g2KhK0gcirVUtVad7Q7yMLfIGOgYi3s8mx7uhlE5ZQLMUW1CbluI0QL6pFwbBJY05qUrLp6UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241853; c=relaxed/simple;
	bh=2tp/lw4xh46xldh4SDGVX7n9csQe2Ow+fHKJNHo9gp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMIDD3wYW2J+Yp5ZKW5eW+Sdk/YIq4EWPToMmNiyEaZjuBfrDfAHJ9uzK60fm/Sr6AHJ7LP51Im8bi2VAI89vClpjjqtJ4VTLvuClARxDi40XgtSowrE81StcevB2cJRBL9dt12+QbY6TWm4ZH6J44u/86Ycfuyv9fkmcJeMqQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzOk07MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzOk07MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0225CC4CECF;
	Tue,  3 Dec 2024 16:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241853;
	bh=2tp/lw4xh46xldh4SDGVX7n9csQe2Ow+fHKJNHo9gp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzOk07MGEHCkwbvDRydxKue0NUaFHYQ4b+81V3LREYBYkIGUfF+3bmUZI3jox6I5n
	 d81SgtedocF2v2eDMNA9j/D1tKtGPcHH/oI3rixN8us/Xb5xA26tBZ1+7JYmgSTWjX
	 l0JN6UE/tENTohLQ0lHAjCUtcZHHy+aVImubD04M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 536/826] phy: airoha: Fix REG_PCIE_PMA_TX_RESET config in airoha_pcie_phy_init_csr_2l()
Date: Tue,  3 Dec 2024 15:44:23 +0100
Message-ID: <20241203144804.663751117@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4624aa9dd7127..9a7ce65f87f05 100644
--- a/drivers/phy/phy-airoha-pcie.c
+++ b/drivers/phy/phy-airoha-pcie.c
@@ -471,9 +471,9 @@ static void airoha_pcie_phy_init_csr_2l(struct airoha_pcie_phy *pcie_phy)
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



