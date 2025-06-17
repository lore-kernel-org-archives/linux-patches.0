Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FB0235071;
	Tue, 17 Jun 2025 16:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178624; cv=none; b=t9gkswurXDkqSTQUYW55A9EstmUPBuCnHlZDHhhP9WtkzZEzcdSj0w7DKeTqxXtOHfzhoeQeKpNf4XIjQcRhSJT5+Lr86tzJYutBHmGstlnkN8aM1FsEfXnOPXf5WYV3E62c4AIFo2xKnBnI9H/Q0zUGXOj9Ifj3Lk6CtKo2pxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178624; c=relaxed/simple;
	bh=CKYw9IDAvLJkTWGMHRpx2z574j/lhWgDS66swszQalU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC9gcXKED9t7R6s3sMg2JMwmRA7EqsLbspmRTusaFEw/XCxqv02WHhbOGwg37AdgKoec2adn94BkjX4/WfbDwKpN8Wv8mhCB1eDzX7TwKTyZI6OFeJ+yM9smhNKWcZM9fj5Ypp9Bi+Uuly1WJmyvUKUwcTcBPGw4OIySSdeltTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1A9lEby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1A9lEby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F36C4CEE3;
	Tue, 17 Jun 2025 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178623;
	bh=CKYw9IDAvLJkTWGMHRpx2z574j/lhWgDS66swszQalU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1A9lEbyLnZiNZNOsScLwhVEOobRjtLr+sxWWhuaUeZTwLxLaq9JCv3gvRnpkLLVG
	 IVryNrW9zJpMLKdaHF6SzD8a/Lr5qdW/88XlXrxVnYDsySp8TSJI7oHH7WGLYKLBJv
	 NiRqwQynOAUVaRBZN7MTioH3dJ52pUYsZdxUy3fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 503/780] Revert "phy: qcom-qusb2: add QUSB2 support for IPQ5424"
Date: Tue, 17 Jun 2025 17:23:31 +0200
Message-ID: <20250617152511.982222515@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 8a040e13afd94a1f91acaf8e0505769d4f7f5af4 ]

With the current settings, compliance tests especially eye diagram
(Host High-speed Signal Quality) tests are failing. Reuse the IPQ6018
settings to overcome this issue, as mentioned in the Hardware Design
Document.

So revert the change which introduced the new settings and reuse the
IPQ6018 settings in the subsequent patch.

Fixes: 9c56a1de296e ("phy: qcom-qusb2: add QUSB2 support for IPQ5424")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250415-revert_hs_phy_settings-v3-1-3a8f86211b59@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qusb2.c | 28 ---------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qusb2.c b/drivers/phy/qualcomm/phy-qcom-qusb2.c
index 1f5f7df14d5a2..81b9e9349c3eb 100644
--- a/drivers/phy/qualcomm/phy-qcom-qusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-qusb2.c
@@ -151,21 +151,6 @@ static const struct qusb2_phy_init_tbl ipq6018_init_tbl[] = {
 	QUSB2_PHY_INIT_CFG(QUSB2PHY_PLL_AUTOPGM_CTL1, 0x9F),
 };
 
-static const struct qusb2_phy_init_tbl ipq5424_init_tbl[] = {
-	QUSB2_PHY_INIT_CFG(QUSB2PHY_PLL, 0x14),
-	QUSB2_PHY_INIT_CFG_L(QUSB2PHY_PORT_TUNE1, 0x00),
-	QUSB2_PHY_INIT_CFG_L(QUSB2PHY_PORT_TUNE2, 0x53),
-	QUSB2_PHY_INIT_CFG_L(QUSB2PHY_PORT_TUNE4, 0xc3),
-	QUSB2_PHY_INIT_CFG(QUSB2PHY_PLL_TUNE, 0x30),
-	QUSB2_PHY_INIT_CFG(QUSB2PHY_PLL_USER_CTL1, 0x79),
-	QUSB2_PHY_INIT_CFG(QUSB2PHY_PLL_USER_CTL2, 0x21),
-	QUSB2_PHY_INIT_CFG_L(QUSB2PHY_PORT_TUNE5, 0x00),
-	QUSB2_PHY_INIT_CFG(QUSB2PHY_PLL_PWR_CTRL, 0x00),
-	QUSB2_PHY_INIT_CFG_L(QUSB2PHY_PORT_TEST2, 0x14),
-	QUSB2_PHY_INIT_CFG(QUSB2PHY_PLL_TEST, 0x80),
-	QUSB2_PHY_INIT_CFG(QUSB2PHY_PLL_AUTOPGM_CTL1, 0x9f),
-};
-
 static const struct qusb2_phy_init_tbl qcs615_init_tbl[] = {
 	QUSB2_PHY_INIT_CFG_L(QUSB2PHY_PORT_TUNE1, 0xc8),
 	QUSB2_PHY_INIT_CFG_L(QUSB2PHY_PORT_TUNE2, 0xb3),
@@ -359,16 +344,6 @@ static const struct qusb2_phy_cfg ipq6018_phy_cfg = {
 	.autoresume_en   = BIT(0),
 };
 
-static const struct qusb2_phy_cfg ipq5424_phy_cfg = {
-	.tbl            = ipq5424_init_tbl,
-	.tbl_num        = ARRAY_SIZE(ipq5424_init_tbl),
-	.regs           = ipq6018_regs_layout,
-
-	.disable_ctrl   = POWER_DOWN,
-	.mask_core_ready = PLL_LOCKED,
-	.autoresume_en   = BIT(0),
-};
-
 static const struct qusb2_phy_cfg qcs615_phy_cfg = {
 	.tbl            = qcs615_init_tbl,
 	.tbl_num        = ARRAY_SIZE(qcs615_init_tbl),
@@ -954,9 +929,6 @@ static const struct phy_ops qusb2_phy_gen_ops = {
 
 static const struct of_device_id qusb2_phy_of_match_table[] = {
 	{
-		.compatible	= "qcom,ipq5424-qusb2-phy",
-		.data		= &ipq5424_phy_cfg,
-	}, {
 		.compatible	= "qcom,ipq6018-qusb2-phy",
 		.data		= &ipq6018_phy_cfg,
 	}, {
-- 
2.39.5



