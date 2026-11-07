Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061556;
	b=Kr4FJHDGpLmlrX7qhUfu3upgKC3V9AZ+9O2BKsJYMOhiS9hD0cgJ/lecsNlL6q9ErCnk
	 sPcM+rpC/OSQxrMJOuWcGVU06MKmox0FGwMLFemLt1JE4AGB6NDFwpUqETyz7PBe3XUFT
	 6elWvU2TbVpdOapBN5LJvCj9pPAMYZek08jTI8hHWkD0kEbMyZsi14Y6apq5Ix0/INNmE
	 5jiDz3r895FF/jHwd9XTjVmyh1LxZWdUqZTrZ2N6iMf+XTdifVSLqhyy14VCj1Lz1tBYT
	 HAC5O5T/OePu/Ahf2UO+IoFrQ5zoPfi0+l+IjChbDVsqfO9eVXLf2u4Ayw0f87i4FjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xnL5fkWehCNcYC/zbY5TnRLB1OeVgaeFTgFV5z+9uSk=;
	b=Nc3Sl3ZUC5k0fWmLDSU2IZL9sTyO3Jx5BFT+N3lvbO12U33oNXWB5cEnwfQul2yoFh7Q
	 uIyi9Cid8HgRbBKTgHF9mLs+2uNBI8MA7Bu184Vlp7+llicboAvgKOTVHI5MwjlvOG0I/
	 dLcz2xMffG3H75ZoKbdpZO/wlBRXCektvd2G7BXeYgaPupaBw55h/Q35nw92tvd/cfsGS
	 hP5uTWumU2oLNKLbGTVGa0wQjUaL/cJz8tr5vo9uf+GCnwZZHlI2sqXOkmcW9TUjM/G1i
	 4o9zHnjAntgfs3jCsf7QJ0vP6djkZkZzvxywGV4Gf+r7nOzAcFarNCWbbTV/597Nw8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKBw1q2U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8793C606A331;
	Sat,  7 Nov 2026 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKBw1q2U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E2D1F008A1;
	Sat,  7 Nov 2026 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061556;
	bh=xnL5fkWehCNcYC/zbY5TnRLB1OeVgaeFTgFV5z+9uSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKBw1q2U9DiR6fyjT5GKUyj5odCRo4sbntvwdZZD8EjTBu08JLhvx3V7ls/4CCexc
	 cMscg5hoJew8wgFPSrHFV86XqxMommB6DexQ7Xv9np/+aiDnLud2/uM56sy5uQfhDv
	 C1UAdKg7s7ObaaNYZZKJEJHTKJM9Vyd1q1X4V6WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0621/1536] HID: wacom: Use hdev->product in wacom_setup_touch_input_capabilities
Date: Sat,  7 Nov 2026 08:43:57 -0500
Message-ID: <20261107135014.974841444@linuxfoundation.org>
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
@@ -3961,8 +3961,8 @@ int wacom_setup_pen_input_capabilities(s
 int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 					 struct wacom_wac *wacom_wac)
 {
+	struct hid_device *hdev = container_of(wacom_wac, struct wacom, wacom_wac)->hdev;
 	struct wacom_features *features = &wacom_wac->features;
-
 	if (!(features->device_type & WACOM_DEVICETYPE_TOUCH))
 		return -ENODEV;
 
@@ -3971,9 +3971,11 @@ int wacom_setup_touch_input_capabilities
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
@@ -4005,19 +4007,17 @@ int wacom_setup_touch_input_capabilities
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
@@ -4047,8 +4047,8 @@ int wacom_setup_touch_input_capabilities
 		fallthrough;
 
 	case WACOM_27QHDT:
-		if (wacom_wac->shared->touch->product == 0x32C ||
-		    wacom_wac->shared->touch->product == 0xF6) {
+		if (hdev->product == 0x32C ||
+		    hdev->product == 0xF6) {
 			input_dev->evbit[0] |= BIT_MASK(EV_SW);
 			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
 			wacom_wac->has_mute_touch_switch = true;


