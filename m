Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2748311C2C;
	Sat, 14 Feb 2026 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104361; cv=none; b=C0WcBAljOVbGyLOb9VI5ctan3UGnysSHzIrxEs2DR720lO2uRUup2t9bXOOD1yXSSAxQz6ucpfYRlt2KIm71td90HPEfL8SAcLcVRuNtwSFQqqy7LuHvWIQScUkCDsDcY/ITrkyorGHxALi5a8BfMuv/boY0I/4WYe4Lr7K9zzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104361; c=relaxed/simple;
	bh=wU+LQ22pYsQ+C1uiK5gpxnqaGGJ8G8GMZIj026Npz1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R4XH6yzExOzL3eipK6GQLze/38FW3Xgz3zuxHgBzmpnsiUJX+qQYMk4jYdfVR5wrbmFrjRZ20uVbHb8JMoTfP0GzBrqQy3FpcZOPMwiZ8T7TxAbJPJnhj89SIwoW7wfT52osVi/fYilXm2TTQALSwgCAYHlwgEtOQ7hxiBzzT/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onx51MqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onx51MqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08E0C19422;
	Sat, 14 Feb 2026 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104360;
	bh=wU+LQ22pYsQ+C1uiK5gpxnqaGGJ8G8GMZIj026Npz1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onx51MqIzjBmqQRcw5SjMVhYuV2rNEfqFNzPqwrVRY5yfRVuU2lXb9rjFTarTkUA9
	 MvtGLlnA53vswJzS7slXFaNwpv2dgJyPIOe6bfQ/QRsSZG2HFK6lseWGGlj9Mt1Kz5
	 Qtp10n/lCoOdIz1A4YIfhMC/YeKj9ykRjisUf5Q768hu8evqrGMl7fJ2x3sHvMVWf4
	 P6YZONXReBhCMxtPpbR5dmXFK6GIPyoF76HIm76Y5n4PPRklba5Z8jCu3s7d2piTsd
	 UtiNfkLb5zruiAGjEH6i20wilu3I9skstqMutWrjJuBaE6Jan+8dR/hgIVwe+uxDbp
	 /7dgQyJhEtQjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bluecross <elantsew.andrew@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] Bluetooth: btusb: Add support for MediaTek7920 0489:e158
Date: Sat, 14 Feb 2026 16:23:05 -0500
Message-ID: <20260214212452.782265-40-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bluecross <elantsew.andrew@gmail.com>

[ Upstream commit 2630bcc8343a9d2a38dc1793068e6754b3156811 ]

Add support for MediaTek7920 0489:e158

/sys/kernel/debug/usb/devices reports for that device:

T:  Bus=03 Lev=01 Prnt=01 Port=02 Cnt=03 Dev#=  5 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e158 Rev= 1.00
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

Signed-off-by: Andrew Elatsev <elantsew.andrew@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis
This commit adds a new USB device ID (0489:e158) for a MediaTek MT7920
Bluetooth adapter to the `btusb` driver. The commit message includes the
full USB device descriptor dump from `/sys/kernel/debug/usb/devices`,
confirming this is a real hardware device (manufactured by MediaTek
Inc., identified as "Wireless_Device").

### Code Change Analysis
The change is a **two-line addition** to the `quirks_table[]` array in
`drivers/bluetooth/btusb.c`:

```c
{ USB_DEVICE(0x0489, 0xe158), .driver_info = BTUSB_MEDIATEK |
                                             BTUSB_WIDEBAND_SPEECH },
```

This is added in the "Additional MediaTek MT7920 Bluetooth devices"
section, alongside other MT7920 device IDs that already exist
(0x0489:0xe134, 0x0489:0xe135, 0x13d3:0x3620, 0x13d3:0x3621,
0x13d3:0x3622). The new entry uses the exact same `driver_info` flags as
all other MT7920 entries.

### Classification
This is a **new device ID addition** to an existing, well-established
driver. This falls squarely into the "NEW DEVICE IDs" exception category
that is explicitly allowed and encouraged for stable backports.

### Scope and Risk Assessment
- **Lines changed**: 2 lines added (one table entry)
- **Files touched**: 1 file (`drivers/bluetooth/btusb.c`)
- **Risk**: Essentially zero. This only adds a USB ID match entry to a
  device table. It cannot affect any other device or code path. The
  driver (btusb with MediaTek support) already exists and works for the
  other MT7920 variants.
- **Complexity**: Trivial — it's a data table entry, not logic.

### User Impact
Without this entry, users with the MediaTek MT7920 variant (vendor
0x0489, product 0xe158) have **no Bluetooth functionality at all** — the
kernel simply won't bind the btusb driver to this device. With this
entry, Bluetooth works out of the box. This is a direct hardware
enablement fix.

### Stability Indicators
- The same pattern (USB_DEVICE + BTUSB_MEDIATEK | BTUSB_WIDEBAND_SPEECH)
  is used by dozens of other MediaTek entries in this table, all well-
  tested.
- The commit was accepted by the Bluetooth subsystem maintainer (Luiz
  Augusto von Dentz).

### Dependencies
None. This is a self-contained, single-entry table addition with no
dependencies on other commits.

### Conclusion
This is a textbook example of a stable-worthy device ID addition:
- Trivial two-line change to an existing device table
- Zero risk of regression to any other device or code path
- Enables hardware that otherwise doesn't work at all
- Uses the exact same flags as all other MT7920 entries
- The btusb driver and MediaTek support exist in all active stable trees

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index ded09e94d296d..646de80c7e7be 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -637,6 +637,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3622), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe158), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional MediaTek MT7921 Bluetooth devices */
 	{ USB_DEVICE(0x0489, 0xe0c8), .driver_info = BTUSB_MEDIATEK |
-- 
2.51.0

