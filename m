Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6B04C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB76C433C1;
	Mon, 14 Nov 2022 12:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430667;
	bh=WB9QxwtsxiBq3DAdYg+/rml0ZidWSD64mWmqJrKskcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SH0YJWOTmqiJLLOxuw9wwM2rpTm+uIhdVmvXAnabjysw+NjPu7bOzNcLjjVtB7rXS
	 mvpKexyJyBPCPIQxtWKBrtWm9OlTVHQdhPGmwUJMcfID1nL+lClv0UQFIbJPe/SVYX
	 5EgNBaL0L1W7zxS9ug+lF6oZk9Dt6VuXuvAhdYHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wong Vee Khee <vee.khee.wong@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/131] stmmac: intel: Enable 2.5Gbps for Intel AlderLake-S
Date: Mon, 14 Nov 2022 13:45:35 +0100
Message-Id: <20221114124451.487606072@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

[ Upstream commit 23d743301198f7903d732d5abb4f2b44f22f5df0 ]

Intel AlderLake-S platform is capable of running on 2.5GBps link speed.

This patch enables 2.5Gbps link speed on AlderLake-S platform.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Link: https://lore.kernel.org/r/20220225023325.474242-1-vee.khee.wong@linux.intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: dcea1a8107c0 ("stmmac: intel: Update PCH PTP clock rate from 200MHz to 204.8MHz")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index b32f1f5d841f..3829bd23e47d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -722,6 +722,7 @@ static int tgl_common_data(struct pci_dev *pdev,
 	plat->rx_queues_to_use = 6;
 	plat->tx_queues_to_use = 4;
 	plat->clk_ptp_rate = 200000000;
+	plat->speed_mode_2500 = intel_speed_mode_2500;
 
 	plat->safety_feat_cfg->tsoee = 1;
 	plat->safety_feat_cfg->mrxpee = 0;
@@ -741,7 +742,6 @@ static int tgl_sgmii_phy0_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
-	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return tgl_common_data(pdev, plat);
@@ -756,7 +756,6 @@ static int tgl_sgmii_phy1_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 2;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
-	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return tgl_common_data(pdev, plat);
-- 
2.35.1



