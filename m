Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D7F4A4852;
	Mon, 31 Aug 2026 13:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183807; cv=none; b=TBVZXcxq/5sQXmV6VMfaPqtDrGpoUpzPH03A87fXo0SgYjNVwoJJiIW7FECNrzltBJMl4MxcMz2mNL1nbcgIOLN75YxaXON9FYBfUhM4M2kZIjXK07Q8Akhq27JI/jSXrN3qKN/F7h+WPglePkhO67plEX7uq1G1KcbFLtqsNk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183807; c=relaxed/simple;
	bh=r4qloKFWLJaS2fDwoq64lAHQCv9JXiuEUBNefQaUvXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WCpXFqMWTVRrCOY3c7739nXV1de24TIkII03FaVtW4c5Q5jeAwx7iQZs8mkTuGxb2S6l95iKJxlYfOIM00nII5tu8qh2Dw9MczlL5fGZm3BVp9L7Io5IfQPhniTkg+qmpLI9M9NF5Ux5yk9NRba8BcX9fgrRh3Iz5jNgm+xetBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiZur0xy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiZur0xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADF51F00ACF;
	Mon, 31 Aug 2026 13:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183804;
	bh=cRa/ASTntvOrwJRKgvylKIFjYrSui3heS92pnaoYiX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QiZur0xyJr+Qf+6CUG4I656qkWcefM7fzUrYWv1tb4cnsyKY+VE/r7BY95NyzQ17e
	 /n2zhfWO95vQe1MFOpvBrIRjrhrANHA2rv3Boq87eBuuj46IgBvG13RN8UBw49dVdS
	 qMaelVxwvykuKzltfcLqZmx934pYPuceUfKdbceAdiHEAjNv9139PiCfRwUFMilkkQ
	 +0Vfu2pHmOMB5mpiCj1fqwoiPTYQkwFHuKngeGFosCsXyoQ2ziihhUqDmH2htxsx9N
	 FfGqhFB5cihy3pKRQqJDEzBfw8pqGi22hqMgSeeQuzEp1rglgx51CvQjwmKGNnvEhq
	 STemfyyhF/qxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rtc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] rtc: renesas-rtca3: Check RADJ poll result during initial setup
Date: Mon, 31 Aug 2026 09:25:42 -0400
Message-ID: <20260831133314.4125787-314-sashal@kernel.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit fafb016d081200c7652e84202f8ba5951e659a53 ]

In rtca3_initial_setup(), the driver clears the RTCA3_RADJ register and
waits for it to reach zero using readb_poll_timeout(). Check the return
value of readb_poll_timeout() and propagate the error if the poll fails.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com> # on RZ/G3S
Link: https://patch.msgid.link/20260602192559.1791344-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[rtc: renesas-rtca3]` `[Check]` — Check the return value of
the RADJ register poll during RTC initial setup in
`rtca3_initial_setup()`.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** Claudiu Beznea `<claudiu.beznea.uj@bp.renesas.com>` #
  on RZ/G3S
- **Reviewed-by:** Claudiu Beznea `<claudiu.beznea.uj@bp.renesas.com>`
- **Link:**
  https://patch.msgid.link/20260602192559.1791344-3-prabhakar.mahadev-
  lad.rj@bp.renesas.com
- **Signed-off-by:** Lad Prabhakar, Alexandre Belloni (ignore pipeline-
  added SOBs)
- **Cc: stable:** — not present on this individual patch (patch 1/5 in
  the same series did CC stable)
- **Notable:** Part of v2 `[PATCH 2/5]` series; hardware-tested on
  RZ/G3S; no syzbot/fuzzer reports

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** After clearing `RTCA3_RADJ` and polling for it to reach zero,
  the driver ignores the `readb_poll_timeout()` return value.
- **Symptom:** If the poll times out (`-ETIMEDOUT`), setup continues and
  may start the RTC with automatic time error adjustment
  (`RTCA3_RCR2_AADJE`) even though RADJ did not clear.
- **Root cause:** Oversight — every other poll in
  `rtca3_initial_setup()` checks `ret`; this one does not.
