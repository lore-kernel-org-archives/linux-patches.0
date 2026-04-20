Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306AB3AE1B9;
	Mon, 20 Apr 2026 13:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692003; cv=none; b=mzF0n3f/fLQ7IIr6qEjNYK8dcvMVhWhO9R386XSUiT+XXvDZOhoFF3cT9Fn4+g5y9afoK0vXUJN2zHE8qH96WYU7YR82wcGO7SaWLFAcFshX4x3aETVSOudeZotpjc/+JU9VQpZJseHQ0tTsHHTEnmWMxo3RFbX6SYaqQppdzns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692003; c=relaxed/simple;
	bh=xFW6uvgmMmtOrI+bb9sEhiu/oCjr/ge72kMhUFEXVO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYxaU71/N03sQ9B3FwACCHORWpqjlVGyQQztr6ntQ27Ntwk621cIHg63q6MXJzu/01IlrQiQe+IP7q4j40ta0Xnk5PUbP3krX4qackgwQVtDtvlWU4+sd2CkRP1S1MV5m/FuqIaSYTCI3dBX2eyA4+6aD6ONofHUowqRVO3pQmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QN6Vy7h0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QN6Vy7h0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C758C19425;
	Mon, 20 Apr 2026 13:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692003;
	bh=xFW6uvgmMmtOrI+bb9sEhiu/oCjr/ge72kMhUFEXVO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QN6Vy7h006djr3q0SX/MyccGJu9Kq1SEw/04sTeSnGQd0nNQxE+Ox817ou76Fxej5
	 uaN6pvjVltcOU2LLVs//h0/sIwoIdb6mfovR80HBTctAZY12QZk7aAnMJJowdzg99m
	 ERyyUyBUdT459KzBpOCJoyI+2YLN57empGFrJ45h5PuMBxpxsQM2ymf0DjTtGNs8NM
	 NQxA7TRzQ/HiwZGlc7yAoKFdCNcAnXEx8d2P5ZSTkCYDpFm3vy6N3dFabrrDjGXWti
	 4zpA2HQOnj39I5Gax3gGWD+bnVpP/NKtn2SfoBMYZnrHZtnL9dJuekMZywVRwHXTLf
	 wFFz6k8rHTqUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	dave@stgolabs.net,
	jic23@kernel.org,
	vishal.l.verma@intel.com,
	djbw@kernel.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] cxl/region: Fix use-after-free from auto assembly failure
Date: Mon, 20 Apr 2026 09:21:50 -0400
Message-ID: <20260420132314.1023554-316-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 87805c32e6ad7b5ce2d9f7f47e76081857a4a335 ]

The following crash signature results from region destruction while an
endpoint decoder is staged, but not fully attached.

