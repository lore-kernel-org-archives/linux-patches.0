Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29B114286;
	Wed,  4 Jun 2025 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998550; cv=none; b=aWKvMfrZfUO6sUm6vqlu6p5HLb2DQU7iPWSqdSAM89sZQFA2uG4dlXMSrrEt9OAYb9k4GXuhCh0Jweqd1d1YkV5Gr3O1QEWBO6MMOeHMuTLN0TTrh9LVuWP54+P7pZI3ipWkDwTMaun9RbOFRWZ4tqcXF+ZYI8DvqTAwCDiTJko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998550; c=relaxed/simple;
	bh=4MnvX19RoLhPZ8OHATKGxouldE2OkP41gq2zpNz3RkM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=COsfVx6KARhaFNnyQhcSacEI/2r8IOg1jiBUuuRbMvLVGyl88pCUaXohlV0+97A/xbjcJWIG0Olh1LVGq/tgMQsEpKqhOQUui7xbxsdUlhHdA0MEFJWOxIg75Nj6h/wfoBnBzz3Bve8bl9/thlMeUqG6nA9ApGGygQIf1Qx1fWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=co2XTrP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="co2XTrP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615C2C4CEED;
	Wed,  4 Jun 2025 00:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998549;
	bh=4MnvX19RoLhPZ8OHATKGxouldE2OkP41gq2zpNz3RkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=co2XTrP6GZTDuumCdQI2iTrwMaIpkltSmJ3XwLzbTgxfKmjed0/lzHIA+ayFS8Pv4
	 yRig+mqga+yZpER2uI7Sriw+5Kd7BBuAC60Ovxnt0cCoeqOojaOUFLcV4+1ClzKkzj
	 TV077q5h2efb6VvqaWAwIhjJX8srE2yhdNmi0yi3xSzh2XqQnJ6HdZhGSnp20PEvHW
	 pTQksfm44U3/hgnX0q6PlLZMwgNPzpJ13eKs8qJiHBnaKf+xt2behFPo6KScW2jBYl
	 C1g7XnxaUr6+TUmsoEp0tyoOnEUt1/do+Qx8XNISLQv9Qn9YWwlCTiKcvK/W9gmasS
	 rzTfohhiFaShg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiande Lu <jiande.lu@mediatek.com>,
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
Subject: [PATCH AUTOSEL 6.14 010/108] Bluetooth: btusb: Add new VID/PID 13d3/3630 for MT7925
Date: Tue,  3 Jun 2025 20:53:53 -0400
Message-Id: <20250604005531.4178547-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Transfer-Encoding: 8bit

From: Jiande Lu <jiande.lu@mediatek.com>

[ Upstream commit 5bd5c716f7ec3e25d8d3b8a7566e192a26f9c7ce ]

Add VID 13d3 & PID 3630 for MediaTek MT7925 USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=07 Lev=01 Prnt=01 Port=10 Cnt=02 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3630 Rev= 1.00
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

Signed-off-by: Jiande Lu <jiande.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees based on
the following analysis: ## Commit Analysis **Nature of the Change:**
This commit adds hardware support for a new MediaTek MT7925 Bluetooth
USB device with VID 13d3 and PID 3630. The change is a simple addition
of a single line to the USB device ID table in
`drivers/bluetooth/btusb.c`. **Code Changes:** The modification adds one
entry to the `quirks_table`: ```c { USB_DEVICE(0x13d3, 0x3630),
.driver_info = BTUSB_MEDIATEK | BTUSB_WIDEBAND_SPEECH }, ``` **Backport
Suitability Assessment:** 1. **Fixes User-Affecting Issue:** YES - This
enables Bluetooth functionality for users with this specific hardware
variant, which would otherwise be non-functional. 2. **Small and
Contained:** YES - The change is minimal (2 lines) and only adds a
device ID entry without modifying any existing logic or behavior. 3.
**No Side Effects:** YES - Adding a device ID entry has no impact on
existing devices or functionality. It only extends support to new
hardware. 4. **No Architectural Changes:** YES - This is purely a device
identification addition with no changes to the driver's architecture or
core functionality. 5. **Non-Critical Subsystem Impact:** YES - While
Bluetooth is important, this change only affects one specific device
variant and cannot break existing functionality. 6. **Minimal Regression
Risk:** YES - Device ID additions have virtually no risk of causing
regressions since they only affect the newly supported device. **Pattern
Consistency:** This commit follows the exact same pattern as the
provided reference commits (all marked "Backport Status: YES"): -
Similar commit #1: Added VID 13d3/PID 3628 for MT7925 - Similar commit
#2: Added VID 13d3/PID 3602 for MT7925 - Similar commit #3: Added VID
0489/PID e124 for MT7925 - Similar commit #4: Added VID 0489/PID e111
for MT7925 All these similar commits were deemed suitable for
backporting, and this commit is functionally identical in scope and risk
profile. **Stable Tree Compliance:** This change perfectly aligns with
stable tree criteria: - Fixes important hardware compatibility issue -
Introduces no new features beyond device recognition - Contains no
architectural modifications - Has minimal regression risk - Is confined
to a single driver file - Enables existing, well-tested code paths for
new hardware The commit enables users with this specific MT7925
Bluetooth adapter to have functional Bluetooth support in stable
kernels, which is an important user-facing improvement with essentially
zero risk.

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 61d5e0d165bcd..64f0f64a5459c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -720,6 +720,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3628), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3630), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8723AE Bluetooth devices */
 	{ USB_DEVICE(0x0930, 0x021d), .driver_info = BTUSB_REALTEK },
-- 
2.39.5

