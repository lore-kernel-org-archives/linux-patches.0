Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5498567636;
	Mon, 19 Oct 2026 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418262; cv=none; b=uwYLL1DByCie81gQaGcHrCtPENYfRF3WHr8W38NL2lP2ZgPgDJ6/9vpsd64pgEQeeoEvlTORAnwYnOkgYxRDjfOfyweDnRapw4w9kE3ZqxdO4MzHusmJHKhBG5gFlC2QhBgzdZani6mlf8zfWQHVcNFllGPT0/+5HJ2gbIWMFl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418262; c=relaxed/simple;
	bh=4IJ95QmyIwySBghoX3OiWGk7JuwUWxFU7DTQ9/ZwBH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l0sHZJe3YQtvQMIi1yhOomE6Ky3V7zvswlJ0Sx/ruu8oU+NffdzWcl3XdOhGkyvDzU5g/GXCk1nYk26FXZIL5JeB1FvYKA6ZL4q6LR9QFKDHuUtzlU2pjXYBxpUTdxVlrWrswZrs0ddglWriMf39FzR4n5woSrk8cGF94gy/ebQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SrEmTah3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SrEmTah3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95C81F000C6;
	Mon, 19 Oct 2026 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418260;
	bh=SsOW5VfsgNpEbr9I97vmwt9dDZ2MBlJTVNWb6++x0fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrEmTah3D/k5Lb78SLE4cTOWVmT47jXSWTJQ7L/egLeGfxa5mNxmb0Klw2l2b/K75
	 +ge0bE8JOAZcw6GGt3NIlQ7lv7kppBl3Ipnj00LUyvtbsDdJMKW9efhS6omT3hue1K
	 C751j3fgWtGZ5EO04eB4UKAfnKqzWDe21UXheQVUb0qFbm8BzxKYlrME0YE3ozMLFR
	 sbZNXidBUQkU3R2ql1CGKMclZTolJnrf0U7csfNWLDfMguEFQhmld83Xdsuw/Bj7Sz
	 +5qxpH23+vpt1YfP14FUAj/5q8Ad/CE14HqwlRdt4TAXhnxC4tU3tAe6xDpl2kHheD
	 mKE8uluJgMYRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li Jun <lijun01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peterhuewe@gmx.de,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null
Date: Mon, 19 Oct 2026 09:46:57 -0400
Message-ID: <20261019135441.1420968-126-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Jun <lijun01@kylinos.cn>

[ Upstream commit b4d1adc70471d0752bba674552d19971ed9fa869 ]

if no define CONFIG_TCG_TIS_SPI_CR50 in config,
the add of tpm_tis_spi_resume is null, this cause the tpm chip to
fail to resume.

Signed-off-by: Li Jun <lijun01@kylinos.cn>
Link: https://lore.kernel.org/r/20260812100914.3540149-1-lijun01@kylinos.cn
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.12.111** (`p-6.12-3-gc504cf0baa3d8`). The SPI TPM
header still defines `tpm_tis_spi_resume` as `NULL` unless CR50 is
built, so this resume bug is present here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[tpm / tpm_tis_spi] [fix] CR50 not defined leaves
`tpm_tis_spi_resume` NULL**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected; not a negative signal)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Jarkko Sakkinen `<jarkko@kernel.org>` (TPM
  maintainer)
- **Acked-by:** none
- **Link:** `https://lore.kernel.org/r/20260812100914.3540149-1-
  lijun01@kylinos.cn`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Li Jun `<lijun01@kylinos.cn>` (author); Jarkko
  Sakkinen (maintainer)
- Ignore pipeline-added Sasha Levin SOB / Upstream-commit markers if
  present

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** Without `CONFIG_TCG_TIS_SPI_CR50`, `tpm_tis_spi_resume` is
  `#define`d to `NULL`.
- **Symptom/failure mode:** SPI TPM chip fails to resume after system
  sleep.
- **Version info:** none in the message.
- **Root cause:** Resume callback is compiled in only for CR50, but
  `SIMPLE_DEV_PM_OPS` in `tpm_tis_spi_main.c` always uses
  `tpm_tis_spi_resume` for every SPI TIS device.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. This is an explicit resume-path bug fix. The wording
is poor English, but the claimed failure is concrete.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/char/tpm/tpm_tis_spi.h` only (~+6 / −2)
- **Functions:** none; preprocessor selection of the resume callback
- **Scope:** single-file surgical header change

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** `#if CONFIG_PM_SLEEP && CONFIG_TCG_TIS_SPI_CR50` → `extern
  tpm_tis_spi_resume`; else → `#define tpm_tis_spi_resume NULL`.
