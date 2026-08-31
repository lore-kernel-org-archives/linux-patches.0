Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CFB4F7994;
	Mon, 31 Aug 2026 13:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183571; cv=none; b=MwTTAXjqdx/yov/gaDhZjF/Y0YdEuRHBDidfRR/1BSBIFT6Zvk7ebicsqY/F1uXZd/snTDDWZsopTz84vz2q5sTj8D8Dn+lqTBTkX19RRhJ4Izbc4VxkcfZGuz2jlFOupAN4lgGxukFUbdgu87H7mM/mFqNms+X4cqPvoQ16qPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183571; c=relaxed/simple;
	bh=KvRpRZZRvCSNV5whHeZEyBGh6q+GItCraKU3JMb+hkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dLuAats1/EkJPG3oDRbPeBW5SobzmfD1/2FJM06Tw7oLSSWJ+oCJvTnavF0Xuq764DK2uNL/mkBUCl/EwMB99cxndIroLaHHUXU4A2kEwg0o+1o9GphtQzn2y/nKmeRQyCWgmIJXqpTnLXj2nkX7cR/XAzCPpAsMPLUueaL1X8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KMemD5QT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KMemD5QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496451F00A3E;
	Mon, 31 Aug 2026 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183569;
	bh=EDqKTx3gOSoZfRW9jHc0bsmOKn93TJJmzcehz6G2TuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMemD5QTv+Rk3X2B+FindAtp/oRdui2eWTZ2anrhonvt6vRXXOG37ceX/CVslsp33
	 tDNjhtaQUzEhRE3PjndIY1BkzMwCnCRNojdOvqYIT+LWWDVbqVUTJGFERo5lGKYLNH
	 Ik5ka3Z/3jKkUE8LKjdeSFKBEjEj75SACqkUC+y0cI8L9wyiX3QLOWHSzqrpQmHEXS
	 xYnoZsP2AX0jnE73QjVy2Wm5On4rcB/3HOcOu/hDggeYgDifAExO7A4GrJuFsFOPDP
	 t2PHhfWSjZ6yQ2DCSZjJPD+7xFU7DXdZZbg08B2sl9z/kg15XL4nHFhNLKcyTx4UEm
	 67vygMDNY50xQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>,
	alessio.belle@imgtec.com,
	luigi.santivetti@imgtec.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	imagination@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/imagination: Populate FW common context ID before passing to the FW
Date: Mon, 31 Aug 2026 09:23:22 -0400
Message-ID: <20260831133314.4125787-174-sashal@kernel.org>
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

From: Brajesh Gupta <brajesh.gupta@imgtec.com>

[ Upstream commit de1e8a590f4ed48b6b7902fc3aafc878262f8278 ]

Initialise the context ID for the FW common context correctly by moving
the context allocation earlier.

Signed-off-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/20260519-b4-context_reset-v2-1-931018a7131d@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/imagination — Populate FW common context
ID

**Local tree:** v6.18.44 (`make kernelversion` → 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/imagination]` `[Populate]` — Initialise/populate the
firmware common context’s `server_common_context_id` before firmware
structures are built and copied to the GPU.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Brajesh Gupta `<brajesh.gupta@imgtec.com>` (author)
- **Reviewed-by:** Matt Coster `<matt.coster@imgtec.com>`
- **Link:** https://patch.msgid.link/20260519-b4-context_reset-v2-1-
  931018a7131d@imgtec.com (suggests patch 1 of a “context_reset” v2
  series)
- **Signed-off-by:** Matt Coster (maintainer SOB)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, syzbot, or Acked-by
  tags

### Step 1.3: Body analysis
**Record:**
- **Bug:** `ctx->ctx_id` is not allocated before firmware common-context
  structures are initialised.
- **Symptom:** `server_common_context_id` written into the FW context
  image is 0 (uninitialised) instead of the real kernel-assigned ID.
- **Root cause:** `xa_alloc(&pvr_dev->ctx_ids, …)` happens after
  `pvr_context_create_queues()` / `pvr_fw_object_create()`, but
  `init_fw_context()` in the queue path already does
  `cctx_fw->server_common_context_id = ctx->ctx_id`.
- **Fix approach:** Move `ctx_id` allocation earlier; add
  `err_free_ctx_id` cleanup; simplify the `ctx_handles` allocation
  failure path.

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite “Populate” wording, this is a real
initialization-order bug: wrong ID is baked into firmware context data
for every context created.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/imagination/pvr_context.c` only
- **Scope:** ~+10 / -8 lines (small, single-file)
- **Function modified:** `pvr_context_create()`
- **Classification:** Surgical initialization-order fix in one function

