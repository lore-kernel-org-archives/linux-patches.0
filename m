Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3427854BC0B;
	Mon, 19 Oct 2026 13:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418202; cv=none; b=EPuny+YjsHlQwkpNeiPp6X3asWxkvV1yfdk7Rc8Hs/JW+cQvpUu0sQd5xSV/6YTwNvi5zlxlZ4I16eLMkwKj4KGQp6pP0bQA3I9cbJ1VuxyOuCmXSYucAAkbAkGrMyJjZidQXgf4Kqu2iLfAv/1JKycOBqrtkfp8QkF2FKhjaHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418202; c=relaxed/simple;
	bh=zbv5n/iUgw1TdOv5qfqPb2adYceNULy459/p58NA4r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1bd/wOVJHVSO4ab6bfrtKGSkS+BDUOFgKX3qs+EsIOmTOhJS83HD4XmR5H50gUjP8c0Lt2fFfTuSdkg+Y46vYwkJPtYTD2EmgsSjWDv7Co7hcxtC/yfNGnTOlYI6yCZcBUgjs8GtZ3CmLoMJIWFpTWgbzdIwEcQiRVR734CMiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFwiVWoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFwiVWoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6E01F000C4;
	Mon, 19 Oct 2026 13:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418199;
	bh=yaDvv4if2EQfZyDxwt9WaxbkScaEfCJPng9oJb9w5zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFwiVWoKItAkFqQQZJzoBiPZbAlwK8lR3MZIcTo486SUlZIAF3I8J92njvFALeHhA
	 Gnz8OGawaTC+9zTtvqP3PyXR8Qv8c362iAf5fWA9BYyK+CopGpE0ckamTkqrBIc/Wc
	 Q66ZT4cwS0X3hBVguGKd5PPUljZxDkZiw661zpnO77zUcg6eqWIc3PjDBEulP8EhRI
	 TOpl6AAWNb5W2CQH+6ukBD59cAHABbl2aXE8HifnSlFIPptXvb06u9ySmAU4pD+gPc
	 3uhpEAA6gwARBTYGwCMCXjbw364PuLWVBASjxmev12ySSmKB5cFFWEETgiNMnHRJn1
	 FAI0QlYfkeyFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amd/pm: derive stable PPT limits from PPTable
Date: Mon, 19 Oct 2026 09:46:13 -0400
Message-ID: <20261019135441.1420968-82-sashal@kernel.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 25f4a46b0c8acd77c9065b50a1fe48af27d91fdf ]

GetPptLimit reports mutable PMFW runtime state. Using that value for
static capabilities causes two externally visible problems:

- A userspace override changes the default reported through hwmon.
- A firmware reset changes the advertised minimum or maximum range.

Derive platform defaults and supported ranges from the driver PPTable
for Sienna Cichlid, Navi10, Arcturus, and Aldebaran. Reserve PMFW queries
for the effective current limit.

Runtime policy can no longer redefine immutable platform capabilities.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough from the local 6.12 tree, the sibling SMU13/SMU14
backports, and the series context to decide. The remaining lore lookups
failed with 403, so those are marked unverified.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [drm/amd/pm] [derive] [source immutable PPT default/min/max from
the driver PPTable instead of PMFW GetPptLimit]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Yang Wang <kevinyang.wang@amd.com> (author)
- Reviewed-by: Kenneth Feng <kenneth.feng@amd.com> (AMD PM reviewer)
- Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (amdgpu
  maintainer)
- No Fixes:, Reported-by, Tested-by, Link:, or Cc: stable (absence
  expected)
- Ignore Sasha Levin SOB if present (pipeline)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: GetPptLimit returns mutable PMFW runtime state, but the driver
  used that one value for current, default, min, and max.
- Symptoms: (1) a userspace power-cap override changes the default shown
  in hwmon; (2) a firmware/GPU reset changes the advertised min/max
  range.
