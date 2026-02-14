Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A713EBF2C;
	Sat, 14 Feb 2026 01:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030973; cv=none; b=dINttqQICtbt9HMrc2EF/WDQUh3AxsVVMJFVzxUTC6IF7nDxW9eVfvG5GJfiKGCkjAKaecoitJqsGtoDPCpCxBLFonl+NrrIvq947FSptzoKBYgaqQ0wlql+1NpffmDF39VjI+ItOx624aXJNmq1ed5z/Ut7crj0DTSg9uH/zYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030973; c=relaxed/simple;
	bh=gij6qTX6Cycb2hJBF678hTPThaCkudlyWwxv0qo7PiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OtTnJh3PpX22qGbiN7UJp8LbXEfDbn84K3QoEFSp51s5a5T9Bw/HbVA0ffcMAZ29kQ+Ywb+FGV01tNAILOSL7HMKCQOP2MkSE+5nTZ0TnYeAAoy1fIhEYjYSZxLJObdsa9egR9gfF4ZtQTZT7BAuYACHqpi2rd481JujS+ftgnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kAchVaWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kAchVaWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7AEC116C6;
	Sat, 14 Feb 2026 01:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030972;
	bh=gij6qTX6Cycb2hJBF678hTPThaCkudlyWwxv0qo7PiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAchVaWPzxIz0jHNYTOW3iMezFIkbL58rrV8o/Ew/hKEEPlHZPBD3YaPwI2N4t5xW
	 TZD7Ovp4saOngHMokMNEMLB0JMECKN3n2NcDdX/RhUZoEyTCftfBSLFlRdZwCgBMft
	 6k/uSbUU7rJmnnQF80IBg5+mjV1zRf4U8vi28kbO5nrBiIGj4rHHSUGAQe60BM1VhI
	 YDiAb/uE6iHV59BaeVzeCVXBOm8nGYVcQrXn1Wgd3v6G8zCg5LA0NnpyVseLB0mv5W
	 wwrxu+SOM/IlA2ucci/LLwrBWgvFO5mlR2TT8B4f/9rsKS2B2kHU04PaPpoRRmQvU2
	 2346UYGXR55AA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Phillips <david@profile.sh>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] HID: elecom: Add support for ELECOM HUGE Plus M-HT1MRBK
Date: Fri, 13 Feb 2026 19:58:03 -0500
Message-ID: <20260214010245.3671907-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Phillips <david@profile.sh>

[ Upstream commit b8e5fdf0bd022cd5493a5987ef66f5a24f8352d8 ]

New model in the ELECOM HUGE trackball line that has 8 buttons but the
report descriptor specifies only 5. The HUGE Plus supports connecting via
Bluetooth, 2.4GHz wireless USB dongle, and directly via a USB-C cable.
Each connection type reports a different device id, 01AA for cable,
01AB for USB dongle, and 01AC for Bluetooth.

This patch adds these device IDs and applies the fixups similar to the
other ELECOM devices to get all 8 buttons working for all 3 connection
types.

For reference, the usbhid-dump output:
001:013:001:DESCRIPTOR         1769085639.598405
 05 01 09 02 A1 01 85 01 09 01 A1 00 05 09 19 01
 29 05 15 00 25 01 75 01 95 05 81 02 75 03 95 01
 81 01 05 01 09 30 09 31 16 01 80 26 FF 7F 75 10
 95 02 81 06 09 38 15 81 25 7F 75 08 95 01 81 06
 05 0C 0A 38 02 15 81 25 7F 75 08 95 01 81 06 C0
 C0 05 0C 09 01 A1 01 85 02 15 01 26 8C 02 19 01
 2A 8C 02 75 10 95 01 81 00 C0 05 01 09 80 A1 01
 85 03 09 82 09 81 09 83 15 00 25 01 19 01 29 03
 75 01 95 03 81 02 95 05 81 01 C0 06 01 FF 09 00
 A1 01 85 08 09 00 15 00 26 FF 00 75 08 95 07 81
 02 C0 06 02 FF 09 02 A1 01 85 06 09 02 15 00 26
 FF 00 75 08 95 07 B1 02 C0

Signed-off-by: David Phillips <david@profile.sh>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

This commit adds support for the ELECOM HUGE Plus trackball (M-HT1MRBK)
across three connection types (USB-C cable, 2.4GHz USB dongle,
Bluetooth). The device has 8 buttons but the HID report descriptor only
reports 5, so the driver applies a report descriptor fixup to expose all
8 buttons — the same pattern used for other ELECOM devices already
supported by this driver.

### Code Change Analysis

The changes span 4 files:

1. **`drivers/hid/hid-ids.h`**: Adds 3 new device ID defines (0x01aa,
   0x01ab, 0x01ac) for the three connection types.

2. **`drivers/hid/hid-elecom.c`**:
   - Adds a new case block in `elecom_report_fixup()` for the three new
     device IDs, calling `mouse_button_fixup()` with appropriate offsets
     (24, 28, 22, 16, 8). Note the offsets differ slightly from the
     existing HUGE (M-HT1DRBK) which uses (22, 30, 24, 16, 8) — this is
     because the HUGE Plus has a different report descriptor format as
     shown in the commit message.
   - Adds the three device IDs to `elecom_devices[]` table (USB for 01AA
     and 01AB, Bluetooth for 01AC).

