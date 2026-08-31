Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE8C4F30E8;
	Mon, 31 Aug 2026 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183661; cv=none; b=Ie5i4uvVJs5snCgVcdW2IxIy1X1aBCbLldqIlCuQzjJlncuNTSGYJu/zD9/+YQYajMtDjYlPB9nmMTyzGjKSAxqutZRrok1KmeKkWtwf2Y/RfTNkljLXUjNQWuKmId9ndxj9u8USG70i0gUqDw2Yl9KH4EkZiQRMUyefNwJV/oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183661; c=relaxed/simple;
	bh=35ftScKN79r4y9/XpMotZcW20dUe1DAof2CnKV9ela0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V5JapgM9QGrBDYYUWCrazoRG54s5ojl08f80ZpTb1dX1zWMISm+dE7SaAOkdvq1pM8mRpR6L3+L+B5W0ItiGlzkzufFkfPRMhoI1xexUZFrt1ecpXBKxSQe8HHD784aEXfN9A+JI0JsCA3zz09oSsydqV0i+tpYRcafIzm0Y6hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhNVhna1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhNVhna1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22A21F00A3D;
	Mon, 31 Aug 2026 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183658;
	bh=ihLb3RsDQds81mGMVctTKmmoDpuj7IoLPdoU1xnopSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhNVhna16hkcynvvA9glKOYI0PCIOvHdhAiNcWUPY8MItC6N7byd00nnt6vcVoLl0
	 9crv/c++t9qfrnF24L0QZ7ZuwqAT99kGrIa1efp+uTmHp9cZTDTIR4NcxGI90UWtAu
	 eRSVaBjgd1+8N/xCQsVV6lrYH5yv6rqrsuAcH4abMPouyei2Ynfa85SXOZnfpiHJAT
	 U7/d21p8tVTRlp6uyuDUKFMYOkMPQHxdiUshIKCxnGPMc8/DBuUvtofesj07dw2tZ1
	 PeEFfZq1tPB4ITph77WKnreeal0mJNTy8Q46KLVaX2sVzuoviVV4JDz+wden/L9No6
	 aRt+DG6ZGD9Tw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joy Zou <joy.zou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] regulator: pca9450: Correct default t_off_deb for PCA9451A/PCA9452
Date: Mon, 31 Aug 2026 09:24:14 -0400
Message-ID: <20260831133314.4125787-226-sashal@kernel.org>
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

From: Joy Zou <joy.zou@nxp.com>

[ Upstream commit fbef4191b4961c125585c715407e693f7d0024a9 ]

The PMIC PCA9451A and PCA9452 have a default power-off debounce time of
2ms according to their datasheet, while PCA9450A and PCA9450BC use 120us.

Add default_t_off_deb field to struct pca9450 to support per-variant
default configuration when the device tree property is not specified.

Datasheet reference links:
- PCA9451A Rev.2.1: https://www.nxp.com/docs/en/data-sheet/PCA9451A.pdf
- PCA9452 Rev.1.0: https://www.nxp.com/docs/en/data-sheet/PCA9452.pdf

Signed-off-by: Joy Zou <joy.zou@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260618-b4-regulator-opt-v1-1-c43b1f62aaf6@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `regulator: pca9450: Correct default
t_off_deb for PCA9451A/PCA9452`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[regulator: pca9450]` `[Correct]` — Fix wrong default
power-off debounce (`t_off_deb`) for PCA9451A/PCA9452 PMIC variants.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Frank Li `<Frank.Li@nxp.com>` (NXP reviewer)
- **Link:** https://patch.msgid.link/20260618-b4-regulator-
  opt-v1-1-c43b1f62aaf6@oss.nxp.com
- **Signed-off-by:** Joy Zou `<joy.zou@nxp.com>` (author)
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (regulator
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, syzbot links

Notable: NXP author + NXP reviewer + subsystem maintainer ack; no user
bug report or fuzzer report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** PCA9451A and PCA9452 datasheet default power-off debounce is
  **2 ms**; PCA9450A/PCA9450BC default is **120 µs**. Driver used 120 µs
  for all variants when DT property `nxp,pmic-on-req-off-debounce-us` is
  absent.
- **Symptom:** Wrong PMIC `PWRCTRL` off-debounce programmed at probe on
  PCA9451A/9452 boards without that DT property.
- **Root cause:** `pca9450_of_init()` hardcoded `T_OFF_DEB_120US` as the
  fallback for all chip types.
- **Fix:** Add per-variant `default_t_off_deb` in `struct pca9450`, set
  in probe switch.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite “Correct default,” this is a real hardware-
configuration bug: the driver overwrites PMIC timing with a value
inappropriate for PCA9451A/9452.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/regulator/pca9450-regulator.c` only (+9 / -1 net
  functional lines)