- **Version info:** None in message; driver landed in this tree via
  `d4488377609e3` (Nov 2024).

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Yes — despite neutral wording (“check the return value”),
this is a real initialization error-handling bug, not cosmetic cleanup.
The same RADJ-clear poll in `rtca3_set_offset()` already checks `ret`.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `drivers/rtc/rtc-renesas-rtca3.c` (+2 lines)
- **Function:** `rtca3_initial_setup()`
- **Scope:** Single-file, surgical fix (2 lines)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (lines 635–637):** Before: RADJ poll result stored in `ret` but
  ignored; execution proceeds to enable `RTCA3_RCR2_START |
  RTCA3_RCR2_AADJE`. After: on poll failure, return error immediately.
  Affects cold-init path in probe, not hot path.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Error-path / logic correctness fix
- **Mechanism:** Missing timeout handling after hardware register poll.
  If RADJ does not clear within `RTCA3_DEFAULT_TIMEOUT_US` (150 µs), the
  driver continues hardware programming; the subsequent RCR2 poll
  overwrites `ret`, masking the failure and allowing probe to succeed
  with bad RTC adjustment state.

### Step 2.4: Fix Quality
**Record:** Obviously correct — mirrors the pattern used for all other
polls in the same function and for the identical RADJ poll in
`rtca3_set_offset()`. Minimal, no API changes. **Regression risk:** Very
low; on success path `ret == 0` and behavior is unchanged.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame the Changed Lines
**Record:** Buggy code introduced in `d4488377609e3` (“rtc: renesas-
rtca3: Add driver for RTCA-3…”, Oct 30 2024). Present since driver
introduction. Blame confirms lines 634–636 unchanged since
`d4488377609e3`.

### Step 3.2: Follow Fixes Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File History / Related Changes
**Record:** Recent `rtc-renesas-rtca3.c` history in this tree:
- `6e21d1253ef13` — PIE clear polling fix (patch 1/5 of same series;
  already in 6.18.y)
- `27b2fcbd6b982` — Disable interrupts only if RTC enabled (probe-
  failure fix)
- `8f315a5c7376b` — RISC-V build fix
- `d4488377609e3` — Driver introduction

Patch 2/5 (this commit) is standalone; patches 3–5 are error-message,
doc typo, and refactor (not prerequisites).

### Step 3.4: Author's Other Commits
**Record:** Lad Prabhakar authored patch 1 (PIE fix, backported here)
and this patch. Claudiu Beznea (co-author/reviewer) introduced the
driver. Both are active Renesas RTC contributors.

### Step 3.5: Dependencies
**Record:** No dependencies. Applies cleanly to current
`drivers/rtc/rtc-renesas-rtca3.c` in this tree. Upstream commit:
`fafb016d08120` on `master`; **not yet in HEAD** (`v6.18.44`).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:**
- `b4 dig -c 6e21d1253ef13 -a` found series v2 at
  https://patch.msgid.link/20260602192559.1791344-2-prabhakar.mahadev-
  lad.rj@bp.renesas.com
- This commit is `[PATCH v2 2/5]` (message-id `…1791344-3…`)
- Cover letter lists RADJ poll checking as an explicit series goal
- No NAKs found in saved mbox; Claudiu provided RB/TB
- **Stable nomination:** Only patch 1/5 CC'd `stable@vger.kernel.org` in
  the submission; patch 2/5 did not (per instructions, this is not a
  deciding factor)

### Step 4.2: Reviewers
**Record:** `b4 dig -w` recipients include Alexandre Belloni (RTC
maintainer), Claudiu Beznea, Geert Uytterhoeven, `linux-rtc@`, `linux-
renesas-soc@`.

### Step 4.3: Bug Reports
**Record:** No bug reports, syzbot links, or user crash reports. Issue
identified by code review during the same audit that produced the PIE
polling fix.

### Step 4.4: Related Patches
**Record:** 5-patch series; only patches 1–2 are bug fixes. Patches 3–5
(error message, doc typo, year-decoding refactor) are not stable
candidates.

