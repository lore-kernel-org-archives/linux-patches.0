Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE02A50B390;
	Mon, 19 Oct 2026 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418746; cv=none; b=X0DoOlJDuUezr+s9JAO4iIdTtZC2jCE3UgYUQHm3gCjpY369TaXCuWx8bQ4xJgWoLew9KUnHqO+1RFHg3t36f/f4Z+NTKwcgBeilYxs9NKwvvSzLJhEMCNDscv9SYG/6S3IkXNw9MyRtAx3itk/7JQV/+NXvlbpk7hK+Ka1sRzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418746; c=relaxed/simple;
	bh=OKR8MfhjCT4d494Ibm69L1jmkmuwbzzvmUPQL48nEQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lv/ZbwVToFeY4uHLawN9N9WwT4WEsKiNa2sgjsGMzMMom7KL6VSHSIIBwODKcF06Gu4qUQj2phS4ElHYrhpXCUTBNOHrOXINOa9IxhCCOZ0ilIXGl96w/8+8y8fUdPYO3LHUl+fSGmi7ZdkVpkVsxpWvgNBJbU2MFnQPcw8yQPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zz2k3LNS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zz2k3LNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B631F000C7;
	Mon, 19 Oct 2026 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418743;
	bh=eqR8+KOPZ8pnk+K+E0eR+FyydimkvuSbCbmBAmeToow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zz2k3LNSG+Lv80/ElMbkkFOzBEwLn+W64zWbxH7AIsXE+yPQKH6Eu9CPt3dIgS5gg
	 1wAwl/qnH44iTvDfJVV2ub1suR8v6cTSpxwOcvidEB74AZdtQnRyQU21sMphXUluyl
	 jaOuBzzvAWRRZhhEp3z2ml0VTzHD+HccxchaovNIMf/T4JblJ1UTb5r/9gFCJ9lf49
	 DuNMcrXwWeSexOj06APVGEghOb8YfgtKreNpsle5dnRwz+3rHRJ8aaQQZ2LLeYiXjb
	 Z02RePIpxhYZuvvqPvd/8cWzaCdGjhQoog7YaQEYnIoeEyiF4cZOCIvp9GJ3jrEAiS
	 /XXhham7UurVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu/gfx12: set KMD_QUEUE for kernel gfx queues
Date: Mon, 19 Oct 2026 09:52:35 -0400
Message-ID: <20261019135441.1420968-464-sashal@kernel.org>
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

[ Upstream commit 9fe5745f9d8eca38d31d9b672a1998edf856f651 ]

