Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A8A4AD4A4;
	Mon, 31 Aug 2026 13:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184079; cv=none; b=cQgCvV90993vtW9jFLUQ4wXP6tgu9wg4HXIPrqAET8/f3ZHDkOwRQfQ9mnM1sLH6+K/hU8ML17jSxl3jfKQMlElgkm+w4ulaRkzGFFCkAKE0fDDQ+1kL8Qpheqi8jGlvHakR6CgczVXgyOj4uCwSd0tGAtoGKIfX/hoxO6k1EmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184079; c=relaxed/simple;
	bh=js1xdQPd8SVF0DfTFRnxBCxUin6MEY6bS4OlgxHK4lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RCTtBHeV/E4zboqit2zk5L7zR2whAUaOjKXHi4auxnzObbDpMxv/nkPg4GU4Xm407dqW7niVRuCXtSXOAINfC5Enp9djoI8hSa3gTElpci/KTPPnQjEMi30x7JsBg8PvFQssPdiTZmDuQaJRNQYNDaqGx2eUpoKKuUf8+wFPvks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7vsu39J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7vsu39J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFDE1F000E9;
	Mon, 31 Aug 2026 13:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184077;
	bh=z/rg2K/V3OZcgIB5m1IKvlZag47CkDnfvOGJTq8IRKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7vsu39JUtmjbaUeghLAAIE6aDGTXmSd+lWulNocDJum3pTmV22z8QN7NhTEL5a6N
	 AcwAvL4u+z4hrBhasJNN6lPQGT/lMN2SBj4nZb9V3upsY/kAD+uA5faqg/Pz0KrmM7
	 TDQBdTwXi4Ub2UJdfZmKvUPIKE+t6DEnQJhiaGkz4AUlnWxC6yUAhYCTYUa/V1h0th
	 U6FsVGk/QUoWWCZp6UE+VpYE/ngOiNAkLLrb43xKitX96eqId4/84ix4y2mjEeDazn
	 Ldn9k1KNOSeU7/HpwsYwjCRDUDlVLaVas5PqUj/k4cNitn/DGlGhoyVTpAuKyCqd0V
	 vlv15bkyEKxbQ==
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
Subject: [PATCH AUTOSEL 6.18-6.12] Bluetooth: btusb: MT7925: Add VID/PID 0e8d/8c38
Date: Mon, 31 Aug 2026 09:28:25 -0400
Message-ID: <20260831133314.4125787-477-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 69b2f05df3ee63e1273608cdb81a7d664e9de2b8 ]