- **Functions:** `pca9450_of_init()`, `pca9450_i2c_probe()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (`struct pca9450`):** Add `int default_t_off_deb`.
- **Hunk 2 (`pca9450_of_init`):** When `nxp,pmic-on-req-off-debounce-us`
  is missing (`-EINVAL`), use `pca9450->default_t_off_deb` instead of
  hardcoded `T_OFF_DEB_120US`.
- **Hunk 3 (`pca9450_i2c_probe`):** Set `default_t_off_deb` per chip
  type:
  - PCA9450A/BC → `T_OFF_DEB_120US`
  - PCA9451A/9452 → `T_OFF_DEB_2MS`

**Before → After:** Missing DT property → always 120 µs → variant-
correct default (120 µs or 2 ms).

### Step 2.3: Bug mechanism
**Record:** **Category (g): Logic/correctness fix** — wrong default
constant for newer PMIC variants. `pca9450_of_init()` always writes
`PCA9450_REG_PWRCTRL` via `regmap_update_bits()` during probe; with
missing DT property it programmed 120 µs on chips whose default is 2 ms.

### Step 2.4: Fix quality
**Record:** Obviously correct, minimal, matches datasheet. Low
regression risk: PCA9450A/BC behavior unchanged; only PCA9451A/9452
default path changes. No new public API.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy line `t_off_deb = T_OFF_DEB_120US` introduced in
**55ca06f54f57f** (“regulator: pca9450: Add support for setting debounce
settings”, 2025-11-17 / backported to 6.18.y 2026-03-19). Before that
commit, driver did not program `PWRCTRL` debounce at all (hardware
defaults remained).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag. Bug introduced by 55ca06f54f57f,
confirmed present in this tree.

### Step 3.3: Related file history
**Record:**
- `5edeb7d312628` — add pca9451a support
- `017b76fb8e5b6` — add pca9452 support
- `55ca06f54f57f` — add debounce DT configuration (introduced bug)
- `f7e52a24e5b76` — PCA9452 probed name fix
Standalone fix; no series dependency.

### Step 3.4: Author context
**Record:** Joy Zou authored PCA9451A/9452 support commits; NXP
contributor for this driver.

### Step 3.5: Prerequisites
**Record:** Requires `pca9450_of_init()` from 55ca06f54f57f and
PCA9451A/9452 types — all present in this tree. Applies cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Patch discussion
**Record:** Link fetch blocked (Anubis bot protection). `b4 dig` for
this commit hash returned no match (fix not yet merged). `b4 dig -c
55ca06f54f57f` found the original debounce patch thread. Could not read
fix-patch review thread.

### Step 4.2: Reviewers
**Record:** Mark Brown (regulator maintainer) committed; Frank Li (NXP)
reviewed. Appropriate subsystem coverage.

### Step 4.3: Bug report
**Record:** No Reported-by or bugzilla/syzbot link. Issue identified
from datasheet mismatch (author-driven fix).

### Step 4.4: Related patches
**Record:** Standalone 1/1 fix in “regulator-opt” series per Link
subject. No other patches required.

### Step 4.5: Stable list
**Record:** Not searched (no stable discussion found via available
tools).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `pca9450_of_init()`, `pca9450_i2c_probe()`

### Step 5.2: Callers
**Record:** `pca9450_of_init()` called once from `pca9450_i2c_probe()`
at line 1371 during I2C device probe (boot-time, board enumeration).

### Step 5.3: Callees
**Record:** `of_property_read_u32()`, `regmap_update_bits()` on
`PCA9450_REG_PWRCTRL` — programs PMIC power-control timing.

### Step 5.4: Reachability
**Record:** Triggered on every boot for PCA9451A/PCA9452 devices when DT
omits `nxp,pmic-on-req-off-debounce-us`. Not userspace-triggerable;
embedded platform init path. DT bindings in this tree do not document
debounce properties, so omission is likely.

### Step 5.5: Similar patterns
**Record:** Other debounce defaults in `pca9450_of_init()` are also
hardcoded (e.g. `t_on_deb`, `t_on_step`); only `t_off_deb` differs by
PMIC variant per commit message/datasheet.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** `drivers/regulator/pca9450-regulator.c:1182` still
has `t_off_deb = T_OFF_DEB_120US`. PCA9451A/9452 support and debounce
init code are present. Bug introduced by 55ca06f54f57f (ancestor of
HEAD). Fix commit not yet in tree.

### Step 6.2: Backport complications
**Record:** Clean apply expected — small localized change, no conflicts
anticipated.

### Step 6.3: Related fixes already present?
**Record:** No existing fix for this issue found via `git log --grep`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/regulator/` — PMIC driver. **Criticality:
PERIPHERAL** (platform-specific embedded hardware).

