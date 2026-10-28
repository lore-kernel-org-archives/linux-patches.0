Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213206;
	b=gZDOmBRk34XAdJlXilFLWhYbjLgse1/z2rma+2wH2/Sila42HJczdsjOefX0s2A4NePp
	 0QlC3gGwdcxUY0VV+zX3GQHb23B6UIUe1cYguEo260OPAWCPbwdHRxCkYFxf4ka/x5DGt
	 Uk9TI7DXC8ArJqfBuR00jfQMJiUkmUnknFB8zskMm6XtphX3pmjwButON+SBJ6hRUQdoL
	 +uDxodOdFPeye0n3y7yXRmZQsjkDHmGLkzX/CcVJ4zbYLkshunQmAqqjgZdwVHPp4cquo
	 17eLkHivmKxc9Jzkbb1p9pBeKoFRmEMHJ3e9z3xppLumTAwHuR4zZXPmBZwi4rn8rkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t6XMQ5WbGS5EH+Zz71nfIVIvY4A42CD+a6imH8or6A4=;
	b=YkhzGkyYg4hCPVyKYIl3odadPgsRHqX9uq5VMDoSrB7xeQ8z0q8xYtITn4zkViRKf4M0
	 p0l7eC9OWTg3tVQtcdjHHUZj7visdW2uTRF5jNTda5zo4L8cT+27D/UtQk1abYzUPJ1cL
	 CZWbI19IAlGRppBJB82s2JDKo5WHtv6qekH91AVJ26RJ9jmyYjjaXRqaEBcF+tNsMFX2k
	 qXytDLuJcvxFLGCrmoX2+Kled/hf09c0pLQYLHp2QtcCVdXulG6ODaZjM8OI2g4z3SPW9
	 HZXUmP1NQRYIO8NTFq850DMKHUcQjYkTWFopFNvuuAiIaRE/9/LVDjo1wlDRxxOwwyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJUOhURX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65468606A31A;
	Wed, 28 Oct 2026 18:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJUOhURX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43341F01825;
	Wed, 28 Oct 2026 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213206;
	bh=t6XMQ5WbGS5EH+Zz71nfIVIvY4A42CD+a6imH8or6A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJUOhURXpZDUf+oC29Kw/dA7dvMZ1+RfnKRuyKZZhw5BcYOH0yUW7LGgSkyFC52nL
	 WFbhAT4c6GX9Ne3AQnkjKLlyUBXsrOJ8786J5sggvZF7iuq9zf/YbolIZu2Sfv7KHB
	 qCbwffQARq7xc6Ex1isV4jgO5jhXCh6aHT00d71c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 0423/1887] HID: core: introduce hid_safe_input_report()
Date: Wed, 28 Oct 2026 17:41:59 +0100
Message-ID: <20261028170508.860818435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
      HID low level functions") is not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c             | 26 ++++++++++++++++++++++++--
 drivers/hid/i2c-hid/i2c-hid-core.c |  7 ++++---
 drivers/hid/usbhid/hid-core.c      | 11 ++++++-----
 include/linux/hid.h                |  2 ++
 4 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 61dde8e3fbb25..3b1952e66ca42 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2085,14 +2085,36 @@ EXPORT_SYMBOL_GPL(hid_report_raw_event);
  * @interrupt: distinguish between interrupt and control transfers
  *
  * This is data entry for lower layers.
+ * Legacy, please use hid_safe_input_report() instead.
  */
 int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data,
 		     u32 size, int interrupt)
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
+int hid_safe_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data,
+			  size_t bufsize, u32 size, int interrupt)
 {
 	struct hid_report_enum *report_enum;
 	struct hid_driver *hdrv;
 	struct hid_report *report;
-	size_t bufsize = size;
 	int ret = 0;
 
 	if (!hid)
@@ -2137,7 +2159,7 @@ int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data
 	up(&hid->driver_input_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(hid_input_report);
+EXPORT_SYMBOL_GPL(hid_safe_input_report);
 
 bool hid_match_one_id(const struct hid_device *hdev,
 		      const struct hid_device_id *id)
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 9559c96d44b4d..d301dc5acd31e 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -539,9 +539,10 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
 		if (ihid->hid->group != HID_GROUP_RMI)
 			pm_wakeup_event(&ihid->client->dev, 0);
 
-		hid_input_report(ihid->hid, HID_INPUT_REPORT,
-				ihid->inbuf + sizeof(__le16),
-				ret_size - sizeof(__le16), 1);
+		hid_safe_input_report(ihid->hid, HID_INPUT_REPORT,
+				      ihid->inbuf + sizeof(__le16),
+				      ihid->bufsize - sizeof(__le16),
+				      ret_size - sizeof(__le16), 1);
 	}
 
 	return;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index ccf0aad99a4b9..3bfca6c3b5286 100644
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
@@ -480,9 +480,10 @@ static void hid_ctrl(struct urb *urb)
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
index 9fde4e8839c91..803bbaccec6ab 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -960,6 +960,8 @@ extern void hidinput_disconnect(struct hid_device *);
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
 		     int interrupt);
+int hid_safe_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data,
+			  size_t bufsize, u32 size, int interrupt);
 struct hid_field *hidinput_get_led_field(struct hid_device *hid);
 unsigned int hidinput_count_leds(struct hid_device *hid);
 __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code);
-- 
2.53.0