[ dj: Moved bus_find_device( to next line. ]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260327052821.440749-2-dan.j.williams@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Analysis: cxl/region: Fix use-after-free from auto assembly failure

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `cxl/region` (CXL memory region management)
- Action verb: "Fix" (explicit bug fix)
- Record: cxl/region Fix use-after-free bug triggered by region
  destruction after auto-assembly staging failure

**Step 1.2: Commit Tags (from original mbox found via b4)**
- Original mbox version (20260327052821.440749-2) contains:
  - `Fixes: a32320b71f08 ("cxl/region: Add region autodiscovery")` ←
    v6.3-rc1
  - `Cc: <stable@vger.kernel.org>` ← explicit stable nomination by
    author
  - `Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>`
- Reviewed-by: Ira Weiny, Alison Schofield, Dave Jiang (three maintainer
  reviewers)
- Signed-off-by: Dan Williams (author; CXL subsystem maintainer), Dave
  Jiang (committer)
- Link:
  patch.msgid.link/20260327052821.440749-2-dan.j.williams@intel.com
- Note: `[ dj: Moved bus_find_device( to next line. ]` - minor
  formatting adjustment at commit time
- Record: Author explicitly Cc'd stable, provides Fixes: tag, triple
  maintainer Reviewed-by

**Step 1.3: Commit Body**
- Candidate commit message is very short. Original mbox (before
  committer trimming) shows a full KASAN splat:
  ```
  BUG: KASAN: slab-use-after-free in __cxl_decoder_detach+0x724/0x830
  [cxl_core]
  Read of size 8 at addr ffff888265638840 by task modprobe/1287
  ... unregister_region+0x88/0x140 [cxl_core]
  ... devres_release_all+0x172/0x230
  ```
- The "staged" state is established by `cxl_region_attach_auto()` and
  finalized by `cxl_region_attach_position()`
- Memdev removal sees `cxled->cxld.region == NULL` (staged but not
  finalized) and falsely thinks decoder is unattached; later region
  removal finds stale pointer to freed endpoint decoder
- Record: Real bug, KASAN UAF, concrete crash, reachable via memdev
  unregister during autoassembly

**Step 1.4: Hidden Fix Detection**
- Not hidden - explicit "Fix use-after-free"
- Record: Explicit UAF fix, not disguised

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files: `drivers/cxl/core/region.c` (+50), `drivers/cxl/cxl.h` (+4 -2)
- Functions modified: `cxl_rr_ep_add`, `cxl_region_attach_auto`,
  `__cxl_decoder_detach`
- New functions: `cxl_region_by_target`, `cxl_cancel_auto_attach`
- Scope: single-subsystem surgical fix
- Record: ~60 lines added in 2 files, contained in CXL core

**Step 2.2: Code Flow Changes**
- Before: `cxl_region_attach_auto()` places cxled into
  `p->targets[pos]`, increments `nr_targets`, but `cxld->region` remains
  NULL until `cxl_rr_ep_add()` runs later. If the auto-assembly fails
  (never reaches `cxl_rr_ep_add`), the stale pointer in `p->targets[]`
  persists.
- After: New intermediate state `CXL_DECODER_STATE_AUTO_STAGED` tracks
  the "attached to target array but not yet fully attached" window;
  `__cxl_decoder_detach` now cancels the staging when `cxlr == NULL`
- Record: Adds state tracking for the previously-untracked window
  between target-array placement and region attachment

**Step 2.3: Bug Mechanism**
- Category: (d) Memory safety / UAF fix + state machine gap
- Mechanism: Race between auto-assembly failure and memdev removal. When
  memdev is removed via `cxld_unregister()`, `cxl_decoder_detach(NULL,
  cxled, -1, DETACH_INVALIDATE)` is called. Path hits `cxlr =
  cxled->cxld.region` which is NULL for a staged-but-not-assembled
  decoder, returns NULL without removing the stale `p->targets[pos]`
  pointer. Later region destruction dereferences the freed cxled.
- Record: UAF in `__cxl_decoder_detach` call path from
  `unregister_region` -> iterates freed targets

**Step 2.4: Fix Quality**
- Surgical: introduces one new enum value, state transitions in 2
  places, one new cleanup helper, one new matcher
- No API changes, no locking changes, no hot-path changes
- Low regression risk: only affects auto-assembly path on failure
- Record: High-quality, well-contained fix

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- `cxl_region_attach_auto()` and the `CXL_DECODER_STATE_AUTO` enum were
  introduced in the Fixes: target
- Record: Buggy code introduced in v6.3-rc1 via a32320b71f08

**Step 3.2: Follow Fixes: Tag**
- `git describe a32320b71f08 --contains` → `v6.3-rc1~89^2~6^2~7`
- Commit: "cxl/region: Add region autodiscovery" by Dan Williams, Feb
  2023
- Present in all stable trees from v6.3+: 6.6.y, 6.12.y, 6.15.y, 6.17.y
  (note: 6.1 predates the bug)
- Record: Bug exists in all stable trees from v6.3 onwards

**Step 3.3: File History**
- Recent changes relevant: `b3a88225519cf cxl/region: Consolidate
  cxl_decoder_kill_region() and cxl_region_detach()` (v6.17-rc1)
  refactored the two call sites into `__cxl_decoder_detach`;
  `d03fcf50ba56f cxl: Convert to ACQUIRE() for conditional rwsem
  locking` introduced new locking helpers
- Record: Code has been refactored in 7.0; older stable trees (<6.17)
  use `cxl_region_detach()` with similar `if (!cxlr) return 0;` pattern
  that has the same bug and would need an adapted backport

**Step 3.4: Author**
- Dan Williams is the CXL subsystem maintainer (originator of region
  autodiscovery); regular prolific contributor to drivers/cxl/
- Record: Subsystem maintainer authoring the fix → high trust

**Step 3.5: Dependencies**
- Fix uses `bus_find_device(&cxl_bus_type, ...)` - available since CXL
  bus exists
- Uses `__free(put_device)` scope-based cleanup - present in 6.6+
- No explicit prerequisites; part of a 9-patch series but patches 2-9
  are test/dax_hmem work unrelated to this fix
- Record: This patch (1/9) is self-contained; subsequent patches don't
  depend on it

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: b4 dig / Lore Discussion**
- `b4 am` at
  patch.msgid.link/20260327052821.440749-2-dan.j.williams@intel.com
  fetched the full 9-patch thread
- This is the only revision (no v1/v2 indicated in cover letter)
- Cover letter states: "One use-after-free has been there since the
  original automatic region assembly code."
- Record: Single revision, clean review history, author explicitly flags
  UAF age

**Step 4.2: Reviewers**
- Ira Weiny, Alison Schofield, Dave Jiang - all CXL maintainers (DKIM-
  verified intel.com sign-offs)
- All three provided Reviewed-by on this patch
- Record: Thoroughly reviewed by core CXL maintainers

**Step 4.3: Bug Report**
- Bug was discovered by the author while writing test code (series 8/9:
  "Simulate auto-assembly failure"). Series 9/9 adds a test that
  exercises this path.
- Record: Discovered via new test harness; reproducible and tested in
  tree

**Step 4.4: Related Patches**
- 9-patch series: patch 1/9 (this) is a standalone UAF fix; remaining
  patches refactor dax_hmem and add tests
- No dependencies between this patch and 2-9
- Record: Standalone fix, no series dependencies

**Step 4.5: Stable Mailing List**
- Cc: stable@vger.kernel.org was present in original mbox posting
- Record: Explicitly nominated for stable by author

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
- Modified: `cxl_rr_ep_add`, `cxl_region_attach_auto`,
  `__cxl_decoder_detach`
- Added: `cxl_region_by_target`, `cxl_cancel_auto_attach`
- Record: 3 modified, 2 new helpers

**Step 5.2: Callers**
- `cxl_region_attach_auto` is called from `cxl_region_attach` during
  region creation
- `__cxl_decoder_detach` is called from `cxl_decoder_detach`, which is
  called from `cxld_unregister()` (on endpoint decoder device removal)
  and `detach_target()` (sysfs detach)
- `cxld_unregister` is registered via `devm_add_action_or_reset` in
  `cxl_decoder_autoremove` - fires on device/driver removal
- Record: Reachable via module unload, memdev hot-unplug, and sysfs-
  driven detach

**Step 5.3: Callees**
- `cxl_cancel_auto_attach` uses `bus_find_device` (existing API) with a
  simple matcher
- Record: Uses existing, well-established kernel APIs

**Step 5.4: Call Chain Reachability**
- modprobe / rmmod cxl_test / rmmod cxl_mem → memdev removal →
  cxld_unregister → cxl_decoder_detach → __cxl_decoder_detach → UAF
- Production scenarios: CXL hot-unplug, module unload during
  autoassembly, memdev probe failure during multi-decoder region
  assembly
- Record: Reachable from module-unload paths; triggerable on real
  hardware

**Step 5.5: Similar Patterns**
- The `state != CXL_DECODER_STATE_AUTO` guard in
  `cxl_region_attach_auto()` (line 1779) checks for the simpler two-
  state enum; adding a staged state does not regress this check because
  the staged->auto transition is managed internally
- Record: No parallel instances needing the same fix

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Code in Stable Trees**
- `CXL_DECODER_STATE_AUTO` enum exists in v6.3 onwards (confirmed by
  checking v6.1 → missing, v6.3 → present)
- `cxl_region_attach_auto()` exists in v6.3 onwards
- The buggy `if (!cxlr) return 0;` (or `return NULL;`) pattern exists in
  v6.6, v6.12, v6.15 equivalents (verified by reading v6.6 and v6.12
  tags)
- Record: Bug exists in v6.3, v6.6, v6.12, v6.15, v6.17, v7.0 trees

**Step 6.2: Backport Complications**
- v6.17+: `__cxl_decoder_detach` exists with same structure → should
  apply cleanly or with minor offsets
- Pre-v6.17 (6.6, 6.12, 6.15): function was named `cxl_region_detach`
  and called directly from `cxl_decoder_kill_region` +
  `cxld_unregister`; fix would need adaptation - inserting
  `cxl_cancel_auto_attach(cxled)` before the `return 0` in
  `cxl_region_detach`
- Pre-6.6 `__free(put_device)` scope cleanup: available via cleanup.h
  since ~5.19, but usage may differ
- Record: Clean apply on 6.17+/7.0; adapted backport needed for 6.6-6.15

**Step 6.3: Related Fixes in Stable**
- `101c268bd2f37 cxl/port: Fix use-after-free, permit out-of-order
  decoder shutdown` (v6.12-rc6) - different UAF, already backported
- `b3a88225519cf cxl/region: Consolidate...` (v6.17-rc1) - refactor, not
  a fix
- Record: No duplicate fix already in stable

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem Criticality**
- drivers/cxl/ - CXL (Compute Express Link) memory subsystem
- Used for CXL memory devices, increasingly common in server/datacenter
  deployments
- Bug triggers during module unload or memdev removal - important for
  operability
- Record: IMPORTANT (growing datacenter usage; data-tier memory path)

**Step 7.2: Activity**
- Very actively developed subsystem (~140 commits to region.c since
  v6.6)
- Record: Active subsystem; fix is current

## PHASE 8: IMPACT AND RISK

**Step 8.1: Affected Users**
- Users of CXL memory devices whose auto-assembly fails (e.g., firmware-
  programmed decoders that can't fully assemble, partial hardware
  configurations, module unload races)
- Record: CXL hardware users; scope grows as CXL adoption grows

**Step 8.2: Trigger Conditions**
- Memdev removed while at least one endpoint decoder is in staged-but-
  not-completed state
- Reproducible via cxl_test with `fail_autoassemble` module option
  (added in patch 8/9)
- Production trigger: module reload during partial assembly; hardware
  hotplug during assembly
- Record: Realistic trigger; concrete reproducer provided in same series

**Step 8.3: Failure Mode**
- Kernel panic via KASAN slab-use-after-free
- Without KASAN: silent memory corruption or crash in
  `__cxl_decoder_detach`
- Severity: CRITICAL (UAF with clear path to crash)
- Record: CRITICAL - memory safety violation

**Step 8.4: Risk/Benefit**
- Benefit: HIGH - eliminates real UAF in CXL subsystem
- Risk: LOW - adds new state, doesn't change successful path; all
  transitions are bounded
- Ratio: Strong positive
- Record: Clear net benefit

## PHASE 9: SYNTHESIS

**Step 9.1: Evidence Compilation**
- FOR: UAF with KASAN trace, Fixes: tag → v6.3 (affects all modern
  stable trees), explicit Cc: stable by author, triple maintainer
  Reviewed-by, author is subsystem maintainer, concrete reproducer in
  same series, contained ~60-line fix, no new userspace API
- AGAINST: Some adaptation needed for pre-v6.17 stable trees (function
  renamed), patch is very new (not in mainline yet - currently in linux-
  next)
- Record: FOR evidence overwhelming

**Step 9.2: Stable Rules Check**
1. Obviously correct: YES (state transitions are bounded and reviewed)
2. Real bug: YES (KASAN-confirmed UAF)
3. Important: YES (CRITICAL - UAF, potential crash/corruption)
4. Small/contained: YES (2 files, ~60 lines)
5. No new features/APIs: YES (internal state enum addition only)
6. Applies cleanly: Mostly - clean on v6.17+/v7.0, needs adaptation for
   6.6-6.15

**Step 9.3: Exception Categories**
- Not a device-ID-add or quirk; standalone UAF fix

**Step 9.4: Decision**
- Clear YES. Real UAF, author-nominated for stable, well-reviewed,
  contained scope.

## Verification

- [Phase 1] Read original mbox via `b4 am` at `/tmp/20260326_dan_j_willi
  ams_dax_hmem_add_tests_for_the_dax_hmem_takeover_capability.mbx`:
  confirmed `Fixes: a32320b71f08`, `Cc: <stable@vger.kernel.org>`, KASAN
  splat, three Reviewed-by from CXL maintainers
- [Phase 2] Read `drivers/cxl/core/region.c` 1040-1070, 1780-1810,
  2150-2220 and `drivers/cxl/cxl.h` 360-405 to validate code flow
- [Phase 3] `git show a32320b71f08 --stat`: confirmed introduction
  commit is "cxl/region: Add region autodiscovery" by Dan Williams, Feb
  2023
- [Phase 3] `git describe a32320b71f08 --contains` →
  `v6.3-rc1~89^2~6^2~7`: bug present since v6.3
- [Phase 3] `git show v6.1:drivers/cxl/cxl.h | grep cxl_decoder_state`:
  empty (enum didn't exist before v6.3)
- [Phase 3] `git show v6.3:drivers/cxl/cxl.h`: confirmed enum exists in
  v6.3
- [Phase 3] `git log --author="Dan Williams"` in drivers/cxl/: confirmed
  Dan Williams as subsystem maintainer
- [Phase 3] `git log --grep="cxl_decoder_detach"`: confirmed
  consolidation in `b3a88225519cf` (v6.17-rc1)
- [Phase 4] `b4 am https://patch.msgid.link/...`: fetched 9-patch
  series, confirmed triple DKIM-verified Reviewed-by
- [Phase 4] Cover letter read: confirmed "One use-after-free has been
  there since the original automatic region assembly code"
- [Phase 4] `git log linux-next/master --grep="use-after-free from auto
  assembly"`: commit `87805c32e6ad7` present in linux-next but not
  mainline yet
- [Phase 5] `grep -n CXL_DECODER_STATE` in drivers/cxl: identified all
  usage sites
- [Phase 5] Read `drivers/cxl/core/port.c` around line 2190: confirmed
  `cxld_unregister` calls `cxl_decoder_detach(NULL, cxled, -1,
  DETACH_INVALIDATE)`, matching the UAF trigger path
- [Phase 6] `git show v6.6:drivers/cxl/core/region.c` and `v6.12`:
  confirmed `cxl_region_detach()` has same `if (!cxlr) return 0;` bug
- [Phase 8] KASAN stack trace in original mbox shows
  `__cxl_decoder_detach+0x724 ... unregister_region+0x88 ...
  devres_release_all+0x172` - concrete reachability
- UNVERIFIED: Whether backport adaptation for pre-6.17 stable trees will
  be straightforward or require substantial rework beyond renaming
  `__cxl_decoder_detach` → `cxl_region_detach`

**Summary**

This is a genuine, well-reviewed use-after-free fix with a KASAN-
confirmed crash signature, originating from the CXL subsystem
maintainer. The bug has existed since v6.3 when region autodiscovery was
introduced, affects all current stable trees, and the author explicitly
Cc'd stable. The fix is small, contained, and introduces only an
internal enum value plus a cleanup helper. Reviewed by three CXL
maintainers. Pre-v6.17 stable trees will need minor contextual
adaptation due to the `__cxl_decoder_detach` refactor, but the
underlying logic is directly transferable.

**YES**

 drivers/cxl/core/region.c | 54 ++++++++++++++++++++++++++++++++++++++-
 drivers/cxl/cxl.h         |  6 +++--
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 373551022a2b3..1e97443535167 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1063,6 +1063,14 @@ static int cxl_rr_ep_add(struct cxl_region_ref *cxl_rr,
 
 	if (!cxld->region) {
 		cxld->region = cxlr;
+
+		/*
+		 * Now that cxld->region is set the intermediate staging state
+		 * can be cleared.
+		 */
+		if (cxld == &cxled->cxld &&
+		    cxled->state == CXL_DECODER_STATE_AUTO_STAGED)
+			cxled->state = CXL_DECODER_STATE_AUTO;
 		get_device(&cxlr->dev);
 	}
 
@@ -1804,6 +1812,7 @@ static int cxl_region_attach_auto(struct cxl_region *cxlr,
 	pos = p->nr_targets;
 	p->targets[pos] = cxled;
 	cxled->pos = pos;
+	cxled->state = CXL_DECODER_STATE_AUTO_STAGED;
 	p->nr_targets++;
 
 	return 0;
@@ -2153,6 +2162,47 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 	return 0;
 }
 
+static int cxl_region_by_target(struct device *dev, const void *data)
+{
+	const struct cxl_endpoint_decoder *cxled = data;
+	struct cxl_region_params *p;
+	struct cxl_region *cxlr;
+
+	if (!is_cxl_region(dev))
+		return 0;
+
+	cxlr = to_cxl_region(dev);
+	p = &cxlr->params;
+	return p->targets[cxled->pos] == cxled;
+}
+
+/*
+ * When an auto-region fails to assemble the decoder may be listed as a target,
+ * but not fully attached.
+ */
+static void cxl_cancel_auto_attach(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_region_params *p;
+	struct cxl_region *cxlr;
+	int pos = cxled->pos;
+
+	if (cxled->state != CXL_DECODER_STATE_AUTO_STAGED)
+		return;
+
+	struct device *dev __free(put_device) =
+		bus_find_device(&cxl_bus_type, NULL, cxled, cxl_region_by_target);
+	if (!dev)
+		return;
+
+	cxlr = to_cxl_region(dev);
+	p = &cxlr->params;
+
+	p->nr_targets--;
+	cxled->state = CXL_DECODER_STATE_AUTO;
+	cxled->pos = -1;
+	p->targets[pos] = NULL;
+}
+
 static struct cxl_region *
 __cxl_decoder_detach(struct cxl_region *cxlr,
 		     struct cxl_endpoint_decoder *cxled, int pos,
@@ -2176,8 +2226,10 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
 		cxled = p->targets[pos];
 	} else {
 		cxlr = cxled->cxld.region;
-		if (!cxlr)
+		if (!cxlr) {
+			cxl_cancel_auto_attach(cxled);
 			return NULL;
+		}
 		p = &cxlr->params;
 	}
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 9b947286eb9b0..30a31968f2663 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -378,12 +378,14 @@ struct cxl_decoder {
 };
 
 /*
- * Track whether this decoder is reserved for region autodiscovery, or
- * free for userspace provisioning.
+ * Track whether this decoder is free for userspace provisioning, reserved for
+ * region autodiscovery, whether it is started connecting (awaiting other
+ * peers), or has completed auto assembly.
  */
 enum cxl_decoder_state {
 	CXL_DECODER_STATE_MANUAL,
 	CXL_DECODER_STATE_AUTO,
+	CXL_DECODER_STATE_AUTO_STAGED,
 };
 
 /**
-- 
2.53.0

