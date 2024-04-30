Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7906A2BB07;
	Tue, 30 Apr 2024 10:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474609; cv=none; b=XaxLHQhsm2cjqvChIVgX7MOtRXm1/spiqYUPDn0p8X6HqkT2JSEmCv+QQEVDgIRttRqyS3a6DGhNi4G8WrjDaouLaf31C2kP3+JVT3YbqjGmEa57qKRpSaAZRoV/FlAp5a/oCecogMONwzkog3lczmZ6TuFgNE0OBpZ5JobXrj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474609; c=relaxed/simple;
	bh=a/xme8PbV1P76evrdZ8Bu+zJfUXoEdRBcW/HrGYxMHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKXUdo+ifuCjaWw4b9qnQiqWR30P9Lm8NLTaAghDrmJ5iyQxMftX1Ob/DBV9kWGuUXdj+R3DfSF4zkoYXGYRvI6HfvfR3SZdT0KoRYZN+3P4hEHI+a0sWEnlDUXUFU+ocVQutb6T4QnylkIGv9dFVon3TOKsbwe2HyTsFcLMXPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVx4VEZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVx4VEZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE65DC2BBFC;
	Tue, 30 Apr 2024 10:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474609;
	bh=a/xme8PbV1P76evrdZ8Bu+zJfUXoEdRBcW/HrGYxMHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVx4VEZlzdNOqE7yHl5SH0Wybe/aIGwASlikZInBvQiGp76gDfiV0SyWjW7RPtOsg
	 6yNcXrtsXWQeCgLdpn/bnxeZH71HcwsKGIKJnKgAU4YNe/88eCDIUsPnnLDkcG0Htg
	 LZ/CAKASMapnzqHE/AstxSkvRS30Oj0n8YlhXccw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 208/228] phy: rockchip-snps-pcie3: fix clearing PHP_GRF_PCIESEL_CON bits
Date: Tue, 30 Apr 2024 12:39:46 +0200
Message-ID: <20240430103109.807563493@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index d5bcc9c42b284..9857ee45b89e0 100644
--- a/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c
+++ b/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c
@@ -40,6 +40,8 @@
 #define RK3588_BIFURCATION_LANE_0_1		BIT(0)
 #define RK3588_BIFURCATION_LANE_2_3		BIT(1)
 #define RK3588_LANE_AGGREGATION		BIT(2)
+#define RK3588_PCIE1LN_SEL_EN			(GENMASK(1, 0) << 16)
+#define RK3588_PCIE30_PHY_MODE_EN		(GENMASK(2, 0) << 16)
 
 struct rockchip_p3phy_ops;
 
@@ -149,14 +151,15 @@ static int rockchip_p3phy_rk3588_init(struct rockchip_p3phy_priv *priv)
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



