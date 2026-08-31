Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014FD46DFF4;
	Mon, 31 Aug 2026 13:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183302; cv=none; b=Q2SkfSpHu9fKxYNYLHhP/n4z7VgfFoAitdNtUm9NQvGdKahdsD9ve/NkcQwjEOQOi4tz0Jgmb+DFMRpDx2Htxlr1R/QGK/rk+nDYwTn6bxq2OSDxpB3Xwk03pQ9o+8iMbMbrgw2XcGKC2SdubEzIBYS0OA/Kqevm5Z1BzBmiep4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183302; c=relaxed/simple;
	bh=1xDt4C7KhNf7kVp/+VSVtbC7O7z4obXhQ+RE6SH4Vfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OodMFHdfKjiU8xmuvHt9N+znsPKI2+TljDWNv9ZvM4/4eeTQTKPLg140txg8812t2NPjVhGC2LY6OeAx2zCXi59fVzU8wsCWL9jKRCD8TQ7XSY3ETAtj41rtzgemMwG3/XInV9zwuMqdP6kS/IvTMX3u+A07s0XEHL7lOTLCB+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQ1B9cYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQ1B9cYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3BA1F00A3D;
	Mon, 31 Aug 2026 13:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183299;
	bh=y1preF5+Nm7sJx/6vhxIdSvAsjE3Sh4FPm3KwOWx5nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQ1B9cYaONWodq5EeYE26AZdKdJw6BfXk/uViTMzCk7rz9I+oKSDUQTIWeokjEbr4
	 Ac8Oq1SsFyPMLKYXFUcjZ7pPR3erW+Xr2NLIoaPovkDU0NVaxRf7LDdth1i39F9spT
	 BlLqrs+7rMzLKyZa3YOdn13OdXaMy7rQF2mpiSbfcUeHprKcOnbipMC91hF/KWBSBC
	 QfVOUrFt3jyVw6NEFLw7fe4EIJPtZfBGOKxgb/mm8nkgD0suipbXXJ13AW7kcotB+s
	 7CBir4mMKwcEjzgrLMiM5UT8hQ/9XrbVpJNx93r1QOzQPYQ5zQzfXC3uYHlEnTj7+m
	 2Y9R1ZHO2rYOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] hwmon: (dell-smm) Add Dell Latitude 7530 to fan control whitelist
Date: Mon, 31 Aug 2026 09:21:34 -0400
Message-ID: <20260831133314.4125787-66-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 5a1aba28f6c79f4bbb7a5361063225030ecd36f3 ]

A user reported that the Dell Latitude 7530 needs to be whitelisted
for the special SMM calls necessary for globally enabling/disabling
BIOS fan control.

Closes: https://github.com/Wer-Wolf/i8kutils/issues/17
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20260610180141.311503-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `hwmon: (dell-smm) Add Dell Latitude 7530 to
fan control whitelist`