- **After:**
  - `CONFIG_PM_SLEEP && CR50` → CR50 `tpm_tis_spi_resume` (resets
    `wake_after`, then `tpm_tis_resume`)
  - `CONFIG_PM_SLEEP && !CR50` → `#define tpm_tis_spi_resume
    tpm_tis_resume`
  - `!CONFIG_PM_SLEEP` → still `NULL`
- **Path:** system sleep resume for `tpm_tis_spi`
  (`SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_spi_resume)`).

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** logic / PM correctness (missing resume callback)
- **Mechanism:** `tpm_pm_suspend()` sets `TPM_CHIP_FLAG_SUSPENDED`. With
  a NULL `.resume`, that flag is never cleared. `tpm_try_get_ops()` then
  returns `-EIO` (`rc` starts as `-EIO` and the SUSPENDED branch jumps
  to `out_lock` without starting the chip). TPM 1.2 self-test / IRQ re-
  enable in `tpm_tis_resume()` are skipped as well.
- **Fix:** restore the pre-CR50 callback (`tpm_tis_resume`), which
  Infineon/ST/Atmel SPI TIS used before 797c0113c9a48.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: aliases the existing exported `tpm_tis_resume`
  already used by `tpm_tis.c` and `tpm_tis_i2c.c`.
- `tpm_tis_spi.h` includes `tpm_tis_core.h`, which declares
  `tpm_tis_resume` under `CONFIG_PM_SLEEP` — same gate as the new
  `#define`.
- Nested `#if` indentation is ugly kernel style, not a functional risk.
  Jarkko accepted it as-is.
- **Regression risk:** very low. CR50 path unchanged. Non-CR50 path
  restored to the historical, still-current TIS resume helper.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Introduced by **797c0113c9a48** (`tpm: tpm_tis_spi: Support cr50
  devices`, Andrey Pronin / Stephen Boyd, 2019-11-12).
- `git blame -L 43,47 drivers/char/tpm/tpm_tis_spi.h` attributes the
  `#if ... && CR50` / `#define ... NULL` block entirely to that commit.
- Present since v5.5-era CR50 support; long-lived in this 6.12 tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. The introducing commit is 797c0113c9a48. `git
merge-base --is-ancestor 797c0113c9a48 HEAD` succeeded — it is in this
tree. Before that commit, `tpm_tis_spi.c` used `SIMPLE_DEV_PM_OPS(...,
tpm_tis_resume)` (verified with `git show
797c0113c9a48^:drivers/char/tpm/tpm_tis_spi.c`).

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `git log --oneline -S tpm_tis_spi_resume -- drivers/char/tpm/` only
  shows 797c0113c9a48. No later rewrite of this symbol in this tree.
- Header history besides that is unrelated (`6422cbd3c52de` phy_ops
  cleanup).
