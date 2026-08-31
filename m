Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0472D4FECFA;
	Mon, 31 Aug 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183707; cv=none; b=plQ5J3Jlx5y12atkJ7/OBCg8e9+Defr3OmOyQnhIG+A5HMl6Wwohu6hxGDQ87vpe0mizndXnO1sVp0ciuEq/CdFOIkZ+XfcBVNwUvET9RlRSN1G86zWMVGbwjsPnD+L08hCEBiMP1I1+SX9luCgtCblQ57NSwzfmLyp2VBj0Hdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183707; c=relaxed/simple;
	bh=+BtR3ve7wqfi+7y9eTvnH9X2fjN9liKpDW/AVR08+2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pkZsswDJj/YLYnafmQf8C7w5oSOj/Y3sfbE52EOs182ILin9waUD2iKp0WjNBrY8yXVWIU8sRqNNci/LbXo7bIZT4gIn3tC3I1hpCUoDNFQarPmmOWF5Qz50VJ7pN824Ndb0j4uZiDdgyvHaM+doL1Bu06fV4TmsBNiVvjp9tds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g06SV+dm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g06SV+dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3591F00ACF;
	Mon, 31 Aug 2026 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183704;
	bh=Y5wjJNEqT86eGKEDF72nMfMtty6YQPix7M3lX58IKuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g06SV+dmqjhy/MCKa+nOJLP+sVraVOQ/m24xYb5/Xj4GiVoB0mtK/lTbspnito2K/
	 KqBdYontnN2t4CFoyA0kWUinuUhbNEWTx1wcTKXsJSfjMeuOdkaxeNEET/p4BI49ZO
	 H1IuZrRBXhPd2b0aljRxNoYz9Zx9oTASX3SVJP2BYwjqM6gX9rl9D3Qs4TnucNevrq
	 bCBIx1IOPUltdrxWpB7TjV8AdIjsefBBrs5p79qqW/dv2cYylQyMrvEUY0qQ4D8dQX
	 JWhQQb1ikc0urdeOxHNaxfSldXyZskbyajt3iJQIHzCprTH2o7aseTBVKaFy9if/jJ
	 SQYYUtEdVIbCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Pearson <mpearson-lenovo@squebb.ca>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	wim@linux-watchdog.org,
	linux-watchdog@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] watchdog: lenovo_se10_wdt: Add support for SE10 Gen 2 platform
Date: Mon, 31 Aug 2026 09:24:43 -0400
Message-ID: <20260831133314.4125787-255-sashal@kernel.org>
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

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 7b25feb19ce8073193fff6a05a43b5a5c2854b4b ]

The Lenovo SE10 Gen 2 platform uses a watchdog chip from the same family.
Watchdog functionality is the same, so update the driver with the new chip
ID.

Add the Gen 2 MTM's to enable support on the platform.

Tested on SE10 G2.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20260428124954.1193450-1-mpearson-lenovo@squebb.ca
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `watchdog: lenovo_se10_wdt: Add support for
SE10 Gen 2 platform`

