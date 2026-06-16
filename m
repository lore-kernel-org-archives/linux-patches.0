Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47292F12AE;
	Tue, 16 Jun 2026 18:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633100; cv=none; b=e1IktI47knwAIKAFEKBAN+t3WlEyF4LZLgL+D4Er7/5G8NFKu58XVoDwLdVDS8iD+HWwTnnJeUZKIRHinI9uQyvnB6XUZaZeHIK0Moxsv1hILeXTggoECwLU335GnMsrq2y/6BlQ2lEI0Uc+bX6Zo5RENzQVco1i5oRQbBJIz6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633100; c=relaxed/simple;
	bh=N01r7CKQV3lIacPWEk/+Ra270VINeIa6rJLtAsjQbTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/ka6iJ2FiuCkeC/5pR8tMxtewcfP3yd9jgMHx8hZUKA+W5nhk03/jNzTM1huoP+4hDOJ73a+G0rDbpdI/VRQRselqXlUjO0XTQ1Qx4bDr2cHzq8gAtGBk0edTaQj8woc2xRpYuw/1SMufFdVVTyCWQH/DtLWKcgOQaWsW7fKQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3Y+GpPS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3Y+GpPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD001F000E9;
	Tue, 16 Jun 2026 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633099;
	bh=Pd/X8r/hAZ5u+XV1uWBJCvd0MtulQIHgX7x7kXCf+Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3Y+GpPSOrnshkZg4SzZsk2tVg6M0en1C8scpa39t5I+eoUlkks2EzJNeM7bbVU/q
	 8hTvVswQUt6pKXRTUebN1N11zmHeeZNWHzVGM790eMshjZsUvd7eaVI4h/E62UwaC0
	 dG4lyn0/Ma74ANor8NFnq2PKwY54LI4tsDEOAlrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Lee <carl.lee@amd.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Luca Stefani <luca.stefani.ge1@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/411] nfc: nxp-nci: i2c: use rising-edge IRQ on ACPI systems
Date: Tue, 16 Jun 2026 20:24:09 +0530
Message-ID: <20260616145100.961007042@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carl Lee <carl.lee@amd.com>

[ Upstream commit f23bf992d65a42007c517b060ca35cebdea3525a ]

Some ACPI-based platforms report incorrect IRQ trigger types (e.g.
IRQF_TRIGGER_HIGH), which can lead to interrupt storms.

Use the historically working rising-edge trigger on ACPI systems to
avoid this regression.

Device Tree-based systems continue to use the firmware-provided
trigger type.

Fixes: 57be33f85e36 ("nfc: nxp-nci: remove interrupt trigger type")
Signed-off-by: Carl Lee <carl.lee@amd.com>
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Tested-by: Luca Stefani <luca.stefani.ge1@gmail.com>
Link: https://patch.msgid.link/20260516-nfc-nxp-nci-i2c-restore-irq-trigger-fallback-v3-1-37ba4b6e9086@amd.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/i2c.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 22c498860c03d5..a0e665f958c4d5 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/nfc.h>
 #include <linux/gpio/consumer.h>
@@ -268,6 +269,7 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 {
 	struct device *dev = &client->dev;
 	struct nxp_nci_i2c_phy *phy;
+	unsigned long irqflags;
 	int r;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
@@ -304,9 +306,26 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 	if (r < 0)
 		return r;
 
+	/*
+	 * ACPI platforms may report incorrect IRQ trigger types
+	 * (e.g. level-high), which can lead to interrupt storms.
+	 *
+	 * Use the historically stable rising-edge trigger for ACPI devices.
+	 *
+	 * On non-ACPI systems (e.g. Device Tree), prefer the firmware-
+	 * provided trigger type, falling back to rising-edge if not set.
+	 */
+	if (ACPI_COMPANION(dev)) {
+		irqflags = IRQF_TRIGGER_RISING;
+	} else {
+		irqflags = irq_get_trigger_type(client->irq);
+		if (!irqflags)
+			irqflags = IRQF_TRIGGER_RISING;
+	}
+
 	r = request_threaded_irq(client->irq, NULL,
 				 nxp_nci_i2c_irq_thread_fn,
-				 IRQF_ONESHOT,
+				 irqflags | IRQF_ONESHOT,
 				 NXP_NCI_I2C_DRIVER_NAME, phy);
 	if (r < 0)
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-- 
2.53.0



