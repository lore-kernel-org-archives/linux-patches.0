Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66713491B18;
	Mon, 19 Oct 2026 13:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418140; cv=none; b=nLckUbu8kB616hXsYkmUKU+MWxmUa8WrCk8+c745es5kfp32ddrZqOupdKJ2tnVi3cDFlwPHNfuFwkqPR9RDCXPxWWEBzF7FoF1hflLK2UllQtfGfv124Q8pPCyHkJ1sAGhGqpYz/JZ7VQ21+bEQ7EAStwqHuHksn64KqnampK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418140; c=relaxed/simple;
	bh=nV/GgtA5nTps9seInIOZO0l79vN6MSzj8KxQpKLXFi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OK5t+fxr2czFktTvRAvVDGOJ+YQPC2Gjbat70UqSyzczuekrEdHnnPrFZGIL2LZNCclyC43kXpgf9icbqdxMdF/otNhRHPJEOZW39kT9M7uEhJmXSlzOI3/UrTQNyWzOynGxoFZvJlOzKWHe+jUqWqKc005mJ9wHExyaFb9Yohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awtmbfM3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awtmbfM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A951F000C4;
	Mon, 19 Oct 2026 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418138;
	bh=V3PpoMFAw7qVzM1GmPC801AjygH/PqO9elu51OZwm6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awtmbfM35GvxrICJC9YsYeE6kkmFpQ6LocPglQBwvS1MX7AfO0oznuNFKC4mTfsB2
	 eGLoC3ZKmD95HMR0eOY6Wn/gYs/GJQK80GBTvVngrECjkBjdoVnlKY6vYQbcFc7J81
	 hXfcKFWE6e8E4jBpktXrafwA0poIN+b3eWG23ob8J4wYVpGP8SS8NbqJzVJvU4YgQc
	 CwPOacC3I99mca9gRU3wtPb//154YxlRRtRo4vGhng6GMsDFoMnUT07dIfAK7CuIms
	 kNdWiwi9BQZkN5IBxwSWPThI3aa12us+1JYMjI1NeCueS6fZS8bRyFvzBEOGNTOfXk
	 1j5nei/6aOI3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/amdgpu/gfx11: WARN() rather than BUG() for invalid SDMA engine
Date: Mon, 19 Oct 2026 09:45:30 -0400
Message-ID: <20261019135441.1420968-39-sashal@kernel.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c24edbd5ae0e4f24e0179e8c9f22a867016177bb ]

There's no need to crash the kernel for these cases.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough context: this is a three-line `BUG()`-to-`WARN()` change
on the GFX11 KFD SDMA path, already present in this 7.3-rc4 tree. The
remaining question is whether it is a real panic-prevention fix worth
keeping in stable.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[drm/amdgpu/gfx11]` `[WARN() rather than BUG()]` `[stop
panicking on an invalid SDMA engine id in get_sdma_rlc_reg_offset()]`

**Step 1.2: Tags**
Record:
- `Reviewed-by: Kent Russell <kent.russell@amd.com>` (AMD GPU developer)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer; ignore any Sasha Levin SOB)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc: stable`
  (absence expected)

**Step 1.3: Body**
Record: Body is one sentence: “There's no need to crash the kernel for
these cases.” No stack trace, no reproducer, no version range. Failure
mode claimed: kernel crash via `BUG()`. Root cause as stated: invalid
`engine_id` in `get_sdma_rlc_reg_offset()` was treated as fatal.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. It is an explicit panic-to-warning conversion. It is
also patch `15/43` of Alex Deucher’s amdgpu `BUG()`-removal series
(later resent as `02/30`). Same boilerplate appears on sibling
gfx12/gfx12.1 patches. That is hardening of a driver `BUG()`, not a
style-only rename.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record: One file, `drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c`.
Function: `get_sdma_rlc_reg_offset()`. Scope: +2/−1, single-file
surgical change.

**Step 2.2: Code flow**
Record: Before: `switch (engine_id)` handles 0 and 1; `default:` calls
`BUG()` and never returns. After: `WARN(1, "Invalid SDMA engine id
%d\n", engine_id); break;` then the function still computes
`sdma_rlc_reg_offset` from `sdma_engine_reg_base` (initialized to 0) and
returns. Affected path: invalid engine id on SDMA queue
load/dump/occupy/destroy.

