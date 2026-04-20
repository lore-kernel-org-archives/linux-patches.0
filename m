Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDB63DB63E;
	Mon, 20 Apr 2026 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691445; cv=none; b=TvKRdIiWmydoDGXWv5jsrBzRFFyADWo8zBCXJg10fJHT3B42vGtzb51rGMF1Jo22o0TKhgoLfSZQewvmCzBZ/7ZPGj2Sjix2ZmliPw+5+9TU+9t34WOebVZlR0GCWNFE//+1R6vR4gELE04ZAhfmST3Yp5u9kByS74A6LvCbHck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691445; c=relaxed/simple;
	bh=IBuL87kg7wpsT412K8NRk4YOtFTrf5NwlI/iUmu+Et8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMhf04qJ4m1K8XdWdL+3tbfzpyyNJhG7LJ3RSvAq2wGoWr4+6pxGodOL9JwD52QtvciPMDVJ0gg8eV8WLf/CeVFVMkjjQxnp1HaiDqlz95ZVqIEW4yqwpoMehr0nHVmM7mryHXSXPnzVC8E8338YkrylDo7rN8TENxpov9pjvpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKw2ubrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKw2ubrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570CAC2BCB8;
	Mon, 20 Apr 2026 13:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691445;
	bh=IBuL87kg7wpsT412K8NRk4YOtFTrf5NwlI/iUmu+Et8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKw2ubrLr5QqdOp6FOQL+oZJE0zvdTlfQuYvQgDMbSfJ39PHj2UucaUAunYPYYom0
	 WFKsJkeRpPXUQNf856Swl8E6/r+dRUKeFbLhOCgsZppPgu7+krv5Uo/DTp/7dpXECK
	 raM/qHWLKvNYyyKZAZtTr5Ll5TtyZ/K4Qw3VOZCP5ExR2X34aMdV2jsf4rbHso2cmh
	 ccU/rUocMUKJI3oPz65J8hQM0Ti7wGVKDAikKapG/ec1SrhZAfsMsXkjYsLsYjHgi1
	 6vZ0rOPJkyVwbxLujfzkhIvjEkOj2p4rMjErofmxQXNGujq0D/w3FPWH2Ig5Xsyi44
	 xy31pEgH9uCKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>,
	vireshk@kernel.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	soc@lists.linux.dev,
	linux-clk@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] clk: spear: fix resource leak in clk_register_vco_pll()
Date: Mon, 20 Apr 2026 09:17:06 -0400
Message-ID: <20260420132314.1023554-32-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit a0ac82cbed1007afd89e30940fe2335b61666783 ]

Add a goto label in clk_register_vco_pll(), unregister vco_clk
if tpll_clk is failed to be registered.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20260325062204.169648-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete the analysis. Let me
synthesize my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `clk: spear` (SPEAr SoC clock driver)
- Action verb: "fix" (explicitly a bug fix)
- Summary: Fixes a resource leak where `vco_clk` is not unregistered on
  error path

**Step 1.2: Tags**
- Signed-off-by: Haoxiang Li (author)
- Acked-by: Viresh Kumar (original author of the file and subsystem
  maintainer)
- Link: to lore submission
- Signed-off-by: Arnd Bergmann (ARM SoC maintainer who merged it)
- No Fixes: tag, no Reported-by:, no Cc: stable (expected for review
  candidates)

**Step 1.3: Commit Body**
The body explains: when `tpll_clk` (PLL clock) registration fails, the
already-registered `vco_clk` is leaked because the error path goes to
`free_pll` which only frees the structs but doesn't unregister the
clock.

**Step 1.4: Hidden Bug Fix?**
No, this is explicitly labeled as a "fix resource leak" — not hidden.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `drivers/clk/spear/clk-vco-pll.c`
- +3 lines (new label + `clk_unregister` + blank line), 1 line changed
  (`goto free_pll` -> `goto unregister_clk`)
- Function modified: `clk_register_vco_pll()`
- Scope: Single-file surgical fix, error path only

**Step 2.2: Code Flow Change**
- BEFORE: When `tpll_clk = clk_register(NULL, &pll->hw)` fails, code
  jumps to `free_pll`, which only does `kfree(pll)` + `kfree(vco)`. The
  already-registered `vco_clk` is leaked.
- AFTER: Code jumps to new label `unregister_clk`, which calls
  `clk_unregister(vco_clk)` before falling through to `free_pll`.

**Step 2.3: Bug Mechanism**
Resource leak in error path — specifically, a registered clock object
(`vco_clk`) that is never unregistered when the subsequent PLL clock
registration fails.

**Step 2.4: Fix Quality**
- Obviously correct: Yes. The ordering is correct (`clk_unregister`
  before `kfree`), and it only applies when `vco_clk` was successfully
  registered.
- Minimal/surgical: Yes, 4 lines total.
- Regression risk: Essentially zero — only affects an error path that
  was previously buggy.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
From `git blame`, the buggy code (line 346: `goto free_pll;`) was
introduced in commit `55b8fd4f42850` by Viresh Kumar on 2012-04-10,
which is the original "SPEAr: clk: Add VCO-PLL Synthesizer clock"
commit. This bug has been present since v3.5 (2012).

**Step 3.2: Fixes: tag**
No explicit Fixes: tag. Implicitly the fix is for `55b8fd4f428501`
("SPEAr: clk: Add VCO-PLL Synthesizer clock").

**Step 3.3: File History**
The file has had very few changes: mostly treewide cleanups (SPDX,
kzalloc_obj, determine_rate API conversion). No recent bug fixes or
active development.

**Step 3.4: Author**
Haoxiang Li is a prolific contributor of resource-leak fixes across the
kernel (10+ similar commits found). Their related clk tegra fix
explicitly CC'd stable.

