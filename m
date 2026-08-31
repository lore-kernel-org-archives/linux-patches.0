Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E435C58FD1F;
	Mon, 31 Aug 2026 13:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184251; cv=none; b=kDoWjHizKmjGS7hrXUbQIdvmiCV7p7GtNT3GzlYrda90i4QQK3LEKIg2KS9S/x591ArMgnLe9PaDsHRt6R9zWcQl3NCeEu6qjJr1onFO/gT/KAE8uwHQ3LHekD+Tvu28SixvFR7pCZeNceUuDYurRSOXDhgC6dgugDVbXqket48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184251; c=relaxed/simple;
	bh=kQ4lYD5oTwFC8xsvbKLxftlUNTKqTEYD/LC8FJsADyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uD6lkPPkbIFnVrmIG3mxFV7rwI52rRCkIISfPiuUzsu3ru3/4NErwhDSeG5INffZLXP7r4/OIGMm4Uu2QrmpubjrWjKXAzdjJJGtbnKlM1SWpcXH4R6CqmoDOQ/qvboMz0+wL37DoWQIT79P7uSlb9upf7SBB0E+yvzn6omJJEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSziANUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSziANUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50131F00A3E;
	Mon, 31 Aug 2026 13:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184248;
	bh=ilmLay646quhiSaTllAkjbNWVuNYgdU7ga209ABNBWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XSziANUUcKR5mKtLByLdVHQKiD14anRaTAIxArztSXzS3oDLxda8Qjer7Zw50+wuE
	 LKA0DVS7CYmeSpy0YS+Kap2e48KYMtxMWL1VQ4yXICxOlqyEFI+9n8+IIQQn4PzJRT
	 CUreedX9LSMJ+IKn2eEzKgMAjC339gQ6XzzsaFWfl9Z9DOvSIvfFaZ5fLQXSbi+kA2
	 isdfZtnW14fwrlUMXlIi/iVxr4Ue6CIhfLtvTsIe7ed1sSr9w/ODt8jDtSmO6u/Yeh
	 M2W1M7A+MeWe65FF/VcYdiJ/RRPOFXZB+2gWAz48OJXefRDql9204CJSaf0+Nm8CgW
	 FZxMEbX5KV/kA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	heiko@sntech.de,
	linux-sound@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: rockchip: rockchip_pdm: Reorder clock enable sequence
Date: Mon, 31 Aug 2026 09:30:08 -0400
Message-ID: <20260831133314.4125787-580-sashal@kernel.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3168721d6ec3b610edf6a3c22ad190722a27d276 ]

Enable the 'hclk' bus clock before the 'clk' controller clock during
runtime resume.
The bus clock provides the register access interface, so enable it before
the controller clock. This also makes the resume sequence the reverse of
the suspend sequence, which keeps the clock ordering consistent.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 3)...
Retry attempt 3...
## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[ASoC: rockchip: rockchip_pdm]` `[Reorder]` — Reorder the
runtime-resume clock enable sequence for the Rockchip PDM driver.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:**
  https://patch.msgid.link/20260602101608.45137-4-phucduc.bui@gmail.com
- **Cc: stable@vger.kernel.org:** — not present (expected)
- **Signed-off-by:** bui duc phuc, Mark Brown (ASoC maintainer)

Notable: no user report, syzbot, or explicit stable nomination. Mark
Brown accepted the patch.

### Step 1.3: Analyze the Commit Body
**Record:**
- **Bug:** `rockchip_pdm_runtime_resume()` enables `pdm_clk` (controller
  clock) before `pdm_hclk` (bus clock).
- **Symptom/failure mode:** Not explicitly described (no crash, hang, or
  user report). The commit argues that register access requires the bus
  clock, so resume ordering is wrong and does not mirror suspend.
- **Version info:** none in the message.
- **Root cause:** Bus clock (`hclk`) provides the register interface; it
  must be enabled before the controller clock (`clk`). Suspend disables
  `clk` then `hclk`; resume should reverse that.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Yes — this is a PM correctness bug disguised as ordering
