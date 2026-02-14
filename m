Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057BB194098;
	Sat, 14 Feb 2026 01:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031120; cv=none; b=ALiINabBdcv86EevAD7cbZoEpXOH4mDi0RjY8oTPHR10sJEmJYi/IFRwQd/qUXzPTjYtu+wCnNu6MdVFLxfBNMOV9Nqxikf2oF71qcINkR40za81hFB+yhbdnuj7aeJLtSbd13I2c2kKK0Lgb8gxCb+lQ5DgO7lBkXk2XhTHQdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031120; c=relaxed/simple;
	bh=WtDfGtmmYtFguOzEXYrv/v+sKkiG5xUD0xOLBtOCIhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCYFe+dsDfedYZ+g84y/SReHse6eW6V71FRpvKJMgucF9PaPahuxs+epjb61nwXKf8ecob1y23DjyjW3k4TowTqyiPxinR7WpUWefNKjknN008OaUlPx7/BEbh2/fg8mkhAC1hLd3+bADkQ9qUWll2F+tbpg4T4RnP4MWPsF5wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2JDXdnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2JDXdnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB881C16AAE;
	Sat, 14 Feb 2026 01:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031119;
	bh=WtDfGtmmYtFguOzEXYrv/v+sKkiG5xUD0xOLBtOCIhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2JDXdnKrBNMIxBve1Q9fp1kMPVoImlqYnIS7ksPpvbXbr1HQfooqg8CFn2M8ppz0
	 eJ7Ki4BWu/uUE7SjAqSq2ZRPL/cBI26oaDx/lgxcdRDogBNHyBGwQEwVUpdD5z08KF
	 jEzRMZYaLI/MGrsslousL9WkvATboTyQPjeJ/MQwZ4bQC3NYd6/KP2YxbcUyDFjZEJ
	 rSi0We5MT/ihaHC3PNzY7FwogdLu+BfuLO1AqldekgPRYOokBgxX1DKNIm9Noyb1+1
	 4hTq1ku6uJ39I16zNO4eG81xpdhcuiCRimwaYs+b/GOVVvHuRtRh0U3Mosak0q+pz5
	 mcyUyUXwNGRVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Howard <blhoward2@gmail.com>,
	Kris Fredrick <linux.baguette800@slmail.me>,
	Andrei Shumailov <gentoo1993@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] HID: multitouch: add quirks for Lenovo Yoga Book 9i
Date: Fri, 13 Feb 2026 19:59:10 -0500
Message-ID: <20260214010245.3671907-70-sashal@kernel.org>
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

From: Brian Howard <blhoward2@gmail.com>

[ Upstream commit 822bc5b3744b0b2c2c9678aa1d80b2cf04fdfabf ]

The Lenovo Yoga Book 9i is a dual-screen laptop, with a single composite
USB device providing both touch and tablet interfaces for both screens.
All inputs report through a single device, differentiated solely by report
numbers. As there is no way for udev to differentiate the inputs based on
USB vendor/product ID or interface numbers, custom naming is required to
match against for downstream configuration. A firmware bug also results
in an erroneous InRange message report being received after the stylus
leaves proximity, blocking later touch events. Add required quirks for
Gen 8 to Gen 10 models, including a new quirk providing for custom input
device naming and dropping erroneous InRange reports.

Signed-off-by: Brian Howard <blhoward2@gmail.com>
Tested-by: Brian Howard <blhoward2@gmail.com>
Tested-by: Kris Fredrick <linux.baguette800@slmail.me>
Reported-by: Andrei Shumailov <gentoo1993@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220386
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here is my complete analysis:

---

## Commit Analysis: HID: multitouch: add quirks for Lenovo Yoga Book 9i

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and well-structured. Key signals:
- **"firmware bug"** explicitly mentioned — erroneous InRange reports
  block touch events
- **Closes: bugzilla.kernel.org/show_bug.cgi?id=220386** — tracked
  kernel bug
- **Reported-by: Andrei Shumailov** — user-reported real-world issue
- **Tested-by** from both the author (Brian Howard) and another user
  (Kris Fredrick) — multiple testers
- **Signed-off-by: Jiri Kosina** — accepted by HID subsystem maintainer

The Lenovo Yoga Book 9i is a dual-screen laptop shipping to consumers.
All touch/stylus inputs are multiplexed through a single USB composite
device.

### 2. CODE CHANGE ANALYSIS

The commit makes changes in **two files** with **73 lines added**:

**a) `drivers/hid/hid-ids.h` — 1 line:**
Adds `USB_DEVICE_ID_LENOVO_YOGABOOK9I 0x6161`. Standard device ID
addition.

**b) `drivers/hid/hid-multitouch.c` — 72 lines across 5 insertion
points:**

1. **New quirk flag** (`MT_QUIRK_YOGABOOK9I BIT(24)`) — follows the
   existing pattern (BIT(23) is `MT_QUIRK_APPLE_TOUCHBAR`).

