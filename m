Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059520;
	b=lxhNYrzX5qOBG8p1iKr3bWarsLGYKclnjUhCVX5PsSkmf80C4BwrCW3heo/yjNsbNO3Z
	 SNPs2ucgUOhczShAIb0Yo881MlFfqaEPcdFqsOMIb5ZjFJ3xq2HSvfYSs1cZNEtQFec0c
	 KR3ks2qwwZkvBEM4e0W9EjN9BqKS72IcvwfVkLUok90vwsJ7qfeeHhcayS/b/bfKVOLfN
	 PC5pc9+FYXZiSkLRwa9ps4yCtFjtcdH69tIptVoJKy1TEcaoWxbMvoRMnQJFJIPW0p0+h
	 H5TjiBgil/iWl3WPrG7sZM1WkUaapfHEaJPX+iMDbMnrRhHCzm92Q5mhE0cxWItK67Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tc3uYj4UlDaLFSOdMsIlUvTTAwlh2K9TtlrMdRZtB9Q=;
	b=4xcDsfynwbE/YAPg0r8zdp7r1J+DFl3Z4uuEFLTDcaOm/XvlLxIpuD9ihlq09S7+Ni/q
	 7va1G6vopVDXDYsh4I/iRuuW+HqeC2Gfnatw2N1ZFlYMokJhGEXlkRnSACbq5ZmgPJxMQ
	 dkYqbcQTVn/HM2DkDhG9LPu5vuNATiK+43UdFNqMJjCt9mgi6udaz9ndmzn7Kwk9f/cD7
	 l8HYDZj+rBaQuFQjVNH7HaCzZI5SzLIYr5YuRDwaCOnqLFni4+tIoxpLVouV+yA0Z3xsx
	 AYGm6sCVeM/Tr9CVcFMKLkEjjOJA1txsEZ57WvcUF3kt2QFjD6nPvZGuiDEG1ln5OUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z4u/mq5y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3D7606A32C;
	Thu, 19 Nov 2026 03:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4u/mq5y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358B61F000C4;
	Thu, 19 Nov 2026 03:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059519;
	bh=tc3uYj4UlDaLFSOdMsIlUvTTAwlh2K9TtlrMdRZtB9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4u/mq5ywDVtgqfhWK/gCKUuj0N7HvU+LfMHWmRiLcwHHUSfgj+lRaSV/ZGL8R4ji
	 0NoX4fEiW4QJ6zz0ti15dc02VXwcSl7JgB1sA9OzHAWOqSjrEtVgJFx3ROXO+lsI9f
	 yvh0Z69BRWQ5156LuvXplQr6sijKlZT0Jkm8SaPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0844/1848] platform/x86: Rename hp-wireless to wireless-hotkey
Date: Wed, 18 Nov 2026 15:48:02 +0100
Message-ID: <20261118145951.945942129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit a558ea42c0decd088df1950bb232ac2257929281 ]

This driver was originally intended to support some HP laptops, but
later support was added for Xioami and AMD laptops.

