Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D05522A81D;
	Tue, 29 Apr 2025 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946497; cv=none; b=etaOGHaIjpQypUVmldi8deLHujx9fRNlZ7RHYhFft/F64yWyYo6bpcGWKnYF3XZBf0EFdJ9krapD8jJvCxJIfcY279XPqAuCKrTeNVuviXzKH/C5rkiJE9cRRYsNy+q1o4QvB/7nJjT0o0cNRXFgig8VoENv1xedLZUkEI2DdmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946497; c=relaxed/simple;
	bh=GaZvHo1+h2mzvH0tg6aCaH6Nv/OYpLFCHhbm1ai9ltE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hzrp7BHw7w1AU1R30sAzgYjUi+vgQDNGzHXz8rI/xox451neuPfZJQ961H5S/GMK9Qfhmluf5Lv2W8PYiwinuqvxkAeWGIlgrC9ZXtgrIhR9fCYnSaBJP4N57O+bw22ofHNUFWNJNt2S9Y8zXhv8spr+D8GtZ1AqcwajaD0X+pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGE2Klbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGE2Klbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D61C4CEE3;
	Tue, 29 Apr 2025 17:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946497;
	bh=GaZvHo1+h2mzvH0tg6aCaH6Nv/OYpLFCHhbm1ai9ltE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGE2KlbeyAv8XqMqtPRiK6vW0sU00bFf5N59VJMSC9QCvf1Et35D7/5ECmj2OMa12
	 Pa/Ax+Ge38ZNcz/cUqNM0p+2UT3HKlE9Grp0TfHmnnkkqC+8KwidW5trO6B3vZtrwr
	 kaxptB2KGpdvCbhxIsG+9q+yknLH26v0Hgu5OSl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 279/311] platform/x86: x86-android-tablets: Add Vexia Edu Atla 10 tablet 5V data
Date: Tue, 29 Apr 2025 18:41:56 +0200
Message-ID: <20250429161132.443013102@linuxfoundation.org>
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

[ Upstream commit 59df54c67be3e587e4217bddd793350fbe8f5feb ]

The Vexia EDU ATLA 10 tablet comes in 2 different versions with
significantly different mainboards. The only outward difference is that
the charging barrel on one is marked 5V and the other is marked 9V.

Both are x86 ACPI tablets which ships with Android x86 as factory OS.
with a DSDT which contains a bunch of I2C devices which are not actually
there, causing various resource conflicts. Enumeration of these is skipped
through the acpi_quirk_skip_i2c_client_enumeration().

Extend the existing support for the 9V version by adding support for
manually instantiating the I2C devices which are actually present on
the 5V version by adding the necessary device info to
the x86-android-tablets module.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250407092017.273124-2-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/x86-android-tablets/dmi.c    | 12 ++++
 .../platform/x86/x86-android-tablets/other.c  | 60 +++++++++++++++++++
 .../x86-android-tablets/x86-android-tablets.h |  1 +
 3 files changed, 73 insertions(+)

diff --git a/drivers/platform/x86/x86-android-tablets/dmi.c b/drivers/platform/x86/x86-android-tablets/dmi.c
index e43d482b17a35..278c6d151dc49 100644
--- a/drivers/platform/x86/x86-android-tablets/dmi.c
+++ b/drivers/platform/x86/x86-android-tablets/dmi.c
@@ -179,6 +179,18 @@ const struct dmi_system_id x86_android_tablet_ids[] __initconst = {
 		},
 		.driver_data = (void *)&peaq_c1010_info,
 	},
