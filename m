Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1353B53C024;
	Mon, 19 Oct 2026 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418340; cv=none; b=pSGzRs1/U28I56flt1B8Ebo1zsXf7gk1GRkKyUxD7pGwalY+ns1un9/BvMoIYPihXTQBi9Iq60x0EsW0w5PoP+fXN1I7IzpOkyvVxfPhDeLZSv8rW4+CpGucH+g85nSu6M+K8PSHGUZFLvqi4Uh3NAcbiwVWyA6X3Op9HfqhNlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418340; c=relaxed/simple;
	bh=W/DkYhXzNatnQySBrmF7cfsDRjm5tK6Q+eT0r4Q/WmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t6dHAJEXVltxlA75It/FjD6luZ9k62oSs2MU/qOmEbrmkvQlPlaw/tNA6fHAJYJGw6ZB9KwKkt+Cu4VKVzyNC/SWCTzk2943O8grWSDnDVjr9Qd8wTA/rPRkGF/OnczqWeTRbGvF81Jcf0CHnrApPo+wEMGlWoGWgZHaPA04i/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MH1hqwHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MH1hqwHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993E61F000C4;
	Mon, 19 Oct 2026 13:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418338;
	bh=Kt8eKIk+Pbct/atlIdIgI8G2qAB4WrScIfzwOfDT0ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MH1hqwHob0J/e5mlrBBdRGDrGmJThqCj4SN8s0SZU5GTr7cOVii2ncQswOHWMS08p
	 V7+QQs3cKseXH+UKI8+dgGuouppFeUy2VOSh3a1lOpSrndFOTan8NECNeJJTd9vKI8
	 ImQN0x2kdRPMVXpunrohLDAcVxLBjjkAAKPZoEllBJslaExifRVD1NHrrt0Mz8NKex
	 woJ/ZI47unfHkKaIYF73gemazob2EMVkubA3sHth1dthT+ncwnwJ7k0TvcE2PkDAe3
	 dacoNafXslqxxkO5pwdmkg4kqb4QdYjUZRyhPbCvfDg3y+4VM9rIhChpRQLwz4lCIa
	 XQnbWvhO7gtdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jesse Zhang <Jesse.Zhang@amd.com>,
	Michael Chen <michael.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Shaoyun Liu <shaoyun.liu@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu/mes_v12_0: use mes schedule pipe for legacy queues on unified MES
Date: Mon, 19 Oct 2026 09:47:47 -0400
Message-ID: <20261019135441.1420968-176-sashal@kernel.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 5ec4cc91708370847772f2a2397316dbd8d8f066 ]

when suspend_all_gangs is issued to pipe0 MES during system suspend or runtime PM, pipe0 can only suspend and resume queues it has tracked.
KCQs registered with a non-zero pipe slot may not be correctly handled, leaving them in an inconsistent state after resume.

v3: fix the schedule pipe issue
v4: use schedule pipe for KQ resets

Reviewed-by: Michael Chen <michael.chen@amd.com>
Suggested-by: Michael Chen <michael.chen@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Suggested-by: Shaoyun Liu <shaoyun.liu@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a **6.18.y** tree (`v6.18.53`). The buggy MES v12 pipe selection
is present here, the patch is small, and it applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/amdgpu/mes_v12_0] [use] [route legacy kernel queues to the
MES schedule pipe on unified MES]`

Subsystem is AMD GPU MES firmware for gfx12. Verb is “use”, but the body
describes a resume/tracking bug, not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- No `Fixes:` tag (expected for autosel review)
- No `Reported-by:` / `Tested-by:` / `Cc: stable`
- `Reviewed-by: Michael Chen <michael.chen@amd.com>`
- `Suggested-by: Michael Chen`, `Alex Deucher`, `Shaoyun Liu` (AMD MES
  people)
- `Signed-off-by: Jesse Zhang` (author), `Alex Deucher` (amdgpu
  maintainer)
- Ignore pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  5ec4cc917083...]`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: on unified MES, `suspend_all_gangs` is sent to pipe0 (SCHED).
  Pipe0 can only suspend/resume queues it has tracked.
- Symptom: KCQs registered on a non-zero pipe (KIQ = pipe 1) are not
  handled, and can be left inconsistent after resume.
- Trigger named in the message: system suspend / runtime PM.
- Changelog: v3 fixes schedule-pipe selection; v4 also sends kernel-
  queue resets to the schedule pipe.
