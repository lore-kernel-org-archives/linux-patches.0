Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258A3525A6F;
	Mon, 31 Aug 2026 13:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183874; cv=none; b=osrvLkCT+MQPyv3jks5uA5bqOmzTg3AxIjCcExjtUyefowtqeX0zPzd/nqViKOqJnP6XOMN79ZTSqGxP+6qNUp1n8UgKOIzwWzdYRcoOEu+I0yWi4g0ytPVpfOMc4h8UsvwotSBZKnbTM7U+Xsp8+Fxrbs6wD00AU194Er2moIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183874; c=relaxed/simple;
	bh=dVyXwQpOhSlcZaeS+Pb9nWCK/YswTgLI3aEufnhu3s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IewIwnkwhcoMZyYlOfupeTDUIm64loriyXliV07h591jUe2HlNk/BGJFCN1TIoiiKVzoO0sjOP4JLxBj8hNOm3wjg8B1YbunSrNZRfoOHr4EqPCU9/HEvtV03gJgfNuFiloDiHUlLdzzCPNl/FF/aMF8U8q7YXtfmhjYz0Yeb6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrNnvBr5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrNnvBr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDCA1F00A3E;
	Mon, 31 Aug 2026 13:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183872;
	bh=XrswinvKlteXXsU1UUGMT4NTv9PprhYDQw1IswwUcS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrNnvBr5mEbzF9Q50Kvr3k9rdeRmQ30PtmQzo2LSicvP00T5TAgCnoCH1cCxV6afp
	 LHWdsGnZgcDkjXHRHjW8acaqMF3t8OzMrdZMtsIhSUIeukJO4GTmsROw2YWM8BYUxV
	 JJrEbn/hkpL841z26ZM8XJDFxT6rze2pNG96wFWUX/uylmDU7ZiFLdEhpyA5JSJgtQ
	 w9joExCQvynGEiYXK0XOK60UnnSnJOuOpBeiTH85KERO1TvIBg5bqwGaVcuIcl7v9i
	 3xOW+DaaTRqjVu20sBOu4Qyl+96wyXZzMpadOCb0gdGaO7e7BmyjG5KOKOLOrGk3l1
	 aslU7tliKmYPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu/userq: pin mqd and fw object bo to avoid eviction
Date: Mon, 31 Aug 2026 09:26:21 -0400
Message-ID: <20260831133314.4125787-353-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit a3bbf32a336939a1d21b9561f8e53333b684b7ef ]

mqd and fw objects are queue core objects which should remain
valid and never be unmapped and evicted for user queues to work
properly.

