Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D3C346E50;
	Wed,  3 Dec 2025 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779372; cv=none; b=OMu7wEuEn6e0cyADIzpoFNSpm7Tem1BFI+laxhvS/HM05bK4uI+1ZIAb5huPSkDFC56q9XspiTazuwG/9yikyTVnAVK9Qft6vI5e/KfOIRIZtbLtSTaYPbfg6Jd70Eyh6P9tCEAzX8reP9Q1D1cS2sKgOVhPIXt0c0yx3xb7Sps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779372; c=relaxed/simple;
	bh=0UR2sq0I0Yf9vR+Gcwu2QZc3R4l9e9AW4sG9mrJeqJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shoZ9J3NWf4AQvLSH23TWiQOvdgWO1OeKw9WSGWWsihFqgtGH+o1GK7SV1NdQ/K9x3Bo6Wh0JtQ8hPsxwy9Lgq959Do2b6dJVumZvkZf2EluS2OMT2t1YCk0vVn6gfqHb61UDz6YSRNw8TtCu5DLeFZQoac9MFZ31webo7fWIQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWbmD95u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWbmD95u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11709C4CEF5;
	Wed,  3 Dec 2025 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779372;
	bh=0UR2sq0I0Yf9vR+Gcwu2QZc3R4l9e9AW4sG9mrJeqJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWbmD95umsj9oex5xIUeyKQ81Xy7yReJJN/KBndT5tb7nTpkgNR7iu71/doCLwZ/k
	 XBwHDAm9vTjWBXTzePAh0/y0Njkf7rr5SdOX11xK4r5FjErninIUQUF9Kx/5l/tMcM
	 Ghip/t0wjZeRjaBBit0JSiNRDr7odGnJhcs+u+4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Michael Riesch <michael.riesch@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/568] phy: rockchip: phy-rockchip-inno-csidphy: allow writes to grf register 0
Date: Wed,  3 Dec 2025 16:23:33 +0100
Message-ID: <20251203152448.450941406@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Riesch <michael.riesch@collabora.com>

[ Upstream commit 8c7c19466c854fa86b82d2148eaa9bf0e6531423 ]

The driver for the Rockchip MIPI CSI-2 DPHY uses GRF register offset
value 0 to sort out undefined registers. However, the RK3588 CSIDPHY GRF
this offset is perfectly fine (in fact, register 0 is the only one in
this register file).
Introduce a boolean variable to indicate valid registers and allow writes
to register 0.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Michael Riesch <michael.riesch@collabora.com>
Link: https://lore.kernel.org/r/20250616-rk3588-csi-dphy-v4-4-a4f340a7f0cf@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c b/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c
index 75f948bdea6a1..20737a0400f5c 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c
@@ -87,10 +87,11 @@ struct dphy_reg {
 	u32 offset;
 	u32 mask;
 	u32 shift;
+	u8 valid;
 };
 
 #define PHY_REG(_offset, _width, _shift) \
-	{ .offset = _offset, .mask = BIT(_width) - 1, .shift = _shift, }
+	{ .offset = _offset, .mask = BIT(_width) - 1, .shift = _shift, .valid = 1, }
 
 static const struct dphy_reg rk1808_grf_dphy_regs[] = {
 	[GRF_DPHY_CSIPHY_FORCERXMODE] = PHY_REG(RK1808_GRF_PD_VI_CON_OFFSET, 4, 0),
@@ -145,7 +146,7 @@ static inline void write_grf_reg(struct rockchip_inno_csidphy *priv,
 	const struct dphy_drv_data *drv_data = priv->drv_data;
 	const struct dphy_reg *reg = &drv_data->grf_regs[index];
 
-	if (reg->offset)
+	if (reg->valid)
 		regmap_write(priv->grf, reg->offset,
 			     HIWORD_UPDATE(value, reg->mask, reg->shift));
 }
-- 
2.51.0



