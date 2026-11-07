Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061570;
	b=ptWJPi267OHdiXVqwXbRjIVlT2hHz+wAJaL5b0i2zOdKC4Ia6gZFS6O2Es/i9o4htSb3
	 o+g3GP1X4Te3X5s7pRX9YotQhg8ZlStEqcg3YRjSImKjtio7p3qfRq9ZQs9bmLMHQETzK
	 jES6NIu0HKWdGrHLQfDSGC85T8SOtPs6qDQA0aklQiE4PM1t9usR/RraanjxNr4CjKv0B
	 pbI9zEwwzKSnSJl2O1G6Fd4bknhzla/keAvPDB46+oxrK3hesyGFlH7M4lZhDK6u3r2uj
	 05LzFL5rz6jw6FU+lJkAIjbtfAQnYHmUx4CvH85gQ+W9L1A8AbKLGOtqFcrY1pqiqYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nodin/6a8HU/JRIWT9rFZ3eWwSRA5wAccSDfr+Rd90M=;
	b=hWfkw0mze32MNYnS0ne/uizsNfu4fr8aZNh8gg5UwfL7kqSRZSyrXgWEqkFbJbW0q+xu
	 n8mZRhJNwZV6aZiYVYgMYMhQIhGUtELTm5jYYPRmhvwsbQwGGoSuQGysiSPoGpnsZRyuG
	 UOOdQkzLVCuxIHtgrggb7zLcdicv3rAiofD+tDQ1O8obISC+FlRXlb6ZvsYfY3lb3pzih
	 PTPwgO50hIUbR0gF2ASduMJplyitGQHDbIytllIChSDogmUgCXNaw4SOzXJh6PnkOnopN
	 ECTRQNncNQEr6k8gh2WzubMzbJCBde+7wKlEbmDBiudIhMZmFEamhrs4iE8riawq5wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dj4JW3ET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BA1606A326;
	Sat,  7 Nov 2026 14:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dj4JW3ET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195411F0089F;
	Sat,  7 Nov 2026 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061570;
	bh=Nodin/6a8HU/JRIWT9rFZ3eWwSRA5wAccSDfr+Rd90M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dj4JW3ETNbfmUOmBAFEr/jahGWfjgNbvQzDQb/RmPv1UBN3Pk/HQznxrb6cathA6Z
	 oZ6A4KPQabxBdIcIGafzQ+V0rSKmak8yqjsMVzbCSomczxJd3kh35fM4T+jxJNkzmX
	 S1jUTNUqN7bcuVl1oBLKhVY4Qfl0oa+GlwbSynUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0622/1536] HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration
Date: Sat,  7 Nov 2026 08:43:58 -0500
Message-ID: <20261107135015.004190226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

commit ba16e5ffbaa10fde960918d69af5e49f2b3fdd5e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |   93 ++++++++++++++++++++++++++++++++++++++----------
 drivers/hid/wacom_wac.c |    5 ++
 2 files changed, 79 insertions(+), 19 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -895,19 +895,14 @@ static int wacom_add_shared_data(struct
 		list_add_tail(&data->list, &wacom_udev_list);
 	}
 
-	mutex_unlock(&wacom_udev_list_lock);
-
 	wacom_wac->shared = &data->shared;
 
-	retval = devm_add_action_or_reset(&hdev->dev, wacom_remove_shared_data, wacom);
-	if (retval)
-		return retval;
+	if (wacom_wac->has_mute_touch_switch)
+		WRITE_ONCE(wacom_wac->shared->has_mute_touch_switch, true);
 
-	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH)
-		wacom_wac->shared->touch = hdev;
-	else if (wacom_wac->features.device_type & WACOM_DEVICETYPE_PEN)
-		wacom_wac->shared->pen = hdev;
+	mutex_unlock(&wacom_udev_list_lock);
 
+	retval = devm_add_action_or_reset(&hdev->dev, wacom_remove_shared_data, wacom);
 	return retval;
 }
 
@@ -2319,13 +2314,12 @@ static void wacom_release_resources(stru
 
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
@@ -2335,12 +2329,67 @@ static void wacom_set_shared_values(stru
 			wacom_wac->shared->is_touch_on = true;
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
@@ -2416,6 +2465,11 @@ static int wacom_parse_and_register(stru
 	if (error)
 		goto fail;
 
+	if (wacom_sibling_pending(wacom)) {
+		error = -EPROBE_DEFER;
+		goto fail;
+	}
+
 	error = wacom_setup_inputs(wacom);
 	if (error)
 		goto fail;
@@ -2473,6 +2527,7 @@ static int wacom_parse_and_register(stru
 
 fail_hw_stop:
 	hid_hw_stop(hdev);
+	cancel_delayed_work_sync(&wacom->init_work);
 fail:
 	wacom_release_resources(wacom);
 	return error;
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3973,6 +3973,11 @@ int wacom_setup_touch_input_capabilities
 
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