**Step 2.3: Bug mechanism**
Record: Category **(g) logic / correctness** plus crash hardening.
`BUG()` is a kernel panic (unless `CONFIG_BUG` is off). The fix stops
the panic and logs. It does not add a hard error return; callers still
`RREG32`/`WREG32` using a 0 base.

**Step 2.4: Fix quality**
Record: Obviously correct as “don’t panic.” Minimal. Regression risk is
low: if the default branch is taken, the kernel continues and may
program SDMA engine 0-ish registers instead of dying. That matches the
older gfx9/gfx10.3 pattern (`dev_warn` + fallthrough to engine 0),
though this gfx11 version warns and breaks with `base = 0` rather than
explicitly using the engine-0 `SOC15_REG_OFFSET`. No public API change.

## Phase 3: Git history

**Step 3.1: Blame**
Record: Function and original `BUG()` introduced in `cc009e613de65`
(“drm/amdkfd: Add KFD support for soc21 v3”, Mukul Joshi, 2022-05-04).
That commit is an ancestor of `v6.1` and `v6.6` in this repo. The
`WARN()` lines are from `c24edbd5ae0e4` (Alex Deucher, 2026-06-15 /
committed 2026-07-08).

**Step 3.2: Fixes: tag**
Record: No `Fixes:` tag. Buggy code is the original gfx11 KFD SDMA
helper, not a later regression.

**Step 3.3: File history / series**
Record: Standalone for this file. Related siblings:
- `28cc342e2455c` gfx12 same change
- `9f8032604b973` gfx12.1 same change
Part of the June/July 2026 amdgpu `BUG()` cleanup. No extra gfx11
refactor is required for this hunk.

**Step 3.4: Author**
Record: Alex Deucher is the amdgpu maintainer. Around the same dates he
landed many `BUG()`/`BUG_ON()` → `WARN()`/`-EINVAL` conversions across
gfx/sdma/psp.

**Step 3.5: Prerequisites**
Record: None. The function and `BUG()` existed since the file was added.
Applies standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record: `b4 dig -c c24edbd5ae0e4` matched patch-id
`8e42a5ee823a482676f1d117737bc3f4d06296d3`.
Lore/msgid: https://patch.msgid.link/20260615235645.737189-15-
alexander.deucher@amd.com
Series: v1 `[PATCH 15/43]` 2026-06-15; later v2 `[PATCH 02/30]`
2026-07-07. Committed version matches the posted diff. No NAKs found. No
reviewer `Cc: stable` on this patch. Cover-letter fetch from lore
returned 403; mail-archive and Phoronix describe the series as removing
amdgpu `BUG()` so the driver does not panic when it can continue.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Alex Deucher, `amd-gfx@lists.freedesktop.org`. Kent Russell’s
`Reviewed-by` is on the git commit, not on the v1 mail-archive copy
(review landed later / at commit time).

**Step 4.3: Bug report**
Record: None. No syzbot, bugzilla, or user panic report.

**Step 4.4: Related patches**
Record: Independent per-IP copies. This gfx11 hunk does not depend on
the rest of the 43-patch series.

**Step 4.5: Stable list**
Record: No stable-thread hit found for this subject. UNVERIFIED:
lore.kernel.org/stable search was blocked (Anubis/403).

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `get_sdma_rlc_reg_offset()` only.

**Step 5.2: Callers (this tree)**
Record:
- `hqd_sdma_load_v11()` — KFD SDMA queue load
- `hqd_sdma_dump_v11()` — dump (debug / dqm)
- `hqd_sdma_is_occupied_v11()`
- `hqd_sdma_destroy_v11()` — preempt/destroy

Those are `gfx_v11_kfd2kgd` ops. Load goes `kfd_load_mqd_sdma()` →
`hqd_sdma_load()`. Dump is used from `kfd_device_queue_manager.c`.

**Step 5.3: Callees**
Record: `SOC15_REG_OFFSET`, register arithmetic, `pr_debug`. Callers
then `RREG32`/`WREG32` at the returned offset.

**Step 5.4: Reachability**
Record: Yes, from `/dev/kfd` queue create/destroy (needs KFD/render
access, not a raw unprivileged syscall). `engine_id` comes from
`v11_sdma_mqd.sdma_engine_id`, set in `kfd_mqd_manager_v11.c` from
`q->sdma_engine_id`.