+	{
+		/* Vexia Edu Atla 10 tablet 5V version */
+		.matches = {
+			/* Having all 3 of these not set is somewhat unique */
+			DMI_MATCH(DMI_SYS_VENDOR, "To be filled by O.E.M."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "To be filled by O.E.M."),
+			DMI_MATCH(DMI_BOARD_NAME, "To be filled by O.E.M."),
+			/* Above strings are too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "05/14/2015"),
+		},
+		.driver_data = (void *)&vexia_edu_atla10_5v_info,
+	},
 	{
 		/* Vexia Edu Atla 10 tablet 9V version */
 		.matches = {
diff --git a/drivers/platform/x86/x86-android-tablets/other.c b/drivers/platform/x86/x86-android-tablets/other.c
index 74dcac8d19d72..f7bd9f863c85e 100644
--- a/drivers/platform/x86/x86-android-tablets/other.c
+++ b/drivers/platform/x86/x86-android-tablets/other.c
@@ -598,6 +598,66 @@ const struct x86_dev_info whitelabel_tm800a550l_info __initconst = {
 	.gpiod_lookup_tables = whitelabel_tm800a550l_gpios,
 };
 
+/*
+ * Vexia EDU ATLA 10 tablet 5V, Android 4.4 + Guadalinex Ubuntu tablet
+ * distributed to schools in the Spanish Andalucía region.
+ */
+static const struct property_entry vexia_edu_atla10_5v_touchscreen_props[] = {
+	PROPERTY_ENTRY_U32("hid-descr-addr", 0x0000),
+	PROPERTY_ENTRY_U32("post-reset-deassert-delay-ms", 120),
+	{ }
+};
+
+static const struct software_node vexia_edu_atla10_5v_touchscreen_node = {
+	.properties = vexia_edu_atla10_5v_touchscreen_props,
+};
+
+static const struct x86_i2c_client_info vexia_edu_atla10_5v_i2c_clients[] __initconst = {
+	{
+		/* kxcjk1013 accelerometer */
+		.board_info = {
+			.type = "kxcjk1013",
+			.addr = 0x0f,
+			.dev_name = "kxcjk1013",
+		},
+		.adapter_path = "\\_SB_.I2C3",
+	}, {
+		/*  touchscreen controller */
+		.board_info = {
+			.type = "hid-over-i2c",
+			.addr = 0x38,
+			.dev_name = "FTSC1000",
+			.swnode = &vexia_edu_atla10_5v_touchscreen_node,
+		},
+		.adapter_path = "\\_SB_.I2C4",
+		.irq_data = {
+			.type = X86_ACPI_IRQ_TYPE_APIC,
+			.index = 0x44,
+			.trigger = ACPI_LEVEL_SENSITIVE,
+			.polarity = ACPI_ACTIVE_HIGH,
+		},
+	}
+};
+
+static struct gpiod_lookup_table vexia_edu_atla10_5v_ft5416_gpios = {
+	.dev_id = "i2c-FTSC1000",
+	.table = {
+		GPIO_LOOKUP("INT33FC:01", 26, "reset", GPIO_ACTIVE_LOW),
+		{ }
+	},
+};
+
+static struct gpiod_lookup_table * const vexia_edu_atla10_5v_gpios[] = {
+	&vexia_edu_atla10_5v_ft5416_gpios,
+	NULL
+};
+
+const struct x86_dev_info vexia_edu_atla10_5v_info __initconst = {
+	.i2c_client_info = vexia_edu_atla10_5v_i2c_clients,
+	.i2c_client_count = ARRAY_SIZE(vexia_edu_atla10_5v_i2c_clients),
+	.gpiod_lookup_tables = vexia_edu_atla10_5v_gpios,
+};
+
 /*
  * Vexia EDU ATLA 10 tablet 9V, Android 4.2 + Guadalinex Ubuntu tablet
  * distributed to schools in the Spanish Andalucía region.
diff --git a/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h b/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h
index 2204bbaf2ed5a..dcf8d49e3b5f4 100644
--- a/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h
+++ b/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h
@@ -127,6 +127,7 @@ extern const struct x86_dev_info nextbook_ares8_info;
 extern const struct x86_dev_info nextbook_ares8a_info;
 extern const struct x86_dev_info peaq_c1010_info;
 extern const struct x86_dev_info whitelabel_tm800a550l_info;
+extern const struct x86_dev_info vexia_edu_atla10_5v_info;
 extern const struct x86_dev_info vexia_edu_atla10_9v_info;
 extern const struct x86_dev_info xiaomi_mipad2_info;
 extern const struct dmi_system_id x86_android_tablet_ids[];
-- 
2.39.5



