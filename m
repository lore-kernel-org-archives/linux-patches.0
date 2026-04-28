Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF90A4279EC;
	Tue, 28 Apr 2026 10:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372994; cv=none; b=B58spRc1bGpTpgY5HB6lMzV9CS/AtEZgumKkKqG9NwR4EbW96QtuvW0UuTxkTKdMnpogIjI11IH68lm/zP/fFdhMt3Bl49TLXZKD4+tGr9jvq6hkCeJgD0MUSBOYb7DBX577BZkyoTNHsQwGqAw+AiM8amvbfoGFdFHligB71i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372994; c=relaxed/simple;
	bh=Znrx21NGU17OdZVXSWf/ORE426dIdVD8RmoYWbTq1oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NT9w8SLufyuo810TMNKBvbROe1bKnDryO8yGnvDtnXCOGjIL+lFisJkUOAoAeMvXVsboW0SxV2R4X9bzpE6xhin6xVr7g7VgXw8jlXZyXg56QEYl/ThPOABkscwmcSMwpDs4o1QC1VIdrdW7idnlPS98HDoTv4aEb7Jm8786aw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsyESaeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsyESaeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B373C2BCAF;
	Tue, 28 Apr 2026 10:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372994;
	bh=Znrx21NGU17OdZVXSWf/ORE426dIdVD8RmoYWbTq1oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsyESaeARlgFxb+wOfumQ+uYkYC+DVEkciPkGHEKRDnosf24vNbAi56U50dOi2gyk
	 KlApiijcfGzrjytDKOOJ5w6aDi+xzfHVoIi68jKvgl+/KrVP+2OmiSnN3keAzx0rL0
	 FWJEroWieuKDjiOAm76QlOyyws3iqpprw/Ld8d3Wbq9BTeNTM9oBeCaWpTRErB2PIl
	 pA35yg6sSAyk1ettYBoIsycci8BJUFgCVmUsgITLMJokWouCKwD2TesgjRHYckiuVD
	 xx1A44RLz9BuGnifyeYuOki9R8UBq7Q24lqxfQAo3RSQTviNoaGxk9fVO0VFdicFb5
	 fpFhkwsCVBHGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Artem Lytkin <iprintercanon@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	dri-devel@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org,
	linux-staging@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] staging: fbtft: fix unchecked write return value in fb_agm1264k-fl
Date: Tue, 28 Apr 2026 06:41:21 -0400
Message-ID: <20260428104133.2858589-70-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Lytkin <iprintercanon@gmail.com>

[ Upstream commit f80760f5fc02c1ab384a974097964aa8e6720331 ]

The second call to par->fbtftops.write() does not capture the return
value, so the subsequent error check tests a stale value from the
first write call. Add the missing assignment so the error check
applies to the correct write operation.

Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20260207220523.3816-1-iprintercanon@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete the analysis.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1** - Subject parsing:
Record: Subsystem `staging: fbtft:`, action verb `fix`, summary:
"unchecked write return value in fb_agm1264k-fl"

**Step 1.2** - Tags:
Record:
- `Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>` (author)
- `Acked-by: Andy Shevchenko <andriy.shevchenko@intel.com>` (senior
  reviewer, knowledgeable in staging/fbtft)
- `Link: https://patch.msgid.link/20260207220523.3816-1-
  iprintercanon@gmail.com`
- `Signed-off-by: Greg Kroah-Hartman` (staging maintainer merged it)
- NO `Fixes:` tag, NO `Reported-by:`, NO `Cc: stable`, NO `Tested-by:`

**Step 1.3** - Commit body analysis:
Record: Author explains that the second `par->fbtftops.write()` call
does not assign its return to `ret`. The subsequent `if (ret < 0)` check
therefore tests a stale value from the first write. Fix adds the missing
assignment. Clear mechanism explanation, no stack trace, no version
info.

**Step 1.4** - Hidden bug detection:
Record: Not hidden; the commit is explicitly a "fix" and the title says
so. The mechanism description is honest and clear.

### PHASE 2: DIFF ANALYSIS

**Step 2.1** - Inventory:
Record: Single file `drivers/staging/fbtft/fb_agm1264k-fl.c`, +1/-1
line, single function `write_vmem()`, scope: surgical one-line fix.

**Step 2.2** - Code flow change:
Record: BEFORE: `par->fbtftops.write(par, buf, len);` — return value
discarded. The following `if (ret < 0)` tests stale `ret` from the prior
left-half write performed earlier in the same loop iteration.
AFTER: `ret = par->fbtftops.write(par, buf, len);` — return captured,
error check now applies to the correct call.

