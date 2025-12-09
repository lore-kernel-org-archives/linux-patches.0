Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7D7219303;
	Tue,  9 Dec 2025 00:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239415; cv=none; b=eWuWAvnEKlNqJY6pkyCu0QyOmXZSOdN9j/toXPNg41/WmRmQV/DMEqGVHHZebM62MiWihWt2Mz+z00skJhD7i9TNmx/rkgttC3xGj3dEvwBxY92jtdCyw3SHZXjcQp5N155mJjGLLHPsuMY0Y6jL+KhbA8l/R5P14b6wj0RaGIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239415; c=relaxed/simple;
	bh=rPLCsJ7oKMNb8wOUeMVrIrmHBTliVFaFmmYP7IJbl4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BT9+FhEIzy6WMqDxJp/iXY7JQ5B/cBsCEYBbumM77hchqML+I4Jmqtalsg91kWlU7Izv4OjKfAyvpUfjEpi6z70FsgcNl2H/WWH3VOOSfcTg9RdYJ9YRI7lrg2lVLxSx3FXdc5qI70jhDACCszu8yPuu7mqCD27NKw7fmAxYz4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kod4GpEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kod4GpEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88F9C113D0;
	Tue,  9 Dec 2025 00:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239415;
	bh=rPLCsJ7oKMNb8wOUeMVrIrmHBTliVFaFmmYP7IJbl4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kod4GpEQCNMOtOmx15GHmtUx4aicOw2FrRB3XzzQ35KeqEwyp9tl1LQzyoPNuaAJS
	 AstgDWyJC+U+shbyNkSPCnTvd0WWafys9joUmcqzZWq2iB06HmvsfvMwrRM1swfd8Z
	 xTgP32sKV+pUgFcwANRLxZPWVYdUhfKA/pGqjs0/lPLTlwbp4hFitQ2vyZsEM7fvbG
	 1l1yi1Wi/2S7U+rE7SMl1Qkw9LW1JXWGyCwZTXhV2gCd/JoPKp0p/FDJXtiklwk8PU
	 TZi5zORj5ZeRRQG+3cW2SEGn/cnpG9p3IocXEac11D4t1XPBOCleY5CYJ2PnZyL+CR
	 quS3DsVJ+VUuw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Max Chou <max.chou@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] Bluetooth: btusb: Add new VID/PID 0x0489/0xE12F for RTL8852BE-VT
Date: Mon,  8 Dec 2025 19:15:03 -0500
Message-ID: <20251209001610.611575-11-sashal@kernel.org>
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

From: Max Chou <max.chou@realtek.com>

[ Upstream commit 32caa197b9b603e20f49fd3a0dffecd0cd620499 ]

Add the support ID(0x0489, 0xE12F) to usb_device_id table for
Realtek RTL8852BE-VT.

The device info from /sys/kernel/debug/usb/devices as below.

T:  Bus=04 Lev=02 Prnt=02 Port=05 Cnt=01 Dev#= 86 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e12f Rev= 0.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00e04c000001
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

Signed-off-by: Max Chou <max.chou@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: Bluetooth: btusb: Add new VID/PID 0x0489/0xE12F for
RTL8852BE-VT

### 1. COMMIT MESSAGE ANALYSIS

- **Subject**: Adding a new USB Vendor/Product ID for a Realtek
  Bluetooth chip variant
- **No "Cc: stable@vger.kernel.org"** tag present
- **No "Fixes:"** tag present
- Commit message includes detailed device info from
  `/sys/kernel/debug/usb/devices`, confirming this is real hardware
  that's been tested
- Signed off by Realtek engineer (the hardware vendor) and Bluetooth
  maintainer

### 2. CODE CHANGE ANALYSIS

The diff is extremely simple:
```c
+       { USB_DEVICE(0x0489, 0xe12f), .driver_info = BTUSB_REALTEK |
+
BTUSB_WIDEBAND_SPEECH },
```

- **2 lines added** to the `quirks_table[]` static array
- Uses identical `driver_info` flags as the existing RTL8852BE-VT entry
  (`0x0bda, 0x8520`)
- Placed in the appropriate "Realtek 8852BT/8852BE-VT Bluetooth devices"
  section
- No code logic changes whatsoever - just adding an entry to a USB
  device ID table

### 3. CLASSIFICATION

This falls squarely under the **NEW DEVICE IDs** exception, which is
explicitly allowed in stable:

> "Adding PCI IDs, USB IDs, ACPI IDs, etc. to existing drivers - These
are trivial one-line additions that enable hardware support"

This is **not** a new feature. The btusb driver already fully supports
RTL8852BE-VT devices. This simply registers another VID/PID combination
for the same chipset.

### 4. SCOPE AND RISK ASSESSMENT

| Factor | Assessment |
|--------|------------|
| Lines changed | 2 (minimal) |
| Files touched | 1 (`drivers/bluetooth/btusb.c`) |
| Complexity | Trivial - static table entry |
| Risk | **Extremely low** |

- Change only affects devices matching VID 0x0489 / PID 0xe12f
- Cannot regress any existing functionality
- No behavioral changes to the driver code itself

### 5. USER IMPACT

- **Without this patch**: Users with this Bluetooth adapter have non-
  functional hardware
- **With this patch**: The adapter is recognized and works with existing
  Realtek support
- **Severity for affected users**: High - complete loss of Bluetooth
  functionality
- This is a real Realtek product (vendor confirmed via signoff)

### 6. STABILITY INDICATORS

- Submitted by Realtek engineer (Max Chou) - hardware vendor
- Merged by Bluetooth maintainer (Luiz von Dentz)
- Device info in commit message demonstrates the device exists and was
  tested

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The btusb driver with Realtek support (`BTUSB_REALTEK`) exists in all
  stable trees
- `BTUSB_WIDEBAND_SPEECH` flag is also well-established

---

## Summary

This is a textbook example of a commit that should be backported to
stable:

**Benefits**:
- Enables real hardware for real users
- Zero risk of regression (only affects specific VID/PID)
- Trivial 2-line data table addition
- Obviously correct - follows exact same pattern as dozens of other
  entries
- Hardware vendor submitted the patch

**Concerns**:
- No explicit stable tags (common for device ID additions; maintainers
  often omit these for routine changes)

The absence of `Cc: stable` is not concerning for device ID additions -
they're so routine that many maintainers don't bother tagging them, yet
stable maintainers regularly pick them up. This enables users with this
Bluetooth adapter to have working hardware on stable kernels without
requiring a full kernel upgrade.

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index cc03c8c38b16f..a5b73e0d271f3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -585,6 +585,8 @@ static const struct usb_device_id quirks_table[] = {
 	/* Realtek 8852BT/8852BE-VT Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0x8520), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe12f), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek 8922AE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0x8922), .driver_info = BTUSB_REALTEK |
-- 
2.51.0

