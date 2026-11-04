Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829219;
	b=KeXagr4nXej9VEzI8g7DipizZXvSX+TwBs8QeTAI93bWfA7qpHF5ASCLuMFzNzyp4H/t
	 x3J+0LPlig3tqkszRbthoa4/Fqvp1C/QCE7z+csiZrrteLN85uhxYwzHi9qYsDL2ZKAY8
	 y/oC00jH6NmRSdCzJJ/V8ycXa67v7hwI6kEp7v+8M14rn6SZPG36+27PCIMciVeGdX53n
	 AVRrc+jR/1LQ/ZQAd01AcWr/fTgv1UJeQ3sj07U0FwBwcJ+VLqkrUHA4jjWP9JcwK5Oe5
	 cmwizXRZc8AJbhdD1yynykjY08ngcI/blLImdLM/Zq7qlTFKWPs5yv7yXErbKIjkwMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XL24dsEdbAbAzMc9DsToD1vrWxwC3niRjff7Gw9QvbU=;
	b=G9qkYCASZ6l/alUP1bR25l2dgqI9Uq2z9zRrKq+BJkoQhxwxsevWbPp8RPdxDoOgoK5i
	 ppVbdK9jZjLvCHNlGVWgKKoaTQrWloIv7I9tEbVAnEK+4KACZdXk3LXTVHR7ckhLckV3j
	 hNdEqogdKV82fQj0AIP2wj01pq6Zh3DaEzMa3NDW2Xfh9gEjcr4TIUP1idbH2eNUhZY1A
	 jewv1jH/4LnzaAv4XyHsVQl9ToL8GWkTEHlcVQD13S/qvJMoqf8tWEDLeRWnMLWiMGRhL
	 QiwcDVI7Dggwg6z6F+bhzHodGbQyBYBq2mUf3tpcGShVOtthWCK0UQVyMK+Nh5B3x4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFDEm523;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22FB6070323;
	Wed,  4 Nov 2026 21:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFDEm523
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485E31F00919;
	Wed,  4 Nov 2026 21:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829218;
	bh=XL24dsEdbAbAzMc9DsToD1vrWxwC3niRjff7Gw9QvbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFDEm523T+7papHk2NaDxrG5B8zz56nOWAl5Yxmmid+sMIrGFEIzPWdFCPCWcanfg
	 QsFUlyOGHFBJszpOr/cSKTVlSN4NuQjwAf4ade+Gk5O0Nrq+xsbEUPVuP8tQvm4V8x
	 A8MbHZnVwGAhzW4utlSUcL9bTVQKCrCnYLpeC4Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 515/547] HID: hid-lenovo-go-s: Move static led_classdev_mc to drvdata struct
Date: Wed,  4 Nov 2026 16:11:39 -0500
Message-ID: <20261104211053.026403128@linuxfoundation.org>
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

commit 7a5673e5f0f71cfe4004c1f1c3112cd1ea8ae1d9 upstream.

In the next patch I will switch drvdata from static global to a
devm_kzalloc struct. In preparation for that, move the led_classdev_mc
to be a member of the gos_cfg_drvdata struct. As part of that effort,
provide a constant name when accessing it and access the led_classdev
through the led_classdev_mc.

