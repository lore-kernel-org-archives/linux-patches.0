Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A05347FEC;
	Sat, 12 Sep 2026 13:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219441; cv=none; b=kJpi4jHHAYTE79XTTrrWXw54ioMLbMhkOZdgwKdOFyXeOK5wDMjQu9fpA3l+QBPHTQ4tNromqooURj+4tS8dTeaiv1RDKyBYTodOtQ+WiUTcNk919rabROdqlJ8pAEfiLlZ9W9QaBJwnsd5zI9zB7W8hM65DB9oSd3rx8UcB2+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219441; c=relaxed/simple;
	bh=jMVmmbxjRvmL21G/FqwZz+8J6bJfAq9pP4XP9byNa6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj9nKeBTQTYAfMQlfz419c4moYCGPUcG2UqhuBXDkujOIdjsZUy12ak+iwwYNGHsZSs/WqqqGi0ZlMJt7PUt5f4F5h3W44uN8hLNIadCXs79pu3rm5C8JfJcmD7hnfD3dsQ7oG7MFFP3Fe5uBLA4PMXVXbBAtLBIqebjguzlKAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxZQRhMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxZQRhMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3064F1F000FF;
	Sat, 12 Sep 2026 13:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219440;
	bh=iwcZEp35JnYKDkX4lJx1dXeyDEL+QoTBBTwZXWLc3p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxZQRhMWZtj2xc0gT+QdqgchgjpJV0q6cgSzGhBs/nlxvmoky/9HjD7umJ/nVGBbr
	 ZKIsyEqpyiThAzDo8eTIEokuPtAVbyv+z+jvCPvaXsfsaZZrF096B2aXawWSBBJF/N
	 6p7vjtPceffc59ScWZi+IIiZIwwYFt+c1MEpxfmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1352/1376] phy: qcom: qmp-combo: Add missing PLL (VCO) configuration on SM8750
Date: Sat, 12 Sep 2026 09:02:58 +0200
Message-ID: <20260912065637.665529539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 304c102cff7382353a28039907a7017bde795db9 ]

Add missing DP PHY status and VCO clock configuration registers to fix
configuring the VCO rate on SM8750.  Without proper VCO rate setting, it
works on after-reset half of rate which is not enough for DP over USB to
work as seen on logs:

  [drm:msm_dp_ctrl_link_train_1_2] *ERROR* max v_level reached
  [drm:msm_dp_ctrl_link_train_1_2] *ERROR* link training #1 on phy 0 failed. ret=-11

Fixes: c4364048baf4 ("phy: qcom: qmp-combo: Add new PHY sequences for SM8750")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250616062541.7167-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 7df2892b88c7a..535dffd3d7b0d 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -249,6 +249,9 @@ static const unsigned int qmp_v8_usb3phy_regs_layout[QPHY_LAYOUT_SIZE] = {
 	[QPHY_COM_CMN_STATUS]		= QSERDES_V8_COM_CMN_STATUS,
 	[QPHY_COM_BIAS_EN_CLKBUFLR_EN]	= QSERDES_V8_COM_BIAS_EN_CLKBUFLR_EN,
 
+	[QPHY_DP_PHY_STATUS]		= QSERDES_V6_DP_PHY_STATUS,
+	[QPHY_DP_PHY_VCO_DIV]		= QSERDES_V6_DP_PHY_VCO_DIV,
+
 	[QPHY_TX_TX_POL_INV]		= QSERDES_V8_TX_TX_POL_INV,
 	[QPHY_TX_TX_DRV_LVL]		= QSERDES_V8_TX_TX_DRV_LVL,
 	[QPHY_TX_TX_EMP_POST1_LVL]	= QSERDES_V8_TX_TX_EMP_POST1_LVL,
-- 
2.53.0



