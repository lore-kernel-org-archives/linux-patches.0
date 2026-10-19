Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485FE4FDE4B;
	Mon, 19 Oct 2026 14:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418407; cv=none; b=cX4fXslTPWOyNZ8eAHrLihyVWJmGGd/3Z9AxhF0bCiknWX1q95R8QAdlkzQ9jXwRPaQDI9i+xmxfyvSytzh7K2kdPCEO72q4YzW2jbW4XWrblgRD84MCvCo5bxI1b9keNxC3JkrSSY4UFSKFCS9zFIQveq0ylo218pNWs3/gvhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418407; c=relaxed/simple;
	bh=IZWNaEFy+vY5C5AJXWKzEJzAjsoe+9+GeXh452giMLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p0yg+XGVdksGXDybVDDnjyNd+TOncs4CYg/ygxrQqhJKA83ZE6ga1mBnTENE/WIGcPMdB45R+uzhXVmzXCZpE9LSPRl6fpNhY2w7MOtbGTcQ4S5/KvCl6U8Rf8hLa//KDRB0vWsXes8oOAzwfPey7iZ0iJUtfrS/VFPGip1ksK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jc0iYWRe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jc0iYWRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E881F000C6;
	Mon, 19 Oct 2026 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418405;
	bh=qPK7eRR5HbyiUFAa0HzwzZPTXxjO1dsWLmNEqD8bbuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jc0iYWReAF3VpUaWLIaCry8F5gZhFa2/CWHEg4Nx7VivaQXW/QeXRiUm8QSfM1sb6
	 uqc83T+3Mkpu9IFyHuHLCpFwTbRhGdJOniqI/bKEm8/frPCvdpnAt3bMVl4ziXTFC2
	 i6PmQl0BpNlvYbvn9qNgnvNeP5EnyhqxcCYFJZSK+kt+wEmdM1FZb37RajosSyjU6D
	 OqWcKm/Owcd9A2myHCpHnVSrujmAq/WKOpzWFoOFOgqXONWmjk62UYEBx7H4xW5OrE
	 bmo8OqbpcFrw+Sw1jep1A7I1htb5naG1K9DjCDUAiHnPF6e/hywL2ovw8nL2cK8bOb
	 xvww/R+Qugv9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amd/pm: validate vega10 profile mode inputs
Date: Mon, 19 Oct 2026 09:48:37 -0400
Message-ID: <20261019135441.1420968-226-sashal@kernel.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit bf939f2a1687ef4ab815640096357f8ef5bd5fb6 ]

Check for out of range profile modes and custom params that exceed 8 bits.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. Vega10 still accepts out-of-range
`pp_power_profile_mode` sysfs values and silently truncates custom DPM
bytes before they are sent to SMU.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [drm/amd/pm] [validate] [reject out-of-range Vega10 power
profile modes and custom params wider than 8 bits]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Lijo Lazar <lijo.lazar@amd.com> (author)
- Reviewed-by: Asad Kamal <asad.kamal@amd.com>
- Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (AMDGPU
  maintainer)
- No Fixes:, Reported-by, Tested-by, Link:, or Cc: stable (absence is
  expected)
- Ignore pipeline tags: [Upstream commit
  bf939f2a1687ef4ab815640096357f8ef5bd5fb6], Signed-off-by: Sasha Levin

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record: [Bug: Vega10 profile-mode setter does not reject invalid modes
or custom params that do not fit in 8 bits] [Symptom: invalid SMU
SetWorkloadMask / SetCustomGfxDpmParameters programming; silent uint8_t
truncation] [No version info in the message] [Root cause implied:
missing bounds checks before SMC messages]

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. The subject is explicitly “validate”. This is
input validation before firmware commands, not style cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record: [drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c: +9 / -0]
[vega10_set_power_profile_mode()] [single-file surgical fix]

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Hunk 1: After `power_profile_mode = input[size]`, if mode >
  PP_SMC_POWER_PROFILE_CUSTOM (6), log and return -EINVAL. Before: any
  mode fell through to `1 << power_profile_mode` (or `1 << (mode-1)`) as
  PPSMC_MSG_SetWorkloadMask, then stored in `hwmgr->power_profile_mode`.
