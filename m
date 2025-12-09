Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEF021FF55;
	Tue,  9 Dec 2025 00:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239430; cv=none; b=aFcTanHsxQ1r8csV+eU9Adn0qrp7pn6GpGDD6u77Wn7O7UQnT71x80SKSWfnAkK7W70YbNpoZEmkdguGwy5a/G1GQu5QKqghpp6RfmI9vwn618/a8czKRcqPTU2fc9HniJfkLtOnG6ykW4vpggN6So+OrBkJl/ZYUJ8l0gXIq5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239430; c=relaxed/simple;
	bh=mA14ruNO3szL9g1X8tOTLj3a3VtsH9RLuJW+L+/RCmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqkY6Ar465sbn2suHbU8HGXCPjJLoVKjc5pgXV/UdpYk6dRzFDqCT/RffhXP92NVEVjoIioWbeBeTCZmvWNwAYrUP3rbqgpAbfWm4O10/TR0MGPPj2rTIVa61H+fhA7ITxVl+5IKugZlmZenRVSKCBm3jHRsCl8ISw+OqlrehuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olM3tFxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olM3tFxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFB7C4CEF1;
	Tue,  9 Dec 2025 00:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239430;
	bh=mA14ruNO3szL9g1X8tOTLj3a3VtsH9RLuJW+L+/RCmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olM3tFxnaoxotIvmzvIRirMGeZeIY+hJVnE9K0Xs6Wu8iHYYF5ix8icaFtiG9t8pr
	 tCOC9kX/9iq/bvc5XYPr0YWoXmcIOLMPoLy5p1lnaxYYFKeAZINZC+OAv9ZhOBilWO
	 VljPMTaNRXDZ6i4EEHbt14FFqobofcgnc6ycsR0bV7qZtgCJTkEhICDgk23VaNh3nZ
	 by69/lUBQ68/Umz2lfVgjpUSG1UDXfdWzik1Zb8ND2KiNd/51sC9LsUV1aFcYhex72
	 Aa0ajiFrmM/5SjCB6zNUMJ1HyfXExkGK1R6Kmtl0YQRzbIkC4mdjaTY8KS9qJQkR3P
	 1gAFf3glEGn0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chris Lu <chris.lu@mediatek.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] Bluetooth: btusb: MT7922: Add VID/PID 0489/e170
Date: Mon,  8 Dec 2025 19:15:09 -0500
Message-ID: <20251209001610.611575-17-sashal@kernel.org>
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 5a6700a31c953af9a17a7e2681335f31d922614d ]

Add VID 0489 & PID e170 for MediaTek MT7922 USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=06 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e170 Rev= 1.00
S:  Manufacturer=MediaTek Inc.
S:  Product=Wireless_Device
S:  SerialNumber=000000000
C:* #Ifs= 3 Cfg#= 1 Atr=e0 MxPwr=100mA
A:  FirstIf#= 0 IfCount= 3 Cls=e0(wlcon) Sub=01 Prot=01
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=125us
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
E:  Ad=8a(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS=  64 Ivl=125us
I:  If#= 2 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
E:  Ad=8a(I) Atr=03(Int.) MxPS= 512 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS= 512 Ivl=125us

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: Bluetooth: btusb: MT7922: Add VID/PID 0489/e170

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: Adding a new USB Vendor ID (VID) 0x0489 and Product ID
(PID) 0xe170 for a MediaTek MT7922 Bluetooth chip.

**Key Tags**:
- Signed-off-by: Chris Lu from MediaTek (the chip vendor)
- Reviewed-by: Paul Menzel
- Signed-off-by: Luiz Augusto von Dentz (Bluetooth maintainer)

No explicit `Cc: stable@vger.kernel.org` tag, but this is common for
device ID additions which are often handled implicitly.

### 2. CODE CHANGE ANALYSIS

The change is a 2-line addition to the `quirks_table[]` array:
```c
{ USB_DEVICE(0x0489, 0xe170), .driver_info = BTUSB_MEDIATEK |
                                             BTUSB_WIDEBAND_SPEECH },
```

This simply registers a new USB device ID with existing driver flags
(`BTUSB_MEDIATEK` and `BTUSB_WIDEBAND_SPEECH`) that are already fully
supported. The btusb driver already contains full MT7922 support - this
just adds another VID/PID variant to the recognition table.

### 3. CLASSIFICATION

This is a **NEW DEVICE ID** addition - one of the explicitly allowed
exception categories for stable backports:
- Adding a USB VID/PID to an existing, well-tested driver
- Trivial one-entry addition to a device table
- The driver code for MT7922 already exists; only recognition is missing

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Lines changed | 2 |
| Files touched | 1 |
| Complexity | Minimal - static table entry |
| Risk | **Extremely low** |

The change can only affect USB devices with VID=0x0489 and PID=0xe170.
Users without this specific hardware are completely unaffected. This is
about as low-risk as a kernel patch can be.

### 5. USER IMPACT

- **Affected users**: Those with this specific MediaTek MT7922 Bluetooth
  variant
- **Severity without fix**: Bluetooth hardware is completely non-
  functional (driver doesn't recognize the device)
- **Impact**: HIGH for affected users - their Bluetooth doesn't work at
  all

The commit includes detailed `/sys/kernel/debug/usb/devices` output
showing real hardware, indicating this comes from actual user/vendor
testing.

### 6. STABILITY INDICATORS

- Authored by MediaTek (chip vendor) with direct hardware knowledge
- Reviewed by community member
- Signed off by the Bluetooth subsystem maintainer
- Follows established pattern of many similar MT7922 device ID entries
  visible in the diff context

### 7. DEPENDENCY CHECK

- **No dependencies**: This is a self-contained table entry addition
- **Existing support**: The BTUSB_MEDIATEK and BTUSB_WIDEBAND_SPEECH
  flags and MT7922 support code exist in all recent stable trees
- **Clean application**: Should apply cleanly to any stable tree that
  has MT7922 support

### CONCLUSION

This commit is a textbook example of what SHOULD be backported to
stable:

1. **Falls under Device ID Exception**: Explicitly allowed category for
   stable
2. **Fixes Real User Problem**: Enables Bluetooth hardware that would
   otherwise be completely non-functional
3. **Minimal Risk**: 2-line table entry addition, cannot break anything
   else
4. **No New Features**: Just enables existing driver for new hardware
   variant
5. **Well-Reviewed**: Proper sign-offs from vendor and maintainer
6. **Clear Benefit**: Users with this hardware get working Bluetooth

The lack of explicit stable tag is typical for device ID additions -
stable maintainers routinely accept these. The benefit (enabling
hardware) far outweighs the near-zero risk.

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 595afeff4afb5..9b199da1c0d67 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -687,6 +687,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe153), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe170), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04ca, 0x3804), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04ca, 0x38e4), .driver_info = BTUSB_MEDIATEK |
-- 
2.51.0

