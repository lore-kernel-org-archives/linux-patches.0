Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A5E526088;
	Mon, 19 Oct 2026 14:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418558; cv=none; b=fCt9q0RRPiKlowDE34yFe050HS6dddVfaLABV/LAjWyoXoe2WWJlLmZT4XoblYLPFlfXgjottOFDLkYRBYAUp2qQV8clQknuqqWycxb9dsi9XCkvbhP2n14VW9xGakOlutYZA6n+9jaYdDgznsKG2HYbxPVT8/4G3ORa5lZrj/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418558; c=relaxed/simple;
	bh=YjaW7hvY/Q1t4ehpefr0Pa9tbJyktpHRNTzBtEnk2HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9geffFnt/3p/gWn6tE5fZ6TtXqAVsuXBH3jAFNEbSxp7rpmr9L/6jl3J6lbvJZadfRf5VOjkoM38ni3NKgxGYFzOaJAX4sfObifvySk3umzWN8w5cm/9urb8N87c9XKxdTRNBeevVKTE4FeNMiXxlatRZC2Hj0i/NmyVHYOcPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0fd+Sz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0fd+Sz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405041F000C9;
	Mon, 19 Oct 2026 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418556;
	bh=pq/wQvQNe/nJmYgSNvMIlWf3rnE0y071HJ7w5F2PN+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0fd+Sz6ibGyIiZL/dfApOXK5GFGjStPKBnx6o2dwNFcy9K9Z2rlDw8QDUCevFuIf
	 FW5ca/5IkvZbnsZkCtvwyUrEfIAuMcXelt0F+Nv/GS+xmobYRmyIRUKt8tMoRVRArc
	 NcR4xkDikqEe6JLaweidMkr29PpTu17D8hxrZDGOMH0L8Nviitq3aPd27xnc+tW6qY
	 U5cFUVP7xzvlbabHG1QzUBDstIrN026bJffKsdaFX3Rhz45FaPPMZAZ/zAIXNl5ree
	 y7aDyDTisJzcHX8dPTF0uEux85hEM2XhYEqrpvgxzm/s7Nl6litPtJcEYChAdwkYbK
	 o82ERl5rAwMWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/etnaviv: check MMUv2 status after reset
Date: Mon, 19 Oct 2026 09:50:23 -0400
Message-ID: <20261019135441.1420968-332-sashal@kernel.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 4720915ab48282429f9e22ad5984b7870e4e962c ]

A full GPU reset is the only way to disable the MMUv2 and the
driver depends on the MMU being disabled after a reset to be able
to properly restart the GPU. Validate this assumption by checking
that the reset actually did disable the MMU.

Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Link: https://patch.msgid.link/20260511085148.652256-2-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4**. The etnaviv reset path is present here;
this patch closes a hole in how reset success is detected so hang
recovery can reprogram MMUv2.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/etnaviv] [check] [verify MMUv2 is actually disabled after
GPU reset]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Reviewed-by: Christian Gmeiner \<cgmeiner@igalia.com\> (etnaviv
  reviewer in MAINTAINERS)
- Link: https://patch.msgid.link/20260511085148.652256-2-
  l.stach@pengutronix.de (series 2/2)
