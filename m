Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FA24D90D1;
	Mon, 20 Apr 2026 13:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692017; cv=none; b=cIe8+UKrAmht5zBm5KkyaUWTCf/jfLIqD3hFF/RzGZLoWBpj2puwqTmc4j5+k5o5/p/Wzlo2MALQs13A7kVKnKaY9kBaykTI+ZECZ0/X296OWy/RtZ9FiH2GAiyPn5RgkkR+fE8CV+/MdEFsZZxisfrWTcqXzzeuCgIisaiwm14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692017; c=relaxed/simple;
	bh=jvmYOPkTLZLZlS7JN2M40phX4qLm75L0szk72vSc99M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAjcNVualS9aFlJzZ9cgVaJZ+ab3uJEtO9N+qlVAwW3wIXefFJRFoPdPHCJ18KDfvOLqpAiGryPmmc5JGZTbAsHhSsgJ8MZsxkwnUVdXcIQQiWIGARvFcOQWmH4aqWkhACYEViVoCDy6UWBfA99GeiXKR5bOidih4CKv8nexgQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BF1jXNcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BF1jXNcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F074C2BCB4;
	Mon, 20 Apr 2026 13:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692017;
	bh=jvmYOPkTLZLZlS7JN2M40phX4qLm75L0szk72vSc99M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BF1jXNcXTvRhRjRSgpMLEN0GIQcMaLwE77WkWUfOfFwrwAxEWfVUTnVbjZY1RR7t+
	 AfVAEuy3KgZjScaMLVxnfKBhEKg7oneR/kw+dRH1ZKFeLRQb7CwwIA356Hk3tgKHJe
	 sXm0rvTNRQ/lqIRcW8XEvq6J1bQqfSWlDCvwbzrk1NezuLbL4BrM4Q8MCIzjhzLFIR
	 QZRKL/peXnWY8bXMJXESIOTu7tApCBM4iRcdrpH1GbEWlzOHTRe0OhFROjYhBLqQM2
	 vOVUkOc2Q4ySKrDumNSHYxDcpaKqnior/zCcO2l+Jxy6jOhc53OAFaYcjZ1k5qe3Df
	 HbBqZX5LFIc3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] dm vdo indexer: validate saved zone count
Date: Mon, 20 Apr 2026 09:21:58 -0400
Message-ID: <20260420132314.1023554-324-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Matthew Sakai <msakai@redhat.com>

[ Upstream commit 9e809bb1defe9be7fed2e21552c6b03b2694394d ]

Verify that the loaded zone count is in the valid range
before using it as a loop iterator.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile everything.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** `dm vdo indexer` (device mapper, VDO deduplication
  index)
- **Action verb:** "validate" - implies adding a missing safety check
- **Summary:** Validates the zone count loaded from disk before using it
  as a loop iterator

**Record:** [dm vdo indexer] [validate] [Add bounds check on zone count
read from disk before loop use]

### Step 1.2: Tags
- `Signed-off-by: Matthew Sakai <msakai@redhat.com>` - the dm-vdo
  subsystem author/maintainer
- `Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>` - the dm
  subsystem maintainer who committed it

No Fixes: tag, no Reported-by, no Cc: stable. The absence of these is
expected for commits under manual review.

**Record:** Author is the dm-vdo subsystem maintainer. Committed through
the dm maintainer. No explicit bug reporter.

### Step 1.3: Commit Body
The message says: "Verify that the loaded zone count is in the valid
range before using it as a loop iterator." This clearly states:
- The zone count comes from loaded (on-disk) data
- It's used as a loop iterator
- Without validation, an invalid value would be used in the loop

**Record:** Bug = missing input validation on disk-loaded data used as
loop bound. Failure = out-of-bounds array access. Root cause = no bounds
check after reading from persistent storage.

### Step 1.4: Hidden Bug Fix Detection
This IS a bug fix despite using "validate" rather than "fix". It adds a
missing bounds check on data read from disk, preventing an out-of-bounds
array access. This is a classic data corruption / corrupted metadata
handling fix.

**Record:** Yes, this is a real bug fix - adding a missing bounds check
on untrusted data from disk.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Changes Inventory
- **File:** `drivers/md/dm-vdo/indexer/index-layout.c`
- **Lines added:** 3 (the `if` check + error return)
- **Function modified:** `reconstruct_index_save()`
- **Scope:** Single-file, single-function, 3-line surgical fix

**Record:** 1 file, +3 lines, extremely small and contained.

### Step 2.2: Code Flow Change
**Before:** Line 1447 computes `isl->zone_count =
table->header.region_count - 3` from disk data, then immediately uses
`zone_count` as the loop bound at line 1476: `for (z = 0; z <
isl->zone_count; z++)`, indexing into `volume_index_zones[z]`.

**After:** After computing `zone_count`, the code checks `if
(isl->zone_count > MAX_ZONES)` and returns `UDS_CORRUPT_DATA` error if
invalid.

### Step 2.3: Bug Mechanism
This is a **buffer overflow / out-of-bounds write** fix:

- `region_count` is a `u16` (0-65535) read from disk via
  `decode_u16_le()` at line 1129
