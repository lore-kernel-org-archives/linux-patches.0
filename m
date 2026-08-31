Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37C44FECD9;
	Mon, 31 Aug 2026 13:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183706; cv=none; b=fStTHNALv/V3l7JEHBPCpa/8uooPzT4eDw5pJiNFfG6WbLPnSjKnPQAEUOWyWTNrX4gSd90XLJtH+v6+aX0BCDyZPw9Uc6xUA1+4orQW0BeXqNrdWdSBfgUuDsZ0w2FNRHu/Wup1CHfzBclRUMj3WBCRMTcLY9f1ADhn+FHiJ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183706; c=relaxed/simple;
	bh=/UIGWPSzVsuz2lrNdBiicc6dFSrM/X3miQ7PA+BjyDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rd77hWWH/8hE0v7loN34dvTQJkeSMV3uC9jDYv93dDFHq0oW1RtiLFJwg3OXhZrFzmBn4tGPnF0xt6jiRxPJjGjTIgLviCr18HHrB+qGOrA95VX0mPE1gZhEJaaRNjZ2SHcvn+oQb030B6yuljq5Xaf3SxXn7kWXjyPvALamwPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxGgrZJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxGgrZJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2141F000E9;
	Mon, 31 Aug 2026 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183703;
	bh=hGO7DxnF0hUGWNeMC4DkULgGvqL893kfpbThi1dppZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxGgrZJgankYR/IJJqHjG+oyBmYEMqhxpr8FgSIRY4+EXSmQ7zN8drJgRg8erMSaW
	 O0H++IXKg4IyE5zof+tDprQ4G9eGekKbeBAJ7BMTgIbhXUj+I3vD5KK8SjnaIfnmml
	 RFBs0GlQejiz4qKt4n89O4G2HaITA/Fdd2f2UWaUi4dUHFp+BGKveVL6kzh4/4apM6
	 QksoNS7U/bO6cAbLv/2wnOC2W7Bmr7JDOfo3fScq56fGvSoPk4QAQ+9uWqzNUH5ks3
	 Oh+XUHVlAmDHwKPA6GWkw8lOKFsecVvLimTkd8b4HNkIDrSzAG7tcfEzJ2fSy2pGNt
	 R7hVnJCU+rQ/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	sen@ti.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: codecs: pcm3168a: Drop CONFIG_PM-conditional preproc directive
Date: Mon, 31 Aug 2026 09:24:42 -0400
Message-ID: <20260831133314.4125787-254-sashal@kernel.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit eb7107264da8545ba7381a76818bae553e1fd1e4 ]

