Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18BF647992;
	Mon, 19 Oct 2026 14:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418795; cv=none; b=fHLAGe30u5vCkolKVVyMSrFRWlDSz0CO7PppLd+vRdN8WAcmU9Cn4hGa4/yesc5QBMpOybQLo9t2AC+3NngG7UCRhttXT/ST9zmx8wB0WXOBNYABDGZrSjXsy1xWTeU80c9nI44cI3mgdqY56NJABpxUEWEZKJG8OPBo1IkqsAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418795; c=relaxed/simple;
	bh=gEEJd4PlB23y/8SGXAWYyzRbVPbMpV+TOCKiJ4Zlp1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dS5+iJA2EPM+uhosPS8yadbqyGcblc1ky6A0Zfs5grljAptzovZTS+vDkFghpyNnaGiGUKOt1xZdY3MUwIygSCuoTFaBC3W1L11iMo9UEFCLHSqEkFqf3WLF9lFNfm1/sU8Qeqi4mLmd2tcAE7c6nyopj5LYFqzgjWfZr0RWbHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxrcAi6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxrcAi6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91371F000C6;
	Mon, 19 Oct 2026 14:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418792;
	bh=vvmtytqQAG4Lx2uj9KxSX8lUECGNW+T1jV44qoXA0VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxrcAi6aUiRLXGPMPLJzdt/ZONfodS+zLlaeGlV7nGsitVqYHHjYhioUDQD1gIes+
	 oroKW/4vYIQJ9Zl+qFdESRGA+k2jUwSaj8r6e8vucbtIuZhG+hp1SYeOcZ/wuoeQFC
	 n/33Q3G59eD3UUxYa95jSmfA1ca8jIy0j2WIa9mVJnUYhfHv1CrUI9GM62jh/8hj7n
	 xyEoLkXfYNhBbzNW1aW92IIJ9BCG7n6qVDvbaIH+IjWlV0PhS6Z9oYpzcYoEXYpgwt
	 K31dnHVPlxU40ftc9TPGKHLhPHNrvbS5iMkI/RlYPaFkTLbCtsgKMp63CVSXRQtERE
	 HWjOlJBnTeMkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] dmaengine: pl330: remove debugfs file on teardown
Date: Mon, 19 Oct 2026 09:53:11 -0400
Message-ID: <20261019135441.1420968-500-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0d3e3376b289cdaff5b3b6c1581999926ff1000f ]

init_pl330_debugfs() creates a debugfs file with struct pl330_dmac as
private data. pl330_remove() then unregisters the DMA device and frees
the PL330 channel/thread state without removing that file.

Keep the debugfs dentry and remove it before tearing down the DMAC state
used by the debugfs show callback.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615091645.28878-1-pengpeng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[dmaengine/pl330] [remove] [drop the leftover debugfs file
before DMAC teardown]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Fixes:` — absent (expected for this review)
- `Reported-by:` — absent
- `Tested-by:` — absent
- `Reviewed-by:` — absent
- `Acked-by:` — absent
- `Link:`
  `https://patch.msgid.link/20260615091645.28878-1-pengpeng@iscas.ac.cn`
