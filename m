Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052056;
	b=ziO7nRMfeBCrcm+s345QCRmecHAQM49QrUlJ+fUbRvyvqplVoWwGOgIAmnRJW9cGawvO
	 8sXgIDcTwN4X6TMRmGgeZirhuxlIFh+0ge4sAvMQy1bEdD8wFpWdTBY3GyCXx9rCysEGI
	 RSQR2rmbIZ2WCHyTBOGQhLvgr1+MTHGauK9+0YGlejC6f0Knmk1LvG9lCvg/zi8JtHU54
	 N2VD9FH+F0PQj4aQMXN3mQ4Lqin08kWj8aqvyXc1PPB+ZIudo3HdHHiGrCJxQBb/oguTE
	 +rEk7KfBJL3lQUcCPY0XU5yMuBTkqiLb7h3MRuIrz0iAOfRvv/wsU0WSq473TL5PsuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0I6qQ+TyW9Tifrs3lK3vsdHjqrvSujRN/f7JI2lhGf0=;
	b=O5/dIt6FvA/NJVKLmkdv5de6Fidiuj/1YsXH0P3Z5Ahb+1/E4NhLh6J1fu6HJ9t88iZF
	 Zp8+dj1Y05T69Bnw+bH0WNLjTo277kkuT0R2qX0w5k5oSCHg7RLPv0Q8QC4ymMszN6Ms/
	 7O8ycIFFFxkdrRsi18/phiGQcU7ZTMno7Vv+FgdGNCs1fBCP+jS1rPS4t3w/vLz4/izQ2
	 Y05imfpIdq70o3bVajfTCtVyVOJeAgnPg1lxoza1U/x+WjAuX4Wdvq6N/TZQ4Xn95BHuq
	 brhkCuEqCi0nhJdQ4MjTXwsrl8WPO04L63Kp6GzaBkqBWp43sFCMAO05HSlAaKl5Gmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8pA0T7M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB05E606A31C;
	Thu, 19 Nov 2026 01:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8pA0T7M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AAE1F000C4;
	Thu, 19 Nov 2026 01:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052055;
	bh=0I6qQ+TyW9Tifrs3lK3vsdHjqrvSujRN/f7JI2lhGf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8pA0T7MiIc70a5By69ArHiBxQJPhSWV1HAUQpckpSSAdzUvQYEpD9mCbY7HKCJ1S
	 u0q2iF75wf5DTbO1DZzq9O3eKIQks+ciyrKP0enPQYLYKpMs0gMVBn6/cVhl9NXb2p
	 9bPUSjnkrSwtiYygjemkSRmB5aMWNln5rbtbPb7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0429/2214] HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration
Date: Wed, 18 Nov 2026 15:35:05 +0100
Message-ID: <20261118150028.043227737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit ba16e5ffbaa10fde960918d69af5e49f2b3fdd5e ]

Input subsystem guidelines require that device capabilities are advertised
before the input device is registered.  The Wacom driver was violating
this by advertising the SW_MUTE_DEVICE capability post-registration in
wacom_set_shared_values() (and duplicating it in device-specific setup
cases).

Resolve this by moving the SW_MUTE_DEVICE capability setup to
wacom_setup_touch_input_capabilities() for all touch devices that support
it.

For generic touch devices whose capabilities depend on mute switch
usages parsed from a sibling Pen/Pad interface, defer registration
with -EPROBE_DEFER until the sibling has parsed its descriptors and
initialized shared capabilities.

Cc: stable@vger.kernel.org
Fixes: d2ec58aee8b1 ("HID: wacom: generic: support generic touch switch")
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Ping Cheng <ping.cheng@wacom.com>
Tested-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ sashal: retained devm_add_action() with explicit failure cleanup instead of devm_add_action_or_reset() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_sys.c | 88 ++++++++++++++++++++++++++++++++++-------
 drivers/hid/wacom_wac.c |  5 +++
 2 files changed, 78 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 9f72b5c3ce95f..b6393a8065744 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -924,6 +924,9 @@ static int wacom_add_shared_data(struct hid_device *hdev)
 
 	wacom_wac->shared = &data->shared;
 
+	if (wacom_wac->has_mute_touch_switch)
+		WRITE_ONCE(wacom_wac->shared->has_mute_touch_switch, true);
+
 	retval = devm_add_action(&hdev->dev, wacom_remove_shared_data, wacom);
 	if (retval) {
 		mutex_unlock(&wacom_udev_list_lock);
@@ -931,11 +934,6 @@ static int wacom_add_shared_data(struct hid_device *hdev)
 		return retval;
 	}
 
-	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH)
-		wacom_wac->shared->touch = hdev;
-	else if (wacom_wac->features.device_type & WACOM_DEVICETYPE_PEN)
-		wacom_wac->shared->pen = hdev;
-
 out:
 	mutex_unlock(&wacom_udev_list_lock);
 	return retval;
