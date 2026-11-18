Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023968;
	b=QzhscrpBeha524QeuVJu4u24fas0goQLxnZdWM450tXnMNQ57/dLhhoJAS+MmwQHdEXq
	 qQmSmyBfNKjXjVOGE60Y88YGacIUyOvsAGeeVt3MNHUwD/TBwhJiSTChTAme3s1Bye49B
	 aTymQ2o85kMDObDxoS7u0KS/Q2cTGn3vL2pS56ThqctCegzyKNL0rXObZyP3h5jjWR2I1
	 wzvmmv4pqv/nZLRhawT/fG6/KnNcxswghgsENDZc9MmmgGdC1fcyoB5efTFmLzVCCofZU
	 TqbqSZqwKTZPXxUygG04Ioib9ZrXGElbRfFU3MLwMPwU5jSNN4+TNzGJwqJv3W8WlTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PYF6Rodqr8cpHcv47LZgSZgUJyVuDXJ+7VJhxyey7e0=;
	b=36XdSQz1JpBKSrXTdYhdJXHcE31vR1QWqW/dRyys1AfI6eELOxyF7U2H5t3YQA2nT0fX
	 7DTXueGWNnW5UfEZmLbZOfehTlsG52Y5lJ/KgQ26fuNlXTNWTSIz5PsN4QI6fmoVrHGr9
	 O9b3x/S6LLJnbj5yMTETxkgu1hDK+mXfZstbjXScOAelCfXP0vDFGNHX4X0j00wmJ0HV3
	 bG3enY8llY+O1n5KHEi7wmp6rS+jnMMhmh95eRGQqvzXiiiA25rIkY2ZSxCHa86P9YOYU
	 iz4dC/e61gLvmNkFeBDxscw37ffUz6k9zoxVkrkuGFyvCHyEMqM6BdWxosOljJgtoEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljKEzCdz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD132606A320;
	Wed, 18 Nov 2026 17:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljKEzCdz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D031F000C6;
	Wed, 18 Nov 2026 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023968;
	bh=PYF6Rodqr8cpHcv47LZgSZgUJyVuDXJ+7VJhxyey7e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljKEzCdzCnmpSBmA8RPTCgFr1UJ3CLyT0h+ZlR44X8KeXT6ibEOYdfkNAbiiwdQ+C
	 iOXEyUgsDezK7mtFOYkJiQdq74Z0bf3cxOolitJ/wtFx3NMqm9J4tfVh5qqbNCvUmI
	 a2stUIHPyHFa/FBGvcRdabeqII//JhlzsW03+nQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0556/2151] thermal: renesas: rzg3e: make min and max temperature per-chip
Date: Wed, 18 Nov 2026 15:38:11 +0100
Message-ID: <20261118150142.213858471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

[ Upstream commit 6c7f87f517d3704a3fcc3b1c7f4220c2fcf75322 ]

The Renesas RZ/T2H (R9A09G077) and RZ/N2H (R9A09G087) SoCs have
different minimum and maximum temperatures compared to the already
supported RZ/G3E.

Prepare for them by moving these into a chip-specific struct.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: John Madieu <john.madieu.xa@bp.renesas.com>
Tested-by: John Madieu <john.madieu.xa@bp.renesas.com>
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Link: https://patch.msgid.link/20260108195223.193531-3-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Stable-dep-of: 84f0e14e6261 ("drivers/thermal/renesas/rzg3e: Fix signed integer overflow in temp_to_code()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/renesas/rzg3e_thermal.c | 35 ++++++++++++++++---------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/thermal/renesas/rzg3e_thermal.c b/drivers/thermal/renesas/rzg3e_thermal.c
index e66d73ca67527..246ff368b0346 100644
--- a/drivers/thermal/renesas/rzg3e_thermal.c
+++ b/drivers/thermal/renesas/rzg3e_thermal.c
@@ -62,8 +62,6 @@
 #define TSU_SICR_CMPCLR	BIT(1)
 
 /* Temperature calculation constants from datasheet */
-#define TSU_TEMP_D		(-41)
-#define TSU_TEMP_E		126
 #define TSU_CODE_MAX		0xFFF
 
 /* Timing specifications from datasheet */