- Standalone; not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: `git log --author='Li Jun' -- drivers/char/tpm/` is empty in
this tree. Author is an outside contributor. Weight comes from
**Reviewed-by / Signed-off-by Jarkko Sakkinen**, TPM DEVICE DRIVER
maintainer.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. The `#define` uses `tpm_tis_resume`, present since
**41a5e1cf1fe15** (2016, `tpm/tpm_tis: Split tpm_tis driver into a
core...`). Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 mbox 20260812100914.3540149-1-lijun01@kylinos.cn` saved a
  2-message thread (lore WebFetch returned 403; b4 succeeded).
- Submission: Li Jun, 12 Aug 2026, `[PATCH] tpm: tpm_tis_spi: fix nodef
  CR50 tpm_tis_spi_resume is null`
- Reply: Jarkko Sakkinen, 21 Aug 2026: **Reviewed-by: Jarkko Sakkinen**
  — no NAK, no requested changes, no extra revisions.
- `b4 dig -a` on the CR50 introducer was attempted; lore search from b4
  returned a server error. Not needed for this candidate (the 2026
  thread was retrieved directly).
- No Cc: stable in the thread.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients were peterhuewe@gmx.de, jarkko@kernel.org,
jgg@ziepe.ca, linux-integrity@vger.kernel.org — the TPM maintainer set.
Jarkko reviewed.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. The report is the patch itself: Kylinos hit
resume failure with CR50 disabled. Severity from author: TPM chip fails
to resume.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone `[PATCH]`, not a series. No follow-up in that thread.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: WebSearch of lore.kernel.org/stable for this subject found no
prior stable discussion. Nothing indicating it was rejected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body edited. Symbols involved: `tpm_tis_spi_resume`
(header), used as resume callback; fallback `tpm_tis_resume`.

Step 5.2: TRACE CALLERS
Record:
- Only caller: `drivers/char/tpm/tpm_tis_spi_main.c:310`
  `static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend,
  tpm_tis_spi_resume);`
- Wired as `.pm = &tpm_tis_pm` on `tpm_tis_spi_driver`.
- Invoked by the PM core on system suspend/resume/hibernation
  (`.suspend/.resume/.freeze/.thaw/.poweroff/.restore` via
  `SYSTEM_SLEEP_PM_OPS`).
- Context: process context, PM not IRQ.

Step 5.3: TRACE CALLEES
Record:
- CR50 `tpm_tis_spi_resume`: reset `phy->wake_after = jiffies`, then
  `tpm_tis_resume(dev)`.
- `tpm_tis_resume`: `tpm_chip_start` → optional IRQ re-enable → TPM 1.2
  `tpm1_do_selftest` → `tpm_chip_stop` → `tpm_pm_resume` (clears
  `TPM_CHIP_FLAG_SUSPENDED`).
- Generic fallback after this patch is exactly `tpm_tis_resume`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace/system suspend (`echo mem > /sys/power/state`, systemd
suspend, etc.) → PM core → `tpm_pm_suspend` (always registered) → later
resume callback. Reachable on any board with `CONFIG_TCG_TIS_SPI` +
`CONFIG_PM_SLEEP` and no CR50. After the broken resume, `/dev/tpm0`,
hwrng, and key operations fail via `tpm_try_get_ops()` → `-EIO`.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Sibling TIS phys already use `tpm_tis_resume` (`tpm_tis.c:249`,
`tpm_tis_i2c.c:322`, `tpm_tis_synquacer.c:110`). Only SPI TIS lost that
callback when CR50 was optional. The header already stubs
`cr50_spi_probe` with `-ENODEV` when CR50 is off; resume was not stubbed
equivalently.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** `drivers/char/tpm/tpm_tis_spi.h:43-47` is the exact
pre-patch `#if defined(CONFIG_PM_SLEEP) &&
defined(CONFIG_TCG_TIS_SPI_CR50)` / `#define tpm_tis_spi_resume NULL`
block. Bug since 797c0113c9a48 (2019). Candidate is **not** already in
this tree (`git log --grep='fix nodef CR50'` / `'tpm_tis_spi_resume is
null'` empty).

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply.** Current header matches the patch’s old side. No
later refactor of this `#ifdef` in 6.12.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No alternate resume fix. Recent TPM SPI change here is unrelated
(`bb63a0530e8e6` wait_woken).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **TPM character driver** (`drivers/char/tpm/`). **IMPORTANT** —
not core mm/VFS, but security hardware used for measured boot, keys,
hwrng. SPI TIS is the usual driver for discrete TPMs on embedded boards
(SLB9670, ST33HTPM, ATTPM20P).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (many 6.12 TPM stable-style fixes). The
buggy `#ifdef` itself has been untouched since 2019.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific.** Users with
`CONFIG_TCG_TIS_SPI=y/m`, `CONFIG_PM_SLEEP=y`, and
**`CONFIG_TCG_TIS_SPI_CR50` unset** (Kconfig bool, default n).
Chromebooks with CR50 enabled are unaffected. Infineon/ST/Atmel SPI TPM
boards (common on ARM/embedded) are the hit.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Any system sleep/hibernation of that SPI TPM. Common on
laptops/SBCs that suspend. Unprivileged users typically cannot suspend;
after resume, any user of `/dev/tpm0` sees failures. Not a race.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- **Failure mode:** TPM stays `TPM_CHIP_FLAG_SUSPENDED`; ops return
  `-EIO`. Device does not come back after suspend. TPM 1.2 also skips
  resume self-test.
- **Severity: HIGH** (device dead after suspend; security hardware). Not
  a panic, but a hard functional break of the TPM until reboot.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit: high** for SPI TPM + suspend without CR50 — restores post-
  resume TPM.
- **Risk: very low** — 6-line header, CR50 path unchanged, fallback is
  the same function other TIS drivers already use.
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real user-visible bug: SPI TPM does not resume unless CR50 is compiled
  in.
- Regression vs pre-2019 `tpm_tis_resume` usage, introduced by optional
  CR50 support.
- Bug and introducing commit are in this 6.12 tree.
- Tiny, obviously correct, applies cleanly.
- TPM maintainer Reviewed-by.
- Failure is `-EIO` on all TPM ops after suspend (verified in
  `tpm_try_get_ops`).

AGAINST:
- Commit message is terse / no Fixes:/stable tags (not a reason to
  reject).
