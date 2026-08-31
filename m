Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD9F44A701;
	Mon, 31 Aug 2026 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183671; cv=none; b=FmKbqE4/I6/RFjCJNAKvI1X7eDOtAm9KhbVHp1zK+2m8gV6duTWWQBdZ/mpunu1EnoMIJfMDyl/PYST2zkTaFjwAug5lVmhRTELYMQTnp9APFTMLqz0ZFjfAeFjTGmerWCQKIAXzXjCrYDUyqEFykw7GJa6bL6LLC844C1Lsf90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183671; c=relaxed/simple;
	bh=pBN4fcc1fiA7+GCxC11i+L4p6P9qGCHbI4x1U8Pms0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJjecfyfhn7eiPr4qNMmretEX4HCeUdmBdT+W+2DUm/zXm1uYGl7/nHbH6dsWQrZ/YWMTNC3hscK0LJ+geCG+XFP6kGu6tzWJ1PEtitLSVROFhzZBysLXlteK+zCgMX6b/lluwdgyB4K3QA78n4SH+URb/0yskcaUP7c0P+xAQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4d7VK3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4d7VK3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6D81F00A3E;
	Mon, 31 Aug 2026 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183668;
	bh=Ojh/9B4EbSkNtTqvQ/mgtwjhwV817bk1bE98Z2tgAvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4d7VK3hKyz3tzs7R6MFGeW1XipdZYHdnattQ3itnQzFhsq1Ttv+9pWuFwX6iVgk1
	 YGwHSUFyW/KYPP3S/wG/ERGkimNgRZKg2nwqXOSPKhf7JiPpPiVEqhBYAzGMJ+UUC4
	 I7JvetrW/34x/tBRNuY+jF+bC5F9xAMegdJwQufmIM79YNODHwarVGLKfmzYiJWP2r
	 TDG2af/FdVmo0oTtHPNYHilzfX6bF5jdKPVHjDPtyfTzeH0huRCCEs5g1MV7jb4PyP
	 O9iW6YKLmO85QAc8R/vdn0+ShABr43/X9m+qRXJWUph3U6Y8QAp4MDot6b65Is7oQw
	 gM6d5BspvD4Hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hrvoje Nuic <hrvoje.nuic@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] Bluetooth: btusb: Add Mercusys MA530 for Realtek RTL8761BUV
Date: Mon, 31 Aug 2026 09:24:21 -0400
Message-ID: <20260831133314.4125787-233-sashal@kernel.org>
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

From: Hrvoje Nuic <hrvoje.nuic@gmail.com>

[ Upstream commit ce21a5cf3d1fd92b84ea9ad2b7c7240aff2162d2 ]

Add the USB ID for the Mercusys MA530 Bluetooth adapter. The device uses
a Realtek RTL8761BUV controller and works with the existing Realtek setup
path.

The device reports vendor ID 0x2c4e and product ID 0x0115, and loads the
rtl_bt/rtl8761bu_fw.bin firmware successfully with this quirk.

