Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E61F12D1FC;
	Tue, 30 Apr 2024 11:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476711; cv=none; b=anhgAV6LmwO8nxQjEq4Kes7sDIC4g9Q+9EATIq7rUSjCNcCizq+0hCravUYU2hNZWKQMtsJoChlHvxBN4pFxPtwKNeqOZyXRIIHlLFQIxss+zzC7oW9fJ64YVoIog3CvU3tGVerJ64A2t2AVPp51KdUqQTyqLP7gzXAmtIpFbgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476711; c=relaxed/simple;
	bh=SM5EWBXI7mMvnesWWcwT1Z3lJl2a+H7dbcPh7iGucP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bufNxHyjexk2tOjBuSHWV6veSymVPueU/exMLs8OUOIKIaW6Df+XwAqLiQqUGUYkiieCaaLZ5e/6M9UuWCFV5oEW6WJFC7xe9gOGDUv6hwp4idM8yATQ8yYU2WFKH+FoT+myTrDuw93PIxmLkzT9kL1PzuYpL9MtWuPw1728Y2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzUxomEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzUxomEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C197BC2BBFC;
	Tue, 30 Apr 2024 11:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476711;
	bh=SM5EWBXI7mMvnesWWcwT1Z3lJl2a+H7dbcPh7iGucP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzUxomEofqrjbf7IbmzZ+nFVBXc6dm+c7IAiHgifmnf8wJHABhdbpF8JC4La8pkXJ
	 rSADC60WYvngUWHaWWrz5ssorI8W2eCHfn1XFtXbVeceNtmgjuPllAWYRWD08FIsvm
	 v7AWS7gNYeeVNTdGA/FZuMXhK13PTi2J3DRCFiHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/110] phy: rockchip-snps-pcie3: fix clearing PHP_GRF_PCIESEL_CON bits
Date: Tue, 30 Apr 2024 12:41:09 +0200
Message-ID: <20240430103050.527325785@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 55491a5fa163bf15158f34f3650b3985f25622b9 ]

Currently the PCIe v3 PHY driver only sets the pcie1ln_sel bits, but
does not clear them because of an incorrect write mask. This fixes up
the issue by using a newly introduced constant for the write mask.

While at it also introduces a proper GENMASK based constant for the
PCIE30_PHY_MODE.

Fixes: 2e9bffc4f713 ("phy: rockchip: Support PCIe v3")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20240404-rk3588-pcie-bifurcation-fixes-v1-2-9907136eeafd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-snps-pcie3.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c b/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c
index 4f32a2dc24580..c6aa6bc69e900 100644
--- a/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c
+++ b/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c
@@ -39,6 +39,8 @@
 #define RK3588_BIFURCATION_LANE_0_1		BIT(0)
 #define RK3588_BIFURCATION_LANE_2_3		BIT(1)
 #define RK3588_LANE_AGGREGATION		BIT(2)
+#define RK3588_PCIE1LN_SEL_EN			(GENMASK(1, 0) << 16)
+#define RK3588_PCIE30_PHY_MODE_EN		(GENMASK(2, 0) << 16)
 
 struct rockchip_p3phy_ops;
 
@@ -148,14 +150,15 @@ static int rockchip_p3phy_rk3588_init(struct rockchip_p3phy_priv *priv)
 	}
 
 	reg = mode;
-	regmap_write(priv->phy_grf, RK3588_PCIE3PHY_GRF_CMN_CON0, (0x7<<16) | reg);
+	regmap_write(priv->phy_grf, RK3588_PCIE3PHY_GRF_CMN_CON0,
+		     RK3588_PCIE30_PHY_MODE_EN | reg);
 
 	/* Set pcie1ln_sel in PHP_GRF_PCIESEL_CON */
 	if (!IS_ERR(priv->pipe_grf)) {
-		reg = mode & 3;
+		reg = mode & (RK3588_BIFURCATION_LANE_0_1 | RK3588_BIFURCATION_LANE_2_3);
 		if (reg)
 			regmap_write(priv->pipe_grf, PHP_GRF_PCIESEL_CON,
-				     (reg << 16) | reg);
+				     RK3588_PCIE1LN_SEL_EN | reg);
 	}
 
 	reset_control_deassert(priv->p30phy);
-- 
2.43.0



