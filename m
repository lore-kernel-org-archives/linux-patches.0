Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BC43B95FF;
	Mon, 20 Apr 2026 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691456; cv=none; b=UlaBpocP9WoigXPFgNmIQ2Xc0a8aSPaWPUeEWCX64Q9S3idUD3rC4sr5kuMMli6NAQgotYxyu29IoF8YKknyxlDhUa0KjO237j+5vvDcbTE1gHfp0iDRyOm8hZgtSMOzQkkoKkOqBJuBw3DEULFzmZ+wOiGeiTwDlZeLm3Tauh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691456; c=relaxed/simple;
	bh=YWc6kcq7ugUrsZMHY2DTz8cVHaSEtbEi5TDTbn1bu00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mFnpvANz6M6yOH2xXvYdKTqWEf6i+l1crxbKEYxFrbg80niL5RF0Em36r4bzIqxwWtYR/v16M5EwJNynMKjME26r+SgQjfzIGX/FXbqZYmIZsaE6fCry4k85i6d8KTAnZBeh+tLlWBmO61oJ8QpwkO55rmsoM/dKfAQJjgnra+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4jOwA5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4jOwA5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F473C2BCB6;
	Mon, 20 Apr 2026 13:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691456;
	bh=YWc6kcq7ugUrsZMHY2DTz8cVHaSEtbEi5TDTbn1bu00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4jOwA5AC2zL9DTY5D8sqhusgbxXLEjxy9zkjW/VV2zxftTm11YPQC2QzC1rpZfBe
	 XGWDsDFBXEMoaS69u7JgZ3U7DCyNoG7QH9LDd/M3/O2gj2O2YasZwoIIUx4j0IkYY3
	 2ECay66nSKGZ7lR5BHWJFQ2qN4Ros4e1o7s8e60i0MbIy/wf4ViwtcLuamzswPvB0V
	 wgA88yzi/zhgqPUrEyWnYGbsPgqeiHmBKA4lKPgUJ/qCOI7l4ii2PT8LKwhqK885r3
	 MGOsVl75d2ezx3ZtbMl6JAmos994QKS5IJgUOZerwEy0SyLAFkioz0aIyeC1ZW6dK7
	 pHgGOBPxt5Y3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Timber <dxdt@dev.snart.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sj1557.seo@samsung.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] exfat: fix s_maxbytes
Date: Mon, 20 Apr 2026 09:17:13 -0400
Message-ID: <20260420132314.1023554-39-sashal@kernel.org>
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

From: David Timber <dxdt@dev.snart.me>

[ Upstream commit 4129a3a2751cba8511cee5d13145223662a8e019 ]

With fallocate support, xfstest unit generic/213 fails with

   QA output created by 213
   We should get: fallocate: No space left on device
   Strangely, xfs_io sometimes says "Success" when something went wrong
  -fallocate: No space left on device
  +fallocate: File too large

because sb->s_maxbytes is set to the volume size.

To be in line with other non-extent-based filesystems, set to max volume
size possible with the cluster size of the volume.

Signed-off-by: David Timber <dxdt@dev.snart.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The context lines match exactly - the patch would apply cleanly to this
tree. Now let me compile my full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `exfat` (filesystem)
- **Action verb**: "fix" — explicit bug fix
- **Summary**: Corrects the `s_maxbytes` value set for exFAT superblock