**Local tree:** `v6.18.43` (`6.18.43`) — detached HEAD at
`gc7f0dac02d232`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[watchdog: lenovo_se10_wdt]` `[Add]` `[support for SE10 Gen
2 platform]` — hardware enablement for a new platform variant of an
existing watchdog driver.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Mark Pearson `<mpearson-lenovo@squebb.ca>` (author) |
| Signed-off-by | Guenter Roeck `<linux@roeck-us.net>` (watchdog
maintainer) |
| Link | `https://lore.kernel.org/r/20260428124954.1193450-1-mpearson-
lenovo@squebb.ca` |
| Fixes: | **None** (expected for candidate review) |
| Reported-by: | **None** |
| Tested-by: | **None** (body says "Tested on SE10 G2") |
| Cc: stable | **None** (expected) |

Notable: Maintainer (Guenter Roeck) signed off. No syzbot, no crash
reports.

### Step 1.3: Body Analysis
**Record:**
- **Bug/feature described:** Lenovo SE10 Gen 2 uses a watchdog chip from
  the same family with chip ID `0x5652` (vs Gen 1 `0x5632`). Gen 2 MTM
  product names are not in the DMI table.
- **Symptom:** Watchdog driver does not bind on Gen 2 hardware — either
  `dmi_check_system()` never matches, or `se10_wdt_probe()` rejects the
  chip ID and returns `-ENODEV`.
- **Root cause (author):** New hardware variant not recognized by
  existing driver tables.
- **Version info:** None stated.

### Step 1.4: Hidden Bug Fix?
**Record:** **No.** This is explicit hardware enablement ("Add
support"), not a disguised crash/leak/race fix. Without it, watchdog
simply does not work on Gen 2 — that is absent functionality, not a
kernel defect on Gen 1 systems.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Changes |
|------|---------|
| `drivers/watchdog/lenovo_se10_wdt.c` | +65 / -1 lines |

**Functions modified:** `se10_wdt_probe()`, `se10_dmi_table[]` (data)

**Scope:** Single-file, surgical hardware-ID extension.

### Step 2.2: Code Flow Changes
**Record:**
- **Hunk 1 (`se10_wdt_probe`, line 181):** Before: only chip ID `0x5632`
  accepted. After: also accepts `0x5652`. Path: platform probe on
  matching DMI systems.
- **Hunk 2 (`se10_dmi_table`):** Before: 5 Gen 1 product names
  (`12NH`–`12NM`). After: adds 8 Gen 2 entries (`13LJ`, `13LK`,
  `13S1`–`13S6`). Path: module init via `dmi_check_system()`.

### Step 2.3: Bug Mechanism
**Record:** **Hardware identification / device ID extension (category
h).** Not a memory-safety, locking, or logic bug. Gen 2 hardware is
rejected because its chip ID and DMI product names are unknown to the
driver.

### Step 2.4: Fix Quality
**Record:** Obviously correct — same chip family, same ops, author
tested on hardware, watchdog maintainer reviewed. Minimal change (one
condition extended, DMI entries appended). **Regression risk: very low**
— only affects systems matching new DMI entries; Gen 1 behavior
unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Chip ID check introduced in `5d324e5159d9e` (Linus Torvalds,
2025-11-28) — initial import of `lenovo_se10_wdt.c` into this tree at
v6.18. Driver has been present since v6.18 release (308 lines at `v6.18`
tag, confirmed).

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related File History
**Record:** Only one commit touches this file in current branch history
(`5d324e5159d9e`). Upstream Gen 2 commit: `dd785736030e9` / upstream
`7b25feb19ce8` (2026-04-28). Related but separate: `ab48c217d9855` ("Fix
use-after-free and resource leak risk") — **not** in this tree;
independent bug fix, not a prerequisite for Gen 2 IDs.

### Step 3.4: Author Context
**Record:** Mark Pearson is listed as MODULE_AUTHOR. No other watchdog
commits from this author in current HEAD history. Guenter Roeck
(watchdog maintainer) committed upstream version.

### Step 3.5: Dependencies
**Record:** **Standalone.** No series markers, no prerequisite commits.
Applies cleanly to current `lenovo_se10_wdt.c` (verified: commit exists
in repo, diff is self-contained).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c dd785736030e9` found v1 only:
- URL: https://patch.msgid.link/20260428124954.1193450-1-mpearson-
  lenovo@squebb.ca
