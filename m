Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED592594BD;
	Sat, 12 Sep 2026 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229460; cv=none; b=YkWZZbH8rABsD3eHTRxvFNkeEjb4jhJXMxh6bGU6+LNiigcWXzxtd0WKWDSV2vdqE6KHXKaVEeqBH4gxFDlCz2SSyCQ/Hfi4fj/zLAw8vzUW9mwnnqO8s4Pi1wtoNDoTxPkMG51lLiaY4evqiKjDM2h9scA+XRlCXEiCzbbN5LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229460; c=relaxed/simple;
	bh=fyVxpP7aV8sT7WvNTXzvKWUVCGkdFmRaYJGqLqMv0qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOSVa5y64e/Kt3AER/IB0Hy4LI8TY1GGebrjew5JmtqOr5BlGGREalIMQXiPBCc0c8M1m/ebUwQDlnvn6Z0ZWJhN+1youv4SBI/sVdKO975+AjScl9EgxrecqvItF2IqrpEGbu4sZy2Tpcavco8DBeQYacFh8h13in4aOvTJsyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03tVXL5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03tVXL5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2EA1F000FF;
	Sat, 12 Sep 2026 16:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229459;
	bh=g6yJrG2xHfRZh80dORbU3JJtA1EMNqka3ZD4J4MoqiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03tVXL5nGthJQJ3pzTYuq2vRo0VZHq0otB8putFN09WkcW9S05XTn45n9le+XeqVo
	 BbeIa4XLCIgREiRdmIndaR3u0mbjtJtkJ+/9umt5a3CLhu12LBBTwatO7PCUKe0RpL
	 4T2brr/bU8WaA1udpPNqOnftNSSbo+w5b2mTV0aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0557/1191] thermal/drivers/rcar_gen3_thermal: Fix device initialization
Date: Sat, 12 Sep 2026 08:54:45 +0200
Message-ID: <20260912065600.753772547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 47b2d3d2ed6c5c20f3521d5b615ffc92ed18b974 ]

The thermal zone is registered before the device is register and the
thermal coefficients are calculated, providing a window for very
incorrect readings.

The reason why the zone was register before the device was fully
initialized was that the presence of the set_trips() callback is used to
determine if the driver supports interrupt or not, as it is not defined
if the device is incapable of interrupts.

Fix this by using the operations structure in the private data instead
of the zone to determine if interrupts are available or not, and
initialize the device before registering the zone.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20230208190333.3159879-4-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: dd04ad1cdabc ("thermal/drivers/rcar: Fix error checking in probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 2dfce4f096314..8835846884d11 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -89,7 +89,8 @@ struct rcar_gen3_thermal_priv {
 	struct rcar_gen3_thermal_tsc *tscs[TSC_MAX_NUM];
 	struct thermal_zone_device_ops ops;
 	unsigned int num_tscs;
-	void (*thermal_init)(struct rcar_gen3_thermal_tsc *tsc);
+	void (*thermal_init)(struct rcar_gen3_thermal_priv *priv,
+			     struct rcar_gen3_thermal_tsc *tsc);
 	int ptat[3];
 };
 
@@ -240,7 +241,7 @@ static irqreturn_t rcar_gen3_thermal_irq(int irq, void *data)
 	for (i = 0; i < priv->num_tscs; i++) {
 		status = rcar_gen3_thermal_read(priv->tscs[i], REG_GEN3_IRQSTR);
 		rcar_gen3_thermal_write(priv->tscs[i], REG_GEN3_IRQSTR, 0);
-		if (status)
+		if (status && priv->tscs[i]->zone)
 			thermal_zone_device_update(priv->tscs[i]->zone,
 						   THERMAL_EVENT_UNSPECIFIED);
 	}
@@ -311,7 +312,8 @@ static bool rcar_gen3_thermal_read_fuses(struct rcar_gen3_thermal_priv *priv)
 	return true;
 }
 
-static void rcar_gen3_thermal_init_r8a7795es1(struct rcar_gen3_thermal_tsc *tsc)
+static void rcar_gen3_thermal_init_r8a7795es1(struct rcar_gen3_thermal_priv *priv,
+					      struct rcar_gen3_thermal_tsc *tsc)
 {
 	rcar_gen3_thermal_write(tsc, REG_GEN3_CTSR,  CTSR_THBGR);
 	rcar_gen3_thermal_write(tsc, REG_GEN3_CTSR,  0x0);
@@ -322,7 +324,7 @@ static void rcar_gen3_thermal_init_r8a7795es1(struct rcar_gen3_thermal_tsc *tsc)
 
 	rcar_gen3_thermal_write(tsc, REG_GEN3_IRQCTL, 0x3F);
 	rcar_gen3_thermal_write(tsc, REG_GEN3_IRQMSK, 0);
-	if (tsc->zone->ops->set_trips)
+	if (priv->ops.set_trips)
 		rcar_gen3_thermal_write(tsc, REG_GEN3_IRQEN,
 					IRQ_TEMPD1 | IRQ_TEMP2);
 
@@ -338,7 +340,8 @@ static void rcar_gen3_thermal_init_r8a7795es1(struct rcar_gen3_thermal_tsc *tsc)
 	usleep_range(1000, 2000);
 }
 
-static void rcar_gen3_thermal_init(struct rcar_gen3_thermal_tsc *tsc)
+static void rcar_gen3_thermal_init(struct rcar_gen3_thermal_priv *priv,
+				   struct rcar_gen3_thermal_tsc *tsc)
 {
 	u32 reg_val;
 
@@ -350,7 +353,7 @@ static void rcar_gen3_thermal_init(struct rcar_gen3_thermal_tsc *tsc)
 
 	rcar_gen3_thermal_write(tsc, REG_GEN3_IRQCTL, 0);
 	rcar_gen3_thermal_write(tsc, REG_GEN3_IRQMSK, 0);
-	if (tsc->zone->ops->set_trips)
+	if (priv->ops.set_trips)
 		rcar_gen3_thermal_write(tsc, REG_GEN3_IRQEN,
 					IRQ_TEMPD1 | IRQ_TEMP2);
 
@@ -510,6 +513,9 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 	for (i = 0; i < priv->num_tscs; i++) {
 		struct rcar_gen3_thermal_tsc *tsc = priv->tscs[i];
 
+		priv->thermal_init(priv, tsc);
+		rcar_gen3_thermal_calc_coefs(priv, tsc, *ths_tj_1);
+
 		zone = devm_thermal_of_zone_register(dev, i, tsc, &priv->ops);
 		if (IS_ERR(zone)) {
 			dev_err(dev, "Sensor %u: Can't register thermal zone\n", i);
@@ -518,9 +524,6 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 		}
 		tsc->zone = zone;
 
-		priv->thermal_init(tsc);
-		rcar_gen3_thermal_calc_coefs(priv, tsc, *ths_tj_1);
-
 		tsc->zone->tzp->no_hwmon = false;
 		ret = thermal_add_hwmon_sysfs(tsc->zone);
 		if (ret)
@@ -558,7 +561,7 @@ static int __maybe_unused rcar_gen3_thermal_resume(struct device *dev)
 	for (i = 0; i < priv->num_tscs; i++) {
 		struct rcar_gen3_thermal_tsc *tsc = priv->tscs[i];
 
-		priv->thermal_init(tsc);
+		priv->thermal_init(priv, tsc);
 	}
 
 	return 0;
-- 
2.53.0



