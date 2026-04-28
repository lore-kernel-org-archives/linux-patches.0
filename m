Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDFA3F54D2;
	Tue, 28 Apr 2026 10:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372907; cv=none; b=nXkVo1xewnHRzPddOZGMu01sDudmxNI6V3AkbuYWIA8dtEUDZtUjOa9HL2wlHTCmqkow9zln/mkq/vpru/BEChHOqf/mmDGfhw3DeI37S33ZE/CCbMD0KMdx8/RYtee41F/i2oJYGbfaZynkcA/ah4EyaQNIc3IdewjdGJAQB8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372907; c=relaxed/simple;
	bh=AXRho5msvG4K0H7cOuH6JUNxG4lakdUdkAW5p2Ev8Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pWRr7oQs0p2F/S1BWsDc3Q91eIoMVqSFC2euNMwl3qk/vELoDM4HJ5Ugv+9/kgPIaIc53xaMq4m14C70A0C73xVoUkRrUrHQz0vnvtzeV+977MyEmNjxqhvIz+v0zQNPc2j2gxX2ix0f5zZEkRS9pGDXpQO8zpgHAdFaFMq/t6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p+cfoIHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+cfoIHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B6CC2BCB8;
	Tue, 28 Apr 2026 10:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372906;
	bh=AXRho5msvG4K0H7cOuH6JUNxG4lakdUdkAW5p2Ev8Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+cfoIHtvecBMv7Kjvlf/0p8d2z5V822Dngvw/R8zjzBtnUAS8kKAvlH7RzuMaFQc
	 leGkyls1jpabW7e1RarjtHXWF6sQbGVHe1SprhIPe61H0cT/vfEvxnuWDWMHRLxkuM
	 zK782OvQM/8kt7VDbSxyQZAbkcpaZykDVYrQeqVQOiinxJ04HxswxjGQQGenDQ5hNY
	 Eju0gXPb40gVS6iVLucDuL6J6IivCus/0FD9UGyEl9UVGZ2xhrvlQczP9oUJlshg/Z
	 L58ODFpX5yP/JV0x2ao8A8jHwoI97lXnT7hxK2mM7G7FkWIxe8X/Magvd9UA7EAB6Z
	 vpjtbHUDYbbvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	rtm@csail.mit.edu,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] fs/ntfs3: increase CLIENT_REC name field size
Date: Tue, 28 Apr 2026 06:40:20 -0400
Message-ID: <20260428104133.2858589-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 81ad9e67eccc0b094a6eef55a19ee56c761416dc ]

This patch increases the size of the CLIENT_REC name field from 32 utf-16
chars to 64 utf-16 chars. It fixes the buffer overflow problem in
log_replay() reported by Robbert Morris.

Reported-by: <rtm@csail.mit.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my investigation, let me compose the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject line parsing:**
Record: Subsystem `fs/ntfs3`; action verb "increase" (which supports a
fix per body text); summary: enlarges CLIENT_REC.name to fix a buffer
overflow in log_replay().

**Step 1.2 - Tags:**
Record:
- `Reported-by: <rtm@csail.mit.edu>` — Robert (Robbert) Morris, MIT
  CSAIL; a researcher who regularly reports filesystem memory-safety
  bugs (he has multiple previous ntfs3 reports landed: `1b7dd28e14c47`
  and `652cfeb43d6b9`, both credited to him).
- `Signed-off-by: Konstantin Komarov <...paragon-software.com>` — author
  is the ntfs3 subsystem maintainer.