- No stack trace, no kernel version list.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit correctness fix for MES pipe
routing. The v4 reset hunk is the same class of bug (reset must follow
the pipe that actually owns the queue).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/drm/amd/amdgpu/mes_v12_0.c` (+17 / −10)
- Functions: `mes_v12_0_map_legacy_queue`,
  `mes_v12_0_unmap_legacy_queue`, `mes_v12_0_reset_hw_queue`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Map/unmap, `enable_uni_mes`: previously always `AMDGPU_MES_KIQ_PIPE`.
  After: MES ring (`AMDGPU_RING_TYPE_MES`) stays on KIQ; every other
  kernel queue goes to `AMDGPU_MES_SCHED_PIPE`. Non-uni_mes path still
  uses SCHED.
- Reset: previously `is_kq` → KIQ, else SCHED. After: always SCHED.
- Affected paths: KCQ/KGQ map at gfx init/resume, unmap at gfx
  hw_fini/suspend, MES scheduler-queue map in `mes_v12_0_queue_init`,
  kernel-queue reset in gfx12 hang recovery.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / hardware-firmware tracking bug** (wrong MES pipe).
- `AMDGPU_MES_SCHED_PIPE = 0`, `AMDGPU_MES_KIQ_PIPE = 1`.
- Suspend-all is submitted to SCHED (pipe0). Mapping KCQs on KIQ (pipe1)
  means pipe0 never tracked them.
- Reset of kernel queues was also sent to KIQ
  (`amdgpu_mes_reset_legacy_queue` always sets `is_kq = true`), so hang
  recovery talked to the wrong pipe.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct given MES pipe semantics. Minimal. Non-uni_mes
unchanged. MES scheduler queue still mapped via KIQ, which matches
`mes_v12_0_queue_init()` calling `amdgpu_mes_map_legacy_queue()` on the
SCHED ring (`AMDGPU_RING_TYPE_MES`). Regression risk is low: pipe choice
is firmware-facing, but AMD MES reviewers signed off. The v4 reset hunk
was added after the v3 Reviewed-by; it is consistent with the map
change, not a random extra edit.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Map/unmap KIQ routing: `aa539da8aff07a` (“drm/amdgpu/mes12: adjust
  mes12 sw/hw init for multiple pipes”, Jack Xiao, 2024-08). In
  v6.18.53.
- Reset `is_kq` → KIQ: `2e828a25f850f` (“drm/amdgpu/mes: use correct MES
  pipe for resets”, 2025-04). In v6.18.53.
- MES v12 itself: `785f0f9fe7420` (2024-05). In this tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Functionally this corrects `aa539da8aff07a`
(map/unmap) and `2e828a25f850f` (KQ reset pipe). Both ancestors of
v6.18.53.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `6abd725fdfc41` implements MES suspend/resume gang for v12 (in
  6.18.53); `mes_v12_0_suspend_gang()` already submits to
  `AMDGPU_MES_SCHED_PIPE`.
- `2e828a25f850f` is the prior reset-pipe policy this commit revises.
- Later autosel commit `00a6825e89078` (oversubscription doorbell mode)
  is unrelated.
- Standalone for 6.18: sibling `mes_v12_1` does not exist here.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Jesse Zhang is an AMD amdgpu contributor (MES/gfx/SDMA). This is
not a drive-by. Merged by Alex Deucher.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs MES v12, `enable_uni_mes`, map/unmap/reset callbacks, and
SCHED-pipe suspend. All present in v6.18.53. Applies cleanly to
`v6.18.53:drivers/gpu/drm/amd/amdgpu/mes_v12_0.c` (patch --dry-run rc
0). No missing helper or struct field.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 5ec4cc917083...` →
  https://patch.msgid.link/20260330013346.1054624-1-Jesse.Zhang@amd.com
- v3 series: 1/2 this file; 2/2 `mes_v12_1` (not in this tree).
- v4 standalone: https://lists.freedesktop.org/archives/amd-
  gfx/2026-April/142750.html (map/unmap only).
- Committed form matches later resends that add “v4: use schedule pipe
  for KQ resets” (e.g. 11/42 in “Enable pipe reset for compute”).
- Michael Chen: `Reviewed-by` on v3. No NAK in the saved thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc: amd-gfx, Alex Deucher, Christian König, Shaoyun Liu,
Michael Chen. Right maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot. Description is from AMD MES engineers
(Suggested-by three of them). No public crash log.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 2/2 is mes_v12_1 only. Not a hard dependency of 1/2. The May
42-patch compute-reset series reused this patch; this hunk does not need
the rest of that series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No useful stable-list discussion found. Absence is not a
negative signal.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `mes_v12_0_map_legacy_queue`, `mes_v12_0_unmap_legacy_queue`,
`mes_v12_0_reset_hw_queue`. Semcode MCP not available; used grep/read.

**Step 5.2: TRACE CALLERS**
Record:
- Map: `amdgpu_mes_map_legacy_queue()` ← `amdgpu_gfx_enable_kcq()` /
  `amdgpu_gfx_enable_kgq()`, gfx12 KCQ/KGQ reset remap,
  `mes_v12_0_queue_init()` for the MES SCHED ring when `enable_uni_mes`.
