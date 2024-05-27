Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAF8262BE;
	Mon, 27 May 2024 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838081; cv=none; b=M42D3y9sCy/RkviLc6Brw8E6ckThQuK6Tr2SAIbkcZF/jmiWWu9FFubWHS3mipp4UwhApqkm4kuFWhFPnjVJDYQgg93lpeqWHSIOORS97r3BtvDV82GWOlpK/ZQN6huYqL2lfqjp4iejBu+lhV/GbcSQLOrpNfKUZNFIp1mJiVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838081; c=relaxed/simple;
	bh=5g/XY3sspELp0Dwgvg4j47m0aRDIJPyCZCLFaG5I08g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pfb3rq1nfGQKSNUz8rfv92qXdxESoIbcv5gumPYrLBkJILXOna4B9+3WWMZZa0dh/pLu7LdR+yNl0MJuka8z6WJFrl3IPbNcJom9+3VSe1jxl9OT0BXZQ7I35c1zMhy6nTSdfn3QY89EekAGgvC1qq2h+fALgMvhWtzI7S9DE6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOexW590; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOexW590"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DC8C2BBFC;
	Mon, 27 May 2024 19:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838081;
	bh=5g/XY3sspELp0Dwgvg4j47m0aRDIJPyCZCLFaG5I08g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOexW590iUzbVdmYmOymbQj2OoJJZXfF3gscIs9sEKiikFAk/jkan1GhAKzhDxAH3
	 246gwHQIbvp/eXfb9nBi5cr7iQzstj4sS7kLEMkc3fpMbMxLMqnuSfUNKy4t1BKZaF
	 tWE8PjTAZyTKEo+rXNcD9M2QH15yw+jV/26R5BkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 257/493] pwm: Drop useless member .of_pwm_n_cells of struct pwm_chip
Date: Mon, 27 May 2024 20:54:19 +0200
Message-ID: <20240527185638.700189244@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 4e77431cda4973f03d063c47f6ea313dfceebf16 ]

Apart from the two of_xlate implementations this member is write-only.
In the of_xlate functions of_pwm_xlate_with_flags() and
of_pwm_single_xlate() it's more sensible to check for args->args_count
because this is what is actually used in the device tree.