3. **`drivers/hid/hid-quirks.c`**: Adds the three device IDs to
   `hid_have_special_driver[]` so the HID core knows to route these
   devices to the elecom driver.

4. **`drivers/hid/Kconfig`**: Updates help text to mention the new
   device.

### Classification

This is a **new device ID addition with report descriptor fixup** — one
of the explicitly allowed exception categories for stable backports. The
ELECOM HID driver already exists in stable trees, and this commit adds
IDs for a new variant of an existing product line (HUGE Plus vs HUGE),
applying the same `mouse_button_fixup()` mechanism already used by other
ELECOM devices.

### Scope and Risk Assessment

- **Lines changed**: Small — ~30 lines of meaningful additions across 4
  files.
- **Risk**: Very low. The changes are purely additive (new device IDs +
  new case in switch statement). They cannot affect any existing device
  since they only trigger for the new device IDs. The
  `mouse_button_fixup()` function is already well-tested with other
  ELECOM devices.
- **Pattern**: Follows the exact same pattern as previous ELECOM device
  additions (e.g., the HUGE M-HT1DRBK, DEFT M-DT2DRBK, etc.).

### User Impact

Without this patch, users of the ELECOM HUGE Plus trackball can only use
5 of 8 buttons. This is a real hardware functionality issue — the
device's report descriptor is broken (reports 5 buttons when 8 exist),
and the driver fixup is needed to make all buttons work. This affects
real users who purchased this trackball.

### Stability and Dependencies

- No dependencies on other commits.
- The `mouse_button_fixup()` function and the entire ELECOM driver
  infrastructure exist in stable trees already.
- The patch is self-contained and applies cleanly.
- The different report descriptor offsets (24, 28, 22, 16 vs 22, 30, 24,
  16 for older HUGE) are correctly derived from the actual descriptor
  dump provided in the commit message.

### Conclusion

This is a textbook device ID addition to an existing driver with a
hardware quirk/fixup. It follows the same pattern as all other ELECOM
devices in the driver, is small and self-contained, fixes a real
hardware issue (only 5 of 8 buttons work), and carries essentially zero
risk of regression to existing devices. This falls squarely into the
"new device IDs / hardware quirks" exception category that is explicitly
allowed in stable.

**YES**

 drivers/hid/Kconfig      |  1 +
 drivers/hid/hid-elecom.c | 16 ++++++++++++++++
 drivers/hid/hid-ids.h    |  3 +++
 drivers/hid/hid-quirks.c |  3 +++
 4 files changed, 23 insertions(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 920a64b66b25b..6ff4a3ad34cbf 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -369,6 +369,7 @@ config HID_ELECOM
 	  - EX-G Trackballs (M-XT3DRBK, M-XT3URBK)
 	  - DEFT Trackballs (M-DT1DRBK, M-DT1URBK, M-DT2DRBK, M-DT2URBK)
 	  - HUGE Trackballs (M-HT1DRBK, M-HT1URBK)
+	  - HUGE Plus Trackball (M-HT1MRBK)
 
 config HID_ELO
 	tristate "ELO USB 4000/4500 touchscreen"
diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index 2003d2dcda7cc..37d88ce57f671 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -5,6 +5,7 @@
  *  - EX-G Trackballs (M-XT3DRBK, M-XT3URBK, M-XT4DRBK)
  *  - DEFT Trackballs (M-DT1DRBK, M-DT1URBK, M-DT2DRBK, M-DT2URBK)
  *  - HUGE Trackballs (M-HT1DRBK, M-HT1URBK)
+ *  - HUGE Plus Trackball (M-HT1MRBK)
  *
  *  Copyright (c) 2010 Richard Nauber <Richard.Nauber@gmail.com>
  *  Copyright (c) 2016 Yuxuan Shui <yshuiv7@gmail.com>
@@ -123,12 +124,25 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 */
 		mouse_button_fixup(hdev, rdesc, *rsize, 22, 30, 24, 16, 8);
 		break;
+	case USB_DEVICE_ID_ELECOM_M_HT1MRBK:
+	case USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AB:
+	case USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC:
+		/*
+		 * Report descriptor format:
+		 * 24: button bit count
+		 * 28: padding bit count
+		 * 22: button report size
+		 * 16: button usage maximum
+		 */
+		mouse_button_fixup(hdev, rdesc, *rsize, 24, 28, 22, 16, 8);
+		break;
 	}
 	return rdesc;
 }
 
 static const struct hid_device_id elecom_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
@@ -142,6 +156,8 @@ static const struct hid_device_id elecom_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK_019B) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AB) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, elecom_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6d8b64872cefe..85ab1ac511096 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -466,6 +466,9 @@
 #define USB_DEVICE_ID_ELECOM_M_HT1URBK_019B	0x019b
 #define USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D	0x010d
 #define USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C	0x011c
+#define USB_DEVICE_ID_ELECOM_M_HT1MRBK	0x01aa
+#define USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AB	0x01ab
+#define USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC	0x01ac
 
 #define USB_VENDOR_ID_DREAM_CHEEKY	0x1d34
 #define USB_DEVICE_ID_DREAM_CHEEKY_WN	0x0004
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 11438039cdb7f..3217e436c052c 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -420,6 +420,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 #if IS_ENABLED(CONFIG_HID_ELECOM)
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC) },
@@ -432,6 +433,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK_019B) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AB) },
 #endif
 #if IS_ENABLED(CONFIG_HID_ELO)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, 0x0009) },
-- 
2.51.0

