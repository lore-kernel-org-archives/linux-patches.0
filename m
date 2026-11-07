Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062752;
	b=cFDD3ZGJtYCNig2p25vJ29X2SFHdHWWB8KtC4LFyNppJlwzg7EhQYy+IQ/iSB4MzAjwF
	 L6+kZunl6lyIT8ACmg2qOI5ZY8phQRKalcIUVjLgpLkO4qeAvdUKlKZclZCVuciFIfkxS
	 DXsQl5acTJ4P1ongq+g0Q6f8wkmyegrTHkuZ02KJvIiVyvx2PNHlBq1ZyplNbkmBPd5LE
	 to93a6xn4by6jgbZcqmUv+cR6kU335hGNxmnsyNFDo+x0fNzD+SkmM7eEbJ49xAxHoSA0
	 7kQVKQ6E3Augdsmm2TZRb8SPXF6FSCRyERF+TlwaaS8KLuZ+CNUr1ocl1D7ZUwOyEgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ftxjltVVJlBqt0+y8TtOP/3TdHT6WaxXnsGrWr7vgrs=;
	b=R7cwAObMpPNuGoB+/jbRZ7QzbjyvhvyHnwsfDQKjHmo5PKRALD/m4jFZd7+tOBcIuKip
	 zheAe8tjgrLwwCnR7Sfa4MFr3Bt587jS5XaE0kxhJBFowSYs1ahWHvyTjm4+oUUg8E14N
	 85QU+oGz0TvP8dm/KlB1kAoiLcoLEVVD8yTUzpgbhZGBNiTw3z58pIfAj9uvVNxuCr29U
	 zHYrhBDT3ffol0exxa/HO2qIZWZQel8k348OHb8mEoVoI51Yxbif40D6GECuhbeLfB9pi
	 amdD44HcEZNvIIq0pvkCSghZceYhAySXoyEx1pk8foJfIbMKQfQPuVNFxParKwUWVig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KJWW8l/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23051606A32D;
	Sat,  7 Nov 2026 14:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KJWW8l/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B481F0089F;
	Sat,  7 Nov 2026 14:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062752;
	bh=ftxjltVVJlBqt0+y8TtOP/3TdHT6WaxXnsGrWr7vgrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJWW8l/mu8bf3jROkGuhZ5lHrV5VVE3NPsbb3njO3CV1pxwDWnO5eV9T06homdMC5
	 Ve7c6qes6EXYesbwSahlj1jT9uz09C9l3zsgwYU8JOFKawZKyiL+6ESIUo+zg3n9/o
	 iz3rDRSFdQJSY0uKg7/Vz22DFDp8sJxwLP8BFPjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serin Yeh <serin.yeh@intel.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/869] media: i2c: ov8856 : remove ACPI node bypass mechanism
Date: Sat,  7 Nov 2026 08:45:47 -0500
Message-ID: <20261107134854.533543011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Serin Yeh <serin.yeh@intel.com>

[ Upstream commit 609a71568664acb7ee57b42de002ca782e3769e8 ]

On Intel platforms the sensor is enumerated via ACPI, and an INT3472
"discrete" companion device (the power-logic-control driver under
drivers/platform/x86/intel/int3472) registers the sensor's
reset/powerdown GPIOs and the regulator supply. These resources are
therefore discoverable and usable through the standard gpiod/regulator
lookups at probe time.

However, the driver guarded both the GPIO/regulator acquisition in
ov8856_get_hwcfg() and the whole power-on/off sequence with
is_acpi_node() and skipped them on ACPI. As a result the sensor was
never powered or reset by the driver, and probe failed when reading the
chip ID in ov8856_identify_module().

Remove the is_acpi_node() checks so the GPIO/regulator resources are
acquired and the full power sequence runs regardless of the firmware
interface. The driver now behaves consistently across DT and ACPI
platforms and initialises the hardware correctly.

Tested on Intel platforms with kernel 6.17 and 7.0.

Fixes: d2fa1134a48b ("media: i2c: ov8856: Use V4L2 legacy sensor clock helper")
Cc: stable@vger.kernel.org
Signed-off-by: Serin Yeh <serin.yeh@intel.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8856.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/ov8856.c b/drivers/media/i2c/ov8856.c
index dd01e1d515ff6..2e104734ef0b1 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -2071,9 +2071,6 @@ static int ov8856_power_on(struct device *dev)
 	struct ov8856 *ov8856 = to_ov8856(sd);
 	int ret;
 
-	if (is_acpi_node(dev_fwnode(dev)))
-		return 0;
-
 	ret = clk_prepare_enable(ov8856->xvclk);
 	if (ret < 0) {
 		dev_err(dev, "failed to enable xvclk\n");
@@ -2109,9 +2106,6 @@ static int ov8856_power_off(struct device *dev)
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct ov8856 *ov8856 = to_ov8856(sd);
 
-	if (is_acpi_node(dev_fwnode(dev)))
-		return 0;
-
 	gpiod_set_value_cansleep(ov8856->reset_gpio, 1);
 	regulator_bulk_disable(ARRAY_SIZE(ov8856_supply_names),
 			       ov8856->supplies);
@@ -2282,21 +2276,18 @@ static int ov8856_get_hwcfg(struct ov8856 *ov8856)
 		dev_warn(dev, "external clock rate %u is unsupported",
 			 xvclk_rate);
 
-	if (!is_acpi_node(fwnode)) {
-		ov8856->reset_gpio = devm_gpiod_get_optional(dev, "reset",
-							     GPIOD_OUT_LOW);
-		if (IS_ERR(ov8856->reset_gpio))
-			return PTR_ERR(ov8856->reset_gpio);
+	ov8856->reset_gpio = devm_gpiod_get_optional(dev, "reset",
+						     GPIOD_OUT_LOW);
+	if (IS_ERR(ov8856->reset_gpio))
+		return PTR_ERR(ov8856->reset_gpio);
 
-		for (i = 0; i < ARRAY_SIZE(ov8856_supply_names); i++)
-			ov8856->supplies[i].supply = ov8856_supply_names[i];
+	for (i = 0; i < ARRAY_SIZE(ov8856_supply_names); i++)
+		ov8856->supplies[i].supply = ov8856_supply_names[i];
 
-		ret = devm_regulator_bulk_get(dev,
-					      ARRAY_SIZE(ov8856_supply_names),
-					      ov8856->supplies);
-		if (ret)
-			return ret;
-	}
+	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(ov8856_supply_names),
+				      ov8856->supplies);
+	if (ret)
+		return ret;
 
 	ep = fwnode_graph_get_next_endpoint(fwnode, NULL);
 	if (!ep)
-- 
2.53.0



