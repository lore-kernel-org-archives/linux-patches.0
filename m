Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715894D1FB0;
	Mon, 19 Oct 2026 14:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418505; cv=none; b=VkV8aRh/Y706+mlcLzMTX8b0w0GaVt1vG65D2cov69cE+KvkwVgFvOVxhKHsYURHyJd53Q26cpbcSYnZRFFD56kfOO3adUurt2VqkuZ3G7bOVFVAlZKG9CCL5SggYrHVr8cAk6dwuaGal0O3CiK9qnyxDlmZa/cWcZBGC5yiHlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418505; c=relaxed/simple;
	bh=2VNeTNAdkZexvUQYw/aV00PLJtaFV4LY36AdV6DvVoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eowR8MQXbpK6Bau4ZWcNiEo4tOfYrpliQd/4XjAy15+OeZH8g6PjQqkOMvsNiGsgE3ODyESvHb6TqLHr/FoTRa2Rxtwox8A/hjND37YV1cxgY3tYMHpbOBw3hpVrKtONLNcVitGsk3aaehKFWMOE2OqhqhtKrM/8s/COTwpBgVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8ngBZQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8ngBZQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A401F000C4;
	Mon, 19 Oct 2026 14:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418502;
	bh=nHFBcSULm0DfhTGaqeLamMS07HlHbJMEAnLLd80NT9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8ngBZQIr6tkVxb8tPjskOBAsDAjHlaWW2s7mre/eLFNUe1zr8eI4AKPwDF/ipK5j
	 GghYOqmB3LwchxtBQIuNXum0KCo3D9mRiFCk3Z6oU0RgDhZQMhcxnUtC1fYq9DPXq7
	 Uj1FeJdC/KlfeeeoEYW8LEEFWmt4sPw6kxxzdmsz9fSm8aGmxY71/iVjz9EWkytmgb
	 pWJBQsTKp4F5BfaFRlJUxIOHvCue/aFSWbqsgWHqGWRryVKlXh5QKnXOtMxN6odDp4
	 Xc4+vnPDUAeFGTjKl3wjIVo9zs4+x/ORWN05bYtkZLZ5/NneH+9REvGnyZOyfw5bVl
	 fZK6o5zOcfHUw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ruoyu Wang <ruoyuw560@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18] memory: stm32_omm: initialize ret in stm32_omm_set_amcr
Date: Mon, 19 Oct 2026 09:49:45 -0400
Message-ID: <20261019135441.1420968-294-sashal@kernel.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 1527acf2295cf2d6e11e3e9b121d63709667e6e7 ]

stm32_omm_set_amcr() returns ret after checking whether the AMCR value
matches the device tree description. On the normal matching path ret is
not otherwise assigned, so initialize it to 0 before the checks.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://patch.msgid.link/20260617182202.961843-1-ruoyuw560@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. `stm32_omm_set_amcr()` in that tree still
returns uninitialized `ret` on the AMCR-match path, and the one-line
init is a real probe/resume correctness fix.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[memory / stm32_omm] [initialize] [set ret=0 in
stm32_omm_set_amcr so the AMCR-match success path does not return an
uninitialized stack value]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>` (driver
  maintainer; MAINTAINERS lists him for ST STM32 OCTO MEMORY MANAGER)
- `Link:
  https://patch.msgid.link/20260617182202.961843-1-ruoyuw560@gmail.com`
- `Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>` (author)
- `Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>` (memory-
  controller maintainer; applied the patch)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- No `Reported-by:` / `Tested-by:` / syzbot / kernel test robot tags
- Pipeline-only tags (`[Upstream commit ...]`, `Signed-off-by: Sasha
  Levin`) ignored

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `stm32_omm_set_amcr()` returns `ret` after the AMCR vs DT check.
  On the matching (success) path, `ret` is not assigned `-EINVAL` and
  may never have been assigned at all.
- Symptom: the function can return a leftover stack value as an errno to
  probe/configure/resume. Callers treat any non-zero as failure, so
  garbage can fail device bring-up or resume; a lucky 0 would hide the
  mismatch path’s intent.
- Version info: none in the message.
- Root cause (author): success path does not initialize `ret` before
  `return ret`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. This is an explicit uninitialized-variable fix
