Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057774;
	b=EkpjJ5yZpTMAvRUHzC735rgd2ewH2wrkw/CAWYfvKqxXYoPQFxrTYhxOTm+iGMkbt5cG
	 akYXVtRMBWfwBwg+r9rf+13kseJ3vNZIKCrel+qfFj3q6jo7i8TCaBP+P/4IybEOD+wo1
	 s2jO0DKBlHyGLWgZfNn5O/h3u+jWkSVMmH5m9Nh6dg2cEM2YgcfXHJ0iswNpMiDNCbh1W
	 BKM5A3pMpvt+vDB6vSz/dKc7zZchrmoH7/tb/FsBO0bz7qyjExAnmXigjzw925PXFqL5J
	 YcgHWyTTeM+tOpDorubgN+/9VSU37J1Frik+F8RjGKVFb2adeei9vZ/C8roLf/GTUAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7vFPGkvdm8A/lCIlpjr4Vn8pgm86eC2WenojkdOfRUM=;
	b=M8X9Y7bpJTwrqonl0OyVrLyHsiNGXLgRXmFOiJYlC8yZveIhYjRmoHKRTkhTIzCI0oVv
	 6wupA4u32ch7FyXbsXgNJjpAkbCTAOIpPDcUyvy+OQ8WjYzZ6GWYlz32g8lz/7IJbrjqD
	 u31DowXxNDB74Nx/RNbQ3W+ZSS/AHsmLEzKcaZlUAVSXNcOQ4gxu4Evip+ArkvIg+M7nV
	 85mvotnkRpeHaVNumlIu/COMcWqfyIDk/5rI0ytKhQrubQf/BzIdRCR3GPwZpxv2UXTG4
	 SazIli5iHyqw6Ch/bW/HVBWRQSpkkZrBoMzebnXEs/urnT9d0RZU73zVDaufjUUJPvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yD5bhQ1h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FE2606A320;
	Thu, 19 Nov 2026 03:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yD5bhQ1h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338191F000C4;
	Thu, 19 Nov 2026 03:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057774;
	bh=7vFPGkvdm8A/lCIlpjr4Vn8pgm86eC2WenojkdOfRUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yD5bhQ1hbzVcZ3pbneykTD0LrMXfKVxzo/bI0eTlIcsvkwR854HHemB32YGertQ1D
	 TifOMqznX3hTapWkJh6GYqbaG03yTQ6RDnKb7cypCXrsg4RfWM/MYu8mXsk6QkQm9l
	 TDYexL8yEvGKJo+M/yy3McCt80mzcSsrGvkg25u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 0248/1848] HID: wacom: Use hdev->product in wacom_setup_touch_input_capabilities
Date: Wed, 18 Nov 2026 15:38:06 +0100
Message-ID: <20261118145922.342318044@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

commit 86472508a7ef74b525e79a79d2d02d911a641d6b upstream.

Replace the lookup-dependent 'wacom_wac->shared->touch->product' references
with 'hdev->product' inside wacom_setup_touch_input_capabilities() since
'hdev' is already available (via container_of) and represents the touch
device itself.

Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Ping Cheng <ping.cheng@wacom.com>
Tested-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3870,8 +3870,8 @@ int wacom_setup_pen_input_capabilities(s
 int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 					 struct wacom_wac *wacom_wac)
 {
+	struct hid_device *hdev = container_of(wacom_wac, struct wacom, wacom_wac)->hdev;
 	struct wacom_features *features = &wacom_wac->features;
-
 	if (!(features->device_type & WACOM_DEVICETYPE_TOUCH))
 		return -ENODEV;
 
@@ -3880,9 +3880,11 @@ int wacom_setup_touch_input_capabilities
 	else
 		__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
 
-	if (features->type == HID_GENERIC)
+	if (features->type == HID_GENERIC) {
+		hid_dbg(hdev, "generic touch setup\n");
 		/* setup has already been done */
 		return 0;
+	}
 
 	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
@@ -3914,19 +3916,17 @@ int wacom_setup_touch_input_capabilities
 		input_dev->evbit[0] |= BIT_MASK(EV_SW);
 		__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
 
-		if (wacom_wac->shared->touch->product == 0x361) {
+		if (hdev->product == 0x361) {
 			input_set_abs_params(input_dev, ABS_MT_POSITION_X,
 					     0, 12440, 4, 0);
 			input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
 					     0, 8640, 4, 0);
-		}
-		else if (wacom_wac->shared->touch->product == 0x360) {
+		} else if (hdev->product == 0x360) {
 			input_set_abs_params(input_dev, ABS_MT_POSITION_X,
 					     0, 8960, 4, 0);
 			input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
 					     0, 5920, 4, 0);
-		}
-		else if (wacom_wac->shared->touch->product == 0x393) {
+		} else if (hdev->product == 0x393) {
 			input_set_abs_params(input_dev, ABS_MT_POSITION_X,
 					     0, 6400, 4, 0);
 			input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
@@ -3956,8 +3956,8 @@ int wacom_setup_touch_input_capabilities
 		fallthrough;
 
 	case WACOM_27QHDT:
-		if (wacom_wac->shared->touch->product == 0x32C ||
-		    wacom_wac->shared->touch->product == 0xF6) {
+		if (hdev->product == 0x32C ||
+		    hdev->product == 0xF6) {
 			input_dev->evbit[0] |= BIT_MASK(EV_SW);
 			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
 			wacom_wac->has_mute_touch_switch = true;


