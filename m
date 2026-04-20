Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4E64657CC;
	Mon, 20 Apr 2026 13:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691830; cv=none; b=f6zZrK+B2IkTyMcBSc9d2KryReIpI44Fa3+Xb8/1TccH13Mps43NiPcxNFPpzv9fdxlrCKy8gG0n3u8+NvF6OJj31C98DJS+gqOfFzaTFqH+t7+CqCiVCoMrXL9qlKo/92BWO1ic8Z9F+n+myLz9aIPZZ4WWXW+O2vS0kpFdmTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691830; c=relaxed/simple;
	bh=cmg9KuhF5WyD3sfoKBJfBIlEtsiosFUQoJ3tomSefTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRrwpR2nAa3VyscCbpXDHmVYUk6ahNrA8Wa+0TuwJ4raY2soSbBiWeLP6R7jCazW17v6eDVI2X5bx27y073HB7BHSCsOfCv5gu4bHPFHELMwlEJZc0g2Q2M2/2Prsj2NApm+Xp1iQ0l0url4K5zT0Zkq2Fyk83s9Zjr75IRwgtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rf2WiIA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rf2WiIA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8284FC2BCB4;
	Mon, 20 Apr 2026 13:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691830;
	bh=cmg9KuhF5WyD3sfoKBJfBIlEtsiosFUQoJ3tomSefTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rf2WiIA9BuK7Xs8i6pU+0B1b3/QRAhVBMGxbrdM5ECCETqYtMSgrVItBHlhW9lNxO
	 uOfGtQM0roSrJWLw28XfbJq3lxO4jGcdY5Y96xcnxKWAl+MuFJG27pqS+HPtj1VQfQ
	 BHhaYYAn+oOJLfaPpfZkvj6QPIdoZbbDaMSaj3y63+GNHLaugQTJy4SUKHlTbTNNO+
	 FjVNhTbssq3bznBFrlw3lNv15vC5I/QoC5EufE9h0e31fKDqigzFfzAV/+Umzm42j8
	 MddNpRb37P4O1NVnH5U3yQwPFT3Spgw0Ehhbc5x2RAreF+AaIO39iaRgy5Ba7yJV1l
	 JrJa8GRTc1Jbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] Bluetooth: btusb: MT7922: Add VID/PID 0489/e174
Date: Mon, 20 Apr 2026 09:20:14 -0400
Message-ID: <20260420132314.1023554-220-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 1f2ac009d3e06380400618e777c858e582872efa ]

Add VID 0489 & PID e174 for MediaTek MT7922 USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=06 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e174 Rev= 1.00
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

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. The patch would insert the `0xe174` entry right after the `0xe170`
entry (line 704-705), which is exactly the position shown in the diff.
The context lines match perfectly. Now I have all the information needed
for the analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [Bluetooth: btusb] [Add] [VID/PID 0489/e174 for MediaTek MT7922
USB Bluetooth chip]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Signed-off-by: Chris Lu <chris.lu@mediatek.com> — author, MediaTek
  employee
- Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com> —
  Bluetooth subsystem maintainer
- No Fixes: tag (expected for device ID additions)
- No Reported-by: tag (not a bug fix, so expected)
- No Cc: stable tag (expected — that's why we're reviewing)

Record: Author is from MediaTek (chip vendor). Merged by the Bluetooth
subsystem maintainer.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The commit body provides the USB device descriptor dump from
`/sys/kernel/debug/usb/devices`, confirming this is a real MediaTek
MT7922 Bluetooth USB device (Vendor=0489, ProdID=e174,
Manufacturer=MediaTek Inc., Product=Wireless_Device). The device runs at
USB 2.0 High Speed (480 Mbps) and has 3 interfaces typical of a
Bluetooth HCI device.

Record: No bug described — this is a device ID addition enabling
hardware support. The device is verified to exist and be manufactured by
MediaTek.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: This is not a hidden bug fix. It is a straightforward device ID
addition to enable Bluetooth on hardware with this specific VID/PID.

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
- Files changed: `drivers/bluetooth/btusb.c` only
- Lines added: +2 (one `USB_DEVICE` table entry spanning 2 lines)
- Lines removed: 0
- Function modified: None — this adds to the static `quirks_table[]`
  array
