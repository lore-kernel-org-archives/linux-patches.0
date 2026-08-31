Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1674F59E333;
	Mon, 31 Aug 2026 13:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184313; cv=none; b=JeEW9sWTwTRgq3jG3xc24FkKINvXeC7/tnWEIHgF3A7bYDh25qxnZOyfBC3RSFvRz1+InQcV4s0pcLiAO5ZAQTy4VWGDJ4k1GnBV5Hs9nqlapqV9Cl55fNKjKC5sRgP2dXAVpQE+ha1jpb79J1NdWn3hw21/lpsUVkoJ3XyZu6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184313; c=relaxed/simple;
	bh=S8oPNqJK2YScA77w6HNluC2za2EJgvJstaFP6JIompQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CR2fZJxkQRAn3yrSESiuZ1VQkFCZ6e43XaojgYN4Z+IfEBxNAbN6sFEyBUDW5ClzE+VcnVuzLS2KGHR2OH4J6JeeH/+FrluaMZagtZZaDOG9leEIzz9y0sxeibP4qTQRQbPnUaTEF5Fe+oTfEUcefGOpe2Gf8xpJResxWsMcZ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWC+UEHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWC+UEHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3E41F00ACA;
	Mon, 31 Aug 2026 13:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184310;
	bh=eErB3ZsQF2vSimd9+eQ0cHMZgsfpSD/bccO35dY+BKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SWC+UEHI++G6+J/ikt5FVT1yUXd7PJfc0BIr49681kvFphshcy0BCdU2xMt2+5ppQ
	 EtBZNS8W2sZUDFvCWyxpKjEqwwp4wMzYTw5rmn5Wh7kuh7x5wxyV4tqP74QgKTfNXW
	 w/gAOSDbhLakW+V6NTHOWsGZxKY9tUlrWb4b0ReOK5F/D9s7nDwSr7uwWwY+Kvs1SK
	 UAZpl4NYv1sxhm6Srh1WvDTysv7CnPfb7HBcwY58RNLmWTfW7Kr2byDMWc8dKeumHU
	 7dv5h4w1Jyz4+VzthBD58+5rgv3CLroK4jVQBZ391RDYDRY2PAcaQZEFUQTkXcNjHQ
	 0MLrnjS3DnL7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nils Helmig <nils.helmig@web.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] Bluetooth: btusb: Add TP-Link UB600 for Realtek 8761BUV
Date: Mon, 31 Aug 2026 09:30:44 -0400
Message-ID: <20260831133314.4125787-616-sashal@kernel.org>
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

From: Nils Helmig <nils.helmig@web.de>

[ Upstream commit bc597f0cc44f0b173c50ee986a047219cd559ee9 ]

Add the vendor/product ID (0x37ad, 0x0600) to usb_device_id table
for Realtek 8761BUV.

The device info from /sys/kernel/debug/usb/devices as below.

T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  4 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=37ad ProdID=0600 Rev= 2.00
S:  Manufacturer=
S:  Product=TP-Link Bluetooth USB Adapter
S:  SerialNumber=ACA7F14FD2A5
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

