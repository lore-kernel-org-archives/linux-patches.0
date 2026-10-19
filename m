Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81C6498E5;
	Mon, 19 Oct 2026 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418804; cv=none; b=IBdFcD0Uh4fq1uo7N8UhTDVJfFFqL4Xd4DVcWMJAc2Jc4U60WsXtFyXJB+Y90PYjW11dn4qF36c2UwbCfmsB7/q9ZZ4LvOQpaHGegnejxnqzWgEC6+73jzggDVTrV5P4BxiGMrUF6knOjEEjx/+faAZwNvvs+N0MPa6w1x7DAt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418804; c=relaxed/simple;
	bh=nt+AO/ghutLObfF6OY/X8l9WW5XkkHqwfjimIgOTP0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=If9IMeFtASZBcFgfxrBiXen9iTKaBuX3T1UFXWEYeg9935vYxJxdwA+xRo1WSDXPss/dpw15S2XETJ3+QlbtNT/eaard/b5c3kDRQZTlEsMZYYFK3FydImCYb6TQ38dhzyiPoKlqmTdue018ply0lXgsP778vHS0fEqkrRR/8ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNrGwj2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNrGwj2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05111F000C4;
	Mon, 19 Oct 2026 14:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418800;
	bh=ZMRJUcIVaGsiHeUnipdtBhMjjrZG7IlLuALxVE80EOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNrGwj2y/0hyQOoGJ8O0wlU3AfFEAEnNI+BLQRu2jLyXUavHmTanNxTTquB0NjMoy
	 +83FWwkaeLN1K4hBGIHvg6GZol6xSw7fD3kkTEbGZ5S8iYiiWfvwRn7dDMNQm031FZ
	 Gk9Zw1jZJn+19FYfscrx9ITDx/lJrUducZ/TD4+TplnaZVQ/X8tEbH6gGapssmr/vn
	 mi/0MbznA4IhCBh1MIbIu+jFD9/zBQfq/uLxEMNFH7CRJ7kjGknOZrjK8tXYjz+zjv
	 mkuwEQUrKk1fwwHYHGxQdfn52WX5k31YJwflwwEo+3fKp4n7fGyGPQ9h8khtFPpOtT
	 unAuZwrWKAD5w==
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
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu/gfx11: set KMD_QUEUE for kernel gfx queues
Date: Mon, 19 Oct 2026 09:53:16 -0400
Message-ID: <20261019135441.1420968-505-sashal@kernel.org>
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

[ Upstream commit 8228688eb40cc116127e80394cb8157417854c70 ]

Set KMD_QUEUE in the GFX MQD and kernel ring control registers so CP
preserves kernel IB VMIDs instead of replacing them with the queue VMID.
Use prop->kernel_queue to distinguish kernel and user MQDs.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 893642e0e3b2f5aa818e0ee4a49e2d401d541e3a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the local-tree, history, and mailing-list evidence. Compiling the
nine-phase analysis and the backport verdict next.

## Phase 1: Commit message forensics

**Step 1.1:**
Record: `[drm/amdgpu/gfx11] [set] [program KMD_QUEUE on kernel GFX
MQDs/rings so CP keeps kernel IB VMIDs]`

**Step 1.2:**
Record: tags on the upstream commit
`893642e0e3b2f5aa818e0ee4a49e2d401d541e3a`:
- Signed-off-by: Jesse Zhang `<Jesse.Zhang@amd.com>` (author)
- Reviewed-by: Alex Deucher `<alexander.deucher@amd.com>` (amdgpu
  maintainer)
- Signed-off-by: Alex Deucher `<alexander.deucher@amd.com>`
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable (absence
  expected)

Pipeline-only tags ignored: `[Upstream commit ...]`, Sasha Levin SOB,
cherry-pick marker.

**Step 1.3:**
Record:
- Bug: CP overwrites the VMID in kernel GFX IBs with the queue VMID
  unless `KMD_QUEUE` is set.
- Symptom/failure mode: IBs run in the wrong VM (queue VMID, typically
  0) instead of the IB VMID encoded by `gfx_v11_0_ring_emit_ib_gfx()`.
  That is a GPU page-fault / hang / wrong-address-space class failure.
