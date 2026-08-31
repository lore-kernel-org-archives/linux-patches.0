Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2B656E07D;
	Mon, 31 Aug 2026 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184114; cv=none; b=rxWgZmKBrtLd8otEixBRH3MZZUeP1ApWHQx1Xai0lrG9lj953e1iijnjkFlziSyDX0tsvtaSoeCHNagrzQVvUQULT/8ZqED36cEBoYYAK7br+5xqhrh9L72wM/WGeE4r+XIRo4jHKjtzKTVaig7+fREk48YDS5BkVNUdZ2P9J3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184114; c=relaxed/simple;
	bh=JeIWjeuuWo6VaEzTSPuo2urvBxzEIcwn0ji/bX9o5/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O6Ke9iCXahxg2Uuw7uVA1IXzL2loUxqCkqrIKmWY41k7TRo72GJkhU1UaVaxvWnH1sQCGeeLfJA3DT+TQgl2LXEReDP34lCEiAL4uoC1TO4v1rL2cocjbQ4K1yqZqHiYYTSeQJvgkuMzu2YZeZ80PrVvehVs9PtsMYsTJrKRP88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E6UnkWmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E6UnkWmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51AD1F00ACA;
	Mon, 31 Aug 2026 13:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184112;
	bh=fwK88PsV0/tcr1iY8Ix2BUCLb4fJksddhf7T8CmozkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6UnkWmvVRMh6G0a20rAICgZslT9pUVoH9xsKCOrpXkvp7GgVlA1T0fYgvDH42BGf
	 NYla9Jmu8aSs7k/t4ZbkXhPyQficGnnzfbAFKMUIo+FnBnSx0KqA04AkvPwRl33lK1
	 VsnzxEe3Sdu2w9jqh0349+YFmLmnn/FimLPRUzi2Y6SC4tWzDJBz+V8f0JEzHDPHdy
	 e+PR/cx67K1IRYPvGgp4ZMdmEJag/pssh3yBNx99EFb4mZuXktNOGmrnRBO9nTkXM7
	 eTaAlR645TRGbvMXHW6nRAYomsKdCcBD35M/nIaZChajRF4ltPQFXg08oPc7/YQDI1
	 ZqIAuEfUxuWCw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amdkfd: check find_first_zero_bit before __set_bit on kfd->doorbell_bitmap
Date: Mon, 31 Aug 2026 09:28:46 -0400
Message-ID: <20260831133314.4125787-498-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 516bf737a5602875f6c28d1028967837c8edf2c0 ]

If inx from find_first_zero_bit is beyond range not need set doorbell_bitmap.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2664ce9143d174651a793d96a6a2326050c4f45a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amdkfd: check find_first_zero_bit
before __set_bit on kfd->doorbell_bitmap`

**Local tree:** `v6.18.44` (Linux 6.18.44)
**Fix commit:** `2664ce9143d174651a793d96a6a2326050c4f45a` — **not** in
this tree; buggy code is still present.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/amdkfd]` `[check]` — validate `find_first_zero_bit`
result before calling `__set_bit` on `kfd->doorbell_bitmap`.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Xiaogang Chen `<xiaogang.chen@amd.com>` (author)
- **Reviewed-by:** Alex Deucher `<alexander.deucher@amd.com>` (AMD DRM
  maintainer)
