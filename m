Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74EB3A7F4A;
	Mon, 20 Apr 2026 13:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690970; cv=none; b=oqS4F0G7OqIS42KF8Dgzbk196DqQCJ+Jm2x8iGXcxeTdiPgR//Sz1/8mgwx0O0zl5zoXUSfL84BO31b78xPnnWSeAnmvMPa33jH2McimbLdCIs9Xde1qq6IiEkcRgwfBKII9wctA5g2UJIS2EtKBH46slVourwwDcYFMQUBfq7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690970; c=relaxed/simple;
	bh=CqB6f6BO16HoJiFomyWK/H5P8xJm22jbSv1gMmamNKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OYOWGKiYsEG/9fdu4wVL8lVJtpRlJ1lyL6R2Krm6kYNVZ/fB3oqhfsWVn6Jcmq+8jwDqtpD0SWzPpWED39FpG68QbVvSzGAWdzTwik1kae21PU6b5+EAjNL2X6Wmnez9/Qxe4MGWTO71G3ZRYISfwxN9Iw4bA1xn3pLbHohOfUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afzSjnvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afzSjnvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30D0C2BCB9;
	Mon, 20 Apr 2026 13:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690970;
	bh=CqB6f6BO16HoJiFomyWK/H5P8xJm22jbSv1gMmamNKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afzSjnvq1dymL/v99vHOiR6g7dpv2J6RmCdovaj41xSDnGjZP8LBVTJ7dZ5gdqFV4
	 CGqSa1HtrbkVLDJpzlKdHxMA1IUBfB+bxRdXZTB6ObMi4as1AT0A0LvYH8MiNBglZS
	 0SY8afRGmZlm+pTZI1EVnVmYhSikJkx9S32LFGMGKg+uqw8D0DF6QNbK+fHmQ0qPlX
	 HYVbv+KvXH6FWLrDxpsAt1HrESAgsA1pJO6OBvu/x/ozpMct1lhSnScC0GnR9BRrqJ
	 5AKyMDEO3TkUeMp19rPCPvt7kjNaPuNC0kJJuLnRZ9C2iOroIbmiGjODS+u4tQNreF
	 4tGr6lnDFEIVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] dm vdo slab-depot: validate old zone count on load
Date: Mon, 20 Apr 2026 09:08:04 -0400
Message-ID: <20260420131539.986432-18-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Matthew Sakai <msakai@redhat.com>

[ Upstream commit b3929b2cc2a6003b8e301e6540c651e60d24dcb4 ]

Verify the old zone count has a valid value before using
it to compute slab summary entry offsets.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a thorough understanding. Let me compile my final analysis.

---

## Complete Analysis: dm vdo slab-depot: validate old zone count on load

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `dm vdo slab-depot` (device-mapper VDO subsystem, slab
  depot component)
- Action verb: "validate" — implies adding a missing safety check,
  strongly suggests bug fix
- Summary: Validates the `old_zone_count` field read from on-disk
  metadata before using it as an array index.
- Record: [dm vdo slab-depot] [validate] [add bounds check on old zone
  count loaded from disk]

**Step 1.2: Tags**
- `Signed-off-by: Matthew Sakai <msakai@redhat.com>` — author, VDO
  subsystem maintainer
- `Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>` — DM subsystem
  maintainer
- No Fixes: tag, no Reported-by, no Link: tags
- Record: Patch authored by VDO maintainer, signed off by DM maintainer.
  No external bug report; likely found via code audit.

**Step 1.3: Commit Body**
- "Verify the old zone count has a valid value before using it to
  compute slab summary entry offsets."
- This directly describes a missing input validation on data loaded from
  disk. The "old zone count" is deserialized from the VDO super block
  and used to compute array offsets without bounds checking.
- Record: Bug = missing validation of on-disk value used as array index;
  Symptom = potential OOB memory access; Root cause = zone_count from
  disk not validated against MAX_VDO_PHYSICAL_ZONES.

**Step 1.4: Hidden Bug Fix Detection**
- This IS a bug fix. "Validate" = adding a missing safety check. The
  code was using an untrusted on-disk value to compute memory offsets.
- Record: Yes, this is a validation bug fix preventing out-of-bounds
  access.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files: `drivers/md/dm-vdo/slab-depot.c` (+3 lines)
- Function modified: `vdo_decode_slab_depot()`
- Scope: Single-file, surgical 3-line addition
- Record: 1 file, +3 lines, single function, surgical fix.

**Step 2.2: Code Flow Change**
- BEFORE: `state.zone_count` from on-disk metadata was stored as
  `depot->old_zone_count` without any bounds validation. The decode
  function (`decode_slab_depot_state_2_0` in `encodings.c`) reads
  `zone_count` as a raw byte (`buffer[(*offset)++]`) and stores it
  without validation.
- AFTER: `state.zone_count` is checked against `MAX_VDO_PHYSICAL_ZONES`
  (16). If it exceeds 16, `UDS_CORRUPT_DATA` error is returned before
  any allocation.
- The check is placed BEFORE the allocation of the depot structure, so
  no memory leak on this error path.