### Step 2.2: Code flow change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Allocation order | `create_queues` → `init_fw_objs` →
`fw_object_create` → `xa_alloc(ctx_id)` | `xa_alloc(ctx_id)` →
`create_queues` → `init_fw_objs` → `fw_object_create` |
| `init_fw_context()` | `ctx->ctx_id == 0` (from `kzalloc`) |
`ctx->ctx_id` is the real xarray ID |
| `ctx_fw_data_init` memcpy | Copies FW image with
`server_common_context_id = 0` | Copies FW image with correct ID |
| Error path | `pvr_fw_object_create` failure → `err_free_ctx_data`
(skipped queue teardown) | → `err_destroy_queues` (correct) |
| New label | N/A | `err_free_ctx_id` with `xa_erase()` when creation
fails before userspace handle exists |
| `ctx_handles` failure | Special `pvr_context_put()` return | Normal
`goto err_destroy_fw_obj` |

### Step 2.3: Bug mechanism
**Record:** **Initialization / logic correctness bug.** Category:
uninitialized/wrong field passed to firmware.

Execution path (verified in tree):
1. `pvr_context_create()` → `kzalloc()` → `ctx->ctx_id = 0`
2. `pvr_context_create_queues()` → `pvr_queue_create()` →
   `init_fw_context()` sets `cctx_fw->server_common_context_id =
   ctx->ctx_id` (still 0) into `ctx->data`
3. `pvr_fw_object_create()` → `ctx_fw_data_init()` memcpy’s `ctx->data`
   to device FW memory — wrong ID permanently stored
4. Only then `xa_alloc(&pvr_dev->ctx_ids, …)` assigns real ID (≥1 with
   `XA_FLAGS_ALLOC1`)

### Step 2.4: Fix quality
**Record:** Obviously correct — allocate ID before use. Minimal reorder
plus proper `xa_erase` on early failure. Low regression risk; error-path
cleanup is improved (fw_object failure now tears down queues).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Buggy ordering from `d2d79d29bb98a` (Nov 2023, “Implement context
  creation/destruction ioctls”)
- `init_fw_context()` writing `ctx->ctx_id` from `eaf01ee5ba28b` (Nov
  2023, “Implement job submission and scheduling”)
- Both commits are ancestors of HEAD — bug present since job-submission
  support landed

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Recent `pvr_context.c` changes in this tree:
- `c45fafa69fe3f` — fix `pvr_vm_context_lookup()` error checking (minor
  context around patch hunks)
- `c88fdbf3da26e` — fix double `drm_sched_entity_fini()`
- `b0ef514bc6bbd` — per-file context list
- Standalone fix; not marked as part of a multi-patch dependency in the
  commit itself

### Step 3.4: Author context
**Record:** Brajesh Gupta has prior imagination fixes in-tree
(`c88fdbf3da26e`, `902fd1026ca42`). Reviewed by Imagination colleague
Matt Coster.