- **Signed-off-by:** Alex Deucher `<alexander.deucher@amd.com>`
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable`, `Tested-by:`, or
  `Acked-by:` tags
- `(cherry picked from commit 2664ce9143d1...)` — pipeline marker;
  ignored per instructions

### Step 1.3: Body analysis
**Record:**
- **Bug:** When `find_first_zero_bit` finds no free bit, it returns `nb`
  (the search size). The old code called `__set_bit(inx, ...)` before
  checking whether `inx` is in range.
- **Symptom:** Out-of-bounds bitmap write when the bitmap is exhausted;
  on large-page systems, also leaks bitmap slots on the error path (set
  bit, then return NULL).
- **Root cause:** Range check was placed after `__set_bit` instead of
  before it.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite the terse message, this is a memory-safety /
resource-management fix, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c` (+5 / -3 lines)
- **Function:** `kfd_get_kernel_doorbell()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** lock → `find_first_zero_bit` → `__set_bit` → unlock → if
  `inx >= 1024` return NULL
- **After:** lock → `find_first_zero_bit` → if `inx >= 1024` unlock and
  return NULL → `__set_bit` → unlock
- **Affected path:** Error path when no kernel doorbell slot is
  available

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Out-of-bounds access / bitmap resource leak
- **Mechanism:** `doorbell_bitmap` is allocated with
  `bitmap_zalloc(PAGE_SIZE / sizeof(u32))` (1024 bits on 4 KiB pages).
  `find_first_zero_bit(..., PAGE_SIZE / sizeof(u32))` returns `1024`
  when full. `__set_bit(1024, ...)` writes past the end of a 1024-bit
  bitmap. On larger pages, indices 1024..(PAGE_SIZE/4-1) could be set
  and then discarded via `return NULL`, leaking slots.

### Step 2.4: Fix quality
**Record:**
- Obviously correct; mirrors the process-doorbell pattern in
  `kfd_device_queue_manager.c` (check before `set_bit`)
- Minimal change, no API changes
- **Regression risk:** Very low — only affects the exhaustion error path

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Function dates to 2014 (`19f6d2a660340d`, Oded Gabbay)
- `find_first_zero_bit` with `PAGE_SIZE / sizeof(u32)` added in
  `c31866651086fc` (Jul 2023, Shashank Sharma)
- The check-after-set pattern predates 2023; the 2023 change did not
  introduce the ordering bug, but kept it

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related file history
**Record:**
- Recent `kfd_doorbell.c` changes are doorbell-manager refactors (2023)
- No related fix for this issue already in the tree
- Part of a 3-patch series per b4; patch 1 is unrelated
  (`AMDKFD_IOC_GET_DMABUF_INFO`)

### Step 3.4: Author context
**Record:** Xiaogang Chen is an AMD contributor; Alex Deucher
(maintainer) reviewed and committed.

### Step 3.5: Dependencies
**Record:** Standalone — no prerequisite commits required. Applies
cleanly to current `kfd_doorbell.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260528184656.123149-2-xiaogang.chen@amd.com
- **Series:** `[PATCH 2/3]` — patch 1 is unrelated ioctl work
- Lore fetch blocked by bot protection; thread content not directly
  readable

### Step 4.2: Reviewers
**Record:** CC'd to `amd-gfx@lists.freedesktop.org`; Reviewed-by Alex
Deucher (maintainer).

### Step 4.3: Bug reports
**Record:** No external bug report, syzbot report, or crash trace
referenced.

### Step 4.4: Related patches
**Record:** Patch 2/3 is independent of patches 1 and 3 for this fix's
correctness.

### Step 4.5: Stable list history
**Record:** Not searched separately; no stable nomination found in
commit metadata.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `kfd_get_kernel_doorbell()`, `kfd_release_kernel_doorbell()`

### Step 5.2: Callers
**Record:**
- `kfd_kernel_queue.c:76` — `kernel_queue_init()` for HIQ/DIQ queues
- Typically 1–2 kernel queues per KFD device (HIQ + optional DIQ)
- Error path at line 78–80 handles NULL return

### Step 5.3: Callees
**Record:** `mutex_lock/unlock`, `find_first_zero_bit`, `__set_bit`,
`amdgpu_doorbell_index_on_bar`

### Step 5.4: Reachability
**Record:**
- Triggered during KFD device init / debug-queue setup (`CONFIG_HSA_AMD`
  / AMDGPU KFD)
- Not directly userspace-syscall reachable, but reachable during GPU
  compute driver init
- Exhaustion requires ~1024 allocations without release — unrealistic in
  normal use (~2 kernel queues), but possible with a doorbell leak

### Step 5.5: Similar patterns
**Record:** Process doorbells in `kfd_device_queue_manager.c:484–490`
already check `found >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS` **before**
`set_bit`. This fix aligns kernel doorbells with that correct pattern.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at lines 155–162 still has check-
after-set:

```155:162:drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
        mutex_lock(&kfd->doorbell_mutex);
        inx = find_first_zero_bit(kfd->doorbell_bitmap, PAGE_SIZE /
sizeof(u32));

        __set_bit(inx, kfd->doorbell_bitmap);
        mutex_unlock(&kfd->doorbell_mutex);

        if (inx >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
                return NULL;
```

Bitmap allocation at line 75: `bitmap_zalloc(PAGE_SIZE / sizeof(u32))` —
1024 bits on 4 KiB pages. `KFD_MAX_NUM_OF_QUEUES_PER_PROCESS` = 1024
(`kfd_priv.h:97`).

### Step 6.2: Backport difficulty
**Record:** Clean apply expected — 8-line hunk, no conflicts observed.

