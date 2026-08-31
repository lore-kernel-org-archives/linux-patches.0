Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63904511E8D;
	Mon, 31 Aug 2026 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183784; cv=none; b=mM9mkoD3ey2AGx+oxPLfMPigpl7M9OnYekQQ4X1JcfD6y0nWad5jE5ANYqMFSpZ7N/ZMyf5tkJUALYAJ9Fnn4gwDemO5qF2LjsE6Zntq845ofA6KM7oER3NNtdPusBHOwnGZ3hBtgEC4TuMn44CLyJ4ih7zaAT58cpILx4gewhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183784; c=relaxed/simple;
	bh=gQ54Kb83VbE6pJF7wgQPgCceL0NcYunXBNUky0rfQ2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TSdP0kJrp9zHHtDurfzbb9/JcX28aCR9sQ696dwvGBqo4K7Q9my2CewRU40MknKvNmb8lZ5oeq4ObMWdwlxinZufc1ORlUrIybcSH4bEMDgQN1Cy/KIbn+JYnc8oF+JG7T4qCzSRm8JER3RUa4QeytCPUUxdIHU8juArytuLfQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZzZD2FyO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZzZD2FyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E3D1F00A3E;
	Mon, 31 Aug 2026 13:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183782;
	bh=k81biJ+K8PpduLeUzIuG9AsrGX9e8QnNxvaQEDSLZrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzZD2FyONPSSpKXFElxxP2nb+lUR9Jiu1TUD3f5foEsQvYwXVYXP6oPlJz8dcSyl6
	 sbgr42nHDvDVsllF8x7IT4ujqycuK2qicHtUXu7NqHcy6BZ6Vg0PZtuQ42SuTZbQC9
	 8Gq7zfMASOtcofqX4q3EsdJ3B5fLnlQbpqroZPrYUZszfJBQ+SNXwZUYGU1o8TWFSD
	 dKkCvMbogkXai9/A1Fq9yOhOLMJWuDvbh711L5wx5eXSoSDmOtFkJZ1bC1pme6izPB
	 WslxLIwfaIGh2drUBpskUldskAU42f5LkZW8OPtZ2TuWjETn08XFo5gq4fuy8jvZfd
	 HD9xgtuWDNPrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>,
	openipmi-developer@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ipmi: si: Use platform_get_irq_optional() to retrieve interrupt
Date: Mon, 31 Aug 2026 09:25:29 -0400
Message-ID: <20260831133314.4125787-301-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 39851b7e580a65bee732e5364f0efb974b242370 ]

Use platform_get_irq_optional() to retrieve the interrupt resource
instead of directly parsing and mapping the OF node via
irq_of_parse_and_map().  This is the standard pattern for platform
devices.  irq_of_parse_and_map() requires ire_dispose_mapping(), which
is missing.

Assisted-by: Antigravity:Gemini-3.5-Flash
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Message-ID: <20260603192511.6869-1-rosenp@gmail.com>
[Handle a negative return from platform_get_irq_optional() to mean
 no interrupt is assigned.]
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ipmi: si: Use platform_get_irq_optional()
to retrieve interrupt`

**Local tree:** `v6.18.44` (kernel 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ipmi: si]` `[use]` — Switch OF probe path from
`irq_of_parse_and_map()` to `platform_get_irq_optional()` for interrupt
retrieval.

### Step 1.2: Parse all commit message tags
**Record:**
- `Assisted-by: Antigravity:Gemini-3.5-Flash`
- `Signed-off-by: Rosen Penev <rosenp@gmail.com>`
- `Message-ID: <20260603192511.6869-1-rosenp@gmail.com>`
- Follow-up amendment: `Signed-off-by: Corey Minyard
  <corey@minyard.net>` (IPMI subsystem maintainer)

**Notable patterns:** No `Reported-by:`, `Fixes:`, `Cc: stable`, or
syzbot links. Maintainer (Corey Minyard) signed off with a behavioral
clarification (negative return → no IRQ).

### Step 1.3: Analyze commit body
**Record:**
- **Bug described:** `irq_of_parse_and_map()` creates an IRQ mapping
  that requires `irq_dispose_mapping()` on teardown; that cleanup is
  missing in the IPMI SI OF probe/remove path.
- **Symptom/failure mode:** IRQ domain mapping leak when an OF-probed
  IPMI SI device is removed or the driver is unloaded — not a crash, but
  a real resource leak.
