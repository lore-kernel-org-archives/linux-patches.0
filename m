Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0EF57DF21;
	Mon, 19 Oct 2026 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418315; cv=none; b=i3BnyGdAytSTbbgEoR8TQ0fk7USPmVTerfeIpBLvW22LKeaAPBCgA4BeINAi0dHkeWnajqXhZ9EB7OsWszGxXnwE2MVVimMa4+v1hWt+4yA1vQ+XTKfHCVONZXe3VZNXgUkR36Oag8fb6yHDujrYG07hSVrdc55ecLTwgaEBf1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418315; c=relaxed/simple;
	bh=9QLd1uN4lvICOAEyZAuQE98IxEjKpgPfzCaCXlVCil8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NzpLNxLp5ZQZ8zWjxQ9eAXx7Rc8CC1926UjzfXUyMiAjTddAebQLgT88O7c7FF3+P4nv7J3cluxWAtChKwJ0UnaA7UO76TsNC2Op8FdiCFmhjkmQiEQoK1BaQrtzChCLYXmcg25vZ9bItRBCEYijgTV/ecar2YAo9yjgTcbtc4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyMewUeH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyMewUeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CD41F000C4;
	Mon, 19 Oct 2026 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418311;
	bh=E26p/SctKIE+fAVdFun4DeWsksla8dRXiJgCb7P+uNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyMewUeHZOOu26oVnfIMBBFTieugB7oGEtezQ3IUM/UeinthLyPIqZdPPPVW7kLaQ
	 QxMvHchqHfmPknG0DFccK+fla3ObJe1vDLJwctyR2IQihnhhI9x0MSWKMcIJiWO5Xk
	 HLRq50neQZtmxHfIi0hMOxF3YM8FptF6r/9Jz5ieBo4WxfqOsvVtpGc7brpcvvuAvg
	 WeJATM86Dt/KSA6qlgd5IW4fjhZoa1EtXbrvsYzZPrDIzsdGgs0y6a5KdNyKFfHeFy
	 XMfN6QPNp5n7kcdtfCd5J/4oeNUsXwQHLW+3XCuLLPzVkcDSeTnfI4uUw0ADJ8y9PE
	 xz9E9Fi/FqIdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vadim Klishko <vadim@cirque.corp-partner.google.com>,
	Vadim Klishko <vadim@cirque.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] HID: i2c-hid: Add a quirk for a Cirque I2C device.
Date: Mon, 19 Oct 2026 09:47:29 -0400
Message-ID: <20261019135441.1420968-158-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Klishko <vadim@cirque.corp-partner.google.com>

[ Upstream commit 1c942462c3969b287a86ab6dbb143324289d564e ]

Cirque touchpads with PID D0C1 generate an error when probed
by the I2C HID driver, resulting in no hidraw device created.
Adding I2C_HID_QUIRK_NO_IRQ_AFTER_RESET fixes the issue.

Signed-off-by: Vadim Klishko <vadim@cirque.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `HID: i2c-hid`
- Action verb: `Add` (a quirk)
- Claimed intent: add `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` for Cirque I2C
  touchpad PID D0C1

Record: `[HID/i2c-hid] [add] [hardware quirk so Cirque D0C1 touchpads
probe successfully]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Signed-off-by: Vadim Klishko <vadim@cirque.com>` (author; Cirque, the
  device vendor)
- `Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>` (HID
  maintainer; applied the patch)
- No `Fixes:` tag (expected)
- No `Cc: stable@vger.kernel.org` (expected)
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or
  `Link:` tags in the committed message
- v1/v2/v3 changelog (from mailing list, not the commit body): v2 added
  subsystem prefix and expanded the explanation; v3 was a Patchwork
  resend. No code changes across revisions.

Record: Author is the hardware vendor; HID maintainer SOB. No
syzbot/stable tags.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Cirque touchpads with product ID D0C1 error during I2C-HID probe, so no
hidraw node is created. Applying the existing
`I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` workaround fixes it.

Record:
- Bug: Cirque D0C1 fails I2C-HID probe
- Symptom: no hidraw device (touchpad unusable)
- Root cause (author): device needs the established “no IRQ after reset”
  quirk
- Version info: none in the message; submitted Jul 2026, applied to hid
  `for-7.3/upstream-fixes`

**Step 1.4: DETECT HIDDEN BUG FIXES**
Not disguised. It is an explicit hardware quirk, which the stable rules
treat as a real-world device fix.