- Record: Before = raw on-disk byte used unchecked; After = validated
  against maximum before use.

**Step 2.3: Bug Mechanism**
This is an **out-of-bounds memory access** bug:

1. `zone_count` is a `zone_count_t` (u8), so it can be 0-255.
2. `MAX_VDO_PHYSICAL_ZONES` = 16.
3. In `combine_summaries()` (line 4575-4588), `depot->old_zone_count` is
   used to cycle through zones: `entries + (zone * MAX_VDO_SLABS) +
   entry_number`, where `zone` ranges from 0 to `old_zone_count - 1`.
4. The `summary_entries` buffer is allocated with
   `MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES` = `MAX_VDO_SLABS *
   MAX_VDO_PHYSICAL_ZONES` = 8192 * 16 = 131,072 entries.
5. If `old_zone_count` = 17, the maximum offset becomes 16 * 8192 + 8191
   = 139,263, which exceeds the buffer size of 131,072. With
   `old_zone_count` = 255, the max offset is 2,088,959 — massively out
   of bounds.
6. This causes an OOB read (data copied from beyond the buffer boundary)
   and potentially corruption, since `combine_summaries` uses `memcpy`
   both for reading and writing.

Record: [OOB memory access] [corrupt on-disk zone_count > 16 causes
access beyond allocated summary_entries buffer in combine_summaries()]

**Step 2.4: Fix Quality**
- Obviously correct: a simple bounds check against a well-defined
  constant.
- Minimal/surgical: 3 lines, inserted in the right place (before
  allocation and use).
- No regression risk: this only rejects corrupt/invalid data early.
- Placed before allocation, so no resource leak on this new error path.
- Record: Fix is obviously correct, minimal, zero regression risk.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The buggy code (using `state.zone_count` without validation) was
  introduced by `7ce49449ffb940` ("dm vdo: add the slab depot") by
  Matthew Sakai on 2023-11-16.
- This is contained in v6.9-rc1, so it has been present since kernel
  6.9.
- Record: Buggy code introduced in commit 7ce49449ffb940 (v6.9-rc1),
  present since kernel 6.9.

**Step 3.2: Fixes tag** — No Fixes: tag present (expected).

**Step 3.3: File History**
- The file has had moderate recent activity (kerneldoc fixes, refcount
  rework, ring reference removal). No related validation fixes found.
- Record: No prior fix for this issue. Standalone fix.

**Step 3.4: Author**
- Matthew Sakai is the VDO subsystem maintainer and author of the
  original VDO code. Mikulas Patocka is the DM subsystem maintainer who
  signed off.
- Record: Fix from subsystem maintainer, signed off by DM maintainer.
  High confidence.

**Step 3.5: Dependencies**
- This is entirely standalone. It adds a check using
  `MAX_VDO_PHYSICAL_ZONES` and `UDS_CORRUPT_DATA`, both of which already
  exist in all stable trees with dm-vdo.
- Record: No dependencies. Clean standalone fix.

### PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.5:** Could not find the original mailing list submission
through web search or b4 dig (the commit may be very recent or submitted
through a different channel). The DM tree often takes patches directly.
Both the VDO and DM maintainer signed off, indicating proper review.
- Record: Mailing list thread not found (may be recent/not yet indexed).
  Maintainer sign-offs provide review confidence.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
- Modified: `vdo_decode_slab_depot()` — the main decoder for VDO slab
  depot on-disk state.

**Step 5.2: Callers**
- `vdo_decode_slab_depot()` is called from `dm-vdo-target.c:1360` during
  VDO volume load/activation. This is triggered when a VDO device is
  started (e.g., `dmsetup create`).
- Record: Called during device activation — any VDO user hits this code
  path.

**Step 5.3-5.4: Impact Path**
- `vdo_decode_slab_depot()` → stores `old_zone_count` →
  `combine_summaries()` uses it to compute offsets into
  `summary_entries` array → OOB access if value > 16.
- The bug is triggered whenever VDO loads a volume with corrupt metadata
  (malicious disk image, bit rot, filesystem corruption).

**Step 5.5: Similar Patterns**
- The `dm-vdo-target.c` already validates `physical_zone_count` at line
  421 (`if (count > MAX_VDO_PHYSICAL_ZONES)`), but the on-disk
  deserialization path in `decode_slab_depot_state_2_0` does NOT
  validate `zone_count`. This is an inconsistency that this fix
  addresses.
- Record: New zone_count validated in dm-vdo-target.c; old zone_count
  from disk was NOT validated. Asymmetric validation = bug.

### PHASE 6: CROSS-REFERENCING

**Step 6.1: Stable Tree Presence**
- dm-vdo was introduced in v6.9-rc1. File does NOT exist in v6.8 or
  earlier.
- Exists in stable trees: 6.12.y, and any other active stable tree >=
  6.9.
- Record: Bug exists in all kernels >= 6.9 (6.12.y stable tree).

**Step 6.2: Backport Complications**
- The v6.9 code is identical to current mainline for this function
  (verified). Patch should apply cleanly.
- Record: Clean apply expected.