(`int ret` → `int ret = 0`). Same class as KMSAN/compiler “used
uninitialized” fixes even without a sanitizer tag.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/memory/stm32_omm.c` (`1` insertion, `1` deletion)
- Function: `stm32_omm_set_amcr`
- Scope: single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before, `int ret, idx;` then the loop may assign `ret` from
`of_address_to_resource()`, mismatch sets `ret = -EINVAL`, and the
function always `return ret`. After, `ret` starts at `0`, so AMCR match
returns success unless an earlier path already returned an error.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: Category **uninitialized data / logic correctness**. Mechanism:
`ret` is assigned only by a successful `of_address_to_resource()`
(inside a loop that can `continue`) or by `ret = -EINVAL` on AMCR
mismatch. The success `return ret` is therefore undefined if the loop
never assigned `ret`. Fix: default `ret = 0`.

Verified from the pre-fix function (v6.18.53 and the original driver):

```50:50:drivers/memory/stm32_omm.c
        int ret = 0, idx;
```

(v6.18.53 still has `int ret, idx;` — confirmed via `git show
v6.18.53:drivers/memory/stm32_omm.c`.)

Mismatch path:

```116:121:drivers/memory/stm32_omm.c
        if (amcr != read_amcr) {
                dev_err(dev, "AMCR value not coherent with DT memory-map
areas\n");
                ret = -EINVAL;
        }

        return ret;
```

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. Error returns in the loop are unchanged
(`return ret` / `return -EFAULT`). AMCR mismatch still returns
`-EINVAL`. Risk is negligible: initializing an errno to 0 cannot
deadlock, cannot change a public API, and matches the intended success
code.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: `int ret, idx;` and the `return ret` were introduced in
`8181d061dcff1` (“memory: Add STM32 Octo Memory Manager driver”,
2025-04-28 / committed 2025-05-07). Present from the first version of
the driver. Driver first appears in **v6.16**; still present in v6.17
and v6.18.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The introducing commit is `8181d061dcff1`,
which **is** an ancestor of v6.18 (`git merge-base --is-ancestor
8181d061dcff1 v6.18` succeeded).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (path-limited `git log --oneline -- drivers/memory/stm32_omm.c`):
driver add, spelling, several probe/error-handling fixes,
`syscon_regmap_lookup_by_phandle_args`, req2ack test fix. Intermediate
commit `6d8b18ae647bb` changed syscon lookup but left `int ret, idx;`
and `return ret` in place. This init patch is standalone, not “patch
X/Y”.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Ruoyu Wang has only this commit under `drivers/memory/`. The
driver maintainer (Patrice Chotard) reviewed it. Memory-controller
maintainer (Krzysztof Kozlowski) applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. The hunk only changes a local `int ret` declaration. No
new helpers, types, or APIs. Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 1527acf2295cf2d6e11e3e9b121d63709667e6e7` →
  https://patch.msgid.link/20260617182202.961843-1-ruoyuw560@gmail.com
- `b4 dig -a`: single revision **v1 only**; committed version is that v1
- Thread: author submission; Patrice Chotard `Reviewed-by`; Krzysztof
  “Applied, thanks!” (mem-ctrl commit
  `1527acf2295cf2d6e11e3e9b121d63709667e6e7`)
- No NAK, no risk flags, no reviewer request for `Cc: stable`
- lore.kernel.org WebFetch returned 403; discussion recovered via `b4
  dig -m` and openwall/lkml mirrors

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Patrice Chotard (driver
maintainer), Krzysztof Kozlowski (memory controllers), Maxime Coquelin,
Alexandre Torgue, linux-kernel, linux-stm32, linux-arm-kernel.
Appropriate maintainers were on the patch and it was reviewed/applied.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by`, no bugzilla/syzbot link. No verified kernel-
test-robot mail in the thread. The author describes the uninit return
from code inspection.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not a series. No sibling patches required.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** for lore.kernel.org/stable (HTTP 403). Web search
and the saved mbox show no stable-list discussion of this subject.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `stm32_omm_set_amcr` only. (semcode MCP not available; used hunk
headers + `rg`.)

**Step 5.2: TRACE CALLERS**
Record (verified with `rg` on `drivers/memory/stm32_omm.c`):
1. `stm32_omm_configure()` → `stm32_omm_set_amcr(dev, true)` then
   returns that `ret` (probe, full firewall access)
2. `stm32_omm_probe()` → `stm32_omm_set_amcr(dev, false)` when OMM
   access is not granted; `if (ret) return ret`
3. `stm32_omm_resume()` → `stm32_omm_set_amcr(dev, true)`; `if (ret)
   return ret`

All three are driver probe / system-resume paths, not an obscure debug
hook.

**Step 5.3: TRACE CALLEES**
Record: `of_property_match_string`, `of_parse_phandle`,
`of_address_to_resource`, `syscon_regmap_lookup_by_phandle_args`,
`regmap_update_bits` / `regmap_read`. Side effects are DT parse + AMCR
syscon R/W.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Platform probe of `compatible = "st,stm32mp25-omm"` (SoC node in
`arch/arm64/boot/dts/st/stm32mp251.dtsi`, enabled on
`stm32mp257f-ev1.dts`). Reachable on STM32MP25 boot and suspend/resume.
Not a syscall fuzzer path; hardware/DT driven.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: No second copy of this AMCR helper. Binding example uses both
`ospi1` and `ospi2` regions; in-tree board `stm32mp257f-ev1.dts` only
sets `memory-region-names = "ospi1"`. Binding **does not require**
`memory-region` (required list is
compatible/reg/clocks/resets/`st,syscfg-amcr`/ranges). Omitting `memory-
region-names` is a valid DT; the loop then never assigns `ret`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` / `make kernelversion`: **v6.18.53** (branch
  `autosel`)
- `git show v6.18.53:drivers/memory/stm32_omm.c` has `int ret, idx;` and
  `return ret` after the AMCR compare
- Driver exists in v6.18 (`git cat-file -e
  v6.18:drivers/memory/stm32_omm.c`)
- Bug introduced with the driver in v6.16 (`8181d061dcff1`)

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. The one-line `int ret, idx;` → `int ret = 0, idx;`
is present exactly once in v6.18.53. Surrounding function matches the
upstream hunk. No rework needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `git log --oneline --grep='stm32_omm' -- drivers/memory/` on
this history shows other stm32_omm error-handling fixes, but none
initialize `ret` in `stm32_omm_set_amcr` in v6.18.53. No alternate fix
for this uninit.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/memory/` STM32 Octo Memory Manager (OSPI mux / 256MB
map split on STM32MP25). Criticality: **PERIPHERAL** (SoC-specific), but
it sits under flash/OSPI bring-up for that platform, so probe/resume
failure is user-visible there.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Modest, mature-enough driver (added v6.16, a handful of follow-
up fixes). Not a staging driver. Maintainer-reviewed.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Config-specific / platform-specific: `CONFIG_STM32_OMM` on
STM32MP25 (`st,stm32mp25-omm`). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Always runs during OMM probe (and again on system resume if
  `restore_omm`).
- Uninitialized `return ret` is **guaranteed** if the memory-region loop
  never assigns `ret` (optional DT property missing or names do not
  match `ospi1`/`ospi2`) **and** AMCR equals computed `amcr` (0 when no
  ospi2 region).
- On the in-tree ev1 board, `ospi1` is present, so
  `of_address_to_resource` typically sets `ret = 0` before the AMCR
  check; the uninit is then a maybe-uninitialized / custom-DT / failed-
  phandle path. Compilers still cannot prove assignment because of the
  `continue`s.
- Not an unprivileged syscall trigger.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Returning uninitialized `int` as errno. Callers abort probe or
resume on non-zero. Failure mode: OSPI/OMM device fails to probe or
fails to resume (flash/memory-map unavailable). Severity **MEDIUM**
(wrong control-plane result / possible resume failure; not a documented
oops, but C undefined behavior). Garbage zero would incorrectly look
like success on a path that never validated regions.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: prevents UB and spurious probe/resume failures on STM32MP25
  OMM; makes the success path well-defined. Medium benefit for that
  platform, low global blast radius.
- Risk: **very low** (one initializer, no locking/API/data-structure
  change).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real uninitialized return in a function whose callers treat `ret` as
  errno
- Reachable on probe and system resume
- DT binding leaves `memory-region` optional, so the loop is allowed to
  assign nothing
- 1-line, obviously correct, reviewed by the driver maintainer, applied
  by the subsystem maintainer
- Driver and buggy code exist in this 6.18.53 tree since the driver
  landed in v6.16
- Clean apply; no prerequisites
- Matches the uninitialized-data class that stable routinely takes

AGAINST:
- STM32MP25-only (narrow user set)
- No crash log, syzbot, or user `Reported-by`
- On the one in-tree board with `memory-region-names = "ospi1"`, `ret`
  is often already 0 from `of_address_to_resource`
- Not CORE mm/net/fs

UNRESOLVED:
- Could not query lore.kernel.org/stable (403)
- No confirmed compiler-warning/KMSAN report in the thread (web-search
  snippets that mentioned kernel test robot were not backed by the
  actual mails)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one initializer; maintainer
   Reviewed-by; applied upstream
2. Fixes a real bug that affects users? **PASS** — uninitialized errno
   on OMM probe/resume
3. Important issue? **PASS** at MEDIUM — probe/resume malfunction and
   UB, not a documented panic; still a user-visible device failure mode
4. Small and contained? **PASS** — 1 line, 1 function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — v6.18.53 has the uninit
   declaration unchanged

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs patch. Closest extra: it also
silences a typical `-Wmaybe-uninitialized` shape, but the decision is on
the runtime uninit return, not on the build-fix exception.

**Step 9.4: MAKE YOUR DECISION**
Backport. The local 6.18.53 tree contains the driver and the bug; the
fix is a one-line initialization of a returned errno with essentially no
regression risk.

What this does for 6.18.y users: STM32MP25 Octo Memory Manager probe and
resume no longer return a stack-garbage error code when AMCR matches DT
and `ret` was never written. That is a real, contained correctness fix.

Risk vs benefit: benefit is defined success (`0`) vs undefined errno;
risk is a single `= 0`.

### Verification
- [Phase 1] Parsed tags: Reviewed-by Patrice Chotard, Link msgid, SOBs
  Wang + Kozlowski; no Fixes/Cc-stable/Reported-by
- [Phase 2] Diff: `int ret, idx` → `int ret = 0, idx` in
  `stm32_omm_set_amcr` only
- [Phase 2] Pre-fix function: loop may skip all `ret =
  of_address_to_resource` stores; mismatch sets `-EINVAL`; success falls
  through to `return ret`
- [Phase 3] `git blame` on parent: uninit from `8181d061dcff1` (driver
  add, 2025)
- [Phase 3] Driver in v6.16+; `git merge-base --is-ancestor
  8181d061dcff1 v6.18` true
- [Phase 3] No series/prereqs; later `6d8b18ae647bb` did not fix `ret`
- [Phase 4] `b4 dig -c 1527acf2295cf2d6e11e3e9b121d63709667e6e7`: lore
  msgid 20260617182202.961843-1
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Chotard, Kozlowski, STM32/ARM lists CC’d
- [Phase 4] mbox: Reviewed-by Chotard; Applied by Kozlowski; no NAK
- [Phase 4] lore.kernel.org WebFetch 403; used openwall + mbox instead
- [Phase 5] Callers verified: `stm32_omm_configure`, `stm32_omm_probe`,
  `stm32_omm_resume`
- [Phase 5] Binding `st,stm32mp25-omm.yaml`: `memory-region` not in
  `required:`
- [Phase 5] Board DT `stm32mp257f-ev1.dts` has only `ospi1` memory-
  region
- [Phase 6] `git describe HEAD` / Makefile: v6.18.53; `git show
  v6.18.53:drivers/memory/stm32_omm.c` still has `int ret, idx;`
- [Phase 6] Python check: old pattern present once in v6.18.53;
  initialized form absent
- [Phase 7] MAINTAINERS: Patrice Chotard owns
  `drivers/memory/stm32_omm.c`
- [Phase 8] Failure mode: garbage errno → probe/resume fail on STM32MP25
  OMM
- UNVERIFIED: stable@ mailing-list thread (lore 403); no verified
  kernel-test-robot report

**YES**

 drivers/memory/stm32_omm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/stm32_omm.c b/drivers/memory/stm32_omm.c
index 5d06623f3f689..2a1af229d2444 100644
--- a/drivers/memory/stm32_omm.c
+++ b/drivers/memory/stm32_omm.c
@@ -47,7 +47,7 @@ static int stm32_omm_set_amcr(struct device *dev, bool set)
 	struct device_node *node;
 	struct resource res, res1;
 	unsigned int syscon_args[2];
-	int ret, idx;
+	int ret = 0, idx;
 	unsigned int i, amcr, read_amcr;
 
 	for (i = 0; i < omm->nb_child; i++) {
-- 
2.53.0