- Scope: single-file, single-table-entry addition

Record: [1 file, +2/-0 lines] [quirks_table[] static data only] [Trivial
single-entry addition]

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- BEFORE: Device with VID 0489 / PID e174 is not recognized by btusb
  driver, so Bluetooth doesn't work on this hardware
- AFTER: Device is matched by `usb_device_id` table with `BTUSB_MEDIATEK
  | BTUSB_WIDEBAND_SPEECH` flags, enabling the existing MediaTek
  Bluetooth support path

Record: Purely a data table entry; no logic changes.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: (h) Hardware workaround / Device ID addition. Without this
entry, the btusb driver doesn't bind to the device, and the user's
Bluetooth hardware is completely non-functional.

Record: [Device ID addition] [Enables existing MT7922 driver code for a
new PID variant]

**Step 2.4: ASSESS THE FIX QUALITY**
- Obviously correct: Yes — identical pattern to dozens of other entries
  in the same table
- Minimal: Yes — 2 lines, data-only
- Regression risk: Zero — only affects devices with this specific
  VID/PID
- No API changes, no logic changes, no locking changes

Record: [Perfect quality — trivial table entry] [Zero regression risk]

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
The neighboring entry `0xe170` was added by Chris Lu (same author) in
commit `5a6700a31c953` on 2025-10-15. The MT7922A device section has
entries going back to 2023. The BTUSB_MEDIATEK driver support has been
present since at least v6.10.

Record: MT7922 support exists in tree since v6.10. This is just another
PID variant for the same chip family.

**Step 3.2: FOLLOW THE FIXES: TAG**
No Fixes: tag — expected for a device ID addition.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Recent btusb.c commits are heavily dominated by device ID additions
(e0e2, e0e4, e0f1, e0f2, e0f5, e0f6, e102, e152, e153, e170, plus IDs
from other vendors). This is a pattern of ongoing hardware enablement
for the MT7922 family.

Record: Standalone commit. No prerequisites beyond existing MT7922
support.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Chris Lu at MediaTek is a regular contributor to the Bluetooth/btusb
subsystem. He authored the e170 entry, the e135 (MT7920) entry, and a
kernel crash fix for MediaTek ISO interfaces. He clearly works on
Bluetooth at MediaTek.

Record: Author is a domain expert from the chip vendor.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
The only prerequisite is MT7922 support via BTUSB_MEDIATEK, which has
been present since v6.10 (commit `8c0401b7308cb`). The entry `0xe170`
(the sibling right before) exists in the current tree. The patch applies
cleanly — the diff context matches the current file exactly.

Record: No dependencies beyond base MT7922 support already in stable
trees (v6.10+).

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Found via web search: The patch was submitted as `[PATCH v1]` and then
`[PATCH RESEND v1]` on the linux-mediatek mailing list in January 2026.
The RESEND indicates initial posting may not have received attention.
The mailing list archive at lists.infradead.org confirms the exact same
diff.

Record: [https://lists.infradead.org/pipermail/linux-
mediatek/2026-January/103452.html] [v1 + RESEND v1] [No concerns or NAKs
visible]

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Merged by Luiz Augusto von Dentz (Bluetooth subsystem maintainer at
Intel), as indicated by his Signed-off-by.

Record: Bluetooth subsystem maintainer merged this.

**Step 4.3-4.5:** Not applicable — no bug report (this is hardware
enablement), no series dependencies.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.5:** The change is purely to the `quirks_table[]` static
data array. No functions are modified. The USB_DEVICE macro expands to
match criteria for the USB core's device matching infrastructure. When a
device with VID=0x0489/PID=0xe174 is plugged in, the btusb driver will
bind to it using the BTUSB_MEDIATEK code path. This code path is well-
tested through dozens of other MT7922 variants.

Record: No function changes. Data-only addition to existing, well-tested
USB device matching infrastructure.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?**
The MT7922 BTUSB_MEDIATEK support exists since v6.10. The
`quirks_table[]` and the entire MT7922 code path exist in all current
active stable trees from v6.10 onward. For older stable trees (v6.6,
v6.1), the base MT7922 support may not be present, so the device ID
alone wouldn't help there.

