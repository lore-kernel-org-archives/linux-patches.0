Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591434968F6;
	Mon, 31 Aug 2026 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183528; cv=none; b=f2T2+88zjl5I0XxJdhHzLhzCPOC8MaRCBnjkR48cVR7Ghl/bLLu8pqU2iIEjohq9Vpa3V22G8113RVZD4a7Tq02Z2dX5WaxjPA+UgfE0SGDTS1OLHbqxh5EFJJgJEyDhq6Kmw1OUivg4sKqECLsSqKzBAVnefvV1k1oofeG0wQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183528; c=relaxed/simple;
	bh=hDVWWEqdrziYLZbomuM8rcTjqb4po1Wbb+L2oGl9z/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mw34QJcH2i0XEo+vgz456hs7wWnM/sbPwfzhRhOsV/XXTEJK61ppW6Vjjcq6McIfWJQ3506sW+ef+CZIaoccY9vcLAfH80sh5thb3RDijAlewKIMyyQ6Uzvx62U2su/BYy4CET5TzVjN05+lzVaTJR8AyPh2oEQ/p6gp0TzeW5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdr8C5gx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdr8C5gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252C11F00ACA;
	Mon, 31 Aug 2026 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183526;
	bh=crpun+QCBVEcyB2Pgb0Ue25kuVuSVt9lQ+ZQUwR0CWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdr8C5gxnIoIkZ9LsuYuJiSnsbzY67hcgF80AguVqYnOgwK5bjiqng7h0prP1BcGQ
	 RSb8tFk3L9e8qJwSmizkB2QXthIR8PuFIbNj1aqh4dQMN7+br4xqxrMZwPlxE+0HCO
	 R9bTPN6COd4zoOTg7xV45NKXBT2SSnv0L9JCGQ6QCWZvEdmj6hInL9ETMH+CIrFt0U
	 9ybmQUbTvpO5qFet9FJcX6CHiAlFM+cB57DfH87GqxBrQz6O56RhPBwJ57V5/2VkI3
	 Ss/AwtF3dXHULLkB9b52wC3NVoJyxCPxp9VII/nLUfbVfvpIzHVwHv1UUN8Gt0/V3p
	 IK7khGgz6fIDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Osama Abdelkader <osama.abdelkader@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] mmc: davinci: fix mmc_add_host order in probe
Date: Mon, 31 Aug 2026 09:22:57 -0400
Message-ID: <20260831133314.4125787-149-sashal@kernel.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit d04e0151d316edbdb4f0397a9b92a1936e4a1421 ]

mmc_add_host() makes the host visible to the MMC core. Register the
interrupt handlers and advertise MMC_CAP_SDIO_IRQ before that, so the
core cannot start using the host before IRQ handling is set up.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `mmc: davinci: fix mmc_add_host order in
probe`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

