Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481FA155351;
	Tue, 23 Jul 2024 18:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759300; cv=none; b=IBndHDW1htL8r5HvQ8Dayz0+HzIbeF5yMwKZDzvefgAiaePiVCe+CAI6amDGUn289B9B1q1wdQoquxLNN2Y2yz0PGeA27p938gXh9tB4UCp3/FycHQGkojA80aIDajl9f9SZauG/66M1oWBO53rqhoiAeBXLz2pWs1vvkOob8CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759300; c=relaxed/simple;
	bh=nazeofJxKlV7PcPOYNr9LbhbMcOZqR/AXTxGpxn9XFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meYq4Tq4WChjpjfTHGUz1ukOsKnuhi3LLjxBJtFLV0Wnw3IUapcqOzLynw/9S89g5U6WkQUVP/3ThI2bcOj8KMQeahUwapi98JaUkX/IELZEwVPGm6GLOALnMz/7KlBOKpp1iAyxjJtLT0/Gx3KHnWo/AKh0B3Z3W9z+0J1IdGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvB6QyNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvB6QyNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C02AC4AF0A;
	Tue, 23 Jul 2024 18:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759300;
	bh=nazeofJxKlV7PcPOYNr9LbhbMcOZqR/AXTxGpxn9XFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvB6QyNP/1kLpXTKpkaU/6QkaW1B16aR2ym2h3ZOkvTqecJMXAau6YEoTZWZJjCAQ
	 vyZuAFA4gwj2yqVOxLl/r6zQBPP6cw6rxrsHyffHelCN+hbvvkygKfL5/lNTb/OVIm
	 rua8AiHtGhlxxFHMkf7opr2tcRuUDA+yqc0011sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/105] platform/x86: lg-laptop: Use ACPI device handle when evaluating WMAB/WMBB
Date: Tue, 23 Jul 2024 20:23:47 +0200
Message-ID: <20240723180405.943459501@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit b27ea279556121b54d3f45d0529706cf100cdb3a ]

On the LG Gram 16Z90S, the WMAB and WMBB ACPI methods are not mapped
under \XINI, but instead are mapped under \_SB.XINI.

The reason for this is that the LGEX0820 ACPI device used by this
driver is mapped at \_SB.XINI, so the ACPI methods where moved as well
to appear below the LGEX0820 ACPI device.