- Version info: none in the message.
- Root cause (author): kernel GFX MQD and `CP_RB0_CNTL` never set
  `KMD_QUEUE`; `prop->kernel_queue` is the kernel-vs-user discriminator.

**Step 1.4:**
Record: Not a hidden cleanup. The subject uses “set”, but the body
describes a concrete CP mis-program. This is a hardware-programming
correctness fix.

## Phase 2: Diff analysis

**Step 2.1:**
Record:
- File: `drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c` (+2 / -0)
- Functions: `gfx_v11_0_cp_gfx_resume()`, `gfx_v11_0_gfx_mqd_init()`
- Scope: single-file surgical fix

**Step 2.2:**
Record:
- Hunk 1 (`gfx_v11_0_cp_gfx_resume`): `CP_RB0_CNTL` was built from 0
  (`RB_BUFSZ`/`RB_BLKSZ` only). After: `KMD_QUEUE=1` on the kernel GFX
  ring 0 path.
- Hunk 2 (`gfx_v11_0_gfx_mqd_init`): `CP_GFX_HQD_CNTL` started from
  `regCP_GFX_HQD_CNTL_DEFAULT` (0x00a00000). After:
  `KMD_QUEUE=prop->kernel_queue` (1 for kernel MQDs, 0 for user MQDs).
- Both are init/resume paths, not error paths.

**Step 2.3:**
Record:
- Category: hardware workaround / logic correctness (queue privilege
  bit).
- Mechanism: `KMD_QUEUE` is bit 29 of `CP_RB0_CNTL` / `CP_GFX_HQD_CNTL`
  (`0x20000000`). The default value `0x00a00000` does **not** include
  that bit. Compute kernel MQDs already set `KMD_QUEUE` when
  `prop->kernel_queue`; GFX MQDs only set `RB_NON_PRIV` for user queues
  and left kernel GFX `KMD_QUEUE` clear.

**Step 2.4:**
Record:
- Quality: obviously correct and minimal. Kernel rings
  (`amdgpu_ring_to_mqd_prop`) set `kernel_queue=true`; userq props are
  `kzalloc`’d so the bit stays 0.
- Regression risk: low. Same privilege bit already used for compute/KFD
  kernel queues. User MQDs are unchanged.
- Residual gap (not a reject): ring 1 (`CP_RB1_CNTL`) is not updated.
  That path is only `!amdgpu_async_gfx_ring && num_gfx_rings > 1`;
  default `amdgpu_async_gfx_ring=1`.

## Phase 3: Git history

**Step 3.1:**
Record:
- `CP_RB0_CNTL` programming: `3d879e81f0f9e` (“drm/amdgpu: add init
  support for GFX11 (v2)”, 2022-05-04).
- GFX MQD `CP_GFX_HQD_CNTL` setup: same commit; later `e27b36ea6ba5f2`
  switched the start value to `regCP_GFX_HQD_CNTL_DEFAULT`;
  `063d668320872` added `RB_NON_PRIV` for user queues.
- Bug is a long-standing omission on GFX11, present through v6.18.57.

**Step 3.2:**
Record: No `Fixes:` tag. Closest related change is `063d668320872` (“set
MQD as appriopriate for queue types”), already in v6.18.57. That commit
set compute `KMD_QUEUE` only for kernel queues and GFX `RB_NON_PRIV` for
user queues; it did not set GFX `KMD_QUEUE`.

**Step 3.3:**
Record: Recent `gfx_v11_0.c` on this tree includes KGQ reset/wptr fixes
and a gfx11 userq firmware-version bump (`b7cb1b6696137`). Sibling:
`53db34aed3716` (gfx12, same author/intent; pipeline-applied, ignored
for selection). This commit is standalone at the code level.

**Step 3.4:**
Record: Jesse Zhang is a regular amdgpu contributor (reset/userq/MQD).
Alex Deucher (maintainer) reviewed and applied it.

**Step 3.5:**
Record: Needs `prop->kernel_queue` (`284d4dfe850e6`, in v6.18.57),
`gfx_v11_0_gfx_mqd_init`, and `KMD_QUEUE` masks in gc_11 headers — all
present. No new helpers. Can apply standalone.

## Phase 4: Mailing list / external research