Record: Not a hidden bug fix; it is a straightforward hardware quirk.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
- `drivers/hid/hid-ids.h`: +1 (`#define I2C_PRODUCT_ID_CIRQUE_D0C1
  0xD0C1`) next to existing `I2C_VENDOR_ID_CIRQUE` /
  `I2C_PRODUCT_ID_CIRQUE_1063`
- `drivers/hid/i2c-hid/i2c-hid-core.c`: +2 (quirk table entry)
- Functions modified: none. Data only: ID macro + `i2c_hid_quirks[]`
  entry
- Scope: single-file-class surgical (2 files, 3 lines). No new quirk
  flag; reuses `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` (`BIT(0)`), already
  used for Hantick 5288, ITE Voyo Winpad A15, and Raydium 3118 in this
  tree.

Record: `[+3 lines, 2 files] [no functions] [surgical hardware quirk]`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before: D0C1 (`vendor 0x0488`, `product 0xD0C1`) has quirks `0`.
`i2c_hid_parse()` → `i2c_hid_finish_hwreset()` waits up to 1000 ms for a
reset-ACK IRQ.
After: lookup returns `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET`.
`i2c_hid_finish_hwreset()` sleeps 100 ms and clears
`I2C_HID_RESET_PENDING` instead of waiting for the IRQ.
Path: device probe / HID parse (and resume only if `RESET_ON_RESUME` is
also set; this entry does not set that).

Record: `[probe reset-wait → 100 ms sleep, skip IRQ wait, for VID 0x0488
/ PID 0xD0C1 only]`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **(h) Hardware workaround** (device ID + quirk table).

Mechanism: some I2C-HID devices never send the reset-complete interrupt.
The same quirk is already documented for Hantick (`402946a8ef71eb`: bind
fails with `"failed to reset device"`), ITE (`fc6a31b007393`: `"can't
add hid device: -61"`), and Raydium (`0c8432236dea2`). Hans de Goede
later made a missing ACK a warning rather than `-ENODATA`
(`7bcf9ebb50f2a`, in this tree), but a device that emits a bogus IRQ
during the wait can still break the following report-descriptor read
(`i2c_hid_parse` logs `"reading report descriptor failed"` and
`hid_add_device` fails → no hidraw). The vendor says this quirk fixes
that on D0C1.

Record: `[hardware quirk] [skip reset-ACK IRQ wait for Cirque D0C1]`

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct: additive, ID-matched, uses a long-standing quirk.
Risk is confined to 0x0488:0xD0C1. No API, locking, or allocator
changes. Same 3-line shape as prior stable-worthy i2c-hid quirks.

Record: `[high quality, minimal] [regression risk very low, ID-scoped]`

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Cirque 1063 ID + `NO_SLEEP_ON_SUSPEND`: `26dd6a5667f500` (Kai-Heng
  Feng, 2024-01-23) — already in this tree
- `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` handling in
  `i2c_hid_finish_hwreset()`: present (lines 500–502)
- Quirk table terminator `{ 0, 0 }` from original table
  (`71af01a8c85ad8`, 2016)

The “buggy” behavior is the generic reset-ACK wait vs this panel’s
firmware, not a recent regression. D0C1 is a new product ID of an
existing vendor.

Record: `[generic reset-ACK wait vs D0C1 firmware] [quirk infra since
~2017; Cirque vendor ID since 2024 / v6.8]`

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Recent `i2c-hid-core.c` work in this tree is unrelated (report-
descriptor error text, Dell S4, buffer overflow). Not part of a numbered
series.

Record: `[standalone] [no prerequisites beyond existing quirk flag +
Cirque vendor define, both present]`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
`git log --author="Vadim Klishko"` / `"Klishko"` in this tree: no
commits. First-time contributor; affiliation is the touchpad vendor
(`vadim@cirque.com`, Google corp-partner address on the list). HID
maintainer Benjamin Tissoires applied it (`for-7.3/upstream-fixes`, SHA
`1c942462c396`).

Record: `[vendor patch, maintainer-applied] [no other related commits in
this tree]`

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Mainline context after the new entry mentions
QTEC/`I2C_HID_QUIRK_RE_POWER_ON` and BLTP; those IDs are **not** in
6.12. The added lines do not use them. Required pieces in this tree:
- `I2C_VENDOR_ID_CIRQUE` (yes)
- `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` and its `i2c_hid_finish_hwreset()`
  handling (yes)
- `i2c_hid_lookup_quirk()` (yes)

