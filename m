Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B4C515756;
	Mon, 31 Aug 2026 13:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183802; cv=none; b=n5FYZpyNpRzY+JRpipt9ggq093ReQaRXrZlfFSBtwSKUGCW3Hbp4SdK/yZpFeuz4FwsvMP0bfJPOn9gZa4mQeKr40MOTDWatuIlIQK1BtSarX47BI+Zs5azi4IQwBbMAUBsfVFETDB3KWDqKhNc4d7fHsff19hEuoKIVUhPhTLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183802; c=relaxed/simple;
	bh=/l9ANvFiBZ+91fI8kVmsZk9vxKthGQasnovzW7+7bbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+5RON9W+cWnPmXESAMkFJPbJK1ds46ZGM6CK1+rYfagbw8QQCNLbD7Z84gvjl9x7rT072YJdnoZrvrXs40e03VQKJw7y150wRjIKZ1co2+uctFWn5sfgocyqBM4EvpVB28AHwF07oARkW5UYqQam6caGHPm6PRV4k4EL0W2BpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eN7clqFq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eN7clqFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1671F00A3E;
	Mon, 31 Aug 2026 13:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183797;
	bh=5zKhH/B3scEFaWqE/jcAFyTLzjaQjd3nA7jH+wHplKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eN7clqFqHsLMCZ/gJiN7dAvCIZiWCIJlw8mAw5707eeODVlicCfJhnWbsFJ9c6fUn
	 fo5QOFaV1JZ/AJqN7xP+HtzY41GGyXHnGDx8eNOBtaKuNuuPJ5myt1Rx3sN4yaBsj+
	 QPLrpvcwcyCqav5EFj+aFoainPdvQ1FFJfM7+an+DpEexYZIbFpFHxR6P81a/eztmc
	 6dNm/RKBwZC4QJuWmJV8bOlI+rui5/Bta4Z+TcoKPMeO3PS4Om4HGAAU7tB7wxQgcl
	 lRAoGSRib7OykTpvQ2SIAX6abc5s3uCGMbnDaA4RKH0UkRVQ4dpZIAnra1o4BhOyUM
	 vLNXPJUT03izA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "luke-yj.chen" <luke-yj.chen@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] Bluetooth: btusb: MT7925: Add VID/PID 13d3/3609
Date: Mon, 31 Aug 2026 09:25:38 -0400
Message-ID: <20260831133314.4125787-310-sashal@kernel.org>
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

From: "luke-yj.chen" <luke-yj.chen@mediatek.com>

[ Upstream commit a55ef87b61b26097373fe8cbd2ead36582a8df4f ]

Add VID 13d3 & PID 3609 for MediaTek MT7925 USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=06 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3609 Rev= 1.00
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

Signed-off-by: luke-yj.chen <luke-yj.chen@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 3)...
Retry attempt 3...
## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[Bluetooth: btusb: MT7925] [add] Add VID/PID 13d3/3609 for
MediaTek MT7925 USB Bluetooth chip`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: luke-yj.chen <luke-yj.chen@mediatek.com>` (author,
  MediaTek)