Fixes: be6d7dbb368ba840d7 ("HID: hid-lenovo-go-s: Add RGB LED control interface")
Cc: stable@vger.kernel.org
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go-s.c | 73 +++++++++++++++++------------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/hid/hid-lenovo-go-s.c b/drivers/hid/hid-lenovo-go-s.c
index e5c4104a3adb..c77c297a04cb 100644
--- a/drivers/hid/hid-lenovo-go-s.c
+++ b/drivers/hid/hid-lenovo-go-s.c
@@ -60,7 +60,7 @@ static struct gos_cfg_drvdata {
 	u8 tp_en;
 
 	/* RGB Variables */
-	struct led_classdev *led_cdev;
+	struct led_classdev_mc led_mc;
 	bool rgb_registered;
 	u8 rgb_profile;
 	u8 rgb_effect;
@@ -347,7 +347,7 @@ static int hid_gos_pl_test_event(struct command_report *cmd_rep)
 
 static int hid_gos_light_event(struct command_report *cmd_rep)
 {
-	struct led_classdev_mc *mc_cdev;
+	struct led_classdev_mc *led_mc;
 	int ret = 0;
 
 	switch (cmd_rep->sub_cmd) {
@@ -362,12 +362,12 @@ static int hid_gos_light_event(struct command_report *cmd_rep)
 	case USR_LIGHT_PROFILE_1:
 	case USR_LIGHT_PROFILE_2:
 	case USR_LIGHT_PROFILE_3:
-		mc_cdev = lcdev_to_mccdev(drvdata.led_cdev);
+		led_mc = &drvdata.led_mc;
 		drvdata.rgb_effect = cmd_rep->data[0];
-		mc_cdev->subled_info[0].intensity = cmd_rep->data[1];
-		mc_cdev->subled_info[1].intensity = cmd_rep->data[2];
-		mc_cdev->subled_info[2].intensity = cmd_rep->data[3];
-		drvdata.led_cdev->brightness = cmd_rep->data[4];
+		led_mc->subled_info[0].intensity = cmd_rep->data[1];
+		led_mc->subled_info[1].intensity = cmd_rep->data[2];
+		led_mc->subled_info[2].intensity = cmd_rep->data[3];
+		led_mc->led_cdev.brightness = cmd_rep->data[4];
 		drvdata.rgb_speed = cmd_rep->data[5];
 		ret = 0;
 		break;
@@ -927,7 +927,7 @@ static ssize_t rgb_effect_store(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
 {
-	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(drvdata.led_cdev);
+	struct led_classdev_mc *led_mc = &drvdata.led_mc;
 	enum rgb_config_index index;
 	bool rgb_registered;
 	u8 effect;
@@ -945,10 +945,10 @@ static ssize_t rgb_effect_store(struct device *dev,
 	effect = ret;
 	index = drvdata.rgb_profile + 2;
 	u8 rgb_profile[6] = { effect,
-			      mc_cdev->subled_info[0].intensity,
-			      mc_cdev->subled_info[1].intensity,
-			      mc_cdev->subled_info[2].intensity,
-			      drvdata.led_cdev->brightness,
+			      led_mc->subled_info[0].intensity,
+			      led_mc->subled_info[1].intensity,
+			      led_mc->subled_info[2].intensity,
+			      led_mc->led_cdev.brightness,
 			      drvdata.rgb_speed };
 
 	ret = rgb_cfg_call(drvdata.hdev, SET_RGB_CFG, index, rgb_profile, 6);
@@ -999,7 +999,7 @@ static ssize_t rgb_speed_store(struct device *dev,
 			       struct device_attribute *attr, const char *buf,
 			       size_t count)
 {
-	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(drvdata.led_cdev);
+	struct led_classdev_mc *led_mc = &drvdata.led_mc;
 	enum rgb_config_index index;
 	bool rgb_registered;
 	int val = 0;
@@ -1019,10 +1019,10 @@ static ssize_t rgb_speed_store(struct device *dev,
 
 	index = drvdata.rgb_profile + 2;
 	u8 rgb_profile[6] = { drvdata.rgb_effect,
-			      mc_cdev->subled_info[0].intensity,
-			      mc_cdev->subled_info[1].intensity,
-			      mc_cdev->subled_info[2].intensity,
-			      drvdata.led_cdev->brightness,
+			      led_mc->subled_info[0].intensity,
+			      led_mc->subled_info[1].intensity,
+			      led_mc->subled_info[2].intensity,
+			      led_mc->led_cdev.brightness,
 			      val };
 
 	ret = rgb_cfg_call(drvdata.hdev, SET_RGB_CFG, index, rgb_profile, 6);
@@ -1185,7 +1185,7 @@ static ssize_t rgb_profile_range_show(struct device *dev,
 static void hid_gos_brightness_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
 {
-	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(drvdata.led_cdev);
+	struct led_classdev_mc *led_mc = &drvdata.led_mc;
 	enum rgb_config_index index;
 	bool rgb_registered;
 	int ret;
@@ -1202,9 +1202,9 @@ static void hid_gos_brightness_set(struct led_classdev *led_cdev,
 
 	index = drvdata.rgb_profile + 2;
 	u8 rgb_profile[6] = { drvdata.rgb_effect,
-			      mc_cdev->subled_info[0].intensity,
-			      mc_cdev->subled_info[1].intensity,
-			      mc_cdev->subled_info[2].intensity,
+			      led_mc->subled_info[0].intensity,
+			      led_mc->subled_info[1].intensity,
+			      led_mc->subled_info[2].intensity,
 			      brightness,
 			      drvdata.rgb_speed };
 
@@ -1444,17 +1444,6 @@ static struct mc_subled gos_rgb_subled_info[] = {
 	},
 };
 
-static struct led_classdev_mc gos_cdev_rgb = {
-	.led_cdev = {
-		.name = "go_s:rgb:joystick_rings",
-		.brightness = 0x50,
-		.max_brightness = 0x64,
-		.brightness_set = hid_gos_brightness_set,
-	},
-	.num_colors = ARRAY_SIZE(gos_rgb_subled_info),
-	.subled_info = gos_rgb_subled_info,
-};
-
 static void cfg_setup(struct work_struct *work)
 {
 	bool gp_registered, rgb_registered;
@@ -1525,22 +1514,20 @@ static void cfg_setup(struct work_struct *work)
 	if (rgb_registered)
 		goto update_kobjects;
 
-	ret = devm_led_classdev_multicolor_register(&drvdata.hdev->dev, &gos_cdev_rgb);
+	ret = devm_led_classdev_multicolor_register(&drvdata.hdev->dev, &drvdata.led_mc);
 	if (ret) {
 		dev_err(&drvdata.hdev->dev,
 			"Failed to create RGB device: %i\n", ret);
 		goto update_kobjects;
 	}
 
-	ret = devm_device_add_group(gos_cdev_rgb.led_cdev.dev, &rgb_attr_group);
+	ret = devm_device_add_group(drvdata.led_mc.led_cdev.dev, &rgb_attr_group);
 	if (ret) {
 		dev_err(&drvdata.hdev->dev,
 			"Failed to create RGB configuration attributes: %i\n", ret);
 		goto update_kobjects;
 	}
 
-	drvdata.led_cdev = &gos_cdev_rgb.led_cdev;
-
 	/* Pairs with smp_load_acquire in attribute show/store functions */
 	smp_store_release(&drvdata.rgb_registered, true);
 	rgb_registered = true;
@@ -1549,7 +1536,7 @@ static void cfg_setup(struct work_struct *work)
 	if (gp_registered)
 		kobject_uevent(&drvdata.hdev->dev.kobj, KOBJ_CHANGE);
 	if (rgb_registered)
-		kobject_uevent(&drvdata.led_cdev->dev->kobj, KOBJ_CHANGE);
+		kobject_uevent(&drvdata.led_mc.led_cdev.dev->kobj, KOBJ_CHANGE);
 }
 
 static int hid_gos_cfg_probe(struct hid_device *hdev,
@@ -1563,6 +1550,18 @@ static int hid_gos_cfg_probe(struct hid_device *hdev,
 	mutex_init(&drvdata.cfg_mutex);
 	init_completion(&drvdata.send_cmd_complete);
 
+	/* Device is hardwired and name is guaranteed to be unique */
+	drvdata.led_mc.led_cdev.name = "go_s:rgb:joystick_rings";
+	drvdata.led_mc.led_cdev.brightness = 0x50;
+	drvdata.led_mc.led_cdev.max_brightness = 0x64;
+	drvdata.led_mc.led_cdev.color = LED_COLOR_ID_RGB;
+	drvdata.led_mc.led_cdev.brightness_set = hid_gos_brightness_set;
+	drvdata.led_mc.num_colors = 3;
+	drvdata.led_mc.subled_info = devm_kmemdup(&hdev->dev, gos_rgb_subled_info,
+						  sizeof(gos_rgb_subled_info), GFP_KERNEL);
+	if (!drvdata.led_mc.subled_info)
+		return -ENOMEM;
+
 	/* Executing calls prior to returning from probe will lock the MCU. Schedule
 	 * initial data call after probe has completed and MCU can accept calls.
 	 */
-- 
2.56.0



