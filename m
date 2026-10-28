Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208988;
	b=5UWauHVJdtZYdKm4obAmW6LxE4MGMBsVh3d3lv4nydq1Jz6VDV2X6fhBWtIfUQEKGxtD
	 f+WI6gJTX4S5NzFGpDjYOgmhMaBj6zmvYxnTtd6IYQJPyUnqfE81MeMv91/stbEGbuRFV
	 jwkg287RE8xgFS7NOqYrtsJ7eqb0aysOT3fhjm695hBrgdynscfY/xjHFSigEOtrrhN25
	 D2TORAHU47qKGc585+zge+MnuULUaYWAtdW4t9AwZY/yfHSMOFY10UMyfWlM3Bw4nYn9B
	 3AG65dMuVCvqTri/hZbc4oR7QiItN5RaeMXWMXVqP5aIGtAFg57John5JxFVMSB3j5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=50oNSViML/F2AAzkgdRf46QUITi227vuw3lEkU0HLJA=;
	b=oWbpR1t1O1j9zcrCUbk2R1XYNe95t2bt7L1VKQ2eOKeCdJ4y+TcjLXWY1x9sNbcPwkzK
	 +d0o0gsmp2asTFSWU1ol3k1lHiRIPi/CioVFWrchAmLgPRB/USpM9HV6Mc2UR414SyOIJ
	 t+cnahAoQQe5+1bLY/Bg14jevvgvfToQqZI6EbaYVF4t8tRIDQiOTwCFel7hSZtJOw/vJ
	 oUqhNYPp3a919bk/mVxX1pgrLa9lVCLzphrsk+b2A5Q//7AqQRN8kPNHsdH+cUaMkmjc9
	 MHgnUbpe0GGQQz1XmjptYtYUXnncsg5LlNHr8i4LaJDMhDDDasZ4LsaKg71qSKUtZhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xiGg0Bu/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8D9606A31A;
	Wed, 28 Oct 2026 17:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xiGg0Bu/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F04A1F01825;
	Wed, 28 Oct 2026 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208988;
	bh=50oNSViML/F2AAzkgdRf46QUITi227vuw3lEkU0HLJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiGg0Bu/pYK0Wx7Ab0wSqHV9GMRVBQT/69GHx7erC2+OLjgi0mbQ2QrpYiyM8QONF
	 J/7AnY+uP4rdq6kZ64cDhHBv/wRqkEukB6TA+VQ68mSePqfAtCMD3g4ACZDgUz1jDF
	 EYOhFGB4KIRz9iq6Z1/pxNgkOhkRG+qXixSCswY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 312/516] HID: core: introduce hid_safe_input_report()
Date: Wed, 28 Oct 2026 17:57:44 +0100
Message-ID: <20261028170010.881160362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit 206342541fc887ae919774a43942dc883161fece ]

hid_input_report() is used in too many places to have a commit that
doesn't cross subsystem borders. Instead of changing the API, introduce
a new one when things matters in the transport layers:
- usbhid
- i2chid