cleanup. Resume currently mirrors suspend instead of reversing it, which
is incorrect for clock domains where the bus clock gates register
access.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `sound/soc/rockchip/rockchip_pdm.c` (+/- ~6 logical lines
  in one hunk)
- **Functions modified:** `rockchip_pdm_runtime_resume()`
- **Scope:** Single-file, surgical PM fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (runtime resume):**
  - **Before:** enable `pdm->clk`, then `pdm->hclk`; on second failure,
    disable `pdm->clk`
  - **After:** enable `pdm->hclk`, then `pdm->clk`; on second failure,
    disable `pdm->hclk`
- **Path affected:** Runtime PM resume and anything that calls it
  (system sleep resume via `pm_runtime_resume_and_get()`)

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic / PM correctness fix (clock enable ordering)
- **Mechanism:** Suspend disables controller clock first, then bus
  clock. Resume must enable bus clock first, then controller clock.
  Current code enables both in the same order as suspend, violating
  standard clock-domain ordering and the driver’s own probe path (probe
  enables `hclk` first).

### Step 2.4: Fix Quality
**Record:**
- Fix is obviously correct and minimal.
- Matches the pattern used in `rockchip_sai.c` and `rockchip_i2s_tdm.c`
  (hclk before functional clock on resume).
- Regression risk is very low: only reorders two existing
  `clk_prepare_enable()` calls and corresponding error-path cleanup.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame the Changed Lines
**Record:**
- Buggy ordering introduced in **fc05a5b222530** (“ASoC: rockchip: add
  support for pdm controller”, June 2017).
- Error-path cleanup added later in **ef0a098efb366** (Dec 2022).
- Bug has existed since driver introduction; present in this tree.

### Step 3.2: Follow the Fixes: Tag
**Record:** No `Fixes:` tag — not applicable.

### Step 3.3: File History for Related Changes
**Record:**
- Related prior fix: **ef0a098efb366** — missing
  `clk_disable_unprepare()` on error path in the same function (already
  in this 6.18.y tree).
- No evidence this is part of a multi-patch dependency series.
- Standalone fix.

### Step 3.4: Author's Other Commits
**Record:** Author (bui duc phuc) has other ASoC cleanup/guard patches;
this is a targeted Rockchip PDM PM fix accepted by maintainer Mark
Brown.

### Step 3.5: Dependent/Prerequisite Commits
**Record:** No dependencies. Code structures (`pdm->clk`, `pdm->hclk`,
runtime PM callbacks) all exist in this tree. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:**
- `b4 dig -c 8f78f7bc1806c` failed — commit not in this checkout.
- Link fetch blocked (403 / bot protection).
- Could not retrieve lore thread content.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — `b4 dig -w` failed for the same reason. Mark
Brown’s Signed-off-by confirms maintainer acceptance.

### Step 4.3: Bug Report Search
**Record:** No bug report, syzbot link, or crash description in the
commit message or accessible lore thread.

### Step 4.4: Related Patches / Series
**Record:** Message-ID suffix `45137-4` suggests patch 4 of a series,
but no related mbox files for this patch were found in the workspace.
Fix itself is self-contained.