**Step 4.1:**
Record:
- `b4 dig -c 893642e0e3b2…` and `8228688eb40cc…`: lore.kernel.org
  returned errors; no b4 match.
- Found original series: [PATCH 10/21]
  https://lists.freedesktop.org/archives/amd-
  gfx/2026-September/153407.html
- Sibling [PATCH 09/21] gfx12:
  https://lists.freedesktop.org/archives/amd-
  gfx/2026-September/153406.html
- No 00/21 cover letter; series starts at 01/21 (`detect_hung_queue`).
- This is patches 09/10 of a 21-patch gfx pipe-reset / hung-queue series
  (Sep 21, 2026).
- No v2 of this hunk; committed text matches the mailed diff.
- No NAK on 09/10. No reviewer `Cc: stable` on this patch.

**Step 4.2:**
Record: Posted to amd-gfx. Alex Deucher reviewed the **entire series**
(https://lists.freedesktop.org/archives/amd-
gfx/2026-September/153488.html): “Patches 11 and 12 look like bug fixes.
Maybe move them to the start… Other than that, the series is: Reviewed-
by: Alex Deucher”. He did **not** call 09/10 out as the urgent
standalone fixes.

**Step 4.3:**
Record: No bugzilla/syzbot/user crash report attached. Severity is
inferred from the CP VMID description, not from a reproducer.

**Step 4.4:**
Record: Series is pipe-reset enablement (`detect_hung_queue`, MES
collateral restore, userq VMID for MMIO reset, pipe reset helpers).
Those later patches are **not** in this 6.18.57 tree
(`detect_hung_queue` / `amdgpu_gfx_mqd_reset_restore` grep: no matches).
This 2-line hunk does not implement pipe reset; it only programs
`KMD_QUEUE`.

**Step 4.5:**
Record: UNVERIFIED — lore.kernel.org/stable search returned 403. No
local evidence this was discussed on stable@.

## Phase 5: Code semantic analysis

**Step 5.1:**
Record: `gfx_v11_0_cp_gfx_resume`, `gfx_v11_0_gfx_mqd_init`.

**Step 5.2:**
Record:
- `gfx_v11_0_cp_gfx_resume`: called from CP resume when
  `!amdgpu_async_gfx_ring`. Default `amdgpu_async_gfx_ring=1`
  (`amdgpu_drv.c`), so this is the uncommon path.
- `gfx_v11_0_gfx_mqd_init`: registered as
  `adev->mqds[AMDGPU_HW_IP_GFX].init_mqd`. Callers:
  - `amdgpu_ring_init_mqd()` ← `gfx_v11_0_kgq_init_queue()` (default
    async KGQ resume)
  - `mes_userq_mqd_create()` ← userqueue create (`AMDGPU_USERQ` ioctl)

**Step 5.3:**
Record: Callees are `REG_SET_FIELD` / `WREG32_SOC15`. No alloc, no locks
added.

**Step 5.4:**
Record: Reachable from GPU init (every GFX11 device) and from userq
create. `gfx_v11_0_ring_emit_ib_gfx()` writes `vmid << 24` into
`PACKET3_INDIRECT_BUFFER`. That is the VMID the commit says CP will
replace without `KMD_QUEUE`. Userspace command submission uses this
path.

**Step 5.5:**
Record: Same bit already set for gfx11 compute kernel MQDs, MES v11/v12,
gfx7–10 compute, and KFD MQD managers. GFX11/12 GFX HQD was the missing
counterpart. Sibling gfx12 patch is the same change.

## Phase 6: Cross-reference against this tree

**Step 6.1:**
Record: Local tree is **6.18.57** (`make kernelversion`, `git describe
HEAD` → `v6.18.57-155-gcdf239ca885b2`).
v6.18.57 `gfx_v11_0.c` does **not** set `KMD_QUEUE` in either site.
GFX11 support and `prop->kernel_queue` are in this tree. The bug exists
here.

**Step 6.2:**
Record: Expected apply: **clean**. Context around both
`REG_SET_FIELD(..., RB_BLKSZ, ...)` sites matches the patch. Register
masks exist in `gc_11_*_sh_mask.h`.

