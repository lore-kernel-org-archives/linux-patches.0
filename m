Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C3B2F2352;
	Thu,  3 Jul 2025 15:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555601; cv=none; b=OejgfGCo5L6CgMc3B5if34CtmXkWZsHSkoo9SDjD689Z8B27Vsz+P9hMhGnAOiXbxiirKeSRn1ZXCC5fAjXklSmZB9DZIO1x0DcsYLMirk2f9sxGttsg/ODdB8XNMA8FgfX2e4VVK3vNhLxrfy3lBTrvYog7SKnu/VnRG4gnrgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555601; c=relaxed/simple;
	bh=iYiYxbpneT0/Rh77Noan+ormlrz7fX8dtxMWp9RjSFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QcwJiPmhAqNBkQyFUjEHmCmwxYmrm2xmxWVujkJ/TPJK16w0hLNr798WkRev7dSwKnR9rp9oSqJwqpWJ6hDpU/ZiRoG3S21eajwziMAS61wAvprfrmDiQzB3SMqh2r9y9c/+Pvfp+B/s7qYjnEvsR1bxA7Co7YK1OBmTwq5b59A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zn45tYjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zn45tYjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC17EC4CEE3;
	Thu,  3 Jul 2025 15:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555601;
	bh=iYiYxbpneT0/Rh77Noan+ormlrz7fX8dtxMWp9RjSFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zn45tYjY/KutkWqmSJPDhhYBC1mbv44jIKjlde7KfYVBAxBI0z9A6iIrrCuRhxdg8
	 o6oVo3hS0wzdH3Exvc/kY6lHgVvYd6vBVeHVbMdwed/5SOKr9jkaw5hlgHldl2BG+D
	 ktCWLXFgSm5+M1gPRIl7DvFsM0A8MuXrdye/rTf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/139] platform/x86: ideapad-laptop: move ymc_trigger_ec from lenovo-ymc
Date: Thu,  3 Jul 2025 16:42:06 +0200
Message-ID: <20250703143943.631085780@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit cde7886b35176d56e72bfc68dc104fa08e7b072c ]

Some models need to trigger the EC after each YMC event for the yoga
mode control to work properly. EC triggering consist of a VPC call from
the lenovo-ymc module. Except for this, all VPC calls are in the
ideapad-laptop module.

Since ideapad-laptop has a notification chain, a new YMC_EVENT action
can be added and triggered from the lenovo-ymc module. Then the
ideapad-laptop can trigger the EC.

If the triggering is in the ideapad-laptop module, then the ec_trigger
module parameter should be there as well.

Move the ymc_trigger_ec functionality and the ec_trigger module
parameter to the ideapad-laptop module.