2. **New device class** (`MT_CLS_YOGABOOK9I 0x0115`) — standard pattern,
   same as `MT_CLS_APPLE_TOUCHBAR 0x0114`, `MT_CLS_SIS 0x0457`, etc.

3. **Class definition in `mt_classes[]`** (~8 lines) — combines existing
   quirk flags (`MT_QUIRK_ALWAYS_VALID`, `MT_QUIRK_FORCE_MULTI_INPUT`,
   `MT_QUIRK_SEPARATE_APP_REPORT`, `MT_QUIRK_HOVERING`) plus the device-
   specific `MT_QUIRK_YOGABOOK9I`. Sets `export_all_inputs = true`. This
   is the exact same pattern used by many existing classes (e.g.,
   `MT_CLS_WIN_8_FORCE_MULTI_INPUT`).

4. **Firmware bug workaround in `mt_report()`** (~30 lines) — **THE
   CRITICAL FIX**: After the stylus leaves proximity, the device
   firmware erroneously sends an all-zero report with InRange set. This
   report is consumed by the multitouch stack and blocks subsequent
   touch events. The fix detects these bogus reports (all relevant
   digitizer fields — InRange, TipSwitch, BarrelSwitch, BarrelSwitch2,
   ContactID, TiltX, TiltY — are zero) and drops them by returning
   early. Without this fix, **touch input becomes non-functional** after
   stylus use.

5. **Custom naming in `mt_input_configured()`** (~20 lines) — Maps
   report IDs to human-readable names (e.g., report 48→"Touchscreen
   Top", 56→"Touchscreen Bottom", 20→"Stylus Top", 40→"Stylus Bottom",
   80→"Emulated Touchpad"). Since all inputs come through a single USB
   device with no interface differentiation, udev has **no other way**
   to distinguish which input corresponds to which physical screen.
   Without this, the dual-screen touchscreen/stylus configuration is
   effectively impossible.

6. **Device ID table entry** (~6 lines) — Standard `HID_DEVICE()` entry
   mapping `USB_VENDOR_ID_LENOVO` + `USB_DEVICE_ID_LENOVO_YOGABOOK9I` to
   `MT_CLS_YOGABOOK9I`.

### 3. CLASSIFICATION

This is a **hardware quirk/workaround**, which falls squarely under the
"QUIRKS and WORKAROUNDS" stable exception:
- Fixes firmware-induced bug that blocks touch events (bug fix)
- Adds device-specific naming for a multiplexed USB device (hardware
  workaround for udev differentiation)
- Uses the well-established `hid-multitouch` quirk framework
- Pattern is identical to Apple Touch Bar, ASUS, SIS, Razer Blade
  Stealth, Smart Tech, and many other device-specific quirk additions

### 4. SCOPE AND RISK ASSESSMENT

**Scope**: 73 lines added across 2 files. All changes are behind a
**device-specific quirk flag** (`MT_QUIRK_YOGABOOK9I`) that is **only
activated** for USB VID:PID `0x17ef:0x6161` (Lenovo Yoga Book 9i).

**Risk**: **EXTREMELY LOW**. The changes:
- Are only triggered for one specific USB device ID
- Do not modify any common code paths
- Do not change behavior for any other hardware
- Use only existing framework constructs (`mt_classes[]` entries, quirk
  flags, `mt_report()` filtering, `mt_input_configured()` naming)
- Are well-tested by multiple users

**Dependencies**: The commit is self-contained. It uses standard HID
definitions (`HID_DG_INRANGE`, `HID_DG_TIPSWITCH`, etc.) and `hid-
multitouch` structures that exist in all current stable trees (v6.1,
v6.6, v6.12). The `for (int ...)` C11 syntax is valid in all stable
trees (kernel uses `-std=gnu11` since v5.18+). The only backport
adjustment needed is the context around BIT(23)/BIT(24) numbering — in
stable trees without `MT_QUIRK_APPLE_TOUCHBAR` (v6.12 and earlier), the
BIT number would need adjustment from 24 to 23. This is a trivial
context fixup.

### 5. USER IMPACT

**HIGH for affected users**: The Lenovo Yoga Book 9i (Gen 8-10) is a
commercially available dual-screen laptop. Without this fix:
- Touch input **stops working** after stylus use (firmware InRange bug)
- Both screens cannot be independently configured (no input
  differentiation)

