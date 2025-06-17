Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115562EA171;
	Tue, 17 Jun 2025 16:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178582; cv=none; b=lLG0356PuN+rzfA+iGooipb+oaR5E0G7n7PgoYnFpx2C10YouTMzoiccD6i9LMvzKbBF2GGE90F4zULhSw5p4WR1q5tR2zFosSTgkhb6OpD92Jc6/idKucFah+6smlEX9A1e07hGBugHd2ZNkOrzl0yhfMln0+BZBECia6rG5Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178582; c=relaxed/simple;
	bh=4N2VYTycZSmHUrtvYG683ApPuHJjbk7gQl1gUx/KXZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlb3tVKBK+0ewpUPKXJ9aTeWVqIkjgH/WDAa56h99hNGBeE2YbnQ28FeIjHkFPvObnGbWNUWFA19nX6Ssl8CJYgHex4+4JmaeHZRHRt6tgP0GCqUkhPTgIYnZyJQmY+qSSst/nmMr34cnG+HcyNkL70NylJ1iuomtpcgORvNwFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSB5xf3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSB5xf3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEF3C4CEE3;
	Tue, 17 Jun 2025 16:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178581;
	bh=4N2VYTycZSmHUrtvYG683ApPuHJjbk7gQl1gUx/KXZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSB5xf3W27QYUYcNm7SdO3RTSkWfRiaWiCCcPIu+1XJILkJetxdci4lsf1GRCNN3s
	 sHZMkxB5yWT4QJ1pS6rdE63W7046EVghle6nwL9QhX56ssHngpf9HXP0lX55TVvvBs
	 IPoR8z/Qx843AtEaX119R83gDN81sXCA4BL+BQc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 491/780] phy: rockchip: samsung-hdptx: Fix clock ratio setup
Date: Tue, 17 Jun 2025 17:23:19 +0200
Message-ID: <20250617152511.478291240@linuxfoundation.org>
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
index 77236f012a1f7..6cfed3fcd647b 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -320,6 +320,7 @@
 #define LN3_TX_SER_RATE_SEL_HBR2_MASK	BIT(3)
 #define LN3_TX_SER_RATE_SEL_HBR3_MASK	BIT(2)
 
+#define HDMI14_MAX_RATE			340000000
 #define HDMI20_MAX_RATE			600000000
 
 enum dp_link_rate {
@@ -1074,7 +1075,7 @@ static int rk_hdptx_ropll_tmds_mode_config(struct rk_hdptx_phy *hdptx,
 
 	regmap_write(hdptx->regmap, LNTOP_REG(0200), 0x06);
 
-	if (rate >= 3400000) {
+	if (rate > HDMI14_MAX_RATE / 100) {
 		/* For 1/40 bitrate clk */
 		rk_hdptx_multi_reg_write(hdptx, rk_hdtpx_tmds_lntop_highbr_seq);
 	} else {
-- 
2.39.5