Record: `[standalone on 6.12] [QTEC/BLTP are context-only, not
dependencies]`

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c 1c942462c396` matched patch-id
`d0e1a0779d3e935e26ea6a8cb93b1b9f683a32a4`.

Revisions:
- v1: https://patch.msgid.link/20260703144726.14808-1-vadim@cirque.com
  (subject lacked `HID: i2c-hid:`)
- v2: https://patch.msgid.link/20260708003108.20288-1-vadim@cirque.com
  (subject + explanation; **no code change**)
- v3: https://patch.msgid.link/20260728041718.32954-1-vadim@cirque.com
  (Patchwork resend; **no code change**)
- Applied: Benjamin Tissoires, 2026-08-25, hid.git `for-7.3/upstream-
  fixes` (`1c942462c396`)

No NAKs in v1/v2/v3 archives (openwall/patchew). No reviewer-requested
code changes. No explicit `Cc: stable` on the list.

Record: `[lore/msgid as above] [v1→v3, code unchanged] [applied by HID
maintainer] [no NAKs]`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w` original recipients: `vadim@cirque.com`, `jikos@kernel.org`,
`linux-input@vger.kernel.org`, `linux-kernel@vger.kernel.org`. v3 also
CCd Benjamin Tissoires and Hans de Goede (i2c-hid quirk author). Apply
mail CCd `hansg@kernel.org`. No written `Reviewed-by`, but the
maintainer applied it.

Record: `[HID maintainers Kosina/Tissoires; de Goede CCd; applied by
Tissoires]`

**Step 4.3: SEARCH FOR THE BUG REPORT**
No bugzilla/syzbot link. Evidence is the vendor’s report: probe error,
no hidraw, quirk fixes it. Author is Cirque.

Record: `[vendor-reported probe failure] [severity: device does not
enumerate] [user count unverified beyond vendor]`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Standalone 1/1. Not a multi-patch series.

Record: `[standalone]`

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Web search of lore.kernel.org/stable for Cirque D0C1 i2c-hid did not
turn up discussion of this patch (results were unrelated historical
stable traffic).

Record: `[no stable-list discussion found]`

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
No function bodies changed. The new table entry is consumed by
`i2c_hid_lookup_quirk()`, which feeds `ihid->quirks`, consumed by
`i2c_hid_finish_hwreset()`.

Record: `[i2c_hid_quirks[] data; consumers: i2c_hid_lookup_quirk,
i2c_hid_finish_hwreset]`

**Step 5.2: TRACE CALLERS**
- `i2c_hid_lookup_quirk()`: only from `__i2c_hid_core_probe()` after
  reading the HID descriptor vendor/product — so the quirk is installed
  before `hid_add_device()` / parse.
- `i2c_hid_finish_hwreset()`: from `i2c_hid_parse()` (probe) and
  `i2c_hid_core_resume()` (only if `I2C_HID_QUIRK_RESET_ON_RESUME`; this
  ID does not set that).

Record: `[probe path via hid_add_device → i2c_hid_parse] [resume reset
path not used for this ID]`

**Step 5.3: TRACE CALLEES**
With the quirk, `i2c_hid_finish_hwreset()` calls `msleep(100)` and
`clear_bit(I2C_HID_RESET_PENDING)`. Then, unless
`NO_WAKEUP_AFTER_RESET`, `i2c_hid_set_power(PWR_ON)`.

Record: `[msleep + clear reset-pending; then existing PWR_ON]`

**Step 5.4: FOLLOW THE CALL CHAIN**
ACPI/OF I2C-HID probe → `__i2c_hid_core_probe` (descriptor + quirk
lookup) → `i2c_hid_core_register_hid` → `hid_add_device` →
`i2c_hid_parse` → hwreset → read report descriptor → hidraw/input.

Reachable on boot for machines with this touchpad; not a syscall fuzz
path, but a normal laptop input device.

Record: `[boot/probe of Cirque D0C1 I2C touchpad] [userspace-visible:
hidraw/input missing without quirk]`

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Same quirk already in this tree for Hantick, ITE Voyo, Raydium 3118.
This is the same pattern, new ID.

Record: `[three existing NO_IRQ_AFTER_RESET entries; this is a fourth
ID]`

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Local tree: `pending-6.12`, `make kernelversion` = **6.12.111**, `git
describe HEAD` = `p-6.12-3-gc504cf0baa3d8`.

- `I2C_PRODUCT_ID_CIRQUE_D0C1` is **absent** (`git grep` no matches)
- `git merge-base --is-ancestor 1c942462c396 HEAD` → not an ancestor
  (exit 1)
