Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE27513777E;
	Tue, 16 Jun 2026 18:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635274; cv=none; b=EpFRZO20mWh1Au2eoAppIbR+IZ/WwrfyDFEDnxSxzQ00OEkMCWeS9wWwEVEhd9CguGBcmq6xeUpaU8cKbOlMKTcg5Lq1zc96p4uPrpb8/l4bEpF8EiiSCmzG8S/1xl6Az9T+cIMaUErlf+em1RlaCFyX/gJFSbQqN/KQodsjrDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635274; c=relaxed/simple;
	bh=qSzA2T1ib4zB8OqRaIwhNzAt6tHz75/R3zyu3C5pRMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4q855ibAkbg8YFDvYd+qXDiK6xSK9SJxlmighiZib6wGfmDoKX63CqkNW3pZajyQlKOz+7FPZmn/g8z1OKNx1zLdfjthw+6MxcOIfCeG9yCEHoXTfuye8M6tui3TTvzJtIicAs+LwzmZG4F94gzEZnRLFchs+tuY0/eExyL8Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAO6rz3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAO6rz3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A751F000E9;
	Tue, 16 Jun 2026 18:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635272;
	bh=rzZE6rWX486jHTi0qRCmafIcjN95kuto3VUGKmtU2ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAO6rz3jN9nMBD+fb8noKVor8XHF9gHuqqZwRXOgzZj8zyKkMf0a19BamH2fl47A6
	 v7ZttEFfpCuUEy82ES2q8XNwF61gr1Ge1xcuvY3Gny72nxwCT3DB/K36D2Qi6atKwD
	 oMY21U83nXKRJGe2B3ylrAAog2NLuD0/D3yrwc1I=
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
Subject: [PATCH 5.10 010/342] nfc: nxp-nci: i2c: use rising-edge IRQ on ACPI systems
Date: Tue, 16 Jun 2026 20:25:06 +0530
Message-ID: <20260616145048.794709512@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 237b344a30bbd8..989b4a0e5b1982 100644
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



