Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BAE1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F23BC433EF;
	Wed, 28 Dec 2022 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245414;
	bh=piYS0Q3TciC95a5421Gzlybs/ll4cgZ94Mwp6EJfaJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8Nd4zxjNPNuppORCMsIZQXzM53wtlR3KvqFkTOFinrXrrj1ikCvK3Ri7Ru2VbtHb
	 iHkG0T+3CwrqdOIpYHKgt3JOvoiSXeL5Ldp76TjYwSefYgjp6aVeO2tVs9s5TFDy1q
	 h2rlKjLLvrKF/oStIv9OrM4aSQzt8YGkoCakvpx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0824/1146] phy: qcom-qmp-pcie: split pcs_misc init cfg for ipq8074 pcs table
Date: Wed, 28 Dec 2022 15:39:23 +0100
Message-Id: <20221228144352.536552838@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 2584068a9ef4a7bff3b9302dd058a4c95ce68631 ]

Commit af6643242d3a ("phy: qcom-qmp-pcie: split pcs_misc region for ipq6018
pcie gen3") reworked the pcs regs values and removed the 0x400 offset
for each pcs_misc regs.

This change caused the malfunction of ipq8074 downstream since it still
has the legacy pcs table where pcs_misc are not placed on a different
table and instead put together assuming the offset of 0x400 for the
related pcs_misc regs.

Split pcs_misc init cfg from the ipq8074 pcs init table to be handled
correctly to prepare for actual support for gen3 pcie for ipq8074.

Fixes: af6643242d3a ("phy: qcom-qmp-pcie: split pcs_misc region for ipq6018 pcie gen3")
Reported-by: Robert Marko <robimarko@gmail.com>
Tested-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://lore.kernel.org/r/20221103212125.17156-1-ansuelsmth@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 8fe7d5681192..9ccc6e27fc1f 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -505,6 +505,13 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_gen3_pcs_tbl[] = {
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_FLL_CNTRL1, 0x01),
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_P2U3_WAKEUP_DLY_TIME_AUXCLK_H, 0x0),
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_P2U3_WAKEUP_DLY_TIME_AUXCLK_L, 0x1),
+	QMP_PHY_INIT_CFG(QPHY_V4_PCS_G12S1_TXDEEMPH_M3P5DB, 0x10),
+	QMP_PHY_INIT_CFG(QPHY_V4_PCS_RX_DCC_CAL_CONFIG, 0x01),
+	QMP_PHY_INIT_CFG(QPHY_V4_PCS_RX_SIGDET_LVL, 0xaa),
+	QMP_PHY_INIT_CFG(QPHY_V4_PCS_REFGEN_REQ_CONFIG1, 0x0d),
+};
+
+static const struct qmp_phy_init_tbl ipq8074_pcie_gen3_pcs_misc_tbl[] = {
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_PCIE_OSC_DTCT_ACTIONS, 0x0),
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_PCIE_L1P1_WAKEUP_DLY_TIME_AUXCLK_H, 0x00),
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_PCIE_L1P1_WAKEUP_DLY_TIME_AUXCLK_L, 0x01),
@@ -517,11 +524,7 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_gen3_pcs_tbl[] = {
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_PCIE_OSC_DTCT_MODE2_CONFIG2, 0x50),
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_PCIE_OSC_DTCT_MODE2_CONFIG4, 0x1a),
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_PCIE_OSC_DTCT_MODE2_CONFIG5, 0x6),
-	QMP_PHY_INIT_CFG(QPHY_V4_PCS_G12S1_TXDEEMPH_M3P5DB, 0x10),
 	QMP_PHY_INIT_CFG(QPHY_V4_PCS_PCIE_ENDPOINT_REFCLK_DRIVE, 0xc1),
-	QMP_PHY_INIT_CFG(QPHY_V4_PCS_RX_DCC_CAL_CONFIG, 0x01),
-	QMP_PHY_INIT_CFG(QPHY_V4_PCS_RX_SIGDET_LVL, 0xaa),
-	QMP_PHY_INIT_CFG(QPHY_V4_PCS_REFGEN_REQ_CONFIG1, 0x0d),
 };
 
 static const struct qmp_phy_init_tbl sdm845_qmp_pcie_serdes_tbl[] = {
@@ -1489,6 +1492,8 @@ static const struct qmp_phy_cfg ipq8074_pciephy_gen3_cfg = {
 		.rx_num		= ARRAY_SIZE(ipq8074_pcie_gen3_rx_tbl),
 		.pcs		= ipq8074_pcie_gen3_pcs_tbl,
 		.pcs_num	= ARRAY_SIZE(ipq8074_pcie_gen3_pcs_tbl),
+		.pcs_misc	= ipq8074_pcie_gen3_pcs_misc_tbl,
+		.pcs_misc_num	= ARRAY_SIZE(ipq8074_pcie_gen3_pcs_misc_tbl),
 	},
 	.clk_list		= ipq8074_pciephy_clk_l,
 	.num_clks		= ARRAY_SIZE(ipq8074_pciephy_clk_l),
-- 
2.35.1