**Step 6.3:**
Record: `063d668320872` is present (partial MQD privilege split). No
other commit in v6.18.57 sets GFX `KMD_QUEUE`. The checkout copy at
`7bb279e35c0e1` is the autosel candidate (Sasha Levin), ignored as
selection evidence.

## Phase 7: Subsystem context

**Step 7.1:**
Record: `[drm/amdgpu GFX11] [IMPORTANT]` — RDNA3 (RX 7000 / Phoenix /
etc.), not core mm/fs, but a very common GPU driver.

**Step 7.2:**
Record: Active. Recent 6.18 work includes KGQ reset, userq firmware
versions, MQD priority.

## Phase 8: Impact and risk

**Step 8.1:**
Record: Driver-specific: amdgpu GFX11. Default 6.18 still uses kernel
GFX queues (`amdgpu_user_queue=-1` → `disable_uq=true`). User queues
exist and can be enabled (`user_queue=1/2`).

**Step 8.2:**
Record:
- Trigger: GFX11 init (MQD/KGQ) and any kernel GFX IB with a non-queue
  VMID.
- How common: every GFX11 boot programs the MQD; every gfx IB encodes a
  VMID.
- Unprivileged trigger: yes, via normal render/compute submit.
- Caveat: GFX11 has worked since ~5.19 without this bit, so either older
  CP/MES ignored it, or firmware already special-cased kernel queues.
  The bit becomes more important once user GFX queues share the same MQD
  path and newer FW consults `KMD_QUEUE`.

**Step 8.3:**
Record: Failure mode: CP forces IB VMID = queue VMID → GPUVM fault,
hang/reset, or execution in the wrong VM. Severity: **HIGH** when it
fires (GPU hang / possible wrong-VM access). Everyday 6.18 default may
still appear fine if firmware papers over the missing bit.

**Step 8.4:**
Record:
- Benefit: medium-high — correct kernel-queue privilege on widely
  deployed GFX11, completes an already-stable MQD split, prevents wrong-
  VMID IBs.
- Risk: very low — two `REG_SET_FIELD` lines, no API/locking/data-
  structure change.
- Ratio: favorable.

## Phase 9: Final synthesis

**Step 9.1:**
Evidence FOR:
- Real CP programming bug: missing `KMD_QUEUE` lets CP replace kernel IB
  VMIDs.
- Two-line, obviously correct, applies cleanly to v6.18.57.
- All prerequisites exist (`kernel_queue`, GFX11 MQD, register masks).
- Completes `063d668320872`, which already went to stable for kernel-vs-
  user MQD privileges.
- Compute/KFD already set this bit; GFX11 was inconsistent.
- Maintainer Reviewed-by.
- Wrong VMID is hang/fault/wrong-VM — important if triggered.
- Hardware-programming / quirk-like change, not a feature.

Evidence AGAINST:
- Landed as 10/21 of a pipe-reset series; later patches are not in
  6.18.57.
- Alex called out 11/12 as the “bug fixes,” not this one.
- No user report, syzbot, Fixes, or crash log.
- Omission dates to 2022; default 6.18 GFX11 is usable without the bit.
- Ring 1 `CP_RB1_CNTL` left unchanged (rare path).

Unresolved:
- Exact firmware versions that started replacing IB VMIDs (UNVERIFIED).
- Whether MES already ORs `KMD_QUEUE` when mapping KGQ (UNVERIFIED).
- stable@ discussion (lore 403 / b4 failed).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — 2 lines, maintainer
   reviewed, matches existing compute/KFD pattern.
2. Fixes a real bug that affects users? **PASS** — missing privilege bit
   on kernel GFX queues; CP VMID overwrite is a real HW behavior the
   author states.
3. Important issue? **PASS** — wrong VMID is GPU fault/hang / wrong
   address space (HIGH), not a style cleanup.
4. Small and contained? **PASS** — +2 lines, one file.
5. No new features or APIs? **PASS** — only sets an existing register
   field.
6. Can apply to the local tree? **PASS** — v6.18.57 has the buggy sites
   and dependencies.

**Step 9.3:**
Record: Fits the **hardware workaround / register programming**
exception. Not a new driver or API.

