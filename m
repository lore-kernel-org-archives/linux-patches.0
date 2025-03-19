Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C8C1DA112;
	Wed, 19 Mar 2025 14:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395097; cv=none; b=f3BTZSQG/6wd2sC1G5++jytMB+IGx6VaCognNOgl8d/hHdTE5CgUBH9ZFeCMSoPk1jTqO8STXRVxpqqqNXjaz5q0SNVxdQyfM11UYHS8bGoQzGl4bqPoX/yHw/PIzwsaVzsDW0Nxd5ToDZ9jvXWlNl/UrKO8mcgPgxM9nNEULIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395097; c=relaxed/simple;
	bh=95p1Stg2iL4jHGByy33F9WPNc5v1JUTT5Gt1t6QKMaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iN8YFzKOxLq/XU7MWIpfAIn/3CpVTLdAi6oygRztiyX9H3ruMskjo7fMcT4BIJugH8GStvKz2fGUY9/+QThbYnFMGEpKqJdZFKeupWf+yubj+8bnEZ/MZhGrO/2xdAht4R7Aj5YcT8Yp9FGfnDCatNlRGZ6adb1k8xP/2ODbTsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaU2QFCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaU2QFCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB855C4CEE4;
	Wed, 19 Mar 2025 14:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395096;
	bh=95p1Stg2iL4jHGByy33F9WPNc5v1JUTT5Gt1t6QKMaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaU2QFCWN14CTcq53AzLZ0/VkbL4AKR2od89Ykj7FO/+KkLyQ9N9AB0siwa/Ga9o/
	 ebDNbMpEnLh2tYOkPrqaIfTFufLkC7Sc6OqKI61ypLtme2DSNIfN9Bc4EaOmiPSH10
	 Ubmk63lxhIXcUqzzUSiVEe6sDQuNwxDfIYL0clbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 146/231] Input: goodix-berlin - fix vddio regulator references
Date: Wed, 19 Mar 2025 07:30:39 -0700
Message-ID: <20250319143030.446065254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

commit 3b0011059334a1cf554c2c1f67d7a7b822d8238a upstream.

As per dt-bindings the property is called vddio-supply, so use the
correct name in the driver instead of iovdd. The datasheet also calls
the supply 'VDDIO'.

Fixes: 44362279bdd4 ("Input: add core support for Goodix Berlin Touchscreen IC")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250103-goodix-berlin-fixes-v1-2-b014737b08b2@fairphone.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix_berlin_core.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/input/touchscreen/goodix_berlin_core.c
+++ b/drivers/input/touchscreen/goodix_berlin_core.c
@@ -165,7 +165,7 @@ struct goodix_berlin_core {
 	struct device *dev;
 	struct regmap *regmap;
 	struct regulator *avdd;
-	struct regulator *iovdd;
+	struct regulator *vddio;
 	struct gpio_desc *reset_gpio;
 	struct touchscreen_properties props;
 	struct goodix_berlin_fw_version fw_version;
@@ -248,19 +248,19 @@ static int goodix_berlin_power_on(struct
 {
 	int error;
 
-	error = regulator_enable(cd->iovdd);
+	error = regulator_enable(cd->vddio);
 	if (error) {
-		dev_err(cd->dev, "Failed to enable iovdd: %d\n", error);
+		dev_err(cd->dev, "Failed to enable vddio: %d\n", error);
 		return error;
 	}
 
-	/* Vendor waits 3ms for IOVDD to settle */
+	/* Vendor waits 3ms for VDDIO to settle */
 	usleep_range(3000, 3100);
 
 	error = regulator_enable(cd->avdd);
 	if (error) {
 		dev_err(cd->dev, "Failed to enable avdd: %d\n", error);
-		goto err_iovdd_disable;
+		goto err_vddio_disable;
 	}
 
 	/* Vendor waits 15ms for IOVDD to settle */
@@ -283,8 +283,8 @@ static int goodix_berlin_power_on(struct
 err_dev_reset:
 	gpiod_set_value_cansleep(cd->reset_gpio, 1);
 	regulator_disable(cd->avdd);
-err_iovdd_disable:
-	regulator_disable(cd->iovdd);
+err_vddio_disable:
+	regulator_disable(cd->vddio);
 	return error;
 }
 
@@ -292,7 +292,7 @@ static void goodix_berlin_power_off(stru
 {
 	gpiod_set_value_cansleep(cd->reset_gpio, 1);
 	regulator_disable(cd->avdd);
-	regulator_disable(cd->iovdd);
+	regulator_disable(cd->vddio);
 }
 
 static int goodix_berlin_read_version(struct goodix_berlin_core *cd)
@@ -744,10 +744,10 @@ int goodix_berlin_probe(struct device *d
 		return dev_err_probe(dev, PTR_ERR(cd->avdd),
 				     "Failed to request avdd regulator\n");
 
-	cd->iovdd = devm_regulator_get(dev, "iovdd");
-	if (IS_ERR(cd->iovdd))
-		return dev_err_probe(dev, PTR_ERR(cd->iovdd),
-				     "Failed to request iovdd regulator\n");
+	cd->vddio = devm_regulator_get(dev, "vddio");
+	if (IS_ERR(cd->vddio))
+		return dev_err_probe(dev, PTR_ERR(cd->vddio),
+				     "Failed to request vddio regulator\n");
 
 	error = goodix_berlin_power_on(cd);
 	if (error) {


