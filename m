Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9768C3D88F6;
	Mon, 20 Apr 2026 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691432; cv=none; b=hyyP5Q4lPl6CxmpTtVkfQJ6vRGel4vU7iO9/07E6m2sz6LFlfwk4LK/HJc0U8ua9xndM3kIMKtfjXWHr3kBUKBZsJ4+PuWoBa2/eNkUGuIu4BaLjYDFSgVXpABw5bfnHfaBoqepfkM2eS/by+79jHI3wEMPQmNOEohA3G5G2dY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691432; c=relaxed/simple;
	bh=Wq75/vb38hHhpk9MIiawURmmiKJ1pzAsjcKD04+I+gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frYjUOiXpC3johNsF/IcoxT6OKWcENSSYac12nT3KT/P6TaMzr4GT+prDZ1/ZPIKPT5P1FEoIIzf7A+Jp2mpwPeFSLRORYgY+7+kebNv6d13fvvIjyZ8PDHZpCtTyAUyHOK86APWfEezG03vKK4tR9ihM6KurZieR74FdtfOn6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7GTDk1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7GTDk1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7A0C2BCB4;
	Mon, 20 Apr 2026 13:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691432;
	bh=Wq75/vb38hHhpk9MIiawURmmiKJ1pzAsjcKD04+I+gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7GTDk1WzwBD3TvNlV9mbccu8yjIEmeyWCyMgHVaATPe7zRzOTPc5IxXls69d7wDM
	 c022owMLUKcOpPFV5wnEFOwPuTk4D8DQAPOWcCQaE/D+NafM4Cn8dIxfZJNlpyGtIg
	 DxL6D/jATuhPu+9hzFUUR0TygqdvxF+UpB4/xQkrrjCGA1ATpa5drLmn2mAEzo3/c0
	 B/dUDS0JCQTY2bTfgvqg1mmCFivrWLXjaPuyvGamlcvshyCI+VnBV5PZAc/fj0cJwp
	 rYpPEUY4Hm+fbDNmzn88MW4qJKJz8cZ5XyLJ4LTWbOGzi72xbfvH9B0m2HACShAVOS
	 012XygDQ7W0Sg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] Bluetooth: btusb: Add new VID/PID 13d3/3579 for MT7902
Date: Mon, 20 Apr 2026 09:16:57 -0400
Message-ID: <20260420132314.1023554-23-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 51c4173b89fe7399bad1381016096cc154588660 ]

Add VID 13d3 & PID 3579 for MediaTek MT7902 USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=01 Lev=01 Prnt=01 Port=09 Cnt=04 Dev#=  7 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3579 Rev= 1.00
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
I:  If#= 2 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=8a(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS=  64 Ivl=125us
I:* If#= 2 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=8a(I) Atr=03(Int.) MxPS= 512 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS= 512 Ivl=125us

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for the full analysis. Let me
compile the results.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [Bluetooth: btusb] [Add] Adding new USB VID/PID 13d3/3579 for
MediaTek MT7902 Bluetooth chip.

**Step 1.2: Tags**
- Signed-off-by: Sean Wang <sean.wang@mediatek.com> (author, MediaTek
  Bluetooth developer)
- Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
  (Bluetooth subsystem maintainer)
- No Fixes: tag (expected for device ID additions)
- No Cc: stable (expected for commits under review)
- No Reported-by (but user interest is documented on the mailing list)

**Step 1.3: Body Text**
The commit message describes adding a new USB VID/PID pair for the
MT7902 Bluetooth chip. It includes full USB device descriptor
information from `/sys/kernel/debug/usb/devices`, confirming this is
real hardware with Vendor=13d3 ProdID=3579, manufactured by MediaTek
Inc.

**Step 1.4: Hidden Bug Fix?**
Record: This is not a hidden bug fix. It is a straightforward new device
ID addition to an existing driver. It falls into the "device ID
addition" exception category.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: `drivers/bluetooth/btusb.c` only
- Lines: +3, -1 (net +2 lines)
- Change: Adds one USB_DEVICE entry (13d3/3579) with BTUSB_MEDIATEK |
  BTUSB_WIDEBAND_SPEECH flags, plus a comment "MediaTek MT7902 Bluetooth
  devices"
- Scope: Single-file, single-table, trivially contained

**Step 2.2: Code Flow**
The change adds an entry to the `quirks_table[]` static array. This is a
USB device matching table. When a USB device with VID=0x13d3 PID=0x3579
is plugged in, the btusb driver will now claim it with BTUSB_MEDIATEK
and BTUSB_WIDEBAND_SPEECH flags, causing the MediaTek initialization
path (btmtk) to be used.