- `Cc: stable@vger.kernel.org` — absent (expected)
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Vinod Koul <vkoul@kernel.org>` (dmaengine maintainer)
- Ignore any Sasha Levin SOB if present in candidate wrapping — none on
  this commit object

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `init_pl330_debugfs()` creates a debugfs file whose private
  data is `struct pl330_dmac *`. `pl330_remove()` tears down DMA
  registration and frees channel/thread state without removing that
  file.
- **Symptom:** After unbind/`rmmod`, the debugfs file remains. A later
  read runs `pl330_debugfs_show()` against freed `pl330` /
  `pl330->channels` (use-after-free / oops).
- **Version info:** none in the message. The debugfs file was added in
  `b45aef3aef636` (contained in v5.2-rc1).
- **Root cause:** missing `debugfs_remove()` before DMAC teardown.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not disguised. It is an explicit lifetime/UAF fix (remove
debugfs before freeing the object the show callback uses).

---

## Phase 2: Diff analysis

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/dma/pl330.c` only (`+16 / -3`)
- Functions: `struct pl330_dmac` (add `dbgfs`), `init_pl330_debugfs()`,
  new `deinit_pl330_debugfs()`, `pl330_remove()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Hunk 1 (`struct pl330_dmac`):** store the dentry so it can be
  removed later.
- **Hunk 2 (`init_pl330_debugfs`):** keep the return of
  `debugfs_create_file()` in `pl330->dbgfs`. Add
  `deinit_pl330_debugfs()` that calls `debugfs_remove()` and NULLs the
  pointer. `#else` stub for `!CONFIG_DEBUG_FS`.
- **Hunk 3 (`pl330_remove`):** call `deinit_pl330_debugfs(pl330)`
  **before** IRQ free, `dma_async_device_unregister()`, channel
  teardown, and `pl330_del()`.

Probe still creates the file only on the success path after
`dma_async_device_register()`; nothing after `init_pl330_debugfs()` can
fail, so probe error paths do not need deinit.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Use-after-free / lifetime** (debugfs private data).

Before: file at debugfs root, private data = `pl330`. `pl330_remove()`
then:
1. unregisters the DMA device
2. `pl330_del()` → `dmac_free_threads()` → `kfree(pl330->channels)`
3. AMBA `devm` frees `pl330` itself (`devm_kzalloc` in `pl330_probe`)

`pl330_debugfs_show()` then does `s->private` → `pl330->channels[ch]` on
freed memory.

After: `debugfs_remove()` first. Core debugfs waits for `active_users`
to drain, so an in-flight `cat` finishes before teardown.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct and minimal. `debugfs_remove()` already no-ops
on `IS_ERR_OR_NULL`. `pl330` is `devm_kzalloc`’d so `dbgfs` starts NULL.
Sibling DMA drivers (`pxa_dma`, `hidma`, `idxd`, `bcm-sba-raid`) already
remove debugfs on teardown.

Regression risk: very low. `debugfs_remove()` may wait for a reader;
that is intended. No API/locking/hot-path change.

---

## Phase 3: Git history

**Step 3.1: BLAME THE CHANGED LINES**

Record: Buggy create-without-remove came from `b45aef3aef636`
(“dmaengine: pl330: introduce debugfs interface”, 2019-03-25). `git
describe --contains` → `v5.2-rc1~115^2~30`. Present for years in this
lineage.

**Step 3.2: FOLLOW THE FIXES TAG**

Record: No `Fixes:` tag. Introducer is `b45aef3aef636`, ancestor of HEAD
(`git merge-base --is-ancestor` exit 0).

**Step 3.3: CHECK FILE HISTORY**

Record: Recent `pl330.c` history is unrelated (GFP helpers, runtime PM).
No prerequisite series. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Pengpeng Hou has this one dmaengine commit here. Applied by
maintainer Vinod Koul. Not a series from this author.

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**

Record: None. Uses long-standing `debugfs_create_file` /
`debugfs_remove` / `DEFINE_SHOW_ATTRIBUTE`. Applies standalone.

---

## Phase 4: Mailing list / external research

**Step 4.1: ORIGINAL PATCH DISCUSSION**

Record:
- Lore URL from `b4 dig -c 0d3e3376b289c`:
  `https://patch.msgid.link/20260615091645.28878-1-pengpeng@iscas.ac.cn`
- `b4 dig -a`: single **v1**, no later revision
- Thread (mbox): author submission; sashiko-bot comments on **pre-
  existing** issues (desc_pool locking, IRQ vs `pl330_add`,
  `pch->thread` TOCTOU in show); **Vinod: “Applied, thanks!”** as
  `0d3e3376b289c`
