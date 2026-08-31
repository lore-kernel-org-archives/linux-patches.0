Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3CD563FCB;
	Mon, 31 Aug 2026 13:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184074; cv=none; b=WrQGXIOhaJINfibF23b44M2r8cJYUtT3mklMl8yMw4BMMCzDbHbYk8SEwkST984UC9Gqoz44lkmnTB6ilMtcuYCPyoWaX5RUVwTpQSx7OqiqkDwpM4g+K1C7rETgWNz92Klb6qb2458sSi5C/vi/ARUjhcK4p/FEH/CIcMe9oIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184074; c=relaxed/simple;
	bh=Mr4XhCgtR7TPrv97db74jm7dZPzw0BkfD9Qdcyiaal0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QJBaWJqDg9FT2bv3wrZb++aZLeYIWuPnGaFm1r7EFL8n3DywY24muDs3uHpz/r3+Pnwg2eOgoSkrojjsTKHRuFi0uNynG/RoRhT6T5+BtfY5m9n3z6bc5xL5TVVRDzh9VwRzaG+iHdUH6iA9XFmLhXVLUvV72Aky/Cn1e8V3ijM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5ZEvXuB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5ZEvXuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6B01F00A3E;
	Mon, 31 Aug 2026 13:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184070;
	bh=M0qEMiwmP+nSe1O8FvNVwlw9fe6ZqScjcV3zg50zqgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5ZEvXuBrqYzQ3Qwy/AufXWVJ0qxfVxqjkjtLb1YYymyq8D1rlDWh2+SW7x744WNP
	 Emr0WqKZPAM9unU3EFI9/Wv+XvpXgLqDVynJgfkN+QKw52DnF2I0yVRxuJa6+9Ttwk
	 TVVnVt8Lo86n5ifGsRYl+3FdvOoLYcJL+cKXW8xsRqBTFkXuyfrxwbUYYNMGTS5V4C
	 qTSjYLne2CH2+2gKUF8FHQO81Pnmc76pJW6tXUBh8QhO7pLDhaar41d5AOQMu7PtVN
	 6V53RWpWifumLn8xFSSwBFhuViMaAbfTNTNhIz1MKXHfMSfnPeP4JYokdRaeAVrRHx
	 ALZJaueKhKU2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/amdkfd: Check bounds for allocate_sdma_queue restore_sdma_id
Date: Mon, 31 Aug 2026 09:28:21 -0400
Message-ID: <20260831133314.4125787-473-sashal@kernel.org>
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

From: David Francis <David.Francis@amd.com>

[ Upstream commit bfe9a7545b2a7be1c543f1741e16f2d5ec4116ae ]

allocate_sdma_queue has an option where the sdma queue id can be
specified (used by CRIU). We weren't bounds-checking that
value.

