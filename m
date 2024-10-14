Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813D73B298;
	Mon, 14 Oct 2024 14:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917169; cv=none; b=Z8WHLdhCpZik65b0aODG2vpqq3brs6ifOxxek1A7dOKeqFskJReT8GGQTwc5RLFV49P2k2i3avAJNAZUHXa5xfISFLIyU58Ksmt8V45jdatHAocU9Ks9wVHY7+J+mYxstztxTNgvgyP0Dicy3Dy7xPgpdxIMQCD+/Z/0ThYt5Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917169; c=relaxed/simple;
	bh=xCdky8StFfTywCpWUXTbdLvdhkem6BJl/ALbv+SV24c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNBhMFRj4dA2Lm9Xye+lE5pCjmi6DIZMrzGD5hInjPWd3PS677Nm9DWaM/KICkmQRfGVmdvj9aDoHi3EmOoeHuVByAP3CXO9ArC6KH7ntj3so+6ElGBYDLyiwtcSyghQ95wFdZwkkDNK+sNK8OTFA6XJdRRz/kvHcP4lDzn1LVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nn6qKkCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nn6qKkCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E0AC4CEC3;
	Mon, 14 Oct 2024 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917169;
	bh=xCdky8StFfTywCpWUXTbdLvdhkem6BJl/ALbv+SV24c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nn6qKkCb2BecgTwj8OlP1O2n5TuZKRyHxqsTqadvS15Q7k82s5cJfUFCi9t1gGNsh
	 QSp6eCC4iKuqrQZmqBTMRYfLCqa3JghG8PxOYkMnJRSZL0EWOvHiUfqfBHQmv9dbzy
	 LHg/lmxrOI5vlDVDmiPdbDLn7TBUt2+y6Z2/YGqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/213] HID: asus: add ROG Ally N-Key ID and keycodes
Date: Mon, 14 Oct 2024 16:21:16 +0200
Message-ID: <20241014141049.604538733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 08b50c6b0b0940a304b481346cc187d489c6a751 ]

A handful of buttons on the ROG Ally are not actually part of the xpad
device and are instead keyboard keys (a typical use of the MCU that asus
uses). We attach a group of F<num> key codes which aren't used much and
which the handheld community has already accepted as defaults here.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 8 +++++++-
 drivers/hid/hid-ids.h  | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 88cbb2fe6ac8c..0616df83adc75 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -881,7 +881,10 @@ static int asus_input_mapping(struct hid_device *hdev,
 		case 0xb3: asus_map_key_clear(KEY_PROG3);	break; /* Fn+Left next aura */
 		case 0x6a: asus_map_key_clear(KEY_F13);		break; /* Screenpad toggle */
 		case 0x4b: asus_map_key_clear(KEY_F14);		break; /* Arrows/Pg-Up/Dn toggle */
-
+		case 0xa5: asus_map_key_clear(KEY_F15);		break; /* ROG Ally left back */
+		case 0xa6: asus_map_key_clear(KEY_F16);		break; /* ROG Ally QAM button */
+		case 0xa7: asus_map_key_clear(KEY_F17);		break; /* ROG Ally ROG long-press */
+		case 0xa8: asus_map_key_clear(KEY_F18);		break; /* ROG Ally ROG long-press-release */
 
 		default:
 			/* ASUS lazily declares 256 usages, ignore the rest,
@@ -1273,6 +1276,9 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD3),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
+	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY),
+	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD),
 	  QUIRK_ROG_CLAYMORE_II_KEYBOARD },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f1d49db9fddce..1301d15e5680b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -208,6 +208,7 @@
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD	0x1866
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD2	0x19b6
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD3	0x1a30
+#define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY		0x1abe
 #define USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD	0x196b
 #define USB_DEVICE_ID_ASUSTEK_FX503VD_KEYBOARD	0x1869
 
-- 
2.43.0



