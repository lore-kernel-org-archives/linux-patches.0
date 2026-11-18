Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044375;
	b=erVUGfjuyMuOTdvdwVynrvFlA/s7UWR2PORnSrivUfIUnq+4AYrE5hOYfLQFVb2XfK/w
	 VgBigO2FOSfsxN41i8WF+7Yd36J5+vzZhBYQgEd9O4edYwpzwlsQSaGVeMjb5yesOulVD
	 JYQn1QIEmxDPgbrIpPhXR9bumVgyUnPa6DtEjJffegSpPuqO+Ed9E0JYTyBTRDKTQeFJh
	 T67AXHmdMqJ9Nlg5wy9jNawXNjE4V61mgwqfwY/pP8OypAjs2pWs4BxnOriZvV5xe8hdy
	 /p4wbXFU8JMyk/dJaz1QGRzdoWdg63mikHTV0+Enmb4nt1pNfN3AYaYrOGZP7rj447w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RWmtEm0UBXVWir2pX9KqqiWRxy9vGOrxb4B2rYbxALI=;
	b=Kg2yjytOV5KDZCFeW+pnLzVYKBdfwbDu9JFwKd0b+cmRGRxONHPvd+6YNS8s9/tj7096
	 gHjYrFZc/X/Xp28wKIg//Zj9cE5ubbG2oktR1yMw+5dkLM7x31PsNBdo7RBc13l5Ri9k6
	 Ro3u5B8LldVyEJpOUiCv+iJ8r3AEs8F/AJCLhlrleZDwYtSLXPaTTfZqc5u9gukHlFXqs
	 N8DLbnwd7z9eKGFslInVFyyoxpXJ9hq5IWVTmqbGTFelCNP1GLaP9ANji35du66DLWXIE
	 Aek3umYx/5EFIlws3wfCWGwBSSxh7NrAkXcIH4qcFlAT+xYZvUZe6QjV7fRYuELfUdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WdJLKwW5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6749606A331;
	Wed, 18 Nov 2026 23:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WdJLKwW5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4F81F000C6;
	Wed, 18 Nov 2026 23:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044375;
	bh=RWmtEm0UBXVWir2pX9KqqiWRxy9vGOrxb4B2rYbxALI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WdJLKwW57OQan3b/Nzt2QtaTzyHQ1XO6N35zCQWfwHBtw+aodmW25jN3zarA5vNCI
	 oJF69ehOZRiXyXMMo2ZlF7B9lgppL/I409MXedbcEKFRazd75xa3jAbeqMqXZTcKY2
	 3S3bhQXbQoJG3j0D011ZuC3DkLBNerPVUCpLamh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0545/2857] HID: wacom: Use hdev->product in wacom_setup_touch_input_capabilities
Date: Wed, 18 Nov 2026 15:26:19 +0100
Message-ID: <20261118150221.108040334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3932,8 +3932,8 @@ int wacom_setup_pen_input_capabilities(s
 int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 					 struct wacom_wac *wacom_wac)
 {
+	struct hid_device *hdev = container_of(wacom_wac, struct wacom, wacom_wac)->hdev;
 	struct wacom_features *features = &wacom_wac->features;
-
 	if (!(features->device_type & WACOM_DEVICETYPE_TOUCH))
 		return -ENODEV;
 
@@ -3942,9 +3942,11 @@ int wacom_setup_touch_input_capabilities
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
@@ -3976,19 +3978,17 @@ int wacom_setup_touch_input_capabilities
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
@@ -4018,8 +4018,8 @@ int wacom_setup_touch_input_capabilities
 		fallthrough;
 
 	case WACOM_27QHDT:
-		if (wacom_wac->shared->touch->product == 0x32C ||
-		    wacom_wac->shared->touch->product == 0xF6) {
+		if (hdev->product == 0x32C ||
+		    hdev->product == 0xF6) {
 			input_dev->evbit[0] |= BIT_MASK(EV_SW);
 			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
 			wacom_wac->has_mute_touch_switch = true;


