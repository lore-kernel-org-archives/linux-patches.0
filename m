Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6F130BF71;
	Tue,  2 Sep 2025 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819698; cv=none; b=VLG3B3QG/dnsvjVbycLr+wgrnoVi+fYByc5D7SQLJXieNBDFzQOXpk9QJTgvB8dOQmEX8h75d+AB6OW3TehiifBc6I0F2Hx94kJjvg1fAzeDKu0Qg53dy+d2iacSI3qxckJwpGYMqdqJHRlh8S4PpZxsjzWmBZTdjWvTH5XqP+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819698; c=relaxed/simple;
	bh=42JunV5PxOYKlJomCpT5AMSSSqrcGKYGd0nQlmdEyKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQ9Z6IW6cHOGdtaDLVDSZGX3sVBYcs/ASA4E9y+Jy8uNKVb5a8Ii6pxWHhRDywPIdzCOOKPA3rBTMIP3VJEb7sO+I8RL7AdjiUqhBXRRw8yxsdma4ClaR0wowCI0u73z9dqHNYOIeJ9ZXEiusTe8CGkWR+LHOidkpCF/pYCoC2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKs1CDCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKs1CDCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F2EC4CEED;
	Tue,  2 Sep 2025 13:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819697;
	bh=42JunV5PxOYKlJomCpT5AMSSSqrcGKYGd0nQlmdEyKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKs1CDCuAn8+gkWZVSWWSYRWXFGwsEQmxtttKG/3soB61zoKSDQwRRFeoIUdSdAo+
	 T4faRQmV7nq53rPpS/HJ7aIxQ2Uy8Wltz7gnKWDd39GAGMfxpKJ7lagsp7Yyb2ytJD
	 oT10vzecC4iRXsce0y7MCdC3baFz+hk6HGTQfhEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Coffin <mcoffin13@gmail.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.16 113/142] HID: logitech: Add ids for G PRO 2 LIGHTSPEED
Date: Tue,  2 Sep 2025 15:20:15 +0200
Message-ID: <20250902131952.607383397@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Coffin <mcoffin13@gmail.com>

commit ab1bb82f3db20e23eace06db52031b1164a110c2 upstream.

Adds support for the G PRO 2 LIGHTSPEED Wireless via it's nano receiver
or directly. This nano receiver appears to work identically to the 1_1
receiver for the case I've verified, which is the battery status through
lg-hidpp.

The same appears to be the case wired, sharing much with the Pro X
Superlight 2; differences seemed to lie in userland configuration rather
than in interfaces used by hid_logitech_hidpp on the kernel side.

I verified the sysfs interface for battery charge/discharge status, and
capacity read to be working on my 910-007290 device (white).

Signed-off-by: Matt Coffin <mcoffin13@gmail.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h            |    1 +
 drivers/hid/hid-logitech-dj.c    |    4 ++++
 drivers/hid/hid-logitech-hidpp.c |    2 ++
 3 files changed, 7 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -907,6 +907,7 @@
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_2		0xc534
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1	0xc539
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_1	0xc53f
+#define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_2	0xc543
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_POWERPLAY	0xc53a
 #define USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER	0xc548
 #define USB_DEVICE_ID_SPACETRAVELLER	0xc623
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1983,6 +1983,10 @@ static const struct hid_device_id logi_d
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_1),
 	 .driver_data = recvr_type_gaming_hidpp},
+	{ /* Logitech lightspeed receiver (0xc543) */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
+		USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_2),
+	 .driver_data = recvr_type_gaming_hidpp},
 
 	{ /* Logitech 27 MHz HID++ 1.0 receiver (0xc513) */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER),
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4596,6 +4596,8 @@ static const struct hid_device_id hidpp_
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC094) },
 	{ /* Logitech G Pro X Superlight 2 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC09b) },
+	{ /* Logitech G PRO 2 LIGHTSPEED Wireless Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xc09a) },
 
 	{ /* G935 Gaming Headset */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0x0a87),