- Single-patch series, no v2/v3 revisions.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` recipients: Mark Pearson, `wim@linux-
watchdog.org`, `linux@roeck-us.net`, `linux-watchdog@vger.kernel.org`,
`linux-kernel@vger.kernel.org`. Watchdog maintainer (Roeck) and list
were CC'd.

### Step 4.3: Bug Report
**Record:** No bug report link. Author tested on SE10 G2 hardware. Lore
fetch blocked by Anubis bot protection — could not read thread replies
for stable nominations or NAKs.

### Step 4.4: Series Context
**Record:** Standalone single patch. No multi-patch dependencies.

### Step 4.5: Stable List History
**Record:** Not searched (lore blocked). No stable nomination visible in
commit message.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `se10_wdt_probe()`, `se10_dmi_table[]`, indirectly
`se10_wdt_init()`, `se10_create_platform_device()`.

### Step 5.2: Callers
**Record:**
- `se10_wdt_init()` → `module_init()` → runs at module load (built-in or
  `modprobe`)
- `dmi_check_system(se10_dmi_table)` → calls
  `se10_create_platform_device()` on DMI match
- `platform_driver_register()` → `se10_wdt_probe()` on platform device
  add

**Context:** Boot-time init on x86 systems with matching Lenovo DMI.
Only CONFIG_LENOVO_SE10_WDT=y/m.

### Step 5.3: Callees
**Record:** Standard watchdog registration
(`devm_watchdog_register_device`), LPC I/O (`outb`/`inb`), DMI matching.
No new subsystem dependencies.

### Step 5.4: Reachability
**Record:** Triggered automatically on boot for Lenovo SE10 Gen 2
systems with driver enabled. Not userspace-syscall reachable; hardware-
specific platform init path.

### Step 5.5: Similar Patterns
**Record:** Same file pattern as Gen 1 entries already in tree. Recent
watchdog tree has similar "add compatible/ID" commits (e.g. `watchdog:
apple: Add "apple,t8103-wdt" compatible`).

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **Yes.** Current tree at
`drivers/watchdog/lenovo_se10_wdt.c:181` has `if (chip_id != 0x5632)`
only. DMI table ends at `12NM` with no Gen 2 entries. Driver present
since v6.18. Gen 2 hardware shipped after driver was written —
recognition gap, not post-branch regression.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Commit `dd785736030e9` is NOT an
ancestor of HEAD but diff applies directly to current file with no
conflicts anticipated. No structural refactoring between upstream and
this tree for this file.

### Step 6.3: Related Fixes Already Present?
**Record:** **No.** `git log --grep="SE10 Gen 2"`, `--grep="0x5652"`,
`--grep="13LJ"` on HEAD returned nothing. Gen 2 support not yet in
6.18.43.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/watchdog/` — **PERIPHERAL** (platform-specific
watchdog driver). Critical for embedded/industrial reliability on
affected hardware, but not a core-kernel path.

### Step 7.2: Subsystem Activity
**Record:** Watchdog subsystem actively maintained; recent commits
include bug fixes (UAF, division-by-zero) and hardware ID additions.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Platform-specific** — Lenovo SE10 Gen 2 systems (DMI
product names `13LJ`, `13LK`, `13S1`–`13S6`) with
`CONFIG_LENOVO_SE10_WDT` enabled. Small population; specific
industrial/edge hardware.

### Step 8.2: Trigger Conditions
**Record:** Every boot on matching Gen 2 hardware with driver enabled.
Not triggerable by unprivileged users. Deterministic, not a race.

### Step 8.3: Failure Mode Severity
**Record:** Without patch: watchdog driver does not load;
`/dev/watchdog` unavailable; no kernel crash, corruption, or security
issue. **Severity: LOW** for kernel stability; **MEDIUM** for
operational reliability on embedded systems that depend on hardware
watchdog for auto-recovery.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables watchdog on Gen 2 SE10 — real hardware that
  cannot use existing driver. Matches stable exception for device ID
  additions.
- **Risk:** Very low — table/ID additions only, no logic changes,
  tested, maintainer-reviewed.
- **Ratio:** Favorable for affected hardware users; negligible risk to
  others.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Falls under stable **NEW DEVICE IDs** exception (chip ID + DMI product
  names to existing driver)