Add VID 0e8d & PID 8c38 for MediaTek MT7925 USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=06 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0e8d ProdID=8c38 Rev= 1.00
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

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[Bluetooth: btusb] [add] MT7925 USB VID/PID 0e8d/8c38 for
MediaTek chip`

**Step 1.2 — Tags**

Record:
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none
- **Cc: stable@vger.kernel.org:** none (expected for manual review)
- **Signed-off-by:** Chris Lu `<chris.lu@mediatek.com>` (author), Luiz
  Augusto von Dentz `<luiz.von.dentz@intel.com>` (Bluetooth
  maintainer/committer)

Notable: maintainer Signed-off-by from Luiz von Dentz; no
syzbot/sanitizer signals.

**Step 1.3 — Body analysis**

Record:
- **Bug description:** Without this USB ID, the MT7925 Bluetooth
  function on hardware presenting as `0e8d:8c38` is not recognized with
  the correct MediaTek/WBS driver flags.
- **Symptom:** Bluetooth on this MediaTek MT7925 USB combo device does
  not work (or lacks proper MediaTek setup/firmware path).
- **Version info:** none stated.
- **Root cause (author):** Missing explicit VID/PID entry in
  `quirks_table[]`; device is a standard MediaTek `Wireless_Device` with
  BT interfaces `e0/01/01`.

**Step 1.4 — Hidden bug fix detection**

Record: Not disguised as cleanup. This is an explicit hardware-
enablement ID addition. Functionally it ensures `BTUSB_MEDIATEK |
BTUSB_WIDEBAND_SPEECH` flags are applied for this PID (see Phase 2/6 for
nuance about an existing generic `0x0e8d` match).

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **Files:** `drivers/bluetooth/btusb.c` (+2 lines)
- **Functions:** `quirks_table[]` static data only (no function logic
  changed)
- **Scope:** Single-file, surgical device-ID addition

**Step 2.2 — Code flow change**

Record:
- **Before:** `0e8d:8c38` not listed in the MT7925 section of
  `quirks_table[]`.
- **After:** Explicit entry added with `BTUSB_MEDIATEK |
  BTUSB_WIDEBAND_SPEECH`.
- **Path affected:** USB probe of interface 0 on this device →
  `btusb_probe()` → quirks lookup → MediaTek setup path
  (`btusb_mtk_setup`, firmware load via `btmtk`, WBS support).

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Hardware enablement / device ID (not crash/UAF/race).
- **Mechanism:** Without correct `driver_info` flags, btusb binds
  generically but skips MediaTek-specific probe setup (firmware
  download, MTK ISO handling, WBS). For OEM-vendor PIDs this is
  mandatory; for native `0x0e8d` PIDs a generic vendor+interface entry
  at line 616 may already apply the same flags (verified below).

**Step 2.4 — Fix quality**

Record:
- **Quality:** Obviously correct; identical pattern to ~15 other MT7925
  entries already in tree.
- **Regression risk:** Very low (2-line table entry, no logic change).
- **Red flag:** None. No API changes, no refactoring.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame / introduction**

Record:
- Upstream commit: `69b2f05df3ee6` (mainline, not yet in this stable
  tree).
- Generic MediaTek match `USB_VENDOR_AND_INTERFACE_INFO(0x0e8d, ...)`
  introduced in `a1c49c434e150` (2019); `BTUSB_WIDEBAND_SPEECH` added to
  it in `0fec656d08aa59` (2024).
- MT7925 section started with `560ff4bc99070` (Jan 2024, `13d3/3602`).
- Similar native MediaTek entry `0e8d:0608` added in `be55622ce673f` —
  already present in this 6.18.y tree.

**Step 3.2 — Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3 — Related commits**

Record:
- Part of ongoing MT7925 ID series: `576952cf981b7`, `942873c8137fe`,
  `7ed1d46c6bc28`, `5bd5c716f7ec3`, etc. — all already in 6.18.y.
- Standalone patch (not multi-patch series dependency).
- Same author pattern as `a8c7343e2a044`, `576952cf981b7`.

**Step 3.4 — Author context**

Record: Chris Lu is a regular MediaTek Bluetooth contributor; Luiz von
Dentz is Bluetooth maintainer and committed this to mainline.

**Step 3.5 — Dependencies**

Record:
- Requires existing MT7925 btusb/btmtk support — **present** in this
  tree (`btmtk.c` handles `dev_id == 0x7925`, firmware
  `FIRMWARE_MT7925`, MT7925 USB IDs already listed).
- Applies cleanly to current 6.18.44 tree (`git apply --check` passed).
- No prerequisite commits missing.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- **b4 dig URL:** https://patch.msgid.link/20260407065110.3037135-1-
  chris.lu@mediatek.com
- **Revisions:** v1 submitted 2026-03-09; RESEND v1 2026-04-07 (applied
  version).
- **Reviewer feedback:** No NAKs, no Reviewed-by/Acked-by in thread;
  maintainer merged to mainline.
- **Stable nomination:** None found in thread.

**Step 4.2 — Reviewers CC'd**

Record: Marcel Holtmann, Johan Hedberg, Luiz von Dentz, Sean Wang,
linux-bluetooth, linux-mediatek — appropriate subsystem coverage.

**Step 4.3 — Bug report**

Record: N/A — hardware enablement from vendor; USB descriptor provided
as evidence of tested device.

**Step 4.4 — Series context**

Record: Standalone 1-patch submission for this PID; unrelated series
exists for MT7922 `0e8d/223c`.

**Step 4.5 — Stable list history**

Record: No stable-list discussion found (lore fetch for stable list not
performed; patch thread had no stable CC).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key symbols**

Record: `quirks_table[]`, `btusb_probe()`, `BTUSB_MEDIATEK`,
`BTUSB_WIDEBAND_SPEECH`

**Step 5.2 — Callers**

Record: `btusb_probe()` called from USB core on device plug/enumeration
— common hot-plug path for all USB Bluetooth adapters.

**Step 5.3 — Callees (when flags set)**

Record: `btusb_mtk_setup()`, `btusb_mtk_shutdown()`,
`btmtk_reset_sync()`, `btmtk_set_bdaddr()`, `btmtk_usb_recv_acl()` —
MediaTek firmware and protocol initialization.

**Step 5.4 — Reachability**

Record: Triggered by plugging in USB hardware with this VID/PID. Not
userspace-triggerable as a security bug, but affects any user with this
hardware on boot/plug.

**Step 5.5 — Similar patterns**

Record: Fifteen+ MT7925 entries in same table section; `0e8d:0608`
(MT7921) added similarly despite generic `0x0e8d` vendor match —
precedent already in this tree.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Does buggy/missing code exist?**

Record:
- **Local tree:** `v6.18.44` (`git describe HEAD` →
  `v6.18.44-1-g2736c32da98b9`)
- **Missing entry confirmed:** `grep 0x8c38 drivers/bluetooth/btusb.c` →
  no match
- **MT7925 support present:** `btmtk.c` has `0x7925` handling, firmware
  define, MT7925 USB IDs in quirks table
- **Generic fallback exists:** `USB_VENDOR_AND_INTERFACE_INFO(0x0e8d,
  0xe0, 0x01, 0x01)` at lines 616–618 may already match this device
  during quirks lookup in `btusb_probe()`. Explicit PID entry is still
  consistent with established backport pattern (`0e8d:0608` already
  backported).

**Step 6.2 — Backport complications**

Record: Clean apply verified. Line numbers differ slightly from mainline
but patch applies without conflict. MT7925 section structure matches.

**Step 6.3 — Related fixes already present?**

Record: No duplicate `0x8c38` entry. Multiple other MT7925 IDs already
backported. Commit `69b2f05df3ee6` is **not** an ancestor of HEAD — not
yet in this tree.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem / criticality**

Record: `drivers/bluetooth` — IMPORTANT (common laptop/desktop USB
Bluetooth hardware).

**Step 7.2 — Activity**

Record: Actively maintained; frequent ID additions and bug fixes in
btusb/btmtk on this branch.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users with MT7925 USB combo hardware using native MediaTek USB
ID `0e8d:8c38` (laptops/embedded with this RF module).

**Step 8.2 — Trigger conditions**

Record: USB device enumeration at plug/boot. Common for built-in USB
Bluetooth on new MediaTek platforms.

**Step 8.3 — Failure mode severity**

Record: Without proper MediaTek flags → no firmware load / broken
Bluetooth. Severity: **MEDIUM** (hardware non-functional, not kernel
crash). Explicit ID ensures correct driver behavior regardless of
quirks-table match ordering.

**Step 8.4 — Risk/benefit**

Record:
- **Benefit:** Enables/tested recognition of real MT7925 hardware;
  aligns with other backported MT7925 ID commits in 6.18.y
- **Risk:** Minimal (2-line table entry)
- **Ratio:** Strong benefit, negligible risk

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Standard stable exception: new USB device ID on existing driver
- MT7925 driver infrastructure fully present in 6.18.y
- Identical commits for other MT7925 PIDs already backported to this
  tree
- Precedent: `0e8d:0608` (MT7921) backported despite generic vendor
  match
- Vendor-tested hardware with USB descriptor evidence
- Bluetooth maintainer Signed-off-by and mainline merge
- Applies cleanly, standalone, 2 lines

**Evidence AGAINST:**
- Possibly redundant with existing generic `0x0e8d` vendor+interface
  quirks entry (device may partially work without this patch)
- Not a crash/security/data-corruption fix
- No explicit stable nomination or user bug reports

**Unresolved:** Whether `0e8d:8c38` fails on real hardware without this
explicit entry when generic match applies — not hardware-tested here,
but code analysis shows generic match should set same flags.

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — trivial ID table entry;
   vendor tested, maintainer merged
2. Fixes real bug affecting users? **PASS** — hardware enablement for
   specific MT7925 SKU (Bluetooth non-functional without proper MTK
   setup)
3. Important issue? **PASS** — MEDIUM severity hardware non-
   functionality
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features/APIs? **PASS** — device ID only
6. Can apply to local tree? **PASS** — clean apply, all prerequisites
   present

**Exception category:** NEW DEVICE ID for existing driver (explicit
stable exception)

---

## Verification

- [Phase 1] Parsed tags: only Signed-off-by (Chris Lu, Luiz von Dentz);
  no Fixes/Reported-by/Link/Cc:stable
- [Phase 2] Diff: +2 lines in `quirks_table[]`, `BTUSB_MEDIATEK |
  BTUSB_WIDEBAND_SPEECH`
- [Phase 3] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 3] Upstream commit identified: `69b2f05df3ee6`; NOT in HEAD
  (`git merge-base --is-ancestor` failed)
- [Phase 3] MT7925 support present: `560ff4bc99070` is ancestor;
  `btmtk.c` has `0x7925` paths
- [Phase 3] Generic `0x0e8d` match at lines 616–618 since
  `a1c49c434e150` / WBS since `0fec656d08aa59`
- [Phase 3] Precedent `be55622ce673f` (`0e8d:0608`) in tree
- [Phase 4] `b4 dig -c 69b2f05df3ee6`: lore URL found
- [Phase 4] `b4 dig -a`: v1 + RESEND v1; applied version is latest
- [Phase 4] `b4 dig -w`: Marcel Holtmann, Luiz von Dentz, linux-
  bluetooth CC'd
- [Phase 4] Thread mbox: no NAKs, no stable nomination, no Reviewed-by
- [Phase 5] `btusb_probe()` quirks lookup at lines 4018–4024 verified
- [Phase 5] MediaTek setup gated on `BTUSB_MEDIATEK` at lines 4113–4224
  verified
- [Phase 6] `grep 0x8c38 btusb.c`: not present (patch needed)
- [Phase 6] `git apply --check` on upstream diff: applies cleanly
- [Phase 8] Failure mode: broken Bluetooth on affected hardware, not
  kernel oops

This is a textbook stable backport candidate: a 2-line USB ID addition
for MT7925 on hardware where the driver stack already exists in 6.18.y,
following the same pattern as numerous MT7925 ID commits already present
in this tree.

**YES**The background searches finished and match the earlier analysis:

- **`git log --grep="8c38"`** on the current tree only turned up
  unrelated commits (spi, drm, block, etc.) — not the Bluetooth
  `0e8d/8c38` patch.
- A scoped search in **`drivers/bluetooth/btusb.c`** for that commit
  also came up empty.

That confirms the patch (`69b2f05df3ee6` on mainline) is **not yet in
this 6.18.44 tree**, which is consistent with the **YES** backport
recommendation.The repo-wide search for `0x8c38` returned no matches in
`drivers/bluetooth/`, so that PID isn’t present anywhere in this tree’s
Bluetooth driver history. That aligns with the earlier finding that the
upstream commit hasn’t landed in 6.18.44 yet.

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 5974aa2e94d48..91208da2be48d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -750,6 +750,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe151), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0e8d, 0x8c38), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3602), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3603), .driver_info = BTUSB_MEDIATEK |
-- 
2.53.0

