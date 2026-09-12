Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA7F33EAF3;
	Sat, 12 Sep 2026 16:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229489; cv=none; b=ZjfBToBS7XC8+xZjxN3dUla/mgtBtuBLg/+V1vDYXiq10LimK/QQ5G0vCfGjwgsZnqleohB6XPhIeEEq4u2J0kc6djyb2yfHsdBpx3EHkS5GLstb1hj0V+Eq1oUdr4R4L8sguAYqRhOlcvBwmZz8xtKvkvU0AMs/3oMYeJB4oOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229489; c=relaxed/simple;
	bh=WB12uWIicEuA9N2qhi4UztDWHmlG51jHDEiPg62V8/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rytfvuWQwUibcJB3xHYcvXrTZ+8Vv3HZ+Q1mZmo/4Yr3u+HyroCfqzDDBLU7/k51p86ShED19JVK1ipSRC+WUmTpQj5DfDSnDnhKRWM/4Qgnee1Qvz/JjtHnRw9oPEJeGkxnbico8z23zZ83sP62HW49uS/8gsy4JJXREGl0bwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2qs7hmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2qs7hmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7F31F000FF;
	Sat, 12 Sep 2026 16:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229487;
	bh=kTm5Y7uapmnNun/SWqj4lBzzxPkbQp1KM1JqK014OJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2qs7hmyTr5KfADc13NsFoanV+ARq6gVVBbzsaZwsBzxQby11q7fVNYxTiaqjHii4
	 733NPSs+AgiUXs2b03s86DdwW+OnOBjJWoPhSQYmVxez6uzlAT583Kqa8uzO2usevQ
	 int1QWuKRQqTA0dGf81Ra46J2waRy9wmcJwe8hAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.1 0558/1191] thermal/hwmon: Do not set no_hwmon before calling thermal_add_hwmon_sysfs()
Date: Sat, 12 Sep 2026 08:54:46 +0200
Message-ID: <20260912065600.775997076@linuxfoundation.org>
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

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 8f3f4ad4ad45e2e30c814de42629ef4c9688e92c ]

The thermal->tzp->no_hwmon parameter is only used when calling
thermal_zone_device_register().

Setting it to 'false' before calling thermal_add_hwmon_sysfs() has no
effect.

Remove the call and again prevent the drivers to access the thermal
internals.

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se> #R-Car
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com> #Broadcom
Acked-by: Heiko Stuebner <heiko@sntech.de> #rockchip
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: dd04ad1cdabc ("thermal/drivers/rcar: Fix error checking in probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/broadcom/bcm2711_thermal.c | 1 -
 drivers/thermal/broadcom/bcm2835_thermal.c | 1 -
 drivers/thermal/rcar_gen3_thermal.c        | 1 -
 drivers/thermal/rcar_thermal.c             | 5 -----
 drivers/thermal/rockchip_thermal.c         | 1 -
 drivers/thermal/rzg2l_thermal.c            | 1 -
 6 files changed, 10 deletions(-)

diff --git a/drivers/thermal/broadcom/bcm2711_thermal.c b/drivers/thermal/broadcom/bcm2711_thermal.c
index 1f8651d15160c..ac38348cc361b 100644
--- a/drivers/thermal/broadcom/bcm2711_thermal.c
+++ b/drivers/thermal/broadcom/bcm2711_thermal.c
@@ -98,7 +98,6 @@ static int bcm2711_thermal_probe(struct platform_device *pdev)
 
 	priv->thermal = thermal;
 
-	thermal->tzp->no_hwmon = false;
 	return thermal_add_hwmon_sysfs(thermal);
 }
 
diff --git a/drivers/thermal/broadcom/bcm2835_thermal.c b/drivers/thermal/broadcom/bcm2835_thermal.c
index 2c67841a11151..112b1ab534867 100644
--- a/drivers/thermal/broadcom/bcm2835_thermal.c
+++ b/drivers/thermal/broadcom/bcm2835_thermal.c
@@ -268,7 +268,6 @@ static int bcm2835_thermal_probe(struct platform_device *pdev)
 	 * Thermal_zone doesn't enable hwmon as default,
 	 * enable it here
 	 */
-	tz->tzp->no_hwmon = false;
 	err = thermal_add_hwmon_sysfs(tz);
 	if (err)
 		goto err_tz;
diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 8835846884d11..eac820a105587 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -524,7 +524,6 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 		}
 		tsc->zone = zone;
 
-		tsc->zone->tzp->no_hwmon = false;
 		ret = thermal_add_hwmon_sysfs(tsc->zone);
 		if (ret)
 			goto error_unregister;
diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 61c2b8855cb8d..740250adc3d28 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -551,11 +551,6 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 		}
 
 		if (chip->use_of_thermal) {
-			/*
-			 * thermal_zone doesn't enable hwmon as default,
-			 * but, enable it here to keep compatible
-			 */
-			priv->zone->tzp->no_hwmon = false;
 			ret = thermal_add_hwmon_sysfs(priv->zone);
 			if (ret)
 				goto error_unregister;
diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
index 9fc375cee5a66..05f4fc05fc582 100644
--- a/drivers/thermal/rockchip_thermal.c
+++ b/drivers/thermal/rockchip_thermal.c
@@ -1457,7 +1457,6 @@ static int rockchip_thermal_probe(struct platform_device *pdev)
 
 	for (i = 0; i < thermal->chip->chn_num; i++) {
 		rockchip_thermal_toggle_sensor(&thermal->sensors[i], true);
-		thermal->sensors[i].tzd->tzp->no_hwmon = false;
 		error = thermal_add_hwmon_sysfs(thermal->sensors[i].tzd);
 		if (error)
 			dev_warn(&pdev->dev,
diff --git a/drivers/thermal/rzg2l_thermal.c b/drivers/thermal/rzg2l_thermal.c
index 2e0649f385060..1eff2600d8e62 100644
--- a/drivers/thermal/rzg2l_thermal.c
+++ b/drivers/thermal/rzg2l_thermal.c
@@ -216,7 +216,6 @@ static int rzg2l_thermal_probe(struct platform_device *pdev)
 	}
 
 	priv->zone = zone;
-	priv->zone->tzp->no_hwmon = false;
 	ret = thermal_add_hwmon_sysfs(priv->zone);
 	if (ret)
 		goto err;
-- 
2.53.0