- Driver, quirk flag, lookup, and Cirque vendor ID **are** present
- Without the table entry, D0C1 takes the generic reset-ACK wait that
  the vendor says fails probe

Record: `[yes, buggy generic path exists; D0C1 quirk not yet applied]
[bug is device firmware vs long-standing reset wait]`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
`hid-ids.h` context around `CIRQUE_1063` matches; should apply cleanly.
`i2c-hid-core.c`: insertion after the 1063 entry matches; following
context in mainline is QTEC (not in 6.12; here it is the ELAN comment).
At most fuzz/trivial context adjust. No refactor of the quirk table.

Record: `[clean or trivial fuzz] [no rework of logic]`

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
No D0C1 ID. Cirque 1063 has a *different* quirk (`NO_SLEEP_ON_SUSPEND`).
`7bcf9ebb50f2a` only demotes missing ACK to a warning; vendor still
needed this ID-specific quirk.

Record: `[no existing D0C1 fix; 1063 quirk is unrelated]`

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
`drivers/hid/i2c-hid/` — laptop/Chromebook I2C HID touchpads. Not
mm/core, but a common input path.

Record: `[HID i2c-hid] [IMPORTANT / driver-specific]`

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Mature driver (2012+). Quirk table still gets ID additions; that is
normal, not a rewrite.

Record: `[mature; ID/quirk additions are the usual change]`

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Only I2C-HID devices with HID descriptor VID/PID `0488:D0C1`. Everyone
else unchanged.

Record: `[driver/hardware-specific: Cirque D0C1 touchpads]`

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Every probe of that touchpad (boot). Not a race. Unprivileged users
cannot trigger it beyond having the hardware.

Record: `[every boot on affected machines] [common for those users] [not
a syscall exploit path]`

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Probe fails → no hidraw/input → touchpad dead. Not a panic. Matches
ITE’s historic `"can't add hid device"` failure.

Record: `[device fails to enumerate] [severity: HIGH for affected
hardware, none otherwise]`

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Benefit: touchpad works on 6.12 LTS (ChromeOS/enterprise/Ubuntu-class
kernels still on 6.12).
Risk: 3 lines, existing quirk, ID-gated.

Record: `[benefit high for D0C1 users] [risk very low] [favorable]`

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Explicit hardware quirk; stable rules call these YES
- Real user-visible bug: probe error, no hidraw (vendor-confirmed)
- 3 lines, existing `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET`
- Same shape as Hantick/ITE/Raydium quirks already in this tree
- HID maintainer applied it; author is Cirque
- Driver, quirk flag, and Cirque vendor ID exist in 6.12.111
- No new API/feature flag

AGAINST:
- No `Fixes:` / `Cc: stable` (not a negative per instructions)
- No public repro logs beyond the commit text
- `7bcf9ebb50f2a` tried to reduce new `NO_IRQ_AFTER_RESET` quirks; this
  device still needed one
- Mainline hunk context (QTEC) differs; trivial apply fuzz only
- Affects one product ID, not all machines

UNRESOLVED:
- Exact errno/log line on D0C1 was not posted (only “error” / no hidraw)
- How many shipping systems use D0C1 is unverified
- lore.kernel.org WebFetch returned 403; discussion recovered via b4 dig
  + openwall/patchew

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 3-line ID quirk; vendor-
   tested; maintainer applied
2. Fixes a real bug that affects users? **PASS** — probe failure, no
   hidraw
3. Important issue? **PASS** — input device does not work (hardware bug,
   not a panic)
4. Small and contained? **PASS** — +3 lines, two files
5. No new features or APIs? **PASS** — existing quirk + new device ID
6. Can apply to the local tree? **PASS** — logic applies; at most
   context fuzz around QTEC vs ELAN

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Yes: **hardware quirk** and **device ID addition to an existing
driver**.

**Step 9.4: DECISION**
This is a textbook stable backport: a 3-line i2c-hid quirk so a Cirque
D0C1 touchpad enumerates. The 6.12 tree already has the driver and quirk
machinery; only the ID is missing. Benefit is restoring input on
affected machines; regression risk is limited to that PID.

---

## What this solves for 6.12 users

Cirque D0C1 I2C touchpads fail I2C-HID probe, so hidraw/input never
appear. The quirk skips waiting for a reset-ACK IRQ (100 ms sleep
instead), which is the established workaround. On 6.12 that path still
exists; without the ID, those panels stay dead.

## Risk vs benefit

