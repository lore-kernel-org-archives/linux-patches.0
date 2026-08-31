Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6024A0927;
	Mon, 31 Aug 2026 13:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183699; cv=none; b=BA/PUtgTzsKV4Rhfgo7ohOwjxto9i9qHI/MEEiBv/0/PT/YSVFZHIKSobcGm2vqqbifniFJT8WaIPPjblzZWrVoUqWgg+QSh3pUSwgEIS1UXJnmqibYeWhvb/RW8ZxHkNB4Cs/sdPHe5em63p7k/GV/HJFzKxb4XNzYJK5XENZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183699; c=relaxed/simple;
	bh=ltuDfQ7QZqiRAgvpyktmmDEDKuVQA87KA5z0eue77zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0O+0kCw0OBGyBa1DJhvijFNMlOlSuPNbxSuW6qAeJwiFlkderyr4m+TU2JxgyQ2tCnNU1grdO81eBSJNEbJ4KmS2svVpatbqOj9Xgsy17XvNAhTTeazm9WG92T68FSaB2NRWn5m3ZCJV9L4/R2f2FMSdabGCVWoYvxC2o2MNjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5f7yPAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5f7yPAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462B31F00A3E;
	Mon, 31 Aug 2026 13:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183696;
	bh=4aA/mw8wPBGPJo8tBTr0TR4w7ObCSJFfJDmxuWAwlWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5f7yPAVoLwc5zPj89XaGgsvvjU9bNzaIAy2ImrEJ9XshNBBf2+jaNCjfQU6KClmv
	 6aQ78KKMOThjX2O5fcqm2Bh2PMy1mANqh2+5hc3TU32MwdAOMWnDJevqGNiBOaZrZS
	 hYGfjL9WxwWoUnGjLpLWRE50zqmAinjHDyUFRC6h2DCaXZzWRQcLGXXj+dMzJEZLNj
	 WgPuvzYpG45OX1UVViR7hHeUV90u3WwjsVdDKjh5OFZQwBG0kPIfBSbxyUZyuaA2cV
	 cpI3OZUBsHaE9Z/l0D39yxfvU1FtrYL7zLXG7ENYsddaCMMa4kr772jr9NeWv5Hkt/
	 oQD9DFaQOFDWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: dsa: mv88e6xxx: enable .rmu_disable() for 6320 family
Date: Mon, 31 Aug 2026 09:24:38 -0400
Message-ID: <20260831133314.4125787-250-sashal@kernel.org>
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

From: Marek Behún <kabel@kernel.org>

[ Upstream commit e0fdb4157a85056bd256a7aebac4a3a2f580b201 ]

Commit 9e5baf9b3636 ("net: dsa: mv88e6xxx: add RMU disable op") did not
add the .rmu_disable() method for the 6320 family. Add it now.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260504153227.1390546-5-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: dsa: mv88e6xxx: enable .rmu_disable()
for 6320 family`

**Local tree:** Linux 6.18.43 (`v6.18.43-1-gc7f0dac02d232`, `VERSION =
6`, `PATCHLEVEL = 18`, `SUBLEVEL = 43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[net: dsa: mv88e6xxx]` `[enable]` — add the missing
`.rmu_disable()` callback to the MV88E6320/MV88E6321 ops tables.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by:** — absent
- **Acked-by:** — absent
- **Link:**
  `https://patch.msgid.link/20260504153227.1390546-5-kabel@kernel.org`
  (patch 5/N of a series by Marek Behún)
- **Cc: stable:** — absent (not a negative signal)
- **Signed-off-by:** Marek Behún `<kabel@kernel.org>`, Jakub Kicinski
  `<kuba@kernel.org>` (net maintainer)

No syzbot, no user bug reports, no explicit stable nomination.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug description:** When MV88E6320/MV88E6321 ops tables were created,
  `.rmu_disable` was omitted. Commit `9e5baf9b3636` (May 2018)
  introduced the RMU-disable infrastructure for other Marvell switch
  families; these two new 6320-family chip IDs were not wired up.