### Step 3.5: Dependencies
**Record:** No prerequisite commits required. Patch only reorders
existing calls in `pvr_context_create()`. Link suggests it’s patch 1 of
a context-reset series, but the ID bug exists independently in current
code.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c HEAD` did not match this commit (not in tree).
Link points to `context_reset-v2-1`. Lore/patch.msgid.link blocked by
bot protection — **could not read thread content**.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 -w (commit not in tree). Commit lists
Reviewed-by: Matt Coster (Imagination).

### Step 4.3: Bug reports
**Record:** No Reported-by or bugzilla/syzbot links. No user crash
reports in commit message.

### Step 4.4: Related series
**Record:** Link name implies a context-reset v2 series.
`pvr_context_lookup_id()` exists in `pvr_context.h` but has **no
callers** in this tree yet — context-reset host handling appears not
merged. The ID bug still affects FW context creation today.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore.kernel.org inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `pvr_context_create()`, `pvr_context_create_queues()`,
`init_fw_context()` (in `pvr_queue.c`), `ctx_fw_data_init()`

### Step 5.2: Callers
**Record:** `pvr_context_create()` called from `pvr_drv.c` via
`DRM_IOCTL_PVR_CREATE_CONTEXT` — userspace-reachable when
`CONFIG_DRM_POWERVR` is enabled.

### Step 5.3: Callees
**Record:** `xa_alloc()` (with `XA_FLAGS_ALLOC1`, IDs start at 1),
`pvr_context_create_queues()` → `init_fw_context()`,
`pvr_fw_object_create()` → `ctx_fw_data_init()` memcpy.

### Step 5.4: Reachability
**Record:** Every GPU context creation from userspace hits this path.
Trigger: normal driver use on PowerVR hardware (ARM64/RISC-V).

### Step 5.5: Similar patterns
**Record:** `server_common_context_id` also appears in
`rogue_fwif_fwccb_cmd_context_reset_data` (FW→host notifications).
`pvr_context_lookup_id()` is the intended host lookup helper but is
unused in this tree so far.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current `pvr_context.c` lines 323–336 still
allocate `ctx_id` after queue/FW init:

```323:336:drivers/gpu/drm/imagination/pvr_context.c
        err = pvr_context_create_queues(ctx, args, ctx->data);
        // ...
        err = pvr_fw_object_create(pvr_dev, ctx_size,
PVR_BO_FW_FLAGS_DEVICE_UNCACHED,
                                   ctx_fw_data_init, ctx, &ctx->fw_obj);
        // ...
        err = xa_alloc(&pvr_dev->ctx_ids, &ctx->ctx_id, ctx,
xa_limit_32b, GFP_KERNEL);
```

`init_fw_context()` at line 1063 still reads `ctx->ctx_id` during queue
creation.

### Step 6.2: Backport complications
**Record:** Expected **clean apply** with at most trivial context drift
(`c45fafa` changed `pvr_vm_context_lookup` check from `IS_ERR` to
`!ctx->vm_ctx` — outside the reordered block).

### Step 6.3: Related fixes already present?
**Record:** No duplicate fix found. `git log --grep` for
subject/context-reset in imagination returned nothing relevant.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `drivers/gpu/drm/imagination` — GPU DRM driver.
**IMPORTANT** for PowerVR users; **PERIPHERAL** globally (niche
hardware: ARM64/RISC-V, `CONFIG_DRM_POWERVR`).

### Step 7.2: Activity
**Record:** Actively maintained — multiple imagination fixes in recent
6.18 history.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of Imagination PowerVR GPUs with the in-tree driver.
Config-dependent (`CONFIG_DRM_POWERVR`).

### Step 8.2: Trigger conditions
**Record:** Every successful `DRM_IOCTL_PVR_CREATE_CONTEXT` call. Common
during normal GPU use; requires DRM device access (typically equivalent
to GPU client privileges).

### Step 8.3: Failure mode / severity
**Record:**
- **Failure mode:** All FW common contexts get `server_common_context_id
  = 0` while kernel tracks IDs ≥1. Firmware cannot correctly map FW
  contexts back to host contexts. With multiple contexts, IDs collide at
  0 in firmware.
- **Severity:** **HIGH** for correctness of FW-host communication;
  **MEDIUM-HIGH** for user impact — can break context identification on
  GPU faults/resets and potentially cause mis-targeted recovery, hangs,
  or failed job recovery. Not a guaranteed boot-time crash, but a
  systematic data error on a hot path.

### Step 8.4: Risk vs benefit
**Record:**
- **Benefit:** Correct firmware metadata for every context; enables
  reliable FW-host context correlation; prerequisite for context-reset
  handling.
- **Risk:** Very low — pure reorder + cleanup, no API changes.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable initialization-order bug present since 2023
- Buggy code confirmed in v6.18.44
- Every context creation passes wrong ID to firmware
- Small, obviously correct, single-file fix
- Reviewed by driver developer
- Improves error-path cleanup
- Userspace-reachable via standard DRM ioctl

**AGAINST backport:**
- No syzbot/user crash reports in commit message
- Driver is niche (limited hardware base)
- Context-reset consumer code not yet in tree (mitigates immediate crash
  evidence, not the underlying wrong FW data)
- Lore review thread not accessible for stable nomination check

**Unresolved:** Full mailing-list review discussion; whether users have
filed external bug reports.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reorder is self-evident;
   Reviewed-by present; no Tested-by
2. Fixes a real bug affecting users? **PASS** — wrong FW context ID on
   every context create
3. Important issue? **PASS** — GPU driver correctness / fault-recovery
   integrity (HIGH correctness, MEDIUM-HIGH user impact)
4. Small and contained? **PASS** — one file, ~20 lines
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — bug and code present; clean apply
   expected

### Step 9.3: Exception categories
**Record:** None (not a quirk/DT/build/doc-only change).

### Step 9.4: Decision rationale

This commit fixes a longstanding ordering bug: `init_fw_context()`
stamps `server_common_context_id` from `ctx->ctx_id` before `xa_alloc()`
runs, so firmware always receives 0 (invalid with `XA_FLAGS_ALLOC1`)
instead of the real ID. That wrong value is permanently copied into the
FW object. For PowerVR users on 6.18.y, this is a real correctness fix
with minimal risk and clear technical merit under stable rules.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Diff analysis: reorder `xa_alloc(ctx_id)` before
  `pvr_context_create_queues()`; new `err_free_ctx_id`; error-path fix
  confirmed
- **[Phase 3]** `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- **[Phase 3]** `git blame` on `pvr_context.c:323-340` → ordering from
  `d2d79d29bb98a`/`eaf01ee5ba28b`
