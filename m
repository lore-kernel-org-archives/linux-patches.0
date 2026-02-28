Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A25D33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301168; cv=none; b=l87dLPzRxE47SRHxBUeuROHTGa8Mf3AANdyLNzmgJBqVG7rSc4yFApp//NyaBYLk4CzGOQ10slnWCkfR8sa77agycOSMckki/GYvbzB2Iuur5GoXZdwXsh1kS6BdBP6uUvNQxgtsKIRLShAsC1NK++nlxnk05vBlU6UW0ZmeHl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301168; c=relaxed/simple;
	bh=QmJOBZaR5RMLhXGQoqBBPsyIqSkr6eHuIJHE0yzIkCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5930MjCUG2/zIn4MJlR0F16bprRpteHzQH7eiI2qkcBzX2TarNo1MG5Evi36CD9hM3g7/hBdkqcNOic4CEq96B7+jkG9Kk5Z2fLS+XoyLCmBWMyWgVDpvUNSCXU/vPUVTLhup5wLqewbvKR8dmUqIpcwthYOS78hMWGaERG/g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkK/RWSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkK/RWSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6DAC19424;
	Sat, 28 Feb 2026 17:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301168;
	bh=QmJOBZaR5RMLhXGQoqBBPsyIqSkr6eHuIJHE0yzIkCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkK/RWSE4RS65bWpXzx7uq93kEm/4LqpgkyohM0jF4NI8x0IhrCZKV5cKKcgbFZ0o
	 fKLoB8gbM7cNeq0T89sWLG/x+Gjs3LjqWWxQ9NmQazg0AzHZpCXlamXERy7TPv0hOV
	 Zi/k2tXTdxmWXqKTQRpsC0Pu10XRxr7QyWwl+ulm2iNaR3+N+AcmplDvMIkwa0urA0
	 JuEXGQ4XZRzlTWwy8R80stVeoYMqn0/L2dvKnKYCSjRxJjPt/0weOx6qqYnbk6T2PX
	 WY5RiL23E/3n2/myb4Nb+LtEdvmmsqY3n4+qLoVcrzlUt782G7BRUrMnETm2N3p1Re
	 qSryEPgMPNLPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 334/752] phy: cadence-torrent: restore parent clock for refclk during resume
Date: Sat, 28 Feb 2026 12:40:45 -0500
Message-ID: <20260228174750.1542406-334-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>

[ Upstream commit 434e1a0ee145d0389b192252be4c993f86cf1134 ]

While suspend and resume, parent clock config for refclk was getting lost.
So save and restore it in suspend and resume operations.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Thomas Richard (TI.com) <thomas.richard@bootlin.com>
Link: https://patch.msgid.link/20251216-phy-cadence-torrent-resume-restore-refclk-parent-v3-1-8a7ed84b47e3@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/cadence/phy-cadence-torrent.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/phy/cadence/phy-cadence-torrent.c b/drivers/phy/cadence/phy-cadence-torrent.c
index 37fa4bad6bd72..877f22177c699 100644
--- a/drivers/phy/cadence/phy-cadence-torrent.c
+++ b/drivers/phy/cadence/phy-cadence-torrent.c
@@ -397,6 +397,7 @@ struct cdns_torrent_refclk_driver {
 	struct clk_hw		hw;
 	struct regmap_field	*cmn_fields[REFCLK_OUT_NUM_CMN_CONFIG];
 	struct clk_init_data	clk_data;
+	u8 parent_index;
 };
 
 #define to_cdns_torrent_refclk_driver(_hw)	\
@@ -3326,11 +3327,29 @@ static const struct cdns_torrent_vals sgmii_qsgmii_xcvr_diag_ln_vals = {
 	.num_regs = ARRAY_SIZE(sgmii_qsgmii_xcvr_diag_ln_regs),
 };
 
+static void cdns_torrent_refclk_driver_suspend(struct cdns_torrent_phy *cdns_phy)
+{
+	struct clk_hw *hw = cdns_phy->clk_hw_data->hws[CDNS_TORRENT_REFCLK_DRIVER];
+	struct cdns_torrent_refclk_driver *refclk_driver = to_cdns_torrent_refclk_driver(hw);
+
+	refclk_driver->parent_index = cdns_torrent_refclk_driver_get_parent(hw);
+}
+
+static int cdns_torrent_refclk_driver_resume(struct cdns_torrent_phy *cdns_phy)
+{
+	struct clk_hw *hw = cdns_phy->clk_hw_data->hws[CDNS_TORRENT_REFCLK_DRIVER];
+	struct cdns_torrent_refclk_driver *refclk_driver = to_cdns_torrent_refclk_driver(hw);
+
+	return cdns_torrent_refclk_driver_set_parent(hw, refclk_driver->parent_index);
+}
+
 static int cdns_torrent_phy_suspend_noirq(struct device *dev)
 {
 	struct cdns_torrent_phy *cdns_phy = dev_get_drvdata(dev);
 	int i;
 
+	cdns_torrent_refclk_driver_suspend(cdns_phy);
+
 	reset_control_assert(cdns_phy->phy_rst);
 	reset_control_assert(cdns_phy->apb_rst);
 	for (i = 0; i < cdns_phy->nsubnodes; i++)
@@ -3352,6 +3371,10 @@ static int cdns_torrent_phy_resume_noirq(struct device *dev)
 	int node = cdns_phy->nsubnodes;
 	int ret, i;
 
+	ret = cdns_torrent_refclk_driver_resume(cdns_phy);
+	if (ret)
+		return ret;
+
 	ret = cdns_torrent_clk(cdns_phy);
 	if (ret)
 		return ret;
-- 
2.51.0