- `zone_count = region_count - 3` (line 1447) - stored in `unsigned int`
- If `region_count > MAX_ZONES + 3 = 19`, then `zone_count > 16`, and
  the loop writes past the end of `volume_index_zones[MAX_ZONES]` (a
  fixed-size array of 16 entries at line 162)
- If `region_count < 3`, the subtraction wraps to a very large unsigned
  value, causing massive OOB access
- There's NO other validation of `region_count` vs `MAX_ZONES` in the
  load path

**Record:** [Out-of-bounds array access] [zone_count from disk used
without bounds check as index into fixed-size MAX_ZONES=16 array]

### Step 2.4: Fix Quality
- The fix is **obviously correct**: it checks `zone_count > MAX_ZONES`
  before the array is accessed
- It's **minimal**: exactly 3 lines
- It returns a proper error code (`UDS_CORRUPT_DATA`) with a log message
- **Zero regression risk**: it only rejects previously-invalid data that
  would have caused corruption

**Record:** Fix is obviously correct, minimal, zero regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code was introduced in commit `b46d79bdb82aa1` ("dm vdo: add
deduplication index storage interface"), authored by Matthew Sakai on
2023-11-16. This commit first appeared in v6.9-rc1. The buggy code has
been present since the initial introduction of dm-vdo.

**Record:** Bug introduced in b46d79bdb82aa1 (v6.9-rc1). Present in all
kernels since v6.9.

### Step 3.2: Fixes Tag
No Fixes: tag present. The implicit target would be b46d79bdb82aa1.

### Step 3.3: File History
Recent changes to this file are minimal:
- `f4e99b846c901` - string warning fix (cosmetic)
- `b0e6210e7e616` - removed unused function
- `41c58a36e2c04` - use-after-free fix (similar safety concern)

There's also `9ddf6d3fcbe0b` ("dm vdo: return error on corrupted
metadata in start_restoring_volume functions") - a very similar pattern:
adding proper error returns on corrupted metadata in the same subsystem,
with a Fixes: tag.

**Record:** Standalone fix, no prerequisites. Similar metadata
validation fixes have been applied to dm-vdo.

### Step 3.4: Author
Matthew Sakai is the original author and maintainer of dm-vdo. He
authored the initial dm-vdo code (40-patch series) and continues
maintaining it. This fix comes from the subsystem maintainer.

**Record:** Author is the subsystem maintainer - highest trust level.

### Step 3.5: Dependencies
None. This is a self-contained 3-line addition that doesn't depend on
any other commits.

**Record:** No dependencies. Fully standalone.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.2: Patch Discussion
I was unable to find the exact mailing list submission via b4 dig (the
commit isn't in the tree yet, so there's no SHA to search). Web searches
didn't return the specific patch thread. However, the commit was signed
off by both the subsystem maintainer (Sakai) and the dm maintainer
(Patocka), indicating it went through the standard dm review process.

**Record:** Could not locate specific lore thread. Verified through
standard dm maintainer chain.

### Step 4.3: Bug Report
No Reported-by tag. This appears to be a proactive fix found through
code review by the maintainer.

**Record:** Proactive fix by maintainer, not triggered by user report.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Call Chain
The full call chain from user-facing API to the vulnerable function:
1. `uds_make_index_layout()` - public API for creating/loading VDO index
2. `load_index_layout()` - loads existing index from disk
3. `load_sub_index_regions()` - loads saved index regions
4. `load_index_save()` - loads individual index save
5. `load_region_table()` - reads region table from disk (reads
   `region_count` as u16)
6. **`reconstruct_index_save()`** - uses `region_count` without
   validation -> OOB

This is called during VDO volume activation/load, which happens when a
dm-vdo target is activated (e.g., mounting a VDO-backed filesystem or
activating a VDO logical volume). The data comes from on-disk metadata.

**Record:** Reachable from VDO volume activation. Triggered by corrupted
on-disk metadata.

### Step 5.5: Similar Patterns
The similar fix `9ddf6d3fcbe0b` validates corrupted metadata in
`start_restoring_volume` functions, showing this is a known pattern in
dm-vdo where disk metadata isn't sufficiently validated.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
dm-vdo was introduced in v6.9-rc1. Active stable trees that contain this
code:
- **v6.12.y** (LTS) - YES, contains dm-vdo
- **v6.14.y** (stable) - YES
- **v6.19.y** (stable) - YES
- v6.6.y (LTS) - NO (pre-dates dm-vdo)
- v6.1.y (LTS) - NO

**Record:** Bug exists in v6.12.y, v6.14.y, v6.19.y stable trees.

### Step 6.2: Backport Complications
Changes to the file between v6.12 and HEAD are minimal (MAGIC_SIZE
cleanup and function removal) - none affect the
`reconstruct_index_save()` function area. The patch should apply cleanly
to all stable trees with dm-vdo.

**Record:** Clean apply expected on all relevant stable trees.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
- **Subsystem:** `drivers/md/dm-vdo` - Device Mapper VDO (deduplication
  + compression)
- **Criticality:** IMPORTANT - VDO is used for storage deduplication in
  RHEL/enterprise environments. Data integrity is paramount for storage
  subsystems.

### Step 7.2: Activity
dm-vdo sees regular maintenance commits from its author. It's an
actively maintained storage driver.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
Users of dm-vdo (VDO deduplication). This includes RHEL and enterprise
Linux users who use VDO for storage optimization.

### Step 8.2: Trigger Conditions
- **Trigger:** Corrupted on-disk VDO metadata where `region_count` is
  out of expected range
- **How likely:** Corruption can occur from disk errors, power failures,
  or malicious manipulation
- **User triggering:** Any user activating a VDO volume with corrupted
  metadata

### Step 8.3: Failure Mode Severity
Without this fix, corrupted metadata causes an **out-of-bounds array
write** on a stack-based or structure-embedded array
(`volume_index_zones[MAX_ZONES]`). This results in:
- **Stack/heap corruption** - writing past the array bounds
- **Kernel crash/panic** - likely from corrupted data structures
- **Potential privilege escalation** - corrupted kernel data structures
  from controlled input

**Severity: CRITICAL** - out-of-bounds write from disk-loaded data,
potential kernel crash or memory corruption.

### Step 8.4: Risk-Benefit Ratio
- **Benefit:** HIGH - prevents kernel crash/corruption from malformed
  on-disk metadata
- **Risk:** VERY LOW - 3-line check that only rejects invalid data; zero
  chance of regression for valid data
- **Ratio:** Extremely favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes an out-of-bounds array access from unvalidated disk-read data
  (security-relevant)
- Only 3 lines added - minimal surgical fix
- Obviously correct - simple bounds check against well-defined constant
- Zero regression risk - only rejects data that would have caused OOB
  access
- Written by subsystem maintainer, committed through dm maintainer
- Bug exists since dm-vdo introduction (v6.9), affects all stable trees
  with dm-vdo
- Clean apply expected
- Similar fix pattern already accepted for dm-vdo (`9ddf6d3fcbe0b`)

**AGAINST backporting:**
- No explicit user report or syzbot trigger (proactive fix)
- Requires corrupted on-disk metadata to trigger (not everyday scenario)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - trivial bounds check,
   maintainer-authored
2. Fixes a real bug? **YES** - OOB array access from unvalidated disk
   data
3. Important issue? **YES** - kernel memory corruption/crash from
   corrupted storage metadata
4. Small and contained? **YES** - 3 lines in one function
5. No new features? **YES** - pure safety check
6. Can apply to stable? **YES** - clean apply expected

### Step 9.3: Exception Categories
Not needed - this qualifies as a straightforward bug fix.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from subsystem maintainer (Sakai)
  and dm maintainer (Patocka)
- [Phase 2] Diff analysis: 3 lines added in `reconstruct_index_save()`,
  adds `zone_count > MAX_ZONES` bounds check
- [Phase 2] Confirmed `volume_index_zones[MAX_ZONES]` at line 162,
  MAX_ZONES=16 at config.h:23
- [Phase 2] Confirmed `region_count` is u16 read from disk at line 1129,
  used unvalidated at line 1447
- [Phase 3] git blame: all code in `reconstruct_index_save` from commit
  b46d79bdb82aa1 (v6.9-rc1)
- [Phase 3] git describe: b46d79bdb82aa1 first appears at
  v6.9-rc1~148^2~132
- [Phase 3] Similar fix 9ddf6d3fcbe0b validates corrupted metadata in
  same subsystem, has Fixes: tag
- [Phase 4] Could not locate specific lore thread (commit not yet
  merged, no SHA for b4 dig)
- [Phase 5] Call chain traced: uds_make_index_layout ->
  load_index_layout -> load_sub_index_regions -> load_index_save ->
  reconstruct_index_save
- [Phase 5] Trigger: VDO volume activation with corrupted on-disk
  metadata
- [Phase 6] File exists in v6.12.y, v6.14.y, v6.19.y; confirmed via git
  log
- [Phase 6] Changes since v6.12 don't affect the patched function area -
  clean apply expected
- [Phase 7] Subsystem: dm-vdo, actively maintained, IMPORTANT
  criticality (enterprise storage)
- [Phase 8] Failure mode: OOB array write -> kernel memory
  corruption/crash, severity CRITICAL

This is a textbook stable-worthy fix: a tiny, obviously correct bounds
check that prevents an out-of-bounds array access from corrupted on-disk
metadata in an enterprise storage driver. The fix has zero regression
risk and addresses a potentially security-relevant memory corruption
bug.

**YES**

 drivers/md/dm-vdo/indexer/index-layout.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 61edf2b72427d..37144249f7ba6 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -1445,6 +1445,9 @@ static int __must_check reconstruct_index_save(struct index_save_layout *isl,
 	u64 last_block = next_block + isl->index_save.block_count;
 
 	isl->zone_count = table->header.region_count - 3;
+	if (isl->zone_count > MAX_ZONES)
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
+					      "invalid zone count");
 
 	last_region = &table->regions[table->header.region_count - 1];
 	if (last_region->kind == RL_KIND_EMPTY) {
-- 
2.53.0