Benefit is a working touchpad on affected laptops/Chromebooks still on
6.12. Risk is a 3-line, VID/PID-gated table addition using a quirk
already used by three other devices in this tree.

## Concerns

Apply may need trivial context adjustment because 6.12’s quirk table
does not yet have the later QTEC/BLTP entries. No functional
dependencies. Exact probe errno was not published; the vendor statement
plus matching historical quirks is enough.

---

Verification:
- [Phase 1] Parsed subject/tags/body: vendor SOB Vadim Klishko;
  maintainer SOB Benjamin Tissoires; no Fixes/stable/syzbot tags
- [Phase 2] Diff: +1 hid-ids.h define `I2C_PRODUCT_ID_CIRQUE_D0C1
  0xD0C1`; +2 `i2c_hid_quirks[]` with `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET`
- [Phase 2] Read `i2c_hid_finish_hwreset()`: quirk does `msleep(100)` vs
  1000 ms `wait_event_timeout`
- [Phase 2] Confirmed `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` is `BIT(0)` at
  line 47
- [Phase 3] `git describe HEAD` / `make kernelversion`: pending-6.12,
  6.12.111
- [Phase 3] `git merge-base --is-ancestor 1c942462c396 HEAD`: not in
  tree (exit 1)
- [Phase 3] `git grep I2C_PRODUCT_ID_CIRQUE_D0C1`: no matches
- [Phase 3] `git blame` hid-ids Cirque lines: `26dd6a5667f500` (2024, in
  tree)
- [Phase 3] `git blame` quirk table: Hantick/ITE/Raydium already have
  the same quirk
- [Phase 3] `git log --author=Klishko`: no commits in this tree
- [Phase 3] QTEC/BLTP/`I2C_HID_QUIRK_RE_POWER_ON`: absent; not required
  by this patch
- [Phase 3] Compared prior quirks: `0c8432236dea2` (Raydium),
  `fc6a31b007393` (ITE), `402946a8ef71eb` (Hantick) — same 2-file
  +3-line pattern
- [Phase 3] `7bcf9ebb50f2a` in tree: missing ACK is a warning, not
  `-ENODATA`; vendor still needed the quirk
- [Phase 4] `b4 dig -c 1c942462c396`: patch-id match; v1/v2/v3 msgids
  listed above
- [Phase 4] `b4 dig -a`: v2 listed as series; v3 applied with no code
  changes from v1
- [Phase 4] `b4 dig -w`: To/Cc Jiri Kosina, linux-input, linux-kernel
- [Phase 4] Openwall/patchew: Tissoires applied to hid.git
  `for-7.3/upstream-fixes`; no NAKs
- [Phase 4] lore.kernel.org WebFetch: 403; used b4 + openwall/patchew
  instead
- [Phase 4] Stable-list search: no discussion of this patch found
- [Phase 5] Callers: `i2c_hid_lookup_quirk` from `__i2c_hid_core_probe`;
  `i2c_hid_finish_hwreset` from `i2c_hid_parse` and resume-with-
  RESET_ON_RESUME
- [Phase 5] Parse path: reset then `i2c_hid_read_register` of report
  descriptor; failure → no hid_add_device/hidraw
- [Phase 6] Local files match needed APIs; D0C1 ID missing
- [Phase 8] Failure mode: probe/enumeration failure for one touchpad
  PID, not a panic
- UNVERIFIED: exact dmesg/errno on D0C1; number of shipping units; live
  lore.kernel.org HTML (403)

**YES**

 drivers/hid/hid-ids.h              | 1 +
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 5169713539bc3..11f120a5d1b90 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -333,6 +333,7 @@
 
 #define I2C_VENDOR_ID_CIRQUE           0x0488
 #define I2C_PRODUCT_ID_CIRQUE_1063     0x1063
+#define I2C_PRODUCT_ID_CIRQUE_D0C1     0xD0C1
 
 #define USB_VENDOR_ID_CJTOUCH		0x24b8
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0020	0x0020
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 6d407cbed1886..29c4f624f3c5c 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -136,6 +136,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ I2C_VENDOR_ID_CIRQUE, I2C_PRODUCT_ID_CIRQUE_1063,
 		I2C_HID_QUIRK_NO_SLEEP_ON_SUSPEND },
+	{ I2C_VENDOR_ID_CIRQUE, I2C_PRODUCT_ID_CIRQUE_D0C1,
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	/*
 	 * Without additional power on command, at least some QTEC devices send garbage
 	 */
-- 
2.53.0