- Driver already exists in 6.18.y since v6.18
- Small (+65/-1), contained, single file
- Tested on real hardware; watchdog maintainer signed off
- Clean apply to current tree
- Listed as STRONG YES signal in review guidelines ("Adds device IDs to
  existing drivers")

**AGAINST backport:**
- Not a bug fix — no crash, UAF, leak, or security issue
- Does not meet strict "fixes important issue" criterion without the
  device-ID exception
- Affects narrow hardware population
- Lore thread unreadable — could not verify reviewer stable nominations

**Unresolved:** Full mailing list thread content (Anubis blocked).

### Step 9.2: Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — maintainer-reviewed,
tested on SE10 G2 |
| 2. Fixes a real bug affecting users? | **PASS** (via device-ID
exception) — Gen 2 hardware cannot use watchdog without it |
| 3. Important issue? | **PASS** (moderate) — watchdog critical for
embedded reliability; not crash/corruption class |
| 4. Small and contained? | **PASS** — 66 lines, one file |
| 5. No new features/APIs? | **PASS** (via exception) — device ID/DMI
extension to existing driver |
| 6. Can apply to local tree? | **PASS** — driver present, patch is
standalone |

### Step 9.3: Exception Category
**Record:** **NEW DEVICE IDs** — adding chip ID `0x5652` and DMI product
name entries to the existing `lenovo_se10_wdt` driver, analogous to
PCI/USB ID additions.

### Step 9.4: Decision Rationale

This commit enables watchdog support on Lenovo SE10 Gen 2 hardware by
extending hardware identification tables in a driver that already ships
in 6.18.y. It is not a kernel bug fix in the traditional sense (no oops,
UAF, or corruption), but it squarely matches the stable-tree exception
for device ID additions to existing drivers: trivial, low-risk, tested,
and required for real hardware to function.

For 6.18.43 users running Gen 2 SE10 platforms with
`CONFIG_LENOVO_SE10_WDT`, this is the difference between having and not
having hardware watchdog support. The change is surgical and cannot
affect non-matching systems.

---

## Verification

- [Phase 1] `git show dd785736030e9 --format=fuller --no-patch`: parsed
  subject, tags, body
- [Phase 2] `git show dd785736030e9 -p`: confirmed +65/-1 in one file,
  chip ID + DMI changes
- [Phase 2] Read `drivers/watchdog/lenovo_se10_wdt.c`: verified current
  code lacks Gen 2 support
- [Phase 3] `git describe HEAD` / `make kernelversion`: tree is v6.18.43
- [Phase 3] `git blame -L 180,184 drivers/watchdog/lenovo_se10_wdt.c`:
  chip check from `5d324e5159d9e` (2025-11-28)
- [Phase 3] `git show v6.18:drivers/watchdog/lenovo_se10_wdt.c | wc -l`:
  driver exists at v6.18 (308 lines)
- [Phase 3] `git merge-base --is-ancestor dd785736030e9 HEAD`: commit
  NOT in current tree
- [Phase 3] `git merge-base --is-ancestor ab48c217d9855 HEAD`: related
  UAF fix also NOT in tree (independent)
- [Phase 4] `b4 dig -c dd785736030e9`: found lore URL, v1 only
- [Phase 4] `b4 dig -c dd785736030e9 -a`: single revision
- [Phase 4] `b4 dig -c dd785736030e9 -w`: watchdog maintainer CC'd
- [Phase 4] WebFetch lore URL: **BLOCKED** by Anubis — thread content
  unverified
- [Phase 5] Grep/read `lenovo_se10_wdt.c`: traced init → DMI → probe
  call chain
- [Phase 6] `git log --grep="SE10 Gen 2"/"0x5652"/"13LJ" HEAD`: no
  existing Gen 2 fix
- [Phase 6] Read current file lines 181, 242-283: confirmed missing Gen
  2 chip ID and DMI entries
- [Phase 7] `git log --oneline -10 -- drivers/watchdog/`: subsystem
  active
- [Phase 8] Assessed impact: platform-specific, no kernel crash without
  patch

**YES**The background check finished: commit `dd785736030e9` (SE10 Gen 2
watchdog support) is **not** in the current `v6.18.43` tree, though the
base `lenovo_se10_wdt` driver is present from v6.18.

**Verdict: YES** — this is a low-risk device-ID/DMI extension to an
existing driver and is appropriate for stable backport to this tree.

 drivers/watchdog/lenovo_se10_wdt.c | 66 +++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/lenovo_se10_wdt.c b/drivers/watchdog/lenovo_se10_wdt.c
index cd0500e5080b4..99ff01af41243 100644
--- a/drivers/watchdog/lenovo_se10_wdt.c
+++ b/drivers/watchdog/lenovo_se10_wdt.c
@@ -178,7 +178,7 @@ static int se10_wdt_probe(struct platform_device *pdev)
 		return -EBUSY;
 
 	chip_id = get_chipID();
-	if (chip_id != 0x5632) {
+	if (chip_id != 0x5632 && chip_id != 0x5652) {
 		release_region(CFG_PORT, CFG_SIZE);
 		return -ENODEV;
 	}
@@ -280,6 +280,70 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 		},
 		.callback = se10_create_platform_device,
 	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13LJ"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13LK"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S1"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S2"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S3"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S4"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S5"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S6"),
+		},
+		.callback = se10_create_platform_device,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(dmi, se10_dmi_table);
-- 
2.53.0