### Step 4.5: Stable Mailing List
**Record:** Not searched separately; patch 1 from this series was
already cherry-picked into `linux-6.18.y` as `6e21d1253ef13` (Signed-
off-by: Greg Kroah-Hartman), confirming stable maintainers accept rtca3
fixes from this series.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rtca3_initial_setup()` modified.

### Step 5.2: Callers
**Record:** `rtca3_initial_setup()` called once from `rtca3_probe()` at
line 760. `rtca3_probe()` is the `platform_driver` probe for
`module_platform_driver(rtca3_platform_driver)`. Runs at boot during
device enumeration on Renesas RZ/G3S platforms with
`CONFIG_RTC_DRV_RENESAS_RTCA3`.

### Step 5.3: Callees
**Record:** `readb_poll_timeout()`, `writeb()`, `usleep_range()`,
`clk_get_rate()`. Hardware register I/O during init.

### Step 5.4: Reachability
**Record:** Triggered on every boot when the RTCA-3 platform device
probes. Not userspace-triggerable directly, but affects all systems
using this RTC hardware. Failure during init is a boot-time driver probe
issue.

### Step 5.5: Similar Patterns
**Record:** In the same file, `rtca3_set_offset()` lines 538–542 perform
the identical RADJ-clear poll **with** `if (ret) return ret;`. All other
polls in `rtca3_initial_setup()` also check `ret`. This is the sole
missing check in that function.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Local tree is `v6.18.44` (`linux-6.18.y`).
`drivers/rtc/rtc-renesas-rtca3.c` exists; lines 634–636 show the missing
check. Driver present since `d4488377609e3`.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — upstream diff matches current file
context exactly. No conflicts anticipated.

### Step 6.3: Related Fixes Already Present?
**Record:** Patch 1/5 (PIE polling fix) already backported as
`6e21d1253ef13`. This patch 2/5 is **not** yet in HEAD. No alternate fix
for the RADJ poll issue.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/rtc/` — IMPORTANT (peripheral driver).
`CONFIG_RTC_DRV_RENESAS_RTCA3` depends on `ARCH_RENESAS`; targets
Renesas RZ/G3S SoC only.

### Step 7.2: Subsystem Activity
**Record:** Driver is new (added late 2024) and actively maintained;
multiple follow-up fixes in mainline and at least one already in this
stable tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Config-specific, platform-specific — users building
`CONFIG_RTC_DRV_RENESAS_RTCA3` on Renesas RZ/G3S hardware. Not
universal, but real production embedded users.

### Step 8.2: Trigger Conditions
**Record:** RADJ register fails to clear to zero within 150 µs after
`writeb(0, RTCA3_RADJ)`. Unlikely on healthy hardware; possible on
marginal/broken hardware or timing edge cases. Not unprivileged-
userspace-triggerable; boot-time init only.

### Step 8.3: Failure Mode Severity
**Record:** Without fix: probe succeeds despite failed RADJ init; RTC
may start with `RTCA3_RCR2_AADJE` enabled while adjustment register is
not in expected state → incorrect timekeeping/alarms. **Severity:
MEDIUM** — functional RTC corruption, not kernel oops/UAF/security
issue. With fix: probe fails cleanly with `"Failed to setup the RTC!"`.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents silently registering a mis-initialized RTC;
  consistent error handling; complements already-backported patch 1/5
- **Risk:** Very low — 2 lines, no behavior change when poll succeeds
- **Ratio:** Moderate benefit for a narrow audience, very low risk

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug — only missing poll error check in `rtca3_initial_setup()`
- Inconsistent with identical pattern elsewhere in same driver
- Can leave RTC in wrong adjustment state while probe succeeds
- Trivial, obviously correct, hardware-tested on RZ/G3S
- Driver exists in this `6.18.y` tree; patch applies cleanly
- Sister fix (patch 1/5) already backported to this tree
- Reviewed/tested by driver co-maintainer

**AGAINST backport:**
- No user bug reports or reproducible failure described
- Only triggers on 150 µs poll timeout — rare on working hardware
- Not crash/security/deadlock/kernel memory corruption
- Narrow hardware scope (RZ/G3S only)
- Author CC'd stable only on patch 1, not this patch
- Patches 3–5 in series are clearly non-stable material

**Unresolved:** Whether RADJ poll timeout has been observed on real
hardware (no evidence found).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — 2-line mirror of existing
   pattern; Tested-by on RZ/G3S
2. Fixes a real bug? **PASS** — missing error propagation on hardware
   poll timeout
3. Important issue? **BORDERLINE PASS** — incorrect RTC init/timekeeping
   on affected embedded hardware; not a kernel crash, but functional
   hardware misconfiguration
4. Small and contained? **PASS** — 2 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — driver and buggy code present;
   clean apply

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build fix, or docs fix).