@@ -2336,13 +2334,12 @@ static void wacom_release_resources(struct wacom *wacom)
 
 static void wacom_set_shared_values(struct wacom_wac *wacom_wac)
 {
-	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {
-		wacom_wac->shared->type = wacom_wac->features.type;
-		wacom_wac->shared->touch_input = wacom_wac->touch_input;
-	}
+	struct wacom *wacom = container_of(wacom_wac, struct wacom, wacom_wac);
+
+	guard(mutex)(&wacom_udev_list_lock);
 
 	if (wacom_wac->has_mute_touch_switch) {
-		wacom_wac->shared->has_mute_touch_switch = true;
+		WRITE_ONCE(wacom_wac->shared->has_mute_touch_switch, true);
 		/* Hardware touch switch may be off. Wait until
 		 * we know the switch state to decide is_touch_on.
 		 * Softkey state should be initialized to "on" to
@@ -2352,12 +2349,67 @@ static void wacom_set_shared_values(struct wacom_wac *wacom_wac)
 			WRITE_ONCE(wacom_wac->shared->is_touch_on, true);
 	}
 
-	if (wacom_wac->shared->has_mute_touch_switch &&
-	    wacom_wac->shared->touch_input) {
-		set_bit(EV_SW, wacom_wac->shared->touch_input->evbit);
-		input_set_capability(wacom_wac->shared->touch_input, EV_SW,
-				     SW_MUTE_DEVICE);
+	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {
+		wacom_wac->shared->type = wacom_wac->features.type;
+		wacom_wac->shared->touch_input = wacom_wac->touch_input;
+		wacom_wac->shared->touch = wacom->hdev;
+	} else if (wacom_wac->features.device_type & WACOM_DEVICETYPE_PEN) {
+		/* Pairs with smp_load_acquire() in wacom_sibling_pending() */
+		smp_store_release(&wacom_wac->shared->pen, wacom->hdev);
+	}
+}
+
+static bool wacom_sibling_pending(struct wacom *wacom)
+{
+	const struct wacom_features *features = &wacom->wacom_wac.features;
+	struct hid_device *hdev = wacom->hdev;
+	struct usb_interface *sibling_intf;
+	int ifnum;
+
+	if (features->type != HID_GENERIC ||
+	    !(features->device_type & WACOM_DEVICETYPE_TOUCH))
+		return false;
+
+	if (wacom->wacom_wac.shared) {
+		/* Pairs with smp_store_release() in wacom_set_shared_values() */
+		if (smp_load_acquire(&wacom->wacom_wac.shared->pen))
+			return false;
 	}
+
+	if (!hid_is_usb(hdev) || !wacom->usbdev || !wacom->intf ||
+	    !wacom->intf->cur_altsetting)
+		return false;
+
+	ifnum = wacom->intf->cur_altsetting->desc.bInterfaceNumber;
+
+	/*
+	 * On composite Wacom devices, the Pen interface is always interface 0.
+	 * If the Touch interface is interface 0, there is no sibling Pen
+	 * interface on this device (standalone touch device).
+	 */
+	if (ifnum == 0)
+		return false;
+
+	/* Look for the sibling Pen interface at interface 0 */
+	sibling_intf = usb_ifnum_to_if(wacom->usbdev, 0);
+	if (!sibling_intf || !sibling_intf->cur_altsetting)
+		return false;
+
+	if (sibling_intf->cur_altsetting->desc.bInterfaceClass !=
+	    USB_INTERFACE_CLASS_HID)
+		return false;
+
+	if (sibling_intf->cur_altsetting->desc.bInterfaceSubClass == 1 &&
+	    (sibling_intf->cur_altsetting->desc.bInterfaceProtocol == 1 ||
+	     sibling_intf->cur_altsetting->desc.bInterfaceProtocol == 2))
+		return false;
+
+	/*
+	 * Interface 0 is a candidate HID interface on this composite device
+	 * whose probe has not completed yet (shared->pen is NULL). Defer until
+	 * interface 0 finishes probing and registers shared values.
+	 */
+	return true;
 }
 
 static int wacom_parse_and_register(struct wacom *wacom, bool wireless)
@@ -2433,6 +2485,11 @@ static int wacom_parse_and_register(struct wacom *wacom, bool wireless)
 	if (error)
 		goto fail;
 
+	if (wacom_sibling_pending(wacom)) {
+		error = -EPROBE_DEFER;
+		goto fail;
+	}
+
 	if (!(features->device_type & WACOM_DEVICETYPE_WL_MONITOR) &&
 	     (features->quirks & WACOM_QUIRK_BATTERY)) {
 		error = wacom_initialize_battery(wacom);
@@ -2497,6 +2554,7 @@ static int wacom_parse_and_register(struct wacom *wacom, bool wireless)
 
 fail_hw_stop:
 	hid_hw_stop(hdev);
+	cancel_delayed_work_sync(&wacom->init_work);
 fail:
 	wacom_release_resources(wacom);
 	return error;
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 96164a97ff9cd..b1fd91aa5e370 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3912,6 +3912,11 @@ int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 
 	if (features->type == HID_GENERIC) {
 		hid_dbg(hdev, "generic touch setup\n");
+		if (wacom_wac->has_mute_touch_switch ||
+		    (wacom_wac->shared && READ_ONCE(wacom_wac->shared->has_mute_touch_switch))) {
+			input_set_capability(input_dev, EV_SW, SW_MUTE_DEVICE);
+			wacom_wac->has_mute_touch_switch = true;
+		}
 		/* setup has already been done */
 		return 0;
 	}
-- 
2.53.0



