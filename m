Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6D472794;
	Mon, 20 Apr 2026 13:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691840; cv=none; b=lhRJ9TioFBt570ouJNWTEkDByVEjS0tj74MaEyMPJ88o8hcoErMHrYiYBM10QNpAdPsmfWOnZHpkN+wAJNi68hZ8KiXI+7QoRw+TyMHqKq3WTuPDEwHXtc2rWZf/hYQ3tQK7jXYaKLO0IYnHcM0wynw32+1iyC9s3xSJYyqbIVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691840; c=relaxed/simple;
	bh=R7c8B7eWelbtycKZCd6RLTn/tu87WwxKPZdcFdNv4lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLsQTRH8lFK7uL5rZRT+HOoDEBo9Q3Ab5cv0y2pn1bdljUD/NhuAEmKhQkGBB8qOUOjdxo9XKSU3n0eiIa9jlYt85pGp104LV3aIj4Y+xJhSV0XK+K1cskqhdTd5Ubiwdg1taHnpgSGIhbLhQpKi/gqng0dV0euEvZOz5kvENHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTLt7tTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTLt7tTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B2AC2BCB4;
	Mon, 20 Apr 2026 13:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691839;
	bh=R7c8B7eWelbtycKZCd6RLTn/tu87WwxKPZdcFdNv4lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTLt7tTPwzXK9tyE+5vl8VW6pHkV0FzJmUzxEGLwjaWjerxL6K7ONEFC3awydYJl+
	 clPWvu+SbhNu3UusajxCepignTCvyp0+r5YvjnrlLDZXTOK68feFF/gcLGWuDyqzva
	 SqT8lNtIU5EV+923il3wH3Jn3IrrnnrtRGbKXwjvoMElt7i3MwCAGU7LD9uPlgHjG2
	 2T4JrHWG05vdj+rBwfLk6pc3c3THNreIoOY++xTZ4G3tZgChbWjGA4ZdUoIZ9bRRyF
	 eRElimnyq3cYwVZCTZY/gAqfEAjfjzVg9qkz2Q4rGPfemSOV2gVzkKN4WktkbzPJF0
	 yOvV2fFWCO49A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] dm-integrity: fix mismatched queue limits
Date: Mon, 20 Apr 2026 09:20:19 -0400
Message-ID: <20260420132314.1023554-225-sashal@kernel.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 6ebf3b6c6f16fda0568aa4207c6cd398f983c354 ]

A user can integritysetup a device with a backing device using a 4k
logical block size, but request the dm device use 1k or 2k. This
mismatch creates an inconsistency such that the dm device would report
limits for IO that it can't actually execute. Fix this by using the
backing device's limits if they are larger.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `dm-integrity` (device mapper integrity target)
- **Action verb**: "fix"
- **Summary**: Fixes mismatched queue limits between DM integrity device
  and backing device

### Step 1.2: Tags
- `Signed-off-by: Keith Busch <kbusch@kernel.org>` - the author
- `Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>` - the DM
  integrity maintainer committed it
- No Fixes: tag, no Reported-by:, no Cc: stable (expected for manual
  review candidates)

### Step 1.3: Commit Body
The commit clearly describes the bug: a user can create an integrity
device (via `integritysetup`) on a 4k logical block size backing device
but request 1k or 2k for the DM device. The DM device then reports queue
limits it can't actually satisfy because they're below the backing
device's capabilities. This is an IO correctness bug - the device
advertises capabilities it doesn't have.

### Step 1.4: Hidden Bug Fix
No - this is an explicit "fix" with clear description. The word "fix" is
in the subject.

Record: Real bug fix. Queue limit mismatch causes IO that the backing
device cannot execute.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files**: `drivers/md/dm-integrity.c` only (+9, -3 lines)
- **Function**: `dm_integrity_io_hints()` - the io_hints callback
- **Scope**: Single-file, single-function surgical fix

### Step 2.2: Code Flow Change
Before: Unconditionally sets `logical_block_size`,
`physical_block_size`, and `io_min` to `ic->sectors_per_block <<
SECTOR_SHIFT`.

After: Uses `max()` to ensure these values are never LOWER than the
existing limits (which come from the backing device).

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix**. The old code overwrites the backing
device's queue limits with potentially smaller values, creating an
inconsistency where the DM device reports it accepts smaller IO than the
backing device can handle.

### Step 2.4: Fix Quality
- Obviously correct: `max()` ensures the larger of the two values is
  used
- Minimal and surgical
- Uses the exact same pattern that `dm-crypt` already uses (verified:
  `max_t(unsigned int, limits->logical_block_size, cc->sector_size)`)
- No regression risk: the fix only ever keeps limits the same or makes
  them larger, never smaller