- No NAK of this change. No reviewer `Cc: stable`. Direct lore HTTP
  fetch returned 403; discussion taken from `b4 dig -m`.

**Step 4.2: WHO REVIEWED**

Record (`b4 dig -w`): To/Cc Vinod Koul, Frank Li,
`dmaengine@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Maintainer
applied it. No human Reviewed-by.

**Step 4.3: BUG REPORT**

Record: No syzbot/bugzilla/`Reported-by`. Found by inspection. Failure
mode is still a concrete UAF on leftover debugfs.

**Step 4.4: RELATED PATCHES / SERIES**

Record: Standalone 1/1. Not part of a multi-patch series.

**Step 4.5: STABLE MAILING LIST**

Record: **UNVERIFIED** — `lore.kernel.org/stable` returned HTTP 403. No
stable discussion in the dmaengine mbox.

---

## Phase 5: Code semantic analysis

**Step 5.1: KEY FUNCTIONS**

Record: `init_pl330_debugfs`, `deinit_pl330_debugfs` (new),
`pl330_remove`, `pl330_debugfs_show` (user of private data), `pl330_del`
/ `dmac_free_threads` (free the memory the show callback uses).

**Step 5.2: CALLERS**

Record:
- `init_pl330_debugfs()` — `pl330_probe()` success path only
- `deinit_pl330_debugfs()` — `pl330_remove()` only
- `pl330_remove()` — AMBA `.remove`
- `pl330_debugfs_show()` — debugfs read (`DEFINE_SHOW_ATTRIBUTE`)

**Step 5.3: CALLEES**

Record: `debugfs_create_file`, `debugfs_remove`, then existing remove
path (`dma_async_device_unregister`, `pl330_del` → `kfree(channels)`).

**Step 5.4: CALL CHAIN / REACHABILITY**

Record: `echo … > unbind` or `rmmod dma-pl330` → `pl330_remove`. Then
`cat /sys/kernel/debug/<devname>` (file is created with parent `NULL` at
debugfs root). Reachable from userspace. debugfs is typically root-only
(0700), so not an unprivileged UAF, still a kernel UAF/oops.

**Step 5.5: SIMILAR PATTERNS**

Record: Other DMA drivers already `debugfs_remove[_recursive]` on
teardown (`pxa_dma.c`, `dmaengine.c`, `bcm-sba-raid.c`,
`idxd/debugfs.c`, `qcom/hidma_dbg.c`). pl330 was the outlier.

---

## Phase 6: Local tree

**Step 6.1: DOES THE BUGGY CODE EXIST HERE?**

Record: Local tree is **v7.3-rc4** (`VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
EXTRAVERSION=-rc4`, `git describe` `v7.3-rc4-27-gf0100363d8c37`).

`drivers/dma/pl330.c` is present. Debugfs dates to v5.2. This commit
**is already an ancestor of HEAD** (`0d3e3376b289c`). The bug existed in
this lineage until that commit; current HEAD already has the fix. That
is the mainline landing, not a reason to reject it as a stable
candidate.

**Step 6.2: BACKPORT COMPLICATIONS**

Record: Clean apply on this file. Context (`quirks`, `rstc`,
`init_pl330_debugfs`, `pl330_remove`) has been stable. Expected **clean
apply** to trees that still have the v5.2 debugfs code.

**Step 6.3: RELATED FIXES ALREADY HERE**

Record: This commit is the fix. No earlier alternative fix on `pl330.c`.

---

## Phase 7: Subsystem context

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **dmaengine / ARM PL330** (`drivers/dma/pl330.c`). **IMPORTANT**
for ARM SoCs that use PrimeCell DMA (not core mm/net). Enabled as
`CONFIG_PL330_DMA=y` in `arm64/defconfig`, `multi_v7`, `exynos`,
`socfpga`, `hisi`, `axm55xx`.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Mature driver (since ~2010). Recent commits are small fixes, not
a rewrite.

---

## Phase 8: Impact and risk

**Step 8.1: WHO IS AFFECTED**

Record: Driver-specific + `CONFIG_DEBUG_FS`. Population: ARM/ARM64
boards with PL330 (Exynos and others). Built-in in several defconfigs,
so unbind is less common than for a typical module, but sysfs unbind and
`rmmod` (tristate) still exist.

**Step 8.2: TRIGGER CONDITIONS**

Record: Bind PL330 with debugfs on → unbind or unload → read leftover
`/sys/kernel/debug/<devname>`. Not every boot. Root-oriented (debugfs).
Race-free UAF after teardown; concurrent read during remove is handled
by debugfs `active_users`.

**Step 8.3: FAILURE MODE SEVERITY**

Record: **Use-after-free → oops / KASAN / potential memory corruption.**
Severity **HIGH**. debugfs is usually root-only, so not a typical
unprivileged CVE path, still a real crash/UAF.

**Step 8.4: RISK-BENEFIT**

Record:
- **Benefit:** medium-high for PL330 + debugfs users (prevents UAF on
  teardown).
- **Risk:** very low (~19 lines, one driver, standard `debugfs_remove`).
- **Ratio:** favorable.

---

## Phase 9: Synthesis

**Step 9.1: EVIDENCE**

**For:**
- Real UAF: debugfs private data outlives `pl330` / `channels`
- Show callback indexes `pl330->channels[ch]` after `kfree`
- Small, obviously correct, matches other DMA drivers
- Maintainer applied v1
- `debugfs_remove()` waits for active readers
- Bug present since v5.2; driver is in this tree

**Against:**
- No user/syzbot report (inspection-only)
- Needs `CONFIG_DEBUG_FS` and unbind/unload
- debugfs typically root-only
- No `Fixes:` / `Cc: stable` (not a negative per the review rules)

**Unresolved:** stable@ lore search (HTTP 403).

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — standard debugfs lifetime;
   maintainer applied.
2. Real bug affecting users? **PASS** — leftover file + UAF on read
   after remove.
3. Important (crash/security/corruption/deadlock)? **PASS** — UAF/oops.
   HIGH, not a hot-path panic.
4. Small and contained? **PASS** — one file, +16/-3.
5. No new features/APIs? **PASS**
6. Can apply to the local tree? **PASS** — same file/functions; already
   landed here as the upstream commit.

**Step 9.3: EXCEPTION CATEGORIES**

Record: None (not an ID/quirk/DT/build/docs exception). Ordinary bug
fix.

**Step 9.4: DECISION**

This is a contained UAF fix in a long-shipped ARM DMA driver. The local
v7.3-rc4 tree has the PL330 debugfs code; the change is the right stable
material (crash/UAF, tiny, no new API). Missing reports and debugfs-only
trigger do not outweigh that.

---

### What the commit solves

`init_pl330_debugfs()` created `/sys/kernel/debug/<dev>` with `pl330` as
private data and never removed it. `pl330_remove()` then freed
`pl330->channels` and let `devm` free `pl330`. A later debugfs read is a
use-after-free. The patch stores the dentry and removes it first;
`debugfs_remove()` drains active readers.

### Stable rules

Meets them: real UAF, small, no new API, applies to this driver’s
existing debugfs code.

### Risk vs benefit

Benefit is preventing oops/UAF after PL330 teardown. Risk is very low.

### Concerns

No `Fixes:` tag (introducer is `b45aef3aef636` / v5.2). No mailing-list
stable nomination. Trigger is unbind/unload + debugfs. None of that
blocks backport.

---

Verification:
- [Phase 1] Parsed tags: Link to msgid
  `20260615091645.28878-1-pengpeng@iscas.ac.cn`; SOBs Hou + Vinod Koul;
  no Fixes/Reported-by/Cc stable
- [Phase 1] Body describes create-without-remove and show-callback
  lifetime
- [Phase 2] Diff: `drivers/dma/pl330.c` +16/-3; `dbgfs` field;
  `deinit_pl330_debugfs` in `pl330_remove` before teardown
- [Phase 2] Pre-patch `init_pl330_debugfs` discarded
  `debugfs_create_file()`; `pl330_remove` had no remove
- [Phase 2] `pl330_probe`: `devm_kzalloc` for `pl330`; `pl330_del` →
  `kfree(pl330->channels)`
- [Phase 2] `fs/debugfs/inode.c`: `debugfs_remove` handles
  `IS_ERR_OR_NULL`; waits on `active_users`
- [Phase 3] `git blame` / `git log -S init_pl330_debugfs --
  drivers/dma/pl330.c`: introducer `b45aef3aef636` (v5.2-rc1)
- [Phase 3] `git merge-base --is-ancestor b45aef3aef636 HEAD` and
  `0d3e3376b289c HEAD`: both true
- [Phase 3] `git log --oneline -20 -- drivers/dma/pl330.c`: no
  prerequisite series
- [Phase 3] Author log on `drivers/dma/`: only this commit
- [Phase 4] `b4 dig -c 0d3e3376b289c`: lore match at the msgid above
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Vinod Koul, Frank Li, dmaengine@, linux-kernel@
- [Phase 4] mbox: Vinod applied as `0d3e3376b289c`; sashiko comments
  were pre-existing, not a NAK of this fix
- [Phase 4] lore HTTP 403; stable@ search 403 — UNVERIFIED via
  WebFetch/curl
- [Phase 5] Callers: probe → init; remove → deinit; show via debugfs
- [Phase 5] Same debugfs-remove pattern in other `drivers/dma/*` files
- [Phase 6] `git describe HEAD` / Makefile: v7.3-rc4; `pl330.c` present;
  fix already on HEAD
- [Phase 7] `CONFIG_PL330_DMA` in
  arm64/multi_v7/exynos/socfpga/hisi/axm55xx defconfigs
- [Phase 8] Failure mode: UAF on leftover debugfs read after remove,
  severity HIGH
- UNVERIFIED: whether stable@ ever discussed this patch (HTTP 403)

**YES**

 drivers/dma/pl330.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 82a9fe88ad54c..fe4d266ee611c 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -502,6 +502,7 @@ struct pl330_dmac {
 	struct dma_pl330_chan *peripherals; /* keep at end */
 	int quirks;
 