**Commit under review:** `d04e0151d316e` (exists in repo on `all-next`
etc., **not** an ancestor of this tree’s HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[mmc: davinci]` `[fix]` — correct probe initialization
order so IRQ handlers and SDIO capability are ready before
`mmc_add_host()`.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none in commit message
- **Cc: stable@vger.kernel.org** — none (expected for manual review)
- **Signed-off-by:** Osama Abdelkader `<osama.abdelkader@gmail.com>`
  (author)
- **Signed-off-by:** Ulf Hansson `<ulfh@kernel.org>` (MMC maintainer
  merge)

Notable: maintainer Signed-off-by; no syzbot/user bug report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `mmc_add_host()` exposes the host to the MMC core before IRQ
  handlers are registered and before `MMC_CAP_SDIO_IRQ` is advertised.
- **Symptom:** MMC core may start card detection / I/O while interrupts
  are not handled → requests can hang or SDIO IRQ support is mis-
  advertised.
- **Root cause:** Wrong probe ordering; `mmc_add_host()` should be last
  among setup steps that the core depends on.
- **Version info:** none in message.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit probe-order bug fix, not disguised
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/mmc/host/davinci_mmc.c` (+5 / −7 lines)
- **Function:** `davinci_mmcsd_probe()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow per hunk
**Record:**
1. **Remove early `mmc_add_host()`** — before: host registered with core
   immediately after cpufreq setup → after: deferred until IRQ setup
   completes.
2. **IRQ failure path** — before: `goto request_irq_fail` →
   `mmc_remove_host()` → after: `goto mmc_add_host_fail` (host was never
   added).
3. **Move `mmc_add_host()` after IRQ registration** — SDIO IRQ handler
   registered and `MMC_CAP_SDIO_IRQ` set first, then host registered.
4. **Remove `request_irq_fail` label** — no longer needed since
   `mmc_add_host()` hasn’t run yet.

### Step 2.3: Bug mechanism
**Record:** **Race condition / initialization ordering bug**
- `mmc_add_host()` → `mmc_start_host()` → `_mmc_detect_change(host, 0,
  false)` schedules card-detection work immediately.
- Before fix: detection can issue `mmc_davinci_request()` while
  `devm_request_irq()` for `mmc_davinci_irq` is not yet registered.
- Command completion depends on `mmc_davinci_irq()` (interrupt-driven;
  `mmc_davinci_start_command()` enables `DAVINCI_MMCIM` interrupt mask).
- SDIO: `MMC_CAP_SDIO_IRQ` was set after `mmc_add_host()`, so core could
  probe SDIO before capability was advertised.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** matches established MMC driver pattern
  (`sdhci.c`, `omap_hsmmc.c`, and prior fixes like `mmc: uniphier-sd:
  register irqs before registering controller`).
- **Minimal:** pure reorder + simplified error path.
- **Regression risk:** very low; only changes probe ordering and removes
  unnecessary `mmc_remove_host()` on IRQ failure.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy order introduced in **2009** (`b4cff4549b7a8c`, Vipin
Bhandari). `mmc_add_host()` before `devm_request_irq()` has been wrong
since initial davinci driver integration. `PROBE_PREFER_ASYNCHRONOUS`
added in `21b2cec61c04b` (2020), increasing realistic race window with
async detect work.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Same class of fix already in tree history:
- `a5d8de1cb7e1d` — `mmc: uniphier-sd: register irqs before registering
  controller`
- `74f45de394d97` — `mmc: renesas_sdhi: register irqs before registering
  controller`

Standalone one-patch fix; not part of a series.

### Step 3.4: Author context
**Record:** Osama Abdelkader is an active contributor (e.g. Panthor DRM
fixes) but not davinci maintainer. Fix merged by Ulf Hansson (MMC
subsystem maintainer).

### Step 3.5: Dependencies
**Record:** No prerequisites. Self-contained reorder in existing probe
function. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://lkml.iu.edu/hypermail/linux/kernel/2605.1/03199.html
- **Revisions:** single patch (no v2/v3 found)
- **Maintainer response:** Ulf Hansson — “Applied for next, thanks!”
  (https://lists.openwall.net/linux-kernel/2026/05/29/1414)
- **Stable nomination:** none in thread
- **NAKs/concerns:** none found

### Step 4.2: Reviewers
**Record:** CC’d to `linux-mmc@`, `linux-kernel@`, Ulf Hansson, and
other maintainers. Accepted by subsystem maintainer without objections.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or stack trace. Bug
identified by code inspection / correct driver pattern.

### Step 4.4: Related patches
**Record:** Precedent patches in same subsystem (uniphier-sd,
renesas_sdhi) for identical IRQ-before-`mmc_add_host` ordering.

### Step 4.5: Stable list
**Record:** No stable-list discussion found (lore.kernel.org blocked by
bot protection for direct search; patch thread has no stable Cc).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `davinci_mmcsd_probe()`, `mmc_add_host()`,
`mmc_start_host()`, `_mmc_detect_change()`, `mmc_davinci_irq()`,
`mmc_davinci_request()`, `mmc_davinci_start_command()`

### Step 5.2: Callers
**Record:**
- `davinci_mmcsd_probe()` — platform driver probe during boot / module
  load on `ARCH_DAVINCI` boards.
- `mmc_add_host()` → `mmc_start_host()` → card detection workqueue.
- `mmc_davinci_request()` — MMC core callback during card init and I/O.

### Step 5.3: Callees
**Record:** `mmc_add_host()` calls `device_add()`, `mmc_start_host()`;
probe uses `devm_request_irq()`, `mmc_davinci_cpufreq_register()`.

### Step 5.4: Reachability
**Record:**
- Triggered on every DaVinci MMC controller probe with a card present
  (or during rescan).
- Card detection is scheduled from `mmc_start_host()` with **zero
  delay** (`_mmc_detect_change(host, 0, false)`).
- Requests issued before IRQ registration can hang waiting for
  interrupts that have no handler.
- **Userspace reachability:** indirect via boot-time device enumeration;
  can cause hung boot / unresponsive MMC block device.

### Step 5.5: Similar patterns
**Record:** `sdhci.c` (request IRQ at ~4883, `mmc_add_host` at ~4898),
`omap_hsmmc.c` (IRQ + `MMC_CAP_SDIO_IRQ` before `mmc_add_host` at
~1944). Davinci was the outlier.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current `drivers/mmc/host/davinci_mmc.c` at lines
1297–1312 still has `mmc_add_host()` before `devm_request_irq()`. Fix
commit `d04e0151d316e` is **not** in HEAD (`git merge-base --is-
ancestor` → NOT ancestor).

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Probe structure matches the patch
context; no conflicting recent churn in that hunk. `request_irq_fail` /
`mmc_remove_host` path still present and removable as in the patch.

### Step 6.3: Related fixes already present?
**Record:** uniphier-sd and renesas_sdhi IRQ-ordering fixes are in tree;
davinci-specific fix is **not**.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **PERIPHERAL** — `CONFIG_MMC_DAVINCI` (`ARCH_DAVINCI ||
COMPILE_TEST`). TI DaVinci embedded platforms (e.g. DM644x, OMAP-L138
class). Small user base but real production embedded deployments.

### Step 7.2: Subsystem activity
**Record:** davinci driver receives periodic maintenance (PM macros,
devm helpers, bus-width reporting in 2024–2025) but is mature/legacy.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users building kernels with `CONFIG_MMC_DAVINCI=y/m` on
DaVinci hardware. Not universal; driver-specific.

### Step 8.2: Trigger conditions
**Record:**
- Boot or module load with MMC/SD/SDIO media present.
- Race between `mmc_start_host()` detect work and remaining probe steps.
- More likely since `PROBE_PREFER_ASYNCHRONOUS` (2020).
- Unprivileged users cannot directly trigger; impact is at
  boot/enumeration.

### Step 8.3: Failure mode severity
**Record:**
- **Hung MMC requests** / boot stall during card detection → **HIGH**
  for affected hardware.
- **SDIO IRQ not advertised** → SDIO Wi‑Fi/BT modules may fail →
  **HIGH** for SDIO users.
- Not a typical security issue; no data-corruption mechanism identified,
  but boot hang is a serious stability issue.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents probe-time hangs and SDIO capability mis-
  registration on DaVinci boards; aligns with maintainer-accepted
  pattern used in sibling drivers.
- **Risk:** Very low — 12-line reorder, no API changes, simpler error
  path.
- **Ratio:** Favorable for backport despite narrow hardware scope.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real initialization race with concrete mechanism (`mmc_start_host` →
  immediate detect work).
- IRQ-dependent request completion in `mmc_davinci_irq()`.
- SDIO capability must be set before host registration.
- Identical fixes already accepted in MMC subsystem (uniphier-sd,
  renesas_sdhi).
- Matches omap_hsmmc/sdhci canonical ordering.
- Tiny, obviously correct, maintainer-merged.
- Bug present in 6.18.44; fix not yet applied.

**AGAINST backport:**
- Very small user population (`ARCH_DAVINCI` only).
- No user bug report or syzbot reproduction.
- Theoretical race existed since 2009 (may have been rare on synchronous
  probe).

**Unresolved:** No field crash log confirming reproduction on specific
DaVinci board (not required for this class of fix).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — pattern proven in other MMC
   drivers; maintainer merged.
2. Fixes a real bug? **PASS** — probe ordering race verified in code.
3. Important issue? **PASS** — boot hang / MMC timeout on affected
   hardware (HIGH for those users).
4. Small and contained? **PASS** — 1 file, 12 lines.
5. No new features/APIs? **PASS** — reorder only.
6. Can apply to local tree? **PASS** — buggy code present; patch should
   apply cleanly.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
driver probe-order bug fix.

### Step 9.4: Decision rationale
For **Linux 6.18.44**, this commit fixes a verified probe race in an
existing driver where the buggy code is present and the fix is absent.
While the hardware audience is narrow, boot-time hangs on embedded
systems are exactly the sort of contained, low-risk driver fixes stable
trees routinely take—especially when the MMC maintainer has already
accepted the same pattern for other host drivers. The patch is minimal,
follows established subsystem practice, and introduces negligible
regression risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message.
- **[Phase 1]** Confirmed no Reported-by/Tested-by/Fixes/Link tags.
- **[Phase 2]** Diff analysis: reorder `mmc_add_host()` after IRQ setup;
  remove `request_irq_fail` path.
- **[Phase 2]** Read `mmc_add_host()` in
  `drivers/mmc/core/host.c:644-661` — calls `mmc_start_host()`.
- **[Phase 2]** Read `mmc_start_host()` / `_mmc_detect_change()` in
  `drivers/mmc/core/core.c:2338-2353,1441-1452` — schedules detect work
  with delay 0.
- **[Phase 2]** Read `davinci_mmcsd_probe()` buggy ordering at
  `davinci_mmc.c:1297-1328`.
- **[Phase 2]** Read `mmc_davinci_irq()` and `mmc_davinci_request()` —
  IRQ-driven completion path.
- **[Phase 3]** `git blame -L 1290,1330 drivers/mmc/host/davinci_mmc.c`
  — buggy order since 2009.
- **[Phase 3]** `git show 21b2cec61c04b` — `PROBE_PREFER_ASYNCHRONOUS`
  on davinci since 2020.
- **[Phase 3]** `git log --oneline` — found precedent commits
  `a5d8de1cb7e1d`, `74f45de394d97`.
- **[Phase 3]** `git show a5d8de1cb7e1d` — confirmed identical rationale
  for uniphier-sd.
- **[Phase 4]** WebFetch lkml.iu.edu patch submission — original patch
  found.
- **[Phase 4]** WebFetch lists.openwall.net — Ulf Hansson “Applied for
  next, thanks!”
- **[Phase 4]** `b4 dig -c HEAD` — failed (commit not in HEAD); `b4 dig
  -l` — unsupported syntax.
- **[Phase 5]** Compared `omap_hsmmc.c:1916-1946` and
  `sdhci.c:4883-4898` — IRQ before `mmc_add_host`.
- **[Phase 5]** Read `Kconfig` `CONFIG_MMC_DAVINCI` — `ARCH_DAVINCI ||
  COMPILE_TEST`.
- **[Phase 6]** `git describe HEAD` → `v6.18.44`.
- **[Phase 6]** `git merge-base --is-ancestor d04e0151d316e HEAD` → fix
  **NOT** in tree.
- **[Phase 6]** Grep confirmed buggy probe order still present in
  checked-out tree.
- **[Phase 6]** `git show d04e0151d316e` — verified commit exists and
  matches provided diff.
- **[Phase 7]** `git log --oneline -20 --
  drivers/mmc/host/davinci_mmc.c` — driver actively maintained.
- **[Phase 8]** Assessed impact limited to `ARCH_DAVINCI` with boot-time
  hang severity for those users.

**YES**

 drivers/mmc/host/davinci_mmc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 00adc15956fd2..3d0d05ab1fe48 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1294,14 +1294,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 		goto cpu_freq_fail;
 	}
 
-	ret = mmc_add_host(mmc);
-	if (ret < 0)
-		goto mmc_add_host_fail;
-
 	ret = devm_request_irq(&pdev->dev, irq, mmc_davinci_irq, 0,
 			       mmc_hostname(mmc), host);
 	if (ret)
-		goto request_irq_fail;
+		goto mmc_add_host_fail;
 
 	if (host->sdio_irq >= 0) {
 		ret = devm_request_irq(&pdev->dev, host->sdio_irq,
@@ -1311,6 +1307,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 			mmc->caps |= MMC_CAP_SDIO_IRQ;
 	}
 
+	ret = mmc_add_host(mmc);
+	if (ret < 0)
+		goto mmc_add_host_fail;
+
 	rename_region(mem, mmc_hostname(mmc));
 
 	if (mmc->caps & MMC_CAP_8_BIT_DATA)
@@ -1324,8 +1324,6 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 
 	return 0;
 
-request_irq_fail:
-	mmc_remove_host(mmc);
 mmc_add_host_fail:
 	mmc_davinci_cpufreq_deregister(host);
 cpu_freq_fail:
-- 
2.53.0