Acked-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/53d8c545aa8f79a920358be9e72e382b3981bdc4.1704835845.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: 3e551115aee0 ("pwm: meson: Add check for error from clk_round_rate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c |  1 -
 drivers/pwm/core.c                    | 22 +++-------------------
 drivers/pwm/pwm-clps711x.c            |  1 -
 drivers/pwm/pwm-cros-ec.c             |  1 -
 drivers/pwm/pwm-pxa.c                 |  4 +---
 include/linux/pwm.h                   |  2 --
 6 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 62cc3893dca5d..1f6e929c2f6a3 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -1591,7 +1591,6 @@ static int ti_sn_pwm_probe(struct auxiliary_device *adev,
 	pdata->pchip.ops = &ti_sn_pwm_ops;
 	pdata->pchip.npwm = 1;
 	pdata->pchip.of_xlate = of_pwm_single_xlate;
-	pdata->pchip.of_pwm_n_cells = 1;
 
 	devm_pm_runtime_enable(&adev->dev);
 
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index f2728ee787d7a..31f210872a079 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -107,9 +107,6 @@ of_pwm_xlate_with_flags(struct pwm_chip *chip, const struct of_phandle_args *arg
 {
 	struct pwm_device *pwm;
 
-	if (chip->of_pwm_n_cells < 2)
-		return ERR_PTR(-EINVAL);
-
 	/* flags in the third cell are optional */
 	if (args->args_count < 2)
 		return ERR_PTR(-EINVAL);
@@ -124,10 +121,8 @@ of_pwm_xlate_with_flags(struct pwm_chip *chip, const struct of_phandle_args *arg
 	pwm->args.period = args->args[1];
 	pwm->args.polarity = PWM_POLARITY_NORMAL;
 
-	if (chip->of_pwm_n_cells >= 3) {
-		if (args->args_count > 2 && args->args[2] & PWM_POLARITY_INVERTED)
-			pwm->args.polarity = PWM_POLARITY_INVERSED;
-	}
+	if (args->args_count > 2 && args->args[2] & PWM_POLARITY_INVERTED)
+		pwm->args.polarity = PWM_POLARITY_INVERSED;
 
 	return pwm;
 }
@@ -138,9 +133,6 @@ of_pwm_single_xlate(struct pwm_chip *chip, const struct of_phandle_args *args)
 {
 	struct pwm_device *pwm;
 
-	if (chip->of_pwm_n_cells < 1)
-		return ERR_PTR(-EINVAL);
-
 	/* validate that one cell is specified, optionally with flags */
 	if (args->args_count != 1 && args->args_count != 2)
 		return ERR_PTR(-EINVAL);
@@ -164,16 +156,8 @@ static void of_pwmchip_add(struct pwm_chip *chip)
 	if (!chip->dev || !chip->dev->of_node)
 		return;
 
-	if (!chip->of_xlate) {
-		u32 pwm_cells;
-
-		if (of_property_read_u32(chip->dev->of_node, "#pwm-cells",
-					 &pwm_cells))
-			pwm_cells = 2;
-
+	if (!chip->of_xlate)
 		chip->of_xlate = of_pwm_xlate_with_flags;
-		chip->of_pwm_n_cells = pwm_cells;
-	}
 
 	of_node_get(chip->dev->of_node);
 }
diff --git a/drivers/pwm/pwm-clps711x.c b/drivers/pwm/pwm-clps711x.c
index 42179b3f7ec39..06562d4bb9633 100644
--- a/drivers/pwm/pwm-clps711x.c
+++ b/drivers/pwm/pwm-clps711x.c
@@ -103,7 +103,6 @@ static int clps711x_pwm_probe(struct platform_device *pdev)
 	priv->chip.dev = &pdev->dev;
 	priv->chip.npwm = 2;
 	priv->chip.of_xlate = clps711x_pwm_xlate;
-	priv->chip.of_pwm_n_cells = 1;
 
 	spin_lock_init(&priv->lock);
 
diff --git a/drivers/pwm/pwm-cros-ec.c b/drivers/pwm/pwm-cros-ec.c
index 5fe303b8656de..339cedf3a7b18 100644
--- a/drivers/pwm/pwm-cros-ec.c
+++ b/drivers/pwm/pwm-cros-ec.c
@@ -279,7 +279,6 @@ static int cros_ec_pwm_probe(struct platform_device *pdev)
 	chip->dev = dev;
 	chip->ops = &cros_ec_pwm_ops;
 	chip->of_xlate = cros_ec_pwm_xlate;
-	chip->of_pwm_n_cells = 1;
 
 	if (ec_pwm->use_pwm_type) {
 		chip->npwm = CROS_EC_PWM_DT_COUNT;
diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index 76685f926c758..61b74fa1d3481 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -180,10 +180,8 @@ static int pwm_probe(struct platform_device *pdev)
 	pc->chip.ops = &pxa_pwm_ops;
 	pc->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
 
-	if (IS_ENABLED(CONFIG_OF)) {
+	if (IS_ENABLED(CONFIG_OF))
 		pc->chip.of_xlate = of_pwm_single_xlate;
-		pc->chip.of_pwm_n_cells = 1;
-	}
 
 	pc->mmio_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pc->mmio_base))
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index fcc2c4496f731..8ffe9ae7a23a9 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -271,7 +271,6 @@ struct pwm_ops {
  * @id: unique number of this PWM chip
  * @npwm: number of PWMs controlled by this chip
  * @of_xlate: request a PWM device given a device tree PWM specifier
- * @of_pwm_n_cells: number of cells expected in the device tree PWM specifier
  * @atomic: can the driver's ->apply() be called in atomic context
  * @pwms: array of PWM devices allocated by the framework
  */
@@ -284,7 +283,6 @@ struct pwm_chip {
 
 	struct pwm_device * (*of_xlate)(struct pwm_chip *chip,
 					const struct of_phandle_args *args);
-	unsigned int of_pwm_n_cells;
 	bool atomic;
 
 	/* only used internally by the PWM framework */
-- 
2.43.0