The bugzilla (#220386) and multiple Reported-by/Tested-by tags confirm
this affects real users.

### 6. STABILITY INDICATORS

- Tested-by from author (Brian Howard) and second tester (Kris Fredrick)
- Signed-off by HID subsystem maintainer (Jiri Kosina)
- Kernel bugzilla with tracking
- Follows well-established pattern in hid-multitouch with many precedent
  quirk additions

### 7. DEPENDENCY CHECK

No dependencies on other patches. The commit is completely self-
contained. All referenced symbols (`HID_DG_INRANGE`, `HID_DG_TIPSWITCH`,
`mt_find_report_data`, `rdata->application->quirks`, `hi->report->id`,
etc.) exist in all current stable kernel trees. Minor context adjustment
may be needed for older stable trees lacking the Apple Touch Bar quirk.

### Verdict

This commit fixes a real firmware bug that **blocks touch events** on
the Lenovo Yoga Book 9i, making the device partially non-functional. It
also provides necessary input naming for the dual-screen device to be
properly configurable. All changes are device-specific hardware quirks
behind a USB VID:PID-gated quirk flag with zero risk to other devices.
The commit follows the well-established hid-multitouch quirk pattern, is
tested by multiple users, and is accepted by the subsystem maintainer.
This is textbook "hardware quirk for a broken device" — exactly the type
of change stable trees are designed to accept.

**YES**

 drivers/hid/hid-ids.h        |  1 +
 drivers/hid/hid-multitouch.c | 72 ++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 9c2bf584d9f6f..5a18cb41e6d79 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -841,6 +841,7 @@
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 #define USB_DEVICE_ID_LENOVO_X12_TAB	0x60fe
 #define USB_DEVICE_ID_LENOVO_X12_TAB2	0x61ae
+#define USB_DEVICE_ID_LENOVO_YOGABOOK9I	0x6161
 #define USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E	0x600e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index b1c3ef1290587..f21850f7d89e4 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -76,6 +76,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
 #define MT_QUIRK_ORIENTATION_INVERT	BIT(22)
 #define MT_QUIRK_APPLE_TOUCHBAR		BIT(23)
+#define MT_QUIRK_YOGABOOK9I		BIT(24)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -231,6 +232,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_RAZER_BLADE_STEALTH		0x0112
 #define MT_CLS_SMART_TECH			0x0113
 #define MT_CLS_APPLE_TOUCHBAR			0x0114
+#define MT_CLS_YOGABOOK9I			0x0115
 #define MT_CLS_SIS				0x0457
 
 #define MT_DEFAULT_MAXCONTACT	10
@@ -427,6 +429,14 @@ static const struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_CONTACT_CNT_ACCURATE,
+	},
+		{ .name = MT_CLS_YOGABOOK9I,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_FORCE_MULTI_INPUT |
+			MT_QUIRK_SEPARATE_APP_REPORT |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_YOGABOOK9I,
+		.export_all_inputs = true
 	},
 	{ }
 };
@@ -1576,6 +1586,38 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
 	if (rdata && rdata->is_mt_collection)
 		return mt_touch_report(hid, rdata);
 
+	/* Lenovo Yoga Book 9i requires consuming and dropping certain bogus reports */
+	if (rdata && rdata->application &&
+		(rdata->application->quirks & MT_QUIRK_YOGABOOK9I)) {
+
+		bool all_zero_report = true;
+
+		for (int f = 0; f < report->maxfield && all_zero_report; f++) {
+			struct hid_field *fld = report->field[f];
+
+			for (int i = 0; i < fld->report_count; i++) {
+				unsigned int usage = fld->usage[i].hid;
+
+				if (usage == HID_DG_INRANGE ||
+					usage == HID_DG_TIPSWITCH ||
+					usage == HID_DG_BARRELSWITCH ||
+					usage == HID_DG_BARRELSWITCH2 ||
+					usage == HID_DG_CONTACTID ||
+					usage == HID_DG_TILT_X ||
+					usage == HID_DG_TILT_Y) {
+
+					if (fld->value[i] != 0) {
+						all_zero_report = false;
+						break;
+					}
+				}
+			}
+		}
+
+		if (all_zero_report)
+			return;
+	}
+
 	if (field && field->hidinput && field->hidinput->input)
 		input_sync(field->hidinput->input);
 }
@@ -1772,6 +1814,30 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 		break;
 	}
 
+	/* Lenovo Yoga Book 9i requires custom naming to allow differentiation in udev */
+	if (hi->report && td->mtclass.quirks & MT_QUIRK_YOGABOOK9I) {
+		switch (hi->report->id) {
+		case 48:
+			suffix = "Touchscreen Top";
+			break;
+		case 56:
+			suffix = "Touchscreen Bottom";
+			break;
+		case 20:
+			suffix = "Stylus Top";
+			break;
+		case 40:
+			suffix = "Stylus Bottom";
+			break;
+		case 80:
+			suffix = "Emulated Touchpad";
+			break;
+		default:
+			suffix = "";
+			break;
+		}
+	}
+
 	if (suffix) {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
@@ -2277,6 +2343,12 @@ static const struct hid_device_id mt_devices[] = {
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X12_TAB2) },
 
+	/* Lenovo Yoga Book 9i */
+	{ .driver_data = MT_CLS_YOGABOOK9I,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_YOGABOOK9I) },
+
 	/* Logitech devices */
 	{ .driver_data = MT_CLS_NSMU,
 		HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH_WIN_8,
-- 
2.51.0

