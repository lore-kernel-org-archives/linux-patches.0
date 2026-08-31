Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9404C0438;
	Mon, 31 Aug 2026 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183540; cv=none; b=cUDJJjjzZgy+tNUPMIZKyqD11HPH41tkmSW1ZVmc8sabhHNI1/SzFzM0vpExmFxnLpPBl9xUVjVIJxLBaFJhgpWQk7SzJDnESJUB2p+2kCSpgCs2HTSDGa2EWEdKpLefhgiYpeiL+Xf6q0fX+b0jvVmOac8l7mXhl6Kt6dS9cxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183540; c=relaxed/simple;
	bh=Wsyly7NQ8kAcysOqYRMovGKV400HnOPhO0glfNwWZsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnJiFx1KDXmwHiHE9M0yIUqNieqJ2msGpb7Zh8jb/OSaLexYaVJZGiPXgJ2cRV0+PeyhCwZJ9gTxawnUud7kWZ2eS7Pv40EUUxTgSagERQPLnnfnJiDepegiZkFtGQxkAcex/bECw/Nvvk9apqiYgnaF7LZ9npLY6GYPnQjIHAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKNPFxep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKNPFxep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A941F00A3D;
	Mon, 31 Aug 2026 13:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183538;
	bh=PDMLqywieCUw6u3aoPM0QywGW7QT6PzT+zU/IWS8v+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKNPFxepKA4kXzzBJN8Q8+9qmkJh4k99rdiT9S0C91O3zmQAPsRzJ1YCkCiRFh+mk
	 f2wGJzmWTv0KeaspeM6w3//fH24glezllWFddwRLjiZ534VaATqgmNyfHBgyYq6RbH
	 b4rjU0Ai1sHb2vaTL1gvv5hVystUdvouH5/4jZ7cDGceuSt/niJwOC2i8N8nqRgvt2
	 7zro+HSKuSo86GNBIZO7XPtqQsknxH2DmAsc2GjqbNP7yjP8eaE6nwJSr+JY9B6nfN
	 oD2Atj5b8JTXi+tgzmN2Bm00UQ3ZSYCG4jAkkDgqdHThQlF6mZ7u+i3d2hduBBTSOd
	 wBA2r9dKrRLOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brandon Brnich <b-brnich@ti.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nas.chung@chipsnmedia.com,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] media: chips-media: wave5: Release m2m_ctx after Instance Removed from List
Date: Mon, 31 Aug 2026 09:23:04 -0400
Message-ID: <20260831133314.4125787-156-sashal@kernel.org>
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

From: Brandon Brnich <b-brnich@ti.com>

[ Upstream commit 7cdbd7bb21949a8fda10c7104a2b12ee363cbf5c ]

Possible use after free if IRQ thread manages to obtain spinlock between
m2m_ctx release and wave5_release function removing stream instance from
list of active instances. The IRQ thread looks for the m2m_ctx which is
freed so null pointer dereference occurs.

Signed-off-by: Brandon Brnich <b-brnich@ti.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Tested-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[media: chips-media: wave5]` `[Release]` — reorder
`m2m_ctx` release so it happens after the instance is removed from the
active-instances list.

### Step 1.2: Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** Jackson Lee `<jackson.lee@chipsnmedia.com>`
- **Reviewed-by:** Nicolas Dufresne `<nicolas.dufresne@collabora.com>`
- **Signed-off-by:** Brandon Brnich, Nicolas Dufresne, Hans Verkuil
- **Cc: stable:** — not present (not a negative signal)
- **Link:** — none

Notable: subsystem maintainer review (Dufresne), media maintainer merge
(Verkuil), hardware-vendor testing (Jackson Lee at Chips&Media).

### Step 1.3: Body analysis
**Record:**
- **Bug:** Use-after-free / NULL dereference race during device release.
- **Symptom:** IRQ thread can still find the instance in
  `dev->instances` and call `finish_process()`, which dereferences
  `inst->v4l2_fh.m2m_ctx`, after `v4l2_m2m_ctx_release()` has already
  `kfree()`'d that object.
- **Root cause:** `v4l2_m2m_ctx_release()` was called before
  `list_del_init(&inst->list)`, leaving a window where the instance
  remains visible to the IRQ thread but its `m2m_ctx` is already freed.
- **Version info:** none in message.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit concurrency/lifetime-ordering bug
fix, not disguised cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/media/platform/chips-media/wave5/wave5-helper.c`
  (+3 / −1)
