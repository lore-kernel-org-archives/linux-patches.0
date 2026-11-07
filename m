Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061404;
	b=vRw7DNB3W//aq85QSSSePPByvw0BBce6R76Izf8y1EkFYhECV/I/w/acR8B55r+qZg7X
	 uAC3PFaVCH2xR2Be6JLnM+/0Wyp+XdOV+jAchkfZUzOLI54tyAMbv8/c6KH2G4pQz7Ilk
	 xeUClZ6+9EOGd6Ca4SeUt42Me59g7KPzuuNUvpKQLAIJUDd2Ec5scVhtQPfePcnYkwsIp
	 NJDNT0rkG5z0IUs4gTtGy/v7xVf4VUszBWWneXS8Z3e0Ot2h14yHjQPSpZmg1mB8clDvV
	 n3Q38O+8++HoX+OacnDH2OW+qu7uHSid4AhLS2wy6zpq5ZQoqPnsQVKhJ4JKxYQ/MdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a5485U20OO5qyokkVy/Wh/9F/V+ghzoTRiWBY3BA1rQ=;
	b=fe9RsuRwqf7n8ioyTIATeG0MjucRUC39hp/Aj+eUy5YtJPuIHOTgxxqZf4Z2UPhg76bH
	 vw/cLg7eNKeEv963QlzvuAumqbPt3qbdntnit0nJidjgGD7uBjav2M4iv9CDGiPOs6emP
	 +Zn+zXm7oWG+7mjTbgYcjMllq2v9adDkcRQnU9yPbsNqfe++6Bk5ZD4g929K/lNqiXcNF
	 dJTgOdI0sPqt4JdPQeImw8Y2QX1U+PWmH99TC6tpiplvpc1zaseqtgwuOx7OXMjK0qBV4
	 bj/+BfxaHdCfAZFu9YxUwO2zkCK350CulEqhxYsg8Gc4r7fbhgXrNSFFVb3NGsv68fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=duMy6EWk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9B6606A332;
	Sat,  7 Nov 2026 14:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=duMy6EWk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665A91F0089F;
	Sat,  7 Nov 2026 14:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061403;
	bh=a5485U20OO5qyokkVy/Wh/9F/V+ghzoTRiWBY3BA1rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duMy6EWkXasco7UU7lWGbapqIRNxN+u8U93WymRv+Xj9q9+r+uwYb6wFvPCgHqoiO
	 1xO2tkgMlbLPYVjk0FIBTId9+fWZCes6Y8kSOpSH9bEG59Y5DiSPQum5ExrU//VvsH
	 6ye0RuG1Whuubl3ovxwxUaVS4LDtNZh7HTkegFGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0521/1536] watchdog: rzv2h: Obtain clock-divider and timeout values from OF match data
Date: Sat,  7 Nov 2026 08:42:17 -0500
Message-ID: <20261107135012.062861279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 19f7eaec4d9d1dcd8b49e14dbad56a65810c2910 ]

Update the rzv2h_wdt driver to fetch clock configuration and timeout
parameters from device tree match data rather than relying on hardcoded
constants. Introduce a new structure rzv2h_of_data that encapsulates
minimum and maximum clock select values (cks_min and cks_max), clock
divider (cks_div), timeout cycle count (timeout_cycles), and the
timeout period select bits (tops). These values are provided through
the OF match table and retrieved via of_device_get_match_data() during
probe.

