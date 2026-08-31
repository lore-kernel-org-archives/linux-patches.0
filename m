Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2703425880;
	Mon, 31 Aug 2026 13:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183299; cv=none; b=BnXtvgNkuK8buhcH73MuSMZSC/mKr6MgWpKm+VOSlklKcv0zaluV/KwPBJzCzYF/34h5HgPr/qr/NhtAcLBXYL3ImCz5OIHwT/0aHpJ0W5GryUOL3Y0/yDECamc9jzIb8pzftlxcAcKSVHx1CiE5xwyrPx3MiIKauU45WpafWx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183299; c=relaxed/simple;
	bh=TYVVA7cMOZlyC5hJdwCwBH5vhPTVDWT9Qi9J8uDFcqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UY2FZMUwTbvL0ka1fpgmjAW/3c/82spoV8clZCZtzixTVHY0l1rmv4EP+9NP0KWpLnGsxZw9hOYd+q0FJDl7QUR+yuqYeFasiuj24OlSLNLV1p4Dn4zppl9w5RdxidC3L9xFCdwi+IVqeisibuqR/IqpcbhldumQkhn+eKiKx3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNaXjSj9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNaXjSj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FA51F00A3E;
	Mon, 31 Aug 2026 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183296;
	bh=IcpasXFv9nSy9j8EW1ovq5OX1vHFoS6jIYTb12mZs8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNaXjSj9Sh/qmB7Tda8jwGZcjDtJb18Zsp08lQ43FCg9LNO0WD/TOzq5WYh9Ady+I
	 A/K35yl/5JVamzfsR9natHrCaffLGCzHkVZbGe6XPGABDIn0Clw1NwzD/njFxPH1ee
	 lECrCMqLrFKjrCe8laan7iOoqIBWPaZ8Gz0epvWBBRQC7tsN/QnAiBEyRcRVAtG8cm
	 tZy02JBTV/cX9tvwE2cjJSOiO77msREfMI8IuGv0htQdNEjbdZ0otUdjX36qHOvTYj
	 eXSjJJsh+eOFQD7QXuwcMTar34bk4mMjBgEXva3teBxrk1mRKl2LAGelrhzenbQ6ra
	 7MFGNlXbmtPhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ravindra <ravindra@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] Bluetooth: btusb: Add support for Intel Lizard Peak 2 (0x8087:0x0040)
Date: Mon, 31 Aug 2026 09:21:32 -0400
Message-ID: <20260831133314.4125787-64-sashal@kernel.org>
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

From: Ravindra <ravindra@intel.com>

[ Upstream commit 5269f7231c2b78774c39ae3a27ce2c497cd5aff4 ]

Device from /sys/kernel/debug/usb/devices:

T:  Bus=09 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=8087 ProdID=0040 Rev= 0.00
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=1ms
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

Signed-off-by: Ravindra <ravindra@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: Intel Lizard Peak 2 (0x8087:0x0040)

