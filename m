Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EFD2C21DB;
	Tue,  9 Dec 2025 00:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239483; cv=none; b=U2PI+GuPOvn0esx5e2ppFgRu8SSQyRK0SGxhTZ+sTBYn/Zeq8FhPNbokQn1UlpFa8aKTQgDgp7j4N6elNgU1bmaOeLkWUChXeMHFcpvsdke1BvnN4prasa0MFGYg65h0tDIhgIkABHfPDCVedoVl5DPqjqSPP6CHb/hA7Purbqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239483; c=relaxed/simple;
	bh=uR8napX9KZeuBCSbLJOTeRpPBJvBLislxq4J0wu0pW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTDnfrtcoz10hlGJA5+LDc6zayY3JptHDNzZTZi2oCFqoyKNiO7weCazxeNqin4R9k6A3AdbzpNhPsMPldkmr3I09VZWwI49c0eQ0lTtSuAmezJpvDLLJNWv7PZ3Wxftl+HMRSD52+uVBaks+/EgXl/qWSLHFvRSnwLEuJCZgMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FpTjKh0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FpTjKh0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90629C113D0;
	Tue,  9 Dec 2025 00:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239482;
	bh=uR8napX9KZeuBCSbLJOTeRpPBJvBLislxq4J0wu0pW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpTjKh0/B9B54puuEzd+AjW4ErzJ/ag7fcEaMf9LS4WbM3AxqjaCIf+pd204EnaeY
	 wLxHzadhDHgc/Ga1R1gNeVvXmBZwV4icGeg1wjJuV2kjvaq8AJQxc+syL1BOVKyJua
	 c/KgEUl/Az9nJ00HRHA4IAB6mRImVDdFbltQsVx1b3OKJJKwHZLMp0RjjbX1lSk9CM
	 UD7ktfxEyjmzRbMyqAGF9hfjh8P3f6434C4U+DOpgfVU44IwiUXFHn2py52g1ejdHB
	 lHc0iDYY9D7z/X6OLiyonzDlMuudR1i4ayaOQlqUIYDwzGs36Dd+FeclGMD8FCK7y2
	 v4YonkqPCHtNg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chingbin Li <liqb365@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] Bluetooth: btusb: Add new VID/PID 2b89/6275 for RTL8761BUV
Date: Mon,  8 Dec 2025 19:15:28 -0500
Message-ID: <20251209001610.611575-36-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Chingbin Li <liqb365@163.com>

[ Upstream commit 8dbbb5423c0802ec21266765de80fd491868fab1 ]

Add VID 2b89 & PID 6275 for Realtek RTL8761BUV USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  6 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2b89 ProdID=6275 Rev= 2.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00E04C239987
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Chingbin Li <liqb365@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: Bluetooth: btusb: Add new VID/PID 2b89/6275 for
RTL8761BUV

### 1. COMMIT MESSAGE ANALYSIS

- **Subject:** Adding a USB VID (0x2b89) / PID (0x6275) for a Realtek
  RTL8761BUV Bluetooth chip
- **No "Fixes:" tag** - This is not fixing a code bug
- **No "Cc: stable@vger.kernel.org"** - Not explicitly tagged for stable
- **Evidence of real hardware:** The commit includes detailed USB device
  information from `/sys/kernel/debug/usb/devices`, showing the
  contributor has physical access to the device

### 2. CODE CHANGE ANALYSIS

The change is minimal - just 2 lines added to
`drivers/bluetooth/btusb.c`:

```c
{ USB_DEVICE(0x2b89, 0x6275), .driver_info = BTUSB_REALTEK |
                                             BTUSB_WIDEBAND_SPEECH },
```

This entry:
- Is added to the `quirks_table[]` array in the "Additional Realtek
  8761BUV Bluetooth devices" section
- Uses the exact same pattern and flags as other RTL8761BUV entries
- The same vendor ID (0x2b89) already exists with a different product ID
  (0x8761)

### 3. CLASSIFICATION

This is a **NEW DEVICE ID** addition - one of the explicitly allowed
exceptions for stable trees:
- Adds a USB ID to an existing, mature driver (btusb)
- The btusb driver already fully supports RTL8761BUV chips
- Only the device ID is new, not any driver functionality

### 4. SCOPE AND RISK ASSESSMENT

| Factor | Assessment |
|--------|------------|
| Lines changed | 2 |
| Files touched | 1 |
| Complexity | Trivial - mechanical ID table addition |
| Risk of regression | Essentially zero |
| Pattern precedent | Exact same pattern used by dozens of other entries
|

The risk is **extremely low** because:
- The new entry cannot affect any existing devices
- It only matches the specific VID/PID combination
- All the handling code (BTUSB_REALTEK, BTUSB_WIDEBAND_SPEECH) is
  already tested with similar hardware

### 5. USER IMPACT

- **Affected users:** Anyone with a Bluetooth USB adapter using VID
  0x2b89 and PID 0x6275
- **Without the patch:** The device is not recognized, Bluetooth does
  not work at all
- **With the patch:** Full Bluetooth functionality via the mature btusb
  driver

This is a complete enablement fix for affected hardware.

### 6. STABILITY INDICATORS

- Signed-off-by from the Bluetooth subsystem maintainer (Luiz Augusto
  von Dentz)
- Follows established patterns exactly
- USB device info in commit shows real-world testing on actual hardware

### 7. DEPENDENCY CHECK

- **No dependencies** on other commits
- The required flags (BTUSB_REALTEK, BTUSB_WIDEBAND_SPEECH) have existed
  for years
- Will apply cleanly to all stable trees with btusb support

---

## Summary

This commit is a textbook example of a stable-appropriate device ID
addition:

**Pros:**
- Trivial 2-line change adding a USB VID/PID
- Zero risk of regression - only affects the specific new device
- Enables real hardware for users who otherwise have no Bluetooth
- Follows exact pattern used by many other stable-backported device ID
  additions
- Already merged by subsystem maintainer

**Cons:**
- No explicit stable tag (but not required for device ID additions)
- No Fixes: tag (appropriate - this isn't fixing broken code)

**Risk vs Benefit:** Near-zero risk with clear benefit for hardware
owners.

Per the stable kernel rules, device ID additions to existing drivers are
explicitly appropriate for backporting. They are small, obviously
correct, fix a real user problem (hardware not working), and cannot
introduce regressions.

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9b199da1c0d67..cc03c8c38b16f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -785,6 +785,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2b89, 0x8761), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x2b89, 0x6275), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.51.0