Confirm it's less than the maximum number of queues.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
# Stable Backport Analysis: `drm/amdkfd: Check bounds for
allocate_sdma_queue restore_sdma_id`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, `make kernelversion` → `6.18.43`)

**Commit under review:** `bfe9a7545b2a7be1c543f1741e16f2d5ec4116ae` (not
present in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 – Subject line**

Record: `[drm/amdkfd]` `[Check]` – add bounds validation for user-
specified `restore_sdma_id` in `allocate_sdma_queue()` during CRIU queue
restore.

**Step 1.2 – Tags**

| Tag | Value |
|-----|-------|
| Signed-off-by | David Francis \<David.Francis@amd.com\> |
| Reviewed-by | Harish Kasiviswanathan
\<Harish.Kasiviswanathan@amd.com\> |
| Signed-off-by | Alex Deucher \<alexander.deucher@amd.com\>
(maintainer) |

Notable absences (expected for manual review): no `Fixes:`, `Reported-
by:`, `Cc: stable@vger.kernel.org`, `Link:`.

Record: AMD maintainer-reviewed fix; no fuzzer or user bug report tags.
Part of a 2-patch series (patch 1/2 fixes `allocate_doorbell` bounds).

**Step 1.3 – Body**

Record:
- **Bug:** `allocate_sdma_queue()` accepts a caller-specified SDMA queue
  ID for CRIU restore but never validates it is within the number of
  available queues.
- **Symptom:** Out-of-bounds `test_bit()` / `clear_bit()` on
  `sdma_bitmap` / `xgmi_sdma_bitmap` when a restored `sdma_id` is too
  large; kernel memory safety issue.
- **Root cause:** CRIU restore path passes `q_data->sdma_id` (copied
  from userspace) straight into `allocate_sdma_queue()` without
  validation.

**Step 1.4 – Hidden bug fix?**

Record: **Yes.** Although the subject says "Check bounds," this is a
genuine memory-safety bug fix, not cosmetic cleanup. The companion
`deallocate_sdma_queue()` already bounds-checks `sdma_id`; the allocate-
restore path was inconsistent.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 – Inventory**

| File | Change |
|------|--------|
| `drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c` | +6 lines |

Functions modified: `allocate_sdma_queue()` only. Scope: single-file,
surgical fix.

**Step 2.2 – Code flow (per hunk)**

**Hunk 1 – `KFD_QUEUE_TYPE_SDMA` restore path:**
- Before: if `restore_sdma_id` is non-NULL, immediately
  `test_bit(*restore_sdma_id, dqm->sdma_bitmap)`.
- After: reject `*restore_sdma_id >= get_num_sdma_queues(dqm)` with
  `-EINVAL` before touching the bitmap.

**Hunk 2 – `KFD_QUEUE_TYPE_SDMA_XGMI` restore path:**
- Same pattern using `get_num_xgmi_sdma_queues(dqm)`.

Record: Both hunks guard the CRIU-restore branch only; normal allocation
(`find_first_bit`) is unchanged.

**Step 2.3 – Bug mechanism**

Record: **Memory safety / bounds validation bug (d).**
- `sdma_bitmap` is `DECLARE_BITMAP(sdma_bitmap, KFD_MAX_SDMA_QUEUES)`
  where `KFD_MAX_SDMA_QUEUES = 128`.
- `get_num_sdma_queues()` is typically much smaller (e.g., engines ×
  queues_per_engine, often single digits to low tens).
- `kfd_criu_restore_queue()` copies `q_data->sdma_id` (`uint32_t`) from
  userspace with no validation.
- Without the fix, `sdma_id >= 128` causes out-of-bounds bitmap access
  in `test_bit()` / `clear_bit()`.
- For `sdma_id` in `[get_num_sdma_queues(), 127)`, bits are zero →
  misleading `-EBUSY` rather than crash, but still incorrect.

**Step 2.4 – Fix quality**

Record: Fix is **obviously correct**, minimal (6 lines), mirrors
existing `deallocate_sdma_queue()` bounds checks at lines 1686–1691.
Regression risk is very low: only rejects previously invalid inputs
earlier with `-EINVAL`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 – Blame**

Record: `restore_sdma_id` logic in `allocate_sdma_queue()` is present in
this tree (lines 1588–1621). `git blame` attributes the block to commit
`a112b91dd6349` (history in this tree is squashed/limited). The restore
path and CRIU infrastructure are present in 6.18.43.

**Step 3.2 – Fixes: tag**

Record: N/A – no `Fixes:` tag in commit message.

**Step 3.3 – Related file history**

Record: `git log --oneline --
drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c` returns only one
commit in this tree (limited history). CRIU queue restore code
(`kfd_criu_restore_queue`, `create_queue_cpsch` with `qd->sdma_id`) is
present and active.

**Step 3.4 – Author context**

Record: David Francis (AMD). Reviewed by Harish Kasiviswanathan;
committed by Alex Deucher (amdkfd maintainer). Part of v1 series
submitted 2026-05-12.

**Step 3.5 – Dependencies**

Record: **Standalone.** Patch 1/2 (`allocate_doorbell` bounds) is a
separate, related hardening fix. This patch does not depend on it. `git
merge-base --is-ancestor bfe9a75 HEAD` → exit 1 (fix not yet in tree).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 – Original discussion**

Record:
- `b4 dig -c bfe9a7545b2a7be1c543f1741e16f2d5ec4116ae` → https://patch.m
  sgid.link/20260512192824.3682569-2-David.Francis@amd.com
- `b4 dig -a`: v1 series, 2 patches, dated 2026-05-12.
- v1 initially had a bug (`restore_sdma_id >= ...` instead of
  `*restore_sdma_id`); author self-corrected in follow-up. The
  committed/applied version uses `*restore_sdma_id` (matches the diff
  under review).

**Step 4.2 – Reviewers**

Record: `b4 dig -w` → To/Cc: David Francis, amd-
gfx@lists.freedesktop.org. Reviewed-by from AMD colleague; Signed-off-by
maintainer Alex Deucher.

**Step 4.3 – Bug report**

Record: No external bug report, syzbot link, or crash trace. Bug
identified by code inspection during CRIU hardening (paired with
doorbell bounds patch).

**Step 4.4 – Series context**

Record: `[PATCH 1/2] drm/amdkfd: Check bounds on allocate_doorbell` is
independent. Both are CRIU ioctl-input validation fixes.

**Step 4.5 – Stable list**

Record: Could not search lore stable archive (Anubis bot protection). No
evidence of prior stable rejection found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 – Key functions**

Record: `allocate_sdma_queue()` (modified); callers unchanged.

**Step 5.2 – Callers**

Record:
- `create_queue_nocpsch()` line 664: `allocate_sdma_queue(dqm, q, qd ?
  &qd->sdma_id : NULL)`
- `create_queue_cpsch()` line 1985: same pattern

Both reached from `pqm_create_queue()` → `kfd_criu_restore_queue()` when
`q_data` is non-NULL.

**Step 5.3 – Callees**

Record: `get_num_sdma_queues()`, `get_num_xgmi_sdma_queues()`,
`test_bit()`, `clear_bit()`, `find_first_bit()`, `bitmap_empty()`.

**Step 5.4 – Reachability**

Call chain:
```
kfd_ioctl_criu (KFD_CRIU_OP_RESTORE)
  → criu_restore()
    → criu_restore_objects()
      → kfd_criu_restore_queue()  [copy_from_user q_data->sdma_id]
        → pqm_create_queue(..., q_data, ...)
          → dqm->ops.create_queue(..., qd, ...)
            → allocate_sdma_queue(dqm, q, &qd->sdma_id)
