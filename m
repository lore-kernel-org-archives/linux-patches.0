Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA4443E9D8;
	Tue, 10 Mar 2026 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133324; cv=none; b=VmawsGWxap/wYYBQyGn8mcymLMdXz1acukKBsOTpoStWI0Oubo2PCEqtKFoEy5f00JEgaE/4HccvWFq/y+qJbuJb+BDK77nOihKXSq6WQgLRuED2j5gFQl8PhZ1+3LlE8NI8b9iSjhCCDBpZez2virS20ZQlOYxnnsauKLaHMjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133324; c=relaxed/simple;
	bh=jvcR/0hMrsZWfAV8BjBAREiSkfnnyOlh0e97KIXxWXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DifMzHZrrhWHfEZnqHRrr0iFRinWjwUP43lbZXybDAeU0Buugj5YkkUcPrf3NFrJ2IkIcxQowvRpcM+8h/1xcjncp/OFzSfe82bW0c63KUdDfaODJAyuMDTPXY9Knnf9ejetcV4AG7pzaU6/dxzubKLK/XuQAgkta97UaSqxf40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imMtp+OM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imMtp+OM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D4DC2BC87;
	Tue, 10 Mar 2026 09:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133323;
	bh=jvcR/0hMrsZWfAV8BjBAREiSkfnnyOlh0e97KIXxWXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imMtp+OMjeUUdgqgQ3blAb76MpT0sWBs7KoPsBgmLIhS+uu2YOUHMYrp/UzlbmxQO
	 7akolXFjzDVa6vzIMOoMGIoFz7361EauyJ7VLMU2IlC3gT7V0pxXRsQFM8Fnpll9uX
	 RjD1RA1khyr1+ZpJLGJdXoYevUDVZStE3h7PapJBLeaam0sk4zRDmL+3dDe9VDsFK0
	 7rUJrQ6qR+LXBRb7ZstVkJwwqo5FOWjxoNhQTxpikkTJijXW+WcjYrZxQ/wte3RIfv
	 lt6YvNM4d1LTPZTpJIl7D/EqRwcf6qaLrh1Agnp17jJj+AotJohB5wwccoWktBTG3h
	 Muw4OhVsazBtw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] HID: asus: add xg mobile 2023 external hardware support
Date: Tue, 10 Mar 2026 05:01:12 -0400
Message-ID: <20260310090145.2709021-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 377f8e788945d45b012ed9cfc35ca56c02e86cd8 ]

XG mobile stations have the 0x5a endpoint and has to be initialized:
add them to hid-asus.

Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does
This commit adds a new USB device ID (`USB_DEVICE_ID_ASUSTEK_XGM_2023 =
0x1a9a`) for the ASUS XG Mobile 2023 docking station to the hid-asus
driver. The change consists of:
1. Defining the device ID constant in `hid-ids.h` (1 line)
2. Adding the device to the `asus_devices[]` table in `hid-asus.c` (3
   lines, no quirk flags)

### Classification: New Device ID Addition
This is a textbook **new device ID addition to an existing driver**. The
hid-asus driver already exists in all stable kernel trees. Only the USB
device ID entry is new.

The commit message states: "XG mobile stations have the 0x5a endpoint
and has to be initialized: add them to hid-asus." This means the
device's HID interface (with report ID 0x5a = `FEATURE_KBD_REPORT_ID`)
needs the hid-asus driver to bind to it, rather than the generic HID
driver, for the device to function properly.

### Device entry details
The entry has **no quirk flags** set. This means minimal special
handling — the device simply needs to be claimed by hid-asus (rather
than generic HID) for proper initialization and event handling. The hid-
asus driver provides baseline handling that differs from the generic HID
driver, including filtering of `FEATURE_KBD_LED_REPORT_ID` events in the
raw_event handler.

### Risk assessment
- **Scope**: 4 lines changed across 2 files
- **Risk**: Extremely low — this only affects devices with USB VID/PID
  `0x0b05:0x1a9a`. No existing device behavior is modified.
- **Self-contained**: Yes — no dependencies on other commits. The change
  only requires the existing hid-asus driver infrastructure.

### Stable kernel criteria
- **Obviously correct**: Yes — adding a device ID to an existing table
  with established patterns
- **Fixes real issue**: Enables hardware support for users with XG
  Mobile 2023 docking stations
- **Small and contained**: 4 lines total
- **No new features/APIs**: Just a device ID, no new quirk mechanisms or
  user-visible interfaces
- **Exception category**: New Device IDs — explicitly listed as
  appropriate for stable

### Verification
- Read `asus_probe()` at hid-asus.c:1127-1248 to confirm behavior with
  zero quirk flags — device goes through standard HID parse/start path
  and gets named "Asus Keyboard"
- Confirmed `USB_DEVICE_ID_ASUSTEK_XGM_2023` is only defined and used in
  these two files (self-contained)
- Confirmed the device table entry follows the exact same pattern as
  other entries in `asus_devices[]` (e.g., `USB_DEVICE_ID_ASUS_AK1D` and
  `USB_DEVICE_ID_ASUS_MD_5110` also have no quirk flags)
- Confirmed `FEATURE_KBD_REPORT_ID` is defined as `0x5a` at line 51,
  matching the commit message about the 0x5a endpoint
- No quirk flag dependencies — the entry is independent of any other
  code changes

**YES**

 drivers/hid/hid-asus.c | 3 +++
 drivers/hid/hid-ids.h  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 8487332bf43b0..b1ad4e9f20c85 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1404,6 +1404,9 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD | QUIRK_ROG_ALLY_XPAD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
+	    USB_DEVICE_ID_ASUSTEK_XGM_2023),
+	},
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD),
 	  QUIRK_ROG_CLAYMORE_II_KEYBOARD },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 85ab1ac511096..7fd67745ee010 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -229,6 +229,7 @@
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X		0x1b4c
 #define USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD	0x196b
 #define USB_DEVICE_ID_ASUSTEK_FX503VD_KEYBOARD	0x1869
+#define USB_DEVICE_ID_ASUSTEK_XGM_2023	0x1a9a
 
 #define USB_VENDOR_ID_ATEN		0x0557
 #define USB_DEVICE_ID_ATEN_UC100KM	0x2004
-- 
2.51.0

