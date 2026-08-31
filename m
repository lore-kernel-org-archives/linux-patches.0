Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0B949CF34;
	Mon, 31 Aug 2026 13:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183602; cv=none; b=ZoJ6ktY1CUpQBKJnesq13t16gYT8I2EZJllB1QLhYXmocFJBxltz9SRVnbhxd6LWQNpRiI4O0W0TGQpLnD4Q0hkDjm/n4wxuh0uKKInXIMeto31FJT4oitky7ALxB9tPaQk7e9J1r5tZfEDOE1EuTisdGN9DQGG5VQFh3OT1qw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183602; c=relaxed/simple;
	bh=dK33KCp9ImIgVqbJA1QhaoiVlEcLdSU8DuapOzrZ3KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oynnzoNaNEqe5BNJ+MmIkKSsarqPfolYlg0c9sivThWbLoml7L28H6dKuqeuH4dB9VKrvpeHVKqJkaqlTqnft/LvclhFCWeWqbPkYdOfyHIkvXiFn9ZN808WT1srynpruaLmvNN4mFazzsIzep8GbuevQOFghpWzZbJPhpOsxjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HayIjnqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HayIjnqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53241F00A3D;
	Mon, 31 Aug 2026 13:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183599;
	bh=BQEyAkLQQ9u0yZwKj9QEn6aiwa3AjXqE03qSoylSx2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HayIjnqd7E5cC9QhjIiY9GPuP9pQLi9s6Z7vroVYCMEfQexMpUhgMm+yaFbmAQtTf
	 2kL60HQi1DNM/o17yjjOOhw1UtOdauW7As4f2yoPrKGhECBehn7lDhz4gucktyWrd0
	 zz8ZirCFDPWpFONeMOeHFG9Hng3Eus+ofn8sT20JB6cv9jDSph/8zxqUBXPJ1SmBvD
	 /D6HEam4E26j0N6lfx51p2yO5XPfu+qMuWlG3O3CGowUEakdg+2UZ4SD9yG8SERSdl
	 4mXUTyjTTB5Mh+zv8/rTbxXIOp7TcgmEw0fNtJNtND8iJ1T6lQEN37/jv8OcVh4AVZ
	 +Q9hn/z9+aaOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alessandro Baldi <baldovic@virgilio.it>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: imon: Add iMON VFD HID OEM v1.2 key mappings
Date: Mon, 31 Aug 2026 09:23:39 -0400
Message-ID: <20260831133314.4125787-191-sashal@kernel.org>
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

From: Alessandro Baldi <baldovic@virgilio.it>

[ Upstream commit d97d13c24d7893abcfb80d38630ce74daaa1434c ]

Add Vol+/Vol-/Mute panel button mappings for iMON VFD HID OEM v1.2.
This version differs in the codes that generate the
KEY_VOLUMEUP, KEY_VOLUMEDOWN and KEY_MUTE events.

Signed-off-by: Alessandro Baldi <baldovic@virgilio.it>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: media: imon: Add iMON VFD HID OEM v1.2 key
mappings