### Step 6.3: Related fixes already present?
**Record:** None. `git merge-base --is-ancestor 2664ce9143d1 HEAD` →
NOT_IN_TREE.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/amd/amdkfd` — **PERIPHERAL** (AMD GPU
compute / ROCm users with `CONFIG_HSA_AMD`)

### Step 7.2: Activity
**Record:** Actively maintained; recent doorbell-manager refactoring in
2023.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** AMD GPU users with KFD/ROCm enabled — not universal, but
real production users.

### Step 8.2: Trigger conditions
**Record:**
- All doorbell bitmap slots consumed (1024 on 4 KiB pages)
- Normal operation uses ~2 kernel doorbells per device
- **Likelihood:** Very low without a resource leak; **possible** with a
  leak bug

### Step 8.3: Failure mode severity
**Record:**
- **OOB `__set_bit`:** Memory corruption adjacent to bitmap → potential
  crash or unpredictable behavior — **HIGH** if triggered
- **Bitmap leak (large pages):** Gradual exhaustion — **MEDIUM**
- **Practical impact today:** Low due to unlikely trigger

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents OOB write and bitmap leaks on error path; aligns
  with existing correct pattern
- **Risk:** Minimal — 5-line reorder/addition on error path only
- **Ratio:** Favorable — near-zero risk, real correctness fix

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real out-of-bounds bitmap write when exhausted
- Obviously correct; maintainer-reviewed
- Small, self-contained, clean apply
- Matches established pattern in same subsystem
- Buggy code confirmed present in v6.18.44
- Memory-safety class of fix

**AGAINST backport:**
- No user reports or fuzzer findings
- Trigger extremely unlikely in normal kernel-queue usage (~2 doorbells)
- Bug present since 2014 without known incidents
- Config/driver-specific (AMD KFD only)

**Unresolved:** None affecting the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic verified; maintainer
   reviewed (no runtime test cited)
2. Fixes a real bug? **PASS** — OOB `__set_bit` on exhaustion
3. Important issue? **PASS** — memory corruption (severity high if
   triggered; trigger rare)
4. Small and contained? **PASS** — 8 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code exists; fix not yet applied

### Step 9.3: Exception categories
**Record:** None (not a quirk, device ID, DT, build, or docs fix).

### Step 9.4: Decision rationale

This is a small, maintainer-reviewed memory-safety fix for a genuine
ordering bug: `__set_bit` was called before validating the index
returned by `find_first_zero_bit`. When the bitmap is full, that is an
out-of-bounds write. The trigger is rare for kernel doorbells (only
HIQ/DIQ, typically ~2 per device), but the fix is trivial, matches the
correct pattern already used for process doorbells in the same driver,
and has essentially no regression risk. For the 6.18.y stable tree where
the buggy code is present and the fix is absent, this meets stable
kernel criteria.

---

## Verification

- **[Phase 1]** `git show 2664ce9143d1` — parsed message and tags
- **[Phase 2]** Read `kfd_doorbell.c:149–176` — confirmed check-after-
  set bug; analyzed diff
- **[Phase 2]** `kfd_priv.h:97` — `KFD_MAX_NUM_OF_QUEUES_PER_PROCESS` =
  1024
- **[Phase 2]** `kfd_doorbell.c:75` — bitmap sized `PAGE_SIZE /
  sizeof(u32)` bits
- **[Phase 3]** `git blame -L 150,176 kfd_doorbell.c` — function history
  since 2014
- **[Phase 3]** `git show c31866651086fc` — 2023 doorbell-mgr refactor
- **[Phase 3]** `git show 19f6d2a660340d` — original code had same
  ordering bug
- **[Phase 3]** `git log --oneline -15 -- kfd_doorbell.c` — no duplicate
  fix
- **[Phase 4]** `b4 dig -c 2664ce9143d1` — lore URL found; patch 2/3 of
  series
- **[Phase 4]** `b4 dig -w` — amd-gfx list CC'd
- **[Phase 4]** `b4 dig -a` — v1 series identified
- **[Phase 5]** `grep kfd_get_kernel_doorbell` — caller in
  `kfd_kernel_queue.c:76`
- **[Phase 5]** Read `kfd_kernel_queue.c:76–80, 191, 224` — NULL
  handled; release on cleanup
- **[Phase 5]** Read `kfd_device_queue_manager.c:484–490` — correct
  check-before-set pattern
- **[Phase 6]** `git describe HEAD` — v6.18.44
- **[Phase 6]** `git merge-base --is-ancestor 2664ce9143d1 HEAD` —
  NOT_IN_TREE
- **[Phase 6]** Read current `kfd_doorbell.c` — buggy code confirmed
  present

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index 05c74887fd6fd..fdcf7f2d1b5b4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -153,14 +153,16 @@ void __iomem *kfd_get_kernel_doorbell(struct kfd_dev *kfd,
 	u32 inx;
 
 	mutex_lock(&kfd->doorbell_mutex);
+
 	inx = find_first_zero_bit(kfd->doorbell_bitmap, PAGE_SIZE / sizeof(u32));
+	if (inx >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS) {
+		mutex_unlock(&kfd->doorbell_mutex);
+		return NULL;
+	}
 
 	__set_bit(inx, kfd->doorbell_bitmap);
 	mutex_unlock(&kfd->doorbell_mutex);
 
-	if (inx >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
-		return NULL;
-
 	*doorbell_off = amdgpu_doorbell_index_on_bar(kfd->adev,
 						     kfd->doorbells,
 						     inx,
-- 
2.53.0