- **Root cause:** OF path uses the legacy `irq_of_parse_and_map()` API
  while ACPI/platform paths in the same file already use
  `platform_get_irq_optional()`.
- **Fix approach:** Use the standard platform-device IRQ API, matching
  ACPI/platform probe paths.

### Step 1.4: Detect hidden bug fixes
**Record:** Yes — despite “use standard pattern” wording, this fixes a
real resource-leak bug. `irq_of_parse_and_map()` without matching
`irq_dispose_mapping()` is incorrect API usage. The sibling
`ipmi_powernv.c` driver correctly pairs these calls.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `drivers/char/ipmi/ipmi_si_platform.c` only (+3 net lines)
- **Function modified:** `of_ipmi_probe()`
- **Scope:** Single-file, surgical fix (4 lines in one hunk)

### Step 2.2: Code flow change per hunk
**Record:**
- **Before:** `io.irq = irq_of_parse_and_map(pdev->dev.of_node, 0);` —
  creates an OF IRQ mapping.
- **After:** `io.irq = platform_get_irq_optional(pdev, 0);` with `if
  (io.irq < 0) io.irq = 0;` — uses standard platform IRQ retrieval;
  negative means no IRQ assigned.
- **Path affected:** OF device-tree IPMI SI probe (`CONFIG_OF`), called
  from `ipmi_probe()` when `pdev->dev.of_node` is set.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Resource leak (missing `irq_dispose_mapping()`).
- **Mechanism:** `irq_of_parse_and_map()` allocates an IRQ mapping. On
  remove, `shutdown_smi()` → `std_irq_cleanup()` only calls
  `free_irq()`, never `irq_dispose_mapping()`. Each probe/remove cycle
  leaks one mapping. `platform_get_irq_optional()` uses `of_irq_get()`
  internally (via `platform.c`) and does not require
  `irq_dispose_mapping()`.

### Step 2.4: Fix quality assessment
**Record:**
- **Quality:** High — matches existing ACPI (`acpi_ipmi_probe`, line
  368) and platform (`platform_ipmi_probe`, line 200) patterns in the
  same file.
- **Regression risk:** Very low — behavior for “no IRQ” is equivalent
  (`irq_of_parse_and_map` returns 0; `platform_get_irq_optional` returns
  negative, normalized to 0).
- **Maintainer amendment:** Corey Minyard’s follow-up correctly handles
  negative returns as “no interrupt.”

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** `irq_of_parse_and_map()` introduced in `9d70029edbbf2`
(Corey Minyard, Sep 2017, “ipmi_si: Move platform device handling to
another file”). Bug present since 2017 in this code path.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: File history for related changes
**Record:**
- `443d372d6a96` (2020): “ipmi_si: Avoid spurious errors for optional
  IRQs” — switched ACPI path to `platform_get_irq_optional()`, with `Cc:
  stable@vger.kernel.org # 5.4.x`.
- OF path was never updated; inconsistency remains in 6.18.44.
- This candidate commit is **not yet applied** to the local tree (line
  279 still uses `irq_of_parse_and_map()`).

### Step 3.4: Author's other commits
**Record:** Rosen Penev has no prior commits in `drivers/char/ipmi/` in
this tree. Corey Minyard is the IPMI subsystem maintainer and signed off
on the amendment.

### Step 3.5: Prerequisites/dependencies
**Record:** None. `platform_get_irq_optional()` exists and is already
used in the same file. Standalone, self-contained fix.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c <commit>` could not run — commit not present in
local tree. Lore.kernel.org fetch returned 403 (bot protection).
Message-ID `20260603192511.6869-1-rosenp@gmail.com` identified but
thread content unverified.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not fetch mailing list thread. Corey
Minyard’s Signed-off-by on the amendment is verified via commit message.

### Step 4.3: Bug report
**Record:** N/A — no `Reported-by:` or `Link:` tags. No user or syzbot
report.

### Step 4.4: Related patches/series
**Record:** Appears standalone (not part of a multi-patch series).
Related prior fix: `443d372` (ACPI path, 2020).

### Step 4.5: Stable mailing list history
**Record:** UNVERIFIED — lore.kernel.org inaccessible. Prior related
ACPI fix was explicitly nominated for stable (`Cc:
stable@vger.kernel.org # 5.4.x`).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions modified
**Record:** `of_ipmi_probe()` — only function changed.