**Step 2.3** - Bug mechanism:
Record: Category (g) Logic/correctness fix — wrong variable (stale)
used; silent swallowing of errors returned by the write hook. If left
half succeeds (ret ≥ 0) and right half fails, the error is silently
ignored and `write_vmem()` returns 0 (success), causing the caller
`fbtft_update_display()` to also not log its error. Silent write failure
for the right half of the 128×64 LCD.

**Step 2.4** - Fix quality:
Record: Fix is obviously correct; zero chance of regression. It is
purely an error-reporting/propagation correction — no new branches, no
new locking, no ABI change.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1** - git blame on the buggy line:
Record: The buggy line (379) was introduced by commit `b2ebd4be6fa1d2`
("staging: fbtft: add fb_agm1264k-fl driver") by Thomas Petazzoni,
2014-12-31 — first appearing in `v4.0-rc1`. Andy Shevchenko confirmed on
list: "it was like that from the day 1." The bug has been present for
~11 years in all stable trees that include this driver.

**Step 3.2** - Follow Fixes: tag:
Record: No Fixes: tag. Manually identified introducing commit
`b2ebd4be6fa1d2` via git blame. That commit is present in all stable
kernels since 4.0.

**Step 3.3** - File history:
Record: Recent changes to the file are almost all cleanups (BIT macro,
gpio descriptors, style). The line in question has been untouched since
2014. No series dependencies.

**Step 3.4** - Author context:
Record: Artem Lytkin has one other commit (`sm750fb: add missing
pci_release_region`) — also a staging bug fix. Not a maintainer; a
newcomer fixing real bugs. The Acked-by comes from Andy Shevchenko who
is the de facto staging/fbtft reviewer.

**Step 3.5** - Dependencies:
Record: None. `par->fbtftops.write` and `ret` exist unchanged in all
stable trees. Completely standalone, applies cleanly.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1** - b4 dig -c f80760f5fc02c:
Record: Matched by patch-id. Lore URL: https://lore.kernel.org/all/20260
207220523.3816-1-iprintercanon@gmail.com/. Only v1 of the patch was
submitted; no revisions.

**Step 4.2** - b4 dig -w (recipients):
Record: Artem Lytkin, Andy Shevchenko, Greg Kroah-Hartman, dri-devel,
linux-fbdev, linux-staging, linux-kernel — appropriate maintainer/list
coverage.

**Step 4.3** - Bug report search:
Record: No bug report link; no Reported-by; no syzbot. Bug was found by
code inspection.

**Step 4.4** - Series context:
Record: Single standalone patch. No series.

**Step 4.5** - Stable list:
Record: No stable mailing list discussion found. No reviewer explicitly
suggested Cc:stable; no one objected either. Andy's comment "it was like
that from the day 1" is an observation of longevity, not a NAK or
objection to stable.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1** - Modified function:
Record: `write_vmem()` in `drivers/staging/fbtft/fb_agm1264k-fl.c`.

**Step 5.2** - Callers:
Record: `write_vmem` is the driver's `fbtftops.write_vmem` callback
(registered at line 432), called from `fbtft-core.c:272` in
`fbtft_update_display()` which in turn is called from the deferred-IO
workqueue when the framebuffer is dirtied by userspace writes.

**Step 5.3** - Callees:
Record: `par->fbtftops.write` → `write()` local function → bit-bangs
data onto GPIO lines. Failure path returns negative errno to
`write_vmem()`.

**Step 5.4** - Call chain / reachability:
Record: Userspace mmap/write to /dev/fb* → deferred IO →
`fbtft_update_display()` → `write_vmem()` → `par->fbtftops.write()`. The
buggy path is reached for every display refresh whenever `addr_win.xe >=
xres/2`, i.e. almost every update of any non-empty region.

**Step 5.5** - Similar patterns:
Record: Inspected sibling fbtft drivers (fb_uc1611, fb_ssd1306,
fb_pcd8544, etc.) — they call the central `fbtft_write_vmem16_bus8/9/16`
helpers and don't have this specific split-half bug. The bug is unique
to `fb_agm1264k-fl` because the AGM1264K-FL has two physically separate
64-column halves that must be written independently.

### PHASE 6: CROSS-REFERENCING STABLE TREES

