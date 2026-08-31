Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D60942E438;
	Mon, 31 Aug 2026 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184350; cv=none; b=jp6/+CThtmuO0P/QzVz+zyolRlEmd8zFP+L/AmnZK7l0K1Y7O6zwahdyHl1Zs54CJVxU4iaTVxrBKuV5jpx+g4StcYMJ+y3Ts75Zr26fy2HdOaFlEWbOeZ8IsDPoaemZl7Ix3Lp9UBqpN+AQ+PDdcO2M+hNC7E3sdCdBpH7+krA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184350; c=relaxed/simple;
	bh=yq2TsEnzH0rAVpa+zv4y/e1uGaaWmp5qOApaRubGKd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UH8CZh+u1cv8H9UqHX8lhdf9IJQ16hcsZUEVrn3P51tVxwNd60HvxO82p3LMxzoUL0meQefNfQwbPU51QQzOmY76CPnHMR79t+VwRu2SL0qdfguGVCiVKnH4vq01CSJQ4b3DKFLWXizcCccTYb9tFaHOOr9xAvH6e5iJA1ctAcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7Ei3aLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7Ei3aLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3041B1F00ACF;
	Mon, 31 Aug 2026 13:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184347;
	bh=ya+pZcZsROeTq92EOwS98qoDIqV0o6/MQn2Vl568B18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7Ei3aLC2BScX+NGekhVIO5inX8FQ09cRULy8Edki1T+EMtN4ZPDOuFf4bTl7y+tD
	 yedW3e8jD6OWxMQCYOm7zplDx/AJPulXLOEZUb22FgQX4frHSaB522IiCB8u05rUxY
	 BAxxuWi3f5yTmwfMqM52IDzI0Q5166qb/qbcS/RnmJh9qi448gQeMMQ3LJcNTEpc5Q
	 1IsmyEnno028pc2waX41M8dIjebSR7SIG9B9zQIrYa9ux5+LS0HQffyrPkPbKxSqkY
	 2ytQqXhCW83pS3BCRxkTRGSaTd8NswUil/qX4VAB10Kv+rmoIdrx1Iq2M7Mwh7R7QG
	 Y9JFrNqU6YChQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: liuxixin <gliuxen@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] nvme: validate FDP configuration descriptor sizes
Date: Mon, 31 Aug 2026 09:31:08 -0400
Message-ID: <20260831133314.4125787-640-sashal@kernel.org>
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

From: liuxixin <gliuxen@gmail.com>

[ Upstream commit 0ef4daa6534a510d61ea67c8ad9bb5097b0dd5f8 ]

Validate descriptor sizes while walking the FDP configurations log so
dsze == 0 or a descriptor past the log end cannot cause unbounded
iteration or reads past the buffer.

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: liuxixin <gliuxen@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `nvme: validate FDP configuration descriptor
sizes`

**Local tree:** Linux **6.18.44** (`stable/linux-6.18.y`, `HEAD`
detached at `v6.18.44`)
**Mainline commit:** `0ef4daa6534a5` — **not present** in this tree;
buggy code **is present**

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[nvme]` `[validate]` — Validate FDP configuration
descriptor sizes while walking the FDP configurations log.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Nitesh Shetty `<nj.shetty@samsung.com>`
- **Reviewed-by:** Christoph Hellwig `<hch@lst.de>`
- **Signed-off-by:** liuxixin `<gliuxen@gmail.com>`
- **Signed-off-by:** Keith Busch `<kbusch@kernel.org>`
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`, or
  `Tested-by:` tags
- Notable: reviewed by NVMe/block maintainers; no syzbot report

### Step 1.3: Body analysis
**Record:**
- **Bug:** Walking FDP configuration descriptors uses `dsze` from
  device-provided log data without validating each descriptor size
  before advancing.
- **Symptoms:** `dsze == 0` or a descriptor extending past the log end
  can cause invalid iteration over the log buffer and reads past the
  allocated buffer.
- **Root cause:** Size is applied (`log += dsze`) before bounds are
  checked; zero-sized descriptors are not rejected.
