Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FE12F2612;
	Tue, 11 Nov 2025 01:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823833; cv=none; b=rUAhZR1yghwzvWPwShPz+RixaH6u/7Bm4DSG/uogHkfAtY+LVVyNKuj6y2kT/6zCS31yBarWztk6BXUkhxHgTzg63qHReN0ujsLgYweuF15uovJeJ7+eXaPU58xOCmjH/8bOR93F2VZUYSTxjI6q1tbOQpAdpBpCZRr2kkIcW/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823833; c=relaxed/simple;
	bh=YlkoS1V+qR5rQKP7P1s2iEKHpEgPbBPQW1se8+JOduU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNlcN5ZCMqKZbiJw1y95ZPgBK7fE98c/rmfIxiuRl808nDkaW8oMy/HAF3+HRB/iVxF2nqrmJtjV47ZNnFYHewGkp9h9WVGEhbD/3p5KhEAaL/n9Waz2dVZbTq0EWcGZzPD9qHHfT0+7drOLisr8mOYFE0nC6u0NVXn0KFCRvvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBjEqakn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBjEqakn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F50AC4CEFB;
	Tue, 11 Nov 2025 01:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823832;
	bh=YlkoS1V+qR5rQKP7P1s2iEKHpEgPbBPQW1se8+JOduU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBjEqakn/uno+O7pkXwcy4HMMvBrjqispZyeRBfzN8O5BzEiO5qnYC899AatkYGtA
	 MOZfLbdrj25OQXfQGzIZQFyZaPFdj1UiKvWcoyN10Dkr1WdUDTR0Um/5BbUnDd0/r9
	 j0VZmUjpB6aH85eeqPtalR2F5B2jrWxtinbRWX0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Michael Riesch <michael.riesch@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/565] phy: rockchip: phy-rockchip-inno-csidphy: allow writes to grf register 0
Date: Tue, 11 Nov 2025 09:43:09 +0900
Message-ID: <20251111004534.374157775@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 98c92d6c482fe..279e19e7546b6 100644
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



