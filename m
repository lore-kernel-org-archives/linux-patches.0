Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829202;
	b=lx9+G0S/PX4p6ErGBSdcJLx0edSXisy8rLfDQY3m50qfpIkReKm3OOXsqwTyLSUQFnEG
	 2vIU2mn5tTKffmkSw6Xr/dURTDFWduDzy3LtkkJmZ9BnTGFkL8+d70B5sqNJ0MrIwi9A+
	 8HUu1mImiVskJQHca2sDV2LG8ExTiPbUVYyNpitdDP7JLGwAMYW8M/UvXur3kEonbK1de
	 9lX72QXdmSqt5RvWpNxAJQJs2STreO+wFq6zVFtepurkvOdAjxAOCihgucIBeIC32PHmh
	 yyTcuVDjErpS0fKsWZG5+IcbjCEPnlv2DEnKcw4fUbj+xQje0jsZ0F3URh4546BuBbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J5/yhEC39O75JR/nwhSO+2oC6TpIsR+AYcmjK61wErk=;
	b=rH0a+faSksjX9AqpN8eiJJHRxwZCB02+F3ARnUSvKVbpKv6uwzoRJhXDhv9XQGrDpAjA
	 3JVK7wBo0Tfwp5tDEIPDrpbt9/07XuuY/FanuXBLd8jHrGv4vvq4COXHfHL0pWTibj+BL
	 6wRD+bMhVDZ6By8M3o/8vDC/W21EMJoKE4vquQoMqREYNraUF1/NRbMJD49R237JGHy8G
	 aTf2Aw2I0IlU6nqvi86SiqQYKPfPaVFqRDKjjyjQOSYeWqZJC/2b4ITXR+/G/MDlhmrhL
	 RczHbjwMOYlQk5xIwIpj1eEMMjbPRbRMIiEg2Dy4KSqGFZSrEjlbvxYo0Fl1smrjfFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHWMxgob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC333607030E;
	Wed,  4 Nov 2026 21:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHWMxgob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E18D1F000C1;
	Wed,  4 Nov 2026 21:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829201;
	bh=J5/yhEC39O75JR/nwhSO+2oC6TpIsR+AYcmjK61wErk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHWMxgobP1/ExOCf/8U6i0e1gW1UnczB2d+1qdEiPuNENnRSUZPidsu/MF3iSEWSw
	 zUHemZFJVypWgcX6GWcWzZdTJIQwhJ7/cPoOBT5uCKDQ5C2lEFBMkLB5G7Hx50fDHt
	 ASskvpqJE1GqfOl1vL/T7hGTM8a2YXtiOo9lqqXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 510/547] HID: hid-lenovo-go-s: Add suspend function and gate access under bool.
Date: Wed,  4 Nov 2026 16:11:34 -0500
Message-ID: <20261104211052.876177158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek J. Clark <derekjohn.clark@gmail.com>

commit e69b64d3d75eb10177f75d3d4947e032cb46eeb9 upstream.

Currently a device can suspend while delayed work is pending or
executing. Cancel delayed work if it was pending and restart it if it
hasn't run yet. Gate access to show/store functions behind a bool to
prevent access prior to cfg_setup() being completed.