### Step 7.2: Activity
**Record:** Active in 6.18.y; recent pca9450 commits include debounce
support and PCA9452 name fix.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Boards with **PCA9451A** or **PCA9452** PMIC and no
`nxp,pmic-on-req-off-debounce-us` DT property. PCA9450A/BC unaffected.

### Step 8.2: Trigger conditions
**Record:** Every boot/probe on affected hardware without explicit DT
property. Common case since bindings don't document the property. Not
unprivileged-userspace reachable.

### Step 8.3: Failure mode severity
**Record:** PMIC ON_REQ off-debounce set to 120 µs instead of required 2
ms. Can cause power-sequencing misbehavior (spurious power-off
recognition, shutdown/boot instability). **Severity: MEDIUM** — real
hardware impact, not a kernel oops/panic/data corruption.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Fixes regression from 55ca06f54f57f; restores datasheet-
  correct PMIC timing for PCA9451A/9452.
- **Risk:** Very low — ~10 lines, PCA9450 variants unchanged.
- **Ratio:** Moderate benefit, very low risk. Regression fix for code
  already in this stable tree.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Regression introduced by 55ca06f54f57f (already in 6.18.y)
- Driver actively programs wrong PMIC register value at probe
- Datasheet-backed, maintainer-reviewed, minimal fix
- PCA9451A/9452 support and buggy code both exist in this tree
- DT bindings omit debounce properties → missing property is the common
  case

**AGAINST backport:**
- No crash, security issue, or data corruption
- Platform-specific embedded hardware only
- No user/fuzzer bug report
- Workaround: add `nxp,pmic-on-req-off-debounce-us = <2000>` to DT

**Unresolved:** Could not read mailing-list review thread for fix patch.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — datasheet defaults, NXP
   review; no runtime test evidence
2. Fixes real bug? **PASS** — wrong PMIC timing programmed for two
   variants
3. Important issue? **PASS (borderline)** — PMIC power-sequencing
   misconfiguration on affected boards; regression from stable commit
4. Small and contained? **PASS** — single file, ~10 lines
5. No new features/APIs? **PASS** — internal field only
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply expected

### Step 9.3: Exception categories
**Record:** Hardware quirk/workaround category — per-variant PMIC timing
correction to match datasheet defaults.

### Step 9.4: Decision rationale