- Nested `#if` style is non-idiomatic (no runtime risk).
- Not a crash/UAF; “only” a device that stays unusable after suspend.
- Affects a subset of TPM users (SPI, no CR50).

UNRESOLVED:
- Could not WebFetch lore (403); thread was recovered with `b4 mbox`.
- No independent bugzilla/syzbot report.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — alias to existing helper;
   maintainer reviewed.
2. Fixes a real bug that affects users? **PASS** — author reports TPM
   resume failure; code confirms NULL resume + sticky SUSPENDED.
3. Important issue? **PASS** — HIGH: TPM unusable after suspend
   (security device / `-EIO` on all ops).
4. Small and contained? **PASS** — one header, ~6 lines.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — exact match, no prereqs.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not an ID/quirk/DT/build/docs exception. Ordinary small bugfix.

Step 9.4: MAKE YOUR DECISION
This belongs in 6.12. The driver suspends the TPM, then installs a NULL
resume whenever CR50 is off, so the chip never leaves
`TPM_CHIP_FLAG_SUSPENDED`. The patch restores `tpm_tis_resume` for that
config, which is what this driver used before CR50 and what sibling TIS
drivers still use.

**What it solves for stable users:** After suspend, SPI TPMs (SLB9670
and similar) work again without requiring `CONFIG_TCG_TIS_SPI_CR50`.

**Rules:** Small, correct, real functional/security-device bug, no new
API, clean apply.

**Risk vs benefit:** Very low risk, high benefit for the affected
config.

**Concerns:** None that block backport. Style of nested `#if` is
cosmetic.

Verification:
- [Phase 1] Tags: Reviewed-by Jarkko Sakkinen; Link lore Message-ID
  20260812100914.3540149-1-lijun01@kylinos.cn; no Fixes/Reported-
  by/Cc:stable
- [Phase 2] Diff: `tpm_tis_spi.h` only; `#define tpm_tis_spi_resume
  tpm_tis_resume` when PM_SLEEP && !CR50
- [Phase 2] `tpm_tis_spi_main.c:310` `SIMPLE_DEV_PM_OPS(...,
  tpm_tis_spi_resume)` verified
- [Phase 2] `tpm_try_get_ops()` returns `-EIO` if
  `TPM_CHIP_FLAG_SUSPENDED` (`tpm-chip.c:159-174`)
- [Phase 2] `tpm_pm_suspend` sets that flag;
  `tpm_pm_resume`/`tpm_tis_resume` clear it
- [Phase 3] blame: 797c0113c9a48 (2019); `git merge-base --is-ancestor`
  confirms it is in this tree
- [Phase 3] pre-CR50 file used `tpm_tis_resume` in SIMPLE_DEV_PM_OPS
- [Phase 3] candidate not in this tree (`git log --grep` empty)
- [Phase 4] b4 mbox: 2-message thread; Jarkko Reviewed-by; no NAK
- [Phase 4] lore WebFetch 403 — UNVERIFIED via HTTP, recovered via b4
- [Phase 4] no stable-list discussion found
- [Phase 5] callers: only tpm_tis_spi PM ops; siblings already use
  tpm_tis_resume
- [Phase 6] `git describe HEAD` → p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` → 6.12.111; buggy `#ifdef` present; patch old-side
  matches
- [Phase 7] TPM DEVICE DRIVER, maintainer Jarkko
- [Phase 8] Failure: TPM dead after suspend (`-EIO`), severity HIGH;
  risk very low
- UNVERIFIED: whether linus/master already contains a later stylistic
  rewrite of this header (GitHub search snippet still showed the old
  `#ifdef`; does not affect this 6.12 checkout)

**YES**

 drivers/char/tpm/tpm_tis_spi.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.h b/drivers/char/tpm/tpm_tis_spi.h
index d0f66f6f19318..ced416ecd92c2 100644
--- a/drivers/char/tpm/tpm_tis_spi.h
+++ b/drivers/char/tpm/tpm_tis_spi.h
@@ -40,8 +40,12 @@ static inline int cr50_spi_probe(struct spi_device *spi)
 }
 #endif
 
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_TCG_TIS_SPI_CR50)
-extern int tpm_tis_spi_resume(struct device *dev);
+#if defined(CONFIG_PM_SLEEP)
+	#if defined(CONFIG_TCG_TIS_SPI_CR50)
+		extern int tpm_tis_spi_resume(struct device *dev);
+	#else
+		#define  tpm_tis_spi_resume tpm_tis_resume
+	#endif
 #else
 #define tpm_tis_spi_resume	NULL
 #endif
-- 
2.53.0