Fix this by using the ACPI handle from the ACPI device when evaluating
both methods.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218901
Tested-by: Agathe Boutmy <agathe@boutmy.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240606233540.9774-5-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 79 +++++++++++++-------------------
 1 file changed, 33 insertions(+), 46 deletions(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 40051b043c422..2e1dc91bfc764 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -39,8 +39,6 @@ MODULE_LICENSE("GPL");
 #define WMI_METHOD_WMBB "2B4F501A-BD3C-4394-8DCF-00A7D2BC8210"
 #define WMI_EVENT_GUID  WMI_EVENT_GUID0
 
-#define WMAB_METHOD     "\\XINI.WMAB"
-#define WMBB_METHOD     "\\XINI.WMBB"
 #define SB_GGOV_METHOD  "\\_SB.GGOV"
 #define GOV_TLED        0x2020008
 #define WM_GET          1
@@ -74,7 +72,7 @@ static u32 inited;
 
 static int battery_limit_use_wmbb;
 static struct led_classdev kbd_backlight;
-static enum led_brightness get_kbd_backlight_level(void);
+static enum led_brightness get_kbd_backlight_level(struct device *dev);
 
 static const struct key_entry wmi_keymap[] = {
 	{KE_KEY, 0x70, {KEY_F15} },	 /* LG control panel (F1) */
@@ -127,11 +125,10 @@ static int ggov(u32 arg0)
 	return res;
 }
 
-static union acpi_object *lg_wmab(u32 method, u32 arg1, u32 arg2)
+static union acpi_object *lg_wmab(struct device *dev, u32 method, u32 arg1, u32 arg2)
 {
 	union acpi_object args[3];
 	acpi_status status;
-	acpi_handle handle;
 	struct acpi_object_list arg;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
@@ -142,29 +139,22 @@ static union acpi_object *lg_wmab(u32 method, u32 arg1, u32 arg2)
 	args[2].type = ACPI_TYPE_INTEGER;
 	args[2].integer.value = arg2;
 
-	status = acpi_get_handle(NULL, (acpi_string) WMAB_METHOD, &handle);
-	if (ACPI_FAILURE(status)) {
-		pr_err("Cannot get handle");
-		return NULL;
-	}
-
 	arg.count = 3;
 	arg.pointer = args;
 
-	status = acpi_evaluate_object(handle, NULL, &arg, &buffer);
+	status = acpi_evaluate_object(ACPI_HANDLE(dev), "WMAB", &arg, &buffer);
 	if (ACPI_FAILURE(status)) {
-		acpi_handle_err(handle, "WMAB: call failed.\n");
+		dev_err(dev, "WMAB: call failed.\n");
 		return NULL;
 	}
 
 	return buffer.pointer;
 }
 
-static union acpi_object *lg_wmbb(u32 method_id, u32 arg1, u32 arg2)
+static union acpi_object *lg_wmbb(struct device *dev, u32 method_id, u32 arg1, u32 arg2)
 {
 	union acpi_object args[3];
 	acpi_status status;
-	acpi_handle handle;
 	struct acpi_object_list arg;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	u8 buf[32];
@@ -180,18 +170,12 @@ static union acpi_object *lg_wmbb(u32 method_id, u32 arg1, u32 arg2)
 	args[2].buffer.length = 32;
 	args[2].buffer.pointer = buf;
 
-	status = acpi_get_handle(NULL, (acpi_string)WMBB_METHOD, &handle);
-	if (ACPI_FAILURE(status)) {
-		pr_err("Cannot get handle");
-		return NULL;
-	}
-
 	arg.count = 3;
 	arg.pointer = args;
 
-	status = acpi_evaluate_object(handle, NULL, &arg, &buffer);
+	status = acpi_evaluate_object(ACPI_HANDLE(dev), "WMBB", &arg, &buffer);
 	if (ACPI_FAILURE(status)) {
-		acpi_handle_err(handle, "WMAB: call failed.\n");
+		dev_err(dev, "WMBB: call failed.\n");
 		return NULL;
 	}
 
@@ -222,7 +206,7 @@ static void wmi_notify(u32 value, void *context)
 
 		if (eventcode == 0x10000000) {
 			led_classdev_notify_brightness_hw_changed(
-				&kbd_backlight, get_kbd_backlight_level());
+				&kbd_backlight, get_kbd_backlight_level(kbd_backlight.dev->parent));
 		} else {
 			key = sparse_keymap_entry_from_scancode(
 				wmi_input_dev, eventcode);
@@ -287,7 +271,7 @@ static ssize_t fan_mode_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	r = lg_wmab(WM_FAN_MODE, WM_GET, 0);
+	r = lg_wmab(dev, WM_FAN_MODE, WM_GET, 0);
 	if (!r)
 		return -EIO;
 
@@ -298,9 +282,9 @@ static ssize_t fan_mode_store(struct device *dev,
 
 	m = r->integer.value;
 	kfree(r);
-	r = lg_wmab(WM_FAN_MODE, WM_SET, (m & 0xffffff0f) | (value << 4));
+	r = lg_wmab(dev, WM_FAN_MODE, WM_SET, (m & 0xffffff0f) | (value << 4));
 	kfree(r);
-	r = lg_wmab(WM_FAN_MODE, WM_SET, (m & 0xfffffff0) | value);
+	r = lg_wmab(dev, WM_FAN_MODE, WM_SET, (m & 0xfffffff0) | value);
 	kfree(r);
 
 	return count;
@@ -312,7 +296,7 @@ static ssize_t fan_mode_show(struct device *dev,
 	unsigned int status;
 	union acpi_object *r;
 
-	r = lg_wmab(WM_FAN_MODE, WM_GET, 0);
+	r = lg_wmab(dev, WM_FAN_MODE, WM_GET, 0);
 	if (!r)
 		return -EIO;
 
@@ -339,7 +323,7 @@ static ssize_t usb_charge_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	r = lg_wmbb(WMBB_USB_CHARGE, WM_SET, value);
+	r = lg_wmbb(dev, WMBB_USB_CHARGE, WM_SET, value);
 	if (!r)
 		return -EIO;
 
@@ -353,7 +337,7 @@ static ssize_t usb_charge_show(struct device *dev,
 	unsigned int status;
 	union acpi_object *r;
 
-	r = lg_wmbb(WMBB_USB_CHARGE, WM_GET, 0);
+	r = lg_wmbb(dev, WMBB_USB_CHARGE, WM_GET, 0);
 	if (!r)
 		return -EIO;
 
@@ -381,7 +365,7 @@ static ssize_t reader_mode_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	r = lg_wmab(WM_READER_MODE, WM_SET, value);
+	r = lg_wmab(dev, WM_READER_MODE, WM_SET, value);
 	if (!r)
 		return -EIO;
 
@@ -395,7 +379,7 @@ static ssize_t reader_mode_show(struct device *dev,
 	unsigned int status;
 	union acpi_object *r;
 
-	r = lg_wmab(WM_READER_MODE, WM_GET, 0);
+	r = lg_wmab(dev, WM_READER_MODE, WM_GET, 0);
 	if (!r)
 		return -EIO;
 
@@ -423,7 +407,7 @@ static ssize_t fn_lock_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	r = lg_wmab(WM_FN_LOCK, WM_SET, value);
+	r = lg_wmab(dev, WM_FN_LOCK, WM_SET, value);
 	if (!r)
 		return -EIO;
 
@@ -437,7 +421,7 @@ static ssize_t fn_lock_show(struct device *dev,
 	unsigned int status;
 	union acpi_object *r;
 
-	r = lg_wmab(WM_FN_LOCK, WM_GET, 0);
+	r = lg_wmab(dev, WM_FN_LOCK, WM_GET, 0);
 	if (!r)
 		return -EIO;
 
@@ -467,9 +451,9 @@ static ssize_t charge_control_end_threshold_store(struct device *dev,
 		union acpi_object *r;
 
 		if (battery_limit_use_wmbb)
-			r = lg_wmbb(WMBB_BATT_LIMIT, WM_SET, value);
+			r = lg_wmbb(&pf_device->dev, WMBB_BATT_LIMIT, WM_SET, value);
 		else
-			r = lg_wmab(WM_BATT_LIMIT, WM_SET, value);
+			r = lg_wmab(&pf_device->dev, WM_BATT_LIMIT, WM_SET, value);
 		if (!r)
 			return -EIO;
 
@@ -488,7 +472,7 @@ static ssize_t charge_control_end_threshold_show(struct device *device,
 	union acpi_object *r;
 
 	if (battery_limit_use_wmbb) {
-		r = lg_wmbb(WMBB_BATT_LIMIT, WM_GET, 0);
+		r = lg_wmbb(&pf_device->dev, WMBB_BATT_LIMIT, WM_GET, 0);
 		if (!r)
 			return -EIO;
 
@@ -499,7 +483,7 @@ static ssize_t charge_control_end_threshold_show(struct device *device,
 
 		status = r->buffer.pointer[0x10];
 	} else {
-		r = lg_wmab(WM_BATT_LIMIT, WM_GET, 0);
+		r = lg_wmab(&pf_device->dev, WM_BATT_LIMIT, WM_GET, 0);
 		if (!r)
 			return -EIO;
 
@@ -578,7 +562,7 @@ static void tpad_led_set(struct led_classdev *cdev,
 {
 	union acpi_object *r;
 
-	r = lg_wmab(WM_TLED, WM_SET, brightness > LED_OFF);
+	r = lg_wmab(cdev->dev->parent, WM_TLED, WM_SET, brightness > LED_OFF);
 	kfree(r);
 }
 
@@ -600,16 +584,16 @@ static void kbd_backlight_set(struct led_classdev *cdev,
 		val = 0;
 	if (brightness >= LED_FULL)
 		val = 0x24;
-	r = lg_wmab(WM_KEY_LIGHT, WM_SET, val);
+	r = lg_wmab(cdev->dev->parent, WM_KEY_LIGHT, WM_SET, val);
 	kfree(r);
 }
 
-static enum led_brightness get_kbd_backlight_level(void)
+static enum led_brightness get_kbd_backlight_level(struct device *dev)
 {
 	union acpi_object *r;
 	int val;
 
-	r = lg_wmab(WM_KEY_LIGHT, WM_GET, 0);
+	r = lg_wmab(dev, WM_KEY_LIGHT, WM_GET, 0);
 
 	if (!r)
 		return LED_OFF;
@@ -637,7 +621,7 @@ static enum led_brightness get_kbd_backlight_level(void)
 
 static enum led_brightness kbd_backlight_get(struct led_classdev *cdev)
 {
-	return get_kbd_backlight_level();
+	return get_kbd_backlight_level(cdev->dev->parent);
 }
 
 static LED_DEVICE(kbd_backlight, 255, LED_BRIGHT_HW_CHANGED);
@@ -664,6 +648,11 @@ static struct platform_driver pf_driver = {
 
 static int acpi_add(struct acpi_device *device)
 {
+	struct platform_device_info pdev_info = {
+		.fwnode = acpi_fwnode_handle(device),
+		.name = PLATFORM_NAME,
+		.id = PLATFORM_DEVID_NONE,
+	};
 	int ret;
 	const char *product;
 	int year = 2017;
@@ -675,9 +664,7 @@ static int acpi_add(struct acpi_device *device)
 	if (ret)
 		return ret;
 
-	pf_device = platform_device_register_simple(PLATFORM_NAME,
-						    PLATFORM_DEVID_NONE,
-						    NULL, 0);
+	pf_device = platform_device_register_full(&pdev_info);
 	if (IS_ERR(pf_device)) {
 		ret = PTR_ERR(pf_device);
 		pf_device = NULL;
-- 
2.43.0



