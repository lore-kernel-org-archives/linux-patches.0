Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A1F35208F;
	Tue, 26 Aug 2025 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216855; cv=none; b=ZbbPZLlZ2IYzxPanIybAH7SVSdbUyorwTw3GQpsSimh7c2wWSO4tbjjHiHz56FR5FTnjMBqj8/+BBARPrxPXCilppP/TGY4uKPVSaD3UK4G6I8iWrgMSat3ks1Ab2Rp2NkssOCVGBWL90LgPxiClvTEA/DTdYOD5vuUS0Helj4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216855; c=relaxed/simple;
	bh=9zm2frS8Q69jGceeQEdkBGtSVezazd9wrUJs1reQjGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aAszPmMgxKxAu9GC9LmOMow6qfLVIOoiFJzuB/W5AKzFwzsYSVplUeeSFOYMWMcNR0zXvP7EG8Qhp/NYVsG7VXIkNWODEe9w19gfAuYf8SQvPu/3K9xuoe3aGl3bTMNsVgCXedfHeBmDNuJk2HGNIBoBonrHyZlxQrWalbnqHtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjghfkTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjghfkTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0CDC4CEF1;
	Tue, 26 Aug 2025 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216855;
	bh=9zm2frS8Q69jGceeQEdkBGtSVezazd9wrUJs1reQjGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjghfkTBj82rzdev60HdGYi8X/7iIsUOwwV8Fsbv6NAXllgVydvDpkAcPNkmIsm9/
	 CXRokGotakuwz6rzDKMTm9hjq3i3pD/E3Sy69LYot5LDY+a2Yf0g5wMacpETw+gNSX
	 JR8o/Te5ahFD51kiAiMJ+Ynk/5E9Xy6g2rOen86E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee.jones@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 537/644] platform/chrome: cros_ec: Make cros_ec_unregister() return void
Date: Tue, 26 Aug 2025 13:10:28 +0200
Message-ID: <20250826110959.823261242@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit afb0a80e63d67e957b5d0eb4ade301aff6e13c8c ]

Up to now cros_ec_unregister() returns zero unconditionally. Make it
return void instead which makes it easier to see in the callers that
there is no error to handle.

Also the return value of i2c, platform and spi remove callbacks is
ignored anyway.

Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20211020071753.wltjslmimb6wtlp5@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220123175201.34839-5-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e23749534619 ("platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec.c     |    4 +---
 drivers/platform/chrome/cros_ec.h     |    2 +-
 drivers/platform/chrome/cros_ec_i2c.c |    4 +++-
 drivers/platform/chrome/cros_ec_lpc.c |    4 +++-
 drivers/platform/chrome/cros_ec_spi.c |    4 +++-
 5 files changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -306,13 +306,11 @@ EXPORT_SYMBOL(cros_ec_register);
  *
  * Return: 0 on success or negative error code.
  */
-int cros_ec_unregister(struct cros_ec_device *ec_dev)
+void cros_ec_unregister(struct cros_ec_device *ec_dev)
 {
 	if (ec_dev->pd)
 		platform_device_unregister(ec_dev->pd);
 	platform_device_unregister(ec_dev->ec);
-
-	return 0;
 }
 EXPORT_SYMBOL(cros_ec_unregister);
 
--- a/drivers/platform/chrome/cros_ec.h
+++ b/drivers/platform/chrome/cros_ec.h
@@ -11,7 +11,7 @@
 #include <linux/interrupt.h>
 
 int cros_ec_register(struct cros_ec_device *ec_dev);
-int cros_ec_unregister(struct cros_ec_device *ec_dev);
+void cros_ec_unregister(struct cros_ec_device *ec_dev);
 
 int cros_ec_suspend(struct cros_ec_device *ec_dev);
 int cros_ec_resume(struct cros_ec_device *ec_dev);
--- a/drivers/platform/chrome/cros_ec_i2c.c
+++ b/drivers/platform/chrome/cros_ec_i2c.c
@@ -313,7 +313,9 @@ static int cros_ec_i2c_remove(struct i2c
 {
 	struct cros_ec_device *ec_dev = i2c_get_clientdata(client);
 
-	return cros_ec_unregister(ec_dev);
+	cros_ec_unregister(ec_dev);
+
+	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
--- a/drivers/platform/chrome/cros_ec_lpc.c
+++ b/drivers/platform/chrome/cros_ec_lpc.c
@@ -439,7 +439,9 @@ static int cros_ec_lpc_remove(struct pla
 		acpi_remove_notify_handler(adev->handle, ACPI_ALL_NOTIFY,
 					   cros_ec_lpc_acpi_notify);
 
-	return cros_ec_unregister(ec_dev);
+	cros_ec_unregister(ec_dev);
+
+	return 0;
 }
 
 static const struct acpi_device_id cros_ec_lpc_acpi_device_ids[] = {
--- a/drivers/platform/chrome/cros_ec_spi.c
+++ b/drivers/platform/chrome/cros_ec_spi.c
@@ -790,7 +790,9 @@ static int cros_ec_spi_remove(struct spi
 {
 	struct cros_ec_device *ec_dev = spi_get_drvdata(spi);
 
-	return cros_ec_unregister(ec_dev);
+	cros_ec_unregister(ec_dev);
+
+	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP


