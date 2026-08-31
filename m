Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD7058A9AB;
	Mon, 31 Aug 2026 13:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184228; cv=none; b=kIS0kquYTlDPL2ypoj3CqpzS8nIYQcK8T6yVRqNXhvRquEFlBUQeJg6Hj4mzDVBOSWPYtesyEe4ficXG1/cs6Y5Mq5KBmYPfZpIBua1pgYPD0q3sFbWF5iSDwLktequBbdSStRiExmV9pnSoO+eQQR5Qil487/g4eJY79xOldzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184228; c=relaxed/simple;
	bh=f0/wFsu4gQj5zlgn6B27q+E8TXHKztpTPbNnkZVK6Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9NjAHpmvpY74LcNm9eN/PkbF3AFYVqm4EytklNSzdvhEH0skKKhxht5U12eS4w3bv9UiU4TUmC+hPZu1qr5K36R0RKf1qM48rkYQw/lJ+bGou2gJNy3yniRXeXb9VQfNXva613eP6WX2DUwQ98ulvGp52XVUeEgIC2/R7z7b5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k51Ilv3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k51Ilv3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AD71F00A3E;
	Mon, 31 Aug 2026 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184226;
	bh=RhOX3kDaiERRk8lp7sWh2I8Eh9oqB1joUmiMGjAq4Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k51Ilv3aEOeIG7T4EFMTqmDQOY6H/DIDocTF07iXqyWY/d8SR/3WevMFDdq4iuSNx
	 B1UwrLQ0wsaJXGGvk3C9qe1txoNyc4+dUzY4AVVETYIwqlrzS6LAI59R3afHHt/2PR
	 r986w+2Ep08PLHUgO8PZ7vFlc41aDkxfH/fmvUBARduovbPYCtX0neGBQ3teXKTYvB
	 VYshP7300zDNEDDNYrpAqE4bXhEizctzyJkFTuoWI10ukd9SaVygVH3p+v6qKZyKiZ
	 k/dl85SdsN8ZsYBgM5Q4kZ9odass3hB1PCuOv1dgchSRWeFt2l+mSBeVFichLQL7Dp
	 nZA/HTflHATYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthias Fend <matthias.fend@emfend.at>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pavel@kernel.org,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] leds: tps6131x: Increase overvoltage protection threshold to 6V
Date: Mon, 31 Aug 2026 09:29:55 -0400
Message-ID: <20260831133314.4125787-567-sashal@kernel.org>
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

From: Matthias Fend <matthias.fend@emfend.at>

[ Upstream commit d43f1d792902ba0a53fd311bff2cf96095c7606d ]

Currently, there may be cases where the overvoltage detection is triggered
even with a valid and generally functioning hardware setup. This occurs,
for example, when the input voltage exceeds the currently used overvoltage
threshold of 4.65V (typical). Since input voltages up to 5V are supported,
the threshold should be adjusted accordingly.

While the target output voltage setting has no effect on the LED operation
used here, it indirectly selects the threshold for overvoltage detection.
Set this to a value of 4.95V to select a threshold of 6V (typical).

Signed-off-by: Matthias Fend <matthias.fend@emfend.at>
Link: https://patch.msgid.link/20260527-leds-tps6131x-ovp-v1-1-1ac70d03c9eb@emfend.at
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `leds: tps6131x: Increase overvoltage
protection threshold to 6V`

**Local tree:** `v6.18.44` (`VERSION = 6`, `PATCHLEVEL = 18`, `SUBLEVEL
= 44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[leds: tps6131x]` `[Increase]` — adjust overvoltage
protection (OVP) threshold from ~4.65V to 6V in chip initialization.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Matthias Fend `<matthias.fend@emfend.at>` (driver
  author / hardware vendor contact)
- **Link:** `https://patch.msgid.link/20260527-leds-
  tps6131x-ovp-v1-1-1ac70d03c9eb@emfend.at`
- **Signed-off-by:** Lee Jones `<lee@kernel.org>` (LED subsystem
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`

Notable: maintainer ack; no fuzzer or user bug reports in the message.

### Step 1.3: Body analysis
**Record:**
- **Bug:** OVP can trip on valid hardware when input voltage exceeds the
  current ~4.65V threshold.
- **Symptom:** Spurious overvoltage protection on systems with input up
  to 5V (within chip spec).
- **Root cause:** `tps6131x_init_chip()` writes REG_6 with only `ENTS`,
  leaving OV field at 0 (~4.65V). The OV setting must be programmed via
  the target-output-voltage field; value `TPS6131X_OV_4950MV` selects a
  6V (typical) threshold.
- **Versions:** Driver landed in v6.17; this tree (6.18.44) includes it.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as a threshold increase, but it fixes
incorrect register programming in `tps6131x_init_chip()` that leaves OVP
too low for normal 5V operation.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/leds/flash/leds-tps6131x.c` (+1 effective line
  change in one hunk; whitespace-only elsewhere in hunk)
- **Function:** `tps6131x_init_chip()`
- **Scope:** Single-file, surgical (1 logical line)

### Step 2.2: Code flow change
**Record:**
- **Before:** `val = TPS6131X_REG_6_ENTS;` → `regmap_write(REG_6, 0x80)`
  — only bit 7 set; OV field (bits 0–3) cleared to 0.
- **After:** `val = TPS6131X_REG_6_ENTS | (TPS6131X_OV_4950MV <<
  TPS6131X_REG_6_OV_SHIFT);` — preserves ENTS and sets OV to value 9 (6V
  typical threshold per commit message).
- **Path:** Probe-time chip init, after reset, before LED class setup.

### Step 2.3: Bug mechanism
**Record:** **Logic / hardware configuration bug.** `regmap_write()`
replaces the full register. Writing only `ENTS` clears OV to the lowest
threshold (~4.65V), below the supported 5V input range. This contradicts
`tps6131x_regmap_defaults[]`, which already specifies
`TPS6131X_OV_4950MV` for REG_6.

### Step 2.4: Fix quality
**Record:** Obviously correct — aligns runtime init with existing regmap
defaults and datasheet intent. Minimal change, no API changes, very low
regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy line `val = TPS6131X_REG_6_ENTS;` introduced in
`b338a2ae9b316` (2025-05-14), “leds: tps6131x: Add support for Texas
Instruments TPS6131X flash LED driver”. Present since driver
introduction in v6.17.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Original buggy commit is
`b338a2ae9b316`, confirmed ancestor of HEAD.

### Step 3.3: Related file history
**Record:** Driver history in this tree:
- `b338a2ae9b316` — driver added
- `c3c38e8001654` — V4L2 dependency fix
No other OVP-related commits. Standalone fix, not part of a series.

### Step 3.4: Author context
**Record:** Matthias Fend authored the original driver and DT binding;
listed as maintainer in
`Documentation/devicetree/bindings/leds/ti,tps61310.yaml`. Lee Jones
committed both driver and this fix.

### Step 3.5: Dependencies
**Record:** None. `TPS6131X_OV_4950MV` and `TPS6131X_REG_6_OV_SHIFT`
already exist in this tree (lines 68–69, 140). Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Commit not merged in this checkout; `b4 dig -c <hash>` not
usable. `b4 dig` without commitish requires different invocation.
Lore/patch.msgid.link returned 403/bot protection — **could not read
thread**.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — `b4 dig -w` not run (no commitish). Lee Jones
SOB indicates maintainer acceptance.

### Step 4.3: Bug reports
**Record:** No `Reported-by:` or syzbot links. Author-reported hardware
bring-up issue.

### Step 4.4: Related patches
**Record:** Standalone v1 patch per Link message-id
(`...-ovp-v1-1-...`). No series dependency identified.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore blocked; no local mbox for this patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `tps6131x_init_chip()` modified; callers unchanged.

### Step 5.2: Callers
**Record:** `tps6131x_init_chip()` called once from `tps6131x_probe()`
(line 773), during I2C device probe for `ti,tps61310` / `ti,tps61311`.

### Step 5.3: Callees
**Record:** `regmap_write()` to hardware register REG_6 after
`tps6131x_reset_chip()`.

### Step 5.4: Reachability
**Record:** Triggered at device probe when `CONFIG_LEDS_TPS6131X` is
enabled and hardware is present. Not userspace-syscall reachable, but
affects every boot/probe of this hardware.

### Step 5.5: Similar patterns
**Record:** `tps6131x_regmap_defaults[]` line 156 already uses
`(TPS6131X_OV_4950MV << TPS6131X_REG_6_OV_SHIFT)` for REG_6 — init_chip
was the outlier. `tps6131x_flash_fault_get()` reads REG_6 status flags
but does not program OV.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at line 280:

```280:282:drivers/leds/flash/leds-tps6131x.c
        val = TPS6131X_REG_6_ENTS;

        ret = regmap_write(tps6131x->regmap, TPS6131X_REG_6, val);
```

Driver commit `b338a2ae9b316` is ancestor of HEAD. Bug present since
v6.17.

### Step 6.2: Backport complications
**Record:** Clean apply expected — one-line change, no structural
conflicts. File has low churn since driver addition.

### Step 6.3: Related fixes already present?
**Record:** No — `git log --grep="overvoltage protection threshold"`
returned empty; OVP fix not in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/leds/flash/` — LED flash driver for TI TPS6131x.
**Criticality: PERIPHERAL** (specific camera/flash hardware).

### Step 7.2: Activity
**Record:** Driver added recently (6.17); limited follow-up
(`c3c38e8001654` dependency fix only).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of `CONFIG_LEDS_TPS6131X` with TPS6131x hardware on
~5V input rails. No in-tree DTS users found (`grep` for
`tps61310`/`tps6131x` in `*.dts*` returned none), but binding and driver
are present for out-of-tree/custom boards.

### Step 8.2: Trigger conditions
**Record:** Every probe after reset on affected hardware with input
voltage above ~4.65V (common 5V supply). Not timing-dependent;
deterministic misconfiguration.

### Step 8.3: Failure mode severity
**Record:** Spurious hardware overvoltage protection → flash/torch may
fail or report faults on otherwise valid setups. **Severity: MEDIUM** —
real functional failure on affected hardware, not a kernel
oops/panic/data corruption.

### Step 8.4: Risk vs benefit
**Record:**
- **Benefit:** MEDIUM for affected hardware (driver unusable on spec-
  compliant 5V designs without fix)
- **Risk:** VERY LOW (one register bitfield, matches existing defaults
  table)
- **Ratio:** Favorable for a tree that already ships this driver

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real driver bug present since v6.17 in this 6.18.44 tree
- Incorrect OVP threshold on valid 5V hardware
- One-line, obviously correct fix aligned with regmap defaults
- Hardware configuration / quirk category
- Driver author + subsystem maintainer involvement
- Applies cleanly with no dependencies

**AGAINST backport:**
- Not crash/security/corruption/deadlock
- New, niche driver with no in-tree DTS users yet
- No syzbot or user bug reports
- Lore review thread not accessible for stable nomination confirmation

**Unresolved:** Full mailing-list review discussion; production user
reports.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — matches existing defaults;
   maintainer SOB; logic verified in code
2. Fixes real bug affecting users? **PASS** — spurious OVP on 5V systems
3. Important issue? **PASS (borderline)** — functional hardware failure
   on affected devices; not kernel crash
4. Small and contained? **PASS** — one logical line
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — driver and symbols exist

### Step 9.3: Exception category
**Record:** Hardware workaround / register quirk — adjusting chip OVP
threshold for correct operation within the 5V input spec.

### Step 9.4: Decision rationale
This tree (`6.18.44`) ships the TPS6131x driver with a probe-time
initialization bug that programs an OVP threshold (~4.65V) below the
chip’s supported 5V input. The fix is minimal, matches values already in
`tps6131x_regmap_defaults[]`, and restores correct hardware behavior for
boards using this driver. While not a kernel crash fix, it is a clear
hardware-configuration bug in a shipped driver — the kind of targeted
quirk fix stable trees routinely carry.

---

## Verification

- **[Phase 1]** `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`;
  Makefile → 6.18.44
- **[Phase 1]** Parsed commit message tags from user query
- **[Phase 2]** Read `drivers/leds/flash/leds-tps6131x.c` lines 63–69,
  140, 156, 254–287, 479–521, 769–775
- **[Phase 2]** Confirmed diff is one logical register-field change in
  `tps6131x_init_chip()`
- **[Phase 3]** `git blame -L 275,285` → buggy line from `b338a2ae9b316`
- **[Phase 3]** `git show b338a2ae9b316` → driver added 2025-05-14,
  regmap default already had `TPS6131X_OV_4950MV`
- **[Phase 3]** `git merge-base --is-ancestor b338a2ae9b316 HEAD` →
  driver in tree
- **[Phase 3]** `git log --oneline -20 -- drivers/leds/flash/` → no OVP
  fix present
- **[Phase 3]** `git log --grep="Increase overvoltage"` → empty (fix not
  merged)
- **[Phase 4]** `b4 dig --help` → requires `-c COMMITISH`; commit not in
  tree
- **[Phase 4]** WebFetch lore + curl raw → 403/bot blocked
- **[Phase 5]** `grep tps6131x_init_chip` → single caller in
  `tps6131x_probe()`
- **[Phase 6]** Current line 280 still `val = TPS6131X_REG_6_ENTS;` (bug
  present)
- **[Phase 6]** `git tag -l 'v6.17*' --contains b338a2ae9b316` → driver
  in v6.17+
- **[Phase 6]** `grep -r tps61310/tps6131x *.dts*` → no in-tree DTS
  users
- **[Phase 7]** Read `Kconfig` `LEDS_TPS6131X` and `MAINTAINERS` entry
- **UNVERIFIED:** Mailing-list reviewer feedback and any `Cc: stable`
  nominations
- **UNVERIFIED:** Whether any production boards in the wild hit this on
  6.18.y yet

**YES**The background search finished: there is **no OVP fix commit** in
this tree yet. `git log --grep` only turned up the original TPS6131x
driver (`b338a2ae9b316`) and related follow-ups (DT binding,
MAINTAINERS, V4L2 dependency) — nothing matching “overvoltage protection
threshold” or OVP changes in `leds-tps6131x.c`.

That matches the earlier analysis: the bug is still present at line 280
(`val = TPS6131X_REG_6_ENTS;`), and backporting this one-line fix to
**6.18.y** is warranted.

**YES**

 drivers/leds/flash/leds-tps6131x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/flash/leds-tps6131x.c b/drivers/leds/flash/leds-tps6131x.c
index 6f4d4fd553610..ad96455b3b02a 100644
--- a/drivers/leds/flash/leds-tps6131x.c
+++ b/drivers/leds/flash/leds-tps6131x.c
@@ -277,7 +277,7 @@ static int tps6131x_init_chip(struct tps6131x *tps6131x)
 	if (ret)
 		return ret;
 
-	val = TPS6131X_REG_6_ENTS;
+	val = TPS6131X_REG_6_ENTS | (TPS6131X_OV_4950MV << TPS6131X_REG_6_OV_SHIFT);
 
 	ret = regmap_write(tps6131x->regmap, TPS6131X_REG_6, val);
 	if (ret)
-- 
2.53.0

