Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0836B2571CB;
	Mon, 24 Feb 2025 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409024; cv=none; b=PnFmFEPtkGwBEsAwsRQrEj9ZQ9u2kAVP9x8o4CDN3/ruBdMfaz8ScC6Bk1H2OGlslrzC4wl7RLflafgc/1XfDtz5OyWIRz5AYpgq6wMWGblo1OhOXxACXfaH/x2tpHpOBrn4fx4DBR6agmJvtafHvGc8952fYZdc3mDRh4tqsmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409024; c=relaxed/simple;
	bh=OKfBFp0iSn+BMHiGtLcONIBgQoUVDGB1AbIpzf0shcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuCCLcPszSbjtdW3Rc1dkHSVIcxOSJsZrR56KJlOvjLYM5M4Is/dFnLshD/IE27RJKTlOCjGzI3/ZAPjvFnn9ymT7sxwqINRy9k+Kb4Ky7oHWiUR8cXEyurWVfkhZ5MLAoN0YwOfFc3c9Vq3My+uR+Deuj7ct4YhyvsvB4+bg/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZWOLwBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZWOLwBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D72C4CEE6;
	Mon, 24 Feb 2025 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409023;
	bh=OKfBFp0iSn+BMHiGtLcONIBgQoUVDGB1AbIpzf0shcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZWOLwBzWIS6PW6qN1MQGqJ5lGaKeGOkBaB7znWDkUwTpZbPwvKNewadQ/IC+qbTC
	 poOpPuWws03Ne2phUa8R2S9WNlro8vZt195FOYowtAmpubn0B63NPHSJvRczTsag+Z
	 y/lIbmVF83ueWc2Urse+44sFnmZiIty/3o+lIPjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 075/138] drm/msm/dsi/phy: Do not overwite PHY_CMN_CLK_CFG1 when choosing bitclk source
Date: Mon, 24 Feb 2025 15:35:05 +0100
Message-ID: <20250224142607.424693925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 73f69c6be2a9f22c31c775ec03c6c286bfe12cfa ]

PHY_CMN_CLK_CFG1 register has four fields being used in the driver: DSI
clock divider, source of bitclk and two for enabling the DSI PHY PLL
clocks.

dsi_7nm_set_usecase() sets only the source of bitclk, so should leave
all other bits untouched.  Use newly introduced
dsi_pll_cmn_clk_cfg1_update() to update respective bits without
overwriting the rest.

While shuffling the code, define and use PHY_CMN_CLK_CFG1 bitfields to
make the code more readable and obvious.

Fixes: 1ef7c99d145c ("drm/msm/dsi: add support for 7nm DSI PHY/PLL")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/637380/
Link: https://lore.kernel.org/r/20250214-drm-msm-phy-pll-cfg-reg-v3-3-0943b850722c@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c             | 4 ++--
 drivers/gpu/drm/msm/registers/display/dsi_phy_7nm.xml | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index 388017db45d80..798168180c1ab 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -617,7 +617,6 @@ static int dsi_7nm_pll_restore_state(struct msm_dsi_phy *phy)
 static int dsi_7nm_set_usecase(struct msm_dsi_phy *phy)
 {
 	struct dsi_pll_7nm *pll_7nm = to_pll_7nm(phy->vco_hw);
-	void __iomem *base = phy->base;
 	u32 data = 0x0;	/* internal PLL */
 
 	DBG("DSI PLL%d", pll_7nm->phy->id);
@@ -636,7 +635,8 @@ static int dsi_7nm_set_usecase(struct msm_dsi_phy *phy)
 	}
 
 	/* set PLL src */
-	writel(data << 2, base + REG_DSI_7nm_PHY_CMN_CLK_CFG1);
+	dsi_pll_cmn_clk_cfg1_update(pll_7nm, DSI_7nm_PHY_CMN_CLK_CFG1_BITCLK_SEL__MASK,
+				    DSI_7nm_PHY_CMN_CLK_CFG1_BITCLK_SEL(data));
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/msm/registers/display/dsi_phy_7nm.xml b/drivers/gpu/drm/msm/registers/display/dsi_phy_7nm.xml
index cfaf78c028b13..35f7f40e405b7 100644
--- a/drivers/gpu/drm/msm/registers/display/dsi_phy_7nm.xml
+++ b/drivers/gpu/drm/msm/registers/display/dsi_phy_7nm.xml
@@ -16,6 +16,7 @@ xsi:schemaLocation="https://gitlab.freedesktop.org/freedreno/ rules-fd.xsd">
 	<reg32 offset="0x00014" name="CLK_CFG1">
 		<bitfield name="CLK_EN" pos="5" type="boolean"/>
 		<bitfield name="CLK_EN_SEL" pos="4" type="boolean"/>
+		<bitfield name="BITCLK_SEL" low="2" high="3" type="uint"/>
 	</reg32>
 	<reg32 offset="0x00018" name="GLBL_CTRL"/>
 	<reg32 offset="0x0001c" name="RBUF_CTRL"/>
-- 
2.39.5