**Step 6.3: Related Fixes**
- No related fix found in stable.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** dm-vdo (device-mapper Virtual Data Optimizer) is a data
deduplication and compression layer. Classification: IMPORTANT — used in
production storage (Red Hat VDO in RHEL).
- Record: Subsystem: DM/VDO, Criticality: IMPORTANT (production
  storage).

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected** — All VDO users loading VDO volumes (dm-
vdo is used in RHEL/Fedora storage stacks).

**Step 8.2: Trigger** — Loading a VDO volume with corrupt on-disk
metadata where zone_count > 16. This can happen from:
- Disk corruption / bit rot
- Malicious crafted disk images
- Record: Triggered on VDO volume load with corrupt metadata.

**Step 8.3: Severity** — OOB memory access → can cause:
- Kernel crash/oops (most likely outcome)
- Memory corruption
- Potential information leak
- Severity: **HIGH** (OOB access from untrusted on-disk data)

**Step 8.4: Risk-Benefit**
- BENEFIT: Prevents OOB memory access from corrupt disk metadata.
  Protects all VDO users.
- RISK: 3 lines, obviously correct bounds check, zero regression risk.
- Record: Very high benefit, very low risk.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**

FOR backporting:
- Fixes out-of-bounds memory access from unvalidated on-disk data
- 3-line surgical fix, obviously correct
- Written by VDO maintainer, signed off by DM maintainer
- Affects all VDO users when loading corrupt volumes
- `zone_count_t` is u8 (0-255) but must be <= 16; no validation existed
- `combine_summaries()` computes `zone * MAX_VDO_SLABS` (up to 254 *
  8192) into a buffer of only 131,072 entries
- Similar validation already exists for new zone_count in dm-vdo-
  target.c
- Code exists in stable trees >= 6.9 (including 6.12.y)

AGAINST backporting:
- No explicit Reported-by or syzbot trigger (likely found by code audit)
- No CVE assigned (yet)
- Requires corrupt/malicious on-disk metadata to trigger

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — trivial bounds check
2. Fixes a real bug? **YES** — OOB access from untrusted input
3. Important issue? **YES** — OOB memory access =
   crash/corruption/security
4. Small and contained? **YES** — 3 lines, single file
5. No new features or APIs? **YES** — validation only
6. Can apply to stable? **YES** — code is identical in 6.9+

**Step 9.3: Exception Categories** — N/A (standard bug fix)

**Step 9.4: Decision**
This is a clear-cut missing input validation fix for on-disk data that
can cause out-of-bounds memory access. It's 3 lines, obviously correct,
from the subsystem maintainer, with zero regression risk.

### Verification

- [Phase 1] Parsed commit message: "validate old zone count" = bounds
  check on deserialized data
- [Phase 2] Diff analysis: 3 lines added to `vdo_decode_slab_depot()`,
  validates `state.zone_count <= MAX_VDO_PHYSICAL_ZONES`
- [Phase 2] Confirmed OOB: zone_count=17 → offset 139,263 > buffer
  131,072; zone_count=255 → offset 2,088,959
- [Phase 3] git blame: buggy code introduced in 7ce49449ffb940
  (v6.9-rc1, 2023-11-16)
- [Phase 3] git describe: 7ce49449ffb940 is `v6.9-rc1~148^2~114`
- [Phase 3] Confirmed no Fixes: tag (expected for AUTOSEL candidate)
- [Phase 3] Confirmed standalone fix, no dependencies
- [Phase 4] b4 dig: could not find mailing list thread (UNVERIFIED:
  thread may be too recent)
- [Phase 5] `vdo_decode_slab_depot()` called from `dm-vdo-target.c:1360`
  during VDO volume activation
- [Phase 5] `combine_summaries()` at line 4575-4588 uses
  `old_zone_count` to compute offsets into `summary_entries`
- [Phase 5] `decode_slab_depot_state_2_0()` at line 631 reads
  `zone_count` as raw byte with no validation
- [Phase 5] Confirmed asymmetric validation: new zone_count validated at
  dm-vdo-target.c:421, but not old zone_count from disk
- [Phase 6] File exists in v6.9+ (confirmed `v6.9:drivers/md/dm-
  vdo/slab-depot.c` exists, `v6.8` does not)
- [Phase 6] v6.9 version of `vdo_decode_slab_depot()` is identical —
  clean apply expected
- [Phase 8] Failure mode: OOB memory read/write in `combine_summaries()`
  → crash or corruption, severity HIGH
- UNVERIFIED: Could not locate mailing list discussion; relying on
  maintainer SOBs for review confidence

**YES**

 drivers/md/dm-vdo/slab-depot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 034ecaa51f481..ad00afc2c168d 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -4262,6 +4262,10 @@ int vdo_decode_slab_depot(struct slab_depot_state_2_0 state, struct vdo *vdo,
 	}
 	slab_size_shift = ilog2(slab_size);
 
+	if (state.zone_count > MAX_VDO_PHYSICAL_ZONES)
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
+					      "invalid zone count");
+
 	result = vdo_allocate_extended(struct slab_depot,
 				       vdo->thread_config.physical_zone_count,
 				       struct block_allocator, __func__, &depot);
-- 
2.53.0

