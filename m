Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AC6241664;
	Tue, 29 Apr 2025 17:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946592; cv=none; b=ZvBjwt7tTmy9vrpVTt8YKgkB7wRRGlhYJ3jHY5+OyThLabpt5aD90gycNKeySWJsSwckIMhQItXADnM51DyHlewpPaZuz2pCTPxN9ta4WSucAH7AtVFyEJwoXXH0tJW2bUhvAbmafrnB72B8AZ7ZScu9hYC//sLmaFXAlG17aHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946592; c=relaxed/simple;
	bh=3C6H9/gJK7MrTt+KzyTXdYMewkSDnoMLrcD2e1NS4eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WweL8bcgjGMvQeU6sDbo2Mhn74CWVlnMySCYBAP45+SuKUeMRNiufvKHJSRRaGoluAbY8wKCTP9KgzUXD+b/6jYmDmFGRfmZ1nN3KJbg7D6EeBe7brY4uroDVc0Lf46HGTLDqNxREbKp3v1fhj8zHrPp8JIX9NJrQEpl0roWmbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAnNeXME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAnNeXME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94563C4CEE3;
	Tue, 29 Apr 2025 17:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946592;
	bh=3C6H9/gJK7MrTt+KzyTXdYMewkSDnoMLrcD2e1NS4eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAnNeXMEMFG5WfVJRQesHJ6nXbSzPzr2hjuZ7UA9IgXUL0B6XpV7Q+Uo3TAFdNfyQ
	 zW5jtYBIrE0U9u7gL3iLmBM1aB83bd8F5pN9ptvvTI2WRULnF9jDJu+uA17d19grpk
	 UowaxW3HKhwGWuqORr5eq4Y85rzO352sXnSL0O30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 278/311] platform/x86: x86-android-tablets: Add "9v" to Vexia EDU ATLA 10 tablet symbols
Date: Tue, 29 Apr 2025 18:41:55 +0200
Message-ID: <20250429161132.404070009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3343b086c7035222c24956780ea4423655cad6d2 ]

The Vexia EDU ATLA 10 tablet comes in 2 different versions with
significantly different mainboards. The only outward difference is that
the charging barrel on one is marked 5V and the other is marked 9V.

Both need to be handled by the x86-android-tablets code. Add 9v to
the symbols for the existing support for the 9V Vexia EDU ATLA 10 tablet
symbols to prepare for adding support for the 5V version.

All this patch does is s/vexia_edu_atla10_info/vexia_edu_atla10_9v_info/.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250407092017.273124-1-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/x86-android-tablets/dmi.c    |  2 +-
 .../platform/x86/x86-android-tablets/other.c  | 64 +++++++++----------
 .../x86-android-tablets/x86-android-tablets.h |  2 +-
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/dmi.c b/drivers/platform/x86/x86-android-tablets/dmi.c
index 3e5fa3b6e2fdf..e43d482b17a35 100644
--- a/drivers/platform/x86/x86-android-tablets/dmi.c
+++ b/drivers/platform/x86/x86-android-tablets/dmi.c
@@ -187,7 +187,7 @@ const struct dmi_system_id x86_android_tablet_ids[] __initconst = {
 			/* Above strings are too generic, also match on BIOS date */
 			DMI_MATCH(DMI_BIOS_DATE, "08/25/2014"),
 		},