- Unmap: `amdgpu_mes_unmap_legacy_queue()` ← `amdgpu_gfx_disable_kcq()`
  (gfx12 `hw_fini` / suspend), MES kiq_hw_fini for the SCHED ring.
- Reset: `amdgpu_mes_reset_legacy_queue()` ← `gfx_v12_0_reset_kcq` /
  `gfx_v12_0_reset_kgq` (and SDMA MES reset on other IPs; gfx12 path is
  the one that hits mes_v12).
- Suspend-all: `amdgpu_mes_suspend()` ← KFD `suspend_all_queues_mes()`;
  MES suspend packet already goes to SCHED pipe.

**Step 5.3: TRACE CALLEES**
Record: All three submit via
`mes_v12_0_submit_pkt_and_poll_completion(mes, pipe, ...)`, which writes
the packet to `mes->ring[pipe]`. Wrong `pipe` means the other MES engine
never sees ADD/REMOVE/RESET.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable without special debug options:
- Boot/resume maps KCQs (`enable_legacy_queue_map` is hardcoded true in
  mes_v12 sw_init).
- GPU suspend/`hw_fini` unmaps them.
- Hang recovery resets them.
- KFD bad-queue handling issues suspend_all_gangs.
Userspace GPU clients and suspend/resume trigger this. Unprivileged
DRM/KFD users can hit hang recovery.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same uni_mes → KIQ heuristic remains in `mes_v12_0_misc_op()`;
this patch does not touch it. User-queue add/remove already used SCHED
pipe. Sibling mes_v12_1 fix is for a file this tree does not have.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes, in v6.18.53 `mes_v12_0_map_legacy_queue` / `unmap` /
`reset_hw_queue`. Introduced 2024–2025; not after 6.18 branched.
Verified: `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`; `make
kernelversion` = `6.18.53`; `git merge-base --is-ancestor f15135562c4b0
v6.18.53` is false (candidate not in the stable tag).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply to v6.18.53. Context matches. No rework needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: 6.18.53 still has the uni_mes→KIQ map/unmap and `is_kq`→KIQ
reset. No earlier equivalent fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/gpu/drm/amd/amdgpu` MES for gfx12. **IMPORTANT**
(shipping RDNA4: IP 12.0.0 / 12.0.1), not core mm/net, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; MES v12 has ongoing queue/reset work. The
bug is in code that has been in 6.18 since release, not brand-new post-
branch code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: gfx12 (RDNA4) with unified MES. `amdgpu_uni_mes` defaults to 1;
discovery sets `enable_uni_mes` for IP 12.0.0/12.0.1. Driver-specific,
default-on for those GPUs.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Common: every gfx12 boot maps KCQs; every GPU suspend/`hw_fini` unmaps
  them.
- Hang recovery resets KCQ/KGQ through the same pipe.
- KFD suspend-all on bad queues.
- Not a theoretical race; wrong static pipe choice.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Kernel compute/graphics queues left untracked or reset on the
wrong MES engine → failed suspend/resume, failed queue reset, GPU hang.
KFD treats MES suspend failure as unrecoverable and schedules GPU reset.
Severity: **HIGH** (GPU hang / failed recovery), not a kernel NULL-
deref, but user-visible and production-relevant on RDNA4.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: HIGH for gfx12 6.18 users (default uni_mes).
- Risk: LOW (17 lines, one file, non-uni_mes unchanged, MES self-queue
  still on KIQ).
- Ratio: favor backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real firmware-tracking bug: KCQs mapped to pipe1 while suspend-
  all/reset tracking is pipe0.
- Present in this 6.18.y tree; uni_mes default-enabled on gfx12.
- Hits suspend/resume and hang recovery, not a dead path.
- Small, surgical, applies cleanly.
- Reviewed/suggested by AMD MES engineers; merged by Alex Deucher.
- Corrects pipe policy already in 6.18 (`aa539da8`, `2e828a25`).

AGAINST:
- No public user report or sanitizer hit.
- gfx12-only, not a core-kernel oops.
- v4 reset hunk was not in the v3 Reviewed-by mail (but it is the
  necessary counterpart of the map change).
- 2/2 mes_v12_1 is unrelated here (file absent).

UNRESOLVED:
- No first-party dmesg/reproducer beyond the author’s description (AMD-
  internal).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — pipe choice matches suspend-
   all on SCHED; MES self-queue exception is required and matches
   `queue_init`.
2. Fixes a real bug that affects users? **PASS** — gfx12 KCQ
   tracking/resume/reset.
3. Important issue? **PASS** — GPU hang / failed queue reset /
   inconsistent KCQs after resume. HIGH, not a style nit.
4. Small and contained? **PASS** — one file, ~27 lines.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — clean on v6.18.53.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None of ID/quirk/DT/build/docs. Ordinary driver correctness fix;
still stable-eligible.

**Step 9.4: MAKE YOUR DECISION**
Backport. The 6.18 tree has unified MES, default-on, with the wrong pipe
for legacy kernel queues. The fix is small, applies cleanly, and
prevents KCQ inconsistency and failed MES resets on shipping gfx12
hardware.

Verification:
- [Phase 1] Tags: Reviewed-by Michael Chen; Suggested-by
  Chen/Deucher/Liu; no Fixes/syzbot.
- [Phase 2] Diff: map/unmap uni_mes now KIQ only for
  `AMDGPU_RING_TYPE_MES`; reset always SCHED.
- [Phase 3] Blame on v6.18.53: `aa539da8aff07a` (map/unmap),
  `2e828a25f850f` (reset is_kq).
- [Phase 3] Both those commits are ancestors of v6.18.53; candidate is
  not.
- [Phase 3] `git merge-base --is-ancestor f15135562c4b0 v6.18.53` → not
  in the tag.
- [Phase 4] `b4 dig -c 5ec4cc917083...` → v3 1/2 lore; 2/2 is mes_v12_1
  only.
- [Phase 4] mbox: Chen Reviewed-by; no NAK.
- [Phase 4] v4 list mail had map/unmap only; committed v4 adds KQ reset
  pipe.
- [Phase 5] Callers: `amdgpu_gfx_enable/disable_kcq`, gfx12
  reset_kcq/kgq, mes queue_init, KFD `amdgpu_mes_suspend`.
- [Phase 5] Pipes: SCHED=0, KIQ=1; suspend_gang already uses SCHED.
- [Phase 6] `git describe HEAD` v6.18.53-5049; `make kernelversion`
  6.18.53.
- [Phase 6] `enable_uni_mes` default 1 (`amdgpu_drv.c`); set for IP
  12.0.0/12.0.1.
- [Phase 6] Patch dry-run against v6.18.53 mes_v12_0.c: success.
- [Phase 6] No mes_v12_1.c in this tree.
- [Phase 8] Failure mode: inconsistent KCQs / failed MES reset → GPU
  hang; severity HIGH.
- UNVERIFIED: no public user crash log; lore.kernel.org WebFetch
  returned 403 (used b4 mbox + lists.freedesktop.org instead).

**YES**

 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c | 27 ++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
index c40aed5a8fc21..7d7bcf1c69f27 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -524,10 +524,15 @@ static int mes_v12_0_map_legacy_queue(struct amdgpu_mes *mes,
 		convert_to_mes_queue_type(input->queue_type);
 	mes_add_queue_pkt.map_legacy_kq = 1;
 
-	if (mes->adev->enable_uni_mes)
-		pipe = AMDGPU_MES_KIQ_PIPE;
-	else
+	if (mes->adev->enable_uni_mes) {
+		/* Keep scheduler queue on KIQ pipe; map all other kernel queues on sched pipe. */
+		if (input->queue_type == AMDGPU_RING_TYPE_MES)
+			pipe = AMDGPU_MES_KIQ_PIPE;
+		else
+			pipe = AMDGPU_MES_SCHED_PIPE;
+	} else {
 		pipe = AMDGPU_MES_SCHED_PIPE;
+	}
 
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
 			&mes_add_queue_pkt, sizeof(mes_add_queue_pkt),
@@ -563,10 +568,15 @@ static int mes_v12_0_unmap_legacy_queue(struct amdgpu_mes *mes,
 			convert_to_mes_queue_type(input->queue_type);
 	}
 
-	if (mes->adev->enable_uni_mes)
-		pipe = AMDGPU_MES_KIQ_PIPE;
-	else
+	if (mes->adev->enable_uni_mes) {
+		/* Keep scheduler queue on KIQ pipe; unmap all other kernel queues on sched pipe. */
+		if (input->queue_type == AMDGPU_RING_TYPE_MES)
+			pipe = AMDGPU_MES_KIQ_PIPE;
+		else
+			pipe = AMDGPU_MES_SCHED_PIPE;
+	} else {
 		pipe = AMDGPU_MES_SCHED_PIPE;
+	}
 
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
 			&mes_remove_queue_pkt, sizeof(mes_remove_queue_pkt),
@@ -909,10 +919,7 @@ static int mes_v12_0_reset_hw_queue(struct amdgpu_mes *mes,
 		mes_reset_queue_pkt.doorbell_offset = input->doorbell_offset;
 	}
 
-	if (input->is_kq)
-		pipe = AMDGPU_MES_KIQ_PIPE;
-	else
-		pipe = AMDGPU_MES_SCHED_PIPE;
+	pipe = AMDGPU_MES_SCHED_PIPE;
 
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
 			&mes_reset_queue_pkt, sizeof(mes_reset_queue_pkt),
-- 
2.53.0

