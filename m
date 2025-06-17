Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610A42ED84A;
	Tue, 17 Jun 2025 16:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177205; cv=none; b=jeevpVPvgevI2LPm/7LLGI3nXL5qJK0Cd3Hy6FHRhkjvOWfcniUZh6HxUnYh4eY149bPMeuR1Zep5XPKjs6+CI/2N2vsfIuZNFNsTefC0ker6mYuhr6zsxZ24KAj3XKgU+9FMFXPQ6SKwEJTMZxOSEibSE1Q8LZISmlUcU8hr0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177205; c=relaxed/simple;
	bh=hflle3bOD+lF2yRRrQzHANqkkCl6+LoTrvwrp3Jovh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXfatmlnU6ARaYrt7uzrCmKi52jyFuRMtsgDWQTCl2Xzn3LfokJ8iWeSiggr1b6P8FAT33Od6jXjL3Idh2A/1mi2lWweOqGaCziB8LCqK8ybXiSKeR/wDMXtY+4ket0m96DfQDmWNvsReB/dAyCZYSZ4YDaQgLAsignABVaqDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DshLvfCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DshLvfCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42DAC4CEE3;
	Tue, 17 Jun 2025 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177205;
	bh=hflle3bOD+lF2yRRrQzHANqkkCl6+LoTrvwrp3Jovh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DshLvfCy98xqSrCCLfHmhsTA7KVmq6DKt+cprBSx5dR4XcAx4ekuF7XDxMCeB2ujr
	 nB80zxl/mjCYLmlaO51Tcv4oUGrl3qDaLKsPNIihShaBavWnAq7ahhCRWZkso9l/+D
	 C//4V9K29GhdkiQhCwopu+8Q9Pewzih3HsKNiKYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/512] phy: rockchip: samsung-hdptx: Fix clock ratio setup
Date: Tue, 17 Jun 2025 17:24:33 +0200
Message-ID: <20250617152432.045416321@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 0422253ac1919fea8292381c85f11a9decff1bb1 ]

The switch from 1/10 to 1/40 clock ratio must happen when exceeding the
340 MHz rate limit of HDMI 1.4, i.e. when entering the HDMI 2.0 domain,
and not before.

Therefore, use the correct comparison operator '>' instead of '>=' when
checking the max rate.  While at it, introduce a define for this rate
limit constant.

Fixes: 553be2830c5f ("phy: rockchip: Add Samsung HDMI/eDP Combo PHY driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20250318-phy-sam-hdptx-bpc-v6-3-8cb1678e7663@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 9b99fdd43f5f5..70526c67ca0f1 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -192,6 +192,7 @@
 #define LN3_TX_SER_RATE_SEL_HBR2	BIT(3)
 #define LN3_TX_SER_RATE_SEL_HBR3	BIT(2)
 
+#define HDMI14_MAX_RATE			340000000
 #define HDMI20_MAX_RATE			600000000
 
 struct lcpll_config {
@@ -851,7 +852,7 @@ static int rk_hdptx_ropll_tmds_mode_config(struct rk_hdptx_phy *hdptx,
 
 	regmap_write(hdptx->regmap, LNTOP_REG(0200), 0x06);
 
-	if (rate >= 3400000) {
+	if (rate > HDMI14_MAX_RATE / 100) {
 		/* For 1/40 bitrate clk */
 		rk_hdptx_multi_reg_write(hdptx, rk_hdtpx_tmds_lntop_highbr_seq);
 	} else {
-- 
2.39.5