-		.driver_data = (void *)&vexia_edu_atla10_info,
+		.driver_data = (void *)&vexia_edu_atla10_9v_info,
 	},
 	{
 		/* Whitelabel (sold as various brands) TM800A550L */
diff --git a/drivers/platform/x86/x86-android-tablets/other.c b/drivers/platform/x86/x86-android-tablets/other.c
index 1d93d9edb23f4..74dcac8d19d72 100644
--- a/drivers/platform/x86/x86-android-tablets/other.c
+++ b/drivers/platform/x86/x86-android-tablets/other.c
@@ -599,62 +599,62 @@ const struct x86_dev_info whitelabel_tm800a550l_info __initconst = {
 };
 
 /*
- * Vexia EDU ATLA 10 tablet, Android 4.2 / 4.4 + Guadalinex Ubuntu tablet
+ * Vexia EDU ATLA 10 tablet 9V, Android 4.2 + Guadalinex Ubuntu tablet
  * distributed to schools in the Spanish Andalucía region.
  */
 static const char * const crystal_cove_pwrsrc_psy[] = { "crystal_cove_pwrsrc" };
 
-static const struct property_entry vexia_edu_atla10_ulpmc_props[] = {
+static const struct property_entry vexia_edu_atla10_9v_ulpmc_props[] = {
 	PROPERTY_ENTRY_STRING_ARRAY("supplied-from", crystal_cove_pwrsrc_psy),
 	{ }
 };
 
-static const struct software_node vexia_edu_atla10_ulpmc_node = {
-	.properties = vexia_edu_atla10_ulpmc_props,
+static const struct software_node vexia_edu_atla10_9v_ulpmc_node = {
+	.properties = vexia_edu_atla10_9v_ulpmc_props,
 };
 
-static const char * const vexia_edu_atla10_accel_mount_matrix[] = {
+static const char * const vexia_edu_atla10_9v_accel_mount_matrix[] = {
 	"0", "-1", "0",
 	"1", "0", "0",
 	"0", "0", "1"
 };
 
-static const struct property_entry vexia_edu_atla10_accel_props[] = {
-	PROPERTY_ENTRY_STRING_ARRAY("mount-matrix", vexia_edu_atla10_accel_mount_matrix),
+static const struct property_entry vexia_edu_atla10_9v_accel_props[] = {
+	PROPERTY_ENTRY_STRING_ARRAY("mount-matrix", vexia_edu_atla10_9v_accel_mount_matrix),
 	{ }
 };
 
-static const struct software_node vexia_edu_atla10_accel_node = {
-	.properties = vexia_edu_atla10_accel_props,
+static const struct software_node vexia_edu_atla10_9v_accel_node = {
+	.properties = vexia_edu_atla10_9v_accel_props,
 };
 
-static const struct property_entry vexia_edu_atla10_touchscreen_props[] = {
+static const struct property_entry vexia_edu_atla10_9v_touchscreen_props[] = {
 	PROPERTY_ENTRY_U32("hid-descr-addr", 0x0000),
 	PROPERTY_ENTRY_U32("post-reset-deassert-delay-ms", 120),
 	{ }
 };
 
-static const struct software_node vexia_edu_atla10_touchscreen_node = {
-	.properties = vexia_edu_atla10_touchscreen_props,
+static const struct software_node vexia_edu_atla10_9v_touchscreen_node = {
+	.properties = vexia_edu_atla10_9v_touchscreen_props,
 };
 
-static const struct property_entry vexia_edu_atla10_pmic_props[] = {
+static const struct property_entry vexia_edu_atla10_9v_pmic_props[] = {
 	PROPERTY_ENTRY_BOOL("linux,register-pwrsrc-power_supply"),
 	{ }
 };
 
-static const struct software_node vexia_edu_atla10_pmic_node = {
-	.properties = vexia_edu_atla10_pmic_props,
+static const struct software_node vexia_edu_atla10_9v_pmic_node = {
+	.properties = vexia_edu_atla10_9v_pmic_props,
 };
 
-static const struct x86_i2c_client_info vexia_edu_atla10_i2c_clients[] __initconst = {
+static const struct x86_i2c_client_info vexia_edu_atla10_9v_i2c_clients[] __initconst = {
 	{
 		/* I2C attached embedded controller, used to access fuel-gauge */
 		.board_info = {
 			.type = "vexia_atla10_ec",
 			.addr = 0x76,
 			.dev_name = "ulpmc",
-			.swnode = &vexia_edu_atla10_ulpmc_node,
+			.swnode = &vexia_edu_atla10_9v_ulpmc_node,
 		},
 		.adapter_path = "0000:00:18.1",
 	}, {
@@ -679,7 +679,7 @@ static const struct x86_i2c_client_info vexia_edu_atla10_i2c_clients[] __initcon
 			.type = "kxtj21009",
 			.addr = 0x0f,
 			.dev_name = "kxtj21009",
-			.swnode = &vexia_edu_atla10_accel_node,
+			.swnode = &vexia_edu_atla10_9v_accel_node,
 		},
 		.adapter_path = "0000:00:18.5",
 	}, {
@@ -688,7 +688,7 @@ static const struct x86_i2c_client_info vexia_edu_atla10_i2c_clients[] __initcon
 			.type = "hid-over-i2c",
 			.addr = 0x38,
 			.dev_name = "FTSC1000",
-			.swnode = &vexia_edu_atla10_touchscreen_node,
+			.swnode = &vexia_edu_atla10_9v_touchscreen_node,
 		},
 		.adapter_path = "0000:00:18.6",
 		.irq_data = {
@@ -703,7 +703,7 @@ static const struct x86_i2c_client_info vexia_edu_atla10_i2c_clients[] __initcon
 			.type = "intel_soc_pmic_crc",
 			.addr = 0x6e,
 			.dev_name = "intel_soc_pmic_crc",
-			.swnode = &vexia_edu_atla10_pmic_node,
+			.swnode = &vexia_edu_atla10_9v_pmic_node,
 		},
 		.adapter_path = "0000:00:18.7",
 		.irq_data = {
@@ -715,7 +715,7 @@ static const struct x86_i2c_client_info vexia_edu_atla10_i2c_clients[] __initcon
 	}
 };
 
-static const struct x86_serdev_info vexia_edu_atla10_serdevs[] __initconst = {
+static const struct x86_serdev_info vexia_edu_atla10_9v_serdevs[] __initconst = {
 	{
 		.ctrl.pci.devfn = PCI_DEVFN(0x1e, 3),
 		.ctrl_devname = "serial0",
@@ -723,7 +723,7 @@ static const struct x86_serdev_info vexia_edu_atla10_serdevs[] __initconst = {
 	},
 };
 
-static struct gpiod_lookup_table vexia_edu_atla10_ft5416_gpios = {
+static struct gpiod_lookup_table vexia_edu_atla10_9v_ft5416_gpios = {
 	.dev_id = "i2c-FTSC1000",
 	.table = {
 		GPIO_LOOKUP("INT33FC:00", 60, "reset", GPIO_ACTIVE_LOW),
@@ -731,12 +731,12 @@ static struct gpiod_lookup_table vexia_edu_atla10_ft5416_gpios = {
 	},
 };
 
-static struct gpiod_lookup_table * const vexia_edu_atla10_gpios[] = {
-	&vexia_edu_atla10_ft5416_gpios,
+static struct gpiod_lookup_table * const vexia_edu_atla10_9v_gpios[] = {
+	&vexia_edu_atla10_9v_ft5416_gpios,
 	NULL
 };
 
-static int __init vexia_edu_atla10_init(struct device *dev)
+static int __init vexia_edu_atla10_9v_init(struct device *dev)
 {
 	struct pci_dev *pdev;
 	int ret;
@@ -760,13 +760,13 @@ static int __init vexia_edu_atla10_init(struct device *dev)
 	return 0;
 }
 
-const struct x86_dev_info vexia_edu_atla10_info __initconst = {
-	.i2c_client_info = vexia_edu_atla10_i2c_clients,
-	.i2c_client_count = ARRAY_SIZE(vexia_edu_atla10_i2c_clients),
-	.serdev_info = vexia_edu_atla10_serdevs,
-	.serdev_count = ARRAY_SIZE(vexia_edu_atla10_serdevs),
-	.gpiod_lookup_tables = vexia_edu_atla10_gpios,
-	.init = vexia_edu_atla10_init,
+const struct x86_dev_info vexia_edu_atla10_9v_info __initconst = {
+	.i2c_client_info = vexia_edu_atla10_9v_i2c_clients,
+	.i2c_client_count = ARRAY_SIZE(vexia_edu_atla10_9v_i2c_clients),
+	.serdev_info = vexia_edu_atla10_9v_serdevs,
+	.serdev_count = ARRAY_SIZE(vexia_edu_atla10_9v_serdevs),
+	.gpiod_lookup_tables = vexia_edu_atla10_9v_gpios,
+	.init = vexia_edu_atla10_9v_init,
 	.use_pci = true,
 };
 
diff --git a/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h b/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h
index 63a38a0069bae..2204bbaf2ed5a 100644
--- a/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h
+++ b/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h
@@ -127,7 +127,7 @@ extern const struct x86_dev_info nextbook_ares8_info;
 extern const struct x86_dev_info nextbook_ares8a_info;
 extern const struct x86_dev_info peaq_c1010_info;
 extern const struct x86_dev_info whitelabel_tm800a550l_info;
-extern const struct x86_dev_info vexia_edu_atla10_info;
+extern const struct x86_dev_info vexia_edu_atla10_9v_info;
 extern const struct x86_dev_info xiaomi_mipad2_info;
 extern const struct dmi_system_id x86_android_tablet_ids[];
 
-- 
2.39.5