This commit fixes a **regression** in 6.18.y: commit 55ca06f54f57f added
`pca9450_of_init()` which programs `PCA9450_REG_PWRCTRL` on every probe,
but used PCA9450A/BC's 120 µs off-debounce default for all variants.
PCA9451A and PCA9452 require 2 ms per their datasheets. Because DT
bindings in this tree don't document the debounce property, boards are
likely to omit it, making the wrong 120 µs value the common case.

The fix is small, obviously correct, maintainer-reviewed, and restores
correct hardware behavior without changing PCA9450A/BC paths. While not
a kernel crash, incorrect PMIC power-off debounce can cause real
boot/shutdown/power-management failures on affected embedded platforms —
and this is directly fixing broken behavior introduced by a commit
already in this stable tree.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 2] Read current `pca9450-regulator.c` at lines 1120–1297, 1371;
  confirmed diff hunks match tree
- [Phase 3] `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`; Makefile
  → 6.18.44
- [Phase 3] `git blame -L 1180,1190` → 55ca06f54f57f introduced buggy
  default
- [Phase 3] `git show 55ca06f54f57f^` → no `pca9450_of_init` / PWRCTRL
  programming before debounce commit
- [Phase 3] `git merge-base --is-ancestor` → 55ca06f54f57f and
  5edeb7d312628 both ancestors of HEAD
- [Phase 3] `git log --oneline -20 --
  drivers/regulator/pca9450-regulator.c` → history reviewed
- [Phase 4] WebFetch of patch Link → blocked by Anubis
- [Phase 4] `b4 dig -c 55ca06f54f57f` → found debounce patch thread
- [Phase 4] `b4 dig` for fix commit → no match (not merged)
- [Phase 5] `grep pca9450_of_init` → called from probe line 1371
- [Phase 5] Read `include/linux/regulator/pca9450.h` → `T_OFF_DEB_120US`
  / `T_OFF_DEB_2MS` definitions
- [Phase 6] `grep default_t_off_deb` → not present (fix not applied)
- [Phase 6] `grep pmic-on-req-off-debounce` in tree → driver only, no DT
  binding docs
- [Phase 7] `git log --oneline -20 -- drivers/regulator/` → subsystem
  activity confirmed
- [Phase 8] Assessed impact from PWRCTRL register programming path in
  `pca9450_of_init()`

**YES**

 drivers/regulator/pca9450-regulator.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index f991dc9365f18..2e79d0e096518 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -44,6 +44,7 @@ struct pca9450 {
 	unsigned int rcnt;
 	int irq;
 	bool sd_vsel_fixed_low;
+	int default_t_off_deb;
 };
 
 static const struct regmap_range pca9450_status_range = {
@@ -1179,7 +1180,7 @@ static int pca9450_of_init(struct pca9450 *pca9450)
 
 	ret = of_property_read_u32(i2c->dev.of_node, "nxp,pmic-on-req-off-debounce-us", &val);
 	if (ret == -EINVAL)
-		t_off_deb = T_OFF_DEB_120US;
+		t_off_deb = pca9450->default_t_off_deb;
 	else if (ret)
 		return ret;
 	else {
@@ -1274,21 +1275,25 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	case PCA9450_TYPE_PCA9450A:
 		regulator_desc = pca9450a_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9450a_regulators);
+		pca9450->default_t_off_deb = T_OFF_DEB_120US;
 		type_name = "pca9450a";
 		break;
 	case PCA9450_TYPE_PCA9450BC:
 		regulator_desc = pca9450bc_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9450bc_regulators);
+		pca9450->default_t_off_deb = T_OFF_DEB_120US;
 		type_name = "pca9450bc";
 		break;
 	case PCA9450_TYPE_PCA9451A:
 		regulator_desc = pca9451a_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9451a_regulators);
+		pca9450->default_t_off_deb = T_OFF_DEB_2MS;
 		type_name = "pca9451a";
 		break;
 	case PCA9450_TYPE_PCA9452:
 		regulator_desc = pca9451a_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9451a_regulators);
+		pca9450->default_t_off_deb = T_OFF_DEB_2MS;
 		type_name = "pca9452";
 		break;
 	default:
-- 
2.53.0