Signed-off-by: Nils Helmig <nils.helmig@web.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
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
# Stable Backport Analysis: Bluetooth: btusb: Add TP-Link UB600 for
Realtek 8761BUV

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)
**Upstream commit:** `bc597f0cc44f0b173c50ee986a047219cd559ee9` (present
on `master`, **not** an ancestor of current HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 – Subject line**
Record: `[Bluetooth: btusb] [Add] [TP-Link UB600 USB ID (0x37ad:0x0600)
for Realtek 8761BUV chipset]`

**Step 1.2 – Tags**
Record:
- `Signed-off-by: Nils Helmig <nils.helmig@web.de>` (author)
- `Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>`
- `Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>`
  (Bluetooth maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`,
  `Tested-by:`, or `Acked-by:`

Notable: maintainer Signed-off-by and Reviewed-by present; no syzbot or
crash report (expected for device-ID patches).

**Step 1.3 – Body analysis**
Record:
- **Bug described:** TP-Link UB600 (VID 0x37ad, PID 0x0600) is a Realtek
  8761BUV USB Bluetooth adapter not recognized in `quirks_table`.
- **Symptom:** Device enumerates as generic Bluetooth USB (`Cls=e0`) but
  lacks the Realtek-specific quirk flags needed for proper driver
  handling.
- **Root cause (from code context):** Without a `quirks_table` entry
  with `BTUSB_REALTEK | BTUSB_WIDEBAND_SPEECH`, the chip does not get
  Realtek firmware setup via `btrtl`.
- **Version info:** None in commit message.

**Step 1.4 – Hidden bug fix?**
Record: **Yes, disguised as hardware enablement.** This is not a crash
fix, but a functional bug: the adapter does not work on Linux without
the ID. External documentation confirms users must manually patch
`btusb.c` to load firmware on pre-7.2 kernels.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 – Inventory**
Record:
- **Files:** `drivers/bluetooth/btusb.c` (+2 / -0)
- **Function/section:** `quirks_table[]` static table
- **Scope:** Single-file, 2-line surgical addition

**Step 2.2 – Code flow change**
Record:
- **Before:** `0x37ad:0x0600` not in `quirks_table`; device may bind via
  generic `btusb_table` USB class match with `driver_info == 0`.
- **After:** Device matches `quirks_table` entry with `BTUSB_REALTEK |
  BTUSB_WIDEBAND_SPEECH`.
- **Affected path:** USB probe → `btusb_probe()` → `usb_match_id(intf,
  quirks_table)` when `id->driver_info` is zero (lines 4018–4023).

**Step 2.3 – Bug mechanism**
Record: **Hardware quirk / device ID category (exception #1).** Without
`BTUSB_REALTEK`:
- No `btrealtek_data` allocation (line 4108)
- No `btusb_setup_realtek` / `btrtl_shutdown_realtek` hooks (lines
  4279–4285)
- Realtek 8761BU firmware (`rtl_bt/rtl8761bu_fw`) is never loaded via
  `btrtl`

**Step 2.4 – Fix quality**
Record:
- **Obviously correct:** Uses identical flags as all other 8761BUV
  entries in the same section (e.g., `0x2b89:0x6275`, `0x2357:0x0604`
  TP-Link UB500).
- **Minimal:** 2 lines, no unrelated changes.
- **Regression risk:** Very low — only affects this specific VID/PID.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 – Blame**
Record: Target insertion point is the `/* Additional Realtek 8761BUV
Bluetooth devices */` section (lines 788–804), present since 2022
(`c77a592befddf`). Last entry `0x2b89:0x6275` added in `112a000505b88`
(Oct 2025). The 8761BUV infrastructure is long-established in this tree.

**Step 3.2 – Fixes: tag**
Record: N/A — no `Fixes:` tag present.

**Step 3.3 – Related file history**
Record:
- `4fd6d49079617` (2021): Added TP-Link UB500 (`0x2357:0x0600`) — same
  vendor family, same chip class, same pattern; **already in 6.18.44**
- `112a000505b88`: Added `0x2b89:0x6275` for RTL8761BUV
- Recent btusb commits on 6.18.y are bug fixes (UAF, vendor event
  validation), unrelated to this ID

**Step 3.4 – Author context**
Record: Nils Helmig is a contributor (not subsystem maintainer). Luiz
Augusto von Dentz (maintainer) has Signed-off-by on the committed
version.

**Step 3.5 – Dependencies**
Record: **Standalone.** No series dependencies. All required symbols
(`BTUSB_REALTEK`, `BTUSB_WIDEBAND_SPEECH`, `quirks_table`, `btrtl`
8761BU support) exist in 6.18.44. `git apply --check` succeeds with
2-line offset.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 – Original discussion**
Record:
- Lore URL:
  https://patch.msgid.link/20260530123934.4583-1-nils.helmig@web.de
- Series: v1 (2026-04-25) → v3 (2026-05-30); committed version is v3
  (latest)

**Step 4.2 – Reviewers**
Record (`b4 dig -w`): CC'd to `linux-bluetooth@vger.kernel.org`, Marcel
Holtmann, Luiz Augusto von Dentz. Appropriate maintainers were included.

**Step 4.3 – Bug reports**
Record: No formal bugzilla/syzbot report. User blog (myshell.co.uk)
documents that UB600 requires manual `btusb.c` patching on kernels
before 7.2 — confirms real user impact.

**Step 4.4 – Related patches**
Record: Standalone 1-patch series. No other patches required.

**Step 4.5 – Stable list**
Record: No stable-list discussion found. Not a negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 – Key functions**
Record: `quirks_table[]` (data), consumed by `btusb_probe()` via
`usb_match_id()`.

**Step 5.2 – Callers**
Record: `btusb_probe()` called during USB device enumeration on plug-in
— common, user-triggered path.

**Step 5.3 – Callees**
Record: When `BTUSB_REALTEK` is set, probe path uses
`btrtl_set_driver_name()`, `btusb_setup_realtek()`,
`btrtl_shutdown_realtek()` — all present in tree when
`CONFIG_BT_HCIBTUSB_RTL` is enabled.

**Step 5.4 – Reachability**
Record: Any user plugging in a TP-Link UB600 triggers this. Unprivileged
physical access (USB insert). Not a security issue, but broad hardware
enablement.

**Step 5.5 – Similar patterns**
Record: TP-Link UB500 (`0x2357:0x0604`) in the same 8761BUV section with
identical flags — direct precedent already in 6.18.44.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

**Step 6.1 – Buggy code exists?**
Record: **YES.** The 8761BUV `quirks_table` section exists (lines
788–804) but lacks `0x37ad:0x0600`. `0x37ad` not present anywhere in
`drivers/bluetooth/btusb.c`. Commit `bc597f0` is **NOT** an ancestor of
HEAD.

**Step 6.2 – Backport complications**
Record: **Clean apply.** `git apply --check` succeeded (hunk at line
802, offset 2). No refactoring conflicts.

**Step 6.3 – Related fixes already present?**
Record: **No.** `git log --grep="UB600"` and `git log -S'0x37ad'` on
`btusb.c` return nothing. UB500 support (`4fd6d49079617`) is present as
precedent.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 – Subsystem**
Record: `drivers/bluetooth/btusb.c` — Bluetooth USB HCI driver.
**Criticality: IMPORTANT** (affects users of USB Bluetooth adapters, not
core kernel).

**Step 7.2 – Activity**
Record: Actively maintained; recent stable commits include Realtek
validation fixes and UAF fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 – Who is affected**
Record: Users of TP-Link UB600 USB Bluetooth adapters on 6.18.y without
this ID.

**Step 8.2 – Trigger conditions**
Record: Plugging in TP-Link UB600 (0x37ad:0x0600). Common user action.
Requires `CONFIG_BT_HCIBTUSB` (and `CONFIG_BT_HCIBTUSB_RTL` for firmware
— same as all other Realtek USB BT devices).

**Step 8.3 – Failure mode severity**
Record: **Bluetooth non-functional** (no firmware load, limited ROM-only
mode). Severity: **MEDIUM** for affected hardware — device is
effectively broken without the ID. Not a crash/corruption/security
issue.

**Step 8.4 – Risk-benefit**
Record:
- **Benefit:** HIGH for UB600 owners (device works out of box)
- **Risk:** VERY LOW (2-line ID addition, identical to 8 existing
  8761BUV entries)
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 – Evidence summary**

**FOR backport:**
- Standard stable exception: new USB device ID for existing driver
- Direct precedent: TP-Link UB500 (`0x2357:0x0600`) already in 6.18.44
  with same flags
- Real user impact documented (manual patching required without kernel
  support)
- Maintainer Signed-off-by + Reviewed-by
- Applies cleanly to 6.18.44
- All infrastructure (8761BUV section, `btrtl` 8761BU firmware) present

**AGAINST backport:**
- Not a crash/security/corruption fix
- Only affects one specific USB adapter model
- Requires `CONFIG_BT_HCIBTUSB_RTL` for full functionality (same as all
  Realtek btusb devices)

**Unresolved:** None material to the decision.

**Step 9.2 – Stable rules checklist**
1. Obviously correct and tested? **PASS** — identical pattern to
   existing entries; Reviewed-by present
2. Fixes a real bug affecting users? **PASS** — hardware non-functional
   without ID
3. Important issue? **PASS** — hardware enablement (stable-accepted
   category)
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features/APIs? **PASS** — device ID only
6. Can apply to local tree? **PASS** — verified clean apply

**Step 9.3 – Exception category**
Record: **NEW DEVICE ID** — adding `0x37ad:0x0600` to existing `btusb`
driver's `quirks_table` for already-supported Realtek 8761BUV chipset.

---

## What Problem This Solves

The TP-Link UB600 is a Realtek RTL8761BU-based USB Bluetooth adapter
sold under TP-Link's vendor ID (`0x37ad:0x0600`) rather than Realtek's
(`0x0bda`). Without this `quirks_table` entry, `btusb_probe()` never
sets `BTUSB_REALTEK`, so the `btrtl` firmware loader never runs and
Bluetooth does not work. Adding the ID with the same flags as other
8761BUV devices enables full functionality — exactly as was done earlier
for the TP-Link UB500 (`0x2357:0x0600`) already present in 6.18.44.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified device-ID enablement
  pattern
- [Phase 2] Diff: +2 lines in `quirks_table[]`, `BTUSB_REALTEK |
  BTUSB_WIDEBAND_SPEECH`
- [Phase 3] `git describe HEAD`: v6.18.44; `git merge-base --is-ancestor
  bc597f0 HEAD`: NOT ancestor
- [Phase 3] `git blame -L 788,804`: 8761BUV section present since 2022
- [Phase 3] `4fd6d49079617`: TP-Link UB500 precedent in tree
- [Phase 3] `git apply --check`: patch applies cleanly (offset 2)
- [Phase 4] `b4 dig -c bc597f0`: lore thread found (v3, 2026-05-30)
- [Phase 4] `b4 dig -a`: v1→v3 series; v3 is latest
- [Phase 4] `b4 dig -w`: Marcel Holtmann, Luiz von Dentz CC'd
- [Phase 5] Read `btusb_probe()` lines 4018–4023, 4108–4113, 4279–4285:
  confirmed Realtek flag dependency
- [Phase 5] `btrtl.c` lines 225–231: 8761BU firmware support present
- [Phase 6] `grep 0x37ad btusb.c`: not present; `0x2357, 0x0604` (UB500)
  present at line 789
- [Phase 6] `CONFIG_BT_HCIBTUSB_RTL` in Kconfig: present
- [Phase 8] External blog confirms pre-7.2 kernels need manual patch for
  UB600

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fad09a01ae125..38a066cc3404a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -815,6 +815,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2b89, 0x6275), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x37ad, 0x0600), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0