- No Fixes:, no Cc: stable (expected — that's why we review).

**Step 1.3 - Body analysis:**
Record: Bug description is explicit — "fixes the buffer overflow problem
in log_replay()". Failure mode: memory corruption when mounting a
malicious NTFS image (confirmed by KASAN). The on-disk Windows
`$LogFile` CLIENT_REC truly has `name[64]` (not 32); Linux's undersized
struct causes the size check in `is_rst_area_valid()` to under-reject a
crafted restart area.

**Step 1.4 - Hidden fix detection:**
Record: Not hidden — commit message openly says "buffer overflow". No
disguise.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory:**
Record: 1 file (`fs/ntfs3/fslog.c`), +2/-2 lines. Only `struct
CLIENT_REC` and the `static_assert` on its size change. Scope: single-
file surgical fix.

**Step 2.2 - Code-flow change:**
Record:
- Before: `__le16 name[32]` → `sizeof(CLIENT_REC) == 0x60`.
- After: `__le16 name[64]` → `sizeof(CLIENT_REC) == 0xa0`.

The struct is used (1) as the on-disk client record stride in
`$LogFile`, and (2) in the validator `is_rst_area_valid()` at
`fs/ntfs3/fslog.c:487`:

```464:529:fs/ntfs3/fslog.c
        off = le16_to_cpu(ra->client_off);
        if (!IS_ALIGNED(off, 8) || ro + off > SECTOR_SIZE -
sizeof(short))
                return false;

        off += cl * sizeof(struct CLIENT_REC);

        if (off > sys_page)
                return false;
        ...
        if (le16_to_cpu(rhdr->ra_off) + le16_to_cpu(ra->ra_len) >
sys_page ||
            off > le16_to_cpu(ra->ra_len)) {
                return false;
        }
```

With the new size, malformed RAs that pack `client_off + cl*0x60 <=
ra_len` but would still overflow the target buffer are now rejected
(`off = client_off + cl*0xa0 > ra_len`).

**Step 2.3 - Bug mechanism:**
Record: Memory-safety fix (h: struct size / validation, with (d)
downstream memory safety). Root cause: incorrect on-disk layout
definition caused `is_rst_area_valid()` to under-validate, letting a
crafted log file reach the overflowing `memcpy` in `log_replay()`:

```4033:4048:fs/ntfs3/fslog.c
        t16 = le16_to_cpu(ra2->client_off);
        if (t16 == offsetof(struct RESTART_AREA, clients)) {
                memcpy(ra, ra2, log->ra_size);
        } else {
                memcpy(ra, ra2, offsetof(struct RESTART_AREA, clients));
                memcpy(ra->clients, Add2Ptr(ra2, t16),
                       le16_to_cpu(ra2->ra_len) - t16);
```

Concretely (from the reporter's reproducer): attacker sets `ra_len=112,
client_off=16, log_clients=1`. Old size: `16 + 1*0x60 = 112` not `>
112`, check passes. Then the memcpy writes 64 + 96 = 160 bytes into a
112-byte `ra`, smashing 48 bytes past it. New size: `16 + 1*0xa0 = 176 >
112`, so `is_rst_area_valid()` rejects the RA; `ra2` becomes NULL
(`fslog.c:3885–3888`) and `log_replay()` returns `-EINVAL` at line
3919-3921 before the unsafe memcpy runs.

**Step 2.4 - Fix quality:**
Record: Very small, obviously correct structural change. Risk from the
fix itself is low: `is_rst_area_valid()` becomes *stricter*; the only
regression surface is rejecting a restart area formerly written by buggy
Linux ntfs3 (which had `ra_len = 0x40 + 0x60 = 0xa0`). But that path is
only hit when a log is *dirty* (`client_idx[1] != LFS_NO_CLIENT_LE`);
cleanly unmounted volumes skip the memcpy path entirely
(`fslog.c:3890-3916`). Windows-written logs already use 0xa0 records, so
the new size matches the genuine on-disk format. This is a net positive.

---

## PHASE 3: GIT HISTORY

**Step 3.1 - Blame:**
Record: The `name[32]` / `static_assert(... == 0x60)` lines were
introduced by `b46acd6a6a627 ("fs/ntfs3: Add NTFS journal")` authored
2021-08-13 by Konstantin Komarov. `git describe --contains` reports
`v5.15-rc1~94^2~29`, i.e. present since v5.15 (the very commit that
introduced ntfs3). Thus the bug affects every stable tree that ships
ntfs3.

**Step 3.2 - Fixes: tag:**
Record: No explicit Fixes: tag, but by content the bug traces to
`b46acd6a6a627` (v5.15).

**Step 3.3 - File history:**
Record: Other related security-hardening fixes in `fslog.c` from the
same reporter (`rtm@csail.mit.edu`): `1b7dd28e14c47 ("fs/ntfs3: Correct
function is_rst_area_valid")` and the journal-replay series. This commit
is standalone; not part of a dependent series (confirmed by `b4 dig -a`:
only v1, 1 patch).

**Step 3.4 - Author:**
Record: Konstantin Komarov is the ntfs3 maintainer; routinely lands
fixes for rtm's reports. Strong authority signal.

**Step 3.5 - Dependencies:**
Record: None. Diff only changes a struct and a static_assert. No new
functions referenced.

---

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1 - b4 dig:**
Record:
- `b4 dig -c 81ad9e67eccc0` found: https://lore.kernel.org/all/202603191
  35855.15200-1-almaz.alexandrovich@paragon-software.com/
- `b4 dig -c ... -a`: single revision (v1), applied as-is.
- Thread content (via mbox): plain PATCH, no review comments, went
  straight into the maintainer tree.

**Step 4.2 - Recipients:**
Record (b4 dig -w): `ntfs3@lists.linux.dev`, `linux-
kernel@vger.kernel.org`, `linux-fsdevel@vger.kernel.org`,
`rtm@csail.mit.edu`. Right lists, right reporter.

**Step 4.3 - Bug report:**
Record: Found original report at
`https://lore.kernel.org/ntfs3/42774.1769379272@localhost/`
(2026-01-25). It is a detailed reproducer with:
- A downloadable crafted image
  (`http://www.rtmrtm.org/rtm/ntfs30a.img.gz`)
- A KASAN SLUB trace: "Right Redzone overwritten ... BUG kmalloc-128
  (Not tainted): Object corrupt"
- Exact pointer math matching `log_replay()`'s memcpy path.

Konstantin replied (Feb 9 2026) confirming he'd reproduce and fix. Patch
appeared ~6 weeks later.

**Step 4.4 - Series context:**
Record: Single-patch fix, not part of a larger series.

**Step 4.5 - Stable-specific discussion:**
Record: Not found. Also on Apr 20 2026, Konstantin's `[GIT PULL] ntfs3:
bugfixes for 7.1` explicitly lists this commit under **"Fixed: ...
increase CLIENT_REC name field size to prevent buffer overflow"** — the
maintainer classifies it as a bug fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key functions:** `struct CLIENT_REC` size (used by
`is_rst_area_valid`, `log_replay`, `log_create_ra`, array indexing
everywhere the stride appears).

**Step 5.2 - Callers / reachability:**
Record: `log_replay()` is invoked during `ntfs_fill_super()` mount path
(`fs/ntfs3/super.c`). Triggered on every `mount -t ntfs3` with a dirty
log. Trigger condition: need CAP_SYS_ADMIN (or equivalent) to mount, but
this is a common vector (auto-mount of USB drives, containers with mount
caps, etc.).

**Step 5.3 - Callees:** `is_rst_area_valid()` is called from
`log_read_rst()` before any RA data is trusted; with the new sizeof it
now rejects the pathological `client_off + cl*sizeof` combinations.

**Step 5.4 - Call chain:** `mount` → `ntfs_fill_super` → `log_replay` →
`log_read_rst` → `is_rst_area_valid` / memcpy path. Entirely reachable
from user-triggerable mount.

**Step 5.5 - Similar patterns:** Several sibling checks
(`is_client_area_valid`, `check_client_area`) also iterate with
`sizeof(CLIENT_REC)` stride; the fix corrects all of them simultaneously
because they all reference the same type.

---

## PHASE 6: STABLE TREES

**Step 6.1 - Code presence:**
Record: `git grep "name\[32\]" stable/linux-{5.15,6.1,6.6,6.12,6.19}.y
-- fs/ntfs3/fslog.c` confirms the buggy `__le16 name[32]` and
`static_assert(... == 0x60)` are present in every active stable tree.
ntfs3 was added in v5.15.

**Step 6.2 - Backport complications:**
Record: The 2-line struct edit applies cleanly to every stable branch. I
verified the surrounding struct definition is byte-identical across
5.15.y, 6.1.y, 6.6.y, 6.12.y, 6.19.y.

**Step 6.3 - Existing stable fix?**
Record: No prior fix for this bug exists in any stable branch (no
`CLIENT_REC` commits on any of the stable branches checked).

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 - Subsystem/criticality:**
Record: `fs/ntfs3` — IMPORTANT. Default NTFS driver since v5.15, used by
countless distros to mount Windows-format media (USB drives, external
disks, dual-boot partitions).

**Step 7.2 - Activity:**
Record: Active — many fixes land per cycle, and this commit is in the
7.1 pull request alongside ~16 other ntfs3 fixes.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 - Who is affected:**
Record: Anyone mounting an untrusted NTFS image on a kernel with ntfs3
compiled in. This includes desktop Linux, NAS devices, embedded systems,
containers with mount privileges, and auto-mount frameworks that honor
USB insertion.

**Step 8.2 - Trigger conditions:**
Record: A single `mount -t ntfs3` of a crafted image is sufficient.
Reporter supplied a working reproducer. Requires root/mount cap but this
is a standard attack surface for local privilege escalation via
malicious removable media.

**Step 8.3 - Failure mode:**
Record: CRITICAL — heap out-of-bounds write (48 bytes past a kmalloc-128
slab object, as KASAN demonstrates). Consequences range from kernel
panic to targeted memory corruption / potential privilege escalation
depending on what sits next to that slab.

**Step 8.4 - Risk/benefit:**
Record:
- Benefit: very high — closes a reachable heap buffer overflow with a
  public reproducer in the default Linux NTFS driver.
- Risk: very low — two-line struct-size change; only potential side
  effect is stricter validation that can reject RA headers previously
  written by the same buggy Linux driver on dirty logs, which is far
  better than memory corruption.

---

## PHASE 9: SYNTHESIS

**Step 9.1 - Evidence:**
FOR:
- KASAN-confirmed heap buffer overflow with a publicly reproducible
  image.
- Reported by an external security researcher; acknowledged and fixed by
  the subsystem maintainer.
- Bug exists in every active stable tree (5.15.y and later).
- Maintainer's pull request explicitly labels this as "prevent buffer
  overflow."
- 2-line structural change, no dependencies.

AGAINST: None of substance.

UNRESOLVED: Whether kernels written with old Linux ntfs3 will fail to
replay a *dirty* log after upgrading. This edge case is (a) narrow
(dirty logs only) and (b) acceptable given the severity of the bug.

**Step 9.2 - Stable rules checklist:**
1. Obviously correct and tested: yes — trivial struct size change,
   upstream-tested, matches Windows on-disk layout.
2. Real bug: yes — KASAN trace, public reproducer.
3. Important: yes — heap OOB via mount.
4. Small/contained: yes — +2/-2 in one file.
5. No new features: yes — corrects existing layout.
6. Applies to stable: yes — clean apply confirmed for 5.15.y through
   6.19.y.

**Step 9.3 - Exception category:** Not needed; this meets core stable-
kernel-rules on its own merits (security / memory-corruption fix).

**Step 9.4 - Decision:** YES.

---

## Verification

- [Phase 1] Parsed tags from commit message: found `Reported-by:
  rtm@csail.mit.edu`, `Signed-off-by: Konstantin Komarov`. Commit
  message explicitly mentions "buffer overflow in log_replay()".
- [Phase 2] Diff: +2/-2, changes only `CLIENT_REC.name[32]→[64]` and
  `static_assert(==0x60)→(==0xa0)` in `fs/ntfs3/fslog.c`.
- [Phase 2] Read `fs/ntfs3/fslog.c` lines 464-529 and 4026-4048 to trace
  how the struct size feeds `is_rst_area_valid()` and the subsequent
  memcpy; verified that the attacker-controlled `client_off` + `ra_len`
  combination from the bug report passes the old check and fails the new
  one.
- [Phase 3] `git describe --contains b46acd6a6a627` returned
  `v5.15-rc1~94^2~29`, confirming the bug has been present since ntfs3
  was introduced in v5.15.
- [Phase 3] `git log --grep="rtm@csail" -- fs/ntfs3` showed prior fixes
  by the same maintainer for reports from this reporter
  (`1b7dd28e14c47`, `652cfeb43d6b9`).
- [Phase 4] `b4 dig -c 81ad9e67eccc0` resolved to https://lore.kernel.or
  g/all/20260319135855.15200-1-almaz.alexandrovich@paragon-
  software.com/.
- [Phase 4] `b4 dig -c 81ad9e67eccc0 -a` shows only v1; patch applied
  as-submitted.
- [Phase 4] `b4 dig -c 81ad9e67eccc0 -w` showed correct recipients:
  ntfs3@lists.linux.dev, linux-fsdevel, linux-kernel, rtm.
- [Phase 4] Fetched and read original bug report at
  `lore.kernel.org/ntfs3/42774.1769379272@localhost/raw`: KASAN "Right
  Redzone overwritten" report, reproducer image URL, exact line-number
  match with the memcpy overflow.
- [Phase 4] Fetched maintainer reply at
  `lore.kernel.org/ntfs3/f9e6330b-.../raw` confirming acknowledgment
  (Feb 9, 2026).
- [Phase 4] Fetched 7.1 pull request (`20260420150756.6058-1-...`):
  commit listed under "Fixed: ... to prevent buffer overflow".
- [Phase 6] `git grep` on each active stable branch (5.15.y, 6.1.y,
  6.6.y, 6.12.y, 6.19.y) confirmed all still have `name[32]` and `sizeof
  == 0x60`.
- [Phase 6] `git log --grep="CLIENT_REC" -- fs/ntfs3/fslog.c` on each
  stable branch returned empty — no prior fix in stable.
- [Phase 7] Confirmed `fs/ntfs3` is the default NTFS driver since v5.15
  (same commit that introduced the bug).
- [Phase 8] Verified `log_replay()` is called from the mount path; the
  `memcpy` overflow is reached on a *dirty* log with attacker-controlled
  `client_off` and `ra_len`; reporter provided a working image.
- UNVERIFIED: I did not personally run the provided malicious image
  against pre-fix and post-fix kernels to independently confirm
  behavior; I relied on the KASAN trace, the pointer arithmetic in the
  public source, and the maintainer's agreement.

This is a small, obviously correct memory-corruption fix with a public
reproducer and maintainer acknowledgement, affecting all stable trees
that carry ntfs3. Textbook stable material.

**YES**

 fs/ntfs3/fslog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 272e452761436..10dbe9922bf13 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -45,10 +45,10 @@ struct CLIENT_REC {
 	__le16 seq_num;     // 0x14:
 	u8 align[6];        // 0x16:
 	__le32 name_bytes;  // 0x1C: In bytes.
-	__le16 name[32];    // 0x20: Name of client.
+	__le16 name[64];    // 0x20: Name of client.
 };
 
-static_assert(sizeof(struct CLIENT_REC) == 0x60);
+static_assert(sizeof(struct CLIENT_REC) == 0xa0);
 
 /* Two copies of these will exist at the beginning of the log file */
 struct RESTART_AREA {
-- 
2.53.0