**Step 9.4:**
This is a self-contained GFX11 hardware-programming fix. The local
6.18.57 tree has the buggy code and the `kernel_queue` split, and the
patch applies cleanly. Being mailed inside a pipe-reset series does not
make the two lines a feature: they do not enable pipe reset, and they
correct kernel GFX MQD privilege that compute already had. Benefit vs
risk favors backport.

### What the commit solves for this tree
On GFX11, kernel GFX IBs put a process VMID in
`PACKET3_INDIRECT_BUFFER`. Without `KMD_QUEUE`, CP is specified to
replace that with the queue VMID (0). This tree already distinguishes
user vs kernel MQDs for compute/`RB_NON_PRIV` but never sets GFX
`KMD_QUEUE`. That is a real, small correctness hole on a widely used GPU
generation.

### Risk vs benefit
Two register-field writes; user MQDs stay 0; no API change. Residual
risk is a firmware-specific privilege change, which is the intended
kernel-queue behavior already used on compute.

### Concerns
No public reproducer; later pipe-reset patches are not in 6.18.57; ring1
legacy path not updated. None of those block a clean 2-line apply.

Verification:
- [Phase 1] Parsed tags: author Jesse Zhang; Reviewed-by/SOB Alex
  Deucher; no Fixes/Reported-by/Link/Cc:stable
- [Phase 2] Diff: +2 lines in `gfx_v11_0_cp_gfx_resume` and
  `gfx_v11_0_gfx_mqd_init`
- [Phase 2] `regCP_GFX_HQD_CNTL_DEFAULT=0x00a00000`; `KMD_QUEUE` mask
  `0x20000000` — default does not set the bit
- [Phase 3] Blame: GFX11 init `3d879e81f0f9e` (2022); `063d668320872`
  and `284d4dfe850e6` are ancestors of v6.18.57
- [Phase 3] `git merge-base --is-ancestor 893642e0e3b2… v6.18.57` → not
  ancestor (fix not in 6.18.57)
- [Phase 4] `b4 dig` failed (lore server error)
- [Phase 4] lore URL: https://lists.freedesktop.org/archives/amd-
  gfx/2026-September/153407.html (10/21)
- [Phase 4] Alex series review:
  https://lists.freedesktop.org/archives/amd-
  gfx/2026-September/153488.html
- [Phase 5] Callers: KGQ `amdgpu_ring_init_mqd`; userq
  `mes_userq_mqd_create`; IB VMID in `gfx_v11_0_ring_emit_ib_gfx`
- [Phase 5] semcode unavailable; used grep/read
- [Phase 6] `make kernelversion` / `git describe`: 6.18.57 /
  `v6.18.57-155-gcdf239ca885b2`
- [Phase 6] v6.18.57 file confirmed missing both `KMD_QUEUE` assignments
- [Phase 8] Failure mode: wrong IB VMID → GPU fault/hang; severity HIGH
  when triggered
- UNVERIFIED: firmware versions that require the bit; whether MES
  already sets it; stable@ history (lore 403)

**YES**

 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index a78e8f98f4d00..5ade48c8d43f8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -3737,6 +3737,7 @@ static int gfx_v11_0_cp_gfx_resume(struct amdgpu_device *adev)
 	rb_bufsz = order_base_2(ring->ring_size / 8);
 	tmp = REG_SET_FIELD(0, CP_RB0_CNTL, RB_BUFSZ, rb_bufsz);
 	tmp = REG_SET_FIELD(tmp, CP_RB0_CNTL, RB_BLKSZ, rb_bufsz - 2);
+	tmp = REG_SET_FIELD(tmp, CP_RB0_CNTL, KMD_QUEUE, 1);
 	WREG32_SOC15(GC, 0, regCP_RB0_CNTL, tmp);
 
 	/* Initialize the ring buffer's write pointers */
@@ -4145,6 +4146,7 @@ static int gfx_v11_0_gfx_mqd_init(struct amdgpu_device *adev, void *m,
 	tmp = regCP_GFX_HQD_CNTL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BUFSZ, rb_bufsz);
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BLKSZ, rb_bufsz - 2);
+	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, KMD_QUEUE, prop->kernel_queue);
 #ifdef __BIG_ENDIAN
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, BUF_SWAP, 1);
 #endif
-- 
2.53.0