Signed-off-by: Hrvoje Nuic <hrvoje.nuic@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: Bluetooth: btusb: Add Mercusys MA530 for
Realtek RTL8761BUV

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[Bluetooth: btusb] [Add] Mercusys MA530 USB ID for Realtek
RTL8761BUV controller`

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — not present
- **Tested-by:** — not present (author describes successful firmware
  load in body)
- **Reviewed-by:** — not present
- **Acked-by:** — not present
- **Link:** — not present
- **Cc: stable@vger.kernel.org** — not present
- **Signed-off-by:** Hrvoje Nuic \<hrvoje.nuic@gmail.com\> (author)
- **Signed-off-by:** Luiz Augusto von Dentz \<luiz.von.dentz@intel.com\>
  (Bluetooth maintainer merge)

Notable: Maintainer Signed-off-by from Luiz von Dentz indicates
subsystem maintainer acceptance. No syzbot or multi-reporter tags.

### Step 1.3: Analyze commit body
**Record:**
- **Bug description:** Mercusys MA530 Bluetooth adapter (USB 2c4e:0115,
  Realtek RTL8761BUV) is not in `quirks_table`, so it does not get
  Realtek-specific driver setup.
- **Symptom:** Bluetooth non-functional — device may enumerate as USB
  but no working HCI controller (confirmed by user reports on Manjaro
  6.16.8 and Fedora 6.18.3).
- **Version info:** None in commit message.
- **Root cause:** Missing USB ID entry with `BTUSB_REALTEK |
  BTUSB_WIDEBAND_SPEECH` flags needed for Realtek firmware loading and
  wideband speech support.

### Step 1.4: Detect hidden bug fixes
**Record:** Not a hidden bug fix — this is an explicit hardware
enablement patch (new USB device ID). Functionally equivalent to fixing
broken hardware support for Mercusys MA530 owners.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `drivers/bluetooth/btusb.c` (+2 lines, 0 removed)
- **Functions modified:** `quirks_table[]` static data only (no function
  body changes)
- **Scope:** Single-file, surgical device ID addition

### Step 2.2: Code flow change
**Record:**
- **Before:** Device 2c4e:0115 matches generic `btusb_table` entry
  (Bluetooth class 0xe0/0x01/0x01) with `driver_info = 0`. Probe falls
  through to `usb_match_id(intf, quirks_table)` at line 4021, finds no
  match, and proceeds without `BTUSB_REALTEK` or
  `BTUSB_WIDEBAND_SPEECH`.
- **After:** Same device matches new `quirks_table` entry → gets
  `BTUSB_REALTEK | BTUSB_WIDEBAND_SPEECH` → Realtek setup path
  (`btusb_setup_realtek`, firmware load via btrtl) and wideband speech
  quirk are enabled.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workarounds / device ID addition
- **Mechanism:** Without explicit ID + Realtek quirk flags, the
  RTL8761BUV controller never receives Realtek-specific probe handling
  despite binding to btusb generically. Firmware is not loaded
  correctly; no HCI device appears.

### Step 2.4: Fix quality assessment
**Record:**
- **Quality:** Obviously correct — identical pattern to existing 8761BUV
  entries (e.g., 0x2357:0x0604, 0x2b89:0x8761) and sibling Mercusys
  entry 0x2c4e:0x0128 already in this tree.
- **Regression risk:** Very low — adds one table row; no logic changes.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** Insertion point is the `/* Additional Realtek 8761BUV
Bluetooth devices */` section (blame shows entries from 2021–2025). The
missing ID is not a regression from a specific commit — it was never
added. Realtek 8761BUV support has existed since ~2021.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:**
- `79f9e221dddec` — Add USB ID 2c4e:0128 for Mercusys MA60XNB (same
  vendor 0x2c4e, backported to stable 6.6.x with `Cc:
  stable@vger.kernel.org`)
- `112a000505b88` — Add 2b89:6275 for RTL8761BUV
- `ea3f3de49cb69` — Add device ID for Realtek RTL8761BU
- **Prerequisites:** None — standalone one-line ID addition.
- **Series:** Standalone patch (not part of a multi-patch series).

### Step 3.4: Author's other commits
**Record:** Hrvoje Nuic has no other commits in this 6.18.y tree. Luiz
von Dentz is Bluetooth subsystem maintainer (merged the patch upstream
per patchwork-bot notification).

### Step 3.5: Dependencies
**Record:** No dependencies. Requires only infrastructure already
present in 6.18.y:
- `BTUSB_REALTEK` and `BTUSB_WIDEBAND_SPEECH` defines
- Realtek probe path in `btusb_probe()`
- `rtl8761bu` firmware support in `btrtl.c`

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- Upstream commit: `0105c3e2a97e` (bluetooth-next, per patchwork-bot)
- Lore thread: `https://lore.kernel.org/linux-
  bluetooth/20260422212647.62497-1-hrvoje.nuic@gmail.com/T/` (bot-
  protected; could not fetch full thread)
- Applied by Luiz von Dentz on 2026-04-23
- **b4 dig -c 0105c3e2a97e:** FAILED — commit not present in local tree
- Prior community submissions exist (Santiago CR, Jan 2026; lespink, Oct
  2025) describing same device and same fix

### Step 4.2: Reviewers
**Record:** CC'd to marcel@, luiz.dentz@, linux-bluetooth@, linux-
kernel@ per web search. Maintainer merged without reported NAKs.

### Step 4.3: Bug reports
**Record:**
- Manjaro forum: MA530 (2c4e:0115) detected, firmware present, but no
  HCI device on kernel 6.16.8
- Prior patch submission tested on Fedora 43 / kernel 6.18.3 — device
  non-functional without ID
- **Severity:** Device completely unusable for Bluetooth on affected
  kernels

### Step 4.4: Related patches
**Record:** Multiple independent submissions for same USB ID confirm
real-world demand. Only Hrvoje Nuic's version (placed in 8761BUV
section) was merged upstream.

### Step 4.5: Stable mailing list history
**Record:** No stable-list discussion found for MA530 specifically.
Precedent: sibling Mercusys 2c4e:0128 explicitly nominated `Cc:
stable@vger.kernel.org # 6.6.x`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** No functions modified. Data table `quirks_table[]` consumed
by `btusb_probe()`.