Fixes: a23f3497bf208c59ad ("HID: hid-lenovo-go-s: Add Lenovo Legion Go S Series HID Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go-s.c |  149 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 149 insertions(+)

--- a/drivers/hid/hid-lenovo-go-s.c
+++ b/drivers/hid/hid-lenovo-go-s.c
@@ -38,6 +38,8 @@ static struct hid_gos_cfg {
 	struct led_classdev *led_cdev;
 	struct hid_device *hdev;
 	struct mutex cfg_mutex; /*ensure single synchronous output report*/
+	bool gp_registered;
+	bool rgb_registered;
 	int cmd_status;
 	u8 gp_auto_sleep_time;
 	u8 gp_dpad_mode;
@@ -488,10 +490,22 @@ static ssize_t gamepad_property_store(st
 				      const char *buf, size_t count,
 				      enum feature_status_index index)
 {
+	bool dev_registered;
 	size_t size = 1;
 	u8 val = 0;
 	int ret;
 
+	/* rgb_enabled is attached to led_classdev, not hid_device */
+	if (index == FEATURE_RGB_ENABLE)
+		/* Pairs with smp_store_release from gos_cfg_setup */
+		dev_registered = smp_load_acquire(&drvdata.rgb_registered);
+	else
+		/* Pairs with smp_store_release from gos_cfg_setup */
+		dev_registered = smp_load_acquire(&drvdata.gp_registered);
+
+	if (!dev_registered)
+		return -ENODEV;
+
 	switch (index) {
 	case FEATURE_GAMEPAD_MODE:
 		ret = sysfs_match_string(gamepad_mode_text, buf);
@@ -572,9 +586,21 @@ static ssize_t gamepad_property_show(str
 				     struct device_attribute *attr, char *buf,
 				     enum feature_status_index index)
 {
+	bool dev_registered;
 	ssize_t count = 0;
 	u8 i;
 
+	/* rgb_enabled is attached to led_classdev, not hid_device */
+	if (index == FEATURE_RGB_ENABLE)
+		/* Pairs with smp_store_release from gos_cfg_setup */
+		dev_registered = smp_load_acquire(&drvdata.rgb_registered);
+	else
+		/* Pairs with smp_store_release from gos_cfg_setup */
+		dev_registered = smp_load_acquire(&drvdata.gp_registered);
+
+	if (!dev_registered)
+		return -ENODEV;
+
 	count = mcu_property_out(drvdata.hdev, GET_GAMEPAD_CFG, index, NULL, 0);
 	if (count < 0)
 		return count;
@@ -710,10 +736,16 @@ static ssize_t touchpad_property_store(s
 				       const char *buf, size_t count,
 				       enum touchpad_config_index index)
 {
+	bool gp_registered;
 	size_t size = 1;
 	u8 val = 0;
 	int ret;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	gp_registered = smp_load_acquire(&drvdata.gp_registered);
+	if (!gp_registered)
+		return -ENODEV;
+
 	switch (index) {
 	case CFG_WINDOWS_MODE:
 		ret = sysfs_match_string(touchpad_mode_text, buf);
@@ -744,9 +776,15 @@ static ssize_t touchpad_property_show(st
 				      struct device_attribute *attr, char *buf,
 				      enum touchpad_config_index index)
 {
+	bool gp_registered;
 	int ret = 0;
 	u8 i;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	gp_registered = smp_load_acquire(&drvdata.gp_registered);
+	if (!gp_registered)
+		return -ENODEV;
+
 	ret = mcu_property_out(drvdata.hdev, GET_TP_PARAM, index, NULL, 0);
 	if (ret < 0)
 		return ret;
@@ -773,9 +811,15 @@ static ssize_t touchpad_property_options
 					 char *buf,
 					 enum touchpad_config_index index)
 {
+	bool gp_registered;
 	size_t count = 0;
 	unsigned int i;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	gp_registered = smp_load_acquire(&drvdata.gp_registered);
+	if (!gp_registered)
+		return -ENODEV;
+
 	switch (index) {
 	case CFG_WINDOWS_MODE:
 	case CFG_LINUX_MODE:
@@ -798,9 +842,15 @@ static ssize_t test_property_show(struct
 				  struct device_attribute *attr, char *buf,
 				  enum test_command_index index)
 {
+	bool gp_registered;
 	size_t count = 0;
 	u8 i;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	gp_registered = smp_load_acquire(&drvdata.gp_registered);
+	if (!gp_registered)
+		return -ENODEV;
+
 	switch (index) {
 	case TEST_TP_MFR:
 		i = drvdata.tp_manufacturer;
@@ -858,9 +908,15 @@ static ssize_t rgb_effect_store(struct d
 {
 	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(drvdata.led_cdev);
 	enum rgb_config_index index;
+	bool rgb_registered;
 	u8 effect;
 	int ret;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!rgb_registered)
+		return -ENODEV;
+
 	ret = sysfs_match_string(rgb_effect_text, buf);
 	if (ret < 0)
 		return ret;
@@ -885,8 +941,14 @@ static ssize_t rgb_effect_store(struct d
 static ssize_t rgb_effect_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
+	bool rgb_registered;
 	int ret;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!rgb_registered)
+		return -ENODEV;
+
 	ret = rgb_attr_show();
 	if (ret)
 		return ret;
@@ -918,9 +980,15 @@ static ssize_t rgb_speed_store(struct de
 {
 	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(drvdata.led_cdev);
 	enum rgb_config_index index;
+	bool rgb_registered;
 	int val = 0;
 	int ret;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!rgb_registered)
+		return -ENODEV;
+
 	ret = kstrtoint(buf, 10, &val);
 	if (ret)
 		return ret;
@@ -948,8 +1016,14 @@ static ssize_t rgb_speed_store(struct de
 static ssize_t rgb_speed_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
+	bool rgb_registered;
 	int ret;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!rgb_registered)
+		return -ENODEV;
+
 	ret = rgb_attr_show();
 	if (ret)
 		return ret;
@@ -969,9 +1043,15 @@ static ssize_t rgb_speed_range_show(stru
 static ssize_t rgb_mode_store(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
+	bool rgb_registered;
 	int ret;
 	u8 val;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!rgb_registered)
+		return -ENODEV;
+
 	ret = sysfs_match_string(rgb_mode_text, buf);
 	if (ret <= 0)
 		return ret;
@@ -991,8 +1071,14 @@ static ssize_t rgb_mode_store(struct dev
 static ssize_t rgb_mode_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
+	bool rgb_registered;
 	int ret;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!rgb_registered)
+		return -ENODEV;
+
 	ret = rgb_cfg_call(drvdata.hdev, GET_RGB_CFG, LIGHT_MODE_SEL, NULL, 0);
 	if (ret)
 		return ret;
@@ -1022,10 +1108,16 @@ static ssize_t rgb_profile_store(struct
 				 struct device_attribute *attr, const char *buf,
 				 size_t count)
 {
+	bool rgb_registered;
 	size_t size = 1;
 	int ret;
 	u8 val;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!rgb_registered)
+		return -ENODEV;
+
 	ret = kstrtou8(buf, 10, &val);
 	if (ret < 0)
 		return ret;
@@ -1045,8 +1137,14 @@ static ssize_t rgb_profile_store(struct
 static ssize_t rgb_profile_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
+	bool rgb_registered;
 	int ret;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!rgb_registered)
+		return -ENODEV;
+
 	ret = rgb_cfg_call(drvdata.hdev, GET_RGB_CFG, LIGHT_PROFILE_SEL, NULL, 0);
 	if (ret)
 		return ret;
@@ -1068,8 +1166,14 @@ static void hid_gos_brightness_set(struc
 {
 	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(drvdata.led_cdev);
 	enum rgb_config_index index;
+	bool rgb_registered;
 	int ret;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!rgb_registered)
+		return;
+
 	if (brightness > led_cdev->max_brightness) {
 		dev_err(led_cdev->dev, "Invalid argument\n");
 		return;
@@ -1376,6 +1480,11 @@ static void cfg_setup(struct work_struct
 			"Failed to retrieve OS Mode: %i\n", ret);
 		return;
 	}
+
+	/* Pairs with smp_load_acquire in attribute show/store functions */
+	smp_store_release(&drvdata.gp_registered, true);
+	/* Pairs with smp_load_acquire in attribute show/store functions */
+	smp_store_release(&drvdata.rgb_registered, true);
 }
 
 static int hid_gos_cfg_probe(struct hid_device *hdev,
@@ -1435,9 +1544,24 @@ static void hid_gos_cfg_remove(struct hi
 
 static int hid_gos_cfg_reset_resume(struct hid_device *hdev)
 {
+	bool gp_registered, rgb_registered;
 	u8 os_mode = drvdata.os_mode;
 	int ret;
 
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	gp_registered = smp_load_acquire(&drvdata.gp_registered);
+	/* Pairs with smp_store_release from gos_cfg_setup */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (!gp_registered || !rgb_registered) {
+		ret = schedule_delayed_work(&drvdata.gos_cfg_setup, msecs_to_jiffies(2));
+		if (!ret) {
+			dev_err(&hdev->dev, "Failed to schedule startup delayed work\n");
+			return -ENODEV;
+		}
+
+		return 0;
+	}
+
 	ret = mcu_property_out(drvdata.hdev, SET_GAMEPAD_CFG,
 			       FEATURE_OS_MODE, &os_mode, 1);
 	if (ret < 0)
@@ -1525,6 +1649,30 @@ static int hid_gos_reset_resume(struct h
 	return 0;
 }
 
+static int hid_gos_cfg_suspend(void)
+{
+	disable_delayed_work_sync(&drvdata.gos_cfg_setup);
+
+	return 0;
+}
+
+static int hid_gos_suspend(struct hid_device *hdev, pm_message_t msg)
+{
+	int ret;
+	u8 ep;
+
+	/* Safe assumption. SET_INTERFACE ioctl can't be used while driver is bound */
+	ret = get_endpoint_address(hdev);
+	if (ret <= 0)
+		return 0;
+
+	ep = ret;
+	if (ep == GO_S_CFG_INTF_IN)
+		return hid_gos_cfg_suspend();
+
+	return 0;
+}
+
 static const struct hid_device_id hid_gos_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QHE,
 			 USB_DEVICE_ID_LENOVO_LEGION_GO_S_XINPUT) },
@@ -1541,6 +1689,7 @@ static struct hid_driver hid_lenovo_go_s
 	.remove = hid_gos_remove,
 	.raw_event = hid_gos_raw_event,
 	.reset_resume = pm_ptr(hid_gos_reset_resume),
+	.suspend = pm_ptr(hid_gos_suspend),
 };
 module_hid_driver(hid_lenovo_go_s);
 