### Step 5.2: Callers
**Record:** `of_ipmi_probe()` called from `ipmi_probe()` (line 400)
during platform device probe. Triggered at boot on DT systems with IPMI
nodes (`ipmi-kcs`, `ipmi-smic`, `ipmi-bt` compatible strings).

### Step 5.3: Callees
**Record:**
- **Before:** `irq_of_parse_and_map()` → creates mapping needing
  `irq_dispose_mapping()`.
- **After:** `platform_get_irq_optional()` → `of_irq_get()` for OF nodes
  (per `drivers/base/platform.c:184-188`).
- Downstream: `ipmi_si_add_smi()` → `ipmi_std_irq_setup()` →
  `request_irq()`; remove via `std_irq_cleanup()` → `free_irq()` only.

### Step 5.4: Call chain / reachability
**Record:** Boot-time device probe on `CONFIG_OF` systems (ARM servers,
embedded BMC hosts). Bug manifests on device remove/module unload
(`ipmi_remove()` → `ipmi_si_remove_by_dev()` → `shutdown_smi()`). Not
syscall-reachable, but reachable via driver unbind/module reload.

### Step 5.5: Similar patterns
**Record:**
- Same file: ACPI path (line 368) and platform path (line 200) already
  use `platform_get_irq_optional()`.
- `ipmi_powernv.c` correctly pairs `irq_of_parse_and_map()` with
  `irq_dispose_mapping()` on remove (lines 279, 291) — demonstrates the
  expected contract.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** Line 279 in `drivers/char/ipmi/ipmi_si_platform.c`:
```279:279:drivers/char/ipmi/ipmi_si_platform.c
        io.irq          = irq_of_parse_and_map(pdev->dev.of_node, 0);
```
Bug present since 2017 (`9d70029`). ACPI/platform paths already fixed;
OF path still buggy in 6.18.44.

### Step 6.2: Backport complications
**Record:** Expected clean apply — minimal 3-line functional change at a
stable location with matching context. No conflicting recent churn in
this function.

