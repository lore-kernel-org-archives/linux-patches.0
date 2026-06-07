Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7489B234994;
	Sun,  7 Jun 2026 10:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826817; cv=none; b=G9AbLUDYgOp+vHNI9kP6WT5tMDs8nDtC0G0J/yyqK10r8i30urF0NmePhgbgME0uUhB/aQUSQHGYQ1Chem2HlrwqjqbM5rjRMAwMP195eRNs69UlIz8Gb/XOzgotUaphgJSYGkOEF5HLVXn7R9ly99Sx/1LDFiDBzgBZcR7ijC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826817; c=relaxed/simple;
	bh=hgInsQmPeVbm888/tVunVFxZ7U60VEDjzZ85bduynXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckiKFfFmkjPBFTEgk/N9YUYBAd+RWWIfJT4yd2Mi51X3jGwaGk5L13ZiXhZBOIpFyYl7QM5O6oJAmAfaLa07um2VQ76RI9AyoFxnypyPJbGL1z6t+hStLbWxH/10ZfuJCQTgHEksbRK0cSlsqUtVCuzQu9iNVOQGazc6ZbcoO2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WANpNQrr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WANpNQrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B002C1F00893;
	Sun,  7 Jun 2026 10:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826816;
	bh=J1fZQiyhH0VGF+Xruqz/+a0aL19wPl3K93nNL2NEozs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WANpNQrrfboq0SP+bsH6HiP9QuBur0ne79GW28aVa03q3mRCjvk2cxVBru+PBH7M1
	 2KNyM1ibZif6vGfIlH/WmgdnKask6n7UkU0QdSrbziaG2f3oWCMJsTzsOPu6hiEavo
	 +cZOsPHvsuPI+b17l/TOOl5K/18EoPmrZUpXO/z8=
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
Subject: [PATCH 6.18 010/315] nfc: nxp-nci: i2c: use rising-edge IRQ on ACPI systems
Date: Sun,  7 Jun 2026 11:56:37 +0200
Message-ID: <20260607095727.882627021@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b3d34433bd14a0..a6c08175d9dd93 100644
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
@@ -267,6 +268,7 @@ static int nxp_nci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct nxp_nci_i2c_phy *phy;
+	unsigned long irqflags;
 	int r;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
@@ -303,9 +305,26 @@ static int nxp_nci_i2c_probe(struct i2c_client *client)
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