**Local tree:** `v6.18.44` (stable/linux-6.18.y)
**Mainline commit:** `5a1aba28f6c79` (merged via `hwmon-for-v7.2`, not
yet in this 6.18.y checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[hwmon: (dell-smm)]` `[Add]` — Add Dell Latitude 7530 to
the existing fan-control DMI whitelist.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Closes:** https://github.com/Wer-Wolf/i8kutils/issues/17
- **Signed-off-by:** Armin Wolf \<W_Armin@gmx.de\>
- **Acked-by:** Pali Rohár \<pali@kernel.org\> (dell-smm co-developer /
  whitelist maintainer)
- **Link:**
  https://lore.kernel.org/r/20260610180141.311503-1-W_Armin@gmx.de
- **Signed-off-by:** Guenter Roeck \<linux@roeck-us.net\> (hwmon
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or syzbot tags.

Notable: maintainer ack from Pali Rohár; user bug report via GitHub
issue.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** Dell Latitude 7530 is missing from
  `i8k_whitelist_fan_control`, so the driver never sets the correct SMM
  codes (`manual_fan`/`auto_fan`) for toggling BIOS automatic fan
  control.
- **Symptom:** Manual fan control via hwmon `pwmX_enable` / i8kutils
  does not work; user saw fan speed capped (~3500 RPM) without the
  whitelist entry vs ~4000 RPM with it.
- **Root cause:** SMM fan-control codes differ per Dell model; only
  whitelisted models get the correct codes at init via
  `dell_smm_init_dmi()`.
- No kernel version range stated in the commit message.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised cleanup — this is an explicit hardware-
enablement / quirk entry. Functionally fixes broken manual fan control
on one laptop model.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/hwmon/dell-smm-hwmon.c` (+8 lines, 0 removed)
- **Functions touched:** data in `i8k_whitelist_fan_control[]` (used by
  `dell_smm_init_dmi()`)
- **Scope:** Single-file, surgical DMI table addition.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Before:** On Latitude 7530,
  `dmi_first_match(i8k_whitelist_fan_control)` returns NULL →
  `manual_fan`/`auto_fan` stay 0 → `pwmX_enable` sysfs attribute is not
  exposed (`auto_fan` check at line 864 fails) and
  `i8k_enable_fan_auto_mode()` is never used with correct SMM codes.
- **After:** Latitude 7530 matches → `manual_fan=0x30a3`,
  `auto_fan=0x31a3` (same as Latitude 7320) → fan auto/manual SMM
  control is enabled for this machine.
- **Path affected:** `__init` DMI setup at boot (`dell_smm_init_dmi()` →
  `i8k_init()`).

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Category (h): Hardware workaround / DMI quirk.** Missing
DMI whitelist entry prevents correct per-model SMM codes from being
configured. Same mechanism as the existing Latitude 7320 entry
(`b4be51302d687`).

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Obviously correct: copies the proven Latitude 7320 pattern
  (`I8K_FAN_30A3_31A3`), user-tested on GitHub.
- Minimal, no unrelated changes.
- Regression risk very low: only affects systems matching
  `DMI_PRODUCT_NAME == "Latitude 7530"`. The original 2019 whitelist
  commit notes incorrect SMM codes can be dangerous, but this uses the
  same validated codes as the sibling 7320 model after maintainer/user
  testing.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Insertion point is after Latitude 7320 entry
(`b4be51302d687`, Jul 2024). Whitelist infrastructure introduced in
`afe45277ade62` (Nov 2019). `I8K_FAN_30A3_31A3` enum value present since
at least `8debe3c1295ef`. All prerequisites are long-established in
6.18.y.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Multiple prior whitelist additions already in 6.18.y:
- `b4be51302d687` — Latitude 7320 (same author, same pattern, same
  `I8K_FAN_30A3_31A3`)
- `f8611a7981cd0` — G15 5510
- `fa0bc8f297b29` — G15 5511
- etc.

Standalone single-patch series (v1 only). No series dependencies.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Armin Wolf is a regular dell-smm contributor in this tree
(7320 whitelist, OptiPlex DMI entries, fan mode support). Not the
subsystem maintainer, but established contributor with maintainer ack on
this patch.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Requires only existing
`i8k_whitelist_fan_control`, `i8k_fan_control_data[]`, and
`I8K_FAN_30A3_31A3` — all present in 6.18.44. `git apply --check` on the
mainline patch succeeds cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260610180141.311503-1-W_Armin@gmx.de
- **Series:** v1 only (committed version is latest)
- **Reviewer feedback:** Acked-by Pali Rohár; Guenter Roeck applied. No
  NAKs, no stable nomination in thread.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** CC'd: `pali@kernel.org`, `linux@roeck-us.net`, `linux-
hwmon@vger.kernel.org`. Pali Rohár (co-developer of whitelist mechanism)
acked.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** GitHub issue #17 (piotr152):
- User confirmed without `driver_data`: fan capped at 3500 RPM
- With `I8K_FAN_30A3_31A3`: works, ~4000 RPM
- Same treatment needed as Latitude 7320 (issue #8)
- Severity from user perspective: functional fan-control failure, not
  kernel crash

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone patch. Related prior fix: `b4be51302d687`
(Latitude 7320) — already in 6.18.y.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** No stable-list discussion found for this specific patch. Not
a negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `dell_smm_init_dmi()` (consumer of whitelist),
`i8k_enable_fan_auto_mode()` (uses `manual_fan`/`auto_fan`),
`dell_smm_is_visible()` (exposes `hwmon_pwm_enable` when `auto_fan` is
set).

### Step 5.2: TRACE CALLERS
**Record:** `dell_smm_init_dmi()` called from `i8k_init()` at module
init (`__init`). Affects all subsequent hwmon sysfs read/write on
matched Dell laptops. Not interrupt context; init-time configuration.

### Step 5.3: TRACE CALLEES
**Record:** `dmi_first_match()` → sets globals `manual_fan`/`auto_fan` →
used later by `i8k_enable_fan_auto_mode()` → `dell_smm_call()` (SMM BIOS
call).

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Boot-time DMI match → userspace writes `pwm1_enable` via
hwmon sysfs (root typically required) → `i8k_enable_fan_auto_mode()`.
Reachable from userspace on affected hardware; not a security crash
vector.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Identical pattern used for 12+ models in
`i8k_whitelist_fan_control[]` in this tree, including Latitude 7320 with
the same `I8K_FAN_30A3_31A3` codes.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** The whitelist table exists but lacks Latitude 7530.
`grep "Latitude 7530"` returns no matches in 6.18.44. The omission (not
a regression) means 7530 owners on 6.18.y lack fan-control enablement
that sibling models (7320) already have.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** Verified with `git apply --check`.
Insertion point (after 7320, before E6440) matches current file layout
exactly.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Latitude 7320 whitelist (`b4be51302d687`) is present.
Latitude 7530 fix is not. No duplicate fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **hwmon / dell-smm driver.** **IMPORTANT** for Dell laptop
users relying on fan control; **PERIPHERAL** from a whole-kernel
perspective (DMI-gated, one laptop model).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** hwmon is actively maintained in 6.18.y; dell-smm receives
regular DMI whitelist updates (7320, G15 5510/5511, XPS entries, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Driver-specific / platform-specific** — Dell Latitude 7530
owners using `dell-smm` hwmon fan control (i8kutils, manual thermal
management).

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Every boot on Latitude 7530 with `dell-smm` loaded. Common
for affected hardware owners. Requires root for sysfs writes; not an
unprivileged attack vector.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **Functional failure** — manual BIOS fan-control toggle via
SMM does not work; fan speed may be capped below what manual control
allows. **Severity: LOW–MEDIUM** (thermal management inconvenience, not
kernel oops/corruption). Could matter under heavy workloads if BIOS auto
mode is inadequate.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Enables fan control on a real, shipping laptop for 6.18.y
  users; direct precedent already accepted in this tree (7320).
- **Risk:** Very low — 8 lines, DMI-gated, maintainer-acked, user-tested
  codes.
- **Ratio:** Favorable for backport under the hardware-quirk exception.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Hardware quirk / DMI whitelist exception (explicitly allowed for
  stable)
- Real user-reported issue with on-hardware testing
- Acked-by subsystem co-developer (Pali Rohár)
- Identical precedent already in 6.18.y (Latitude 7320, same SMM codes)
- 8-line patch, applies cleanly, no dependencies
- Driver and infrastructure fully present in 6.18.44

**AGAINST backport:**
- Not a crash, security, deadlock, or data-corruption fix
- Strict reading of "important issue" criterion is borderline
- Fan-control SMM calls carry inherent risk if codes are wrong
  (mitigated by 7320 precedent and user testing)

**UNRESOLVED:** None material to the decision.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — mirrors 7320 entry; user-
   tested on GitHub; maintainer acked.
2. Fixes a real bug affecting users? **PASS** — manual fan control non-
   functional on Latitude 7530.
3. Important issue? **PASS (via quirk exception)** — not crash-level,
   but real hardware functionality for laptop thermal management; fits
   hardware-quirk stable exception.
4. Small and contained? **PASS** — 8 lines, one file.
5. No new features or APIs? **PASS** — DMI table entry only; no new
   sysfs/API surface.
6. Can apply to local tree? **PASS** — verified clean apply to 6.18.44.

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** **Hardware quirk / DMI whitelist workaround** — same
category as Latitude 7320, XPS 9315, G15 5510 entries already in 6.18.y.

### Step 9.4: DECISION RATIONALE

This commit should be backported to **6.18.y**. The dell-smm fan-control
whitelist is an established, conservative mechanism for per-model SMM
code selection. Adding Latitude 7530 with the same `I8K_FAN_30A3_31A3`
codes as the already-backported Latitude 7320 is low risk and fixes a
confirmed user-facing hardware issue. It is not a kernel-stability crash
fix, but it squarely matches the stable-tree exception for hardware-
specific quirks that enable existing driver functionality on real
devices.

---

## Verification

- **[Phase 1]** `git show 5a1aba28f6c79`: parsed subject, tags, body
- **[Phase 1]** GitHub issue #17 fetched: user testing confirms
  `I8K_FAN_30A3_31A3` works; without entry fan capped at 3500 RPM
- **[Phase 2]** Read `dell-smm-hwmon.c` lines 432-441, 863-878,
  1059-1084, 1530-1777: confirmed whitelist → `auto_fan`/`manual_fan` →
  sysfs and SMM path
- **[Phase 2]** `git show 5a1aba28f6c79 --stat`: 1 file, +8 lines
- **[Phase 3]** `git describe HEAD` / `make kernelversion`: tree is
  v6.18.44
- **[Phase 3]** `git blame -L 1560,1567`: Latitude 7320 entry from
  `b4be51302d687`
- **[Phase 3]** `git log -S i8k_whitelist_fan_control`: whitelist
  introduced `afe45277ade62` (2019)
- **[Phase 3]** `git log --grep="fan control whitelist" HEAD`: multiple
  whitelist commits already in 6.18.y including 7320
- **[Phase 3]** `git apply --check` on mainline patch: applies cleanly
  to 6.18.44
- **[Phase 4]** `b4 dig -c 5a1aba28f6c79`: lore thread found
- **[Phase 4]** `b4 dig -c 5a1aba28f6c79 -w`: Pali Rohár and Guenter
  Roeck CC'd
- **[Phase 4]** `b4 dig -c 5a1aba28f6c79 -a`: v1 only, no later
  revisions
- **[Phase 4]** `b4 dig -m /tmp/latitude7530.mbox`: thread downloaded;
  Acked-by Pali Rohár; no stable Cc
- **[Phase 5]** `grep dell_smm_init_dmi`: called from `i8k_init()` at
  line 1808
- **[Phase 6]** `grep "Latitude 7530"`: not present in 6.18.44 (fix
  needed)
- **[Phase 6]** `grep "Latitude 7320"`: present at line 1561 (insertion
  point confirmed)
- **[Phase 6]** `I8K_FAN_30A3_31A3` enum and data present at lines
  1536-1544
- **[Phase 7]** `git log --oneline -20 -- drivers/hwmon/`: active hwmon
  maintenance in tree
- **[Phase 8]** Failure mode assessed as functional/thermal, not crash —
  severity LOW-MEDIUM

**YES**

 drivers/hwmon/dell-smm-hwmon.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 768690a597f4d..9f102589f240c 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1565,6 +1565,14 @@ static const struct dmi_system_id i8k_whitelist_fan_control[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_30A3_31A3],
 	},
+	{
+		.ident = "Dell Latitude 7530",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Latitude 7530"),
+		},
+		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_30A3_31A3],
+	},
 	{
 		.ident = "Dell Latitude E6440",
 		.matches = {
-- 
2.53.0