**Step 2.3: Bug Mechanism**
Category: Hardware enablement (device ID addition). Without this ID, the
MT7902 Bluetooth hardware is not recognized by the btusb driver, leaving
users without Bluetooth.

**Step 2.4: Fix Quality**
The fix itself is a trivial 2-line device ID table addition, following
the exact pattern of dozens of existing entries. It is obviously correct
in isolation. However, it has a **critical dependency** - see Phase 3.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Verified: The surrounding code (other 13d3 device IDs like 3578, 3583,
3606) was introduced by various authors from 2021-2024 and is well-
established. The btusb MediaTek infrastructure has been in the tree
since ~2021.

**Step 3.2: Fixes tag**
N/A - no Fixes: tag (expected for device ID additions).

**Step 3.3: File History**
Recent changes to `drivers/bluetooth/btusb.c` include other device ID
additions (e.g., commit 6c0568b7741a3 adding USB ID 7392:e611 for
Edimax). This is a well-trodden path.

**Step 3.4: Author**
Sean Wang is a MediaTek Bluetooth developer and regular contributor. He
has 10+ commits in `drivers/bluetooth/` including MediaTek-specific
fixes and firmware support. The commit was merged by Luiz Augusto von
Dentz, the Bluetooth subsystem maintainer.

**Step 3.5: Dependencies - CRITICAL FINDING**
This commit is patch 3/4 of a series. Patch 2/4 ("Bluetooth: btmtk: add
MT7902 MCU support") adds:
1. `case 0x7902:` to the switch in `btmtk_usb_setup()` (btmtk.c line
   ~1328)
2. `#define FIRMWARE_MT7902` to btmtk.h

**Without patch 2/4, this commit would cause the btusb driver to claim
the device, but `btmtk_usb_setup()` would hit the `default:` case at
line 1369 and return `-ENODEV` with "Unsupported hardware variant
(00007902)"**. The device would be claimed but non-functional.

Verified: grep confirmed `0x7902` is NOT in btmtk.c's switch and
`FIRMWARE_MT7902` is NOT defined in btmtk.h in this tree.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Discussion**
Found the original submission at spinics.net (mirror of linux-bluetooth
list). This was submitted as patch 3/4 on 2026-02-19. A reviewer
(Bitterblue Smith) noted a copy-paste error in the commit message body
text ("MT7922" should be "MT7902").

**Step 4.2: Reviewers**
Sent to linux-bluetooth@vger.kernel.org and linux-
mediatek@lists.infradead.org. Merged by the Bluetooth subsystem
maintainer (Luiz Augusto von Dentz).

**Step 4.3: User Reports**
Multiple users confirmed they have MT7902 hardware:
- OnlineLearningTutorials reported PID 13d3/3580 (another MT7902
  variant)
- Two additional USB IDs (13d3/3594, 13d3/3596) were reported
- Bitterblue Smith reported 0e8d/1ede (yet another MT7902 variant)
- Sean Wang acknowledged these and promised to add them in a future
  version

This confirms real user demand for MT7902 support.

**Step 4.4/4.5: Series and Stable Context**
The series is 4 patches: SDIO ID (1/4), MCU support (2/4), USB ID (3/4),
SDIO support (4/4). Patches 1 and 4 are for SDIO and not needed for USB.
Patch 2 is required for this commit.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Function Analysis**
The change is to a static data table (`quirks_table[]`), not a function.
The table is used by the USB subsystem's device matching mechanism. When
a matching USB device is found, `btusb_probe()` is called, which sets up
the device using MediaTek-specific code paths (via `btmtk_usb_setup()`).

The `btmtk_fw_get_filename()` function at line 112-127 already handles
0x7902 correctly via its `else` branch (generates
"mediatek/BT_RAM_CODE_MT7902_1_X_hdr.bin"). The only missing piece is
the `case 0x7902:` in the switch statement to reach that code path.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable?**
The btusb driver and MediaTek support infrastructure (BTUSB_MEDIATEK)
exist in this stable tree (7.0). There are already ~70 BTUSB_MEDIATEK
entries. The code to support MT7902 exists in principle (same firmware
loading path as MT7922/MT7925/MT7961), but the specific device ID 0x7902
is not handled in btmtk.c's switch.

**Step 6.2: Backport Complications**
The USB device ID addition itself would apply cleanly. However, it MUST
be accompanied by patch 2/4 (adding `case 0x7902:` to btmtk.c). That
patch is also trivially small (1 line in btmtk.c, 1 line in btmtk.h).

**Step 6.3: Related Fixes in Stable**
No MT7902 support exists in this stable tree.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Bluetooth subsystem (`drivers/bluetooth/`), Criticality:
IMPORTANT. Bluetooth is used widely on laptops and desktops.

**Step 7.2:** The btusb driver is actively developed with frequent
device ID additions.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Users with MediaTek MT7902 Bluetooth hardware (13d3/3579 variant). The
mailing list confirms multiple people have this hardware.

**Step 8.2: Trigger**
Without this patch: Bluetooth hardware is not recognized at all. No
Bluetooth functionality.

**Step 8.3: Severity**
Without this: complete hardware non-functionality (no Bluetooth). With
this (plus dependency): hardware works. Severity of the absence: HIGH
for affected users.

**Step 8.4: Risk-Benefit**
- BENEFIT: Enables Bluetooth on MT7902 hardware. Users have no
  workaround.
- RISK: Extremely low. Device ID table additions are the safest possible
  changes - they only affect users who have the specific hardware.
  Combined with the dependency, total change is ~4 lines.

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Classic device ID addition pattern - explicitly allowed in stable
- Trivially small change (2 lines in btusb.c)
- Real users need this (confirmed on mailing list by multiple people)
- Follows exact pattern of 70+ existing BTUSB_MEDIATEK entries
- Written by MediaTek developer, merged by Bluetooth maintainer
- Zero risk to users without this hardware

**Evidence AGAINST backporting:**
- Requires a companion patch (2/4: btmtk MCU support) to function
- Without that companion, this would make things slightly worse (device
  claimed but non-functional)
- Part of a 4-patch series (though only 2/4 is needed for USB)

**Stable Rules Checklist:**
1. Obviously correct? YES - trivial table entry following established
   pattern
2. Fixes real bug? YES - enables hardware that doesn't work without it
3. Important? YES for affected users - complete Bluetooth failure
4. Small/contained? YES - 2 lines
5. No new features/APIs? Correct - device ID in existing driver
6. Applies to stable? YES, with dependency

**Exception Category:** NEW DEVICE ID to existing driver - explicitly
allowed.

## Verification

- [Phase 1] Parsed tags: Sean Wang (MediaTek dev) authored, Luiz von
  Dentz (BT maintainer) merged
- [Phase 2] Diff: 2 lines added to `quirks_table[]` in btusb.c, adds
  USB_DEVICE(0x13d3, 0x3579)
- [Phase 3] git blame: surrounding entries from 2021-2024, well-
  established table
- [Phase 3] Dependency: grep confirmed 0x7902 NOT in btmtk.c switch,
  FIRMWARE_MT7902 NOT in btmtk.h
- [Phase 3] btmtk_usb_setup default case returns -ENODEV (line
  1369-1372), confirmed by reading code
- [Phase 4] Found original submission at spinics.net/lists/linux-
  bluetooth/msg126673.html
- [Phase 4] Multiple users confirmed MT7902 hardware on mailing list
  (msg126726, msg126732)
- [Phase 4] Sean Wang promised additional MT7902 VID/PIDs (msg126729)
- [Phase 5] btmtk_fw_get_filename() else clause handles 0x7902 correctly
  (line 123-126)
- [Phase 6] BTUSB_MEDIATEK infrastructure confirmed present (70 entries,
  grep verified)
- [Phase 6] MT7902 MCU support NOT present in stable 7.0 tree (grep
  verified)
- [Phase 8] Risk is extremely low - only affects specific hardware,
  follows existing pattern
- DEPENDENCY: Patch 2/4 ("Bluetooth: btmtk: add MT7902 MCU support") is
  REQUIRED for this to function

This is a textbook device ID addition that should be backported to
stable, with the caveat that patch 2/4 from the same series must also be
included. Without that companion patch, the device would be claimed but
fail initialization. The combined change is ~4 lines and extremely low
risk.

**YES**

 drivers/bluetooth/btusb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index d07db8e3a79d5..1acc07d0dc061 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -671,7 +671,9 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3606), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
-
+	/* MediaTek MT7902 Bluetooth devices */
+	{ USB_DEVICE(0x13d3, 0x3579), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	/* MediaTek MT7922 Bluetooth devices */
 	{ USB_DEVICE(0x13d3, 0x3585), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
-- 
2.53.0