Record: Applicable to stable trees v6.10+, v6.12+, and future LTS
branches.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
The diff context matches the current tree perfectly. The entry goes
right after 0xe170 and before 0x04ca entries. The patch will apply
cleanly.

Record: Clean apply expected.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE**
No prior fix for this specific VID/PID exists.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Subsystem: Bluetooth (drivers/bluetooth/). Criticality:
IMPORTANT — Bluetooth is essential on laptops and IoT devices.

**Step 7.2:** btusb.c is very actively developed with frequent device ID
additions. The MT7922 is a popular WiFi/Bluetooth combo chip used in
many laptops.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Users with laptops/devices containing a MediaTek MT7922 Bluetooth chip
with the specific VID/PID 0489:e174. Without this patch, Bluetooth is
completely non-functional for these users.

**Step 8.2: TRIGGER CONDITIONS**
Trigger: simply having this hardware. Every boot, every time.

**Step 8.3: FAILURE MODE**
Without the patch: Bluetooth hardware is completely non-functional
(driver doesn't bind). With the patch: full Bluetooth functionality.

**Step 8.4: RISK-BENEFIT RATIO**
- BENEFIT: HIGH — enables Bluetooth for real hardware users
- RISK: VERY LOW — 2-line data-only change, cannot affect any other
  device
- Ratio: Excellent — maximum benefit, minimum risk

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE COMPILATION**
FOR backporting:
- Classic device ID addition — an explicit exception category that is
  always YES
- Only 2 lines added, data-only (zero code changes)
- Zero regression risk (only matches this specific VID/PID)
- Author is from MediaTek (chip vendor), merged by subsystem maintainer
- Real hardware that users have (USB device dump provided)
- Identical pattern to dozens of existing entries
- MT7922 driver support exists in stable trees (v6.10+)

AGAINST backporting:
- None

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct? YES — trivial table entry
2. Fixes a real bug? YES — enables hardware for real users
3. Important issue? YES — without it, Bluetooth is completely broken on
   this hardware
4. Small and contained? YES — 2 lines
5. No new features/APIs? CORRECT — no new features
6. Can apply to stable? YES — clean apply

**Step 9.3: EXCEPTION CATEGORY**
This is a **Device ID addition to an existing driver** — one of the
explicit exception categories that is automatically YES for stable.

## Verification

- [Phase 1] Parsed tags: Signed-off-by from Chris Lu (MediaTek) and Luiz
  Augusto von Dentz (Bluetooth maintainer)
- [Phase 2] Diff analysis: +2 lines, single USB_DEVICE entry in
  quirks_table[], data-only
- [Phase 3] git blame: neighboring entry 0xe170 added by same author in
  5a6700a31c953 (Oct 2025)
- [Phase 3] MT7922 base support in commit 8c0401b7308cb, present since
  v6.10
- [Phase 3] git merge-base: confirmed MT7922 support in v6.10 and v6.12,
  NOT in v6.6 or v6.1
- [Phase 4] Web search: found mailing list post at lists.infradead.org
  confirming RESEND v1 submission Jan 2026
- [Phase 4] Mailing list archive: identical diff confirmed, no NAKs or
  objections
- [Phase 5] No functions modified — purely static data table change
- [Phase 6] Patch applies cleanly — verified context lines match current
  tree exactly (lines 704-706)
- [Phase 6] BTUSB_MEDIATEK appears 70 times in btusb.c — well-tested
  code path
- [Phase 8] Risk: zero (only affects devices with VID=0x0489,
  PID=0xe174)

This is a textbook device ID addition to an existing, well-tested
driver. It enables Bluetooth on real MediaTek MT7922 hardware for users
who have this specific VID/PID variant. The change is 2 lines of data-
only additions with zero regression risk.

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 5c535f3ab7228..aeba026bdb427 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -703,6 +703,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe170), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe174), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04ca, 0x3804), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04ca, 0x38e4), .driver_info = BTUSB_MEDIATEK |
-- 
2.53.0