- Failure mode: hwmon `power1_cap_default` / `power1_cap_max` /
  `power1_cap_min` stop being immutable platform capabilities. After
  reset, `smu_set_power_limit()` can reject a previously valid TDP
  because max was recomputed from the runtime value.
- Root cause: static capabilities were taken from PMFW instead of
  PPTable.
- Version info: none in the message. Upstream SHA from drm.git is
  `25f4a46b0c8acd77c9065b50a1fe48af27d91fdf` (author 2026-07-30,
  committed 2026-08-06).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit correctness fix.
Navi10/Sienna also start using AC vs DC PPTable entries, matching the
SMU13 pattern already in this tree.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- `arcturus_ppt.c` `arcturus_get_power_limit`: ~+12/-11
- `navi10_ppt.c` `navi10_get_power_limit`: ~+16/-12
- `sienna_cichlid_ppt.c` `sienna_cichlid_get_power_limit`: ~+16/-12
- `aldebaran_ppt.c` `aldebaran_get_power_limit`: ~+6/-2
- Scope: four ASIC PPT backends, one function each. Surgical, not a
  cross-subsystem refactor.

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: query GetPptLimit into `power_limit`; on failure fall back to
  PPTable; assign that same value to current, default, and (for
  Navi/Sienna) the OD min/max base.
- After: default/min/max come from PPTable (Navi/Sienna: AC or DC by
  `adev->pm.ac_power`). GetPptLimit is used only for current; on query
  failure current falls back to default.
- Arcturus: max becomes the PPTable default; min stays 0 (already true
  in this tree from `08e5f8e1a24fb`).
- Aldebaran: max already came from `pptable->PptLimit`; default now does
  too, instead of the GetPptLimit result.
- Path: init via `smu_late_init()` → `smu_get_asic_power_limits()`, and
  GPU reset via `smu_reset()` which re-runs late_init. Also used when
  Sienna/Aldebaran re-query current.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Logic / correctness] Using a mutable firmware PPT as the
immutable hwmon default/range. Fix: PPTable owns capabilities; PMFW owns
current.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct and matches `smu_v13_0_0_get_power_limit()` /
`smu_v14_0_2_get_power_limit()` already in this tree. Minimal.
Regression risk is low: Navi/Sienna now pick DC limits on battery, which
is the same rule SMU13 already uses here. Desktop `ac_power` is normally
true, so those cards keep AC limits. No API or locking changes.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: The GetPptLimit-as-everything pattern dates to `1e239fdd31cdf1`
(Evan Quan, 2020-06-08, “maximize code sharing around power limit”).
Min/max pointer args came from `1958946858a62b` (Ma Jun, 2023-10-12).
Present since well before 6.12.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. The real ancestor is the 2020 GetPptLimit
sharing, which is in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `08e5f8e1a24fb` already in this tree: Arcturus min=0 (Cc: stable).
  This patch keeps that.
- `b3498e00aff57` “fix smu13 power limit default/cap calculation” (Yang
  Wang, Cc: stable, in v6.12.94): same bug on SMU13.
- `b3adc697752b9` follow-up SMU13 range fix (Cc: stable, Closes gitlab
  5419).