- **Version info:** None in commit message.

### Step 1.4: Hidden bug fix?
**Record:** Yes — this is a defensive parsing fix for malformed or
malicious device log data, not cosmetic cleanup. It prevents out-of-
bounds reads and incorrect descriptor traversal during namespace setup
on FDP-capable NVMe controllers.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/nvme/host/core.c` (+6/−4 lines)
- **Function:** `nvme_query_fdp_granularity()`
- **Scope:** Single-file, surgical fix in one loop

### Step 2.2: Code flow change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Descriptor walk loop | Advance `log` by `desc->dsze`, then check `log
>= end` | Read `dsze`, reject `!dsze` or `log + dsze > end`, then
advance |
| Error message | Generic `"FDP invalid config descriptor list"` |
Specific `"FDP invalid config descriptor at index %d"` |

**Path affected:** Error/validation path during FDP granularity query at
namespace enumeration.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds read (memory safety);
  logic error on malformed descriptors
- **Mechanism:**
  1. **`dsze == 0`:** Pointer never advances; walk does not reach the
     intended `fdp_idx` descriptor; subsequent reads of `desc->nrg` and
     `desc->runs` use wrong data.
  2. **`log + dsze > end`:** Old code advanced first, then checked. A
     large `dsze` sets `desc` past the buffer before the check;
     depending on iteration count and layout, subsequent field reads
     (`nrg` at offset 4, `runs` at offset 12 in `struct
     nvme_fdp_config_desc`) can access memory beyond the `kvmalloc`'d
     log buffer.
  3. New code validates **before** advancing, rejecting zero or over-
     length descriptors.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal, obviously correct, and matches standard kernel parsing
  practice.
- Reviewed by Christoph Hellwig and Keith Busch (applied to `nvme-7.2`).
- **Regression risk:** Very low — only affects the error path for
  invalid FDP log data; valid devices unchanged.
- v5 cover letter notes removal of redundant `log >= end` check per
  maintainer feedback.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy loop introduced in `30b5f20bb2dda` ("nvme: register
fdp parameters with the block layer", Keith Busch, 2025-05-06). First
appeared in **v6.16**. Present in this 6.18.44 tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Introducing commit `30b5f20bb2dda` is
in this tree.

### Step 3.3: Related file history
**Record:**
- `5e406928404d6` — "nvme: fix FDP fdpcidx bounds check" (same author) —
  **already in 6.18.y**
- `0ef4daa6534a5` — this descriptor-size validation — **not in 6.18.y**
  (only on `master`)
- Companion fix from v4 series; v5 split out descriptor validation
  separately per maintainer feedback

### Step 3.4: Author context
**Record:** liuxixin contributed the related fdpcidx bounds fix already
backported to 6.18.y. Keith Busch (NVMe maintainer) committed both
fixes.

### Step 3.5: Dependencies
**Record:** Standalone — no series dependencies. Requires FDP code from
`30b5f20bb2dda`, which is present. `git apply --check` confirms clean
apply to current tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/e6f7a8b9c0d1e2f3a4b5c6d7e8f9a
  0b1c2d3e4f.1748841600.git.gliuxen@gmail.com
- **Series:** v1→v2 (combined parsing fix) → v4 (split: fdpcidx +
  descriptor validation) → v5 (descriptor validation only)
- Keith Busch applied v5 to `nvme-7.2`; no NAKs found in thread

### Step 4.2: Reviewers
**Record:** CC'd: `linux-nvme@lists.infradead.org`, `kbusch@kernel.org`,
`axboe@kernel.dk`, `hch@lst.de`, `nj.shetty@samsung.com`, `linux-
kernel@vger.kernel.org`

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. v5 cover letter
documents testing with **fdp-lab**: `dsze==0` and walk-past-end cases
produce `"FDP invalid config descriptor at index %d"`.

### Step 4.4: Related patches
**Record:** Descriptor validation was originally v4 2/2; split to v5
after fdpcidx fix (v4 1/2) was applied separately. fdpcidx fix is
already in 6.18.y; this patch is the remaining half.

### Step 4.5: Stable list
**Record:** No `Cc: stable` discussion found in mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `nvme_query_fdp_granularity()` (modified); callers via
`nvme_query_fdp_info()`.

### Step 5.2: Callers
**Record:**
- `nvme_query_fdp_info()` ← `nvme_update_ns_info_block()` (line 2373)
- `nvme_update_ns_info()` ← `nvme_alloc_ns()` (line 4163),
  `nvme_validate_ns()` (line 4300)
- `nvme_scan_ns()` → `nvme_alloc_ns()` / `nvme_validate_ns()` during
  namespace scan

### Step 5.3: Callees
**Record:** `nvme_get_log_lsi()`, `kvmalloc()`, `kvfree()`,
`le16_to_cpu()`, `le32_to_cpu()`, `le64_to_cpu()`, `dev_warn()`.

### Step 5.4: Reachability
**Record:**
- Triggered when `ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS` and FDP
  feature enabled (`FDPCFG_FDPE`)
- Runs during NVMe namespace enumeration (probe/rescan/AEN paths)
- Device-controlled log data from PCIe NVMe hardware — reachable
  whenever an FDP-capable controller is attached
- Not a general syscall path, but attacker with physical PCIe access or
  VFIO passthrough of a malicious device can supply crafted log data

### Step 5.5: Similar patterns
**Record:** Related fdpcidx bounds fix (`5e406928404d6`, already in
tree) addresses a separate off-by-one in the same function. This patch
completes FDP log parsing hardening.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at lines 2243–2251 still has the pre-
fix loop:

```2243:2251:drivers/nvme/host/core.c
        for (i = 0; i < fdp_idx; i++) {
                log += le16_to_cpu(desc->dsze);
                desc = log;
                if (log >= end) {
                        dev_warn(ctrl->device,
                                 "FDP invalid config descriptor
list\n");
                        ret = 0;
                        goto out;
                }
        }
```

FDP support landed in v6.16; present throughout 6.18.y.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` succeeds with no
conflicts. No rework needed.

### Step 6.3: Related fixes already present?
**Record:** `5e406928404d6` (fdpcidx bounds check) is in 6.18.y.
Descriptor-size validation (`0ef4daa6534a5`) is **not**.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/nvme/host/` — **IMPORTANT** (block storage, widely
deployed; niche FDP subset)

### Step 7.2: Activity
**Record:** NVMe/FDP code is actively maintained; FDP registration added
in 6.16, with follow-up fixes in 2026.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of NVMe controllers reporting `NVME_CTRL_ATTR_FDPS`
with FDP enabled. Growing but still limited hardware base (datacenter
SSDs with Flexible Data Placement). All such users on 6.18.y without
this fix.

### Step 8.2: Trigger conditions
**Record:**
- Controller advertises FDPS; namespace scan queries FDP configuration
  log
- Malformed firmware response or malicious device provides `dsze == 0`
  or oversized `dsze`
- Triggered at device attach/rescan — not everyday, but automatic on
  enumeration
- Physical attacker or compromised passthrough device can trigger

### Step 8.3: Failure mode severity
**Record:**
- **Out-of-bounds read** of kernel heap buffer → potential oops/crash or
  information leak — **HIGH**
- **Incorrect parsing** with zero `dsze` → wrong granularity registered
  — **MEDIUM**
- Not a typical soft-lockup (loop bounded by `u8 fdp_idx`, max 255),
  despite "unbounded iteration" wording referring to buffer traversal
- **Overall severity: HIGH** (memory safety on device-driven kernel
  parsing)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for FDP users; prevents OOB reads from device-
  controlled data
- **Risk:** VERY LOW — 6-line validation in error path, reviewed by
  maintainers, tested with fdp-lab
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real memory-safety bug in kernel parsing of device-provided data
- Buggy code present in 6.18.44; fix not yet applied
- Small, surgical, maintainer-reviewed fix
- Clean apply to current tree
- Companion fdpcidx fix already backported — this is the natural follow-
  up
- fdp-lab test coverage documented

**AGAINST backport:**
- Only affects FDP-capable NVMe hardware (limited audience)
- No syzbot/CVE report
- No explicit stable nomination on mailing list

**Unresolved:** None blocking decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reviewed by Hellwig/Shetty;
   fdp-lab tested
2. Fixes a real bug? **PASS** — OOB read / invalid descriptor walk on
   malformed FDP log
3. Important issue? **PASS** — memory safety, potential crash/info leak
   from device data
4. Small and contained? **PASS** — ~6 lines, one function
5. No new features/APIs? **PASS** — validation only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug-fix category.

### Step 9.4: Decision rationale
For **Linux 6.18.y** specifically: FDP support and the buggy descriptor-
walk code are both present; the fix is absent; the patch applies
cleanly; and it closes a real memory-safety hole in device log parsing
during namespace enumeration. The limited hardware scope lowers urgency
slightly, but stable rules favor small, correct fixes for crash/OOB-read
bugs in production drivers — especially when a related fix from the same
series is already in the tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from `git show
  0ef4daa6534a5`
- **[Phase 2]** Diff analysis: 6 lines changed in
  `nvme_query_fdp_granularity()` loop
- **[Phase 3]** `git blame -L 2240,2252`: buggy code from
  `30b5f20bb2dda` (2025-05-06)
- **[Phase 3]** `git merge-base --is-ancestor 30b5f20bb2dda HEAD`: FDP
  code in 6.18.y
- **[Phase 3]** `git merge-base --is-ancestor 0ef4daa6534a5 HEAD`: fix
  **not** in tree
- **[Phase 3]** `git tag -l 'v6.16*' --contains 30b5f20bb2dda`: FDP
  introduced in v6.16
- **[Phase 3]** `git apply --check`: patch applies cleanly
- **[Phase 3]** `5e406928404d6` already in 6.18.y (related fdpcidx fix)
- **[Phase 4]** `b4 dig -c 0ef4daa6534a5`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1→v5 series evolution documented
- **[Phase 4]** `b4 dig -w`: maintainers CC'd (Busch, Axboe, Hellwig,
  Shetty)
- **[Phase 4]** `b4 dig -m /tmp/fdp_validate.mbox`: v5 cover letter with
  fdp-lab test plan
- **[Phase 4]** No stable-list nomination in mbox
- **[Phase 5]** `grep nvme_query_fdp_info`: call chain through
  `nvme_update_ns_info_block` → `nvme_scan_ns`
- **[Phase 5]** Read `struct nvme_fdp_config_desc` in
  `include/linux/nvme.h` (lines 705–717)
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: **6.18.44**
- **[Phase 6]** Read current `core.c` lines 2243–2251: pre-fix code
  confirmed
- **[Phase 6]** `git merge-base --is-ancestor 30b5f20bb2dda
  stable/linux-6.12.y`: FDP **not** in 6.12.y (noted; verdict is for
  6.18.y only)
- **[Phase 8]** Failure mode: OOB read from device-controlled FDP log →
  HIGH severity

**YES**

 drivers/nvme/host/core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 43cbbcd3796b1..5ea331e933c55 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2241,14 +2241,16 @@ static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
 	desc = log;
 	end = log + size - sizeof(*h);
 	for (i = 0; i < fdp_idx; i++) {
-		log += le16_to_cpu(desc->dsze);
-		desc = log;
-		if (log >= end) {
+		u16 dsze = le16_to_cpu(desc->dsze);
+
+		if (!dsze || log + dsze > end) {
 			dev_warn(ctrl->device,
-				 "FDP invalid config descriptor list\n");
+				 "FDP invalid config descriptor at index %d\n", i);
 			ret = 0;
 			goto out;
 		}
+		log += dsze;
+		desc = log;
 	}
 
 	if (le32_to_cpu(desc->nrg) > 1) {
-- 
2.53.0