Kernel assignment (`kfd_device_queue_manager.c`):
- normal SDMA: `sdma_id % kfd_get_num_sdma_engines()`
- `kfd_get_num_sdma_engines()` is `num_instances/num_nodes`, or
  `min(..., 2)` if XGMI

Userspace `KFD_QUEUE_TYPE_SDMA_BY_ENG_ID` is range-checked against
`num_sdma + num_xgmi - 1` in `kfd_ioctl_create_queue()`.

Verified: on typical GFX11 (2 SDMA, no XGMI) the id is 0 or 1, so
`default:` is not the normal path. Unverified: whether any GFX11 SKU
with XGMI and >2 SDMA instances can produce `engine_id >= 2` and hit
`BUG()`.

**Step 5.5: Similar patterns**
Record: gfx9 and gfx10.3 already `dev_warn` + fallthrough to engine 0.
gfx11/12/12.1 used `BUG()` until this series. This is aligning gfx11
with the safer sibling.

## Phase 6: This tree

**Step 6.1: Buggy code in this checkout?**
Record: Local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). File
exists. Current `get_sdma_rlc_reg_offset()` already has `WARN(1, ...)`.
`git merge-base --is-ancestor c24edbd5ae0e4 HEAD` succeeds. The panic
path is already gone here; the pre-fix `BUG()` is in the parent of that
commit.

**Step 6.2: Backport difficulty**
Record: Clean apply. Hunk matches the original function from 2022; no
conflicting refactor in that switch.

**Step 6.3: Related fixes already here**
Record: This exact fix is already ancestor of HEAD. Sibling gfx12/12.1
conversions are also present. No alternate gfx11 SDMA `BUG()` fix.

## Phase 7: Subsystem

**Step 7.1**
Record: `drivers/gpu/drm/amd/amdgpu` KFD GFX11. Criticality:
**IMPORTANT** (RDNA3 / RX 7000 / Phoenix, not core mm/vfs).

**Step 7.2**
Record: amdgpu/KFD is actively developed; this helper itself has been
stable since 2022.

## Phase 8: Impact and risk

**Step 8.1: Who**
Record: Users of AMD GFX11 + KFD compute (ROCm / `/dev/kfd`), config
`CONFIG_HSA_AMD`. Driver-specific, not universal.

**Step 8.2: Trigger**
Record: Invalid `engine_id` not in `{0,1}` on SDMA HQD
load/dump/destroy. Common path uses kernel-assigned 0/1. Userspace
engine id is validated for `SDMA_BY_ENG_ID`. Trigger is uncommon; not
shown as a day-to-day ROCm failure. Not a fully unprivileged DoS on
typical 2-engine GFX11.

**Step 8.3: Failure mode**
Record: Old: `BUG()` → kernel panic. Severity if hit: **CRITICAL**.
Likelihood: **LOW** on known 2-engine GFX11. After the fix: warning +
possible wrong MMIO if the branch is taken.

**Step 8.4: Risk-benefit**
Record: Benefit: avoid an intentional driver panic on a bad engine id.
Risk: 3 lines, no locking/API change, very low. Ratio: favorable if the
panic is treated as worth preventing; weaker if judged purely
theoretical.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Replaces `BUG()` (panic) with `WARN()` on a real KFD SDMA path.
- 3-line, obviously correct, reviewed by Kent Russell, written by the
  amdgpu maintainer.
- GFX11 KFD support has been in the kernel since 2022 (`cc009e613de65`,
  ancestor of v6.1).
- gfx9/gfx10.3 already refused to panic here; gfx11 was the harsh
  outlier.
- No prerequisites; applies cleanly to this file.
- Prompt’s crash/panic guidance favors inclusion.

AGAINST:
- No user report, syzbot, or demonstrated trigger.
- Official stable rule: not a “this could be a problem” patch without an
  exploit/trigger explanation.
- Identical one-line body across a 43-patch cleanup series, not a
  targeted production-crash fix.
- On typical GFX11, engine id is 0 or 1, so `default:` is largely
  defensive.
- After `WARN()`, execution continues with `base = 0` rather than
  failing the ioctl.

UNRESOLVED:
- Whether any GFX11 product can assign `engine_id >= 2` via XGMI extra
  SDMA engines.
- Full cover-letter text (lore 403).
- Stable-list discussion (lore/stable blocked).

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? **PASS** — 3-line substitution,
   reviewed, in mainline.