Signed-off-by: Gergo Koteles <soyer@irl.hu>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/d980ab3ac32b5e554f456b0ff17279bfdbe2a203.1721898747.git.soyer@irl.hu
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 5808c3421695 ("platform/x86: ideapad-laptop: use usleep_range() for EC polling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig          |  1 +
 drivers/platform/x86/ideapad-laptop.c | 49 ++++++++++++++++++++++
 drivers/platform/x86/ideapad-laptop.h |  4 ++
 drivers/platform/x86/lenovo-ymc.c     | 60 +--------------------------
 4 files changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 07eea525091b0..1fd57eb867662 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -466,6 +466,7 @@ config LENOVO_YMC
 	tristate "Lenovo Yoga Tablet Mode Control"
 	depends on ACPI_WMI
 	depends on INPUT
+	depends on IDEAPAD_LAPTOP
 	select INPUT_SPARSEKMAP
 	help
 	  This driver maps the Tablet Mode Control switch to SW_TABLET_MODE input
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index e21b4dcfe1ddd..3d23c4f908426 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -145,6 +145,7 @@ struct ideapad_private {
 		bool touchpad_ctrl_via_ec : 1;
 		bool ctrl_ps2_aux_port    : 1;
 		bool usb_charging         : 1;
+		bool ymc_ec_trigger       : 1;
 	} features;
 	struct {
 		bool initialized;
@@ -188,6 +189,12 @@ MODULE_PARM_DESC(touchpad_ctrl_via_ec,
 	"Enable registering a 'touchpad' sysfs-attribute which can be used to manually "
 	"tell the EC to enable/disable the touchpad. This may not work on all models.");
 
+static bool ymc_ec_trigger __read_mostly;
+module_param(ymc_ec_trigger, bool, 0444);
+MODULE_PARM_DESC(ymc_ec_trigger,
+	"Enable EC triggering work-around to force emitting tablet mode events. "
+	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
+
 /*
  * shared data
  */
@@ -1501,10 +1508,50 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_
 	priv->r_touchpad_val = value;
 }
 
+static const struct dmi_system_id ymc_ec_trigger_quirk_dmi_table[] = {
+	{
+		/* Lenovo Yoga 7 14ARB7 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82QF"),
+		},
+	},
+	{
+		/* Lenovo Yoga 7 14ACN6 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82N7"),
+		},
+	},
+	{ }
+};
+
+static void ideapad_laptop_trigger_ec(void)
+{
+	struct ideapad_private *priv;
+	int ret;
+
+	guard(mutex)(&ideapad_shared_mutex);
+
+	priv = ideapad_shared;
+	if (!priv)
+		return;
+
+	if (!priv->features.ymc_ec_trigger)
+		return;
+
+	ret = write_ec_cmd(priv->adev->handle, VPCCMD_W_YMC, 1);
+	if (ret)
+		dev_warn(&priv->platform_device->dev, "Could not write YMC: %d\n", ret);
+}
+
 static int ideapad_laptop_nb_notify(struct notifier_block *nb,
 				    unsigned long action, void *data)
 {
 	switch (action) {
+	case IDEAPAD_LAPTOP_YMC_EVENT:
+		ideapad_laptop_trigger_ec();
+		break;
 	}
 
 	return 0;
@@ -1670,6 +1717,8 @@ static void ideapad_check_features(struct ideapad_private *priv)
 	priv->features.ctrl_ps2_aux_port =
 		ctrl_ps2_aux_port || dmi_check_system(ctrl_ps2_aux_port_list);
 	priv->features.touchpad_ctrl_via_ec = touchpad_ctrl_via_ec;
+	priv->features.ymc_ec_trigger =
+		ymc_ec_trigger || dmi_check_system(ymc_ec_trigger_quirk_dmi_table);
 
 	if (!read_ec_data(handle, VPCCMD_R_FAN, &val))
 		priv->features.fan_mode = true;
diff --git a/drivers/platform/x86/ideapad-laptop.h b/drivers/platform/x86/ideapad-laptop.h
index 3eb0dcd6bf7ba..948cc61800a95 100644
--- a/drivers/platform/x86/ideapad-laptop.h
+++ b/drivers/platform/x86/ideapad-laptop.h
@@ -14,6 +14,10 @@
 #include <linux/errno.h>
 #include <linux/notifier.h>
 
+enum ideapad_laptop_notifier_actions {
+	IDEAPAD_LAPTOP_YMC_EVENT,
+};
+
 int ideapad_laptop_register_notifier(struct notifier_block *nb);
 int ideapad_laptop_unregister_notifier(struct notifier_block *nb);
 void ideapad_laptop_call_notifier(unsigned long action, void *data);
diff --git a/drivers/platform/x86/lenovo-ymc.c b/drivers/platform/x86/lenovo-ymc.c
index ef2c267ab485c..bd9f95404c7cb 100644
--- a/drivers/platform/x86/lenovo-ymc.c
+++ b/drivers/platform/x86/lenovo-ymc.c
@@ -20,32 +20,10 @@
 #define LENOVO_YMC_QUERY_INSTANCE 0
 #define LENOVO_YMC_QUERY_METHOD 0x01
 
-static bool ec_trigger __read_mostly;
-module_param(ec_trigger, bool, 0444);
-MODULE_PARM_DESC(ec_trigger, "Enable EC triggering work-around to force emitting tablet mode events");
-
 static bool force;
 module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "Force loading on boards without a convertible DMI chassis-type");
 
-static const struct dmi_system_id ec_trigger_quirk_dmi_table[] = {
-	{
-		/* Lenovo Yoga 7 14ARB7 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "82QF"),
-		},
-	},
-	{
-		/* Lenovo Yoga 7 14ACN6 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "82N7"),
-		},
-	},
-	{ }
-};
-
 static const struct dmi_system_id allowed_chasis_types_dmi_table[] = {
 	{
 		.matches = {
@@ -62,21 +40,8 @@ static const struct dmi_system_id allowed_chasis_types_dmi_table[] = {
 
 struct lenovo_ymc_private {
 	struct input_dev *input_dev;
-	struct acpi_device *ec_acpi_dev;
 };
 
-static void lenovo_ymc_trigger_ec(struct wmi_device *wdev, struct lenovo_ymc_private *priv)
-{
-	int err;
-
-	if (!priv->ec_acpi_dev)
-		return;
-
-	err = write_ec_cmd(priv->ec_acpi_dev->handle, VPCCMD_W_YMC, 1);
-	if (err)
-		dev_warn(&wdev->dev, "Could not write YMC: %d\n", err);
-}
-
 static const struct key_entry lenovo_ymc_keymap[] = {
 	/* Ignore the uninitialized state */
 	{ KE_IGNORE, 0x00 },
@@ -127,11 +92,9 @@ static void lenovo_ymc_notify(struct wmi_device *wdev, union acpi_object *data)
 
 free_obj:
 	kfree(obj);
-	lenovo_ymc_trigger_ec(wdev, priv);
+	ideapad_laptop_call_notifier(IDEAPAD_LAPTOP_YMC_EVENT, &code);
 }
 
-static void acpi_dev_put_helper(void *p) { acpi_dev_put(p); }
-
 static int lenovo_ymc_probe(struct wmi_device *wdev, const void *ctx)
 {
 	struct lenovo_ymc_private *priv;
@@ -145,29 +108,10 @@ static int lenovo_ymc_probe(struct wmi_device *wdev, const void *ctx)
 			return -ENODEV;
 	}
 
-	ec_trigger |= dmi_check_system(ec_trigger_quirk_dmi_table);
-
 	priv = devm_kzalloc(&wdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	if (ec_trigger) {
-		pr_debug("Lenovo YMC enable EC triggering.\n");
-		priv->ec_acpi_dev = acpi_dev_get_first_match_dev("VPC2004", NULL, -1);
-
-		if (!priv->ec_acpi_dev) {
-			dev_err(&wdev->dev, "Could not find EC ACPI device.\n");
-			return -ENODEV;
-		}
-		err = devm_add_action_or_reset(&wdev->dev,
-				acpi_dev_put_helper, priv->ec_acpi_dev);
-		if (err) {
-			dev_err(&wdev->dev,
-				"Could not clean up EC ACPI device: %d\n", err);
-			return err;
-		}
-	}
-
 	input_dev = devm_input_allocate_device(&wdev->dev);
 	if (!input_dev)
 		return -ENOMEM;
@@ -194,7 +138,6 @@ static int lenovo_ymc_probe(struct wmi_device *wdev, const void *ctx)
 	dev_set_drvdata(&wdev->dev, priv);
 
 	/* Report the state for the first time on probe */
-	lenovo_ymc_trigger_ec(wdev, priv);
 	lenovo_ymc_notify(wdev, NULL);
 	return 0;
 }
@@ -219,3 +162,4 @@ module_wmi_driver(lenovo_ymc_driver);
 MODULE_AUTHOR("Gergo Koteles <soyer@irl.hu>");
 MODULE_DESCRIPTION("Lenovo Yoga Mode Control driver");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(IDEAPAD_LAPTOP);
-- 
2.39.5



