Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051711;
	b=gR7ys/ym1W3bF1v3gRP09JjbzniucXFaM584iQgYkOHNXLguIDAV+FICUogvix/HNpxD
	 Tlt1PU+Y8p4CfqZd28pgX30GowMzcYtH8QBAa6evjhhaKUoqtHQtBQh8NX6ocWG+QCvHC
	 QPnm5YQfNJKQHY5qXhXNlJk2z+oM8w7eYbjf1YF11CFLqSMToncqDrv8yJNzGb/ZjwT4K
	 s91lPlRaHq4tWiaDuylUuFpCJdfc3cpnEFdiHHvCkvp+gOyUHhNKRG8Cc7GRTRhnvbL6R
	 QifLzm+nMSn0D0I8DD6OQGoWHYxgI9ax+h0xDR+wEV8/Xh7v8F5BGcqr5TnDMYZsnEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cRFqPjI1VM2a73gXZXh0sS7fJVk4WIzpmUEgfyj7DTo=;
	b=jXJ2r6KEM15VGObCuV0DGI1Q69weoHOERZ+B/OWYLI0paGCbDSmbif2aop9DCcdCISxS
	 b1pLzr+FdyJNDCvDf40u3VRxkGdSqY/0NBklhYaJ3c8iwgFlkaJtfj6lXC2yrts05ATCe
	 qS+r13pEZq35XMmlpAZ0CGevMZdLwk+h4q4iRQNHbh0UYPWsyyum002nGTsYkV2J3ibsb
	 u/GQTAHhy16vbhYE6xTCvPfJ7Z4uIKP5IUu7UnlO5GzAznBinyJ3XvOo9nQMv/bUOFf+K
	 fbmpdnz0PPOsH18Qv9KGK18984/nuttLe9zhFLgfBqRurpn4rDWH9UmCdQYrbehI4Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0EeDx/YQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE01606A31C;
	Thu, 19 Nov 2026 01:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EeDx/YQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3DA1F000C4;
	Thu, 19 Nov 2026 01:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051711;
	bh=cRFqPjI1VM2a73gXZXh0sS7fJVk4WIzpmUEgfyj7DTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EeDx/YQC4PgScTFM+26O4kpbz9ZqpKPFtyZ9WmhxJnSq392tyXJDDBnRpR1Q2cmd
	 jBjbMn6CkkhZjgvCqdrWwOEopHraheXIgwH3NEKEACVje/YBBLf7KrRdSVoNwRLBXY
	 VDP3VaovrZTFl090BqxJvj1UkzA9x7AYo4eMewF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0303/2214] HID: wacom: Use hdev->product in wacom_setup_touch_input_capabilities
Date: Wed, 18 Nov 2026 15:32:59 +0100
Message-ID: <20261118150022.302482470@linuxfoundation.org>
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
@@ -3900,8 +3900,8 @@ int wacom_setup_pen_input_capabilities(s
 int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 					 struct wacom_wac *wacom_wac)
 {
+	struct hid_device *hdev = container_of(wacom_wac, struct wacom, wacom_wac)->hdev;
 	struct wacom_features *features = &wacom_wac->features;
-
 	if (!(features->device_type & WACOM_DEVICETYPE_TOUCH))
 		return -ENODEV;
 
@@ -3910,9 +3910,11 @@ int wacom_setup_touch_input_capabilities
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
@@ -3944,19 +3946,17 @@ int wacom_setup_touch_input_capabilities
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
@@ -3986,8 +3986,8 @@ int wacom_setup_touch_input_capabilities
 		fallthrough;
 
 	case WACOM_27QHDT:
-		if (wacom_wac->shared->touch->product == 0x32C ||
-		    wacom_wac->shared->touch->product == 0xF6) {
+		if (hdev->product == 0x32C ||
+		    hdev->product == 0xF6) {
 			input_dev->evbit[0] |= BIT_MASK(EV_SW);
 			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
 			wacom_wac->has_mute_touch_switch = true;


