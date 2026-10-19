Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF844D3BCC;
	Mon, 19 Oct 2026 14:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418520; cv=none; b=NZhJ2Ugmv1f2rV37lKRPlnu3rIW2DrTh3O/xLqVGgNsyEVJP2JfTxlywUCYIfsv8ot0e/Bl672mkq1zhW189tGWwdiFuTrn3Cj4nMxrzsfcMnS706fRpy9N6Bo0kL9WcJ9xw3vQANvAXGwd9e8pSM87DBLxRFc/SXYRKWml0bjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418520; c=relaxed/simple;
	bh=nAdt/5BAv3tpy5fb3+f/dEwdMsrycZXG/BoJ/3d78SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zk3qXC3w9oYprIBTb3eRgFyfDa2+kqJ3peKOc6jGSRo+6kqeokVPjHrN0s20C5h0vJafpfvOyTj9BBH3Ll86flNqOi0F5AvHJB1Tf5PqR/62kszA16CCMtPDnKZo+82tALcco9exh1F0bjvCT8XBGFGoFwyh4C3pUXXZgzN+fUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZQr2/YJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZQr2/YJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9ECD1F000CF;
	Mon, 19 Oct 2026 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418518;
	bh=g5hh8XGBr6cDzQJ9gkaCkkRFfKMadX4LxrcXJDs2Dh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZQr2/YJo83A6xeimQ1SYSvjqswEKRCtCLoYTqXRWKRpEmZ6cjiEIR+Soff3YPE38
	 ODkslt7mhiFbWP3nahPAXC7FHxK8PbESTyIWZbyjeVzFH0yrvq9H+iCborYWJTEPZi
	 oZwv5uB3OG0zvo52YReoPpbFMGrqeJz+nTLdhvMjFSpAOjajaecWGBI0YabI6LJhRr
	 ypht1/LsmLxZTit99KEalUGgzW8uea2NGTbuBx1ZXLihA4EiVxw8N9OIyfRTshZZCP
	 erKMP7rCPq1231FDLHCswFtpebcYPBJ9csVCU+05mrdXSd4CYQhQ/3fNmmNSuNWLcY
	 O61/L0Cuf+NKQ==
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
Subject: [PATCH AUTOSEL 6.18-5.10] drm/etnaviv: check all modules for idle after reset
Date: Mon, 19 Oct 2026 09:49:56 -0400
Message-ID: <20261019135441.1420968-305-sashal@kernel.org>
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

[ Upstream commit 1006d1f7c03d92b28c252333836635df8e165401 ]

While the FE is an important part of the GPU, which needs to be idle
after reset, all other modules should be idle after a proper reset.
Check all present modules for being idle to determine whether the
reset was successful.

Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Link: https://patch.msgid.link/20260511085148.652256-1-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[drm/etnaviv]` `[check]` `[after GPU reset, require every
present module idle, not only FE]`

**Step 1.2: Tags**
Record:
- `Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>` (etnaviv
  reviewer in MAINTAINERS)
- `Link: https://patch.msgid.link/20260511085148.652256-1-
  l.stach@pengutronix.de`
- `Signed-off-by: Lucas Stach <l.stach@pengutronix.de>` (etnaviv
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable`, or syzbot
  tags (absence of Fixes/Cc-stable is expected here)

**Step 1.3: Body**
Record:
- Bug: reset success was decided only from the frontend (FE) idle bit.
- Symptom/failure mode: a reset that leaves other modules busy is
  treated as success; the driver then continues probe or hang recovery.
- Version info: none in the message.
- Root cause (author): after a proper reset every present module should
  be idle; FE-only is not enough.

