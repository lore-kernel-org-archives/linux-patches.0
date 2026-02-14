Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCAD142E83;
	Sat, 14 Feb 2026 21:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104369; cv=none; b=d5HPFWp5Ta0VOxa1bIRW5ZPW+ZQ3FmfWZ07HfS587WgjK46GZieKko01+Wlb5EStoPpFqSRiqmR4b/DD3zdqylELdV+8KSv+NY/jJnVrFrHWEV6khRJGXmM/hRGkkJGW7wT+8pnh0d9HzN4zu+XbAed6O2GbWqLZCl0+9eEV6Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104369; c=relaxed/simple;
	bh=KxQpaXLSBrHxj9U+FtoqjWKOWY/+aw13eFqCSCIlmAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CskVyRh9KkIt7ucM75VhKLcJvaicnF2HPUhOmefrYzpEy27zXFaLGgxFm+zH+ySF0kR03P4Mk2XheRo5J397/P+Y3JahknqGVdigN/qdjuOByqiMkZpvXXMNBTmmSV0DWfr3/8yfFTjWo8RVbLRGUldnKE1RUK+IkPOzi5gg4pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7hQvqsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7hQvqsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0A7C16AAE;
	Sat, 14 Feb 2026 21:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104369;
	bh=KxQpaXLSBrHxj9U+FtoqjWKOWY/+aw13eFqCSCIlmAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7hQvqsUFrRlo/jdRBFFvU+JgqgVUqofjiH78C6Hm3/E8QtflX810Z0MgnjxmJGoG
	 +lEeI4FlrPBSETE5w/DyvG4VZqvevOL8YktxszEAdsmESdgUvBKhSCeHQDpFK5ffh5
	 8c3ZzrGfYFlAl3iR4BnJvtTsW6+x+yZBHqH05uH1SJU4gS9U58AAx54kjiQ2NxqLlA
	 MwgFfgyh6gHivs0duMuKyuKvFvTAa5R9QH2utGp0ghBgEVwDFHPrVMRkwVnt58Zkq5
	 tZTn4K8cFtp1kddtxsEoaGkHVI4inwgtmRWL0EpLZO4GN5b9xQEnasXzZ8gdBUhkLM
	 CqkumgJS8IRMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shell Chen <w27@sorz.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] Bluetooth: btusb: Add new VID/PID for RTL8852CE
Date: Sat, 14 Feb 2026 16:23:11 -0500
Message-ID: <20260214212452.782265-46-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Shell Chen <w27@sorz.org>

[ Upstream commit d9f7c39c6b7548bd70519b241b6c2d1bcc658d4b ]

Add VID:PID 13d3:3612 to the quirks_table.

This ID pair is found in the Realtek RTL8852CE PCIe module
in an ASUS TUF A14 2025 (FA401KM) laptop.

Tested on aforementioned laptop.

The device info from /sys/kernel/debug/usb/devices is listed as below.

T:  Bus=03 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3612 Rev= 0.00
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
I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms

Signed-off-by: Shell Chen <w27@sorz.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Summary

This commit adds a single new USB VID/PID pair (0x13d3:0x3612) to the
`quirks_table[]` in `drivers/bluetooth/btusb.c` for the Realtek
RTL8852CE Bluetooth controller. This device is found in the ASUS TUF A14
2025 (FA401KM) laptop.

### Classification: New Device ID Addition

This falls squarely into the **"NEW DEVICE IDs"** exception category,
which is explicitly listed as appropriate for stable backporting:

> Adding PCI IDs, USB IDs, ACPI IDs, etc. to existing drivers. These are
trivial one-line additions that enable hardware support. Rule: The
driver must already exist in stable; only the ID is new.

### Code Change Analysis

The change is a **2-line addition** (one logical entry) inserting a new
`USB_DEVICE()` entry into the existing RTL8852CE section of the quirks
table:

```c
{ USB_DEVICE(0x13d3, 0x3612), .driver_info = BTUSB_REALTEK |
                                             BTUSB_WIDEBAND_SPEECH },
```

This is identical in structure to all neighboring entries for the same
chip family (RTL8852CE). The vendor 0x13d3 is Azurewave (a common
Realtek module OEM), and there are already multiple 0x13d3 entries for
this exact chip.

### Risk Assessment

- **Risk: Extremely Low.** This is a pure data addition to a device ID
  table. It cannot affect any other device or code path. The only effect
  is that a USB device with this specific VID/PID will now be recognized
  and handled by the btusb driver with the correct Realtek quirks.
- **Without this patch:** Bluetooth on this specific laptop model simply
  does not work.
- **Dependencies:** None. The RTL8852CE support infrastructure already
  exists in all recent stable trees.
- **Tested:** The commit message explicitly states "Tested on
  aforementioned laptop" and includes detailed USB device info
  confirming it works.

### User Impact

This enables Bluetooth functionality on the ASUS TUF A14 2025 laptop.
Without this entry, users of this laptop running stable kernels have no
Bluetooth. This is a real-world hardware enablement fix.

### Stable Criteria

1. **Obviously correct and tested:** Yes - trivial table entry addition,
   explicitly tested on the device.
2. **Fixes a real bug:** Yes - missing device ID means hardware doesn't
   work.
3. **Important issue:** Yes - complete loss of Bluetooth functionality
   on a shipping laptop.
4. **Small and contained:** Yes - 2 lines added to a single file's
   device ID table.
5. **No new features/APIs:** Correct - just enables existing driver for
   new hardware variant.
6. **Applies cleanly:** The change is a simple table entry insertion
   that should apply cleanly to any stable tree containing the RTL8852CE
   section.

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index de9e484efef71..972139729e8fd 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -559,6 +559,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3592), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3612), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe122), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-- 
2.51.0