This change allows dynamic configuration of the watchdog timer for
different SoCs, such as the RZ/T2H, which require different settings.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Stable-dep-of: 6274281c41ef ("watchdog: rzv2h: Avoid division by zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rzv2h_wdt.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/rzv2h_wdt.c b/drivers/watchdog/rzv2h_wdt.c
index 1d1b173127477..a7f99a79c1e03 100644
--- a/drivers/watchdog/rzv2h_wdt.c
+++ b/drivers/watchdog/rzv2h_wdt.c
@@ -35,9 +35,6 @@
 
 #define WDTRCR_RSTIRQS		BIT(7)
 
-#define MAX_TIMEOUT_CYCLES	16384
-#define CLOCK_DIV_BY_256	256
-
 #define WDT_DEFAULT_TIMEOUT	60U
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
@@ -45,12 +42,21 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+struct rzv2h_of_data {
+	u8 cks_min;
+	u8 cks_max;
+	u16 cks_div;
+	u8 tops;
+	u16 timeout_cycles;
+};
+
 struct rzv2h_wdt_priv {
 	void __iomem *base;
 	struct clk *pclk;
 	struct clk *oscclk;
 	struct reset_control *rstc;
 	struct watchdog_device wdev;
+	const struct rzv2h_of_data *of_data;
 };
 
 static int rzv2h_wdt_ping(struct watchdog_device *wdev)
@@ -84,6 +90,7 @@ static void rzv2h_wdt_setup(struct watchdog_device *wdev, u16 wdtcr)
 static int rzv2h_wdt_start(struct watchdog_device *wdev)
 {
 	struct rzv2h_wdt_priv *priv = watchdog_get_drvdata(wdev);
+	const struct rzv2h_of_data *of_data = priv->of_data;
 	int ret;
 
 	ret = pm_runtime_resume_and_get(wdev->parent);
@@ -106,8 +113,8 @@ static int rzv2h_wdt_start(struct watchdog_device *wdev)
 	 * - RPES[9:8] - Window End Position Select - 11b: 0%
 	 * - TOPS[1:0] - Timeout Period Select - 11b: 16384 cycles (3FFFh)
 	 */
-	rzv2h_wdt_setup(wdev, WDTCR_CKS_CLK_256 | WDTCR_RPSS_100 |
-			WDTCR_RPES_0 | WDTCR_TOPS_16384);
+	rzv2h_wdt_setup(wdev, of_data->cks_max | WDTCR_RPSS_100 |
+			WDTCR_RPES_0 | of_data->tops);
 
 	/*
 	 * Down counting starts after writing the sequence 00h -> FFh to the
@@ -184,7 +191,7 @@ static int rzv2h_wdt_restart(struct watchdog_device *wdev,
 	 * - RPES[9:8] - Window End Position Select - 00b: 75%
 	 * - TOPS[1:0] - Timeout Period Select - 00b: 1024 cycles (03FFh)
 	 */
-	rzv2h_wdt_setup(wdev, WDTCR_CKS_CLK_1 | WDTCR_RPSS_25 |
+	rzv2h_wdt_setup(wdev, priv->of_data->cks_min | WDTCR_RPSS_25 |
 			WDTCR_RPES_75 | WDTCR_TOPS_1024);
 
 	rzv2h_wdt_ping(wdev);
@@ -213,6 +220,8 @@ static int rzv2h_wdt_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->of_data = of_device_get_match_data(dev);
+
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
@@ -230,8 +239,8 @@ static int rzv2h_wdt_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(priv->rstc),
 				     "failed to get cpg reset");
 
-	priv->wdev.max_hw_heartbeat_ms = (MILLI * MAX_TIMEOUT_CYCLES * CLOCK_DIV_BY_256) /
-					 clk_get_rate(priv->oscclk);
+	priv->wdev.max_hw_heartbeat_ms = (MILLI * priv->of_data->timeout_cycles *
+					  priv->of_data->cks_div) / clk_get_rate(priv->oscclk);
 	dev_dbg(dev, "max hw timeout of %dms\n", priv->wdev.max_hw_heartbeat_ms);
 
 	ret = devm_pm_runtime_enable(&pdev->dev);
@@ -254,8 +263,16 @@ static int rzv2h_wdt_probe(struct platform_device *pdev)
 	return devm_watchdog_register_device(&pdev->dev, &priv->wdev);
 }
 
+static const struct rzv2h_of_data rzv2h_wdt_of_data = {
+	.cks_min = WDTCR_CKS_CLK_1,
+	.cks_max = WDTCR_CKS_CLK_256,
+	.cks_div = 256,
+	.tops = WDTCR_TOPS_16384,
+	.timeout_cycles = 16384,
+};
+
 static const struct of_device_id rzv2h_wdt_ids[] = {
-	{ .compatible = "renesas,r9a09g057-wdt", },
+	{ .compatible = "renesas,r9a09g057-wdt", .data = &rzv2h_wdt_of_data },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, rzv2h_wdt_ids);
-- 
2.53.0