**Step 1.4: Hidden bug fix?**
Record: Not disguised. It is an explicit correctness fix of reset-
success detection. Verb is “check”, but it changes a control-flow
condition that previously let a non-idle GPU leave the retry loop.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/gpu/drm/etnaviv/etnaviv_gpu.c` (~3 lines changed,
  3+/3-)
- Function: `etnaviv_hw_reset()`
- Scope: single-file surgical change

**Step 2.2: Code flow**
Record:
- Before: after `gpu_read(VIVS_HI_IDLE_STATE)`, retry only if `(idle &
  VIVS_HI_IDLE_STATE_FE) == 0`.
- After: retry if `(idle & gpu->idle_mask) != gpu->idle_mask`.
- Path: hardware reset retry loop (1s timeout). Used from GPU init
  (`etnaviv_gpu_init` path) and hang recovery
  (`etnaviv_gpu_recover_hang`).

The loop already had a second check on `VIVS_HI_CLOCK_CONTROL`
IDLE_3D/IDLE_2D. This change only widens the IDLE_STATE check from FE to
`idle_mask`.

**Step 2.3: Bug mechanism**
Record: `[Logic / correctness]` Reset success was too weak. Incomplete
reset could be accepted if FE was idle. Fix reuses `gpu->idle_mask`,
already used by `etnaviv_gpu_wait_idle()` and RPM suspend.

**Step 2.4: Fix quality**
Record:
- Obviously correct relative to existing idle policy; same comparison as
  `etnaviv_gpu_wait_idle()`.
- Minimal; no API/struct change.
- Regression risk: stricter success can turn a flaky reset into `-EBUSY`
  after 1s (probe fails). That is the intended failure if modules never
  go idle. `idle_mask` already accounts for GC300/GC600 absent-module
  bits (`~AXI_LP` elsewhere). No lock/API change.

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- FE-only check: `a8c21a5451d83` (“drm/etnaviv: add initial etnaviv DRM
  driver”, 2015).
- `idle_mask` field: same initial driver; default
  `~VIVS_HI_IDLE_STATE_AXI_LP` moved earlier in `2b76f5be7c2778`
  (2018/2019, “initialize idle mask before querying the HW db”).
- Bug is long-standing, not new 7.3 code.

**Step 3.2: Fixes: tag**
Record: None. Introducer is the 2015 driver add, verified via blame/`git
log -S`.

**Step 3.3: Related file history**
Record:
- `1006d1f7c03d9` — this commit
- `4720915ab4828` — patch 2/2, MMUv2 disabled-after-reset check
  (independent extra check)
- `c182a2ae13886` — later power-register flush; not a prerequisite of
  this hunk
This commit is standalone. Patch 2 is related hardening, not required
for this condition change.

**Step 3.4: Author**
Record: Lucas Stach is listed `M:` for “DRM DRIVERS FOR VIVANTE GPU IP”.
Christian Gmeiner is `R:`. Recent etnaviv work by the same author
includes hang-check and reset-related fixes.

**Step 3.5: Dependencies**
Record: Needs `gpu->idle_mask` and the reset retry loop. Both exist in
this tree (and have since the original driver / 2019 idle_mask init).
Applies standalone. Does not need `gpu_write_power_sync` from the later
flush commit.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record:
- `b4 dig -c 1006d1f7c03d9` → https://patch.msgid.link/20260511085148.65
  2256-1-l.stach@pengutronix.de
- `b4 dig -a`: single v1 series, two patches. Committed version matches
  v1.
- Reviewer: Reviewed-by only; no NAK, no stable nomination, no risk
  discussion.
- lore.kernel.org HTTP fetch returned 403; thread recovered via `b4 dig
  -m`.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Lucas Stach, `etnaviv@lists.freedesktop.org`, `dri-