- **Function:** `wave5_vpu_release_device()`
- **Scope:** single-file, surgical reorder

### Step 2.2: Code flow change
**Record:**
- **Before:** `v4l2_m2m_ctx_release()` → take `irq_lock` →
  `list_del_init()` → unlock → `close_func()` →
  `wave5_cleanup_instance()`
- **After:** take `irq_lock` → `list_del_init()` → unlock →
  `v4l2_m2m_ctx_release()` → `close_func()` → `wave5_cleanup_instance()`
- **Path affected:** `release()` on decoder/encoder file descriptors
  (normal teardown, not init)

### Step 2.3: Bug mechanism
**Record:** **Category:** race condition / use-after-free (reference-
counting/lifetime ordering).

Mechanism verified in code:
1. `v4l2_m2m_ctx_release()` calls `kfree(m2m_ctx)`
   (`v4l2-mem2mem.c:1275`) but does not clear `inst->v4l2_fh.m2m_ctx`.
2. IRQ thread (`wave5-vpu.c:126-136`, `173-183`) holds `dev->irq_lock`,
   walks `dev->instances`, and calls `inst->ops->finish_process(inst)`.
3. `wave5_vpu_dec_finish_decode()` / encoder equivalent immediately does
   `m2m_ctx = inst->v4l2_fh.m2m_ctx` and uses it (`wave5-vpu-
   dec.c:344`).
4. With the old order, between `v4l2_m2m_ctx_release()` and
   `list_del_init()`, the instance is still on the list while `m2m_ctx`
   is freed → UAF.

### Step 2.4: Fix quality
**Record:** Obviously correct — IRQ paths only iterate listed instances;
releasing `m2m_ctx` only after `list_del_init()` under the same
`irq_lock` closes the race. Minimal change. Low regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `wave5_vpu_release_device()` originates from
`19eef1d98eeda`. Locking + early `list_del_init()` added by
`ea316b784fe6a` (Nov 2025 upstream, Mar 2026 in this tree). Buggy
`v4l2_m2m_ctx_release()` placement introduced with `ea316b784fe6a`.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug introduced as incomplete fix in
`ea316b784fe6a`, which is present in this tree.

### Step 3.3: Related commits
**Record:**
- `ea316b784fe6a` — prerequisite IRQ locking refactor (present in tree)
- `789e6d8e630c4` / upstream `7cdbd7bb2194` — this fix (not in HEAD)
- Part of a 2-patch series; patch 2/2 is an independent lockdep fix in
  `wave5-vpu-dec.c`, not required for this reorder to work

### Step 3.4: Author context
**Record:** Brandon Brnich (TI). Related wave5 work from same ecosystem
(Jackson Lee, Chips&Media). Hans Verkuil is V4L/media maintainer.

### Step 3.5: Dependencies
**Record:** Requires `ea316b784fe6a` infrastructure (`irq_lock`,
`irq_spinlock`, `list_del_init()` in release path). That commit **is**
an ancestor of HEAD. Patch applies cleanly (`git apply --check` passed).
Standalone for its purpose.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260402184554.1751445-1-b-brnich@ti.com
- **Series:** v1 only for patch 1/2
- **Reviewer feedback:** Nicolas Dufresne `Reviewed-by` on list
- **Stable nomination:** none found in thread
- **NAKs:** none found

### Step 4.2: Reviewers
**Record:** CC'd: `mchehab@kernel.org`,
`nicolas.dufresne@collabora.com`, `jackson.lee@chipsnmedia.com`, `linux-
media@vger.kernel.org`

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug class inferred
from code + prior fluster-test crashes fixed by `ea316b784fe6a`.