**Local tree:** Linux 6.18.43 (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[media: imon]` `[Add]` — Add key mappings for iMON VFD HID
OEM v1.2 panel buttons (Vol+/Vol-/Mute).

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org:** — not present (expected)
- **Signed-off-by:** Alessandro Baldi `<baldovic@virgilio.it>` (author)
- **Signed-off-by:** Sean Young `<sean@mess.org>` (media subsystem
  maintainer — strong quality signal)

No syzbot, no bugzilla links, no multiple reporters.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** iMON VFD HID OEM v1.2 firmware sends different hardware
  scancodes for Vol+, Vol-, and Mute than other variants already mapped
  in `imon_OEM_VFD`.
- **Symptom:** Panel volume/mute buttons on v1.2 hardware produce no
  useful input events (lookup returns `KEY_RESERVED`).
- **Root cause:** Missing entries in the `imon_OEM_VFD.key_table` for
  scancodes `0x0a`, `0x0b`, `0x0c` (with `0xffee` suffix applied at
  lookup time).
- **Version info:** Specific to "iMON VFD HID OEM v1.2" variant of USB
  device `0x15c2:0x0036`.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised as cleanup. This is an explicit hardware-
variant key-mapping fix. Functionally equivalent to a hardware quirk:
same USB ID, different firmware scanc## Phase 1: Commit Message
Forensics

### Step 1.1: Subject Line
**Record:** `[media: imon]` `[Add]` — Add iMON VFD HID OEM v1.2 key
mappings for Vol+/Vol-/Mute panel buttons.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org** — none
- **Signed-off-by:** Alessandro Baldi `<baldovic@virgilio.it>` (author)
- **Signed-off-by:** Sean Young `<sean@mess.org>` (media maintainer;
  pipeline Sasha Levin SOB ignored per instructions)

Notable: maintainer sign-off from Sean Young, but no fuzzer report, user
bug report, or explicit stable nomination.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** iMON VFD HID OEM v1.2 panel buttons send different hardware
  codes for `KEY_VOLUMEUP`, `KEY_VOLUMEDOWN`, and `KEY_MUTE` than other
  variants already mapped in `imon_OEM_VFD`.
- **Symptom:** Volume+/Volume-/Mute panel buttons produce no useful
  input events on v1.2 hardware.
- **Root cause:** Missing entries in the `imon_OEM_VFD.key_table` for
  the v1.2 scancodes (`0x0a`, `0x0b`, `0x0c` with `0xffee` suffix
  pattern).
- **Version info:** Targets a specific hardware/firmware variant (v1.2),
  not a kernel regression.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not a disguised crash/leak/race fix. This is explicit
hardware-variant keymap completion — functionally a hardware
quirk/workaround for a device revision that uses different scancodes.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/media/rc/imon.c` (+4 lines including comment, +3
  mapping entries)
- **Function/structure:** `imon_OEM_VFD.key_table` static data only
- **Scope:** Single-file, surgical data-table addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `imon_panel_key_lookup()` walks `imon_OEM_VFD.key_table`;
  v1.2 Vol+/Vol-/Mute scancodes (`0x000000000a00ffee`,
  `0x000000000b00ffee`, `0x000000000c00ffee`) match nothing → returns
  `KEY_RESERVED`.
- **After:** Those scancodes map to `KEY_VOLUMEUP`, `KEY_VOLUMEDOWN`,
  `KEY_MUTE`.
- **Path affected:** 8-byte panel button packets (`len == 8 && buf[7] ==
  0xee`) on USB device `0x15c2:0x0036` using `imon_OEM_VFD`.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Hardware quirk / incomplete keymap for
hardware variant. **Mechanism:** Same USB ID and driver, but v1.2
firmware emits different panel scancodes than existing table entries;
unmatched codes are dropped as `KEY_RESERVED`.

### Step 2.4: Fix Quality
**Record:** Obviously correct pattern — mirrors existing volume/mute
entries already in the same table. Minimal diff, no logic changes.
**Regression risk:** Very low; only adds new lookup entries without
altering existing mappings.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / Introduction
**Record:** In this shallow 6.18.43 checkout (~50 commits),
`imon_OEM_VFD` and its volume mappings are present at base commit
`a112b91dd6349`. Full upstream introduction history is not available in
this checkout. The **missing v1.2 mappings are confirmed absent** in the
current tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** `git log --oneline -20 -- drivers/media/rc/imon.c` shows
only one commit in this shallow tree (`a112b91dd6349`), which is not
informative for upstream history. No evidence this is part of a multi-
patch series from local history.

### Step 3.4: Author Context
**Record:** No commits from Alessandro Baldi found in this checkout.
Sean Young (Signed-off-by) is the media/RC maintainer — strong subsystem
credibility signal.

### Step 3.5: Dependencies
**Record:** **Standalone.** No prerequisites; only adds rows to an
existing table in existing driver code. No new structures or APIs
required.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig` requires `-c COMMITISH`; no commit hash was
provided and subject-only search is unsupported. **Could not retrieve
lore thread.**

### Step 4.2: Reviewers
**Record:** `b4 dig -w` not possible without commit hash. Sean Young SOB
in commit message indicates maintainer involvement.

### Step 4.3: Bug Report
**Record:** No `Reported-by:` or `Link:` tags. No external bug report
verified.

### Step 4.4: Related Patches / Series
**Record:** Appears standalone; no series indicators in subject or diff.

### Step 4.5: Stable List History
**Record:** Not searched (lore blocked by bot protection on fetch).
Precedent exists for imon stable backports (e.g., 3.17-stable picked up
imon RC protocol fix for broken remote functionality on `15c2:0034`).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** Modified data: `imon_OEM_VFD`. Affected runtime functions:
`imon_panel_key_lookup()`, called from `imon_incoming_packet()`; table
also used by `imon_init_idev()` to register supported keys.

### Step 5.2: Callers
**Record:** `imon_panel_key_lookup()` called from
`imon_incoming_packet()` when processing 8-byte panel packets (`buf[7]
== 0xee`). Triggered by physical panel button presses on supported iMON
USB devices during normal driver operation.

### Step 5.3: Callees
**Record:** Simple linear table scan; returns `KEY_RESERVED` on miss. No
allocation, locking, or I/O in lookup itself.

### Step 5.4: Reachability
**Record:** **Userspace-reachable** via panel button input on
`USB_DEVICE(0x15c2, 0x0036)` bound to `imon_OEM_VFD`. Common HTPC/media-
center use case for this hardware.

### Step 5.5: Similar Patterns
**Record:** Same table already contains multiple variant-specific
volume/mute mappings (standard OEM, MCE VFD `0xffdc`, knob values). v1.2
entries follow established pattern.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Tree is `6.18.43` (`git describe`:
`v6.18.43-1-gc7f0dac02d232`). `imon_OEM_VFD` exists at lines 267–310
with volume mappings for other variants but **without** v1.2 entries
(`0x0a/0x0b/0x0c`). USB ID `0x15c2:0x0036` → `imon_OEM_VFD` at line
392–393.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Insertion point is clearly between
existing OEM volume entries and MCE VFD section — matches current file
layout exactly.

### Step 6.3: Related Fixes Already Present?
**Record:** `grep` for `0x000000000a00ffee` and `OEM v1.2` — **not
found**. Fix is not already in this tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / Criticality
**Record:** `drivers/media/rc/imon.c` — media RC/input driver.
**Criticality: PERIPHERAL** (niche HTPC front-panel hardware).

### Step 7.2: Subsystem Activity
**Record:** Mature, low-churn driver in this tree. imon support has been
stable for many years; this is variant-specific table maintenance.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of SoundGraph iMON OEM VFD (`15c2:0036`) with HID OEM
**v1.2** firmware — specifically panel Vol+/Vol-/Mute buttons. Config:
`CONFIG_RC_CORE` / imon USB driver.

### Step 8.2: Trigger Conditions
**Record:** Pressing panel volume/mute buttons on v1.2 hardware.
**Common** for affected users every time they use those buttons.
Unprivileged physical access; not a security vector.

### Step 8.3: Failure Mode Severity
**Record:** Unmapped keys → `KEY_RESERVED` → buttons do nothing.
**Severity: LOW** — functional impairment only; no oops, hang,
corruption, or security impact.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores basic panel functionality for v1.2 owners;
  aligns with stable rules' explicit acceptance of **hardware quirk**
  fixes.
- **Risk:** Minimal — 3 table entries, no behavior change for existing
  mappings.
- **Ratio:** Moderate benefit for a small user population, very low
  risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes a real, user-visible hardware issue (non-working volume/mute
  buttons)
- Tiny, obviously correct, maintainer-signed
- Fits stable rules' **hardware quirk** category
  (`Documentation/process/stable-kernel-rules.rst`)
- Same pattern as existing variant-specific entries in the same table
- Applies cleanly to 6.18.43; driver and device ID already present
- Zero regression risk for users without v1.2 hardware

**AGAINST backport:**
- Not crash/security/corruption/deadlock
- Niche hardware with small user base
- No user/fuzzer bug report in commit message
- Completes support for a variant rather than fixing a kernel regression
- Mailing list review not verified (no commit hash for `b4 dig`)

**Unresolved:** Original lore discussion and whether a user/distro filed
a bug report.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard keymap pattern;
   maintainer SOB
2. Fixes real bug affecting users? **PASS** — broken panel buttons on
   v1.2 hardware
3. Important issue? **PASS (borderline)** — hardware quirk per stable-
   kernel-rules.rst; not crash-level but explicitly listed acceptable
   category
4. Small and contained? **PASS** — 3 entries, one file
5. No new features/APIs? **PASS** — data-only quirk entries
6. Can apply to local tree? **PASS** — code present, clean insertion
   point

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** — v1.2 firmware revision uses
different panel scancodes for the same USB device already supported by
`imon_OEM_VFD`.

### Step 9.4: Decision Rationale

For **Linux 6.18.43**, the driver, device ID, and `imon_OEM_VFD` table
all exist; v1.2 volume/mute scancodes are missing, so affected users'
buttons are silently ignored. The fix is a minimal hardware-variant
keymap addition — the same class of change stable trees routinely accept
as hardware quirks. Severity is low (no stability/security impact), but
benefit is clear for affected HTPC users and risk is negligible.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed no Reported-by/Fixes/Link/Cc: stable tags
- **[Phase 2]** Diff: +3 keymap entries + comment in
  `imon_OEM_VFD.key_table`
- **[Phase 2]** Read `imon_panel_key_lookup()` at lines 1300–1316
- **[Phase 2]** Read `imon_incoming_packet()` panel path at lines
  1599–1602
- **[Phase 3]** `git describe HEAD` → `v6.18.43-1-gc7f0dac02d232`;
  Makefile → 6.18.43
- **[Phase 3]** `git blame -L 267,310 drivers/media/rc/imon.c` — table
  present (shallow history limits introduction date)
- **[Phase 3]** `git log --grep` / `-S` searches — no candidate commit
  in this tree
- **[Phase 4]** `b4 dig` — failed (no commit hash provided; `-q` not
  supported)
- **[Phase 4]** lore.kernel.org fetch — blocked by bot protection
- **[Phase 4]** Web search — found prior imon stable backport precedent
  (3.17-stable RC protocol fix)
- **[Phase 5]** `grep imon_OEM_VFD` — device `0x15c2:0x0036` uses this
  table
- **[Phase 5]** Traced call chain: panel button →
  `imon_incoming_packet()` → `imon_panel_key_lookup()`
- **[Phase 6]** Read `imon_OEM_VFD` at lines 267–310 — v1.2 mappings
  absent
- **[Phase 6]** `grep 0x000000000a00ffee` — not in tree
- **[Phase 7]** Read `Documentation/process/stable-kernel-rules.rst` —
  hardware quirk explicitly acceptable
- **[Phase 8]** Confirmed failure mode is `KEY_RESERVED` (no crash) via
  lookup code
- **UNVERIFIED:** Original mailing list review thread; whether bug was
  reported by users; exact kernel version that first introduced
  `imon_OEM_VFD` (shallow clone)

**YES**

 drivers/media/rc/imon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 48534bb52e4d0..4f974b88628f0 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -290,6 +290,10 @@ static const struct imon_usb_dev_descr imon_OEM_VFD = {
 		{ 0x000100000000ffeell, KEY_VOLUMEUP },
 		{ 0x010000000000ffeell, KEY_VOLUMEDOWN },
 		{ 0x000000000100ffeell, KEY_MUTE },
+		/* iMON VFD HID OEM v1.2 */
+		{ 0x000000000a00ffeell, KEY_VOLUMEUP },
+		{ 0x000000000b00ffeell, KEY_VOLUMEDOWN },
+		{ 0x000000000c00ffeell, KEY_MUTE },
 		/* 0xffdc iMON MCE VFD */
 		{ 0x00010000ffffffeell, KEY_VOLUMEUP },
 		{ 0x01000000ffffffeell, KEY_VOLUMEDOWN },
-- 
2.53.0

