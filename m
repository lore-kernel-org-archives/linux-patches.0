Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEADF3594B;
	Tue,  2 Sep 2025 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820301; cv=none; b=kX3beogVbLQhl/QwrD5/ASjYqMZaX62NKypPdLYFw5DA1L8287IpjchcCt3eHItDTM/DED1uWMSlSPvcVY/1OhfXkSh++ia2VfmABlGFQh3RvgWdF282AOqIYAHmMJOoSYiyxWCNPYTwk368P4bxPvSVa2VF44D30o57QVHExTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820301; c=relaxed/simple;
	bh=H3rVwcbFlk+z1qBtz6Ndol4G3WW9u8/C3HTjfyhblt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIp4VV+0yMfch0dTELQAbCMMggBokmTN+7Crt1h+S+64ISstHRpwkhfNpk4C2mNHyweKieieS/bI04tk6gr0G3RC2h/7QJUPJzB1LYO40vbkBNUWumBbyh2E2p2R+mQ3dHtmvArawOVqzP5YJeYpjMXZFJPjqFbUu2PiN2FnpYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uzm90frS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uzm90frS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6F6C4CEED;
	Tue,  2 Sep 2025 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820301;
	bh=H3rVwcbFlk+z1qBtz6Ndol4G3WW9u8/C3HTjfyhblt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uzm90frS4Ibl7WYTDzDfB62K9zPbJclCFXMW1DxpixSn3zIZrQz2E/zPQvFqcrAGH
	 Lx4S0MlvWZb3YuemmA7pnjPGgO+JMmHC0BrdMYxeyTTU9QFCi2aUlVBXhsZa4xWk1b
	 RZbDPgYQ0EYlPuT871iFQFDIEu1JrZGOdp5pqm+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Coffin <mcoffin13@gmail.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 61/75] HID: logitech: Add ids for G PRO 2 LIGHTSPEED
Date: Tue,  2 Sep 2025 15:21:13 +0200
Message-ID: <20250902131937.506565778@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -893,6 +893,7 @@
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
@@ -4652,6 +4652,8 @@ static const struct hid_device_id hidpp_
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC094) },
 	{ /* Logitech G Pro X Superlight 2 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC09b) },
+	{ /* Logitech G PRO 2 LIGHTSPEED Wireless Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xc09a) },
 
 	{ /* G935 Gaming Headset */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0x0a87),


