Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214717;
	b=C4mfeePXELM2Y32oko+EK969mUu4rspybaPPwPDR2Und5B+Oul8O1s8v0P73/w8AfNRB
	 6GfvDfo9VldlOCVKgJ4DxtX78KjKWkyPFu2SgK3nLgy7Z6AFXOVcWdNSlAKTlcVKLp47n
	 8SgHBtJBmuTJGgTdGglqoaSLCXhDp5RIywy19A+PmWiaHbul2bhjXKGUNqRmSFT/ttH9c
	 C6QtwkpNXzy/MdCct4d0T0GfUxPqQCbehRCWOEE/LO02yHPVYMYahtt2z/dOd6WsAxGan
	 5xAnt8DHGLL1mwIWxJ7wiZJF5SoiKaYORpJoRcINKgARcg4ftsT5VQD2W6WwdcM1s/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SGEM/eo4rypWV3Ct+l1qtzfoSzrJ392hlQLgm+mB/Oc=;
	b=TyUPXyzuxyhNRi6KVq9p+fmelpP4ow4utPVHFP2EdZ88VxWitmEYOTTyZH07409Hex7z
	 dHC06QZiaZDdiiiNlEj4ozSZCO4FSMpZW4x7N+vQNZL8VJwirkpnO+NMWDeKJ3QmBmKlX
	 +L3wxAuO+OlXGeq802oQVEiPeoZGo4eoLvX6kN1Ot7CKmMrYahgbQ3WdkHPk6as+10kgA
	 Sq3lOU3FRD0fVn6rJD1MUe8UOBXIQe34270VTGBqWTFcOLQoZPNXGlDP6C0dX5osJSvJh
	 oFz+vLnK11xHPOu6Kew1h0IDK/MGwqbSw17rzpCByV0YdH06WU060TYDHv4vY9ivYKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVZysmMo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F7B606A33E;
	Wed, 28 Oct 2026 19:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVZysmMo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F291F01828;
	Wed, 28 Oct 2026 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214717;
	bh=SGEM/eo4rypWV3Ct+l1qtzfoSzrJ392hlQLgm+mB/Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVZysmMoZcCFBgMSs7hURXxlSET37qyYXY9st4kvd1B5gzbJxZ//95/7rnQzkerw7
	 XHig3GXCnLY/6HUQc7DCI/El5wpKh7ql9wjgHxXV9uYCHqv1O5EIOe9Ecv/pObjNA0
	 vedy6UsLIfDeV+jnoxNHaZ8JaJtQ+TP4XcbUyHHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0958/1887] pmdomain: imx8mp-blk-ctrl: Keep the NOC_HDCP clock enabled
Date: Wed, 28 Oct 2026 17:50:54 +0100
Message-ID: <20261028170521.207141959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit e91d5f94acf68618ea3ad9c92ac28614e791ae7d ]

Keep the NOC_HDCP clock always enabled to fix the potential hang
caused by the NoC ADB400 port power down handshake.

Fixes: 77b0ddb42add ("soc: imx: add i.MX8MP HDMI blk ctrl HDCP/HRV_MWR")
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8mp-blk-ctrl.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/soc/imx/imx8mp-blk-ctrl.c b/drivers/soc/imx/imx8mp-blk-ctrl.c
index 65848f6b8f352..5357711b2584c 100644
--- a/drivers/soc/imx/imx8mp-blk-ctrl.c
+++ b/drivers/soc/imx/imx8mp-blk-ctrl.c
@@ -250,9 +250,6 @@ static void imx8mp_hdmi_blk_ctrl_power_on(struct imx8mp_blk_ctrl *bc,
 		regmap_set_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(12));
 		regmap_clear_bits(bc->regmap, HDMI_TX_CONTROL0, BIT(3));
 		break;
-	case IMX8MP_HDMIBLK_PD_HDCP:
-		regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL0, BIT(11));
-		break;
 	case IMX8MP_HDMIBLK_PD_HRV:
 		regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(3) | BIT(4) | BIT(5));
 		regmap_set_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(15));
@@ -306,9 +303,6 @@ static void imx8mp_hdmi_blk_ctrl_power_off(struct imx8mp_blk_ctrl *bc,
 		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL0, BIT(7));
 		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(22) | BIT(24));
 		break;
-	case IMX8MP_HDMIBLK_PD_HDCP:
-		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL0, BIT(11));
-		break;
 	case IMX8MP_HDMIBLK_PD_HRV:
 		regmap_clear_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(15));
 		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(3) | BIT(4) | BIT(5));
@@ -337,7 +331,7 @@ static int imx8mp_hdmi_power_notifier(struct notifier_block *nb,
 	regmap_write(bc->regmap, HDMI_RTX_CLK_CTL0, 0x0);
 	regmap_write(bc->regmap, HDMI_RTX_CLK_CTL1, 0x0);
 	regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL0,
-			BIT(0) | BIT(1) | BIT(10));
+			BIT(0) | BIT(1) | BIT(10) | BIT(11));
 	regmap_set_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(0));
 
 	/*
-- 
2.53.0