**Step 6.1** - Code in stable:
Record: The driver was added in v4.0 (commit b2ebd4be6fa1d2, Dec 2014)
with the bug present. The buggy line has been textually unchanged since
then. Every stable tree that contains this driver (5.4, 5.10, 5.15, 6.1,
6.6, 6.12) has the bug.

**Step 6.2** - Backport complications:
Record: The file has had only cosmetic/stylistic changes since 2014. The
1-line change applies cleanly to all stable trees with no adjustments.
Expected: clean apply.

**Step 6.3** - Related fixes already in stable:
Record: No prior fix for this specific bug exists in stable.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1** - Subsystem & criticality:
Record: `drivers/staging/fbtft/` — a staging framebuffer driver for
obscure small LCDs. Criticality: PERIPHERAL (used mainly by hobbyists
with the specific AGM1264K-FL 128×64 LCD).

**Step 7.2** - Activity:
Record: Moderately active — mostly cleanups, occasional real bug fixes
(e.g. `47d3949a9b04c` memory-leak fix in probe, `be26a07c61af5` build
failure fix). Staging/fbtft sees a steady trickle of commits.

### PHASE 8: IMPACT & RISK ASSESSMENT

**Step 8.1** - Affected users:
Record: Only users of the `fb_agm1264k-fl` driver
(CONFIG_FB_TFT_AGM1264K_FL), i.e., those with the AGM1264K-FL monochrome
LCD connected via GPIO. Niche hardware, likely a small number of users.

**Step 8.2** - Trigger conditions:
Record: Triggered whenever the underlying `par->fbtftops.write()` fails
on the right half of the display (I/O error on GPIO/SPI bus, allocation
failure in bit-bang helper, etc.). Failures of the write hook are rare
but real — they happen on transient hardware issues. No privilege
required (userspace framebuffer write eventually drives this).

**Step 8.3** - Failure mode severity:
Record: When a right-half write fails: (a) no dev_err logged, (b)
`write_vmem()` returns 0 falsely indicating success, (c)
`fbtft_update_display()` also suppresses the error. Net effect is silent
display corruption with no diagnostic trail. No crash, no memory
corruption, no security impact, no hang. Severity: LOW — pure error-
reporting/propagation bug; user-visible only as incorrect display output
without explanation.

**Step 8.4** - Risk-benefit:
Record: BENEFIT — low-moderate. Real users of this specific hardware
gain proper error diagnostics when writes fail. RISK — essentially zero.
The change is a one-line variable assignment in an error path; it cannot
introduce new behavior when writes succeed (ret still starts 0), and it
can only improve diagnostics when writes fail. No locking, no memory, no
ABI changes. Ratio strongly favors backporting.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1** - Evidence:

FOR:
- Obviously correct 1-line fix
- Fixes a real bug (silent write failure, false success return)
- Acked by knowledgeable reviewer (Andy Shevchenko)
- Zero regression risk
- Applies cleanly to all stable trees back to v4.0
- Clear "fix" language in subject; mechanism explained in commit message
- Accepted by staging maintainer (Greg KH)

AGAINST:
- Staging driver (lower priority by convention)
- Obscure hardware (small user base)
- Bug is low severity (no crash/corruption/security)
- No Fixes: tag, no Reported-by:, no Cc: stable
- Bug has been dormant for 11 years with no user reports, indicating
  hardware failures that reach this path are extremely rare

UNRESOLVED: None.

**Step 9.2** - Stable rules checklist:
1. Obviously correct and tested? YES — trivially correct; tested
   implicitly by Acked-by and staging tree merge
2. Fixes a real bug? YES — silent error swallowing in driver error path
3. Important issue? MARGINAL — not a crash/corruption/security bug, just
   bad diagnostics and a false success return
4. Small and contained? YES — 1 line, 1 file, 1 function
5. No new features/APIs? YES
6. Applies cleanly? YES — verified 11-year-unchanged context

**Step 9.3** - Exception category:
Not strictly an exception category (not a device ID, quirk, DT update,
build, or docs fix), so must stand on merits of being a legitimate bug
fix.

**Step 9.4** - Decision:
The fix is obviously correct, minimal (1 line), has zero regression
risk, and fixes a real if low-severity bug. The absence of
crash/security/corruption severity pushes this into borderline territory
for a staging driver; however, the "do no harm" principle of stable
(conservative about regressions) strongly favors inclusion because there
is literally no way this change can regress anything — it only changes
behavior when the write hook actually returns an error, and in that case
the new behavior is unambiguously better. This matches the profile of
fixes that AUTOSEL routinely accepts for staging subsystems.