- Signed-off-by: Lucas Stach \<l.stach@pengutronix.de\> (etnaviv
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, or Cc: stable (absence of
  Fixes/Cc:stable is expected for this review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record: [Bug] After a full GPU reset the driver assumes MMUv2 is off so
it can restart the GPU. [Symptom] If that is false, restart proceeds
with MMU still enabled. [Versions] None stated. [Root cause] Reset
success was inferred from idle bits only; MMU ENABLE was never checked.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Yes. Wording is “validate this assumption,” but it is a missing
success check on a load-bearing invariant: restore skips reprogramming
if ENABLE is still set.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record: `drivers/gpu/drm/etnaviv/etnaviv_gpu.c` +17/−0. Function:
`etnaviv_hw_reset()`. Single-file surgical fix.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before: after idle/2D/3D checks, reset is treated as success.
After: on MMUv2 cores, if `VIVS_MMUv2_CONTROL_ENABLE` /
`VIVS_MMUv2_SEC_CONTROL_ENABLE` is still set, retry until timeout then
`-EBUSY`. Affects probe reset and hang-recovery reset.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: [Logic / correctness] Reset retry loop did not confirm MMU
disable. `etnaviv_iommuv2_restore_{nonsec,sec}()` returns immediately if
ENABLE is set (“state is still there”). After reset the driver drops
`gpu->mmu_context`. If ENABLE is still set, restore skips page-table
reload and the FE is started against stale MMU state.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct; matches existing idle retry. Regression risk:
stricter success could yield more `-EBUSY` if ENABLE is sticky. That is
better than proceeding with MMU still on. Maintainer-authored; low risk.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Reset retry exists since `a8c21a5451d83` (etnaviv initial
driver, v4.5). MMUv2 restore early-return is `afb7b3b1deb47` (v4.8-rc1).
Hole is long-standing.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. N/A.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Patch 1/2 is `1006d1f7c03d9` (“check all modules for idle after
reset”) — sibling robustness, not required for this hunk. Related
stable-bound history: `725cbc7884c37` (MMU state lost on reset),
`f978a5302f556` (MMU context leak on reset), `8f3eea9d01d7b` (keep MMU
across runtime PM because that path avoids full reset). Standalone vs
series: series 2/2, self-contained.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Lucas Stach is listed maintainer of “DRM DRIVERS FOR VIVANTE GPU
IP”. Christian Gmeiner is a listed reviewer. Same author wrote the 2021
MMU-reset invariant patches.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `gpu_read`, `chipMinorFeatures1_MMU_VERSION`,
`ETNA_SEC_KERNEL`, and MMUv2 registers. No new helpers. Can apply
standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record: [Lore]
https://patch.msgid.link/20260511085148.652256-2-l.stach@pengutronix.de
[Revisions] v1 only (b4 dig -a).
[Review] Christian Gmeiner Reviewed-by; no NAK, no stable nomination, no
risk discussion. Direct lore.kernel.org fetch returned 403 (Anubis);
thread recovered via `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To: etnaviv@lists.freedesktop.org; Cc: dri-devel, Christian
Gmeiner. Right lists and reviewer.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, bugzilla, or syzbot. No user incident in the
message or thread.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: `[PATCH 1/2] drm/etnaviv: check all modules for idle after
reset` is the other half. This MMU check does not depend on the
idle_mask change.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search blocked (403/Anubis). UNVERIFIED:
no confirmed stable-list discussion.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `etnaviv_hw_reset()`

**Step 5.2: TRACE CALLERS**
Record:
- `etnaviv_gpu_init()` (~line 891): probe; failure fails bind.
- `etnaviv_gpu_recover_hang()` (~line 1530): GPU hang recovery; return
  value ignored (pre-existing).

**Step 5.3: TRACE CALLEES**
Record: `gpu_read`/`gpu_write` of idle, clock, and MMUv2 control. On
success: `etnaviv_gpu_update_clock()`, drop `mmu_context`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace GPU submit → scheduler timeout (`etnaviv_sched.c`) →
`etnaviv_gpu_recover_hang()` → reset → `etnaviv_gpu_hw_init()` →
`etnaviv_gpu_start_fe_idleloop()` → `etnaviv_iommu_restore()`. Reachable
from normal DRM clients on hang. Also probe.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same ENABLE test in restore is the complementary invariant.
Idle-bit retry in the same loop is the same pattern.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
kernelversion` = 7.3.0-rc4. `etnaviv_hw_reset()` and restore early-
return are here. Bug dates to MMUv2 restore (v4.8). `git merge-base
--is-ancestor afb7b3b1deb471 HEAD` succeeded.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Insertion is after the 2D/3D idle check, which has
been there since the original driver.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: 2021 MMU-reset state patches are here. No earlier equivalent of
this ENABLE check. No follow-up reverting or amending this commit.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [drm/etnaviv] [IMPORTANT] Vivante GPU on i.MX and similar
embedded SoCs; not core mm/vfs, but common in Android/embedded.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (reset, hangcheck, IOMMU work through 2026).
Mature driver, not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific: CONFIG_DRM_ETNAVIV, MMUv2 cores
(`chipMinorFeatures1_MMU_VERSION`).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Successful-looking reset that leaves ENABLE set. Hit on probe
and on hang recovery. Hang recovery is a normal DRM scheduler path (not
privileged). How often ENABLE stays set is unverified; the retry loop
exists because Vivante reset is already unreliable.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: [Failure] After reset, software drops MMU context while hardware
may still have ENABLE. Restore then skips pagetable reload. FE starts
with stale translations → GPU re-hang, faults, or DMA to reused pages.
[Severity] HIGH (broken recovery; possible GPU DMA to wrong memory). Not
a host oops by itself.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: [Benefit] HIGH for etnaviv hang recovery / probe restart
correctness. [Risk] LOW (17 lines, same retry style as existing idle
checks). Sticky ENABLE could fail reset more often; that failure was
previously silent and wrong.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Load-bearing invariant: full reset is the only way to disable MMUv2;
  restore skips work if ENABLE is still set (intentional for runtime PM,
  fatal after reset).
- Same class of bug as 2021 stable-tagged `725cbc7884c37` (keep HW/SW
  MMU state from diverging).
- 17-line surgical check in an existing retry loop.
- Maintainer + listed reviewer; no NAKs.
- Path is userspace-reachable via GPU hang recovery.
- Applies cleanly here; no missing helpers.

AGAINST:
- Framed as assumption validation, not a reported crash.
- No Fixes:/Reported-by/Tested-by/syzbot.
- Series 2/2 of reset hardening; sibling is also robustness.
- Stricter success could increase `-EBUSY` (probe fail / ignored in
  recover_hang).
- GPU-only, not core kernel.

UNRESOLVED:
- No evidence ENABLE-stuck-after-reset was observed on hardware.
- Stable list search could not be completed (lore 403).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — reviewed by etnaviv
   reviewer; logic matches existing idle retry.
2. Fixes a real bug that affects users? **PASS** — missing check allows
   HW/SW MMU divergence after reset; restore then skips reprogramming.
3. Important issue? **PASS** — hang recovery can leave GPU wedged or DMA
   with stale translations (HIGH, not host panic).
4. Small and contained? **PASS** — +17 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same file/function/registers
   exist.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk table, DT, build, or docs fix).
Qualifies as a normal contained bugfix.

**Step 9.4: MAKE YOUR DECISION**
This tree has the buggy reset/restore pair. The patch is a small,
correct completion of reset-success detection so MMUv2 restart actually
reloads pagetables. That is stable-worthy here.

What it solves for users of this tree: GPU reset (probe and hang
recovery) can look successful while MMUv2 ENABLE is still set. The
driver then drops its MMU context and restore bails out, so the FE can
run on stale translations. Checking ENABLE and retrying closes that
hole.

Risk vs benefit: benefit is correct recovery; risk is a slightly
stricter reset with a 1s retry budget, authored by the maintainer.

Concerns: no field report of ENABLE stuck after reset; lore.kernel.org
web was blocked. Neither outweighs the code-level invariant.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Christian Gmeiner; Link
  patch.msgid.link 2/2; author Lucas Stach; no Fixes/Reported-by
- [Phase 2] Diff: +17 lines in `etnaviv_hw_reset()` adding MMUv2 ENABLE
  retry
- [Phase 3] git blame: restore ENABLE early-return `afb7b3b1deb47`
  (v4.8); reset loop `a8c21a5451d83` (v4.5)
- [Phase 3] Related: `725cbc7884c37` / `8f3eea9d01d7b` document reset vs
  PM MMU invariants; both were Cc:stable
- [Phase 3] Series: parent `1006d1f7c03d9` is 1/2 idle_mask check; this
  hunk does not need it
- [Phase 4] b4 dig -c 4720915ab4828: original at
  patch.msgid.link/20260511085148.652256-2-l.stach@pengutronix.de
- [Phase 4] b4 dig -a: v1 only
- [Phase 4] b4 dig -w: etnaviv@, dri-devel@, Christian Gmeiner
- [Phase 4] b4 dig -m: Gmeiner Reviewed-by both patches; no NAK; no
  Cc:stable in thread
- [Phase 4] lore.kernel.org WebFetch/curl: 403 Anubis — stable-list
  search UNVERIFIED
- [Phase 5] Callers: `etnaviv_gpu_init` (probe),
  `etnaviv_gpu_recover_hang` from `etnaviv_sched.c` timeout
- [Phase 5] Restore: `etnaviv_iommuv2_restore_nonsec/sec` return if
  ENABLE set
- [Phase 6] git describe HEAD: v7.3-rc4-27-gf0100363d8c37; kernelversion
  7.3.0-rc4
- [Phase 6] git merge-base --is-ancestor afb7b3b1deb471 HEAD: yes, buggy
  restore in this tree
- [Phase 6] Registers `VIVS_MMUv2_CONTROL_ENABLE` / `SEC_CONTROL_ENABLE`
  in `state_hi.xml.h`
- [Phase 8] Failure mode: hang recovery with stale MMU → GPU re-hang /
  wrong DMA; severity HIGH
- UNVERIFIED: whether ENABLE-stuck-after-reset was seen on hardware;
  whether stable@ discussed it

**YES**

 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index 368e799fc0c5d..daba33052f524 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -598,6 +598,23 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
 			continue;
 		}
 
+		/* try resetting again if MMUv2 is not disabled */
+		if (gpu->identity.minor_features1 & chipMinorFeatures1_MMU_VERSION) {
+			if (gpu->sec_mode == ETNA_SEC_KERNEL) {
+				if (gpu_read(gpu, VIVS_MMUv2_SEC_CONTROL) &
+				    VIVS_MMUv2_SEC_CONTROL_ENABLE) {
+					dev_dbg(gpu->dev, "MMU is not disabled\n");
+					continue;
+				}
+			} else {
+				if (gpu_read(gpu, VIVS_MMUv2_CONTROL) &
+				    VIVS_MMUv2_CONTROL_ENABLE) {
+					dev_dbg(gpu->dev, "MMU is not disabled\n");
+					continue;
+				}
+			}
+		}
+
 		/* enable debug register access */
 		control &= ~VIVS_HI_CLOCK_CONTROL_DISABLE_DEBUG_REGISTERS;
 		gpu_write(gpu, VIVS_HI_CLOCK_CONTROL, control);
-- 
2.53.0