### Step 6.3: Related fixes already present?
**Record:** ACPI/platform paths already use
`platform_get_irq_optional()`. No equivalent OF-path fix or
`irq_dispose_mapping()` addition present. This fix not yet in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/char/ipmi/` — **IMPORTANT** peripheral driver. IPMI
is widely used on servers/embedded for BMC management, but this specific
bug is in the teardown path, not the hot IPMI message path.

### Step 7.2: Subsystem activity
**Record:** Moderate recent activity (refactoring, type-info moves). OF
IRQ retrieval code has been stable since 2017 aside from ACPI-path fix
in 2020.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of `CONFIG_IPMI_SI` + `CONFIG_OF` with device-tree
IPMI nodes. Platform-specific (DT ARM/Power embedded), not universal.

### Step 8.2: Trigger conditions
**Record:** Device remove, driver module unload, or sysfs unbind after
successful OF probe with an IRQ defined. Uncommon in production (IPMI
typically probed once at boot), but possible during development,
firmware updates, or hot-unbind testing. Not unprivileged-user
triggerable directly.

### Step 8.3: Failure mode severity
**Record:** IRQ domain mapping leak on teardown. **Severity: LOW-
MEDIUM** — real kernel resource leak, no crash/corruption/security
impact. Could accumulate with repeated bind/unbind cycles.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Fixes longstanding API misuse; aligns OF path with
  ACPI/platform paths; prevents per-remove IRQ mapping leaks.
- **Risk:** Very low — 3 lines, maintainer-reviewed, matches established
  in-file pattern.
- **Ratio:** Favorable — tiny, correct fix for a real (if low-impact)
  bug.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real resource leak: `irq_of_parse_and_map()` without
  `irq_dispose_mapping()` on remove
- Maintainer (Corey Minyard) signed off with behavioral fix
- Matches pattern already used in same file and previously backported
  for ACPI path (`443d372`, `Cc: stable`)
- Tiny, surgical, obviously correct
- Buggy code confirmed present in 6.18.44 since 2017
- `ipmi_powernv.c` shows correct pairing of these APIs in same subsystem

**AGAINST backport:**
- Low user-visible impact — leak only on driver remove, not during
  normal operation
- No user reports, syzbot, or sanitizer findings
- Does not cause crash, corruption, deadlock, or security issue
- IPMI SI rarely unloaded in production

**Unresolved:**
- Full mailing list review thread (lore 403)
- Whether mainline has merged this yet (commit not in local tree)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — matches in-file precedent;
   maintainer SOB; logic verified against `platform.c` and
   `ipmi_powernv.c`.
2. Fixes a real bug? **PASS** — IRQ mapping leak on teardown.
3. Important issue? **PASS (borderline)** — resource leak, not
   crash/corruption; severity low but real; same driver had a lesser
   ACPI log-spam fix backported to stable in 2020.
4. Small and contained? **PASS** — 3 net lines, one function.
5. No new features/APIs? **PASS** — API usage correction only.
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected.

### Step 9.3: Exception categories
**Record:** N/A — not a device ID, quirk, DT update, build fix, or docs
fix. Standard driver bug fix.

### Step 9.4: Decision rationale

This commit fixes a real, verifiable resource leak in the OF IPMI SI
probe/remove path. The ACPI and platform probe paths in the same file
were already converted to `platform_get_irq_optional()` years ago (with
stable nomination for the ACPI case). The OF path was left behind using
`irq_of_parse_and_map()` without the required `irq_dispose_mapping()` in
the remove path (`std_irq_cleanup()` only calls `free_irq()`).

While the leak only manifests on device removal and is unlikely to
affect typical production servers, it is a genuine kernel bug with a
trivial, maintainer-approved fix that carries negligible regression
risk. The precedent of backporting a related (less severe) IRQ-handling
fix in this same driver supports inclusion.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 2]** Diff analysis: 3 lines added in `of_ipmi_probe()`,
  replaces `irq_of_parse_and_map` with `platform_get_irq_optional` +
  negative check
- **[Phase 3]** `git describe HEAD`: v6.18.44 / kernel 6.18.44
- **[Phase 3]** `git blame -L 275,285`: `irq_of_parse_and_map` from
  `9d70029` (Sep 2017)
- **[Phase 3]** `git log --oneline -5 --
  drivers/char/ipmi/ipmi_si_platform.c`: recent history reviewed
- **[Phase 3]** `git show 443d372`: prior ACPI
  `platform_get_irq_optional` fix with `Cc: stable@vger.kernel.org`
- **[Phase 4]** `b4 dig`: failed — commit not in local tree (requires
  `-c COMMITISH`)
- **[Phase 4]** Lore fetch: 403 Forbidden — thread content UNVERIFIED
- **[Phase 5]** Read `drivers/char/ipmi/ipmi_si_platform.c`: confirmed
  OF path at line 279 uses `irq_of_parse_and_map`; ACPI (368) and
  platform (200) use `platform_get_irq_optional`
- **[Phase 5]** Read
  `drivers/char/ipmi/ipmi_si_intf.c:1326-1354,2308-2310`:
  `std_irq_cleanup()` calls `free_irq()` only, no
  `irq_dispose_mapping()`
- **[Phase 5]** Read `drivers/base/platform.c:171-188`:
  `platform_get_irq_optional()` uses `of_irq_get()` for OF nodes
- **[Phase 5]** Read `drivers/char/ipmi/ipmi_powernv.c:277-291`: correct
  `irq_dispose_mapping()` usage with `irq_of_parse_and_map()`
- **[Phase 6]** `grep irq_of_parse_and_map drivers/char/ipmi/`: only
  `ipmi_si_platform.c:279` and `ipmi_powernv.c:244` (powernv handles
  cleanup correctly)
- **[Phase 6]** Confirmed candidate commit NOT yet in tree (line 279
  unchanged)
- **[Phase 8]** Failure mode: IRQ mapping leak on remove, severity LOW-
  MEDIUM

**YES**

 drivers/char/ipmi/ipmi_si_platform.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_si_platform.c b/drivers/char/ipmi/ipmi_si_platform.c
index fb6e359ae4946..704b06c919f03 100644
--- a/drivers/char/ipmi/ipmi_si_platform.c
+++ b/drivers/char/ipmi/ipmi_si_platform.c
@@ -276,7 +276,10 @@ static int of_ipmi_probe(struct platform_device *pdev)
 	io.regspacing	= regspacing ? be32_to_cpup(regspacing) : DEFAULT_REGSPACING;
 	io.regshift	= regshift ? be32_to_cpup(regshift) : 0;
 
-	io.irq		= irq_of_parse_and_map(pdev->dev.of_node, 0);
+	io.irq = platform_get_irq_optional(pdev, 0);
+	if (io.irq < 0)
+		io.irq = 0;
+
 	io.dev		= &pdev->dev;
 
 	dev_dbg(&pdev->dev, "addr 0x%lx regsize %d spacing %d irq %d\n",
-- 
2.53.0

