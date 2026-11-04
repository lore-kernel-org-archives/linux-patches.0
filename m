Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831046;
	b=3Zy7lgob39G5MxQF6iBpWxOgNg2sIUa6GN6p2UmLgl0bl4bbrtROe1SPTCO4ZbVL+Dwf
	 N5oFeTlZTGCFfEiezu73zxKuqwxZv2tmy0XpzKLEEa30Tk5uhBewKLbAMncO8C1Cequp4
	 Erl8WcN3rFX3X26M0fXYorlrJNR5B5ejnxQz5Ytus4I+jwGKj2HZwwg0kwj5D+UbPnwzW
	 5BNw4UE6y3qyqC7YlRkxMZcAvZIWBAr+3CeceOaYm7tcVf2VIW4kRPVsPHH9Nopyvwh5a
	 5hMYwISslj7y54PyTv0kxlpnlP2qhH83vbgRjVG1KNS2twvv7/A2ce9XeDxIWdsH9Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VBRdA7xENQ3Sb9Qn/x6iuAJ3PZ8w7eZzS2egHgdtbKI=;
	b=QFIa6p5qxhSeCLd/2FG/2NVVrgCN4Ax7GnN1du/l+M6lo/UNiDN175+oKBBsGByyHmBp
	 znre+ZfFn9+/cmMSG9V96aBb/3e3CRYS5biPlO80q34DEfep3hDzdewga0uj1o8g3kp33
	 dFvEz4jZnDDHgvGoeOx2fqhQxrj0ekRlOrlEwwgDNlH0A5HfYHL6Uwu/ZngR8uAmzOsKY
	 XXrk65glms+e9tMcwpYoGMGgqEFgFLOtgACMVv/n3hzJuWBUJtOse5101ksKYrAb5oTYc
	 aHn2YK6idLDvGtKgOE0hhbyHUhDqMngtEqeKP7YRjE0bh4cXRbiRLhDLHQEDuYNNADg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8rss5Dc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B99606A843;
	Wed,  4 Nov 2026 22:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8rss5Dc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A911F00919;
	Wed,  4 Nov 2026 22:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831045;
	bh=VBRdA7xENQ3Sb9Qn/x6iuAJ3PZ8w7eZzS2egHgdtbKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8rss5DcbMtO0XjhRLzbLxvY/2pS8noVY/1IdRyHnGAd0nBixY5vUnRvRhjRXZ5d6
	 P/PL4w/g7k7FkRBUg01Js7e0v3AgPnTC7IVL2QysUlfKL3wTP6wFveBW82fJUw+WUf
	 uzR9kpw2qNV2OTVWuchUwdDyHA0CYLfUdgRKz528=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Berke Durak <berke.durak@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0478/1005] HID: elecom: Add support for ELECOM M-XT4DRBK (018E)
Date: Wed,  4 Nov 2026 16:03:31 -0500
Message-ID: <20261104211057.381412660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Berke Durak <berke.durak@gmail.com>

[ Upstream commit f3c2b266b8fd7cf816d36168d19f67e716f2c080 ]

The 2025 revision of the left-handed EX-G wireless trackball
(M-XT4DRBK-G) reports USB ID 056e:018e instead of 056e:00fd. Its report
descriptor declares an 8-bit button field (Report Count 8) but only five
usages (Usage Maximum 5), so the sixth (Fn) button ends up as a
duplicate of button 5 and is unusable.

The report descriptor has the same layout as the M-XT3DRBK 018C
(button usage maximum at offset 16, button report count at 22, button
report size at 24, padding report size at 30), so reuse that fixup.

Rename the existing M_XT4DRBK define to M_XT4DRBK_00FD to match the
convention used for the other EX-G revisions.

Tested on a Raspberry Pi 5 with the same fixup in an
out-of-tree module on 6.12 (6.12.96+rpt-rpi-2712);
all six buttons are reported after the fix, and they
work (tested with xev as well).

Report descriptor as sent by the device, pre-fix (056e:018e,
215 bytes):

 05 01 09 02 A1 01 09 01 A1 00 85 01 05 09 19 01
 29 05 15 00 25 01 95 08 75 01 81 02 95 01 75 00
 81 01 05 01 09 30 09 31 16 00 80 26 FF 7F 75 10
 95 02 81 06 C0 A1 00 05 01 09 38 15 81 25 7F 75
 08 95 01 81 06 C0 A1 00 05 0C 0A 38 02 95 01 75
 08 15 81 25 7F 81 06 C0 C0 06 01 FF 09 00 A1 01
 85 02 09 00 15 00 26 FF 00 75 08 95 07 81 02 C0
 05 0C 09 01 A1 01 85 05 15 00 26 3C 02 19 00 2A
 3C 02 75 10 95 01 81 00 C0 05 01 09 80 A1 01 85
 03 19 81 29 83 15 00 25 01 95 03 75 01 81 02 95
 01 75 05 81 01 C0 06 BC FF 09 88 A1 01 85 04 95
 01 75 08 15 00 26 FF 00 19 00 2A FF 00 81 00 C0
 06 02 FF 09 02 A1 01 85 06 09 02 15 00 26 FF 00
 75 08 95 07 B1 02 C0

Assisted-by: LLM
Signed-off-by: Berke Durak <berke.durak@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-elecom.c | 6 ++++--
 drivers/hid/hid-ids.h    | 3 ++-
 drivers/hid/hid-quirks.c | 3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index 37d88ce57f671..d21ead40bb076 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -79,7 +79,7 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	case USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB:
 	case USB_DEVICE_ID_ELECOM_M_XT3URBK_018F:
 	case USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC:
-	case USB_DEVICE_ID_ELECOM_M_XT4DRBK:
+	case USB_DEVICE_ID_ELECOM_M_XT4DRBK_00FD:
 		/*
 		 * Report descriptor format:
 		 * 12: button bit count
@@ -104,6 +104,7 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		mouse_button_fixup(hdev, rdesc, *rsize, 12, 30, 14, 20, 8);
 		break;
 	case USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C:
+	case USB_DEVICE_ID_ELECOM_M_XT4DRBK_018E:
 		/*
 		 * Report descriptor format:
 		 * 22: button bit count
@@ -148,7 +149,8 @@ static const struct hid_device_id elecom_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK_00FD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK_018E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT2DRBK) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index a10b4ae0e3d8e..ca5c62f29aebe 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -466,7 +466,8 @@
 #define USB_DEVICE_ID_ELECOM_M_XT3URBK_018F	0x018f
 #define USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC	0x00fc
 #define USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C	0x018c
-#define USB_DEVICE_ID_ELECOM_M_XT4DRBK	0x00fd
+#define USB_DEVICE_ID_ELECOM_M_XT4DRBK_00FD	0x00fd
+#define USB_DEVICE_ID_ELECOM_M_XT4DRBK_018E	0x018e
 #define USB_DEVICE_ID_ELECOM_M_DT1URBK	0x00fe
 #define USB_DEVICE_ID_ELECOM_M_DT1DRBK	0x00ff
 #define USB_DEVICE_ID_ELECOM_M_DT2DRBK	0x018d
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 8d2ac32c5ac12..debd00ed9062a 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -431,7 +431,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK_00FD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK_018E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT2DRBK) },
-- 
2.53.0



