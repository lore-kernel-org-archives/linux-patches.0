Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979E4A33F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300996; cv=none; b=qgX2AKMHgItSIyCayysSjLds2OSUWomvoI+ctZgONfnme4dq7M9zeqV+rJrRLACTi6nocULGk788v42CepscmmH/bQvjbCbBEt8HREp7DxtjE7bNERPKxTwutX5jjofgkHBcwvySWkIm7gdCJ+NkFLSbs75+sKyZlhphr7/+KSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300996; c=relaxed/simple;
	bh=9FS0Rl3rOFg+dN6V++aP4jwOMvB+C59lHo7wwSNbwXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goq5F9fNfJYR3kkanMAOWh57o4s9GIMt6+1todqp0y3KKWAyI0HLPrJdOKlV2Yw55xYdblDynN7IbXaz4lVstJosRX6rNBl2hgACdg7aiHKr+uC4tFdMIgySVMW7IeRpHB9l0fB6ZD97jaIKg+xswqYrmRzSmL6XuKx4m6hwk4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vEDXxPgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEDXxPgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611F3C19424;
	Sat, 28 Feb 2026 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300995;
	bh=9FS0Rl3rOFg+dN6V++aP4jwOMvB+C59lHo7wwSNbwXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEDXxPgWqi34yi8SArEkTnacDR8cFDWuUcISbXTFuGGNmE532Z1C36enVk82O70vD
	 evLMbNRypXIZioIQ6tKdnDGXoQZl9bGOvpSdldsy2UCRccLKJw9GS0gGYmhfdZv1nO
	 a9dyNZmvP8fYgpU8NRBRG4gYEYLOD+mylJ0WXab3Rhuc1LnK1FSYOHbcEpe06YREG2
	 QrGk64i8H/vqR4pwbXuz5Wn4GVVPCqOxpDICSq/9mBSn/dDuD6x9zswKut2bn2wd1Y
	 A0WXvde6BqNK3h0wuAGCEpSw6HLfq9JmMX5A2c7lyOPu3ycl5/p5EkPLtLbKeBBtKn
	 eNlw2SL0fEJwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jan Remmet <j.remmet@phytec.de>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/752] gpio: pca953x: Add support for TCAL6408 TCAL6416
Date: Sat, 28 Feb 2026 12:37:18 -0500
Message-ID: <20260228174750.1542406-127-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jan Remmet <j.remmet@phytec.de>

[ Upstream commit a30a9cb9bca4296d25f253619883e7013b6be158 ]

TCAL6408 and TCAL6416 supports latchable inputs and maskable interrupt.
Tested on a TCAL6416, checked datasheets for the TCAL6408.

They use the same programming model ad the NXP PCAL64xx, but
support a lower supply power (1.08V to 3.6V) compared to PCAL
(1.65V to 5.5V)

Datasheet: https://www.ti.com/lit/ds/symlink/tcal6408.pdf
Datasheet: https://www.ti.com/lit/ds/symlink/tcal6416.pdf

Signed-off-by: Jan Remmet <j.remmet@phytec.de>
Link: https://lore.kernel.org/r/20251216-wip-jremmet-tcal6416rtw-v2-3-6516d98a9836@phytec.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig        | 4 ++--
 drivers/gpio/gpio-pca953x.c | 6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e053524c5e35f..4d644dcecad93 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1194,11 +1194,11 @@ config GPIO_PCA953X
 
 	  8 bits:       max7310, max7315, pca6107, pca9534, pca9538, pca9554,
 	                pca9556, pca9557, pca9574, tca6408, tca9554, xra1202,
-			pcal6408, pcal9554b, tca9538
+			pcal6408, pcal9554b, tca9538, tcal6408
 
 	  16 bits:      max7312, max7313, pca9535, pca9539, pca9555, pca9575,
 	                tca6416, pca6416, pcal6416, pcal9535, pcal9555a, max7318,
-			tca9539
+			tca9539, tcal6416
 
 	  18 bits:	tca6418
 
diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 34cadce9b3101..f7daeadaea57c 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -126,6 +126,9 @@ static const struct i2c_device_id pca953x_id[] = {
 	{ "tca9539", 16 | PCA953X_TYPE | PCA_INT, },
 	{ "tca9554", 8  | PCA953X_TYPE | PCA_INT, },
 	{ "xra1202", 8  | PCA953X_TYPE },
+
+	{ "tcal6408", 8  | PCA953X_TYPE | PCA_LATCH_INT, },
+	{ "tcal6416", 16 | PCA953X_TYPE | PCA_LATCH_INT, },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pca953x_id);
@@ -1466,6 +1469,9 @@ static const struct of_device_id pca953x_dt_ids[] = {
 	{ .compatible = "ti,tca9538", .data = OF_953X( 8, PCA_INT), },
 	{ .compatible = "ti,tca9539", .data = OF_953X(16, PCA_INT), },
 
+	{ .compatible = "ti,tcal6408", .data = OF_953X( 8, PCA_LATCH_INT), },
+	{ .compatible = "ti,tcal6416", .data = OF_953X(16, PCA_LATCH_INT), },
+
 	{ .compatible = "onnn,cat9554", .data = OF_953X( 8, PCA_INT), },
 	{ .compatible = "onnn,pca9654", .data = OF_953X( 8, PCA_INT), },
 	{ .compatible = "onnn,pca9655", .data = OF_953X(16, PCA_INT), },
-- 
2.51.0

