Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DF24CA285;
	Mon, 20 Apr 2026 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692001; cv=none; b=P02P6d1QQCa84tlDkopb2tnIVOO9U7VQE9VbnHnbo7kNRwoNB/VUjscOURBRWfh+QpT10JWkzX71/lWXZO9BETB8UrWWKs52y+Fn1fu66XCHVZv6FfzptFOZ5WMmGCBpPyV1y2vsg+f4JxqTKPTGVWOl3u2PduTBo7Vvo+NUCn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692001; c=relaxed/simple;
	bh=CC4GpNAMEXoNH1UPwn7+SB8s/abXwphtakfGIufYQ9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gg5H6UdtH55oNYywcTeLrvgpZIfFfMunkLfashvmcK13K2xTXVM/wIkaOMDpJbf48FV9lkhE1h7+WpEpSKLzvhpQJCylrG7dGKz4clIXLxzL35PQ7CqA7ycoIHUrrycjWogPSl/3JrDNJ3eZMCTQoCWvD7RnGq/AMPHJH4QLNNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4AXioSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4AXioSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7839DC2BCB8;
	Mon, 20 Apr 2026 13:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692000;
	bh=CC4GpNAMEXoNH1UPwn7+SB8s/abXwphtakfGIufYQ9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4AXioSF65QR0LkKfC9h0zjxItH43BD3b4jZIt9r1j4lBakNijNUpuXlxRwlXMf3u
	 LJqqu2mHkCRCkG1pEc/XvVzNJHfwAtF4jjJez3bu7gScj1xvYq1kxkQobs/I1gzmav
	 omDOUyba2MEI8hpa5VYR8GwG8PQjaafnibNf+oY+ctZ0bJaEG8Uqo9WKMjjOOw1c/A
	 nz2GkFYlc5KYtmVj91Cq1tVVpPYdACKXoNVPyZ3HQPzNwdJBO7VHo5osPpTDN6LuMs
	 pETIdk1XpjaxSIqru//v9/C9DzRIJ1AYWW4WaGiULbTP5fjhMfb9x04y/xBJKUAL38
	 t/Nkdp28GNyBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hongling Zeng <zenghongling@kylinos.cn>,
	kernel test robot <lkp@intel.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-omap@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] fbdev: omap2: fix inconsistent lock returns in omapfb_mmap
Date: Mon, 20 Apr 2026 09:21:49 -0400
Message-ID: <20260420132314.1023554-315-sashal@kernel.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 98cf7df6e0844f7076df1db690c1ede9d69b61ff ]

Fix the warning about inconsistent returns for '&rg->lock' in
omapfb_mmap() function. The warning arises because the error path
uses 'ofbi->region' while the normal path uses 'rg'.

smatch warnings:
drivers/video/fbdev/omap2/omapfb/omapfb-main.c:1126 omapfb_mmap()
warn: inconsistent returns '&rg->lock'.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - line 1122 in v6.6 also has `omapfb_put_mem_region(ofbi->region)`
on the error path, confirming the bug exists in stable trees. Now let me
compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `fbdev: omap2`
- Action verb: "fix"
- Summary: Fix inconsistent lock returns in `omapfb_mmap`

**Step 1.2: Tags**
- Reported-by: kernel test robot `<lkp@intel.com>` — automated static
  analysis (smatch)
- Signed-off-by: Hongling Zeng (author), Helge Deller (fbdev maintainer)
- No Fixes: tag (expected)
- No Cc: stable (expected)

**Step 1.3: Commit Body**
- Bug: smatch warns about inconsistent returns for `&rg->lock` because
  the error path uses `ofbi->region` while the success path uses `rg`
- Symptom: smatch warning (not a runtime crash report)
- Root cause: The error path re-reads `ofbi->region` instead of using
  the captured local `rg`

**Step 1.4: Hidden Bug Fix?**
Yes. While described as a "warning fix," this is actually a real locking
correctness bug, as I'll demonstrate below.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `drivers/video/fbdev/omap2/omapfb/omapfb-main.c`
- 1 line changed: `ofbi->region` → `rg`
- Function: `omapfb_mmap`
- Scope: single-file surgical fix