```

Record: **Reachable from userspace** via `KFD_IOC_CRIU` restore ioctl.
Requires `CAP_CHECKPOINT_RESTORE` or `CAP_SYS_ADMIN` (verified in
`kfd_chardev.c` lines 3332–3337). Not unprivileged, but still a
privileged ioctl input-validation bug.

**Step 5.5 – Similar patterns**

Record: `deallocate_sdma_queue()` already bounds-checks before
`set_bit()`:

```1685:1692:drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
        if (q->properties.type == KFD_QUEUE_TYPE_SDMA) {
                if (q->sdma_id >= get_num_sdma_queues(dqm))
                        return;
                set_bit(q->sdma_id, dqm->sdma_bitmap);
        } else if (q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI) {
                if (q->sdma_id >= get_num_xgmi_sdma_queues(dqm))
                        return;
```

The allocate-restore path was the missing symmetric check.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

**Step 6.1 – Buggy code present?**

Record: **YES.** `allocate_sdma_queue()` at lines 1588–1621 lacks bounds
checks. CRIU infrastructure (`kfd_criu_queue_priv_data.sdma_id`,
`kfd_criu_restore_queue`) is fully present. `KFD_MAX_SDMA_QUEUES = 128`.

**Step 6.2 – Backport complications**

Record: **Clean apply expected.** The target lines match the mainline
diff context. No conflicting changes observed. Fix commit is not in tree
(`git merge-base --is-ancestor` → not ancestor).

**Step 6.3 – Related fixes already present?**

Record: `deallocate_sdma_queue()` bounds checks exist. No equivalent
allocate-side check. `git log --grep="bounds.*sdma"` → no matches. Fix
not yet applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 – Subsystem**

Record: `drivers/gpu/drm/amd/amdkfd` – AMDGPU HSA/KFD compute driver.
**IMPORTANT** (not core kernel, but widely deployed on AMD GPU systems
with ROCm/compute workloads).

**Step 7.2 – Activity**

Record: amdkfd is actively maintained; CRIU checkpoint/restore support
is a relatively newer feature in this area.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 – Who is affected**

Record: Users of **AMD GPU compute (amdkfd)** with **CRIU
checkpoint/restore** enabled. Config-dependent
(`CONFIG_HSA_AMD`/amdkfd). Not universal, but real for containerized GPU
workload migration.

**Step 8.2 – Trigger conditions**

Record:
- Malformed or adversarial CRIU checkpoint with `sdma_id >=
  get_num_sdma_queues()` (especially `>= 128`).
- Triggered during `KFD_CRIU_OP_RESTORE` on SDMA or SDMA_XGMI queue
  objects.
- Requires `CAP_CHECKPOINT_RESTORE` or `CAP_SYS_ADMIN`.
- Likelihood: low in normal use; realistic with corrupted checkpoints or
  malicious privileged actor.

**Step 8.3 – Failure mode severity**

Record:
- `sdma_id >= 128`: **out-of-bounds bitmap access** → potential kernel
  oops, memory corruption. **Severity: HIGH** (memory safety).
- `sdma_id` in valid bitmap range but above queue count: incorrect
  `-EBUSY`, no crash. **Severity: LOW**.

**Step 8.4 – Risk/benefit**

| | Assessment |
|--|------------|
| **Benefit** | Prevents OOB kernel memory access on a privileged ioctl
path; aligns allocate/deallocate safety |
| **Risk** | Very low – 6 lines, only rejects invalid input |
| **Ratio** | Favorable for backport |

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 – Evidence summary**

**FOR backport:**
- Real bounds-check omission with OOB potential (`sdma_id >= 128` on
  128-bit bitmap)
- Userspace-controlled value via CRIU restore ioctl
- Small, surgical, maintainer-reviewed fix
- Buggy code confirmed present in 6.18.43
- Consistent with existing `deallocate_sdma_queue()` pattern
- Standalone (no dependencies)

**AGAINST backport:**
- Requires elevated capability (not unprivileged attack)
- CRIU/amdkfd is a niche code path
- No syzbot or user crash report
- Patch 1/2 (doorbell bounds) is a separate fix not included here

**Unresolved:** No runtime crash report; exact introduction commit of
`restore_sdma_id` path not traceable in this tree's limited git history.

**Step 9.2 – Stable rules checklist# Stable Backport Analysis:
`drm/amdkfd: Check bounds for allocate_sdma_queue restore_sdma_id`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, `make kernelversion` → `6.18.43`)

**Commit under review:** `bfe9a7545b2a7be1c543f1741e16f2d5ec4116ae` (not
present in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/amdkfd]` `[Check]` — Add bounds validation for
`restore_sdma_id` in `allocate_sdma_queue()` during CRIU queue restore.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** David Francis `<David.Francis@amd.com>` (author)
- **Reviewed-by:** Harish Kasiviswanathan
  `<Harish.Kasiviswanathan@amd.com>`
- **Signed-off-by:** Alex Deucher `<alexander.deucher@amd.com>`
  (maintainer)
- **No** Fixes:, Reported-by:, Link:, Cc: stable@vger.kernel.org,
  Tested-by:, Acked-by:
- Notable: Part of a 2-patch series (`[PATCH 2/2]`); patch 1/2 is a
  separate `allocate_doorbell` bounds fix.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `allocate_sdma_queue()` accepts a user-specified SDMA queue
  ID for CRIU restore but never validates it is within the number of
  available queues.
- **Symptom:** Out-of-range `sdma_id` reaches `test_bit()` /
  `clear_bit()` on the SDMA bitmap without validation.
- **Root cause:** The CRIU restore path passes `q_data->sdma_id` from
  userspace straight into `allocate_sdma_queue()` with no bounds check
  on the allocate path (unlike the deallocate path).
- **Version info:** None in the commit message.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit bounds-check bug fix, not disguised
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c` (+6
  / −0)
- **Function:** `allocate_sdma_queue()`
- **Scope:** Single-file, surgical fix in two CRIU-restore branches
  (SDMA and XGMI SDMA).

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (KFD_QUEUE_TYPE_SDMA):** Before → `restore_sdma_id` used
  directly in `test_bit(*restore_sdma_id, dqm->sdma_bitmap)`. After →
  reject with `-EINVAL` if `*restore_sdma_id >=
  get_num_sdma_queues(dqm)`.
- **Hunk 2 (KFD_QUEUE_TYPE_SDMA_XGMI):** Same pattern using
  `get_num_xgmi_sdma_queues(dqm)`.
- **Path affected:** CRIU queue restore only (when `restore_sdma_id` is
  non-NULL).

### Step 2.3: Bug mechanism
**Record:** **Memory safety / bounds validation bug (d).**
- `sdma_bitmap` is `DECLARE_BITMAP(sdma_bitmap, KFD_MAX_SDMA_QUEUES)`
  where `KFD_MAX_SDMA_QUEUES` is **128**.
- `get_num_sdma_queues()` is typically much smaller (e.g. engines ×
  queues_per_engine, often single digits to low tens).
- Without the check, a `sdma_id >= 128` from userspace causes
  `test_bit()` / `clear_bit()` to operate outside the 128-bit bitmap →
  out-of-bounds kernel memory access.
- For `get_num_sdma_queues() <= sdma_id < 128`, bits are zero and the
  code returns `-EBUSY` (no crash, but still invalid input that should
  be rejected earlier).

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and mirrors the existing pattern in
  `deallocate_sdma_queue()` (lines 1686–1691), which already bounds-
  checks `q->sdma_id`.
- Low regression risk: only affects the CRIU-restore path with an out-
  of-range ID.
- No API or structural changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `restore_sdma_id` logic in `allocate_sdma_queue()` is
present in this tree at lines 1588–1621. Git blame attributes these
lines to `a112b91dd6349` (history in this checkout is shallow/squashed
and not reliable for dating the original feature). The vulnerable
pattern is confirmed present in 6.18.43.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in the commit message.

### Step 3.3: Related file history
**Record:** `git log --oneline -20 -- kfd_device_queue_manager.c` shows
only one commit in this tree’s history for that file. The CRIU restore
infrastructure (`kfd_criu_restore_queue`, `create_queue_cpsch`,
`create_queue_nocpsch`) is fully present in 6.18.43. This patch is
**standalone** within its series; patch 1/2 (`allocate_doorbell` bounds)
is a separate fix.

### Step 3.4: Author context
**Record:** David Francis (AMD). Alex Deucher signed off. Harish
Kasiviswanathan reviewed. No other amdkfd commits from this author
visible in this tree’s limited history.

### Step 3.5: Dependencies
**Record:** No functional dependency on patch 1/2. The `restore_sdma_id`
pointer parameter and CRIU call sites already exist in this tree. `git
merge-base --is-ancestor bfe9a75 HEAD` → **not an ancestor** (fix not
yet applied).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c bfe9a7545b2a7be1c543f1741e16f2d5ec4116ae` → https://patch.m
  sgid.link/20260512192824.3682569-2-David.Francis@amd.com
- Series: v1 only (`b4 dig -a`); patch 2/2 of 2.
- v1 initially had a typo (`restore_sdma_id >=` instead of
  `*restore_sdma_id >=`); the committed/applied version (and the diff
  under review) correctly dereferences the pointer.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` — sent to David Francis and `amd-
gfx@lists.freedesktop.org`. Harish Kasiviswanathan reviewed; Alex
Deucher committed.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot report, or crash log.
Internal code-review discovery.

### Step 4.4: Series context
**Record:** 2-patch series:
1. `drm/amdkfd: Check bounds on allocate_doorbell`
2. This commit (SDMA queue ID bounds)

Each patch addresses a separate CRIU-restore validation gap. This one is
independently applicable.

### Step 4.5: Stable list history
**Record:** Could not search lore stable list (Anubis bot protection).
No stable nomination found via b4.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `allocate_sdma_queue()` (modified); callers unchanged.

### Step 5.2: Callers
**Record:**
- `create_queue_nocpsch()` — line 664: `allocate_sdma_queue(dqm, q, qd ?
  &qd->sdma_id : NULL)`
- `create_queue_cpsch()` — line 1985: same pattern
- Both reached from `pqm_create_queue()` → `kfd_criu_restore_queue()`
  when `q_data` is non-NULL.

### Step 5.3: Callees
**Record:** `get_num_sdma_queues()`, `get_num_xgmi_sdma_queues()`,
`test_bit()`, `clear_bit()`, `bitmap_empty()`, `find_first_bit()`.

### Step 5.4: Reachability
**Record:**
```
userspace ioctl (KFD_IOC_CRIU, KFD_CRIU_OP_RESTORE)
  → criu_restore() → criu_restore_objects()
  → kfd_criu_restore_queue() [copy_from_user q_data->sdma_id]
  → pqm_create_queue(..., q_data, ...)
  → create_queue_{nocpsch,cpsch}(..., qd, ...)
  → allocate_sdma_queue(dqm, q, &qd->sdma_id)
```
- Requires `CONFIG_HSA_AMD` / amdgpu KFD.
- CRIU ioctl gated on `CAP_CHECKPOINT_RESTORE` or `CAP_SYS_ADMIN`
  (kfd_chardev.c:3332–3337).
- Reachable from userspace with elevated privileges, not from
  unprivileged users.

### Step 5.5: Similar patterns
**Record:** `deallocate_sdma_queue()` already bounds-checks before
`set_bit()`:
```1686:1691:drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
                if (q->sdma_id >= get_num_sdma_queues(dqm))
                        return;
                set_bit(q->sdma_id, dqm->sdma_bitmap);
```
The allocate path was missing the symmetric check. `allocate_doorbell()`
CP-queue restore path (patch 1/2) has a similar gap but is out of scope
for this commit.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Lines 1588–1621 in this tree use `*restore_sdma_id`
in `test_bit()` / `clear_bit()` without prior bounds validation.
`KFD_MAX_SDMA_QUEUES` is 128 (`kfd_priv.h:123`). CRIU restore and
`kfd_criu_queue_priv_data.sdma_id` exist in 6.18.43.

### Step 6.2: Backport complications
**Record:** Expected **clean apply** — 6 lines added in two well-defined
locations; no structural conflicts observed.

### Step 6.3: Related fixes already present?
**Record:** **No.** `git merge-base --is-ancestor bfe9a75 HEAD` failed
(fix not in tree). No grep hits for the bounds-check pattern in the
allocate path.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/amd/amdkfd` — **IMPORTANT** (AMD GPU
compute / ROCm KFD). Not core kernel, but widely deployed on AMD GPU
servers and workstations.

### Step 7.2: Activity
**Record:** Limited git history in this checkout; amdkfd CRIU support is
mature enough to be present in 6.18.43.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of AMD KFD with CRIU checkpoint/restore (container
migration, HPC job migration). Requires amdgpu + HSA_AMD + privileged
CRIU ioctl access.

### Step 8.2: Trigger conditions
**Record:**
- CRIU restore of an SDMA or XGMI SDMA queue with `sdma_id >=
  get_num_sdma_queues()` (or `>= 128` for definite OOB).
- Triggered by malicious/corrupt checkpoint data or a buggy userspace
  restorer.
- **Not** triggerable by unprivileged users.
- Moderately rare in practice (CRIU + AMD GPU), but straightforward to
  trigger with crafted input once privileges are held.

### Step 8.3: Failure mode severity
**Record:**
- `sdma_id >= 128`: **HIGH** — out-of-bounds `test_bit()` /
  `clear_bit()` on a 128-bit bitmap → potential kernel memory corruption
  or crash.
- `get_num_sdma_queues() <= sdma_id < 128`: **LOW** — returns `-EBUSY`,
  no memory corruption.
- Overall: **HIGH** for the OOB case; privilege requirement lowers
  practical exploitability but not correctness importance.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — closes a kernel memory-safety hole on a
  privileged ioctl path; aligns allocate/deallocate symmetry.
- **Risk:** VERY LOW — 6-line validation, reviewed by AMD maintainers.
- **Ratio:** Benefit outweighs risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real missing bounds check on userspace-supplied `sdma_id` in CRIU
  restore.
- Can cause OOB bitmap access when `sdma_id >= 128`.
- Small (6 lines), obviously correct, AMD-reviewed.
- Buggy code confirmed in 6.18.43; fix not yet applied.
- Symmetric with existing `deallocate_sdma_queue()` bounds checks.

**AGAINST backport:**
- Requires `CAP_CHECKPOINT_RESTORE` or `CAP_SYS_ADMIN` — not
  unprivileged attack surface.
- CRIU + AMD GPU is a niche configuration.
- No syzbot/user crash report.
- Companion patch 1/2 (doorbell bounds) is separate; ideally both go in,
  but this patch stands alone.

**Unresolved:** Exact kernel version when CRIU `restore_sdma_id` was
introduced (shallow history in this checkout).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — trivial validation;
   Reviewed-by from AMD; no Tested-by.
2. Fixes a real bug? **PASS** — missing input validation on ioctl-fed
   data.
3. Important issue? **PASS** — OOB kernel memory access (HIGH when
   `sdma_id >= 128`).
4. Small and contained? **PASS** — 6 lines, one file, one function.
5. No new features or APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — code exists; clean apply
   expected.

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Qualifies as a standard security/correctness bug fix.

### Step 9.4: Decision rationale
For **Linux 6.18.43**, the vulnerable CRIU-restore path exists and the
fix is a minimal, maintainer-reviewed bounds check that prevents out-of-
bounds bitmap access on a userspace-controlled value. The privilege
requirement reduces attack surface but does not eliminate the bug:
privileged container/orchestration stacks using KFD CRIU are exactly the
affected users, and kernel memory safety fixes on ioctl paths are
appropriate stable material. The fix is self-contained and does not
depend on patch 1/2.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message.
- **[Phase 2]** Diff analysis: +6 lines, two bounds checks with
  `*restore_sdma_id` dereference.
- **[Phase 3]** `git describe HEAD` / `make kernelversion` → 6.18.43.
- **[Phase 3]** `git blame -L 1588,1621` → restore_sdma_id code present.
- **[Phase 3]** `git merge-base --is-ancestor bfe9a75 HEAD` → exit 1
  (fix not in tree).
- **[Phase 4]** `b4 dig -c bfe9a75` → lore URL found.
- **[Phase 4]** `b4 dig -a` → v1, 2-patch series.
- **[Phase 4]** `b4 dig -w` → amd-gfx@lists.freedesktop.org CC'd.
- **[Phase 4]** Web search confirmed commit
  `bfe9a7545b2a7be1c543f1741e16f2d5ec4116ae` and v1 pointer-deref fix in
  review.
- **[Phase 5]** `grep allocate_sdma_queue` → callers at lines 664, 1985.
- **[Phase 5]** Read `kfd_criu_restore_queue()` →
  `copy_from_user(q_data)` includes `sdma_id`, no validation.
- **[Phase 5]** Read `kfd_chardev.c:3332-3337` → CAP_CHECKPOINT_RESTORE
  or CAP_SYS_ADMIN required.
- **[Phase 5]** `KFD_MAX_SDMA_QUEUES` = 128 (`kfd_priv.h:123`).
- **[Phase 5]** `deallocate_sdma_queue()` bounds checks at lines
  1686–1691 confirmed.
- **[Phase 6]** Current code at lines 1588–1621 lacks bounds check
  (verified by read + grep).
- **[Phase 6]** CRIU infrastructure present: `kfd_criu_restore_queue`,
  `kfd_criu_queue_priv_data.sdma_id`.
- **[Phase 8]** Failure mode: OOB when `sdma_id >= 128`; privilege-gated
  trigger confirmed.
- **UNVERIFIED:** Exact upstream commit that introduced
  `restore_sdma_id` (shallow git history in this checkout).

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index c650ffc3e66e8..2f8df95382bc3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1586,6 +1586,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 		}
 
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!test_bit(*restore_sdma_id, dqm->sdma_bitmap)) {
 				dev_err(dev, "SDMA queue already in use\n");
@@ -1612,6 +1615,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 			return -ENOMEM;
 		}
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_xgmi_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!test_bit(*restore_sdma_id, dqm->xgmi_sdma_bitmap)) {
 				dev_err(dev, "SDMA queue already in use\n");
-- 
2.53.0

