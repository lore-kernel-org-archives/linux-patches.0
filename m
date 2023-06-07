Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE873925A
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA35C433D2;
	Wed,  7 Jun 2023 20:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169276;
	bh=5EyFGGi44qqO3kvQGy5LGPsVuZDLYemBmcYj8NIYIAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqQDAo/3KEtz3v9NCBRuWp92BQd21Z/qErCODIL9l8tyR9U7Q4FBD3D3svY/0R3rB
	 jx6fnYe6+Fli6b7IQgvwGWy9QSo2jei+Dd1i+MkMRAxAz3+2QRoXWqmA650t0/Bgfz
	 10brL2k9saYRjTOiFS86ou4mZkeRchUa4JS8RIFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 002/286] phy: amlogic: phy-meson-g12a-mipi-dphy-analog: fix CNTL2_DIF_TX_CTL0 value
Date: Wed,  7 Jun 2023 22:11:41 +0200
Message-ID: <20230607200923.061917413@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit b949193011540bb17cf1da7795ec42af1b875203 ]

Use the same CNTL2_DIF_TX_CTL0 value used by the vendor, it was reported
fixing timings issues.

Fixes: 2a56dc650e54 ("phy: amlogic: Add G12A Analog MIPI D-PHY driver")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230512-amlogic-v6-4-upstream-dsi-ccf-vim3-v4-10-2592c29ea263@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/amlogic/phy-meson-g12a-mipi-dphy-analog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/amlogic/phy-meson-g12a-mipi-dphy-analog.c b/drivers/phy/amlogic/phy-meson-g12a-mipi-dphy-analog.c
index c14089fa7db49..cabdddbbabfd7 100644
--- a/drivers/phy/amlogic/phy-meson-g12a-mipi-dphy-analog.c
+++ b/drivers/phy/amlogic/phy-meson-g12a-mipi-dphy-analog.c
@@ -70,7 +70,7 @@ static int phy_g12a_mipi_dphy_analog_power_on(struct phy *phy)
 		     HHI_MIPI_CNTL1_BANDGAP);
 
 	regmap_write(priv->regmap, HHI_MIPI_CNTL2,
-		     FIELD_PREP(HHI_MIPI_CNTL2_DIF_TX_CTL0, 0x459) |
+		     FIELD_PREP(HHI_MIPI_CNTL2_DIF_TX_CTL0, 0x45a) |
 		     FIELD_PREP(HHI_MIPI_CNTL2_DIF_TX_CTL1, 0x2680));
 
 	reg = DSI_LANE_CLK;
-- 
2.39.2