Revert changes done in commit 489db5d94150 ("ASoC: pcm3168a:
Don't disable pcm3168a when CONFIG_PM defined") and add
pm_runtime_status_suspended() check.

The suspended-check addresses regulator's "unbalanced disables"
warning during driver removal even when CONFIG_PM is enabled.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260525201801.1336936-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ASoC: codecs: pcm3168a: Drop CONFIG_PM-
conditional preproc directive`

**Local tree:** `v6.18.44` (kernel `6.18.44`)
**Commit analyzed:** `eb7107264da85` (not yet in this tree's HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ASoC: codecs: pcm3168a]` `[Drop]` — Remove the `#ifndef
CONFIG_PM` guard around regulator/clock teardown in `pcm3168a_remove()`,
replacing it with a `pm_runtime_status_suspended()` check.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent in this commit (original bug documented in
  `489db5d94150`)
- **Tested-by:** — absent
- **Reviewed-by:** — absent
- **Acked-by:** — absent
- **Link:** `https://patch.msgid.link/20260525201801.1336936-4-
  cezary.rojewski@intel.com`
- **Cc: stable:** — absent (not a negative signal)
- **Signed-off-by:** Cezary Rojewski `<cezary.rojewski@intel.com>`, Mark
  Brown `<broonie@kernel.org>` (ASoC maintainer)

Notable: Mark Brown (subsystem maintainer) committed this. Patch 4/4 in
a May 2026 series from the same author.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Commit `489db5d94150` skipped regulator/clock disable in
  `pcm3168a_remove()` when `CONFIG_PM` is defined, assuming runtime
  suspend already handled teardown.
- **Symptom:** `"unbalanced disables"` regulator warnings during driver
  removal with `CONFIG_PM` enabled.
- **Root cause:** Incomplete teardown logic — either double-disable
  (pre-489db5d) or skip-disable-when-active (post-489db5d).
- **Fix approach:** Revert the `#ifndef CONFIG_PM` guard; disable
  regulators/clock in `remove()` only when
  `!pm_runtime_status_suspended(dev)`.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite "Drop CONFIG_PM-conditional preproc directive"
wording, this is a real PM teardown bug fix. It addresses both:
1. Double-disable WARN_ON when device is runtime-suspended at removal.
2. Resource leak when device is runtime-active at removal
   (regulators/clock never disabled under `CONFIG_PM=y`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **File:** `sound/soc/codecs/pcm3168a.c` — 7 insertions, 13 deletions
  (~20 lines net)
- **Functions modified:** `pcm3168a_remove()`, `pcm3168a_rt_suspend()`;
  removes helper `pcm3168a_disable()`
- **Scope:** Single-file, surgical driver fix

### Step 2.2: Code Flow Changes

**Hunk 1 — remove `pcm3168a_disable()` helper:**
- Before: Shared helper for suspend and (conditionally) remove.
- After: Helper removed; disable logic inlined at call sites.

**Hunk 2 — `pcm3168a_remove()`:**
- Before (`CONFIG_PM=y`):
```834:849:sound/soc/codecs/pcm3168a.c
void pcm3168a_remove(struct device *dev)
{
        // ...
        pm_runtime_disable(dev);
#ifndef CONFIG_PM
        pcm3168a_disable(dev);
#endif
}
```
- After: Always call `pm_runtime_disable()`, then disable
  regulators/clock only if `!pm_runtime_status_suspended(dev)`.

**Hunk 3 — `pcm3168a_rt_suspend()`:**
- Before: Calls `pcm3168a_disable(dev)`.
- After: Inlines `regulator_bulk_disable()` + `clk_disable_unprepare()`
  (behavior unchanged).

### Step 2.3: Bug Mechanism
**Record:** **Reference counting / resource lifecycle bug** in driver
remove path.

| Scenario | Old code (`CONFIG_PM=y`) | Fixed code |
|---|---|---|
| Device runtime-suspended at remove | Skip disable (correct) | Skip
disable (correct) |
| Device runtime-active at remove | Never disable → **leak** | Disable
(correct) |
| Pre-489db5d: suspended + disable in remove | Double-disable →
**WARN_ON** | Skip disable (correct) |

### Step 2.4: Fix Quality
**Record:**
- Fix is obviously correct; matches established ASoC pattern (e.g.
  `fsl_asrc_remove()`).
- Minimal, no API changes.
- Low regression risk: only affects driver teardown when not already
  suspended.
- `pm_runtime_disable()` does not auto-suspend active devices (verified:
  `__pm_runtime_disable()` calls `__pm_runtime_barrier()` which waits
  for in-progress ops but does not force suspend), so the post-disable
  status check is necessary and correct.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `#ifndef CONFIG_PM` guard introduced by `489db5d94150` (Nov
2018, Jiada Wang). `pcm3168a_disable()` helper dates to original driver
(2015). Buggy guard has been present since v4.19 era; `489db5d` is an
ancestor of this tree.

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag. Referenced commit `489db5d94150` is
present in this tree and introduced the incomplete fix.

### Step 3.3: Related File History
**Record:** Related commits on master (same series, not prerequisites
for this patch):
- `bb3c847523f95` — S4 hibernation double-disable fix (separate bug)
- `2c734439be9ca` — remove redundant `pm_runtime_idle()` (cleanup)
- `eb7107264da85` — this commit (patch 4/4)

This commit is **standalone**; it does not depend on the S4 or
`pm_runtime_idle` patches.

### Step 3.4: Author Context
**Record:** Cezary Rojewski (Intel) contributed recent pcm3168a work
(`Allow for 24-bit in provider mode`, `Relax probing conditions`). Intel
AVS machine drivers use pcm3168a. Mark Brown committed with maintainer
sign-off.

### Step 3.5: Dependencies
**Record:** No prerequisites. `pm_runtime_status_suspended()` exists in
`include/linux/pm_runtime.h` in this tree. Patch applies cleanly against
current `sound/soc/codecs/pcm3168a.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c eb7107264da85` returned no results. `WebFetch` of
the Link: URL blocked by Anubis bot protection. **UNVERIFIED:** Full
review thread content, explicit stable nominations, NAKs.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via `b4 dig -w`. Mark Brown committed the
patch (strong maintainer endorsement).

### Step 4.3: Bug Report
**Record:** Original bug documented in `489db5d94150` with full stack
traces:
- `unbalanced disables for amp-en-regulator`
- `WARNING` at `_regulator_disable+0x28` in `drivers/regulator/core.c`
- `WARNING` at `clk_core_disable` and `clk_core_unprepare` in
  `drivers/clk/clk.c`
- Triggered by `rmmod snd_soc_pcm3168a_i2c` on Renesas H3ULCB (2018).

### Step 4.4: Related Patches
**Record:** Part of a 4-patch May 2026 series. S4 fix (`bb3c847523f95`)
addresses a different hibernation path; not required for this remove-
path fix.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — lore stable list search
blocked/unavailable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `pcm3168a_remove()`, `pcm3168a_rt_suspend()`,
`pcm3168a_rt_resume()`

### Step 5.2: Callers
**Record:** `pcm3168a_remove()` called from:
- `sound/soc/codecs/pcm3168a-i2c.c` — `pcm3168a_i2c_remove()`
- `sound/soc/codecs/pcm3168a-spi.c` — `pcm3168a_spi_remove()`

Triggered on device unbind, module unload (`rmmod`), or hot-unplug.

### Step 5.3: Callees
**Record:** `gpiod_set_value_cansleep()`, `pm_runtime_disable()`,
`pm_runtime_status_suspended()`, `regulator_bulk_disable()`,
`clk_disable_unprepare()`.

### Step 5.4: Reachability
**Record:** Reachable on driver removal/unbind. Requires
`CAP_SYS_MODULE` for `rmmod` (root). Common on embedded development,
driver reload testing, and module-based audio stacks. Not a syscall-
level attack vector, but a real operational bug.

### Step 5.5: Similar Patterns
**Record:** Identical `pm_runtime_disable()` +
`pm_runtime_status_suspended()` pattern in multiple ASoC drivers, e.g.:

```1410:1412:sound/soc/fsl/fsl_asrc.c
        pm_runtime_disable(&pdev->dev);
        if (!pm_runtime_status_suspended(&pdev->dev))
                fsl_asrc_runtime_suspend(&pdev->dev);
```

Also in `sun8i-codec.c`, `rockchip_spdif.c`, `fsl_sai.c`, etc.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current HEAD has `#ifndef CONFIG_PM` guard at lines
846–848 and `pcm3168a_disable()` helper. `489db5d94150` is an ancestor.
Fix commit `eb7107264da85` is **not** in HEAD.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Single file, no structural
conflicts. Local tree recently changed PM ops via `15559cdeb9be5`
(`EXPORT_GPL_DEV_PM_OPS`) but remove/suspend paths match the patch
context.

### Step 6.3: Related Fixes Already Present?
**Record:** No. `git log --grep="Prevent regulator double-disable"`
returns nothing in HEAD. S4 fix not present either (separate issue).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **sound/ASoC** — **PERIPHERAL** driver (pcm3168a codec).
Used on Intel AVS boards, Renesas, TI K3, and others.

### Step 7.2: Activity
**Record:** Actively maintained — Intel AVS machine support added
recently (`79ebb596201c8`, `b9fb91692af88`). PM ops modernized in
`15559cdeb9be5`.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of pcm3168a codec with `CONFIG_PM=y` (essentially all
production kernels) who unload/remove the driver.

### Step 8.2: Trigger Conditions
**Record:**
- **Common:** `rmmod` or device unbind while codec is runtime-suspended
  (idle) — original double-disable WARN_ON (pre-489db5d; this commit
  prevents regression of that scenario while fixing the leak).
- **Less common but real:** Removal while runtime-active —
  regulators/clock left enabled (current tree bug).
- **Privilege:** Root/module-capable user required for `rmmod`.

### Step 8.3: Failure Mode Severity
**Record:**
- Kernel `WARNING` at `regulator_disable` / `clk_disable` — **MEDIUM**
  (taints kernel, no panic)
- Regulator/clock leak on active-device removal — **MEDIUM-HIGH**
  (resource leak, may affect re-probe or power state)
- Not data corruption or security exploit

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Fixes reproducible WARN_ON (documented since 2018) and
  resource leak on driver removal; aligns with established ASoC pattern.
- **Risk:** Very low — ~7 lines of logic change, maintainer-approved, no
  API changes.
- **Ratio:** Benefit outweighs risk for this tree.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, long-standing bug in driver remove path
- Reproducible WARN_ON with stack traces (since 489db5d, 2018)
- Resource leak when removing active device under `CONFIG_PM=y`
- Small, surgical, maintainer-committed fix
- Established pattern used across ASoC subsystem
- Buggy code confirmed present in v6.18.44; fix not yet applied
- Clean backport expected

**AGAINST backport:**
- Limited to pcm3168a hardware users (peripheral scope)
- Failure mode is WARN_ON/leak, not panic or data corruption
- Requires root for `rmmod` trigger
- Lore review details unverified

**UNRESOLVED:**
- Full mailing list review thread (b4 dig / lore blocked)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — pattern proven in multiple
   drivers; maintainer sign-off
2. Fixes a real bug affecting users? **PASS** — WARN_ON + resource leak
   on driver removal
3. Important issue? **PASS (MEDIUM)** — kernel warnings and PM resource
   leak, not crash/corruption
4. Small and contained? **PASS** — 1 file, ~20 lines
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, fix absent,
   clean apply expected

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
driver bug fix.

### Step 9.4: Decision Rationale

For **v6.18.44**, the incomplete remove-path logic from `489db5d94150`
is present: with `CONFIG_PM=y`, `pcm3168a_remove()` never disables
regulators/clock when the device is runtime-active, and the pre-489db5d
double-disable WARN_ON would return without the suspended check. This
commit fixes both cases using the same pattern already used throughout
ASoC. It is small, maintainer-approved, and addresses a real operational
bug on hardware that is actively supported (Intel AVS, embedded
platforms).

---

## Verification

- **[Phase 1]** `git show eb7107264da85`: parsed subject, body, tags
  (Link, SOBs)
- **[Phase 1]** `git show 489db5d94150`: original bug with stack traces
  for double-disable WARN_ON
- **[Phase 2]** `git show eb7107264da85 -p`: diff analysis (remove
  helper, add suspended check)
- **[Phase 2]** Read `sound/soc/codecs/pcm3168a.c` lines 825–910:
  confirmed buggy code in HEAD
- **[Phase 3]** `git blame -L 825,850 sound/soc/codecs/pcm3168a.c`:
  `#ifndef CONFIG_PM` from 489db5d (2018)
- **[Phase 3]** `git merge-base --is-ancestor 489db5d94150 HEAD`:
  confirmed in tree
- **[Phase 3]** `git merge-base --is-ancestor eb7107264da85 HEAD`: fix
  NOT in tree
- **[Phase 3]** `git log --oneline -20 -- sound/soc/codecs/pcm3168a.c`:
  recent history reviewed
- **[Phase 3]** `git show bb3c847523f95`, `2c734439be9ca`: related
  series commits identified as non-prerequisites
- **[Phase 4]** `b4 dig -c eb7107264da85`: no results
- **[Phase 4]** `WebFetch` lore URL: blocked by Anubis — **UNVERIFIED**
  review thread
- **[Phase 5]** `grep pcm3168a_remove`: callers in i2c/spi probe files
- **[Phase 5]** `grep pm_runtime_status_suspended sound/soc/`:
  established pattern in fsl_asrc, sunxi, rockchip, mediatek
- **[Phase 5]** Read `fsl_asrc.c:1410-1412`: identical remove pattern
- **[Phase 5]** Read `drivers/base/power/runtime.c:1522-1559`:
  `__pm_runtime_disable()` does not force suspend
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: v6.18.44 /
  6.18.44
- **[Phase 6]** `grep pm_runtime_status_suspended
  include/linux/pm_runtime.h`: API present
- **[Phase 8]** `git show 489db5d94150`: confirmed WARN_ON failure mode
  and rmmod trigger

**YES**

 sound/soc/codecs/pcm3168a.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index 7f8d64fb0e57f..2066cf6c1e976 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -822,15 +822,6 @@ int pcm3168a_probe(struct device *dev, struct regmap *regmap)
 }
 EXPORT_SYMBOL_GPL(pcm3168a_probe);
 
-static void pcm3168a_disable(struct device *dev)
-{
-	struct pcm3168a_priv *pcm3168a = dev_get_drvdata(dev);
-
-	regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies),
-			       pcm3168a->supplies);
-	clk_disable_unprepare(pcm3168a->scki);
-}
-
 void pcm3168a_remove(struct device *dev)
 {
 	struct pcm3168a_priv *pcm3168a = dev_get_drvdata(dev);
@@ -842,10 +833,12 @@ void pcm3168a_remove(struct device *dev)
 	 * The asserted level of GPIO_ACTIVE_LOW is LOW.
 	 */
 	gpiod_set_value_cansleep(pcm3168a->gpio_rst, 1);
+
 	pm_runtime_disable(dev);
-#ifndef CONFIG_PM
-	pcm3168a_disable(dev);
-#endif
+	if (!pm_runtime_status_suspended(dev)) {
+		regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies), pcm3168a->supplies);
+		clk_disable_unprepare(pcm3168a->scki);
+	}
 }
 EXPORT_SYMBOL_GPL(pcm3168a_remove);
 
@@ -900,7 +893,8 @@ static int pcm3168a_rt_suspend(struct device *dev)
 
 	regcache_cache_only(pcm3168a->regmap, true);
 
-	pcm3168a_disable(dev);
+	regulator_bulk_disable(ARRAY_SIZE(pcm3168a->supplies), pcm3168a->supplies);
+	clk_disable_unprepare(pcm3168a->scki);
 
 	return 0;
 }
-- 
2.53.0