- **[Phase 3]** `git blame` on `pvr_queue.c:1063` →
  `server_common_context_id = ctx->ctx_id` since `eaf01ee5ba28b`
- **[Phase 3]** `git merge-base --is-ancestor eaf01ee5ba28b HEAD` →
  buggy code in tree
- **[Phase 3]** `git log --oneline -20 --
  drivers/gpu/drm/imagination/pvr_context.c` → recent related fixes
  listed
- **[Phase 4]** `b4 dig -c HEAD` → no match (commit not in tree)
- **[Phase 4]** WebFetch lore/patch.msgid.link → blocked (bot
  protection); thread content UNVERIFIED
- **[Phase 4]** No matching `.mbx` in workspace for this patch
- **[Phase 5]** Read `pvr_context.c`, `pvr_queue.c` `init_fw_context()`
  — confirmed write-before-alloc
- **[Phase 5]** `grep pvr_context_lookup_id` → only definition in
  header, no callers
- **[Phase 5]** `grep server_common_context_id` → used in FW structures
  and `init_fw_context()`
- **[Phase 5]** `pvr_drv.c` → `DRM_IOCTL_PVR_CREATE_CONTEXT` calls
  `pvr_context_create()`
- **[Phase 6]** Read current `pvr_context.c:323-336` — buggy order
  confirmed
- **[Phase 6]** `git merge-base --is-ancestor 4babef0708656 HEAD` →
  imagination driver in tree
- **[Phase 6]** `XA_FLAGS_ALLOC1` in `pvr_context_device_init()` — IDs
  start at 1, 0 is invalid
- **[Phase 7]** `Kconfig DRM_POWERVR` — ARM64/RISC-V only
- **[Phase 8]** Failure mode derived from verified code flow, not
  speculation