- **Symptom/failure mode:** During driver setup, `mv88e6xxx_rmu_setup()`
  silently does nothing for MV88E6320/6321 because the ops pointer is
  NULL. The switch's Remote Management Unit (RMU) mode bits in Global
  Control 2 are never cleared to `RMU_MODE_DISABLED`.
- **Version information:** None stated.
- **Root cause:** Ops-table omission when MV88E6320/MV88E6321 chip
  entries were added.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Yes — described as "enable," but it is a hardware-
initialization bug fix. Without it, RMU may remain enabled on a port
(per `MV88E6352_G1_CTL2_RMU_MODE_PORT_*` values in `global1.h`),
diverging from every other 6352-layout chip that sets `.rmu_disable =
mv88e6352_g1_rmu_disable`.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/net/dsa/mv88e6xxx/chip.c` only (+2 lines)
- **Functions modified:** `mv88e6320_ops`, `mv88e6321_ops` (static const
  struct initializers)
- **Scope:** Single-file, surgical, 2-line fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (`mv88e6320_ops`):** Before: after `.reset =
  mv88e6352_g1_reset`, setup proceeds to VTU ops with no RMU handling.
  After: `.rmu_disable = mv88e6352_g1_rmu_disable` is registered, so
  `mv88e6xxx_rmu_setup()` will call it during `mv88e6xxx_setup()`.
- **Hunk 2 (`mv88e6321_ops`):** Identical change.
- **Path affected:** Normal probe/setup path, called once per switch at
  initialization.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Bug category:** Logic / hardware-initialization correctness
- **Mechanism:** `mv88e6xxx_rmu_setup()` at line 1675 checks
  `chip->info->ops->rmu_disable`; if NULL, returns 0 without touching
  hardware. MV88E6320/6321 use `mv88e6352_g1_reset` and the 6352-family
  G1 CTL2 register layout but lacked the matching
  `mv88e6352_g1_rmu_disable` callback. The fix wires the existing,
  correct disable function.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Fix quality:** Obviously correct — identical to `mv88e6352_ops`,
  `mv88e6172_ops`, `mv88e6240_ops`, etc.
- **Regression risk:** Very low — adds a single register mask write
  during init, same as 15 other chip variants already do.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `mv88e6320_ops` / `mv88e6321_ops` and
`[MV88E6320]`/`[MV88E6321]` chip table entries blame to `5d324e5159d9e`
(2025-11-28 merge). Repository is shallow (`git rev-parse --is-shallow-
repository` → `true`), limiting deeper history. The ops tables without
`rmu_disable` are present in this 6.18.43 tree.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag. Referenced commit `9e5baf9b3636` ("net:
dsa: mv88e6xxx: add RMU disable op", May 2018) is in this tree and added
`mv88e6xxx_rmu_setup()` plus `.rmu_disable` for contemporary chip
families. MV88E6320/MV88E6321 as distinct chip IDs with dedicated ops
tables are a later addition; the omission is in those newer tables, not
in the 2018 commit itself.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Shallow history shows only 2 commits touching `chip.c` on
HEAD. This fix appears to be patch 5 of a Marek Behún series (message-id
suffix `-5`). Standalone — no other patches required;
`mv88e6352_g1_rmu_disable` already exists in `global1.c`.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** No Marek Behún commits found in shallow history for this
path. Jakub Kicinski (net maintainer) signed off.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. `mv88e6352_g1_rmu_disable`,
`mv88e6xxx_rmu_setup()`, and MV88E6320/MV88E6321 chip entries all exist
in this tree. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c HEAD` matched unrelated commit. `b4 shazam` for
subject and message-id returned "not known." `patch.msgid.link` and
`lore.kernel.org` blocked by Anubis bot protection. **Could not retrieve
mailing list discussion.**

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** UNVERIFIED — `b4 dig -w` not usable without matching commit
hash on lore.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No `Reported-by:` or bugzilla/syzbot links. No external bug
report found.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Message-id `...-5-...` indicates patch 5 of a series (likely
MV88E6320/MV88E6321 support). This fix completes ops-table wiring for
chips already present in 6.18.43. Other patches in the series not
verified.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** UNVERIFIED — lore.kernel.org inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `mv88e6320_ops`, `mv88e6321_ops` (data),
`mv88e6352_g1_rmu_disable` (existing callee), `mv88e6xxx_rmu_setup`
(caller during init).

