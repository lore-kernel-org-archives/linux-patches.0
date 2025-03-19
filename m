Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3CA1C4A24;
	Wed, 19 Mar 2025 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394967; cv=none; b=UOe8wDiKJTPVoMyJi0eTAtusDszYa7b42onTAunh/7dEakQmDbqeNglaLs+VjhnCLd7+KyjYZD75dv5eeB4odUA6hulIBDU/voja9ZaNpUYI5p4/nv/wA+e4w3Vj3Y2C/HGjXpcchESYkudPnZO83CC56Rxqzts5dW7gjjlraBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394967; c=relaxed/simple;
	bh=IaUEh1AgkKSjAEu6IA2XAR3zNRBR3bkZQMFY+j7vrSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmlQymJLPMOAUSLT5XX3DOk8xWNHdBYj/RBHgL5YMPsCF5PC4QxhmBHeeihbOkDOvUD+woCjWdOOv2s3PfI+nt4oL57zr1/cxLGLx4I637DHs4eYnEIs0yktc6zhuo0p4/HanQaX1nuSBoLT/UTxsLSWZqhywKAQJ5f0g0hErHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDBd5hjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDBd5hjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B31C4CEE4;
	Wed, 19 Mar 2025 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394967;
	bh=IaUEh1AgkKSjAEu6IA2XAR3zNRBR3bkZQMFY+j7vrSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDBd5hjwNiCbSo8yiREZYUiW6Nl/FgfvSsPaQchT9nc5gMhXk3tvxRywRugC8UVMN
	 HWIA74SX7rT6ECkwZQHyZNBYkpSmNgpCdS+88ibJI8OF9KGJxUnnBVFUtvMmxnnCNa
	 4MRVoy1ahG8lUCkgaKFV64cJuXzZaIk3NXvKVn+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 150/241] Input: goodix-berlin - fix vddio regulator references
Date: Wed, 19 Mar 2025 07:30:20 -0700
Message-ID: <20250319143031.427573783@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