- `a322d276f3d10` SMU14 range fix (Cc: stable).
- This candidate is the remaining SMU11/Aldebaran analog; not already
  applied (`git merge-base --is-ancestor 25f4a46b0c8acd HEAD` failed).

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Yang Wang is a regular amd/pm contributor in this tree
(SMU13/SMU14 power-limit fixes, pptable UAF, metrics). Kenneth Feng
reviewed those as well.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Standalone. No new helpers. `SocketPowerLimitDc`,
`GET_PPTABLE_MEMBER`, and `adev->pm.ac_power` already exist here. Later
drm-next-7.3 series (refactor by controller, OD percentage,
save/restore, restore after reset) is a large follow-on and is not
required for this hunk.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 25f4a46b0c8acd77c9065b50a1fe48af27d91fdf`: lore.kernel.org
  returned server error; no match.
- lore.kernel.org WebFetch: 403.
- drm.git commit page confirms SHA, author, reviewer, committer.
- amd-gfx July 2026: related 4-patch “refactor PPT limit runtime policy”
  (Kenneth Feng reviewed). “derive stable PPT limits from PPTable” is
  listed first among Yang Wang’s five commits in the amd-drm-next-7.3
  pull (mail-archive).
- UNVERIFIED: full review thread / NAKs / explicit Cc: stable for this
  exact patch (lore 403).

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Kenneth Feng Reviewed-by; Alex Deucher signed off. Recipients
from `b4 dig -w` unverified.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by on this commit. Sibling SMU13 fix closed
https://gitlab.freedesktop.org/drm/amd/-/work_items/5227 (WebFetch 403;
title/body unverified). Follow-up closed work item 5419.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: First of five PPT commits in amd-drm-next-7.3. Later four are a
large policy refactor. This patch is self-contained.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED for this SHA (lore 403). The same class of fix for
SMU13/SMU14 already landed in this 6.12 tree with Cc: stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `arcturus_get_power_limit`, `navi10_get_power_limit`,
`sienna_cichlid_get_power_limit`, `aldebaran_get_power_limit`.

Step 5.2: TRACE CALLERS
Record: Registered as `.get_power_limit` in each ppt_funcs table.
Invoked via `smu_get_asic_power_limits()` from:
- `smu_late_init()` (boot and `smu_reset()`), filling
  `smu->{current,default,max,min}_power_limit`
- `smu_get_power_limit()` for CURRENT on Sienna-family (11.0.7/11/12/13)
  and Aldebaran (13.0.2)
Hwmon `power1_cap{,_default,_max,_min}` goes
`amdgpu_hwmon_show_power_cap_*` → `amdgpu_dpm_get_power_limit` →
`smu_get_power_limit`. Sets are range-checked against cached
`max_power_limit`/`min_power_limit` in `smu_set_power_limit()`.

Step 5.3: TRACE CALLEES
Record: `smu_v11_0_get_current_power_limit()` /
`smu_cmn_send_smc_msg(SMU_MSG_GetPptLimit)` for current only; PPTable
fields for defaults.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace-reachable via hwmon sysfs (typically root). GPU reset
/ late_init also refresh the caches. Reachable on Navi10 (RX 5700),
Sienna (RX 6800/6900, 6000M), Arcturus (MI100), Aldebaran (MI200).

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: SMU13 (`smu_v13_0_0`, `smu_v13_0_7`) and SMU14 (`smu_v14_0_2`)
already use PPTable + AC/DC for default/min/max in this tree. These four
backends were the leftover GetPptLimit-for-everything copies.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is **pending-6.12 / 6.12.111**
(`p-6.12-3-g88406e77611c6`). The four `*_get_power_limit` functions
match the patch “before” side. Bug introduced ~2020 (`1e239fdd31cdf1`),
long before 6.12.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply expected. Navi10 context below the hunk differs
(`MAX_PCIE_CONF` vs `NUM_LINK_LEVELS`) but that is outside this
function. Arcturus min=0 already present.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: SMU13/SMU14 analogs are here; these four ASICs are not. No
earlier version of this exact change.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drm/amd/pm SWSMU] [IMPORTANT] — common AMD dGPU/instinct power
management, not core mm/net, but widely used hardware.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained; recent 6.12.y already took SMU13/SMU14
power-limit correctness fixes from the same author.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific: Navi10/Navi14, Sienna Cichlid family, Arcturus,
Aldebaran. Anyone using hwmon power cap (LACT, CoreCtrl, scripts) or
hitting GPU reset.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Always at `smu_late_init` if PMFW current ≠ PPTable default (boot
  power source / firmware policy).
- GPU reset (`smu_reset` → late_init) refreshes default/max/min from
  GetPptLimit, so a runtime policy or leftover firmware value rewrites
  advertised range.
- In this 6.12 tree, DEFAULT/MAX/MIN hwmon reads use the cache, so a
  live userspace write to `power1_cap` does not immediately rewrite
  `power1_cap_default` unless late_init/reset re-runs. The commit’s
  first symptom is therefore mainly boot/reset, not every write. Still a
  real bug.
- Trigger is privileged sysfs or reset, not an unprivileged crash
  primitive.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Incorrect hwmon capabilities; after reset,
`smu_set_power_limit()` can reject a previously legal TDP because max
was derived from the runtime PPT. No oops/UAF/corruption. Severity:
MEDIUM (functional / ABI), same class already accepted for this tree on
SMU13.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: Benefit medium-high for affected GPUs (correct caps, no trapped
range after reset). Risk low (~40 net lines, four isolated functions,
established pattern). Ratio favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real bug: mutable PMFW state used as immutable hwmon default/min/max.
- After GPU reset, cached max/min can shrink and block restoring the
  platform TDP.
- Same class already backported to this 6.12 tree for SMU13/SMU14
  (`b3498e00aff57`, `b3adc697752b9`, `a322d276f3d10`), all Cc: stable.
- Small, obviously correct, no new APIs.
- Buggy code is in this tree; patch applies cleanly.
- Reviewed by Kenneth Feng, signed off by Alex Deucher.

AGAINST:
- Not a crash, security hole, or data corruption.
- First of a later 5-commit PPT series; later patches are large
  refactors (do not take those).
- Navi/Sienna AC/DC selection is extra vs the old always-AC fallback
  (same as already-stable SMU13).
- No Fixes:/Reported-by on this commit; lore thread unverified.

UNRESOLVED:
- Full amd-gfx review text / NAKs (lore 403, b4 failed).
- GitLab 5227 details (403).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — matches SMU13/14 in this tree;
   AMD reviewer + maintainer.
2. Fixes a real bug that affects users? PASS — wrong hwmon caps; reset
   can trap the power range.
3. Important issue? PASS — not a panic, but the same issue was already
   treated as stable-worthy here for newer ASICs; user-visible PM/sysfs
   breakage on common GPUs.
4. Small and contained? PASS — four functions, ~70 lines.
5. No new features or APIs? PASS — corrects existing hwmon values; AC/DC
   uses existing PPTable fields.
6. Can apply to the local tree? PASS — buggy code present; clean apply
   expected.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None of the automatic exceptions (device ID / quirk / DT / build
/ docs). Qualifies as a normal small correctness fix.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.12 tree. It is the leftover
SMU11/Aldebaran half of a power-cap reporting bug whose SMU13/SMU14 half
is already in 6.12.y. Do not pull the later PPT refactor series with it.

Verification:
- [Phase 1] Parsed tags: author Yang Wang, Reviewed-by Kenneth Feng, SOB
  Alex Deucher; no Fixes/Reported-by/Cc stable
- [Phase 1] drm.git SHA 25f4a46b0c8acd77c9065b50a1fe48af27d91fdf
  confirmed via search snippet
- [Phase 2] Diff: four `*_get_power_limit` functions; PPTable for
  default/min/max, GetPptLimit only for current
- [Phase 3] git describe HEAD: p-6.12-3-g88406e77611c6; make
  kernelversion 6.12.111
- [Phase 3] git merge-base --is-ancestor 25f4a46b0c8acd HEAD: not an
  ancestor (not in this tree)
- [Phase 3] git blame: GetPptLimit pattern from 1e239fdd31cdf1 (2020);
  still present in all four files
- [Phase 3] Related stable commits in this tree: b3498e00aff57
  (v6.12.94), b3adc697752b9, a322d276f3d10, 08e5f8e1a24fb
- [Phase 4] b4 dig -c 25f4a46b0c8acd: lore server error, no match
- [Phase 4] lore WebFetch 403; gitlab 5227 403
- [Phase 4] amd-gfx July 2026: 4-patch PPT refactor series by same
  author; drm-next-7.3 pull lists this commit first of five
- [Phase 5] Callers: smu_late_init, smu_reset, smu_get_power_limit,
  hwmon power1_cap*; range check in smu_set_power_limit
- [Phase 5] SMU13/SMU14 in this tree already implement the post-fix
  pattern
- [Phase 6] Read all four local functions: match the patch “before” side
- [Phase 6] GET_PPTABLE_MEMBER and SocketPowerLimitDc exist for Sienna
  and Beige Goby
- [Phase 8] Failure mode: wrong hwmon caps / possible -EINVAL on set
  after reset; not oops
- UNVERIFIED: original lore discussion, NAKs, gitlab 5227 body, whether
  SocketPowerLimitDc is zero on any Navi10 mobile SKU

This is a small, already-reviewed correction of hwmon PPT
default/min/max on GPUs that still use GetPptLimit for those values. The
same bug was already backported on SMU13/SMU14 in this 6.12 tree, the
code is present, and the follow-on refactor series is not required.

**YES**

 .../gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c | 25 ++++++++-------
 .../gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c   | 32 +++++++++++--------
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 28 +++++++++-------
 .../drm/amd/pm/swsmu/smu13/aldebaran_ppt.c    |  8 +++--
 4 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 4fff78da81ff8..2b2d3c3aa20ba 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1329,24 +1329,25 @@ static int arcturus_get_power_limit(struct smu_context *smu,
 					uint32_t *min_power_limit)
 {
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
-	uint32_t power_limit;
+	uint32_t current_limit, default_limit;
 
-	if (smu_v11_0_get_current_power_limit(smu, &power_limit)) {
-		/* the last hope to figure out the ppt limit */
-		if (!pptable) {
-			dev_err(smu->adev->dev, "Cannot get PPT limit due to pptable missing!");
-			return -EINVAL;
-		}
-		power_limit =
-			pptable->SocketPowerLimitAc[PPT_THROTTLER_PPT0];
+	if (!pptable) {
+		dev_err(smu->adev->dev,
+			"Cannot get PPT limit due to pptable missing!");
+		return -EINVAL;
 	}
 
+	default_limit = pptable->SocketPowerLimitAc[PPT_THROTTLER_PPT0];
+
+	if (smu_v11_0_get_current_power_limit(smu, &current_limit))
+		current_limit = default_limit;
+
 	if (current_power_limit)
-		*current_power_limit = power_limit;
+		*current_power_limit = current_limit;
 	if (default_power_limit)
-		*default_power_limit = power_limit;
+		*default_power_limit = default_limit;
 	if (max_power_limit)
-		*max_power_limit = power_limit;
+		*max_power_limit = default_limit;
 	/*
 	 * No lower bound is imposed on the limit. Any unreasonable limit set
 	 * will result in frequent throttling.
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index a2fcf678182b4..4737ceb2a5434 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2393,22 +2393,26 @@ static int navi10_get_power_limit(struct smu_context *smu,
 		(struct smu_11_0_powerplay_table *)smu->smu_table.power_play_table;
 	struct smu_11_0_overdrive_table *od_settings = smu->od_settings;
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
-	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
+	uint32_t current_limit, default_limit;
+	uint32_t od_percent_upper = 0, od_percent_lower = 0;
 
-	if (smu_v11_0_get_current_power_limit(smu, &power_limit)) {
-		/* the last hope to figure out the ppt limit */
-		if (!pptable) {
-			dev_err(smu->adev->dev, "Cannot get PPT limit due to pptable missing!");
-			return -EINVAL;
-		}
-		power_limit =
-			pptable->SocketPowerLimitAc[PPT_THROTTLER_PPT0];
+	if (!pptable) {
+		dev_err(smu->adev->dev,
+			"Cannot get PPT limit due to pptable missing!");
+		return -EINVAL;
 	}
 
+	default_limit = smu->adev->pm.ac_power ?
+		pptable->SocketPowerLimitAc[PPT_THROTTLER_PPT0] :
+		pptable->SocketPowerLimitDc[PPT_THROTTLER_PPT0];
+
+	if (smu_v11_0_get_current_power_limit(smu, &current_limit))
+		current_limit = default_limit;
+
 	if (current_power_limit)
-		*current_power_limit = power_limit;
+		*current_power_limit = current_limit;
 	if (default_power_limit)
-		*default_power_limit = power_limit;
+		*default_power_limit = default_limit;
 
 	if (powerplay_table) {
 		if (smu->od_enabled &&
@@ -2422,15 +2426,15 @@ static int navi10_get_power_limit(struct smu_context *smu,
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
-					od_percent_upper, od_percent_lower, power_limit);
+		 od_percent_upper, od_percent_lower, default_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = power_limit * (100 + od_percent_upper);
+		*max_power_limit = default_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
 	if (min_power_limit) {
-		*min_power_limit = power_limit * (100 - od_percent_lower);
+		*min_power_limit = default_limit * (100 - od_percent_lower);
 		*min_power_limit /= 100;
 	}
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 31c2c0386b1f9..d553c6fbab47c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -632,20 +632,24 @@ static int sienna_cichlid_get_power_limit(struct smu_context *smu,
 	struct smu_11_0_7_powerplay_table *powerplay_table =
 		(struct smu_11_0_7_powerplay_table *)smu->smu_table.power_play_table;
 	struct smu_11_0_7_overdrive_table *od_settings = smu->od_settings;
-	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
-	uint16_t *table_member;
+	uint32_t current_limit, default_limit;
+	uint32_t od_percent_upper = 0, od_percent_lower = 0;
+	u16 *power_limit_ac, *power_limit_dc;
 
-	GET_PPTABLE_MEMBER(SocketPowerLimitAc, &table_member);
+	GET_PPTABLE_MEMBER(SocketPowerLimitAc, &power_limit_ac);
+	GET_PPTABLE_MEMBER(SocketPowerLimitDc, &power_limit_dc);
 
-	if (smu_v11_0_get_current_power_limit(smu, &power_limit)) {
-		power_limit =
-			table_member[PPT_THROTTLER_PPT0];
-	}
+	default_limit = smu->adev->pm.ac_power ?
+		power_limit_ac[PPT_THROTTLER_PPT0] :
+		power_limit_dc[PPT_THROTTLER_PPT0];
+
+	if (smu_v11_0_get_current_power_limit(smu, &current_limit))
+		current_limit = default_limit;
 
 	if (current_power_limit)
-		*current_power_limit = power_limit;
+		*current_power_limit = current_limit;
 	if (default_power_limit)
-		*default_power_limit = power_limit;
+		*default_power_limit = default_limit;
 
 	if (powerplay_table) {
 		if (smu->od_enabled &&
@@ -659,15 +663,15 @@ static int sienna_cichlid_get_power_limit(struct smu_context *smu,
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
-					od_percent_upper, od_percent_lower, power_limit);
+		 od_percent_upper, od_percent_lower, default_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = power_limit * (100 + od_percent_upper);
+		*max_power_limit = default_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
 	if (min_power_limit) {
-		*min_power_limit = power_limit * (100 - od_percent_lower);
+		*min_power_limit = default_limit * (100 - od_percent_lower);
 		*min_power_limit /= 100;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 18d5d07045098..9e67e57d70b75 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1281,8 +1281,12 @@ static int aldebaran_get_power_limit(struct smu_context *smu,
 
 	if (current_power_limit)
 		*current_power_limit = power_limit;
-	if (default_power_limit)
-		*default_power_limit = power_limit;
+	if (default_power_limit) {
+		if (pptable)
+			*default_power_limit = pptable->PptLimit;
+		else
+			*default_power_limit = power_limit;
+	}
 
 	if (max_power_limit) {
 		if (pptable)
-- 
2.53.0