2. Fixes a real bug that affects users? **PASS** with caveat — it fixes
   a real panic *if* the branch runs; no evidence users hit it. Still a
   driver `BUG()` on a userspace-reachable KFD path.
3. Important (crash/security/corruption/deadlock)? **PASS** for the
   failure mode (panic). Likelihood is low.
4. Small and contained? **PASS** — +2/−1, one function.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — file/function exist; hunk is
   identical. (Already applied on 7.3-rc4.)

**Step 9.3: Exception category**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary
robustness fix.

**Step 9.4: Decision**

This tree is 7.3-rc4 and already contains the commit; the evaluation is
whether the change is stable-worthy for this codebase, not whether to
re-apply it.

It should be. `BUG()` in `get_sdma_rlc_reg_offset()` is an intentional
kernel panic on the GFX11 KFD SDMA load/destroy path. Replacing it with
`WARN()` is the same policy older GFX generations already used, it is
three lines, and it cannot introduce a new API or locking scheme. Lack
of a public reproducer makes it a cleanup-shaped patch, but the user-
visible failure if that branch ever runs is still a full panic, which is
what stable is for.

### What it solves for stable users
Stops the GFX11 KFD SDMA helper from taking down the machine on an out-
of-range engine id, instead of asserting.

### Rules
Small, obviously correct, no new API, applies to this file. It addresses
a panic, not a feature.

### Risk vs benefit
Benefit is panic avoidance on AMD RDNA3 compute queues. Risk is
negligible.

### Concerns
Trigger is uncommon; after `WARN()` the function still returns a 0-based
offset. That is acceptable versus `BUG()`. No extra commits are
required.

## Verification
- [Phase 1] Parsed subject/body/tags: one-sentence panic rationale;
  `Reviewed-by: Kent Russell`; no `Fixes`/`Reported-by`.
- [Phase 2] Diff: `BUG()` → `WARN(1, ...)` + `break` in
  `get_sdma_rlc_reg_offset()`; +2/−1.
- [Phase 3] `git blame`: `BUG()` from `cc009e613de65` (2022-05-04);
  ancestor of v6.1 and v6.6.
- [Phase 3] `git show c24edbd5ae0e4`: matches the candidate diff.
- [Phase 3] `git merge-base --is-ancestor c24edbd5ae0e4 HEAD`: yes
  (already in this tree).
- [Phase 4] `b4 dig -c c24edbd5ae0e4`: msgid
  `20260615235645.737189-15-alexander.deucher@amd.com` (`15/43`).
- [Phase 4] `b4 dig -a`: v1 43-patch series 2026-06-15; v2 30-patch
  2026-07-07.
- [Phase 4] `b4 dig -w`: To/Cc Alex Deucher + amd-gfx; no stable CC.
- [Phase 4] mail-archive: posted diff identical; no NAK in the copies
  read.
- [Phase 4] UNVERIFIED: lore.kernel.org cover letter and stable@ archive
  (403/Anubis).
- [Phase 5] Callers verified: `hqd_sdma_load_v11` / `dump` /
  `is_occupied` / `destroy`; load via `kfd_load_mqd_sdma`.
- [Phase 5] `engine_id` from MQD ← `q->sdma_engine_id`; ioctl range
  check for `SDMA_BY_ENG_ID`; typical GFX11 stays 0/1.
- [Phase 5] gfx9/gfx10.3 already warn instead of `BUG()`.
- [Phase 6] `git describe HEAD` / Makefile: 7.3.0-rc4; current file
  already has `WARN()`.
- [Phase 8] Failure mode if hit: `BUG()` panic; trigger likelihood low
  on 2-engine GFX11.
- UNVERIFIED: GFX11 SKU with `engine_id >= 2` in production.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
index aaccf0b9947d4..d32ea91eeb343 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
@@ -139,7 +139,8 @@ static uint32_t get_sdma_rlc_reg_offset(struct amdgpu_device *adev,
 				regSDMA1_QUEUE0_RB_CNTL) - regSDMA0_QUEUE0_RB_CNTL;
 		break;
 	default:
-		BUG();
+		WARN(1, "Invalid SDMA engine id %d\n", engine_id);
+		break;
 	}
 
 	sdma_rlc_reg_offset = sdma_engine_reg_base
-- 
2.53.0