### Step 1.2: Tags
- `Signed-off-by: David Timber <dxdt@dev.snart.me>` — author
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` — exFAT subsystem
  maintainer, who applied the patch
- No Fixes: tag, no Reported-by, no Cc: stable (expected for commits
  under review)
- No Link: tag

Record: Maintainer-signed patch, applied by exFAT maintainer Namjae
Jeon.

### Step 1.3: Commit Body
- Bug: `sb->s_maxbytes` is set to volume size, but should represent the
  maximum file size for the filesystem format
- Symptom: xfstest generic/213 fails returning `EFBIG` ("File too
  large") instead of `ENOSPC` ("No space left on device") when the
  filesystem is full
- Root cause: The VFS layer checks `s_maxbytes` in `vfs_fallocate()`
  (`fs/open.c:333`), `generic_write_check_limits()`, and
  `inode_newsize_ok()`. When `s_maxbytes = volume_data_size`, operations
  near the volume boundary get `EFBIG` from VFS instead of letting the
  filesystem return `ENOSPC`

### Step 1.4: Hidden Bug Fix Detection
This is an explicit fix, not hidden. The commit clearly states "fix
s_maxbytes".

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **fs/exfat/exfat_raw.h**: +1 line (adds `EXFAT_MAX_NUM_CLUSTER`
  constant)
- **fs/exfat/file.c**: +1 line (adds clarifying comment about integer
  overflow)
- **fs/exfat/super.c**: ~3 lines changed (replaces s_maxbytes
  calculation + comment)
- Total: ~5 lines of logic, ~5 lines of comments. Very small and
  surgical.

### Step 2.2: Code Flow Change
1. **exfat_raw.h**: Adds `EXFAT_MAX_NUM_CLUSTER (0xFFFFFFF5)` — the
   exFAT specification maximum cluster count
2. **super.c `exfat_read_boot_sector()`**:
   - Before: `sb->s_maxbytes = (u64)(sbi->num_clusters -
     EXFAT_RESERVED_CLUSTERS) << sbi->cluster_size_bits` — volume data
     size
   - After: `sb->s_maxbytes = min(MAX_LFS_FILESIZE,
     EXFAT_CLU_TO_B((loff_t)EXFAT_MAX_NUM_CLUSTER, sbi))` — format
     maximum clamped to VFS limit
3. **file.c `exfat_cont_expand()`**: Adds comment above
   `EXFAT_B_TO_CLU_ROUND_UP(size, sbi)` noting that `inode_newsize_ok()`
   already checked for integer overflow

### Step 2.3: Bug Mechanism
This is a **logic/correctness fix**: `s_maxbytes` was set to the wrong
value. The VFS uses `s_maxbytes` to represent the maximum file size the
filesystem FORMAT supports, not the volume capacity. Multiple VFS entry
points return `EFBIG` when operations exceed `s_maxbytes`:
- `vfs_fallocate()` at `fs/open.c:333`
- `generic_write_check_limits()` at `fs/read_write.c:1728`
- `inode_newsize_ok()` at `fs/attr.c:264`

Additionally, on 32-bit platforms, the old code did NOT clamp to
`MAX_LFS_FILESIZE`, which could set `s_maxbytes` beyond what the VFS can
handle.

### Step 2.4: Fix Quality
- **Obviously correct**: YES — `0xFFFFFFF5` is the exFAT spec maximum;
  `min(MAX_LFS_FILESIZE, ...)` follows the pattern used by other
  filesystems (JFS, NTFS3, etc.)
- **Minimal**: YES — 3 files, ~5 logic lines
- **Regression risk**: VERY LOW — changes only the superblock
  initialization value; on 64-bit, `s_maxbytes` becomes larger (more
  permissive), which is correct VFS behavior

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code was introduced in commit `719c1e182916` ("exfat: add
super block operations") by Namjae Jeon on 2020-03-02, when exfat was
first added to the kernel (v5.7). This means the bug has been present
since exfat's inception and affects ALL stable trees that include exfat.

### Step 3.2: Fixes Tag
No Fixes: tag present. The implicit target is `719c1e182916` (exfat
initial addition).

### Step 3.3: File History
Recent exfat super.c changes are mostly optimizations and unrelated
fixes. No conflicting changes to the `s_maxbytes` line.

### Step 3.4: Author
David Timber is a contributor to exfat. The patch was reviewed and
applied by Namjae Jeon, the exFAT subsystem maintainer.

### Step 3.5: Dependencies
The patch is **standalone** — it only uses existing macros
(`EXFAT_CLU_TO_B`, `MAX_LFS_FILESIZE`) and adds a new constant. It does
NOT depend on the fallocate support patch.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Patch Discussion
Found the related fallocate patch at `https://yhbt.net/lore/linux-
fsdevel/20260228084542.485615-1-dxdt@dev.snart.me/T/`. The s_maxbytes
fix was discovered during fallocate testing but is a separate,
standalone correction. Namjae Jeon applied the fallocate patch to the
exfat #dev branch on 2026-03-04.

### Step 4.2: Reviewers
Namjae Jeon (exFAT maintainer) signed off on the patch, indicating
review and approval.

### Step 4.3-4.5: Bug Report / Related Patches / Stable Discussion
The bug was discovered via xfstest generic/213 failure. No explicit
stable nomination found, which is expected for commits under review.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Functions and Call Chains
The key function is `exfat_read_boot_sector()` which sets `s_maxbytes`
during mount. The value is then used by:
- `inode_newsize_ok()` — called from `exfat_cont_expand()`
  (truncate/setattr path)
- `generic_write_check_limits()` — called from `generic_write_checks()`
  (write path)
- `vfs_fallocate()` — VFS fallocate entry (if fallocate is supported)

These are all common I/O paths that any exfat user would hit.

### Step 5.5: Similar Patterns
Other non-extent-based filesystems set `s_maxbytes` to the format
maximum:
- FAT: `sb->s_maxbytes = 0xffffffff` (4GB format limit)
- NTFS3: `sb->s_maxbytes = MAX_LFS_FILESIZE`
- JFS: `sb->s_maxbytes = min(((loff_t)sb->s_blocksize) << 40,
  MAX_LFS_FILESIZE)`

exFAT was the outlier using volume size instead of format maximum.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy code exists in ALL stable trees that include exfat (v5.7+).
The exfat `s_maxbytes` initialization has never been changed since the
initial commit in 2020.

### Step 6.2: Backport Complications
The patch context matches the current 7.0 tree exactly. Clean
application expected.

### Step 6.3: Related Fixes
No other fix for this specific issue exists in any stable tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: fs/exfat — filesystem driver
- **Criticality**: IMPORTANT — exFAT is widely used for USB drives, SD
  cards, and cross-platform storage

### Step 7.2: Activity
Active subsystem with regular maintenance by Namjae Jeon.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Affected Users
All exfat users who perform write/truncate operations on files near the
volume's data capacity boundary.

### Step 8.2: Trigger Conditions
- Volume nearly full, file operations that would exceed volume capacity
- On 32-bit platforms: any large exfat volume could have incorrect
  `s_maxbytes`
- Unprivileged users can trigger this via normal file operations

### Step 8.3: Failure Mode
- **Wrong error code** (EFBIG instead of ENOSPC) — MEDIUM severity
- **32-bit platform issue**: `s_maxbytes` not clamped to
  `MAX_LFS_FILESIZE` — potentially more serious, could cause VFS-level
  issues

### Step 8.4: Risk-Benefit
- **Benefit**: MEDIUM — corrects wrong errno for all exfat users, fixes
  32-bit clamping, aligns with VFS conventions
- **Risk**: VERY LOW — tiny change, only modifies initialization value,
  follows established pattern from other filesystems
- **Ratio**: Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Real correctness bug: wrong errno returned to userspace (EFBIG vs
  ENOSPC)
- Missing `MAX_LFS_FILESIZE` clamping on 32-bit platforms
- Bug present since exfat inception (v5.7, 2020)
- Very small fix: ~5 logic lines across 3 files
- Obviously correct: follows exFAT specification and VFS conventions
  used by all other filesystems
- Applied by subsystem maintainer Namjae Jeon
- Standalone: no dependencies on other patches
- Clean apply expected

**AGAINST backporting:**
- Severity is LOW-MEDIUM (wrong error code, not a
  crash/corruption/security issue)
- The xfstest failure mentioned requires fallocate support (not in
  current stable)
- But the underlying bug still affects writes and truncate paths

### Step 9.2: Stable Rules Checklist
1. Obviously correct? **YES** — follows spec, matches all other
   filesystems
2. Fixes real bug? **YES** — wrong errno, missing 32-bit clamping
3. Important issue? **MEDIUM** — wrong error code, potential 32-bit
   issues
4. Small and contained? **YES** — ~5 logic lines, 3 files
5. No new features? **CORRECT** — pure bug fix
6. Applies to stable? **YES** — clean context match

### Step 9.3: Exception Categories
None applicable — this is a straightforward bug fix.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author (David Timber) and
  maintainer (Namjae Jeon)
- [Phase 2] Diff analysis: 3 files, ~5 logic lines; adds
  EXFAT_MAX_NUM_CLUSTER constant, changes s_maxbytes calc, adds comment
- [Phase 2] Verified VFS uses of s_maxbytes: `fs/open.c:333`
  (vfs_fallocate), `fs/read_write.c:1714,1728`
  (generic_write_check_limits), `fs/attr.c:264` (inode_newsize_ok)
- [Phase 3] git blame: buggy code introduced in `719c1e182916` (v5.7,
  2020-03-02), present in all stable trees with exfat
- [Phase 3] No intermediate fixes for this issue
- [Phase 3] Recent file history shows no conflicting changes around
  s_maxbytes line
- [Phase 4] Found related fallocate patch on lore (`yhbt.net/lore/linux-
  fsdevel/20260228084542.485615-1-dxdt@dev.snart.me/T/`); s_maxbytes fix
  is separate standalone patch
- [Phase 4] Namjae Jeon (maintainer) reviewed and applied
- [Phase 5] s_maxbytes is used by VFS write checks, truncate checks, and
  fallocate checks — confirmed via grep
- [Phase 5] Compared with FAT (`0xffffffff`), NTFS3
  (`MAX_LFS_FILESIZE`), JFS (`min(..., MAX_LFS_FILESIZE)`) — all use
  format max, not volume size
- [Phase 6] Code context matches 7.0 tree exactly — clean apply
  confirmed
- [Phase 6] No competing fix in any stable tree
- [Phase 8] Failure mode: wrong errno (EFBIG vs ENOSPC), severity
  MEDIUM; 32-bit MAX_LFS_FILESIZE clamping issue

The fix is small, obviously correct, follows established VFS conventions
used by all other filesystems, and fixes a long-standing correctness bug
in exfat's `s_maxbytes` initialization. The risk is very low and the
benefit is clear.

**YES**

 fs/exfat/exfat_raw.h |  1 +
 fs/exfat/file.c      |  1 +
 fs/exfat/super.c     | 11 ++++++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/exfat/exfat_raw.h b/fs/exfat/exfat_raw.h
index 4082fa7b8c142..ec70cd35bba0c 100644
--- a/fs/exfat/exfat_raw.h
+++ b/fs/exfat/exfat_raw.h
@@ -25,6 +25,7 @@
 #define EXFAT_FIRST_CLUSTER	2
 #define EXFAT_DATA_CLUSTER_COUNT(sbi)	\
 	((sbi)->num_clusters - EXFAT_RESERVED_CLUSTERS)
+#define EXFAT_MAX_NUM_CLUSTER		(0xFFFFFFF5)
 
 /* AllocationPossible and NoFatChain field in GeneralSecondaryFlags Field */
 #define ALLOC_POSSIBLE		0x01
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 90cd540afeaa7..310083537a91d 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -33,6 +33,7 @@ static int exfat_cont_expand(struct inode *inode, loff_t size)
 		return ret;
 
 	num_clusters = EXFAT_B_TO_CLU(exfat_ondisk_size(inode), sbi);
+	/* integer overflow is already checked in inode_newsize_ok(). */
 	new_num_clusters = EXFAT_B_TO_CLU_ROUND_UP(size, sbi);
 
 	if (new_num_clusters == num_clusters)
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 83396fd265cda..95d87e2d7717f 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -531,9 +531,14 @@ static int exfat_read_boot_sector(struct super_block *sb)
 	if (sbi->vol_flags & MEDIA_FAILURE)
 		exfat_warn(sb, "Medium has reported failures. Some data may be lost.");
 
-	/* exFAT file size is limited by a disk volume size */
-	sb->s_maxbytes = (u64)(sbi->num_clusters - EXFAT_RESERVED_CLUSTERS) <<
-		sbi->cluster_size_bits;
+	/*
+	 * Set to the max possible volume size for this volume's cluster size so
+	 * that any integer overflow from bytes to cluster size conversion is
+	 * checked in inode_newsize_ok(). Clamped to MAX_LFS_FILESIZE for 32-bit
+	 * machines.
+	 */
+	sb->s_maxbytes = min(MAX_LFS_FILESIZE,
+			     EXFAT_CLU_TO_B((loff_t)EXFAT_MAX_NUM_CLUSTER, sbi));
 
 	/* check logical sector size */
 	if (exfat_calibrate_blocksize(sb, 1 << p_boot->sect_size_bits))
-- 
2.53.0

