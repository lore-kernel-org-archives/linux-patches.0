Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827116;
	b=UveKIKkIQtN/xELk98ucW1+ByZi6WvcMlq0cC8jq3jgs4uh6LnmjUHXEx4qJtP9qgOoQ
	 6I9cP7qM2wVfcyOOxfvj/ll+za8HsY/fGbK/iUAQ/9dg5eC7CaScOpAGyDY8lAnYmJGtq
	 CXd0ExMJNKXbZgCmCywNBdv3LOGbeUrD3z+d7d7nQofRiUi64YnmbpE9shxvt8suUOjow
	 lntnixCP41x4cVk1pFPGd6HWZ8dfuQZ6pI/pNZ+c69r4QuvwNVT96K3lrjVr+0ryqs9Mp
	 v/adYHbxFDOaroppGYQCUBYfzlT5RPmbtmGWiwGZypCeQ4wagLJ+Nl51b1xps3oKT4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h7wgtjjJaCdUpKlEytTaBWCu5szkx81/yu21wToqn6M=;
	b=Yni77sHkOe2LOHduUt6/rdLdnzoO0azM8Kz+MLkg2JznOiabwvDQOUCS6rsre1r5tMua
	 muuaOKQBZ2LFccDYn8/NniDo0VpEP0gl1rhAEyswLNwOOF+3QBZ3gHrqCi6sVNu0ri176
	 ga08SQEgutRj8YVuzDNehGFU4L4awndhg6ZuEomD7gv3R47DlcSWwl7CAoDjG6gaaHrcb
	 z4Spfo+cZyeOMqIMzL+tX2Kt97D1dtS87s6XcbiCosVUPlb6LPe9+pwtGWM4Z1HE5cw9d
	 4gaUxOKp5l7t75EP8+UB1yBOrhVF/Ru5V/vBWYh1MXXYUthlomBtEigrvETixuj+ndQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LtAfCz5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE95606A847;
	Wed,  4 Nov 2026 21:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LtAfCz5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6EE1F00919;
	Wed,  4 Nov 2026 21:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827115;
	bh=h7wgtjjJaCdUpKlEytTaBWCu5szkx81/yu21wToqn6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtAfCz5JCXXN7E2VnwFyr6uQsyzkWt4WFolYmbZNT5qtoMHNvN62twf9DxEcjJd0H
	 m5V7NcvDXjh8drWWRBBFXoUfgsv+hly0BG6W95Ev/HfyEwXMX9tS2EjLvaQg2VFDzI
	 CEatsDL6yekNcrIYIV3EPw3Jgcy2pTpwGlQVpS3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 183/547] HID: wacom: Use hdev->product in wacom_setup_touch_input_capabilities
Date: Wed,  4 Nov 2026 16:06:07 -0500
Message-ID: <20261104211043.346067335@linuxfoundation.org>
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
@@ -3966,8 +3966,8 @@ int wacom_setup_pen_input_capabilities(s
 int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 					 struct wacom_wac *wacom_wac)
 {
+	struct hid_device *hdev = container_of(wacom_wac, struct wacom, wacom_wac)->hdev;
 	struct wacom_features *features = &wacom_wac->features;
-
 	if (!(features->device_type & WACOM_DEVICETYPE_TOUCH))
 		return -ENODEV;
 
@@ -3976,9 +3976,11 @@ int wacom_setup_touch_input_capabilities
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
@@ -4010,19 +4012,17 @@ int wacom_setup_touch_input_capabilities
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
@@ -4052,8 +4052,8 @@ int wacom_setup_touch_input_capabilities
 		fallthrough;
 
 	case WACOM_27QHDT:
-		if (wacom_wac->shared->touch->product == 0x32C ||
-		    wacom_wac->shared->touch->product == 0xF6) {
+		if (hdev->product == 0x32C ||
+		    hdev->product == 0xF6) {
 			input_dev->evbit[0] |= BIT_MASK(EV_SW);
 			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
 			wacom_wac->has_mute_touch_switch = true;