### Step 5.2: Callers
**Record:** `btusb_probe()` called during USB device enumeration
(hotplug). Every USB Bluetooth dongle insertion passes through this
path.

### Step 5.3: Callees
**Record:** When `BTUSB_REALTEK` is set, probe configures:
- `btusb_setup_realtek` / `btrtl_shutdown_realtek` / `btusb_rtl_reset`
- `BTUSB_USE_ALT3_FOR_WBS` flag
- When `BTUSB_WIDEBAND_SPEECH` is set:
  `HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED`

### Step 5.4: Call chain / reachability
**Record:** User plugs in Mercusys MA530 → USB core enumerates → btusb
binds (generic or quirk match) → probe applies Realtek setup only if
quirk matched → firmware loaded from `rtl_bt/rtl8761bu_fw.bin` → HCI
device created. **Reachable from normal user hardware insertion.**

### Step 5.5: Similar patterns
**Record:** Identical pattern for 10+ RTL8761BUV devices in same table
section; Mercusys 0x2c4e:0x0128 already present at line 534–535 in this
tree.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.y)

### Step 6.1: Does the buggy code exist?
**Record:** **YES.** Device ID 0x2c4e:0x0115 is absent from
`quirks_table[]`. The 8761BUV section exists at lines 788–804. All
Realtek infrastructure is present. Bug affects any Mercusys MA530 user
on 6.18.y.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Patch inserts 2 lines before `{
USB_DEVICE(0x2357, 0x0604)...` in the 8761BUV section — exact match with
current tree layout. No conflicting changes.

### Step 6.3: Related fixes already present?
**Record:** 0x2c4e:0x0128 (Mercusys MA60XNB) present; 0x2c4e:0x0115
(MA530) **not** present. No duplicate fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `drivers/bluetooth/btusb.c`, common USB
Bluetooth driver used by many desktop/laptop users and USB dongles.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — recent btusb commits in this tree
include Realtek ID additions, UAF fixes, and Mercusys 2c4e:0128 (May
2026).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Driver-specific** — owners of Mercusys MA530 USB Bluetooth
adapter (2c4e:0115). Not universal, but completely blocks Bluetooth for
those users.

### Step 8.2: Trigger conditions
**Record:** Plug in Mercusys MA530 USB dongle. Common, deterministic
trigger for device owners. Unprivileged user can trigger by inserting
USB device.

### Step 8.3: Failure mode severity
**Record:** Bluetooth completely non-functional — no HCI controller
created. **Severity: MEDIUM** (hardware unusable, not a kernel
crash/security issue).

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Enables Mercusys MA530 on 6.18.y; matches established
  stable practice for Realtek USB ID additions
- **Risk:** Very low — 2-line table entry, no code path changes
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backporting:**
- Explicit stable exception: new USB device ID to existing driver
- All prerequisites present in 6.18.y (btusb, Realtek path, rtl8761bu
  firmware, WIDEBAND_SPEECH)
- Real user impact — device completely non-functional without ID
- Trivial 2-line change, obviously correct pattern
- Maintainer Signed-off-by (Luiz von Dentz)
- Precedent: sibling Mercusys 2c4e:0128 backported to stable 6.6.x
- Clean apply to current tree