devel@lists.freedesktop.org`, Christian Gmeiner. Right lists and
reviewer.

**Step 4.3: Bug report**
Record: No Reported-by, bugzilla, or syzbot. No described repro.
UNVERIFIED whether a specific hang prompted the series; message does not
say.

**Step 4.4: Series**
Record: 1/2 idle-mask check; 2/2 MMUv2 disable check. Independent. 1/2
is self-contained.

**Step 4.5: Stable list**
Record: Web search of lore stable for this subject found no relevant
thread. No evidence it was rejected for stable.

## Phase 5: Semantic / impact

**Step 5.1: Functions**
Record: `etnaviv_hw_reset()` only.

**Step 5.2: Callers**
Record:
- GPU identify/init: `ret = etnaviv_hw_reset(gpu);` — probe/init failure
  if reset times out.
- `etnaviv_gpu_recover_hang()` ← `etnaviv_sched.c` timed-out job path
  (`drm_sched_stop` → recover → resubmit). Return value of reset is
  ignored there (pre-existing). Benefit on that path is extra retries
  until modules are idle, not a new hard fail.

**Step 5.3: Callees**
Record: `gpu_read(VIVS_HI_IDLE_STATE)` unchanged; only the predicate
changes.

**Step 5.4: Reachability**
Record: Yes. Init/reset on device bring-up; hang recovery from GPU
scheduler after a stuck job (userspace GL/Vulkan/etnaviv DRM). Not
syscall-direct memory corruption; it is a common driver path on Vivante
/ i.MX systems.

**Step 5.5: Similar patterns**
Record: `etnaviv_gpu_wait_idle()` already uses `(idle & gpu->idle_mask)
== gpu->idle_mask`. RPM suspend uses `idle_mask` minus FE/MC. This
aligns reset with those definitions.

## Phase 6: This checkout

**Step 6.1: Local tree and buggy code**
Record:
- `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion` → `7.3.0-rc4`
- `etnaviv_hw_reset`, `idle_mask`, and the idle register exist here.
- `git merge-base --is-ancestor 1006d1f7c03d9 HEAD` → yes (commit
  already in this 7.3-rc4 lineage).
- Pre-commit code (parent `3e32e6672fa30`) still had the FE-only test.
  Introduced 2015; not after this branch.

**Step 6.2: Backport difficulty**
Record: Clean 3-line predicate swap. No refactor of the surrounding
reset function is required for this hunk. Expected: clean apply on trees
that still have the FE-only check.

**Step 6.3: Related fixes already here**
Record: This exact change is already in HEAD. Follow-up MMUv2 check is
also here; it is not a substitute for the idle_mask check.

## Phase 7: Subsystem

**Step 7.1**
Record: `[drm/etnaviv]` `[IMPORTANT]` — not core mm/net, but the Vivante
GPU driver used on NXP i.MX and similar embedded SoCs, including
display.

**Step 7.2**
Record: Actively maintained (recent reset/hang/cache commits). The FE-
only check itself was untouched for ~10 years.

## Phase 8: Impact and risk

**Step 8.1: Who**
Record: Driver-specific: `CONFIG_DRM_ETNAVIV` / Vivante GPU users
(embedded i.MX class).

**Step 8.2: Trigger**
Record: GPU soft-reset during init and after hangcheck. Incomplete
module idle after reset is the hardware case the existing retry loop
already exists for. Unprivileged GPU clients can trigger hang recovery
via a stuck job; they cannot directly poke the idle register.

**Step 8.3: Failure mode**
Record: `[incomplete reset treated as success]` `[HIGH for GPU, not
kernel panic]`. Probe can later use a GPU that is not fully idle; hang
recovery can resubmit onto modules still busy → further hangs, failed
jobs, possible display freeze. Not KASAN/UAF. Not a documented CVE.

**Step 8.4: Risk-benefit**
Record:
- Benefit: medium-high for etnaviv — reset/hang recovery actually waits
  for the same idle definition the rest of the driver uses.
- Risk: low — 3 lines, existing mask, maintainer + reviewer. Residual
  risk is probe `-EBUSY` if some chip never sets all `idle_mask` bits
  after reset; GC300/GC600 already have a reduced mask, and
  wait_idle/RPM have used this mask for years.
- Ratio: favorable.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real logic bug: reset-success ignored non-FE modules.
- Same `idle_mask` already used for wait_idle and RPM.
- 3-line, obviously correct, no new API.
- Hang recovery and init both go through this loop.
- Maintainer-authored, reviewed by listed reviewer.
- Code and prerequisites exist in this tree; bug dates to 2015.

AGAINST:
- No user report, repro, sanitizer hit, or described crash.
- Not a kernel oops/UAF/deadlock; GPU-side hang/recovery.
- CLOCK_CONTROL IDLE_2D/IDLE_3D already checked afterward.
- Patch 1/2 of hardening, not a smoking-gun “Fixes:”.

UNRESOLVED:
- No public report of a hang caused specifically by FE-idle / other-
  module-busy.
- lore.kernel.org HTTP 403; discussion taken from `b4 dig` mbox only.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — predicate matches
   `wait_idle`; reviewed.
2. Real bug affecting users? **PASS** — false reset success on init/hang
   recover.
3. Important (crash/security/corruption/deadlock/hang)? **PASS** —
   failed GPU reset/hang recovery; UI/GPU freeze on this hardware, not a
   core panic.
4. Small and contained? **PASS** — 3 lines, one function.
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** — driver, `idle_mask`, and reset loop
   are present.

**Step 9.3: Exception category**
Record: None (not an ID/quirk/DT/build/doc exception). It is a normal
small driver correctness fix.

**Step 9.4: Decision**
This tree is 7.3-rc4 and already contains the change; the evaluation is
whether this tree *should* have it on technical merit. It should. The
FE-only test has been wrong for as long as the driver has reset
hardware. The retry loop exists because reset is not always complete on
the first try; ignoring other modules lets that loop exit too early,
then init or hang recovery proceeds. The fix is the same idle definition
already used elsewhere, tiny, and reviewed by the subsystem.

It is not a core memory-safety crash, but it is a contained, real reset
bug on a production embedded GPU path, which is in scope for stable.

Verification:
- [Phase 1] Tags: Reviewed-by Christian Gmeiner; Link msgid
  20260511085148.652256-1; maintainer SOB; no Fixes/Reported-by/syzbot
- [Phase 2] Diff: 3-line condition change in `etnaviv_hw_reset()`; FE
  bit → `idle_mask`
- [Phase 3] Blame: FE check from `a8c21a5451d83` (2015); `idle_mask`
  init `2b76f5be7c2778`
- [Phase 3] `git log -S 'FE is not idle'` / `-S idle_mask` limited to
  `etnaviv_gpu.c`
- [Phase 3] Series: 1/2 this commit, 2/2 `4720915ab4828` MMUv2 check;
  standalone
- [Phase 4] `b4 dig -c 1006d1f7c03d9`: lore msgid link; v1 only; dri-
  devel/etnaviv CC; Reviewed-by; no NAK
- [Phase 4] `b4 dig -m`: 4 messages (2 patches + 2 R-b); WebFetch lore
  403
- [Phase 4] Stable lore search: no relevant hits
- [Phase 5] Callers: init `etnaviv_hw_reset` at line 891;
  `etnaviv_gpu_recover_hang` from `etnaviv_sched.c:84`
- [Phase 5] `wait_idle` uses identical mask compare at line 1709
- [Phase 6] `git describe HEAD` v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor 1006d1f7c03d9 HEAD` true; not
  ancestor of `v7.2`
- [Phase 7] MAINTAINERS: Lucas Stach M:, Christian Gmeiner R:
- [Phase 8] Failure: incomplete GPU reset / failed hang recovery, not
  kernel UAF
- UNVERIFIED: specific user-visible hang from FE-only success;
  lore.kernel.org page content besides b4 mbox

**YES**

 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index cf0d9049bcf1e..368e799fc0c5d 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -582,9 +582,9 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
 		/* read idle register. */
 		idle = gpu_read(gpu, VIVS_HI_IDLE_STATE);
 
-		/* try resetting again if FE is not idle */
-		if ((idle & VIVS_HI_IDLE_STATE_FE) == 0) {
-			dev_dbg(gpu->dev, "FE is not idle\n");
+		/* try resetting again if any module is not idle */
+		if ((idle & gpu->idle_mask) != gpu->idle_mask) {
+			dev_dbg(gpu->dev, "GPU modules not idle\n");
 			continue;
 		}
 
-- 
2.53.0