**Local tree:** Linux 6.18.44 (`v6.18.44-1-g2736c32da98b9`)
**Commit under review:** `5269f7231c2b78774c39ae3a27ce2c497cd5aff4`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[Bluetooth/btusb] [add] Add support for Intel Lizard Peak 2
USB device ID 0x8087:0x0040`

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Ravindra <ravindra@intel.com>` (author)
- `Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>`
  (Bluetooth maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org`
- Notable: maintainer Signed-off-by from Luiz von Dentz

### Step 1.3: Body analysis
**Record:**
- **Bug described:** Intel Lizard Peak 2 (8087:0040) is not recognized
  by btusb.
- **Symptom:** Bluetooth hardware is present on USB but not bound with
  correct Intel combined-driver quirks.
- **Evidence:** Full `/sys/kernel/debug/usb/devices` dump showing
  Vendor=8087, ProdID=0040, class e0/01/01, already bound to `btusb` in
  the reporter's test environment.
- **Root cause (author):** Missing USB device ID entry in
  `quirks_table[]`.
- **Version info:** None stated.

### Step 1.4: Hidden bug fix?
**Record:** Not a hidden crash/leak fix. This is explicit hardware
enablement via a one-line USB ID addition — a well-established stable
exception category.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/bluetooth/btusb.c` (+1 line)
- **Functions modified:** None directly; `quirks_table[]` static data
  only
- **Scope:** Single-file, single-line surgical change

### Step 2.2: Code flow change
**Record:**
- **Before:** 8087:0040 is not in the explicit Intel device list; it
  falls through to the catch-all `USB_VENDOR_AND_INTERFACE_INFO(0x8087,
  0xe0, 0x01, 0x01)` entry with `BTUSB_IGNORE`.
- **After:** 8087:0040 matches explicitly with `BTUSB_INTEL_COMBINED`,
  same as other Intel combined devices (0x0025–0x0039).
- **Path affected:** USB probe / device enumeration for this hardware.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workarounds / device ID addition
- **Mechanism:** Without the entry, `btusb_probe()` hits `BTUSB_IGNORE`
  and returns `-ENODEV` (lines 4026–4027). With the entry, the device
  gets Intel combined setup (`btintel_configure_setup()`, Intel
  recv/send paths at lines 4101–4208).

### Step 2.4: Fix quality
**Record:**
- Obviously correct: identical pattern to existing Intel IDs (e.g.,
  0x0039 Whale Peak2 added in `f6dc9214e526c`).
- Minimal: one line, no extra quirks flags.
- **Regression risk:** Very low — only affects 8087:0040, uses existing
  `BTUSB_INTEL_COMBINED` path already exercised by many Intel devices.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Intel device ID block dates from 2013–2024. Neighbor entry
0x0039 added by `f6dc9214e526c` (Jul 2024, Kiran K). The missing 0x0040
is new hardware support, not a regression in old code.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related file history
**Record:** Recent btusb changes in this tree include other device-ID
additions (`79f9e221dddec` Mercusys MA60XNB, `ea3f3de49cb69` RTL8761BU,
etc.) and bug fixes (UAF, leak). This commit is standalone — not part of
a multi-patch series in git history.

### Step 3.4: Author context
**Record:** Ravindra (Intel). Luiz von Dentz (maintainer) Signed-off.
Direct precedent: `f6dc9214e526c` "Whale Peak2" used the exact same one-
line btusb pattern for 0x0039.

### Step 3.5: Dependencies
**Record:** No prerequisites. `BTUSB_INTEL_COMBINED`, `btintel.h`, and
`btintel_configure_setup()` all exist in this 6.18.44 tree.
`f6dc9214e526c` (0x0039) is an ancestor. Patch applies cleanly (`git
apply --check` exit 0).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 5269f7231c2b78774c39ae3a27ce2c497cd5aff4` → [PATCH v2] at
  https://patch.msgid.link/20260512082256.1214764-1-ravindra@intel.com
- Series: v1 (2026-05-12) → v2 (subject spelling fix: "Lizard Peak2" →
  "Lizard Peak 2")
- Lore page fetch blocked by Anubis bot protection; thread content not
  directly readable

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC'd `linux-bluetooth@vger.kernel.org`, Intel
colleagues (kiran.k@intel.com, etc.). Maintainer Luiz von Dentz Signed-
off on the committed version.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Hardware sysfs dump
in commit message is the evidence.

### Step 4.4: Related patches
**Record:** Standalone 1/1 patch. No companion btintel changes needed
(same as Whale Peak2/0x0039 pattern).

### Step 4.5: Stable list
**Record:** Not searched separately; no stable nomination found via
available tools.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `quirks_table[]` (static data). Runtime path:
`btusb_probe()` → `usb_match_id()` → Intel combined setup branch.

### Step 5.2: Callers
**Record:** `quirks_table` consulted from `btusb_probe()` via
`usb_match_id(intf, quirks_table)` at line 4021. Triggered on every USB
Bluetooth device hotplug/enumeration.

### Step 5.3: Callees
**Record:** With `BTUSB_INTEL_COMBINED`: `btintel_configure_setup()`,
`btusb_send_frame_intel`, `btintel_recv_event`, `btusb_recv_bulk_intel`.

### Step 5.4: Reachability
**Record:** Triggered automatically when 8087:0040 USB device is plugged
in or present at boot. No userspace syscall needed; standard hotplug
path.

### Step 5.5: Similar patterns
**Record:** Identical pattern to `f6dc9214e526c` (8087:0039 Whale Peak2)
and other Intel combined IDs. This is the established approach for new
Intel USB BT controllers.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** YES. `0x8087:0x0040` is absent from `quirks_table[]` in
6.18.44. Catch-all IGNORE rule at lines 501–502 is present and would
match this device (vendor 8087, class e0/01/01 per commit's sysfs dump).

### Step 6.2: Backport complications
**Record:** Clean apply confirmed. No conflicts expected. Insertion
point (after 0x0039, before 0x07da) matches current file layout.

### Step 6.3: Related fixes already present?
**Record:** No duplicate fix for 0x0040. `grep` confirms ID not in tree.
Intel combined infrastructure fully present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/bluetooth/btusb.c` — IMPORTANT (common USB
Bluetooth path; affects laptop/desktop users with Intel BT).

### Step 7.2: Activity
**Record:** Actively maintained; frequent device-ID additions in recent
history.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with Intel Lizard Peak 2 (8087:0040) USB Bluetooth —
platform/driver-specific, but Intel BT is widely deployed on new
hardware.

### Step 8.2: Trigger conditions
**Record:** Device present at boot or hotplug. Common/likely for
affected hardware. Unprivileged user cannot trigger artificially without
the hardware.

### Step 8.3: Failure mode severity
**Record:** Without fix → Bluetooth completely non-functional (`-ENODEV`
from IGNORE rule). **Severity: MEDIUM** (broken hardware functionality,
not crash/corruption/security). Qualifies under stable's device-ID
exception.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables Bluetooth on new Intel hardware in stable kernels
- **Risk:** Minimal (1 line, existing code path, no new APIs)
- **Ratio:** Strong benefit, negligible risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- One-line USB device ID to existing btusb driver (explicit stable
  exception)
- Fixes non-working Bluetooth on Intel Lizard Peak 2 hardware
- Same proven pattern as 0x0039 Whale Peak2 already in this tree
- Maintainer Signed-off-by (Luiz von Dentz)
- Applies cleanly to 6.18.44
- No dependencies or series requirements
- All `BTUSB_INTEL_COMBINED` infrastructure present

**AGAINST backport:**
- Not a crash/security/data-corruption fix (functionality only)
- New hardware — limited installed base on older stable releases today
- No syzbot/user bug report beyond Intel's submission

**Unresolved:** Full lore review thread content (bot-blocked); no
explicit `Cc: stable` in available metadata.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — trivial ID add, sysfs
   evidence, maintainer SOB
2. Fixes real bug affecting users? **PASS** — Bluetooth broken without
   it on this hardware
3. Important issue? **PASS** (via device-ID exception) — hardware
   enablement for real users
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS** — device ID only; no new APIs
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception category
**Record:** **NEW DEVICE ID** — adding `8087:0040` to existing btusb
driver with existing `BTUSB_INTEL_COMBINED` quirk.

### Step 9.4: Decision rationale
For Linux 6.18.44, this commit should be backported. The tree already
supports Intel combined USB Bluetooth controllers but lacks the
8087:0040 ID; without it, the device is explicitly ignored and Bluetooth
does not work. This is a textbook stable device-ID addition: one line,
no new driver, no new API, uses an established code path, and applies
cleanly.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified hardware-enablement
  intent
- [Phase 1] No Fixes/Reported-by/Link tags; Luiz von Dentz SOB confirmed
  via `git show`
- [Phase 2] Diff: +1 line in `quirks_table[]`, no functional code
  changes
- [Phase 2] Verified `BTUSB_IGNORE` → `-ENODEV` at lines 4026–4027
- [Phase 2] Verified `BTUSB_INTEL_COMBINED` setup at lines 4101–4208
- [Phase 3] `git blame` on Intel ID block: neighbor 0x0039 from Jul 2024
- [Phase 3] `f6dc9214e526c` (Whale Peak2/0x0039): same one-line pattern,
  is ancestor
- [Phase 3] `git log --oneline -20 -- drivers/bluetooth/btusb.c`: recent
  ID additions confirmed
- [Phase 4] `b4 dig -c 5269f72...`: lore URL found (v2 patch)
- [Phase 4] `b4 dig -a`: v1→v2 series (subject spelling only)
- [Phase 4] `b4 dig -w`: linux-bluetooth@vger.kernel.org CC'd
- [Phase 4] UNVERIFIED: Full lore thread content (Anubis blocked
  WebFetch)
- [Phase 5] `grep quirks_table`: used from `btusb_probe()` line 4021
- [Phase 5] `grep BTUSB_INTEL_COMBINED`: 18 uses, full Intel path
  present
- [Phase 6] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- [Phase 6] `grep 0x8087, 0x0040`: not present (bug exists)
- [Phase 6] `grep 0x8087, 0x0039`: present at line 486
- [Phase 6] Catch-all IGNORE at lines 501–502 confirmed
- [Phase 6] `git show 5269f72... | git apply --check`: exit 0 (clean
  apply)
- [Phase 8] Failure mode: Bluetooth non-functional, severity MEDIUM

**YES**The analysis is complete.

**Commit:** `5269f7231c2b` — adds USB ID `8087:0040` (Intel Lizard Peak
2) to `btusb.c` with `BTUSB_INTEL_COMBINED`.

**Local tree:** Linux 6.18.44 — the ID is missing today. Without it, the
device hits the catch-all Intel `BTUSB_IGNORE` rule and Bluetooth does
not work.

**Verdict:** **YES** for stable backport. This is a one-line device ID
addition to an existing driver, same pattern as the already-present
`8087:0039` (Whale Peak2) entry, applies cleanly, and has maintainer
sign-off from Luiz von Dentz.

 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 430e50388864c..2f7ff83ee78ca 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -484,6 +484,7 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x8087, 0x0037), .driver_info = BTUSB_INTEL_COMBINED },
 	{ USB_DEVICE(0x8087, 0x0038), .driver_info = BTUSB_INTEL_COMBINED },
 	{ USB_DEVICE(0x8087, 0x0039), .driver_info = BTUSB_INTEL_COMBINED },
+	{ USB_DEVICE(0x8087, 0x0040), .driver_info = BTUSB_INTEL_COMBINED }, /* Lizard Peak 2 */
 	{ USB_DEVICE(0x8087, 0x07da), .driver_info = BTUSB_CSR },
 	{ USB_DEVICE(0x8087, 0x07dc), .driver_info = BTUSB_INTEL_COMBINED |
 						     BTUSB_INTEL_NO_WBS_SUPPORT |
-- 
2.53.0