Record: High quality fix. Pattern already proven in dm-crypt.

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The buggy code was introduced in commit `9d609f85b7eb96` ("dm integrity:
support larger block sizes") by Mikulas Patocka, which first appeared at
`v4.12-rc1~120^2~28` - so approximately **kernel v4.12 (2017)**. The bug
has existed for ~9 years and affects all stable trees.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected for manual review).

### Step 3.3: File History
The dm-integrity.c file is actively developed with many recent changes.
The io_hints function itself has had additions (`dma_alignment` in v6.1
era, `discard_granularity` and `io_min` changes in v6.11) but the core
bug (unconditional assignment) has been present since introduction.

### Step 3.4: Author
Keith Busch (`kbusch@kernel.org`) is a well-known kernel developer and
NVMe/block layer expert at Meta. Not the dm-integrity maintainer but
very knowledgeable about block layer queue limits. The patch was
accepted by Mikulas Patocka, the dm-integrity maintainer.

### Step 3.5: Dependencies
This is patch 1/3 of a series. Patch 2 ("dm-integrity: always set the io
hints") removes the `if (sectors_per_block > 1)` guard. Patch 3 ("dm:
provide helper to set stacked limits") creates a common helper. **This
patch (1/3) is fully self-contained** - it fixes the core bug
independently. Patches 2 and 3 are enhancements/refactoring.

Record: Self-contained fix. Bug since v4.12. Accepted by maintainer.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Discussion
Found via `b4 dig`: [PATCH 1/3] at
`https://patch.msgid.link/20260325193608.2827042-1-kbusch@meta.com`

Key findings from the mbox:
- **Mikulas Patocka** (maintainer): "I accepted all three patches."
- **Benjamin Marzinski** (Red Hat DM developer): Provided concrete
  reproduction demonstrating the bug causes real IO failures:

```
INVALID:
# modprobe scsi_debug dev_size_mb=1024 lbpu=1 sector_size=4096
# integritysetup format -s 1024 /dev/sda
# integritysetup open --allow-discards /dev/sda integrity-test
# cat /sys/block/sda/queue/discard_granularity
2048
# cat /sys/block/dm-1/queue/discard_granularity
1024
# blkdiscard -o 1024 -l 16384 /dev/mapper/integrity-test
blkdiscard: BLKDISCARD: /dev/mapper/integrity-test ioctl failed:
Input/output error
```

### Step 4.2: Reviewers
Sent to dm-devel@lists.linux.dev, mpatocka@redhat.com (maintainer),
snitzer@kernel.org (DM maintainer). Appropriate subsystem maintainers
were included.

### Step 4.3-4.5: No explicit stable nomination in discussion, but no
objections either.

Record: Concrete reproduction of IO failures. Maintainer accepted
immediately.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `dm_integrity_io_hints()` modified.

### Step 5.2: Callers
Called via the `.io_hints` callback in `struct target_type
integrity_target`. This is invoked by the DM core when setting up queue
limits for the DM device - affects every dm-integrity device setup.

### Step 5.3-5.5: Impact Surface
Every dm-integrity device created via `integritysetup` (or similar) with
a block size smaller than the backing device's logical block size is
affected. This is a common user-facing operation in LUKS/dm-integrity
setups.

Record: Affects every dm-integrity device with mismatched block sizes.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence
The buggy code exists in ALL stable trees (since v4.12). Verified:
- v5.15: Same bug, uses `blk_limits_io_min()` instead of direct
  assignment
- v6.1: Same bug, same code as v5.15
- v6.6: Same bug, same code plus `dma_alignment`
- v6.12+: Same bug, uses direct `limits->io_min =` (matches the fix
  exactly)

### Step 6.2: Backport Complications
- **v6.12+**: Applies cleanly (code matches exactly)
- **v6.6 and earlier**: Minor conflict - uses `blk_limits_io_min()`
  instead of direct `limits->io_min =`. The `logical_block_size` and
  `physical_block_size` lines are identical in all versions. Only the
  io_min line needs trivial adaptation.

### Step 6.3: No related fixes already in stable for this issue.

Record: Bug present in all stable trees. Clean apply for v6.12+, trivial
adaptation for older.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- `drivers/md/dm-integrity.c` - Device Mapper integrity target
- **Criticality**: IMPORTANT - dm-integrity is used in LUKS setups,
  enterprise storage, and data integrity verification. It's a core
  component of the device mapper framework.

### Step 7.2: Activity
Actively developed - 20+ commits since v6.6, including several bug
fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users of dm-integrity devices where the integrity block size is smaller
than the backing device's logical block size. Common scenario: 4k
native-sector drives with 1k/2k integrity block sizes.

### Step 8.2: Trigger Conditions
Any IO operation (including discard) on a dm-integrity device with
mismatched block sizes. The mismatch is user-creatable via
`integritysetup`. Not timing-dependent.

### Step 8.3: Failure Mode
**IO errors** - the device accepts IO that the backing device cannot
execute. Demonstrated: `blkdiscard` fails with `Input/output error`.
Severity: **HIGH** - IO failures can cause data loss, filesystem errors,
application failures.

### Step 8.4: Risk-Benefit
- **Benefit**: HIGH - prevents IO errors on dm-integrity devices with
  common hardware configurations
- **Risk**: VERY LOW - 9 lines changed, uses `max()` pattern already
  proven in dm-crypt, only ever makes limits larger (never smaller),
  obviously correct
- **Ratio**: Strongly favorable for backporting

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes real IO errors (demonstrated with concrete reproduction)
- Small, surgical fix (9 added, 3 removed, single function)
- Uses proven `max()` pattern from dm-crypt
- Bug present since v4.12 (all stable trees affected)
- Accepted by subsystem maintainer (Mikulas Patocka)
- Self-contained (no dependencies on patches 2/3)
- Reviewed by Red Hat DM developer who provided testing

**AGAINST backporting:**
- Minor adaptation needed for v6.6 and earlier (blk_limits_io_min vs
  direct assignment)
- No explicit Cc: stable nomination (but this is expected)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - max() is trivially correct,
   maintainer accepted, Ben Marzinski tested
2. Fixes a real bug? **YES** - IO errors with concrete reproduction
3. Important issue? **YES** - IO errors leading to data access failures
4. Small and contained? **YES** - 12 lines net, single function
5. No new features? **YES** - pure bug fix
6. Can apply to stable? **YES** - cleanly for v6.12+, minor adaptation
   for older

### Step 9.3: Exception Categories
Not applicable - this is a standard bug fix, not an exception category.

### Step 9.4: Decision
Clear YES. This is a textbook stable backport candidate: small, obvious,
fixes a real user-facing bug (IO errors), long-standing (since v4.12),
accepted by the subsystem maintainer, and uses an already-proven
pattern.

---

## Verification

- [Phase 1] Parsed subject: "dm-integrity: fix mismatched queue limits"
  - explicit fix
- [Phase 1] Parsed tags: SOB from Keith Busch (author) and Mikulas
  Patocka (maintainer/committer)
- [Phase 2] Diff analysis: 3 assignments changed to max() in
  dm_integrity_io_hints(), +9/-3 lines
- [Phase 2] Verified dm-crypt uses identical max_t() pattern
  (drivers/md/dm-crypt.c line 3721)
- [Phase 3] git blame: buggy code introduced in 9d609f85b7eb96 (v4.12,
  2017)
- [Phase 3] git describe --contains: confirmed v4.12-rc1~120^2~28
- [Phase 3] Confirmed patch 1/3 is self-contained; patches 2-3 are
  enhancement/refactoring
- [Phase 4] b4 dig found:
  https://patch.msgid.link/20260325193608.2827042-1-kbusch@meta.com
- [Phase 4] b4 dig -a: single version (v1), no revisions needed
- [Phase 4] b4 dig -w: dm-devel, mpatocka, snitzer all included
- [Phase 4] Mbox review: Mikulas accepted ("I accepted all three
  patches"), Ben Marzinski provided IO error reproduction
- [Phase 5] dm_integrity_io_hints called via .io_hints callback for
  every dm-integrity device setup
- [Phase 6] Verified code exists in v5.15, v6.1, v6.6, v6.12 - all
  stable trees affected
- [Phase 6] v6.6 and earlier use blk_limits_io_min() - minor backport
  adaptation needed
- [Phase 6] v6.12+ uses direct limits->io_min assignment - clean apply
- [Phase 8] Failure mode: IO errors (EIO), demonstrated with blkdiscard,
  severity HIGH

**YES**

 drivers/md/dm-integrity.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 06e805902151c..8dfd498ed1ffd 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4047,9 +4047,15 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 	struct dm_integrity_c *ic = ti->private;
 
 	if (ic->sectors_per_block > 1) {
-		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
-		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
-		limits->io_min = ic->sectors_per_block << SECTOR_SHIFT;
+		limits->logical_block_size =
+				max(limits->logical_block_size,
+				    ic->sectors_per_block << SECTOR_SHIFT);
+		limits->physical_block_size =
+				max(limits->physical_block_size,
+				    ic->sectors_per_block << SECTOR_SHIFT);
+		limits->io_min =
+				max(limits->io_min,
+				    ic->sectors_per_block << SECTOR_SHIFT);
 		limits->dma_alignment = limits->logical_block_size - 1;
 		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
 	}
-- 
2.53.0