+	struct dentry		*dbgfs;
 	struct reset_control	*rstc;
 	struct reset_control	*rstc_ocp;
 };
@@ -2958,14 +2959,24 @@ DEFINE_SHOW_ATTRIBUTE(pl330_debugfs);
 
 static inline void init_pl330_debugfs(struct pl330_dmac *pl330)
 {
-	debugfs_create_file(dev_name(pl330->ddma.dev),
-			    S_IFREG | 0444, NULL, pl330,
-			    &pl330_debugfs_fops);
+	pl330->dbgfs = debugfs_create_file(dev_name(pl330->ddma.dev),
+					   S_IFREG | 0444, NULL, pl330,
+					   &pl330_debugfs_fops);
+}
+
+static inline void deinit_pl330_debugfs(struct pl330_dmac *pl330)
+{
+	debugfs_remove(pl330->dbgfs);
+	pl330->dbgfs = NULL;
 }
 #else
 static inline void init_pl330_debugfs(struct pl330_dmac *pl330)
 {
 }
+
+static inline void deinit_pl330_debugfs(struct pl330_dmac *pl330)
+{
+}
 #endif
 
 /*
@@ -3211,6 +3222,8 @@ static void pl330_remove(struct amba_device *adev)
 	struct dma_pl330_chan *pch, *_p;
 	int i, irq;
 
+	deinit_pl330_debugfs(pl330);
+
 	pm_runtime_get_noresume(pl330->ddma.dev);
 
 	if (adev->dev.of_node)
-- 
2.53.0