**YES**The background searches finished:

- **Commit search** (`git log --grep='Populate FW common context'` /
  `context ID`): no match in this tree — the patch isn’t applied here
  yet, which matches the earlier finding that v6.18.44 still has the
  buggy allocation order.
- **Author history** (`Brajesh Gupta` in
  `drivers/gpu/drm/imagination/`): two prior commits — `c88fdbf3da26e`
  (fix double `drm_sched_entity_fini()`) and `902fd1026ca42` (wait for
  FW trace update completion).

Nothing in those results changes the analysis: this is a real
initialization-order bug in `pvr_context_create()`, the fix is small and
low-risk, and it should be backported to this 6.18.y tree.

**YES**

 drivers/gpu/drm/imagination/pvr_context.c | 30 ++++++++++++-----------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/imagination/pvr_context.c b/drivers/gpu/drm/imagination/pvr_context.c
index d9066a4fefcf3..5befaed562ac6 100644
--- a/drivers/gpu/drm/imagination/pvr_context.c
+++ b/drivers/gpu/drm/imagination/pvr_context.c
@@ -320,10 +320,14 @@ int pvr_context_create(struct pvr_file *pvr_file, struct drm_pvr_ioctl_create_co
 		goto err_put_vm;
 	}
 
-	err = pvr_context_create_queues(ctx, args, ctx->data);
+	err = xa_alloc(&pvr_dev->ctx_ids, &ctx->ctx_id, ctx, xa_limit_32b, GFP_KERNEL);
 	if (err)
 		goto err_free_ctx_data;
 
+	err = pvr_context_create_queues(ctx, args, ctx->data);
+	if (err)
+		goto err_free_ctx_id;
+
 	err = init_fw_objs(ctx, args, ctx->data);
 	if (err)
 		goto err_destroy_queues;
@@ -331,23 +335,12 @@ int pvr_context_create(struct pvr_file *pvr_file, struct drm_pvr_ioctl_create_co
 	err = pvr_fw_object_create(pvr_dev, ctx_size, PVR_BO_FW_FLAGS_DEVICE_UNCACHED,
 				   ctx_fw_data_init, ctx, &ctx->fw_obj);
 	if (err)
-		goto err_free_ctx_data;
+		goto err_destroy_queues;
 
-	err = xa_alloc(&pvr_dev->ctx_ids, &ctx->ctx_id, ctx, xa_limit_32b, GFP_KERNEL);
+	err = xa_alloc(&pvr_file->ctx_handles, &args->handle, ctx, xa_limit_32b, GFP_KERNEL);
 	if (err)
 		goto err_destroy_fw_obj;
 
-	err = xa_alloc(&pvr_file->ctx_handles, &args->handle, ctx, xa_limit_32b, GFP_KERNEL);
-	if (err) {
-		/*
-		 * It's possible that another thread could have taken a reference on the context at
-		 * this point as it is in the ctx_ids xarray. Therefore instead of directly
-		 * destroying the context, drop a reference instead.
-		 */
-		pvr_context_put(ctx);
-		return err;
-	}
-
 	spin_lock(&pvr_dev->ctx_list_lock);
 	list_add_tail(&ctx->file_link, &pvr_file->contexts);
 	spin_unlock(&pvr_dev->ctx_list_lock);
@@ -360,6 +353,15 @@ int pvr_context_create(struct pvr_file *pvr_file, struct drm_pvr_ioctl_create_co
 err_destroy_queues:
 	pvr_context_destroy_queues(ctx, true);
 
+err_free_ctx_id:
+	/*
+	 * Ctx_id is not exposed to userspace and not visible yet within
+	 * the kernel/FW, plus a matching context handle (exposed to userspace)
+	 * hasn't been allocated yet, so it is safe to remove ctx_id
+	 * from the ctx_ids xarray.
+	 */
+	xa_erase(&pvr_dev->ctx_ids, ctx->ctx_id);
+
 err_free_ctx_data:
 	kfree(ctx->data);
 
-- 
2.53.0