- Hunk 2: For CUSTOM with size==4, reject any of input[0..3] with bits
  above 7 set. Before: those `long` values were assigned through uint8_t
  (`busy_set_point` etc. and `custom_profile_mode[]` which is
  `uint8_t[4]`), then packed into a 32-bit SMC parameter. Values >255 or
  negative were truncated.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Logic / bounds / firmware-input validation]
- Missing range check: userspace sysfs can supply modes 7–9
  (WINDOW3D/CAPPED/UNCAPPED exist in the shared enum but Vega10’s table
  only lists 0–CUSTOM). Those become invalid SMU workload bits.
- Missing 8-bit check: custom DPM fields are 8-bit hardware parameters;
  overflow was silently truncated into the packed SMC word.

Step 2.4: ASSESS THE FIX QUALITY
Record: [Obviously correct and minimal. Same `>
PP_SMC_POWER_PROFILE_CUSTOM` guard already exists in
vega20_set_power_profile_mode.] [Regression risk very low: only invalid
writes return -EINVAL; legal modes 0–6 and 8-bit custom params are
unchanged.] No public API or data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Function introduced in 6390258a2f1390 (“drm/amd/pp: Add custom
power profile mode support on Vega10”, 2018-02-19, contained in
v4.17-rc1). Profile mode taken from `input[size]` in e815a9e62b3225
(Evan Quan, 2019). Unconditional `1 << power_profile_mode` SMU send from
3919a485187a85 / fe122ee5428293 (Kenneth Feng, 2021). The buggy pattern
has been in this family of kernels for years, including 6.18.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. N/A. The missing checks are original to this
setter, not a recent regression.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent vega10_hwmgr.c work is other bounds checks (OD DPM
triples, voltage index). This patch is standalone, not “patch X/Y”. No
prerequisite refactor required for these two ifs.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Lijo Lazar is a regular AMD PM contributor (161 commits under
drivers/gpu/drm/amd/pm/ in this tree). Applied by Alex Deucher. Related
author work is other PM validation, not a coupled series for this
function.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Uses existing PP_SMC_POWER_PROFILE_CUSTOM, pr_err, and the
existing uint8_t packing. Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
[https://patch.msgid.link/20260618053650.937168-1-lijo.lazar@amd.com]
[v1 only; committed version matches v1] [Asad Kamal: Reviewed-by; no
other technical discussion] [No Cc: stable in review] [No NAKs]

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients: amd-gfx, Hawking Zhang, Alexander Deucher, Asad
Kamal, Candice Li. Reviewer Asad Kamal (AMD). Maintainer Alex Deucher
signed off on merge.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by / Link / syzbot. No separate bugzilla. The
submission itself is the only write-up.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone one-patch series. Vega20 already had the equivalent
mode check (present after e098bc9612c2b, 2020 layout move). smu7 uses a
switch on known modes so invalid values are not turned into SMU
bitmasks.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable returned HTTP 403; UNVERIFIED whether it
was discussed on stable@. No evidence in the amd-gfx thread of a stable
NAK.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: vega10_set_power_profile_mode()

Step 5.2: TRACE CALLERS
Record:
- Registered as hwmgr_func.set_power_profile_mode.
- pp_set_power_profile_mode() → amdgpu_dpm_set_power_profile_mode() →
  amdgpu_set_pp_power_profile_mode() (sysfs `pp_power_profile_mode`,
  S_IRUGO|S_IWUSR). This is the untrusted path: first character parsed
  with kstrtol, so modes 0–9 are reachable; CUSTOM then parses extra
  longs into parameter[].
- pp_dpm_switch_power_profile() already rejects `!(type <
  PP_SMC_POWER_PROFILE_CUSTOM)` before calling.
- pp_psm.c uses internal workload_setting[] values, not raw sysfs.

Step 5.3: TRACE CALLEES
Record: smum_send_msg_to_smc_with_parameter() with
PPSMC_MSG_SetCustomGfxDpmParameters and PPSMC_MSG_SetWorkloadMask. Those
talk to Vega10 SMU firmware.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace write to
`/sys/class/drm/cardX/device/pp_power_profile_mode` (typically root) →
amdgpu_pm.c store → powerplay → vega10_set_power_profile_mode. Reachable
from userspace. Not a syscall for unprivileged users (owner-write
sysfs).

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: vega20_hwmgr.c already has `if (power_profile_mode >
PP_SMC_POWER_PROFILE_CUSTOM)`. Newer swsmu paths also bound profile
types. Vega10 was the gap among powerplay Vega setters that shift the
mode into an SMU mask.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is 6.18.53 (`VERSION=6 PATCHLEVEL=18
SUBLEVEL=53`, `git describe` v6.18.53-5049-g0f0bdc2b0dffb). v6.18.53’s
vega10_set_power_profile_mode has no range check and no 8-bit check
(function at line 5400). Bug dates to 2018/2019/2021 code, long before
6.18.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: [clean apply with line offset]. Context at v6.18.53 matches the
patch hunks; only the @@ line number differs (5407 vs original 5216). No
conflicting refactor in this file for these lines.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No equivalent Vega10 profile-mode validation in v6.18.53. Vega20
already has the mode check. No earlier version of this exact fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drm/amd/pm powerplay Vega10] [IMPORTANT: discrete GPU driver,
not core mm/fs, but Vega 56/64 / Frontier / MI25 still in production
use]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature Vega10 powerplay; most recent file changes are bounds-
checking, not feature work. Bug is old, not a last-month introduction.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: [driver-specific] Vega10 amdgpu + CONFIG powerplay users who
write `pp_power_profile_mode`.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Write an out-of-range mode (7/8/9) or CUSTOM params >255 /
negative while DPM is manual. Common for tuning tools (and easy to
mistype). Root-only sysfs store; not unprivileged. Not a race.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Invalid SMU workload mask / silently truncated custom DPM bytes
→ wrong clocks/heuristics; possible SMU/GPU misbehavior. Not a
demonstrated KASAN crash. [Severity: MEDIUM, HIGH if SMU rejects poorly
and the GPU hangs — hang not confirmed in mailing list]

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: [Benefit: medium — stops firmware-facing bad input on a real
sysfs ABI] [Risk: very low — +9 lines, reject-only] [Ratio: favorable]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real missing validation on a documented userspace sysfs ABI
- Invalid modes become `1 << mode` SMU SetWorkloadMask; Vega10 has no
  switch/default to ignore them (smu7 does; vega20 already range-checks)