Set KMD_QUEUE in the GFX MQD and kernel ring control registers so CP
preserves kernel IB VMIDs instead of replacing them with the queue VMID.
Use prop->kernel_queue to distinguish kernel and user MQDs.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 14741c01680a803050e949744089b57fa53e02f7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough tree, diff, and caller evidence to judge this for 6.18.57.
Lore lookups failed with 403, so mailing-list review is limited to the
amd-gfx archive title and the commit tags.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[drm/amdgpu/gfx12] [set] [program KMD_QUEUE on kernel GFX
  queues so CP keeps kernel IB VMIDs]`

**Step 1.2 — Tags**
- Record:
  - `Reviewed-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
    maintainer)
  - `Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>` (author)
  - `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>`
    (maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc: stable`
    (absence expected for this review)
  - Pipeline-only markers ignored: `[Upstream commit ...]`, `(cherry
    picked from ...)`, `Signed-off-by: Sasha Levin`

**Step 1.3 — Body**
- Record:
  - Bug: CP replaces kernel IB VMIDs with the queue VMID unless
    `KMD_QUEUE` is set
  - Symptom: kernel IBs run in the wrong VM (queue VMID, typically 0)
  - Root cause: GFX MQD and `CP_RB0_CNTL` never programmed `KMD_QUEUE`
  - Fix: set the bit from `prop->kernel_queue` (MQD) and hard-set 1 on
    the kernel ring
  - No stack trace, repro, or version range in the message

**Step 1.4 — Hidden bug fix?**
- Record: Not disguised. It is an explicit hardware-programming
  correctness fix.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: `drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c` only; `+2 / -0`
- Functions: `gfx_v12_0_cp_gfx_resume()`, `gfx_v12_0_gfx_mqd_init()`
- Scope: single-file surgical fix

**Step 2.2 — Control-flow change**
- Hunk 1 (`gfx_v12_0_cp_gfx_resume`): `CP_RB0_CNTL` was built with
  `RB_BUFSZ`/`RB_BLKSZ` only (base 0). After: `KMD_QUEUE=1` on kernel
  gfx ring 0. Init/resume path, used when `amdgpu_async_gfx_ring` is 0.
- Hunk 2 (`gfx_v12_0_gfx_mqd_init`): `CP_GFX_HQD_CNTL` was built from
  `regCP_GFX_HQD_CNTL_DEFAULT` (0x00f00000). After:
  `KMD_QUEUE=prop->kernel_queue`. This is the default MQD path
  (`amdgpu_async_gfx_ring` defaults to 1).

**Step 2.3 — Bug mechanism**
- Record: `[logic / hardware programming] [CP overwrites IB VMID unless
  KMD_QUEUE; fix sets that bit on kernel queues only]`
- `KMD_QUEUE` is bit 29 (`0x20000000`). Default `0x00f00000` does not
  include it. `CP_RB0_CNTL` starts from 0, so it was also clear.
- Same file already sets `KMD_QUEUE` for compute kernel queues in
  `gfx_v12_0_compute_mqd_init()`. GFX was the missing counterpart.

**Step 2.4 — Fix quality**
- Record: Minimal and obviously correct. User MQDs keep `KMD_QUEUE=0`
  because `mes_userq_mqd_create()` `kzalloc`s `amdgpu_mqd_prop`. Kernel
  rings set `prop->kernel_queue = true` in `amdgpu_ring_to_mqd_prop()`.
  Regression risk is low: it matches the existing compute-queue
  programming.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Surrounding GFX resume/MQD setup comes from `52cb80c12e8a64`
  (`drm/amdgpu: Add gfx v12_0 ip block support (v6)`, 2023-07-04). The
  missing bit has been absent since GFX12 was added.

**Step 3.2 — Fixes: tag**
- Record: No `Fixes:` tag. Bug is the original GFX12 bring-up omitting
  `KMD_QUEUE`. That bring-up commit is an ancestor of this tree.

**Step 3.3 — File history**
- Record: Prerequisite already here: `7b9110f289795` (`drm/amdgpu/gfx12:
  set MQD as appriopriate for queue types`) added `prop->kernel_queue` /
  `RB_NON_PRIV` and compute `KMD_QUEUE`. Present in v6.18.57. This
  commit is standalone, not patch 2/3 of that older series.

**Step 3.4 — Author**
- Record: Jesse Zhang is a regular amdgpu contributor. Same-day sibling:
  `drm/amdgpu/gfx11: set KMD_QUEUE for kernel gfx queues`. Maintainer
  reviewed both.

**Step 3.5 — Dependencies**
- Record: Needs `bool kernel_queue` in `amdgpu_mqd_prop`
  (`284d4dfe850e6`, in v6.18.57) and `CP_*_KMD_QUEUE` masks in
  `gc_12_0_0_sh_mask.h` (present). Can apply standalone. No new helpers.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
- Record: `b4 dig -c 14741c01680a` / `9fe5745f9d8e` / `53db34aed371`
  failed (lore returned an error). Fallback: amd-gfx September 2026
  archive lists `[PATCH 09/21] drm/amdgpu/gfx12: set KMD_QUEUE for
  kernel gfx queues` next to hung-queue / pipe-reset patches. No NAK
  found. No later conflicting revision found.

**Step 4.2 — Reviewers**
- Record: `b4 dig -w` failed (same lore error). Commit has `Reviewed-by`
  / `Signed-off-by` from Alex Deucher.

**Step 4.3 — Bug report**
- Record: No `Reported-by` / syzbot / bugzilla link. Mechanism is stated
  by the AMD author.

**Step 4.4 — Series**
- Record: Submitted as 09/21 in a hung-queue/reset series. This hunk
  does not call any of those new helpers; it is self-contained register
  programming.

**Step 4.5 — Stable list**
- Record: No useful stable-list hit for this subject. UNVERIFIED whether
  anyone already requested or rejected it for stable.

## Phase 5: Semantic / call-chain

**Step 5.1 — Functions**
- Record: `gfx_v12_0_cp_gfx_resume`, `gfx_v12_0_gfx_mqd_init`

**Step 5.2 — Callers**
- Record:
  - `gfx_v12_0_cp_gfx_resume` ← GFX hw init when
    `!amdgpu_async_gfx_ring` (module param default is 1, so this is the
    fallback)
  - `gfx_v12_0_gfx_mqd_init` ← `adev->mqds[AMDGPU_HW_IP_GFX].init_mqd` ←
    `amdgpu_ring_init_mqd()` ← `gfx_v12_0_kgq_init_queue()` (default
    async KGQ path) and `mes_userq_mqd_create()` (user queues,
    `kernel_queue==false`)

**Step 5.3 — Callees**
- Record: `REG_SET_FIELD`, `WREG32_SOC15`. No alloc/lock/API change.

**Step 5.4 — Reachability**
- Record: Yes. Default GFX12 init uses KGQ MQD init.
  `gfx_v12_0_ring_emit_ib_gfx()` writes `control |= ib->length_dw |
  (vmid << 24)` with `AMDGPU_JOB_GET_VMID(job)`. Userspace CS on a
  kernel gfx ring therefore depends on CP honoring that IB VMID.

**Step 5.5 — Similar patterns**
- Record: Compute MQD in the same file already sets `KMD_QUEUE` for
  kernel queues. GFX11 sibling does the same two-line change. KFD MQD
  managers also set `KMD_QUEUE` for kernel queues.

## Phase 6: This tree (6.18.57)

**Step 6.1 — Does the bug exist here?**
- Record: Local tree is **v6.18.57** (`git describe HEAD` =
  `v6.18.57-155-gcdf239ca885b2`, Makefile 6.18.57).
- `git merge-base --is-ancestor 14741c01680a HEAD` → not an ancestor.
- `v6.18.57:drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c` does **not** set
  `KMD_QUEUE` in `gfx_v12_0_cp_gfx_resume` / `gfx_v12_0_gfx_mqd_init`.
  The compute path already does. GFX12 IP has been in this line since
  `52cb80c12e8a64`.

**Step 6.2 — Backport difficulty**
- Record: Clean apply. v6.18.57 context matches the hunks exactly.

**Step 6.3 — Related fixes already here?**
- Record: `7b9110f289795` is in v6.18.57 and handles compute `KMD_QUEUE`
  / GFX `RB_NON_PRIV`. It does not set GFX `KMD_QUEUE`. No equivalent
  GFX12 fix is in v6.18.57.

## Phase 7: Subsystem context

**Step 7.1**
- Record: `[drm/amdgpu GFX12] [IMPORTANT — common AMD GPU driver, RDNA4
  / RX 9000 class]`

**Step 7.2**
- Record: Active but mature GFX12 support in 6.18. This is a leftover
  bring-up omission, not a brand-new subsystem.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: GFX12 amdgpu users (config/driver-specific). Not universal.

**Step 8.2 — Trigger**
- Record: Device init (MQD/`CP_RB0_CNTL` programming), then any kernel
  gfx IB whose VMID ≠ queue VMID. Unprivileged users trigger this via
  normal command submission. Default path is async KGQ
  (`amdgpu_async_gfx_ring=1`).

**Step 8.3 — Failure mode**
- Record: Wrong GPU VMID → GFXHUB page fault, ring timeout, GPU reset,
  or access in the wrong address space. Severity: **HIGH** (GPU hang /
  fault; possible wrong-VM access).

**Step 8.4 — Risk vs benefit**
- Record: Benefit high for GFX12 boxes. Risk very low (2 lines, kernel
  queues only, same pattern as compute). Ratio favors backport.

## Phase 9: Synthesis

**Evidence for**
- Real CP programming bug: kernel IB VMIDs can be replaced with queue
  VMID 0
- `gfx_v12_0_ring_emit_ib_gfx()` puts the job VMID in the IB; that path
  is live
- Compute KGQ already sets `KMD_QUEUE`; GFX did not
- 2-line, obviously correct, maintainer-reviewed
- Bug and prerequisites exist in v6.18.57; applies cleanly
- No new API/feature

**Evidence against**
- No public repro, syzbot, or `Fixes:` tag
- Everyday GFX12 has worked since bring-up, so firmware or privilege
  bits may mask this in some cases
- Submitted as 09/21 in a larger reset series (but this hunk is
  independent)
- Lore/b4 review thread could not be fetched (server 403)

**Unresolved**
- Full reviewer discussion beyond `Reviewed-by: Alex Deucher`
- Whether a specific firmware version started enforcing VMID replacement
- Stable-list history for this exact subject

**Stable rules**
1. Obviously correct and tested? **PASS** — two `REG_SET_FIELD`s;
   maintainer reviewed
2. Real user-facing bug? **PASS** — wrong IB VMID on kernel GFX queues
3. Important (fault/hang/wrong VM)? **PASS** — HIGH, not cosmetic
4. Small and contained? **PASS** — +2 lines, one file
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** — v6.18.57 has the buggy code and
   prerequisites

**Exception category:** hardware programming / quirk-like register bit
on an existing driver. Not a new driver or API.

This belongs on 6.18.57. The tree has GFX12, still omits GFX
`KMD_QUEUE`, and the fix is a two-line register correction with the same
`kernel_queue` distinction already used for compute MQDs.

### What the commit solves for this tree
On GFX12, kernel gfx rings submit `PACKET3_INDIRECT_BUFFER` with a job
VMID. Without `KMD_QUEUE`, CP is specified to replace that VMID with the
queue VMID (0). That is a GPU address-space bug: faults, hangs, or
wrong-VM access. v6.18.57 already has the `kernel_queue` flag and
compute `KMD_QUEUE`; this only fills the GFX gap.

### Risk vs benefit
Benefit is correct VMID handling on RDNA4 kernel gfx queues. Risk is a
two-line bit set on kernel queues only; user queues stay unset.

Verification:
- [Phase 1] Parsed tags: Reviewed-by/SOB Alex Deucher; no
  Fixes/Reported-by/Link
- [Phase 2] Diff: +2 lines in `gfx_v12_0_cp_gfx_resume` and
  `gfx_v12_0_gfx_mqd_init`
- [Phase 2] `regCP_GFX_HQD_CNTL_DEFAULT` is `0x00f00000`; `KMD_QUEUE`
  mask is `0x20000000` — default does not set the bit
- [Phase 2] Userq path: `mes_userqueue.c` kzallocs props, so
  `kernel_queue` stays false
- [Phase 2] Kernel rings: `amdgpu_ring.c` sets `prop->kernel_queue =
  true`
- [Phase 3] Blame: GFX12 setup from `52cb80c12e8a64` (2023); `KMD_QUEUE`
  never set on GFX
- [Phase 3] Prerequisite `7b9110f289795` / `284d4dfe850e6` are ancestors
  of v6.18.57
- [Phase 3] `git merge-base --is-ancestor 14741c01680a HEAD` → not
  present as that SHA
- [Phase 4] `b4 dig` failed (lore server error) — UNVERIFIED full thread
  text
- [Phase 4] amd-gfx Sept 2026 archive: `[PATCH 09/21] drm/amdgpu/gfx12:
  set KMD_QUEUE for kernel gfx queues`
- [Phase 4] lore.kernel.org WebFetch 403; no stable-list discussion
  found
- [Phase 5] Default init: `amdgpu_async_gfx_ring=1` →
  `gfx_v12_0_kgq_init_queue` → `gfx_v12_0_gfx_mqd_init`
- [Phase 5] `gfx_v12_0_ring_emit_ib_gfx` encodes VMID at bit 24
- [Phase 6] `git describe HEAD`: v6.18.57-155-gcdf239ca885b2; Makefile
  6.18.57
- [Phase 6] `git show v6.18.57:drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c`:
  GFX `KMD_QUEUE` missing; compute path present
- [Phase 8] Failure mode: GPU VM fault / hang / wrong address space —
  HIGH
- UNVERIFIED: exact firmware interaction that kept some GFX12 systems
  working without this bit

**YES**

 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index 433381f806b2b..06fde713b9229 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -2733,6 +2733,7 @@ static int gfx_v12_0_cp_gfx_resume(struct amdgpu_device *adev)
 	rb_bufsz = order_base_2(ring->ring_size / 8);
 	tmp = REG_SET_FIELD(0, CP_RB0_CNTL, RB_BUFSZ, rb_bufsz);
 	tmp = REG_SET_FIELD(tmp, CP_RB0_CNTL, RB_BLKSZ, rb_bufsz - 2);
+	tmp = REG_SET_FIELD(tmp, CP_RB0_CNTL, KMD_QUEUE, 1);
 	WREG32_SOC15(GC, 0, regCP_RB0_CNTL, tmp);
 
 	/* Initialize the ring buffer's write pointers */
@@ -3025,6 +3026,7 @@ static int gfx_v12_0_gfx_mqd_init(struct amdgpu_device *adev, void *m,
 	tmp = regCP_GFX_HQD_CNTL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BUFSZ, rb_bufsz);
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BLKSZ, rb_bufsz - 2);
+	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, KMD_QUEUE, prop->kernel_queue);
 #ifdef __BIG_ENDIAN
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, BUF_SWAP, 1);
 #endif
-- 
2.53.0