## Verification

- [Phase 1] Read full commit message; confirmed tags: Artem Lytkin SOB,
  Andy Shevchenko Acked-by, GKH SOB, Link to patch.msgid.link. No
  Fixes/Reported-by/Cc:stable.
- [Phase 2] Read `drivers/staging/fbtft/fb_agm1264k-fl.c` lines 280-392;
  confirmed `ret` initialized to 0 at line 283; left-half assigns `ret
  =` (line 356); right-half lacks assignment (line 379); check on line
  380 uses stale `ret`; function returns `ret` on line 391.
- [Phase 3.1] `git blame` on lines 370-390: line 379 (buggy code)
  introduced in `b2ebd4be6fa1d2` on 2014-12-31.
- [Phase 3.1] `git describe --contains b2ebd4be6fa1d2` →
  `v4.0-rc1~82^2~274`, confirming bug present since v4.0.
- [Phase 3.2] `git show b2ebd4be6fa1d2 --stat`: confirmed it is the
  original driver add of 471 lines.
- [Phase 3.3] `git log --oneline --
  drivers/staging/fbtft/fb_agm1264k-fl.c` showed only cosmetic changes
  since 2014; line 379 untouched by any intermediate fix.
- [Phase 3.4] `git log --author="Artem Lytkin" --oneline` returned one
  other commit (sm750fb pci_release_region fix) — author is a bug-hunter
  in staging.
- [Phase 4.1] `b4 dig -c f80760f5fc02c` matched patch-id `a8ded4803c...`
  → lore thread https://lore.kernel.org/all/20260207220523.3816-1-
  iprintercanon@gmail.com/.
- [Phase 4.1] `b4 dig -c f80760f5fc02c -a`: confirmed only v1 submitted;
  no revisions.
- [Phase 4.1] Read the saved mbox at `/tmp/fbtft_thread.mbox`: confirmed
  Andy Shevchenko's reply "Sounds about right, but it was like that from
  the day 1. Acked-by: Andy Shevchenko". No NAKs, no stable nomination
  request, no objections.
- [Phase 4.2] `b4 dig -c f80760f5fc02c -w`: confirmed CC list includes
  Andy, GKH, dri-devel, linux-fbdev, linux-staging, LKML.
- [Phase 5] Grep for `write_vmem` across staging/fbtft: confirmed caller
  is `fbtft-core.c:272` (`fbtft_update_display`), confirmed the callback
  is registered as `.write_vmem = write_vmem` at line 432 of the driver.
- [Phase 5] Read `fbtft-core.c:270-276`: confirmed return value is only
  used for dev_err logging; no propagation to userspace.
- [Phase 6] Confirmed via blame that the buggy line has been unchanged
  since 2014; file is present and structurally similar across all stable
  trees (5.4+).
- [Phase 7] Read Kconfig help: driver is "FB driver for the AGM1264K-FL
  LCD display (two Samsung KS0108 compatible chips)" — confirmed two-
  halves architecture that is the root cause of the split-write bug.
- [Phase 8] Failure mode verified by code inspection: silent error
  swallowing + false success return; no crash/corruption/security
  consequence.
- UNVERIFIED: The exact number of users running this driver in
  production (unknowable); did not test runtime behavior on actual
  hardware.

The commit is a trivial, obviously-correct, zero-risk one-line fix to a
real (if low-severity) bug present in every stable tree. It meets stable
kernel rules modulo the "important issue" criterion which is only weakly
satisfied, but the risk-benefit ratio overwhelmingly favors inclusion
because the fix cannot regress any working system.

**YES**

 drivers/staging/fbtft/fb_agm1264k-fl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fb_agm1264k-fl.c b/drivers/staging/fbtft/fb_agm1264k-fl.c
index af2dbebefc72b..6fc8f4e9c814d 100644
--- a/drivers/staging/fbtft/fb_agm1264k-fl.c
+++ b/drivers/staging/fbtft/fb_agm1264k-fl.c
@@ -376,7 +376,7 @@ static int write_vmem(struct fbtft_par *par, size_t offset, size_t len)
 
 			/* write bitmap */
 			gpiod_set_value(par->RS, 1); /* RS->1 (data mode) */
-			par->fbtftops.write(par, buf, len);
+			ret = par->fbtftops.write(par, buf, len);
 			if (ret < 0)
 				dev_err(par->info->device,
 					"write failed and returned: %d\n",
-- 
2.53.0