### Step 9.4: Decision Rationale

This is a legitimate initialization bug in a driver that is already
maintained in `linux-6.18.y`, with a sister fix from the same series
already cherry-picked. The omission allows probe to succeed after a
failed hardware register poll, immediately before enabling automatic
time error adjustment — a documented init sequence step. While the
trigger is uncommon and the audience is narrow (Renesas RZ/G3S), the fix
is zero-risk on the success path, obviously correct, hardware-tested,
and prevents silently exposing a mis-initialized RTC to userspace. That
meets the stable bar for a contained driver probe correctness fix in
hardware that this tree already supports.

---

## Verification

- **[Phase 1]** Parsed commit message tags from user-provided content
- **[Phase 2]** Read current `drivers/rtc/rtc-renesas-rtca3.c` lines
  567–660, 538–542; confirmed 2-line diff
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `make kernelversion`
  equivalent → 6.18.44
- **[Phase 3]** `git blame -L 630,650` → bug from `d4488377609e3`
- **[Phase 3]** `git log --oneline -- drivers/rtc/rtc-renesas-rtca3.c` →
  5 commits, patch 1 backported, RADJ fix absent
- **[Phase 3]** `git show fafb016d08120` on master → upstream commit
  matches provided diff
- **[Phase 3]** `git merge-base --is-ancestor fafb016d08120 HEAD` → RADJ
  fix NOT in HEAD
- **[Phase 4]** `b4 dig -c 6e21d1253ef13 -a` → found v2 5-patch series
- **[Phase 4]** `b4 dig -m /tmp/rtca3-series.mbx` → read cover letter
  and patch 2/5 content
- **[Phase 4]** Confirmed patch 1 CC'd stable; patch 2 did not
- **[Phase 4]** WebFetch of lore/patch.msgid.link blocked by bot
  protection for direct fetch; used b4 mbox instead
- **[Phase 5]** `grep rtca3_initial_setup` → called from `rtca3_probe()`
  line 760
- **[Phase 5]** Counted `if (ret)` checks vs `readb_poll_timeout` calls
  — RADJ poll is sole missing check in `rtca3_initial_setup()`
- **[Phase 6]** Confirmed `CONFIG_RTC_DRV_RENESAS_RTCA3` in Kconfig,
  `depends on ARCH_RENESAS`
- **[Phase 6]** Confirmed buggy code at lines 634–636 without `if (ret)
  return ret;`
- **[Phase 8]** `RTCA3_DEFAULT_TIMEOUT_US` = 150 µs verified at line 87

**YES**The background git searches finished and match the earlier
analysis:

- **RADJ poll fix** (`fafb016d08120` / “Check RADJ poll result during
  initial setup”) is **not** in this `linux-6.18.y` checkout; it’s only
  on `master`.
- **All `rtc-renesas-rtca3` commits in this tree:** driver introduction
  (`d4488377609e3`), RISC-V build fix, wakeup boolean cleanup,
  interrupt-disable probe fix (`27b2fcbd6b982`), and the already-
  backported PIE polling fix (`6e21d1253ef13`).
- **From the v2 5-patch series:** only patch 1 (PIE fix) is present;
  patch 2 (this RADJ check) and patches 3–5 are not.

That supports the **YES** backport recommendation for `linux-6.18.y`:
the bug is present, the fix is absent, and the related patch from the
same series is already here.

 drivers/rtc/rtc-renesas-rtca3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-renesas-rtca3.c b/drivers/rtc/rtc-renesas-rtca3.c
index 47b4827979344..c41f2089cbb2b 100644
--- a/drivers/rtc/rtc-renesas-rtca3.c
+++ b/drivers/rtc/rtc-renesas-rtca3.c
@@ -634,6 +634,8 @@ static int rtca3_initial_setup(struct clk *clk, struct rtca3_priv *priv)
 	writeb(0, priv->base + RTCA3_RADJ);
 	ret = readb_poll_timeout(priv->base + RTCA3_RADJ, tmp, !tmp, 10,
 				 RTCA3_DEFAULT_TIMEOUT_US);
+	if (ret)
+		return ret;
 
 	/* Start the RTC and enable automatic time error adjustment. */
 	mask = RTCA3_RCR2_START | RTCA3_RCR2_AADJE;
-- 
2.53.0