- Custom params are 8-bit hardware fields packed into one SMC dword;
  overflow was silent truncation
- Tiny, obviously correct, no new API
- Code and bug exist in this 6.18.53 tree; applies with offset only
- Reviewed and merged by AMD GPU maintainers

AGAINST:
- No crash report, syzbot, or Fixes: tag
- Sysfs is owner-writable (typically root), not an unprivileged UAF
- Commit message does not document a hang/CVE
- From the current first-character sysfs parser, mode cannot exceed 9,
  so the shift is not C UB; the issue is invalid firmware bits, not a
  kernel OOB

UNRESOLVED:
- Whether invalid SetWorkloadMask actually hangs Vega10 SMU (not
  documented on list)
- Whether stable@ discussed this (lore.kernel.org/stable HTTP 403)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — two straightforward -EINVAL
   guards; Reviewed-by + maintainer SOB
2. Fixes a real bug that affects users? PASS — sysfs can program SMU
   with out-of-range profile/custom values
3. Important issue? PASS (MEDIUM, firmware/GPU misprogramming; not a
   confirmed panic, but hardware-command validation on a user ABI)
4. Small and contained? PASS — +9 lines, one function
5. No new features or APIs? PASS
6. Can apply to the local tree? PASS — buggy function present on
   6.18.53; context matches

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/doc exception. Ordinary driver
bounds-check fix.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.18.y tree. The bug is present here,
the fix is surgical, valid userspace is unaffected, and leaving it out
keeps a userspace-to-SMU hole that sibling Vega20 code already closed.