**AGAINST backporting:**
- Not a crash/security/data-corruption fix (hardware enablement only)
- Affects narrow user population (MA530 owners only)
- No explicit Cc: stable tag (not a negative signal per instructions)

**UNRESOLVED:**
- b4 dig could not run (commit not in local tree)
- Full lore thread inaccessible (bot protection)

Neither unresolved item affects the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard ID pattern; author
   verified firmware loads; maintainer merged
2. Fixes a real bug affecting users? **PASS** — device non-functional
   without entry (hardware enablement)
3. Important issue? **PASS** (moderate) — complete loss of Bluetooth
   functionality for affected hardware
4. Small and contained? **PASS** — 2 lines, one file
5. No new features or APIs? **PASS** — device ID only
6. Can apply to local tree? **PASS** — clean apply to existing 8761BUV
   section

### Step 9.3: Exception category
**Record:** **NEW DEVICE IDs** — adding USB ID 0x2c4e:0x0115 to existing
btusb Realtek driver. Explicitly allowed for stable.

### Step 9.4: Decision rationale

For kernel **6.18.y**, this commit should be backported. The Mercusys
MA530 is a commercially available USB Bluetooth dongle that is
completely non-functional on 6.18.y without this two-line ID entry. The
btusb Realtek driver, RTL8761BUV support, and rtl8761bu firmware
infrastructure all exist in this tree; only the device ID is missing.
This matches the well-established stable pattern for Realtek USB
Bluetooth ID additions, and follows the same approach already taken for
the sibling Mercusys MA60XNB (2c4e:0128) in this very tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Fixes/Reported-by/Cc:
  stable tags; maintainer SOB present
- **[Phase 2]** Diff: +2 lines in `quirks_table[]`; no function changes;
  hardware ID category
- **[Phase 3]** `git describe HEAD`: v6.18.44; `git blame -L 788,804`:
  8761BUV section present since 2021–2025
- **[Phase 3]** `git log --grep="Mercusys"`: found 79f9e221dddec
  (2c4e:0128, Cc: stable 6.6.x)
- **[Phase 3]** `grep 0x0115 drivers/bluetooth/btusb.c`: no matches — ID
  absent
- **[Phase 3]** `grep 0x2c4e drivers/bluetooth/btusb.c`: only 0x0128
  present, not 0x0115
- **[Phase 4]** Web search: upstream commit 0105c3e2a97e; patchwork-bot
  confirms maintainer merge
- **[Phase 4]** b4 dig -c 0105c3e2a97e: FAILED (commit not in local
  tree)
- **[Phase 4]** lore.kernel.org fetch: FAILED (bot protection 503)
- **[Phase 4]** Manjaro forum + prior patch submissions: confirm non-
  functional behavior without ID
- **[Phase 5]** Read `btusb_probe()` lines 4018–4024: quirks_table
  lookup when driver_info=0
- **[Phase 5]** Read Realtek setup at lines 4279–4290 and
  WIDEBAND_SPEECH at 4314–4315
- **[Phase 5]** `btrtl.c` lines 225–231: rtl8761bu firmware support
  confirmed
- **[Phase 6]** Tree is 6.18.44; patch applies before 0x2357:0x0604 at
  line 789 — layout matches diff
- **[Phase 6]** No existing fix for 0x2c4e:0x0115 in tree
- **[Phase 8]** Failure mode: no HCI device, Bluetooth unusable;
  severity MEDIUM; risk very low

**YES**The background searches finished and match what we already
concluded:

- **MA530 commit search:** No `MA530` / `Mercusys MA530` commit in this
  tree. `git log --grep="0x0115"` only turned up unrelated `0x0115` IDs
  in other drivers — the Mercusys `2c4e:0115` entry is still missing
  from `btusb.c`.
- **Author search:** Hrvoje Nuic has no other commits in this 6.18.y
  checkout.

That supports the earlier **YES** for stable backport: it’s a small
device-ID addition, all Realtek/8761BUV support is already here, and
only the MA530 ID is absent.

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 6d4c5d75cfc61..66df9192df20a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -791,6 +791,8 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
 	/* Additional Realtek 8761BUV Bluetooth devices */
+	{ USB_DEVICE(0x2c4e, 0x0115), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2357, 0x0604), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
-- 
2.53.0