During eviction if these buffers are evicted the hw continue to
use the invalid addresses and caused page faults and system hung.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amdgpu/userq: pin mqd and fw object bo
to avoid eviction`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, `make kernelversion` → `6.18.43`)

**Upstream commit:** `a3bbf32a336939a1d21b9561f8e53333b684b7ef` (not
present in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[drm/amdgpu/userq]` — implicit **fix** (prevent eviction) —
**pin MQD and firmware-object BOs so they are not evicted while user
queues are active**.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — none (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Christian König `<christian.koenig@amd.com>`
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org:** — none (not a negative signal)
- **Signed-off-by:** Sunil Khatri (author), Alex Deucher (maintainer
  merge)
- **Notable:** Reviewed-by from AMDGPU subsystem maintainer; no
  syzbot/reporter tags

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** MQD and firmware context objects are core user-queue state;
  they must stay mapped and valid for the lifetime of an active queue.
- **Symptom:** Under eviction (memory pressure), these BOs can be
  evicted while hardware still references their GPU addresses → GPU page
  faults → **system hang**.
- **Root cause (author):** Objects were created as kernel BOs in GTT but
  were not pinned, unlike other queue-critical objects.
- **Version info:** None in the message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised as cleanup — this is an explicit stability
fix. Pinning prevents TTM eviction of BOs the GPU firmware still uses.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c` (+10 / −3)
- **Functions modified:** `amdgpu_userq_create_object()`,
  `amdgpu_userq_destroy_object()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow change (per hunk)
**Record:**
- **Hunk 1 (`create_object`):** Before → reserve BO, alloc GART, kmap.
  After → **pin BO first**, then GART/kmap; error paths goto `unpin_bo`
  before `unresv`.
- **Hunk 2 (`destroy_object`):** Before → kunmap + unref. After → kunmap
  + **unpin** + unref.
- **Paths affected:** Queue object creation/destruction for MQD and
  firmware context objects.

### Step 2.3: Bug mechanism
**Record:** **Memory safety / resource lifetime bug.** MQD
(`queue->mqd`) and firmware context (`queue->fw_obj`) BOs created via
`amdgpu_userq_create_object()` were evictable. Doorbell objects in the
same file were already pinned (`amdgpu_bo_pin(...,
AMDGPU_GEM_DOMAIN_DOORBELL)` at line 331). MQD/fw objects were an
oversight.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Mirrors existing doorbell pinning pattern in
  the same file.
- **Minimal:** 10 lines, proper error-path cleanup (`unpin_bo` label).
- **Regression risk:** Low — pinning is standard for BOs hardware must
  keep resident; unpin on destroy balances pin on create.
- **Reviewer note:** Christian König suggested eviction-fence
  association as a future improvement but gave **Reviewed-by** for
  pinning as an immediate fix.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** `amdgpu_userq_create_object()` / `destroy_object()` present
in `7b923c78b50d2` (v6.18.43 tag) **without** pinning. `amdgpu_userq.c`
also exists in `v6.17` and `v6.18` tags. Bug predates the fix commit.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File history for related changes
**Record:** Patch is **v2 2/2** in series with `drm/amdgpu/userq: use
drm_exec in amdgpu_userq_fence_read_wptr` (patch 1/2, different file:
`amdgpu_userq_fence.c`). **This patch is standalone** — no dependency on
patch 1/2.

### Step 3.4: Author's other commits
**Record:** Sunil Khatri is an active AMDGPU userq contributor (multiple
userq fixes in drm tree). Alex Deucher merged; Christian König reviewed.

### Step 3.5: Prerequisites
**Record:** No prerequisites. `amdgpu_bo_pin()` / `amdgpu_bo_unpin()`
exist in this tree (`amdgpu_object.c`). `git show a3bbf32... | git apply
--check` succeeds on current checkout.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **b4 dig -c a3bbf32a336939a1d21b9561f8e53333b684b7ef:**
  https://patch.msgid.link/20260508103910.2442183-2-sunil.khatri@amd.com
- **b4 dig -a:** v1 single patch, v2 two-patch series; committed version
  matches v2 2/2
- **Reviewer feedback:** Christian König: "We should probably use the
  eviction fence instead of pinning, but that can come in a later patch
  set." → **Reviewed-by for now.** Author agreed pinning is acceptable
  interim fix.

### Step 4.2: Reviewers
**Record:** **b4 dig -w:** To/CC: Sunil Khatri, Alex Deucher, Christian
König, amd-gfx@lists.freedesktop.org — appropriate maintainer coverage.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Hang described in
commit message and patch submission; no stack trace provided.

### Step 4.4: Related patches
**Record:** Patch 1/2 (drm_exec locking in fence read) is independent.
Not required for this fix.

### Step 4.5: Stable mailing list
**Record:** Not searched on lore stable (Anubis blocked direct lore
fetch). No explicit stable nomination found in accessible amd-gfx
thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `amdgpu_userq_create_object()`,
`amdgpu_userq_destroy_object()`

### Step 5.2: Callers
**Record:** `mes_userqueue.c`:
- `mes_userq_create_ctx_space()` → `amdgpu_userq_create_object(uq_mgr,
  &queue->fw_obj, ...)` (fw context)
- MQD setup → `amdgpu_userq_create_object(uq_mgr, &queue->mqd, ...)`
  (line 266)
- Destroy paths call `amdgpu_userq_destroy_object()` for both objects

### Step 5.3: Callees
**Record:** `amdgpu_bo_create`, `amdgpu_bo_reserve`,
**`amdgpu_bo_pin`**, `amdgpu_ttm_alloc_gart`, `amdgpu_bo_kmap`,
`amdgpu_bo_kunmap`, **`amdgpu_bo_unpin`**, `amdgpu_bo_unref`

### Step 5.4: Call chain / reachability
**Record:**
`userspace DRM_IOCTL_AMDGPU_USERQ (CREATE)` → `amdgpu_userq_ioctl()` →
`amdgpu_userq_create()` → MES userq setup →
`amdgpu_userq_create_object()` for MQD/fw_obj.

**Reachable from userspace** by processes with DRM render access on
supported AMDGPU hardware (GFX11+ with MES userq support). Trigger
requires active user queues plus memory eviction pressure.

### Step 5.5: Similar patterns
**Record:** Doorbell pinning already done in
`amdgpu_userq_get_doorbell_index()` (line 331). Fix aligns MQD/fw_obj
with that established pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **YES.** At `7b923c78b50d2` and current HEAD,
`amdgpu_userq_create_object()` has no `amdgpu_bo_pin()`; only doorbell
path pins. Fix commit `a3bbf32` is **not** an ancestor of HEAD (`merge-
base --is-ancestor` returned 1).

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` passes with no
conflicts. Line numbers differ slightly from upstream diff (487 vs 243)
but context matches.

### Step 6.3: Related fixes already present?
**Record:** No equivalent pinning for MQD/fw_obj found. Doorbell pinning
present; this fix completes the pattern.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/gpu/drm/amd/amdgpu** — IMPORTANT (AMD GPU users;
not universal core kernel, but affects all userq users on supported
hardware).

### Step 7.2: Subsystem activity
**Record:** Userq subsystem actively developed in 6.18.y (multiple
userq-related stable fixes in drm-fixes stream). Feature is present and
enabled via existing IOCTL path.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of **AMDGPU user mode queues** on hardware where
`userq_funcs` is registered (GFX11/GFX12, SDMA v6/v7, etc.). Config:
`CONFIG_DRM_AMDGPU` with userq-capable ASIC.

### Step 8.2: Trigger conditions
**Record:** Create user queues via `DRM_AMDGPU_USERQ`, then
**VRAM/memory pressure triggers TTM eviction** while queues are active.
Not every boot — requires memory pressure plus active userq workloads.
Triggerable by unprivileged render-capable processes.

### Step 8.3: Failure mode severity
**Record:** GPU page faults from stale MQD/fw addresses → **system
hang**. Severity: **CRITICAL**.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for userq users — prevents GPU hangs under memory
  pressure
- **Risk:** LOW — 10-line change, established pin/unpin API, reviewed by
  maintainer
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Fixes real system hang (page faults → hang) under eviction
- Small, surgical, reviewed by Christian König, merged by Alex Deucher
- Mirrors existing doorbell pinning in same file
- Applies cleanly to 6.18.43
- Buggy code confirmed present in this tree
- Standalone — no series dependency

**AGAINST backport:**
- Userq is a relatively new feature (not all stable users enable it)
- Pinning is acknowledged as interim; eviction-fence integration
  preferred long-term
- No syzbot/reporter — harder to quantify frequency
- Affects driver-specific path, not core kernel

**Unresolved:** Exact reproduction rate in production; no public CVE or
bugzilla reference.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — pattern matches doorbell
   pinning; reviewed by maintainer
2. Fixes real bug affecting users? **PASS** — hang under eviction with
   active user queues
3. Important issue? **PASS** — CRITICAL (system hang)
4. Small and contained? **PASS** — 1 file, +10/−3
5. No new features/APIs? **PASS** — lifecycle fix only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale

For **Linux 6.18.y**, the userq infrastructure is present and the bug is
real: MQD and firmware context BOs can be evicted while hardware still
references them, causing hangs. The fix is minimal, maintainer-reviewed,
follows an existing pattern in the same file, and applies cleanly. While
userq affects a subset of AMDGPU users, a system hang under memory
pressure meets stable criteria for important fixes.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and `git show a3bbf32`
- **[Phase 1]** Reviewed-by: Christian König; Signed-off-by: Sunil
  Khatri, Alex Deucher
- **[Phase 2]** Diff: +10/−3 in `amdgpu_userq.c`;
  `create_object`/`destroy_object` modified
- **[Phase 2]** Confirmed doorbell already pinned at line 331 in local
  tree
- **[Phase 3]** `git describe` / `make kernelversion`: 6.18.43
- **[Phase 3]** `git merge-base --is-ancestor a3bbf32 7b923c78b50d2`:
  NOT in tree (exit 1)
- **[Phase 3]** `git show 7b923c78b50d2:...amdgpu_userq.c`:
  create_object lacks pin
- **[Phase 3]** `git apply --check` on upstream patch: clean apply
- **[Phase 3]** `git show v6.18:...amdgpu_userq.c | grep amdgpu_bo_pin`:
  only doorbell pin
- **[Phase 3]** `git show v6.17:...amdgpu_userq.c`: file exists (982
  lines)
- **[Phase 4]** `b4 dig -c a3bbf32`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1/v2 series; v2 2/2 is committed version
- **[Phase 4]** `b4 dig -w`: Alex Deucher, Christian König CC'd
- **[Phase 4]** spinics.net msg143086: König Reviewed-by; eviction-fence
  noted as future work
- **[Phase 5]** Grep callers: `mes_userqueue.c` uses create_object for
  `fw_obj` and `mqd`
- **[Phase 5]** IOCTL path: `DRM_IOCTL_AMDGPU_USERQ` in `amdgpu_drv.c`
- **[Phase 6]** Buggy code at HEAD lines 243–303: no pin in
  create_object
- **[Phase 6]** Eviction path: `amdgpu_eviction_fence.c` →
  `amdgpu_userq_evict()` exists but does not pin MQD/fw BOs
- **[Phase 8]** Failure mode: page faults + system hang per commit
  message

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 7e3175f82a20d..0f4281c9aea2f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -270,16 +270,20 @@ int amdgpu_userq_create_object(struct amdgpu_userq_mgr *uq_mgr,
 		goto free_obj;
 	}
 
+	r = amdgpu_bo_pin(userq_obj->obj, AMDGPU_GEM_DOMAIN_GTT);
+	if (r)
+		goto unresv;
+
 	r = amdgpu_ttm_alloc_gart(&(userq_obj->obj)->tbo);
 	if (r) {
 		drm_file_err(uq_mgr->file, "Failed to alloc GART for userqueue object (%d)", r);
-		goto unresv;
+		goto unpin_bo;
 	}
 
 	r = amdgpu_bo_kmap(userq_obj->obj, &userq_obj->cpu_ptr);
 	if (r) {
 		drm_file_err(uq_mgr->file, "Failed to map BO for userqueue (%d)", r);
-		goto unresv;
+		goto unpin_bo;
 	}
 
 	userq_obj->gpu_addr = amdgpu_bo_gpu_offset(userq_obj->obj);
@@ -287,11 +291,13 @@ int amdgpu_userq_create_object(struct amdgpu_userq_mgr *uq_mgr,
 	memset(userq_obj->cpu_ptr, 0, size);
 	return 0;
 
+unpin_bo:
+	amdgpu_bo_unpin(userq_obj->obj);
 unresv:
 	amdgpu_bo_unreserve(userq_obj->obj);
-
 free_obj:
 	amdgpu_bo_unref(&userq_obj->obj);
+
 	return r;
 }
 
@@ -299,6 +305,7 @@ void amdgpu_userq_destroy_object(struct amdgpu_userq_mgr *uq_mgr,
 				 struct amdgpu_userq_obj *userq_obj)
 {
 	amdgpu_bo_kunmap(userq_obj->obj);
+	amdgpu_bo_unpin(userq_obj->obj);
 	amdgpu_bo_unref(&userq_obj->obj);
 }
 
-- 
2.53.0