What problem this solves for stable users:
On Vega10, writing `pp_power_profile_mode` with a mode above CUSTOM, or
CUSTOM heuristics that do not fit in 8 bits, is accepted and forwarded
to SMU. That can select a nonsense workload bit or pack truncated DPM
parameters. 6.18 still ships that path; the patch only fails those
writes with -EINVAL.

Risk vs benefit:
Benefit is correct firmware programming on a real sysfs control. Risk is
negligible.

Concerns:
None that block backport. Cherry-pick needs only hunk offset (line 5407
vs 5216). No extra commits required.

Verification:
- [Phase 1] Parsed tags: author Lijo Lazar, Reviewed-by Asad Kamal, SOB
  Alex Deucher; no Fixes/Reported-by/Link/Cc:stable
- [Phase 2] Diff: +9 lines in vega10_set_power_profile_mode; mode >
  CUSTOM → -EINVAL; custom input[0..3] & ~0xFF → -EINVAL
- [Phase 2] custom_profile_mode is uint8_t[4] in vega10_hwmgr.h:386;
  packing uses uint8_t then <<8/16/24
- [Phase 3] git blame on parent: function 6390258a2f1390 (v4.17); SMU
  shift 3919a485187a85 (2021)
- [Phase 3] No Fixes: tag
- [Phase 3] git log --author="Lijo Lazar" -- drivers/gpu/drm/amd/pm/:
  161 commits
- [Phase 4] b4 dig -c bf939f2a1687:
  https://patch.msgid.link/20260618053650.937168-1-lijo.lazar@amd.com
- [Phase 4] b4 dig -a: v1 only
- [Phase 4] b4 dig -w: amd-gfx + AMD PM maintainers
- [Phase 4] mbox: Asad Kamal Reviewed-by; no NAK; no stable mention
- [Phase 4] lore.kernel.org/stable: HTTP 403 — UNVERIFIED
- [Phase 5] Callers: sysfs amdgpu_set_pp_power_profile_mode (S_IWUSR);
  pp_dpm_switch_power_profile already bounds type; pp_psm uses internal
  tables
- [Phase 5] amdgpu_pm.c:1384 only special-cases CUSTOM; other modes skip
  extra parsing; tmp[0] is first character so sysfs modes are 0–9
- [Phase 5] vega20 already has the same mode > CUSTOM check at
  vega20_hwmgr.c:4097
- [Phase 6] git describe HEAD: v6.18.53-5049-g0f0bdc2b0dffb; make
  kernelversion 6.18.53
- [Phase 6] git grep on v6.18.53: no range check in vega10_hwmgr.c
- [Phase 6] Function text on v6.18.53 matches the patch pre-image
  (offset only)
- [Phase 6] git merge-base --is-ancestor bf939f2a1687 HEAD: not an
  ancestor (mainline commit not in 6.18.y history)
- [Phase 8] Failure mode: invalid SMU commands / truncated DPM bytes;
  sysfs root-writable; severity MEDIUM
- UNVERIFIED: actual Vega10 SMU hang on bad SetWorkloadMask; stable@
  discussion (HTTP 403)

**YES**

 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index d6aaba0b3613d..84c777fde62f5 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5406,6 +5406,11 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 	uint8_t min_active_level;
 	uint32_t power_profile_mode = input[size];
 
+	if (power_profile_mode > PP_SMC_POWER_PROFILE_CUSTOM) {
+		pr_err("Invalid power profile mode %u\n", power_profile_mode);
+		return -EINVAL;
+	}
+
 	if (power_profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) {
 		if (size != 0 && size != 4)
 			return -EINVAL;
@@ -5421,6 +5426,10 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 				return -EINVAL;
 		}
 
+		if ((input[0] & ~0xFF) || (input[1] & ~0xFF) ||
+		    (input[2] & ~0xFF) || (input[3] & ~0xFF))
+			return -EINVAL;
+
 		data->custom_profile_mode[0] = busy_set_point = input[0];
 		data->custom_profile_mode[1] = FPS = input[1];
 		data->custom_profile_mode[2] = use_rlc_busy = input[2];
-- 
2.53.0

