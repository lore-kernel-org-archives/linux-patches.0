Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8AD3054E7;
	Tue,  2 Sep 2025 13:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819691; cv=none; b=tJFNVoEZWmu2O1w2u1wAFW3d4M1N6Xp9up/tqqKdwuiFbHb0pLLOMfQ/itsToTi+pbMSDcirSpI/vL+nFSlc8a3MSY9jYROUse7+N3d7YZf/i4Y3o7/ONtZS5LwxhKOhML/Ca4g75bDWM3VTHQl+r0hxwWu2lO2ZnZWWgwA1csU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819691; c=relaxed/simple;
	bh=YlNbHLseJPjgi8fqTilnuSEPww5/ftkLqlroTq7KYVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFq8wd9lQ/hyufwpn+W2COf2trwS7rcDhDAI3NjSzSfnam00Lj3eU/K72mdgx0vW9h7gMlewXag/OaLBYqdanKoMBfnBEMfZussGPDseGXCBs4PA791jsrQSwOI1adYxt4QwWN7xsEMprz/j5luv4v3GbmTQFm+Jayfg94ZcSqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCaThGtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCaThGtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1401C4CEF4;
	Tue,  2 Sep 2025 13:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819691;
	bh=YlNbHLseJPjgi8fqTilnuSEPww5/ftkLqlroTq7KYVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCaThGtKqlUPa1kddvzKFfsocjI94LQlMS1NpH3n15ulkOPuNmwmK1sGJ3XLAucEY
	 IlB/OaN/CVR05+72kt46XhE0jYvd+vHibW9qhShwu2fbxjPoaI0nj55PunO2bsE3RC
	 a5IKC4YuTagModJCQ4wN/wjMkkrPS55smqcBp7RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hilgendorf <martin.hilgendorf@posteo.de>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.16 111/142] HID: elecom: add support for ELECOM M-DT2DRBK
Date: Tue,  2 Sep 2025 15:20:13 +0200
Message-ID: <20250902131952.529218975@linuxfoundation.org>
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

From: Martin Hilgendorf <martin.hilgendorf@posteo.de>

commit 832e5777143e799a97e8f9b96f002a90f06ba548 upstream.

The DT2DRBK trackball has 8 buttons, but the report descriptor only
specifies 5. This patch adds the device ID and performs a similar fixup as
for other ELECOM devices to enable the remaining 3 buttons.

Signed-off-by: Martin Hilgendorf <martin.hilgendorf@posteo.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-elecom.c |    2 ++
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -101,6 +101,7 @@ static const __u8 *elecom_report_fixup(s
 		 */
 		mouse_button_fixup(hdev, rdesc, *rsize, 12, 30, 14, 20, 8);
 		break;
+	case USB_DEVICE_ID_ELECOM_M_DT2DRBK:
 	case USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C:
 		/*
 		 * Report descriptor format:
@@ -123,6 +124,7 @@ static const struct hid_device_id elecom
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT2DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK_010C) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK_019B) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -448,6 +448,7 @@
 #define USB_DEVICE_ID_ELECOM_M_XT4DRBK	0x00fd
 #define USB_DEVICE_ID_ELECOM_M_DT1URBK	0x00fe
 #define USB_DEVICE_ID_ELECOM_M_DT1DRBK	0x00ff
+#define USB_DEVICE_ID_ELECOM_M_DT2DRBK	0x018d
 #define USB_DEVICE_ID_ELECOM_M_HT1URBK_010C	0x010c
 #define USB_DEVICE_ID_ELECOM_M_HT1URBK_019B	0x019b
 #define USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D	0x010d
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -410,6 +410,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT2DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK_010C) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK_019B) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D) },