- `Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>`
  (Bluetooth maintainer committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Cc: stable@vger.kernel.org`, or `Link:` tags

**Step 1.3 — Body**
Record: Adds USB VID 0x13d3 / PID 0x3609 for a MediaTek MT7925 combo
Bluetooth interface. Includes `/sys/kernel/debug/usb/devices` output
showing a standard 3-interface wireless controller
(`Manufacturer=MediaTek Inc.`, `Product=Wireless_Device`, `Driver=btusb`
on HCI interfaces). Symptom without the ID: device may bind generically
but lacks MediaTek-specific quirk flags, so Bluetooth does not work
correctly on this hardware variant.

**Step 1.4 — Hidden bug fix?**
Record: Not disguised as cleanup — it is an explicit hardware-enablement
ID addition. Functionally it fixes non-working Bluetooth on
laptops/modules using this USB ID.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- Files: `drivers/bluetooth/btusb.c` (+2 lines)
- Function/table: `quirks_table[]`
- Scope: single-file, surgical, 2-line addition

**Step 2.2 — Code flow**
Record:
- **Before:** `0x13d3:0x3609` not in `quirks_table[]`; probe falls
  through generic `btusb_table` match without `BTUSB_MEDIATEK |
  BTUSB_WIDEBAND_SPEECH`.
- **After:** Device gets `BTUSB_MEDIATEK | BTUSB_WIDEBAND_SPEECH` via
  `quirks_table` lookup during `btusb_probe()`.
- Affected path: USB device enumeration / driver probe for this
  hardware.

**Step 2.3 — Bug mechanism**
Record: **Hardware quirk / device ID** — missing USB ID entry. Without
it, `btusb_probe()` at lines 4018–4024 does not upgrade the match from
generic Bluetooth to MediaTek-specific handling, so `BTUSB_MEDIATEK`
setup (btmtk paths, firmware, WBS) is never applied.

**Step 2.4 — Fix quality**
Record: Obviously correct — identical pattern to neighboring entries
(`0x3608`, `0x3613`, etc.). Minimal risk; no API/locking changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Insertion point is between commits adding `0x3608`
(`cb45396f96f96`, Sep 2024) and `0x3613` (`bbf56029322c0`, May 2025).
Gap at `0x3609` is an omission, not a post-branch regression.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related changes**
Record: Multiple sibling MT7925 ID commits already in
`stable/linux-6.18.y`: `bbf56029322c0` (13d3/3613), `576952cf981b7`
(13d3/3627), `5bd5c716f7ec3` (13d3/3630), `f63f401130e5c` (13d3/3628),
etc. Standalone 1/1 patch.

**Step 3.4 — Author context**
Record: Author is MediaTek (`luke-yj.chen@mediatek.com`). Committed by
Bluetooth maintainer Luiz Augusto von Dentz. Same pattern as other
MediaTek ID submissions.

**Step 3.5 — Dependencies**
Record: None. Requires only existing `BTUSB_MEDIATEK`,
`BTUSB_WIDEBAND_SPEECH`, and `btmtk` support — all present in this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- Commit: `a55ef87b61b26097373fe8cbd2ead36582a8df4f`
- `b4 dig -c a55ef87b61b26`:
  https://patch.msgid.link/20260512060318.3288273-1-luke-
  yj.chen@mediatek.com
- `b4 dig -a`: v1 (2026-05-12) and v2 (2026-05-12); committed version
  matches v2
- No stable nomination or NAK found in thread mbox

**Step 4.2 — Reviewers**
Record: `b4 dig -w` CC'd Marcel Holtmann, Johan Hedberg, Luiz Von Dentz,
Sean Wang, linux-bluetooth, linux-mediatek.

**Step 4.3 — Bug report**
Record: N/A — hardware ID submission with USB descriptor evidence; no
syzbot/bugzilla.

**Step 4.4 — Series context**
Record: Standalone single-patch series (v1→v2).

**Step 4.5 — Stable list**
Record: Lore fetch blocked by bot protection for manual stable-list
search; no stable discussion found in downloaded mbox.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `quirks_table[]` (data), consumed in `btusb_probe()`.

**Step 5.2 — Callers**
Record: `btusb_probe()` called from USB core on device plug/enumeration
— standard hotplug path.

**Step 5.3 — Callees / effects**
Record: When `BTUSB_MEDIATEK` is set, probe configures
`btusb_mtk_setup`, `btmtk` send/recv, suspend/resume, and firmware
loading. When `BTUSB_WIDEBAND_SPEECH` is set,
`HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED` is enabled (line 4314).

**Step 5.4 — Reachability**
Record: Triggered by plugging in or booting with hardware using
`13d3:3609`. Common laptop WiFi+BT combo path.

**Step 5.5 — Similar patterns**
Record: ~15+ other `13d3:36xx` MT7925 entries in the same table section;
this fills a gap between `0x3608` and `0x3613`.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code exists?**
Record:
- Local tree: **linux-6.18.y**, `6.18.44` (`v6.18.44-1-g2736c32da98b9`)
- `0x13d3:0x3609` **absent** — confirmed gap at lines 754–756 between
  `0x3608` and `0x3613`
- Commit `a55ef87b61b26` **not** an ancestor of HEAD (`git merge-base
  --is-ancestor` exit 1)
- MT7925 infrastructure present: `btmtk.c` handles `0x7925`,
  `FIRMWARE_MT7925` defined, `CONFIG_BT_HCIBTUSB_MTK` in Kconfig

**Step 6.2 — Backport complications**
Record: `git apply --check` succeeds cleanly on current `btusb.c`.
Expected: trivial apply.

**Step 6.3 — Related fixes already present?**
Record: Sibling MT7925 IDs already in stable; `0x3609` specifically is
missing.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**
Record: `drivers/bluetooth/btusb.c` — Bluetooth USB HCI driver.
Criticality: **IMPORTANT** (peripheral driver, but affects real laptop
hardware).

**Step 7.2 — Activity**
Record: Active — multiple MT7925 ID additions through 2025–2026 already
landed in this stable series.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users with MediaTek MT7925 USB Bluetooth at `13d3:3609` (likely
recent laptops with IMC/ASUS-style combo modules).

**Step 8.2 — Trigger**
Record: Device enumeration at boot or hotplug. Unprivileged user cannot
directly trigger, but any system with this hardware hits it
automatically.

**Step 8.3 — Failure mode**
Record: Bluetooth non-functional or severely broken (wrong driver path,
no mtk setup/firmware, no WBS). Severity: **MEDIUM** for affected users
(complete feature loss, not kernel crash).

**Step 8.4 — Risk vs benefit**
Record:
- Benefit: **HIGH** for affected hardware (restores Bluetooth)
- Risk: **VERY LOW** (2-line ID table entry, identical to proven
  siblings)
- Ratio: strongly favors backport

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Classic stable exception: new USB device ID for existing driver
- MT7925/btusb/btmtk support already in 6.18.y
- Sibling IDs (3613, 3627, 3628, 3630) already backported to this tree
- Patch applies cleanly
- Committed by Bluetooth maintainer
- Real hardware with documented USB descriptors

**Evidence AGAINST:**
- None significant; not a new driver, API, or refactor

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — pattern matches ~15 existing
   entries; maintainer committed
2. Fixes real bug affecting users? **PASS** — Bluetooth broken without
   ID
3. Important issue? **PASS** — complete Bluetooth failure on affected
   hardware (MEDIUM severity)
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features/APIs? **PASS** — device ID only
6. Can apply to local tree? **PASS** — verified with `git apply --check`

**Exception category:** NEW DEVICE ID (USB VID/PID for existing `btusb`
+ `btmtk` MT7925 support)

---

## Verification

- [Phase 1] Parsed tags: only Signed-off-by from author and Luiz von
  Dentz
- [Phase 2] Diff: +2 lines in `quirks_table[]` between `0x3608` and
  `0x3613`
- [Phase 3] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 3] `git blame` lines 748–756: gap at 3609 between cb45396 and
  bbf56029
- [Phase 3] Sibling commits in stable: bbf56029, 576952cf, 5bd5c716,
  f63f4011
- [Phase 3] Commit hash: `a55ef87b61b26097373fe8cbd2ead36582a8df4f`; not
  in HEAD
- [Phase 4] `b4 dig -c a55ef87b61b26`: lore URL found
- [Phase 4] `b4 dig -a`: v1 and v2 revisions
- [Phase 4] `b4 dig -w`: Marcel Holtmann, Luiz von Dentz CC'd
- [Phase 4] Mbox: no stable nomination, no NAKs
- [Phase 5] `btusb_probe()` quirks lookup at lines 4018–4024 verified
- [Phase 5] `BTUSB_MEDIATEK` handling at lines 4113–4116, 4214–4228
  verified
- [Phase 5] `BTUSB_WIDEBAND_SPEECH` at line 4314 verified
- [Phase 6] `grep 0x3609` in btusb.c: no match (missing)
- [Phase 6] `git apply --check`: patch applies cleanly
- [Phase 6] `btmtk.c` MT7925 support and `FIRMWARE_MT7925` confirmed
- [Phase 6] `CONFIG_BT_HCIBTUSB_MTK` in Kconfig confirmed
- [Phase 8] Failure mode: Bluetooth non-functional without quirk flags

This is a textbook stable backport: a missing USB ID for hardware whose
driver stack already exists in linux-6.18.y, matching numerous sibling
MT7925 ID commits already present in this tree.

**YES**The background searches finished and matched what the full
analysis used:

- **btusb history:** Recent changes are mostly MT7925 VID/PID additions
  and unrelated fixes; `13d3/3609` was not in the stable tree.
- **Author/subject search:** Found nearby MT7925 IDs (`3604`, `3608`)
  but not `3609` on the checked-out `6.18.44` branch.
- **Branch search:** Located the commit as `a55ef87b61b26` on `all-
  next`/`master`/`net-next`, not in current stable HEAD.

**Verdict remains YES** — it’s a 2-line USB ID addition for existing
MT7925/btusb support, applies cleanly, and fills a gap between `0x3608`
and `0x3613` already present in `linux-6.18.y`.

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 66df9192df20a..5974aa2e94d48 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -758,6 +758,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3608), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3609), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3613), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3627), .driver_info = BTUSB_MEDIATEK |
-- 
2.53.0