### Step 4.4: Related patches
**Record:** Patch 2/2 fixes lockdep issues in
`handle_dynamic_resolution_change` / `initialize_sequence` — separate
concern.

### Step 4.5: Stable list
**Record:** Not searched on lore stable (Anubis blocked direct fetch).
No stable-thread evidence found in mbox.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `wave5_vpu_release_device()`, `wave5_vpu_irq_thread()`,
`irq_thread()`, `wave5_vpu_dec_finish_decode()`,
`wave5_vpu_enc_finish_encode()`

### Step 5.2: Callers
**Record:**
- `wave5_vpu_release_device()` ← `wave5_vpu_dec_release()` /
  `wave5_vpu_enc_release()` (V4L2 `release` file ops)
- IRQ thread ← hardware IRQ or polling thread on `CONFIG_VIDEO_WAVE_VPU`
  devices

### Step 5.3: Callees
**Record:** `v4l2_m2m_ctx_release()` → `v4l2_m2m_cancel_job()`,
`vb2_queue_release()`, `kfree(m2m_ctx)`

### Step 5.4: Reachability
**Record:** Userspace opens `/dev/video*`, streams decode/encode, closes
fd → `release()` path. Concurrent VPU interrupts are normal during
streaming. **Reachable from userspace** on K3 platforms with wave5
hardware.

### Step 5.5: Similar patterns
**Record:** `ea316b784fe6a` fixed a related NULL-deref race in the same
driver by adding IRQ locking; this commit completes that work by fixing
teardown ordering.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code in tree?
**Record:** **YES.** Local tree is **Linux 6.18.43** (`git describe`:
`v6.18.43-1-gc7f0dac02d232`). Current `wave5-helper.c:71` still calls
`v4l2_m2m_ctx_release()` before `list_del_init()`. Fix commit
`789e6d8e630c4` is **not** an ancestor of HEAD.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` on upstream diff
succeeded with no conflicts.

### Step 6.3: Related fixes already present?
**Record:** `ea316b784fe6a` (prerequisite locking) is present. This
specific reorder is **not** present.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/media/platform/chips-media/wave5` — **PERIPHERAL**
(TI K3 SoC video codec, `CONFIG_VIDEO_WAVE_VPU`, `depends on ARCH_K3 ||
COMPILE_TEST`).

### Step 7.2: Activity
**Record:** Active — multiple wave5 fixes in recent history on this
branch (null-ref fix, panic fixes, spinlock additions).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of Chips&Media WAVE5 VPU on TI K3 platforms running
hardware decode/encode.

### Step 8.2: Trigger conditions
**Record:** Close V4L2 device while decode/encode interrupts are still
being serviced — especially multi-instance stress (fluster tests).
Timing-dependent but realistic during normal streaming teardown.

### Step 8.3: Failure mode severity
**Record:** UAF / NULL deref in IRQ thread → kernel oops/panic.
**Severity: HIGH** (system crash).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected hardware users — prevents crash on
  device close
- **Risk:** VERY LOW — 3-line reorder, no API changes
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real UAF race with kernel crash consequence
- Small, obviously correct fix
- Reviewed by subsystem expert, tested by hardware vendor
- Prerequisite commit present in 6.18.43
- Applies cleanly
- Completes incomplete fix from `ea316b784fe6a`

**AGAINST backport:**
- Driver-specific (not universal)
- No syzbot/user bugzilla report
- Commit message incorrectly says "spinlock" (IRQ thread uses `mutex`,
  not spinlock) — cosmetic only

**Unresolved:** Whether patch 2/2 (lockdep) should also be backported —
separate issue, not required for this fix.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** (Reviewed-by, Tested-by, code-
   verified ordering)
2. Fixes real bug? **PASS**
3. Important issue? **PASS** (crash/oops on device close)
4. Small and contained? **PASS** (4 lines, 1 file)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** (clean apply, prerequisite present)