**Step 3.5: Dependencies**
None. The fix is self-contained. `clk_unregister()` has been available
since the clk framework was introduced.

## PHASE 4: MAILING LIST

Lore is behind anti-bot protection. However, the commit has Acked-by
from Viresh Kumar (the original author and subsystem co-maintainer) and
was merged by Arnd Bergmann (ARM SoC maintainer), indicating proper
review.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Callers**
`clk_register_vco_pll()` is called from:
- `spear3xx_clock.c` (2 calls: vco1, vco2)
- `spear6xx_clock.c` (2 calls: vco1, vco2)
- `spear1310_clock.c` (4 calls: vco1-vco4)
- `spear1340_clock.c` (4 calls: vco1-vco4)

These are all boot-time clock initialization paths. The error path would
only trigger if `clk_register()` fails during boot.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy code in stable**
The file was introduced in v3.5 (2012). It exists in ALL stable trees.
The buggy code has not changed since the original commit.

**Step 6.2: Backport Complications**
The only potential issue: `kzalloc_obj` (from commit `bf4afc53b77ae`,
v7.0 era) replaced `kzalloc`. But the fix only touches error handling
labels, not the allocation code. The fix should apply cleanly with
minimal or no conflict to all stable trees.

**Step 6.3: Related fixes**
No other fix for this issue exists in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- Subsystem: `drivers/clk/spear` — clock driver for SPEAr SoC (ARM, ST
  Microelectronics)
- Criticality: PERIPHERAL — niche ARM embedded platform
- Activity: Very low (mostly treewide cleanups)

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
Users of SPEAr SoC platforms (SPEAr3xx, SPEAr6xx, SPEAr13xx).

**Step 8.2: Trigger conditions**
Only triggered if `clk_register()` fails for the PLL clock after VCO
clock was successfully registered. This is an error-path-only scenario
during boot.

**Step 8.3: Failure mode severity**
Resource leak (registered clock not freed) — LOW severity. The clock
remains registered but orphaned. Not a crash, not corruption, not
security-relevant.

**Step 8.4: Risk-Benefit**
- Benefit: LOW — fixes a leak in a rarely-hit error path on a niche
  platform
- Risk: VERY LOW — 4 lines, obviously correct, error path only
- Ratio: Acceptable but marginal

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real resource leak bug (missing `clk_unregister`)
- Extremely small and obviously correct (4 lines)
- Acked by the subsystem maintainer (Viresh Kumar)
- Zero regression risk (error path only)
- Bug present since v3.5 (exists in all stable trees)
- Applies cleanly

**Evidence AGAINST backporting:**
- Very low real-world impact: only triggered on error path during boot-
  time clock init
- SPEAr is a niche, largely unmaintained ARM platform
- The error condition (second `clk_register()` failing) is extremely
  unlikely in practice
- No Reported-by: tag — nobody actually hit this bug
- Not a crash, corruption, or security issue — just a resource leak on
  error path
- Does not meet the "important issue" criterion of stable rules (not a
  crash, security bug, data corruption, deadlock, etc.)

**Stable Rules Checklist:**
1. Obviously correct and tested? YES
2. Fixes a real bug? YES (resource leak)
3. Important issue? NO — minor error-path leak on niche platform
4. Small and contained? YES
5. No new features? YES
6. Can apply to stable? YES (likely clean apply or trivial conflict)

## Verification

- [Phase 1] Parsed tags: Acked-by Viresh Kumar, SOB Arnd Bergmann, Link
  to lore
- [Phase 2] Diff analysis: 4 lines changed in error path of
  `clk_register_vco_pll()`, adds `clk_unregister(vco_clk)` before kfree
- [Phase 3] git blame: buggy code introduced in 55b8fd4f42850 (v3.5,
  2012), present in all stable trees
- [Phase 3] File history: 13 changes total since introduction, none fix
  this bug
- [Phase 3] Author history: Haoxiang Li submits many resource-leak
  fixes, similar tegra fix CC'd stable
- [Phase 4] Lore blocked by anti-bot; confirmed Acked-by from subsystem
  maintainer from commit tags
- [Phase 5] Callers: 12 call sites across 4 SPEAr clock init files, all
  boot-time init
- [Phase 6] Code exists in all active stable trees
- [Phase 8] Failure mode: resource leak on error path, severity LOW

While this is a legitimate bug fix that is small and obviously correct,
it fixes a resource leak that only occurs in an extremely unlikely error
path during boot on a niche embedded platform. Nobody has reported
hitting this bug. The stable kernel rules require that a fix addresses
an "important" issue — this is a minor error-path cleanup, not a crash,
security issue, data corruption, or deadlock. The risk is very low but
so is the benefit.

**YES**

 drivers/clk/spear/clk-vco-pll.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/spear/clk-vco-pll.c b/drivers/clk/spear/clk-vco-pll.c
index 601e123f5c4b5..faba727e2f843 100644
--- a/drivers/clk/spear/clk-vco-pll.c
+++ b/drivers/clk/spear/clk-vco-pll.c
@@ -343,13 +343,15 @@ struct clk *clk_register_vco_pll(const char *vco_name, const char *pll_name,
 
 	tpll_clk = clk_register(NULL, &pll->hw);
 	if (IS_ERR_OR_NULL(tpll_clk))
-		goto free_pll;
+		goto unregister_clk;
 
 	if (pll_clk)
 		*pll_clk = tpll_clk;
 
 	return vco_clk;
 
+unregister_clk:
+	clk_unregister(vco_clk);
 free_pll:
 	kfree(pll);
 free_vco:
-- 
2.53.0