This effectively revert to the old behavior for those two transport
layers.

Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
(cherry picked from commit a9527c32cc9d98252dc975d6fcb29f2013d0f63a)
[Lee: Implement hid_safe_input_report() directly and wrap it from
      hid_input_report() as 67eccf151d76 ("HID: add source argument to
      HID low level functions") is not present.  Use int for report type
      and literal 2 in i2c_hid_get_input() as 56fc4f7bc114 and
      1bdbe0dcff2f are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c             | 26 ++++++++++++++++++++++++--
 drivers/hid/i2c-hid/i2c-hid-core.c |  5 +++--
 drivers/hid/usbhid/hid-core.c      | 11 ++++++-----
 include/linux/hid.h                |  2 ++
 4 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9d1a3b05ca8d9..d20249796ec8c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1873,13 +1873,35 @@ EXPORT_SYMBOL_GPL(hid_report_raw_event);
  * @interrupt: distinguish between interrupt and control transfers
  *
  * This is data entry for lower layers.
+ * Legacy, please use hid_safe_input_report() instead.
  */
 int hid_input_report(struct hid_device *hid, int type, u8 *data, u32 size, int interrupt)
+{
+	return hid_safe_input_report(hid, type, data, size, size, interrupt);
+}
+EXPORT_SYMBOL_GPL(hid_input_report);
+
+/**
+ * hid_safe_input_report - report data from lower layer (usb, bt...)
+ *
+ * @hid: hid device
+ * @type: HID report type (HID_*_REPORT)
+ * @data: report contents
+ * @bufsize: allocated size of the data buffer
+ * @size: useful size of data parameter
+ * @interrupt: distinguish between interrupt and control transfers
+ *
+ * This is data entry for lower layers.
+ * Please use this function instead of the non safe version because we provide
+ * here the size of the buffer, allowing hid-core to make smarter decisions
+ * regarding the incoming buffer.
+ */
+int hid_safe_input_report(struct hid_device *hid, int type, u8 *data,
+			  size_t bufsize, u32 size, int interrupt)
 {
 	struct hid_report_enum *report_enum;
 	struct hid_driver *hdrv;
 	struct hid_report *report;
-	size_t bufsize = size;
 	int ret = 0;
 
 	if (!hid)
@@ -1924,7 +1946,7 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, u32 size, int i
 	up(&hid->driver_input_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(hid_input_report);
+EXPORT_SYMBOL_GPL(hid_safe_input_report);
 
 bool hid_match_one_id(const struct hid_device *hdev,
 		      const struct hid_device_id *id)
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 8a8fcccfb7e49..bf122b594aa97 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -523,8 +523,9 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
 	i2c_hid_dbg(ihid, "input: %*ph\n", ret_size, ihid->inbuf);
 
 	if (test_bit(I2C_HID_STARTED, &ihid->flags))
-		hid_input_report(ihid->hid, HID_INPUT_REPORT, ihid->inbuf + 2,
-				ret_size - 2, 1);
+		hid_safe_input_report(ihid->hid, HID_INPUT_REPORT,
+				      ihid->inbuf + 2, ihid->bufsize - 2,
+				      ret_size - 2, 1);
 
 	return;
 }
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 7d0eb6c85d851..6db8ce670020b 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -281,9 +281,9 @@ static void hid_irq_in(struct urb *urb)
 			break;
 		usbhid_mark_busy(usbhid);
 		if (!test_bit(HID_RESUME_RUNNING, &usbhid->iofl)) {
-			hid_input_report(urb->context, HID_INPUT_REPORT,
-					 urb->transfer_buffer,
-					 urb->actual_length, 1);
+			hid_safe_input_report(urb->context, HID_INPUT_REPORT,
+					      urb->transfer_buffer, urb->transfer_buffer_length,
+					      urb->actual_length, 1);
 			/*
 			 * autosuspend refused while keys are pressed
 			 * because most keyboards don't wake up when
@@ -483,9 +483,10 @@ static void hid_ctrl(struct urb *urb)
 	switch (status) {
 	case 0:			/* success */
 		if (usbhid->ctrl[usbhid->ctrltail].dir == USB_DIR_IN)
-			hid_input_report(urb->context,
+			hid_safe_input_report(urb->context,
 				usbhid->ctrl[usbhid->ctrltail].report->type,
-				urb->transfer_buffer, urb->actual_length, 0);
+				urb->transfer_buffer, urb->transfer_buffer_length,
+				urb->actual_length, 0);
 		break;
 	case -ESHUTDOWN:	/* unplug */
 		unplug = 1;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index c553800ee7c6d..029d8347540d3 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -929,6 +929,8 @@ extern void hidinput_disconnect(struct hid_device *);
 
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *, int type, u8 *, u32, int);
+int hid_safe_input_report(struct hid_device *hid, int type, u8 *data,
+			  size_t bufsize, u32 size, int interrupt);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
 struct hid_field *hidinput_get_led_field(struct hid_device *hid);
 unsigned int hidinput_count_leds(struct hid_device *hid);
-- 
2.53.0