### Step 5.2: TRACE CALLERS
**Record:** `mv88e6xxx_rmu_setup()` called from `mv88e6xxx_setup()`
(line 4051), which is the DSA switch setup callback during device probe.
Every MV88E6320/6321 boot triggers this path.

### Step 5.3: TRACE CALLEES
**Record:** `mv88e6352_g1_rmu_disable()` → `mv88e6xxx_g1_ctl2_mask(chip,
MV88E6352_G1_CTL2_RMU_MODE_MASK, MV88E6352_G1_CTL2_RMU_MODE_DISABLED)` —
clears RMU mode bits in Global Control 2.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Device probe → `mv88e6xxx_setup()` → `mv88e6xxx_rmu_setup()`
→ (currently no-op for 6320/6321) → should call
`mv88e6352_g1_rmu_disable()`. Reachable on every boot with
MV88E6320/6321 hardware; not userspace-triggerable but always runs for
affected devices.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Of 28 `mv88e6xxx_ops` structs, 15 have `.rmu_disable`. Among
chips using `mv88e6352_g1_reset`, some older variants (e.g.
`mv88e6161_ops`, `mv88e6351_ops`) also lack it — but `mv88e6352_ops`,
`mv88e6172_ops`, `mv88e6341_ops`, and other newer 6352-layout chips do
have it. MV88E6320/6321 are the only chips using dedicated
`mv88e6320_ops`/`mv88e6321_ops` and are clearly intended to follow the
6352-family pattern (they already use `mv88e6352_g1_reset`,
`mv88e6352_gpio_ops`, etc.).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** `mv88e6320_ops` (line 5181) and `mv88e6321_ops`
(line 5233) have `.reset = mv88e6352_g1_reset` but no `.rmu_disable`.
`[MV88E6320]` and `[MV88E6321]` chip entries exist at lines 6247 and
6275.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected** — 2 identical lines inserted after
`.reset` in each ops struct. No conflicting changes in recent `chip.c`
history.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No existing fix. `git log --grep="rmu_disable"` and
`--grep="6320 family"` return nothing on this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/net/dsa/mv88e6xxx` — DSA Ethernet switch driver.
**IMPORTANT** (networking infrastructure on embedded/industrial
hardware; not core kernel, but affects connectivity for specific
platforms).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively maintained; MV88E6320/MV88E6321 are recent
additions. Marek Behún is a regular mv88e6xxx contributor; Jakub
Kicinski signed off.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Driver-specific / hardware-specific** — only systems with
Marvell 88E6320 or 88E6321 DSA switches (embedded/industrial routers,
automotive, etc.).

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Triggers on every driver probe (boot, module load). Not
timing-dependent. Requires `CONFIG_NET_DSA_MV88E6XXX` and MV88E6320/6321
hardware. Common for affected hardware (every boot).

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** RMU may remain enabled, routing management frames to an
unexpected port. Potential networking misbehavior or unexpected
management exposure. **Severity: MEDIUM** — functional hardware
misconfiguration, not a kernel oops/UAF/corruption. No crash reports
documented.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Correct switch initialization for MV88E6320/6321; aligns
  with peer 6352-family chips; prevents incorrect RMU state on every
  boot.
- **Risk:** Minimal — 2 lines, existing tested function, same pattern as
  15 other variants.
- **Ratio:** Moderate benefit, very low risk. Appropriate for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real omission bug in hardware init path for MV88E6320/6321
- Buggy code confirmed present in Linux 6.18.43
- Obviously correct, 2-line fix using existing
  `mv88e6352_g1_rmu_disable`
- Called on every probe for affected hardware
- Net maintainer (Jakub Kicinski) signed off
- Zero regression risk
- Completes support for chips already in this stable tree

**AGAINST backport:**
- No user bug reports, syzbot, or crash traces
- Failure mode is incorrect hardware config, not kernel
  crash/security/CVE
- Several older 6352-reset chips also lack `rmu_disable` without known
  fallout
- Mailing list discussion unverified

**UNRESOLVED:**
- Full patch series context and reviewer stable nominations (lore
  inaccessible)
- Whether users have reported observable symptoms

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — mirrors `mv88e6352_ops`;
   maintainer signed off; no Tested-by.
2. Fixes a real bug that affects users? **PASS** — ops-table omission
   leaves RMU enabled on MV88E6320/6321.
3. Important issue? **PASS (borderline)** — networking misconfiguration
   on affected hardware at every boot; not a crash but real functional
   impact.
4. Small and contained? **PASS** — 2 lines, 1 file.
5. No new features or APIs? **PASS** — wires existing callback only.
6. Can apply to the local tree? **PASS** — prerequisite code present;
   clean apply.

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** Hardware workaround / quirk — corrects missing hardware
initialization for specific Marvell switch chips. Falls under the
hardware-quirk exception category.

### Step 9.4: DECISION RATIONALE
This is a small, obviously correct completion of MV88E6320/MV88E6321
driver support already present in 6.18.43. The RMU-disable step runs on
every probe and is standard for 6352-layout chips in this driver. The
fix is low-risk and addresses a real hardware-initialization omission
that can cause incorrect switch behavior. It meets stable criteria.

---

## Verification

- [Phase 1] Parsed subject, tags: Link present; no Reported-by/syzbot;
  SOB from Behún and Kicinski
- [Phase 1] Commit body references `9e5baf9b3636` as RMU infrastructure
  origin
- [Phase 2] Diff: +2 lines in `chip.c`, both `.rmu_disable =
  mv88e6352_g1_rmu_disable`
- [Phase 2] Confirmed `mv88e6xxx_rmu_setup()` no-ops when callback is
  NULL (lines 1675–1680)
- [Phase 2] Confirmed `mv88e6352_g1_rmu_disable()` exists in `global1.c`
  (lines 539–543)
- [Phase 3] `git describe HEAD`: v6.18.43; `make kernelversion`
  equivalent from Makefile: 6.18.43
- [Phase 3] `git show 9e5baf9b3636`: May 2018 commit added RMU disable
  infrastructure
- [Phase 3] Shallow repo confirmed; limited `git log` on `chip.c`
- [Phase 3] `git blame` on MV88E6320 entry and `.reset` line: present
  since `5d324e5159d9e`
- [Phase 4] `b4 dig -c HEAD`: no match for this commit
- [Phase 4] `b4 shazam`: lore lookup failed (message not known)
- [Phase 4] `patch.msgid.link` and `lore.kernel.org`: blocked by Anubis
  — **UNVERIFIED** discussion/reviewer feedback
- [Phase 5] `mv88e6xxx_rmu_setup()` caller: `mv88e6xxx_setup()` line
  4051
- [Phase 5] Python scan: `mv88e6320_ops` and `mv88e6321_ops` are only
  ops using `mv88e6352_g1_reset` without `rmu_disable` among 6320-family
  dedicated tables
- [Phase 6] Confirmed `mv88e6320_ops`/`mv88e6321_ops` lack `rmu_disable`
  at lines 5181–5182 and 5233–5234
- [Phase 6] Confirmed `[MV88E6320]`/`[MV88E6321]` chip entries at lines
  6247–6300
- [Phase 6] No DT bindings referencing 88E6320/6321 in this tree (no
  `.dts` matches)
- [Phase 8] Failure mode: RMU not disabled → MEDIUM severity hardware
  misconfiguration

**YES**The background history search didn’t finish cleanly — the repo is
shallow, so `git log -S "MV88E6320]"` mostly surfaced merge commits and
wasn’t useful for pinpointing when 6320 support landed.

What we could verify from blame: the `MV88E6320`/`MV88E6321` chip
entries and their ops tables are already in this **6.18.43** tree, and
both `mv88e6320_ops` / `mv88e6321_ops` are missing `.rmu_disable` while
using `mv88e6352_g1_reset`.

That doesn’t change the earlier verdict: this is a small, correct
hardware-init fix for chips already supported here.

**YES**

 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f324b88450427..7e294f2104b86 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5179,6 +5179,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
@@ -5232,6 +5233,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
-- 
2.53.0

