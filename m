Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF75F51355A;
	Mon, 31 Aug 2026 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183792; cv=none; b=C+42ebYPZWymh/hQ0g020UjYVZeHkBQVwye8Fv1yJv1+A5qEpoLnap3gFVnRThfxh1nsznLe1vZmZsA12U3dg97N0IX955c2O0WJ2uXmIX6IoFcHA0L7SzpCaRRHCIFdlTt+FVh4c4b9R3EOeoKYfm5tZjLZfYrLSBacdKkq8P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183792; c=relaxed/simple;
	bh=oFgL3RP1wxKXiJlASNNSke7KZ6fX5kaK2e6l/jZfKFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ihpKQ7tdx87plMbhOTuHkQfgbA8aIJ3epCvjQmtt4r7D91AkHwKdRmPMJK5o2Xy7UczMBl5rp43Ii9gGHndq+0e9/hQ0mGUojUBjAk0MKXaaaaOuswKqd5JejMm526AOgMa48m2qQtGEPYw+h9mhsmdi1G5CDnKLPIDgzvJd8YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6jHC2Up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6jHC2Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534A91F00A3F;
	Mon, 31 Aug 2026 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183789;
	bh=uoiUdB65pL39pRygv8E6gcLlcbqoHjqbhN8SRMJbg6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6jHC2UpVC49+xxeTISAjHy+FR8tZjbAGcWTH5JB63d9oTgsnCtzSLypuvQ+QeelH
	 sQWWX/xQzYg3IkiSIibMHN+csJRPndw6MMtr/aqhbjhuh/SgNulgCNvR48iqxcBZmQ
	 GDh37qCCtShftGM8BsurKjPX9II3BPQ42q0jWbLt4BCmnUNneT2DnSCD27qFXWqAnJ
	 EjrAmykexD1GPMWbtdn4U6izeol6QgYzk9UW7APBQIz9qC/dg19yb+7eufB4G3b7hq
	 kHdJT3u5kRHM9rPnduPGPBG14YYLyS6zZzqFQl70pInpUmqO8nkwpYk0tgHi5wnpza
	 JrSn1QrEEAhyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: mt76: mt7925: add Netgear A8500 USB device ID
Date: Mon, 31 Aug 2026 09:25:33 -0400
Message-ID: <20260831133314.4125787-305-sashal@kernel.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 291b067a02b9c1fd272057ebf47c365260955fd2 ]

Add USB device ID for the Netgear A8500 (0846:9050) which uses
the mt7925 chipset.

Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260527144735.10254-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: mt76: mt7925: add Netgear A8500 USB
device ID`

**Local tree:** `v6.18.44` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[wifi: mt76: mt7925]` `[add]` — Add USB device ID for
Netgear A8500 (0846:9050) to the existing mt7925u driver.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Devin Wittmayer `<lucid_duck@justthetip.ca>`
  (author)
- **Link:** https://patch.msgid.link/20260527144735.10254-1-
  lucid_duck@justthetip.ca