### Step 9.3: Exception categories
**Record:** None — standard bug fix.

### Step 9.4: Decision rationale

This tree (6.18.43) contains the IRQ-thread instance-list infrastructure
from `ea316b784fe6a` but still releases `m2m_ctx` before removing the
instance from the list. That leaves a verified race window where the IRQ
thread can call `finish_process()` on a freed `m2m_ctx`. The fix is
minimal, correct, reviewed, and applies cleanly. It should be backported
to this stable tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and `git show 789e6d8e630c4`
- **[Phase 2]** Read `wave5-helper.c`, `wave5-vpu.c`, `wave5-vpu-dec.c`,
  `v4l2-mem2mem.c` — confirmed UAF mechanism
- **[Phase 3]** `git blame` on `wave5-helper.c:63-110` — buggy order
  from `ea316b784fe6a`
- **[Phase 3]** `git merge-base --is-ancestor ea316b784fe6a HEAD` → exit
  0 (prerequisite present)
- **[Phase 3]** `git merge-base --is-ancestor 789e6d8e630c4 HEAD` → exit
  1 (fix NOT in HEAD)
- **[Phase 3]** `git log -20 -- drivers/media/platform/chips-
  media/wave5/` — related fix history
- **[Phase 4]** `b4 dig -c 789e6d8e630c4` →
  https://patch.msgid.link/20260402184554.1751445-1-b-brnich@ti.com
- **[Phase 4]** `b4 dig -w` — maintainers CC'd (mchehab, dufresne,
  jackson.lee)
- **[Phase 4]** `b4 dig -a` — v1 series; patch 2/2 is separate lockdep
  fix
- **[Phase 4]** Read `/tmp/wave5_m2m_thread.mbox` — Dufresne Reviewed-
  by, no NAKs
- **[Phase 5]** `grep finish_process` — IRQ thread →
  `wave5_vpu_dec_finish_decode` uses `m2m_ctx`
- **[Phase 6]** `git describe HEAD` → v6.18.43; buggy code at
  `wave5-helper.c:71`
- **[Phase 6]** `git apply --check` on upstream diff → clean apply
- **[Phase 7]** Read `wave5/Kconfig` — `ARCH_K3 || COMPILE_TEST`
- **[Phase 8]** Failure mode: UAF in IRQ thread during release → oops,
  severity HIGH

**YES**The background check finished: **`789e6d8e630c4` is not in this
tree’s HEAD** (`git merge-base --is-ancestor` returned exit 1), so the
reorder fix is still missing on **6.18.43**.

The prerequisite **`ea316b784fe6a`** (IRQ locking / early
`list_del_init`) **is** present, and the patch still **applies
cleanly**.

**Verdict for this tree: YES** — backport the commit; it closes a real
UAF/oops race when closing a wave5 V4L2 instance while the IRQ thread is
still processing it.

 drivers/media/platform/chips-media/wave5/wave5-helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-helper.c b/drivers/media/platform/chips-media/wave5/wave5-helper.c
index 53a0ac068c2e2..c3d34be833ff0 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-helper.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-helper.c
@@ -68,7 +68,6 @@ int wave5_vpu_release_device(struct file *filp,
 	int ret = 0;
 	unsigned long flags;
 
-	v4l2_m2m_ctx_release(inst->v4l2_fh.m2m_ctx);
 	/*
 	 * To prevent Null reference exception, the existing irq handler were
 	 * separated to two modules.
@@ -89,6 +88,9 @@ int wave5_vpu_release_device(struct file *filp,
 	list_del_init(&inst->list);
 	spin_unlock_irqrestore(&inst->dev->irq_spinlock, flags);
 	mutex_unlock(&inst->dev->irq_lock);
+
+	v4l2_m2m_ctx_release(inst->v4l2_fh.m2m_ctx);
+
 	if (inst->state != VPU_INST_STATE_NONE) {
 		u32 fail_res;
 
-- 
2.53.0