### Step 4.5: Stable Mailing List History
**Record:** UNVERIFIED — could not search lore due to access
restrictions. No `Cc: stable@vger.kernel.org` in the commit message.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rockchip_pdm_runtime_resume()` (modified), with callers:
- `rockchip_pdm_probe()` (when runtime PM disabled)
- `rockchip_pdm_pm_ops` runtime resume callback
- `rockchip_pdm_resume()` via `pm_runtime_resume_and_get()`

### Step 5.2: Callers
**Record:**
- **Runtime PM idle/resume cycle:** common audio power-management path
- **System sleep resume:** `rockchip_pdm_resume()` →
  `pm_runtime_resume_and_get()` → `regcache_sync()`
- **Probe fallback:** only when `CONFIG_PM` disabled

### Step 5.3: Callees
**Record:** `clk_prepare_enable()`, `clk_disable_unprepare()`,
`dev_err()`

### Step 5.4: Call Chain / Reachability
**Record:**
- Resume path is reachable on Rockchip boards using PDM microphones
  (RK3328, RK3568, RV1126).
- Trigger: runtime PM resume after idle, or system suspend/resume.
- Not directly userspace-triggerable as a security primitive, but
  reachable during normal audio use and system PM.

### Step 5.5: Similar Patterns
**Record:**
- **Correct pattern:** `rockchip_sai.c` and `rockchip_i2s_tdm.c` enable
  `hclk` before functional clock on resume.
- **Same bug pattern:** `rockchip_spdif.c` also enables mclk before hclk
  on resume (not fixed by this commit).
- **PDM probe:** enables `hclk` first at line 614.

---

## Phase 6: Cross-Referencing Against the Local Tree

### Step 6.1: Does the Buggy Code Exist?
**Record:** **Yes.** Local tree is **v6.18.44** (`6.18.44`). Current
code at lines 425–435 enables `pdm->clk` before `pdm->hclk`. Bug present
since v4.13 era (2017 driver addition).

### Step 6.2: Backport Complications
**Record:** Expected **clean apply** — single hunk, no structural
changes needed. No significant recent churn in this function beyond
unrelated cleanups.

### Step 6.3: Related Fixes Already Present?
**Record:** **ef0a098efb366** (error-path cleanup in the same function)
is already in this tree. The clock-ordering fix is **not** present.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem and Criticality
**Record:** **ASoC / Rockchip PDM audio driver** — **IMPORTANT** for
embedded Rockchip platforms using PDM digital microphones; not core-
kernel, but relevant to production ARM64 boards.

### Step 7.2: Subsystem Activity
**Record:** Driver is mature but still receives maintenance (runtime PM
conversion, warning fixes, RK3568/RV1126 support). Active enough that PM
paths matter.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Rockchip SoCs with PDM enabled in device tree (e.g.
RK3568, RK3328, RV1126). Config/platform-specific, not universal.

### Step 8.2: Trigger Conditions
**Record:**
- Runtime PM resume after autosuspend
- System sleep resume (`rockchip_pdm_resume()`)
- Common during audio use on battery-powered/embedded devices
- Not unprivileged attack surface; normal device PM operation

### Step 8.3: Failure Mode Severity
**Record:**
- **Potential failure:** clock enable/resume problems, PDM capture
  failure after suspend/resume, possible hardware misbehavior if
  controller clock is enabled without bus clock
- **Observed/reported severity:** **UNVERIFIED** — no crash report in
  commit message; bug latent since 2017
- **Classification:** **MEDIUM** — functional PM/resume correctness on
  real hardware, not demonstrated crash/security/corruption

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** Correct PM behavior on resume; aligns with sibling
  Rockchip drivers and probe ordering; may fix intermittent post-resume
  audio failures
- **Risk:** Very low — 6-line reorder, no API changes
- **Ratio:** Moderate benefit, very low risk; importance is somewhat
  reduced by lack of demonstrated user impact

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Compile

**FOR backport:**
- Real PM bug: resume does not reverse suspend clock order
- Bus clock must precede controller clock for register access
- Probe already enables `hclk` first; runtime resume is internally
  inconsistent
- Matches correct pattern in `rockchip_sai` and `rockchip_i2s_tdm`
- Used on system sleep resume before `regcache_sync()`
- Small, surgical, maintainer-reviewed fix
- Buggy code exists in this 6.18.y tree since 2017
- Prior fix in same function already accepted into stable tree

**AGAINST backport:**
- No user report, syzbot, or documented crash/hang
- Commit does not describe concrete user-visible symptoms
- Bug latent ~9 years without reported failures
- Stable “important issue” bar usually wants demonstrated impact (crash,
  corruption, security, deadlock)
- Similar wrong ordering exists in `rockchip_spdif.c` and has also
  persisted

**UNRESOLVED:**
- Lore review thread content
- Whether reviewers explicitly nominated for stable
- Concrete failure reports on any Rockchip board

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logically correct;
   maintainer signed off; no Tested-by
2. Fixes a real bug affecting users? **PASS** — real PM ordering bug,
   though user impact unverified
3. Important issue? **BORDERLINE/PASS** — can break audio after resume
   on embedded hardware; not proven crash/corruption
4. Small and contained? **PASS** — one function, ~6 lines
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — code exists, clean apply expected

### Step 9.3: Exception Categories
**Record:** Not a device-ID/quirk/DT/build/docs exception. Standard
driver PM bug fix.

### Step 9.4: Decision Rationale

This is a genuine runtime-PM bug in a driver that exists and is used in
the local **6.18.y** tree. The fix is minimal, obviously correct, and
aligns the PDM driver with the established Rockchip pattern (`hclk`
before functional clock on resume, reverse of suspend). The resume path
is exercised during normal audio PM and system sleep resume before
register restore.

The main weakness is the absence of any reported crash or user failure
despite the bug being present since 2017. That lowers urgency, but the
fix is still appropriate for stable because:
- it corrects objectively wrong PM ordering on a real resume path,
- it is zero-risk and self-contained,
- incorrect clock ordering on resume can cause device malfunction after
  suspend on Rockchip PDM hardware,
- a related fix in the same function is already in this stable tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Reported-by/syzbot/Fixes
  tags found
- **[Phase 2]** Diff analysis: swap of two `clk_prepare_enable()` calls
  and corresponding error cleanup in `rockchip_pdm_runtime_resume()`
- **[Phase 3]** `git blame`: buggy order from fc05a5b222530 (2017);
  ef0a098efb366 added error-path cleanup (2022)
- **[Phase 3]** `git log --oneline -20 --
  sound/soc/rockchip/rockchip_pdm.c`: confirmed related prior fix in
  tree
- **[Phase 3]** `git merge-base --is-ancestor fc05a5b222530 HEAD`:
  original driver commit is in this tree
- **[Phase 4]** `b4 dig -c 8f78f7bc1806c`: failed — commit not in
  checkout
- **[Phase 4]** WebFetch/curl lore: blocked (403/bot protection) —
  thread content UNVERIFIED
- **[Phase 5]** Read callers: probe, PM ops, `rockchip_pdm_resume()` via
  `pm_runtime_resume_and_get()`
- **[Phase 5]** Compared patterns in `rockchip_sai.c`,
  `rockchip_i2s_tdm.c`, `rockchip_spdif.c`
- **[Phase 6]** `git describe HEAD` + Makefile: tree is v6.18.44
- **[Phase 6]** Read current `rockchip_pdm.c`: buggy ordering confirmed
  at lines 425–435
- **[Phase 6]** DT check: PDM present for rk3568/rk3328 in
  `arch/arm64/boot/dts/rockchip/`
- **[Phase 8]** Failure mode assessed as functional PM/resume issue; no
  verified crash report

**YES**

 sound/soc/rockchip/rockchip_pdm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index 01292b63bf9d6..115e90d3bbfe0 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -426,16 +426,16 @@ static int rockchip_pdm_runtime_resume(struct device *dev)
 	struct rk_pdm_dev *pdm = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(pdm->clk);
+	ret = clk_prepare_enable(pdm->hclk);
 	if (ret) {
-		dev_err(pdm->dev, "clock enable failed %d\n", ret);
+		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
 		return ret;
 	}
 
-	ret = clk_prepare_enable(pdm->hclk);
+	ret = clk_prepare_enable(pdm->clk);
 	if (ret) {
-		clk_disable_unprepare(pdm->clk);
-		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
+		clk_disable_unprepare(pdm->hclk);
+		dev_err(pdm->dev, "clock enable failed %d\n", ret);
 		return ret;
 	}
 
-- 
2.53.0