- **Signed-off-by:** Felix Fietkau `<nbd@nbd.name>` (mt76 maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable pattern: maintainer (Felix Fietkau) Signed-off-by is a strong
  quality signal; absence of `Cc: stable` is expected per review
  pipeline rules.

### Step 1.3: Analyze commit body
**Record:**
- **Bug description:** Netgear A8500 USB WiFi adapter (VID:PID
  0846:9050) uses the mt7925 chipset but is not recognized by the kernel
  because its USB ID is missing from `mt7925u_device_table[]`.
- **Symptom:** Device enumerates as USB hardware but does not bind to
  `mt7925u` driver; WiFi is non-functional.
- **Root cause:** Missing entry in the USB device ID table.
- **Version info:** None stated in commit message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not a hidden bug fix in the traditional sense (no
crash/UAF/leak). This is an explicit **hardware enablement** fix — a
device ID addition that allows an existing, fully functional driver to
bind to real hardware. Falls under the stable exception category for new
device IDs.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files changed:** `drivers/net/wireless/mediatek/mt76/mt7925/usb.c`
  (+3 lines)
- **Functions modified:** None functionally; only
  `mt7925u_device_table[]` static data
- **Scope:** Single-file, surgical, 3-line addition

### Step 2.2: Code flow change
**Record:**
- **Before:** USB core matches 0846:9050 against
  `mt7925u_device_table[]` → no match → driver does not probe.
- **After:** USB core matches 0846:9050 → `mt7925u_probe()` is called
  with `driver_info = MT7925_FIRMWARE_WM` → normal mt7925u
  initialization path.
- **Path affected:** USB device enumeration / driver binding at plug-in
  time.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workaround / device ID addition (stable
  exception)
- **Mechanism:** Without the VID/PID entry, `usb_driver.id_table`
  matching fails and the adapter is unusable despite the mt7925 driver
  being present and functional for other devices.

### Step 2.4: Fix quality assessment
**Record:**
- **Obviously correct:** Yes — identical pattern to the existing A9000
  entry (0846:9072) already in this tree.
- **Minimal/surgical:** Yes — 3 lines, no logic changes.
- **Regression risk:** Very low — only adds a new match entry; does not
  alter behavior for existing devices.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:**
- `mt7925u_device_table[]` introduced in `c948b5da6bbec` (Sep 2023, "add
  Mediatek Wi-Fi7 driver for mt7925 chips")
- A9000 entry added in `f6159b2051e15` (Jul 2025, Nick Morrow) — already
  present in this tree
- A8500 entry (0846:9050) is **not yet** in this tree

### Step 3.2: Follow Fixes: tag
**Record:** No `Fixes:` tag present. N/A.

### Step 3.3: Related file history
**Record:**
- Recent commits to `mt7925/usb.c` include functional fixes (crash, NULL
  deref, deadlock) and the A9000 ID addition `f6159b2051e15`
- Similar precedent: `fc6627ca8a5f8` added Netgear A7500 (0846:9065) to
  `mt7921/usb.c` with `Cc: stable@vger.kernel.org`
- **Standalone:** Yes — single patch, no series dependency

### Step 3.4: Author's other commits
**Record:** Devin Wittmayer has no other commits in this tree (author is
new contributor). Felix Fietkau is the mt76 maintainer who applied the
patch.

### Step 3.5: Prerequisites
**Record:**
- Requires `CONFIG_MT7925U` and existing mt7925u driver — both present
  in v6.18.44
- Uses `MT7925_FIRMWARE_WM` — already declared via `MODULE_FIRMWARE` in
  same file
- **Can apply standalone:** Yes

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c` could not be run (commit not in local tree). `b4
dig` with message-id failed (incorrect syntax for message-id lookup).
WebFetch of patch.msgid.link and lore.kernel.org returned bot-protection
page. **UNVERIFIED:** Full mailing list review thread not accessible.

### Step 4.2: Reviewers from b4 dig -w
**Record:** UNVERIFIED — could not retrieve recipient list.

### Step 4.3: Bug report search
**Record:** No `Reported-by:` or bugzilla/syzbot links in commit
message. Hardware enablement request from contributor.

### Step 4.4: Related patches/series
**Record:** Part of a well-established pattern of Netgear USB ID
additions to mt76 drivers (mt7921 A7500, mt7925 A9000). Standalone one-
patch submission.

### Step 4.5: Stable mailing list history
**Record:** UNVERIFIED — lore.kernel.org inaccessible. However, the
nearly identical A9000 commit (`f6159b2051e15`) in this tree included
`Cc: stable@vger.kernel.org`, establishing subsystem precedent for such
patches.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** No functions modified. Data table `mt7925u_device_table[]`
consumed by `module_usb_driver(mt7925u_driver)` via `.id_table`.

### Step 5.2: Trace callers
**Record:** USB core calls `usb_match_device()` against
`mt7925u_device_table[]` during enumeration → on match, calls
`mt7925u_probe()` (line 132 of `usb.c`). Triggered when user plugs in
the USB adapter.

### Step 5.3: Trace callees
**Record:** On successful match, `mt7925u_probe()` initializes the
mt7925 chipset using existing driver infrastructure and
`MT7925_FIRMWARE_WM` firmware.

### Step 5.4: Call chain / reachability
**Record:** USB hotplug during normal desktop/laptop use. Any user with
this hardware who plugs in the adapter is affected. No privilege
required to trigger enumeration.

### Step 5.5: Similar patterns
**Record:** Identical pattern in same file for A9000 (0846:9072).
Similar Netgear IDs in `mt7921/usb.c` (0846:9060, 0846:9065). All use
same `USB_DEVICE_AND_INTERFACE_INFO` + `MT7925_FIRMWARE_WM` / equivalent
firmware constant.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** The mt7925u driver and device table exist in
v6.18.44, but the A8500 entry (0846:9050) is **missing**. Current table
has only MediaTek reference (0e8d:7925) and Netgear A9000 (0846:9072).
Driver has been present since `c948b5da6bbec` (confirmed ancestor of
HEAD).

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** File exists with identical
structure. Insertion point is between the MediaTek entry and the A9000
entry (as shown in the candidate diff). Only minor difference: local
file uses `ISC` license header vs `BSD-3-Clause-Clear` in candidate diff
— irrelevant to the 3-line ID addition.

### Step 6.3: Related fixes already present?
**Record:** A9000 ID (`f6159b2051e15`) is already in this tree. No
duplicate A8500 entry found. No alternate fix for A8500.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/mediatek/mt76/` — **IMPORTANT**
(wireless networking driver). Affects users of specific USB WiFi
hardware, not universal.

### Step 7.2: Subsystem activity
**Record:** mt7925 subsystem is actively maintained in this tree —
numerous bugfix commits in recent history (NULL deref, deadlock, crash
fixes), indicating mature driver with ongoing stable fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of the Netgear A8500 USB WiFi 7 adapter (0846:9050)
running kernel 6.18.y with `CONFIG_MT7925U` enabled.

### Step 8.2: Trigger conditions
**Record:** Plugging in the Netgear A8500 USB adapter. Common,
deterministic, no special conditions. Unprivileged user can trigger via
USB device insertion.

### Step 8.3: Failure mode severity
**Record:** Without fix: adapter is completely non-functional (no driver
binding). **Severity: MEDIUM** for affected hardware users (device
unusable, but not a crash/corruption). With fix: normal WiFi operation.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Enables WiFi on a commercially available Netgear USB
  adapter for stable kernel users
- **Risk:** Very low — 3-line ID table entry, zero logic change,
  identical to already-accepted A9000 entry
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compilation

**FOR backporting:**
- Classic device ID addition to existing driver (explicit stable
  exception)
- Driver fully exists in v6.18.44 (`CONFIG_MT7925U`, probe/remove,
  firmware)
- Identical pattern to A9000 entry already in this tree
- Subsystem precedent: similar Netgear ID patches nominated for stable
  (`Cc: stable` on A9000, A7500)
- Maintained by Felix Fietkau (Signed-off-by)
- 3 lines, zero regression risk to existing devices
- Enables real hardware for stable users

**AGAINST backporting:**
- Not a crash/security/corruption fix — hardware enablement only
- No Tested-by or Reported-by in commit message
- Mailing list discussion unverified

**UNRESOLVED:**
- Full lore review thread not accessible
- No explicit Tested-by confirmation

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — trivial ID entry,
   maintainer-applied; Tested-by absent but pattern is standard
2. Fixes a real bug affecting users? **PASS** — device non-functional
   without ID
3. Important issue? **PASS** — hardware enablement for real product
   (stable exception category)
4. Small and contained? **PASS** — 3 lines, 1 file
5. No new features or APIs? **PASS** — device ID only
6. Can apply to local tree? **PASS** — driver and file present, clean
   apply expected

### Step 9.3: Exception category
**Record:** **NEW DEVICE ID** — adding PCI/USB ID to existing driver.
Explicitly listed as a stable exception. The mt7925u driver exists; only
the ID is new.

### Step 9.4: Decision rationale

This commit adds USB VID/PID `0846:9050` for the Netgear A8500 to the
existing `mt7925u` driver in the v6.18.44 stable tree. The driver is
fully present; the A9000 sibling device (0846:9072) is already supported
in this tree via an identical 3-line patch that was nominated for
stable. Without this entry, the A8500 adapter cannot bind to any driver
and is completely unusable. The change is minimal, obviously correct,
introduces no new APIs, and matches established stable backport practice
for mt76 Netgear USB adapters.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 1] Confirmed: no Fixes/Reported-by/Tested-by/Cc:stable tags;
  Felix Fietkau Signed-off-by present
- [Phase 2] Diff analysis: 3 lines added to `mt7925u_device_table[]` in
  `usb.c`
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame` on usb.c lines 12-18: table from c948b5da6bbec
  (2023), A9000 from f6159b2051e15 (2025)
- [Phase 3] `git merge-base --is-ancestor c948b5da6bbec HEAD`: mt7925
  driver is in tree
- [Phase 3] `git show f6159b2051e15`: A9000 precedent with Cc:
  stable@vger.kernel.org
- [Phase 3] `git show fc6627ca8a5f8`: mt7921 A7500 precedent with Cc:
  stable
- [Phase 4] WebFetch patch.msgid.link: blocked by bot protection —
  UNVERIFIED
- [Phase 4] WebFetch lore.kernel.org: blocked — UNVERIFIED
- [Phase 4] b4 dig: commit not in tree, could not dig by hash —
  UNVERIFIED
- [Phase 5] Read `mt7925u_probe()` at line 132: standard USB probe path
- [Phase 5] `grep 0846` in mt76: A9000 (9072) present, A8500 (9050)
  absent
- [Phase 6] Read current `usb.c`: A8500 ID missing, driver fully
  functional
- [Phase 6] `Kconfig` confirms `CONFIG_MT7925U` exists
- [Phase 6] `MODULE_FIRMWARE(MT7925_FIRMWARE_WM)` present in usb.c
- [Phase 7] `git log --oneline -20 -- mt7925/`: active subsystem with
  many stable-worthy fixes
- [Phase 8] Failure mode: no driver binding → device unusable (not
  crash)

**YES**

 drivers/net/wireless/mediatek/mt76/mt7925/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index bf040f34e4b9f..995a7fcc419fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -12,6 +12,9 @@
 static const struct usb_device_id mt7925u_device_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7925, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
+	/* Netgear, Inc. A8500 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9050, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
 	/* Netgear, Inc. A9000 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9072, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
-- 
2.53.0