Rename it to make it clear that it supports a larger variety of
systems.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20210519174405.30155-1-mario.limonciello@amd.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 6dea092b261f ("platform/x86: hp-wmi: fix heap OOB read and memory corruption in hp_wmi_perform_query()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig           |   9 ++-
 drivers/platform/x86/Makefile          |   2 +-
 drivers/platform/x86/hp-wireless.c     | 102 ------------------------
 drivers/platform/x86/wireless-hotkey.c | 103 +++++++++++++++++++++++++
 4 files changed, 109 insertions(+), 107 deletions(-)
 delete mode 100644 drivers/platform/x86/hp-wireless.c
 create mode 100644 drivers/platform/x86/wireless-hotkey.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index c14c145b88d80..b7bbe97b727eb 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -530,16 +530,17 @@ config HP_ACCEL
 	  To compile this driver as a module, choose M here: the module will
 	  be called hp_accel.
 
-config HP_WIRELESS
-	tristate "HP wireless button"
+config WIRELESS_HOTKEY
+	tristate "Wireless hotkey button"
 	depends on ACPI
 	depends on INPUT
 	help
-	 This driver provides supports for new HP wireless button for Windows 8.
+	 This driver provides supports for the wireless buttons found on some AMD,
+	 HP, & Xioami laptops.
 	 On such systems the driver should load automatically (via ACPI alias).
 
 	 To compile this driver as a module, choose M here: the module will
-	 be called hp-wireless.
+	 be called wireless-hotkey.
 
 config HP_WMI
 	tristate "HP WMI extras"
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 5f823f7eff452..5779c9a061384 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -58,7 +58,6 @@ obj-$(CONFIG_GPD_POCKET_FAN)	+= gpd-pocket-fan.o
 
 # Hewlett Packard
 obj-$(CONFIG_HP_ACCEL)		+= hp_accel.o
-obj-$(CONFIG_HP_WIRELESS)	+= hp-wireless.o
 obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
 obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
 
@@ -124,6 +123,7 @@ obj-$(CONFIG_TOPSTAR_LAPTOP)	+= topstar-laptop.o
 obj-$(CONFIG_I2C_MULTI_INSTANTIATE)	+= i2c-multi-instantiate.o
 obj-$(CONFIG_MLX_PLATFORM)		+= mlx-platform.o
 obj-$(CONFIG_TOUCHSCREEN_DMI)		+= touchscreen_dmi.o
+obj-$(CONFIG_WIRELESS_HOTKEY)		+= wireless-hotkey.o
 
 # Intel uncore drivers
 obj-$(CONFIG_INTEL_IPS)				+= intel_ips.o
diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
deleted file mode 100644
index 0753ef18e7211..0000000000000
--- a/drivers/platform/x86/hp-wireless.c
+++ /dev/null
@@ -1,102 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *  Airplane mode button for HP & Xiaomi laptops
- *
- *  Copyright (C) 2014-2017 Alex Hung <alex.hung@canonical.com>
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/input.h>
-#include <linux/platform_device.h>
-#include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Alex Hung");
-MODULE_ALIAS("acpi*:HPQ6001:*");
-MODULE_ALIAS("acpi*:WSTADEF:*");
-MODULE_ALIAS("acpi*:AMDI0051:*");
-
-static struct input_dev *hpwl_input_dev;
-
-static const struct acpi_device_id hpwl_ids[] = {
-	{"HPQ6001", 0},
-	{"WSTADEF", 0},
-	{"AMDI0051", 0},
-	{"", 0},
-};
-
-static int hp_wireless_input_setup(void)
-{
-	int err;
-
-	hpwl_input_dev = input_allocate_device();
-	if (!hpwl_input_dev)
-		return -ENOMEM;
-
-	hpwl_input_dev->name = "HP Wireless hotkeys";
-	hpwl_input_dev->phys = "hpq6001/input0";
-	hpwl_input_dev->id.bustype = BUS_HOST;
-	hpwl_input_dev->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_RFKILL, hpwl_input_dev->keybit);
-
-	err = input_register_device(hpwl_input_dev);
-	if (err)
-		goto err_free_dev;
-
-	return 0;
-
-err_free_dev:
-	input_free_device(hpwl_input_dev);
-	return err;
-}
-
-static void hp_wireless_input_destroy(void)
-{
-	input_unregister_device(hpwl_input_dev);
-}
-
-static void hpwl_notify(struct acpi_device *acpi_dev, u32 event)
-{
-	if (event != 0x80) {
-		pr_info("Received unknown event (0x%x)\n", event);
-		return;
-	}
-
-	input_report_key(hpwl_input_dev, KEY_RFKILL, 1);
-	input_sync(hpwl_input_dev);
-	input_report_key(hpwl_input_dev, KEY_RFKILL, 0);
-	input_sync(hpwl_input_dev);
-}
-
-static int hpwl_add(struct acpi_device *device)
-{
-	int err;
-
-	err = hp_wireless_input_setup();
-	if (err)
-		pr_err("Failed to setup hp wireless hotkeys\n");
-
-	return err;
-}
-
-static int hpwl_remove(struct acpi_device *device)
-{
-	hp_wireless_input_destroy();
-	return 0;
-}
-
-static struct acpi_driver hpwl_driver = {
-	.name	= "hp-wireless",
-	.owner	= THIS_MODULE,
-	.ids	= hpwl_ids,
-	.ops	= {
-		.add	= hpwl_add,
-		.remove	= hpwl_remove,
-		.notify	= hpwl_notify,
-	},
-};
-
-module_acpi_driver(hpwl_driver);
diff --git a/drivers/platform/x86/wireless-hotkey.c b/drivers/platform/x86/wireless-hotkey.c
new file mode 100644
index 0000000000000..b010e4ca33831
--- /dev/null
+++ b/drivers/platform/x86/wireless-hotkey.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *  Airplane mode button for AMD, HP & Xiaomi laptops
+ *
+ *  Copyright (C) 2014-2017 Alex Hung <alex.hung@canonical.com>
+ *  Copyright (C) 2021 Advanced Micro Devices
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_bus.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Alex Hung");
+MODULE_ALIAS("acpi*:HPQ6001:*");
+MODULE_ALIAS("acpi*:WSTADEF:*");
+MODULE_ALIAS("acpi*:AMDI0051:*");
+
+static struct input_dev *wl_input_dev;
+
+static const struct acpi_device_id wl_ids[] = {
+	{"HPQ6001", 0},
+	{"WSTADEF", 0},
+	{"AMDI0051", 0},
+	{"", 0},
+};
+
+static int wireless_input_setup(void)
+{
+	int err;
+
+	wl_input_dev = input_allocate_device();
+	if (!wl_input_dev)
+		return -ENOMEM;
+
+	wl_input_dev->name = "Wireless hotkeys";
+	wl_input_dev->phys = "hpq6001/input0";
+	wl_input_dev->id.bustype = BUS_HOST;
+	wl_input_dev->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_RFKILL, wl_input_dev->keybit);
+
+	err = input_register_device(wl_input_dev);
+	if (err)
+		goto err_free_dev;
+
+	return 0;
+
+err_free_dev:
+	input_free_device(wl_input_dev);
+	return err;
+}
+
+static void wireless_input_destroy(void)
+{
+	input_unregister_device(wl_input_dev);
+}
+
+static void wl_notify(struct acpi_device *acpi_dev, u32 event)
+{
+	if (event != 0x80) {
+		pr_info("Received unknown event (0x%x)\n", event);
+		return;
+	}
+
+	input_report_key(wl_input_dev, KEY_RFKILL, 1);
+	input_sync(wl_input_dev);
+	input_report_key(wl_input_dev, KEY_RFKILL, 0);
+	input_sync(wl_input_dev);
+}
+
+static int wl_add(struct acpi_device *device)
+{
+	int err;
+
+	err = wireless_input_setup();
+	if (err)
+		pr_err("Failed to setup hp wireless hotkeys\n");
+
+	return err;
+}
+
+static int wl_remove(struct acpi_device *device)
+{
+	wireless_input_destroy();
+	return 0;
+}
+
+static struct acpi_driver wl_driver = {
+	.name	= "wireless-hotkey",
+	.owner	= THIS_MODULE,
+	.ids	= wl_ids,
+	.ops	= {
+		.add	= wl_add,
+		.remove	= wl_remove,
+		.notify	= wl_notify,
+	},
+};
+
+module_acpi_driver(wl_driver);
-- 
2.53.0