**Step 2.2: Code Flow Change**
- BEFORE: Error path calls `omapfb_put_mem_region(ofbi->region)` — re-
  reads the `ofbi->region` pointer
- AFTER: Error path calls `omapfb_put_mem_region(rg)` — uses the locally
  captured pointer

**Step 2.3: Bug Mechanism**
This is a **synchronization/lock correctness** bug. Key details:

1. `omapfb_get_mem_region()` acquires `down_read_nested(&rg->lock)` and
   returns its argument (line 183-188 of omapfb.h)
2. At line 1100: `rg = omapfb_get_mem_region(ofbi->region)` acquires the
   read lock and stores the pointer locally
3. Success path (line 1119) correctly releases via `rg`
4. Error path (line 1124, the bug) releases via `ofbi->region`

Critically, `ofbi->region` **can be changed** by another thread — in
`omapfb-ioctl.c` line 98: `ofbi->region = new_rg` during
`omapfb_setup_plane()`. If this happens between get and put:
- `up_read()` is called on a semaphore **not held** by this thread →
  undefined behavior / corruption
- The **actual** locked semaphore is **never released** → deadlock

**Step 2.4: Fix Quality**
- Obviously correct: use the already-captured local variable
- Minimal: 1-line change
- Zero regression risk: the fix is strictly safer than the original code
- Pattern matches `omapfb-sysfs.c` line 73, which correctly uses `rg` on
  its error path

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy line was introduced in commit `3ed37d9aba486d` ("Revert
'OMAPFB: simplify locking'") by Tomi Valkeinen on 2012-12-13. This code
has been present since ~v3.8, meaning all active stable trees contain
it.

**Step 3.2: Fixes tag**
No Fixes: tag present. However, the buggy commit is `3ed37d9aba486d`
which reverted simplified locking and reintroduced per-region locking.
The error path was incorrectly written using `ofbi->region` instead of
`rg` at that time.

**Step 3.3: File History**
The file hasn't had many recent changes — last meaningful changes were
build system/boilerplate updates. No prerequisites needed.

**Step 3.4: Author**
Hongling Zeng is not the subsystem maintainer but has contributed other
small fixes (USB quirks, sysfs fixes). The commit was signed off by
Helge Deller, the fbdev maintainer.

**Step 3.5: Dependencies**
None. This is a standalone one-line fix.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.2:** b4 dig could not find the original submission. Lore is
protected by anti-scraping measures. The commit was signed off by the
fbdev maintainer (Helge Deller), confirming proper review.

**Step 4.3:** The bug was reported by kernel test robot (smatch static
analysis), not a runtime bug report.

**Step 4.4-4.5:** No related series; standalone patch.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.2:** The function `omapfb_mmap` is registered as the
`.fb_mmap` callback in the framebuffer ops structure, called when
userspace mmaps the framebuffer device (`/dev/fb*`). This is a standard
userspace-reachable path.

**Step 5.3:** `omapfb_get_mem_region` → `down_read_nested` (acquires
rw_semaphore read lock). `omapfb_put_mem_region` → `up_read` (releases
read lock). These must operate on the same object.

**Step 5.4:** Reachable from userspace via `mmap()` on `/dev/fbX`. The
error path triggers when `vm_iomap_memory()` fails.

**Step 5.5:** In `omapfb-sysfs.c:59-73`, the identical pattern (`rg =
omapfb_get_mem_region(ofbi->region)` followed by
`omapfb_put_mem_region(rg)`) is used correctly. The bug in `omapfb_mmap`
is the sole instance of the incorrect pattern.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The buggy code exists in v6.6 stable tree (verified: line
1122 has `omapfb_put_mem_region(ofbi->region)`). Present since v3.8
(~2012). All active stable trees are affected.

**Step 6.2:** The fix is a trivial 1-line change. Will apply cleanly to
all stable trees.

**Step 6.3:** No related fixes already in stable.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** Subsystem: `drivers/video/fbdev/omap2` — OMAP2 framebuffer
driver. Criticality: PERIPHERAL (legacy ARM platform, but real users
exist in embedded systems).

**Step 7.2:** Low activity — the file hasn't changed meaningfully in
years. Mature/stable code.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected users: users of OMAP2 SoC framebuffer
(embedded/ARM platforms).

**Step 8.2:** Trigger conditions: Requires concurrent `mmap()` and
region-changing ioctl on the same framebuffer, plus `vm_iomap_memory()`
failure. The race window is narrow, making this unlikely to trigger in
practice.

**Step 8.3:** Failure mode: If triggered, results in **lock state
corruption** (releasing wrong lock) and potential **deadlock** (held
lock never released). Severity: HIGH (deadlock), though likelihood is
LOW.

**Step 8.4:** Risk-benefit ratio:
- BENEFIT: Fixes a genuine lock correctness bug reachable from
  userspace, prevents potential deadlock
- RISK: Essentially zero — replacing one expression with an equivalent
  one in the normal case, and a correct one in the race case. 1-line
  change. Obviously correct.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes a real locking correctness bug (inconsistent lock/unlock
  objects)
- `ofbi->region` can be changed concurrently via ioctl (verified in
  `omapfb-ioctl.c:98`)
- 1-line fix, trivially correct, zero regression risk
- Matches the correct pattern used elsewhere in the same codebase
  (`omapfb-sysfs.c`)
- Accepted by fbdev maintainer (Helge Deller SOB)
- Bug exists in all stable trees (since v3.8, ~2012)
- Clean apply expected

AGAINST backporting:
- OMAP2 fbdev is legacy peripheral hardware
- Race window is extremely narrow and unlikely to trigger in practice
- Only detected by static analysis, not runtime
- Low real-world impact

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — trivially verifiable
2. Fixes a real bug? **YES** — inconsistent lock/unlock on potentially
   different objects
3. Important issue? **MEDIUM** — potential deadlock, but unlikely
   trigger
4. Small and contained? **YES** — 1-line change
5. No new features? **YES**
6. Can apply to stable? **YES** — clean apply

**Step 9.3: Exception Categories**
Not an exception category, but meets standard criteria as a small bug
fix.

**Step 9.4: Decision**
The fix is a 1-line change that is obviously correct, with zero
regression risk. It fixes a real (if unlikely to trigger) locking
correctness bug that could lead to deadlock. The cost of inclusion is
negligible, and it makes the code genuinely correct.

## Verification

- [Phase 1] Parsed tags: Reported-by kernel test robot, SOB from fbdev
  maintainer Helge Deller
- [Phase 2] Diff analysis: 1 line changed in error path of
  `omapfb_mmap()`, replacing `ofbi->region` with `rg`
- [Phase 2] Verified `omapfb_get_mem_region()` returns its argument and
  acquires `down_read_nested` (omapfb.h:183-188)
- [Phase 2] Verified `ofbi->region` can be changed concurrently (omapfb-
  ioctl.c:98: `ofbi->region = new_rg`)
- [Phase 3] git blame: buggy line introduced by commit 3ed37d9aba486d
  (2012-12-13, "Revert 'OMAPFB: simplify locking'"), present since ~v3.8
- [Phase 3] File history: no prerequisites needed, standalone fix
- [Phase 4] b4 dig: could not find original submission thread
- [Phase 5] Correct pattern exists in omapfb-sysfs.c:59-73 (uses `rg`
  not `ofbi->region`)
- [Phase 6] Verified buggy code exists in v6.6 stable tree (line 1122)
- [Phase 6] Fix will apply cleanly (1-line change, no surrounding churn)
- [Phase 8] Failure mode: lock corruption + potential deadlock (severity
  HIGH, likelihood LOW)

**YES**

 drivers/video/fbdev/omap2/omapfb/omapfb-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
index a8b2930290e1f..d70deb6a91508 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1121,7 +1121,7 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 	return 0;
 
 error:
-	omapfb_put_mem_region(ofbi->region);
+	omapfb_put_mem_region(rg);
 
 	return r;
 }
-- 
2.53.0

