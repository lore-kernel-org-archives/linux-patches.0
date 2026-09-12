Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF604478E25;
	Sat, 12 Sep 2026 16:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229409; cv=none; b=baww62fU10FTbLCRJC+LntnTE8ZculWTMJIGUfsgQYgV69n3KnKCAL5vAGFuCH9UVFt+KVJVsICB3QKFnwfPnEjoqO1jOuKOVEPz/zi496y9/M9tpogKA5X6tpXYIcidjJRem+eoXfl9sIQ9cIHqzksOEDBUnGTjlBKIbkhD61c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229409; c=relaxed/simple;
	bh=z6krJUSuUuigvglbMHlJobB4Dviuf5lBMmOr3btKl5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HQhPVVSF/RQkAEStnz9kUlLJVZZKl/D8Etz6tW3Q4z5vyXNbHA/fzuclnDGqhKacXhs5stUhAWbxJ86pZRr+jTfmCwqEkrU+XBWYF/Lgrpd2Wck5m2LZEu5wbLUhgjsd6liA86Jkcin0HYQSEpanHCiOzlrHbH7M3ORY3hb0SBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rI1NK1fb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rI1NK1fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461381F00893;
	Sat, 12 Sep 2026 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229404;
	bh=v4lx8dh08WrHF6eh2aykNdefujw5V1nPMPusNk3v3Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rI1NK1fb1rEALfVUyzAXm4B5qWKZSGinaQdCGyz1eBpwXvqztEYfNr1zpuyJ7V8Py
	 gQZ197DEHy6a/8JhLhNqqWpijliR+BsjrN+mK5W41L1FU0bICaVHNIaf+JvxHbZIwO
	 beVjXjwJFgx4urCsALqq/tEVaPV2jul49W6cyf0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0556/1191] thermal/drivers/rcar_gen3_thermal: Create device local ops struct
Date: Sat, 12 Sep 2026 08:54:44 +0200
Message-ID: <20260912065600.731497663@linuxfoundation.org>
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

[ Upstream commit aef43e04937ea819c6c1b35030b48f06f73488e0 ]

The callback operations are modified on a driver global level. If one
device tree description do not define interrupts, the set_trips()
operation was disabled globally for all users of the driver.

Fix this by creating a device local copy of the operations structure and
modify the copy depending on what the device can do.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20230208190333.3159879-3-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: dd04ad1cdabc ("thermal/drivers/rcar: Fix error checking in probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 5a715a58f18b2..2dfce4f096314 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -87,6 +87,7 @@ struct rcar_gen3_thermal_tsc {
 
 struct rcar_gen3_thermal_priv {
 	struct rcar_gen3_thermal_tsc *tscs[TSC_MAX_NUM];
+	struct thermal_zone_device_ops ops;
 	unsigned int num_tscs;
 	void (*thermal_init)(struct rcar_gen3_thermal_tsc *tsc);
 	int ptat[3];
@@ -225,7 +226,7 @@ static int rcar_gen3_thermal_set_trips(struct thermal_zone_device *tz, int low,
 	return 0;
 }
 
-static struct thermal_zone_device_ops rcar_gen3_tz_of_ops = {
+static const struct thermal_zone_device_ops rcar_gen3_tz_of_ops = {
 	.get_temp	= rcar_gen3_thermal_get_temp,
 	.set_trips	= rcar_gen3_thermal_set_trips,
 };
@@ -466,6 +467,7 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->ops = rcar_gen3_tz_of_ops;
 	priv->thermal_init = rcar_gen3_thermal_init;
 	if (soc_device_match(r8a7795es1))
 		priv->thermal_init = rcar_gen3_thermal_init_r8a7795es1;
@@ -473,7 +475,7 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, priv);
 
 	if (rcar_gen3_thermal_request_irqs(priv, pdev))
-		rcar_gen3_tz_of_ops.set_trips = NULL;
+		priv->ops.set_trips = NULL;
 
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
@@ -508,8 +510,7 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 	for (i = 0; i < priv->num_tscs; i++) {
 		struct rcar_gen3_thermal_tsc *tsc = priv->tscs[i];
 
-		zone = devm_thermal_of_zone_register(dev, i, tsc,
-						     &rcar_gen3_tz_of_ops);
+		zone = devm_thermal_of_zone_register(dev, i, tsc, &priv->ops);
 		if (IS_ERR(zone)) {
 			dev_err(dev, "Sensor %u: Can't register thermal zone\n", i);
 			ret = PTR_ERR(zone);
-- 
2.53.0