@@ -72,6 +70,11 @@
 #define TSU_POLL_DELAY_US	10	/* Polling interval */
 #define TSU_MIN_CLOCK_RATE	24000000  /* TSU_PCLK minimum 24MHz */
 
+struct rzg3e_thermal_info {
+	int temp_d_mc;
+	int temp_e_mc;
+};
+
 /**
  * struct rzg3e_thermal_priv - RZ/G3E TSU private data
  * @base: TSU register base
@@ -79,6 +82,7 @@
  * @syscon: regmap for calibration values
  * @zone: thermal zone device
  * @rstc: reset control
+ * @info: chip type specific information
  * @trmval0: calibration value 0 (b)
  * @trmval1: calibration value 1 (c)
  * @trim_offset: offset for trim registers in syscon
@@ -90,6 +94,7 @@ struct rzg3e_thermal_priv {
 	struct regmap *syscon;
 	struct thermal_zone_device *zone;
 	struct reset_control *rstc;
+	const struct rzg3e_thermal_info *info;
 	u16 trmval0;
 	u16 trmval1;
 	u32 trim_offset;
@@ -161,17 +166,17 @@ static void rzg3e_thermal_power_off(struct rzg3e_thermal_priv *priv)
  */
 static int rzg3e_thermal_code_to_temp(struct rzg3e_thermal_priv *priv, u16 code)
 {
-	int temp_e_mc = TSU_TEMP_E * MILLIDEGREE_PER_DEGREE;
-	int temp_d_mc = TSU_TEMP_D * MILLIDEGREE_PER_DEGREE;
+	const struct rzg3e_thermal_info *info = priv->info;
 	s64 numerator, denominator;
 	int temp_mc;
 
-	numerator = (temp_e_mc - temp_d_mc) * (s64)(code - priv->trmval0);
+	numerator = (info->temp_e_mc - info->temp_d_mc) *
+		    (s64)(code - priv->trmval0);
 	denominator = priv->trmval1 - priv->trmval0;
 
-	temp_mc = div64_s64(numerator, denominator) + temp_d_mc;
+	temp_mc = div64_s64(numerator, denominator) + info->temp_d_mc;
 
-	return clamp(temp_mc, temp_d_mc, temp_e_mc);
+	return clamp(temp_mc, info->temp_d_mc, info->temp_e_mc);
 }
 
 /*
@@ -180,13 +185,12 @@ static int rzg3e_thermal_code_to_temp(struct rzg3e_thermal_priv *priv, u16 code)
  */
 static u16 rzg3e_thermal_temp_to_code(struct rzg3e_thermal_priv *priv, int temp_mc)
 {
-	int temp_e_mc = TSU_TEMP_E * MILLIDEGREE_PER_DEGREE;
-	int temp_d_mc = TSU_TEMP_D * MILLIDEGREE_PER_DEGREE;
+	const struct rzg3e_thermal_info *info = priv->info;
 	s64 numerator, denominator;
 	s64 code;
 
-	numerator = (temp_mc - temp_d_mc) * (priv->trmval1 - priv->trmval0);
-	denominator = temp_e_mc - temp_d_mc;
+	numerator = (temp_mc - info->temp_d_mc) * (priv->trmval1 - priv->trmval0);
+	denominator = info->temp_e_mc - info->temp_d_mc;
 
 	code = div64_s64(numerator, denominator) + priv->trmval0;
 
@@ -392,6 +396,8 @@ static int rzg3e_thermal_probe(struct platform_device *pdev)
 		return ret;
 	platform_set_drvdata(pdev, priv);
 
+	priv->info = device_get_match_data(dev);
+
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
@@ -526,8 +532,13 @@ static const struct dev_pm_ops rzg3e_thermal_pm_ops = {
 	SYSTEM_SLEEP_PM_OPS(rzg3e_thermal_suspend, rzg3e_thermal_resume)
 };
 
+static const struct rzg3e_thermal_info rzg3e_thermal_info = {
+	.temp_d_mc = -41000,
+	.temp_e_mc = 126000,
+};
+
 static const struct of_device_id rzg3e_thermal_dt_ids[] = {
-	{ .compatible = "renesas,r9a09g047-tsu" },
+	{ .compatible = "renesas,r9a09g047-tsu", .data = &rzg3e_thermal_info },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, rzg3e_thermal_dt_ids);
-- 
2.53.0



