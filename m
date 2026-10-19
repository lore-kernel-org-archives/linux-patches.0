Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F5653FA34;
	Mon, 19 Oct 2026 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418741; cv=none; b=OWNa0+NV0SKfkkF4orqVMXJL+k2+rccxt15wkV47Mon3qrLSIryCvcBvQXl1rW7mULBq+sg6ama20q/7NmlonrH8rGpGltuH1Du5i8QpPonPKKdVHdlLvuX1avDXP8twDKei5LVhOCmeMwitnKu3onFtzMXWXZQdfytF0TP1Btg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418741; c=relaxed/simple;
	bh=ItiaHpscuhLnvEU67e6Y4Sr5/bGI3Pbtxayik5HC9Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c/i/wJRYksWJ0xhrKlhcag4M+MiGMXu9Zj8NxZeJNcFCbYR8kIhOxHRgT2hAIaMCxvY3eC8eb5ADe4HxbSRQynLSRI3L9fXlOj7rdGKOZKK8M1DWAbB14SdhEJryqUL3itUaeqYrvBVacflKV9tMakna3V3LVYEsxjP0QeKn4qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JnAFN8Cs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnAFN8Cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDAF1F000C8;
	Mon, 19 Oct 2026 14:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418739;
	bh=LCK6HzOGftkUfxabSJI1PrQfGr8GFb458mN9VeUB30k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnAFN8CsBjqT1I9q339vBlRTKeNyLHONguQGmeVKtFkrTHqxo3WiJddoHqiBTiXUN
	 HkicvSz4oFzsSwRl/K15W104V9L8vnYwnQhXo39ftkfaHh9EHKLyT4oux26ar//mfH
	 q9uDwZ8ZvAg0u4w3Yr51xl3Npvh/h0/CCi2iTqjcI/h5Y1+1R47obn2GkN23mwUWv2
	 QkOe1/X8n087DL5MzCKLRm8v12VTwz3RiflpQhtT3fEP1UXj6BdV67kB3OF/debpF3
	 NupCjOyEDjQlKGHhFIfHFhoad/yibbbSXnrt22lz4B6rzQ1TeJYizRJVF1jHVBvVyH
	 o/L1RIM051jJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/amdgpu/atomfirmware: WARN() rather than BUG()
Date: Mon, 19 Oct 2026 09:52:32 -0400
Message-ID: <20261019135441.1420968-461-sashal@kernel.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit d7c595044965c826e6f3ce30590d3ec4399cd633 ]

There's no need to crash the kernel for this case.  Just
return an error.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[drm/amdgpu/atomfirmware] [WARN rather than BUG / return an
  error] [stop panicking the kernel on an unexpected VBIOS gfx_info
  revision]`

**Step 1.2: Tags**
- Record:
  - `Reviewed-by: Kent Russell <kent.russell@amd.com>` (added at commit
    time; not on the mailed v1 patch)
  - `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (author;
    amdgpu maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Acked-by:`, `Link:`, or
    `Cc: stable` (absence expected)
  - Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
    ignored per instructions

**Step 1.3: Body**
- Record:
  - Bug: `BUG()` on an unexpected atom `gfx_info` firmware revision in
    `amdgpu_atomfirmware_get_clock_info()`.
  - Symptom: whole-machine kernel crash during AMDGPU init.
  - Author intent: do not crash; “just return an error.”
  - No stack trace, reproducer, or version range in the message.
  - Actual diff does **not** add `WARN()` and does **not** set `ret =
    -EINVAL`; it only deletes the `else { BUG(); }`.

**Step 1.4: Hidden bug fix?**
- Record: Not hidden. It is an explicit crash-prevention change.
  Title/body oversell the implementation (no `WARN()`, no explicit error
  return).

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: `drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c` — **2 lines
  deleted, 0 added**. Function: `amdgpu_atomfirmware_get_clock_info()`.
  Single-file surgical change.

**Step 2.2: Code flow**
- Record: On Navi+ (`asic_type >= CHIP_NAVI10`), after a successful
  `gfx_info` header parse:
  - **Before:** known revisions (`frev==3`, or `frev==2 && crev==6`, or
    `frev==2 && crev>=2 && crev!=6`) set `spll->reference_freq` and
    `ret=0`. Any other `(frev,crev)` hit `BUG()` and panics.
  - **After:** unknown revisions fall through. `ret` stays whatever
    earlier `firmwareinfo` / `smu_info` / `umc_info` parsing left (`0`
    if those succeeded, else `-EINVAL`). No panic.

**Step 2.3: Bug mechanism**
- Record: **Logic / correctness + crash prevention.** `BUG()` used as an
  “unknown firmware table” assert in a driver probe path. Firmware is
  independent of the kernel; an unknown or newer table must not take
  down the box. Sibling `amdgpu_atomfirmware_get_gfx_info()` already
  returns `-EINVAL` for unknown revisions; this path was the
  inconsistent panic.

**Step 2.4: Fix quality**
- Record: Minimal and obviously safe (only removes a panic). Regression
  risk is very low. Residual nit: unknown tables no longer fail the
  function if earlier tables parsed, so init can continue with the
  `smu_info` reference clock instead of failing probe. That matches the
  pre-`BUG()` behavior from 2021 and is still far better than panicking.
  Message/subject mismatch is cosmetic, not a functional defect.

---

## Phase 3: Git history

**Step 3.1: Blame**
- Record: `BUG()` added in `a8d59943b8846` (“drm/amdgpu: update query
  ref clk from bios”, Hawking Zhang, 2022-04-28) when adding
  `atom_gfx_info_v3_0`. `git describe` =
  `v5.17-rc6-1819-ga8d59943b8846`. `git merge-base --is-ancestor` vs
  tags: **not in v5.18, is in v5.19**. Navi+ clock override itself came
  from `9a530062d57fe` (Aaron Liu, 2021; `v5.12-rc7-1827`), which did
  **not** `BUG()` — unknown versions just skipped the override.

**Step 3.2: Fixes: tag**
- Record: None. Introducer is `a8d59943b8846` as above. That commit is
  an ancestor of this HEAD.

**Step 3.3: File history**
- Record: Latest change on this file in HEAD is this commit. No follow-
  up on the same function. Standalone; not a functional 2/3 dependency.

**Step 3.4: Author**
- Record: Alex Deucher is the amdgpu maintainer. Same-day series
  converted many amdgpu `BUG()`/`BUG_ON()` sites. Related file commits
  are unrelated vram/firmware table work.

**Step 3.5: Prerequisites**
- Record: None. Only deletes two lines of existing `BUG()`. Applies
  standalone wherever that `else { BUG(); }` exists.

---

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `b4 dig -c d7c595044965c` → `[PATCH 18/43]
  drm/amdgpu/atomfirmware: WARN() rather than BUG()`
  https://patch.msgid.link/20260615235645.737189-18-
  alexander.deucher@amd.com
  - `b4 dig -a`: **v1 only** of a 43-patch June 15 2026 series. Resent
    as `[PATCH 05/30]` on 2026-07-07 (same diff).
  - Thread has no technical NAK. Only a ping from Alex on 01/43.
  - No reviewer-requested `Cc: stable` found in the mbox.
  - Committed version matches mailed diff (2-line deletion).

**Step 4.2: Recipients**
- Record: `b4 dig -w`: `Alex Deucher`, `amd-gfx@lists.freedesktop.org`
  only. Kent Russell’s `Reviewed-by` was added at commit, not on the
  mailed patch.

**Step 4.3: Bug report**
- Record: No `Reported-by`, syzbot, or bugzilla. No evidence of a user
  hitting this `BUG()` in the last four years.

**Step 4.4: Series context**
- Record: Independent one-file `BUG()` removals. Pull text for drm-
  next-7.3 lists this under “Old BUG() and BUG_ON() removal.” drm-
  fixes-7.2 took an earlier batch described as “Drop unnecessary BUG()
  and BUG_ON() from error paths.” This commit landed in **drm-next for
  7.3** (`git describe d7c595044965c` = `v7.2-rc2-1048-gd7c595044965c`).

**Step 4.5: Stable list**
- Record: lore.kernel.org/stable fetch returned 403. **UNVERIFIED**
  whether stable@ discussed this specific patch. No `Cc: stable` on the
  submission.

---

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
- Record: `amdgpu_atomfirmware_get_clock_info()` only. semcode MCP not
  available; used grep / read.

**Step 5.2: Callers**
- Record: Sole caller `amdgpu_device.c` (~4085), during device init when
  `adev->bios && adev->is_atom_fw`. `is_atom_fw` is set for `asic_type
  >= CHIP_VEGA10`. Failure currently logs and `goto failed` (probe
  abort). Not IRQ, not a syscall hot path. Runs once per GPU at
  boot/module load.

**Step 5.3: Callees**
- Record: `get_index_into_master_table`,
  `amdgpu_atom_parse_data_header`, `le32_to_cpu` on VBIOS tables. No
  alloc/lock in the changed hunk.

**Step 5.4: Reachability**
- Record: Yes, from normal boot on Vega10+ with atom firmware. The
  `BUG()` itself only ran for Navi+ (`CHIP_NAVI10` and later — RX 5700
  and essentially all later AMD GPUs) **and** an unrecognized `gfx_info`
  `(frev,crev)`. Current headers only define v2.2 / v2.3 / v2.4 / v2.7 /
  v3.0, all of which the `if`/`else if` already accept (`frev==2 &&
  crev>=2` or `frev==3`). So the panic path is **firmware-mismatch /
  corruption / future table**, not day-1 shipping VBIOS.

**Step 5.5: Similar patterns**
- Record: Same author, same series: imu11/12, ucode, cgs, gfx11/12 SDMA,
  etc. `get_gfx_info()` in this file already used `-EINVAL` instead of
  `BUG()`.

---

## Phase 6: This checkout

**Step 6.1: Does the buggy code exist here?**
- Record: Local tree is **v7.3-rc4** (`VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
  EXTRAVERSION=-rc4`, HEAD `f0100363d8c37`). `git merge-base --is-
  ancestor d7c595044965c HEAD` → yes. Current source already has the
  `BUG()` removed (lines 911–920). The panic existed in this lineage
  from **v5.19** until this commit (**v7.2-rc2+**).

**Step 6.2: Backport difficulty**
- Record: Clean 2-line deletion against the pre-image. No structural
  prerequisites.

**Step 6.3: Related fixes already here**
- Record: This **is** the fix; no alternate fix. No later revert or
  follow-up on this function.

---

## Phase 7: Subsystem context

**Step 7.1:** Record: `drm/amdgpu` atom firmware parser. **IMPORTANT**
(very common GPUs), not core mm/VFS.

**Step 7.2:** Record: High activity; this particular function has been
stable since the 2022 v3.0 clock change aside from this `BUG()` removal.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Users of amdgpu on Navi+ (RDNA and later), i.e. a large
  fraction of AMD GPU systems, **if** VBIOS `gfx_info` revision is not
  one of the known cases.

**Step 8.2: Trigger**
- Record: GPU probe. Not unprivileged syscall. Needs Navi+ **and**
  unknown `gfx_info` frev/crev (corrupt VBIOS, unexpected vendor
  firmware, or a newer table the driver was never taught). Common-path
  shipping firmware does not hit it; firmware is still out of the
  kernel’s control.

**Step 8.3: Failure mode**
- Record: `BUG()` → kernel panic during device init. **Severity:
  CRITICAL if triggered, LOW likelihood on known VBIOS.** After the fix,
  unknown tables skip the gfx_info clock override and typically still
  return success from earlier tables.

**Step 8.4: Risk-benefit**
- Record: Benefit medium-high (prevents a machine-killing assert in
  firmware parse). Risk very low (2-line deletion, no locking/API/data-
  structure change). Ratio favors applying it.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

**For backporting**
- `BUG()` in driver init panics the whole system; kernel policy
  (`Documentation/process/coding-style.rst`, `deprecated.rst`) says not
  to do this.
- Path is real GPU probe for all modern AMD GPUs; firmware tables can
  change independently of the kernel.
- 2-line deletion, obviously correct, no new API.
- Sibling function already errors instead of panicking.
- Restores the pre-v5.19 “don’t panic” behavior.
- Maintainer-authored, Reviewed-by Kent Russell.
- Zero practical regression surface.

**Against**
- No user report in ~4 years; known table versions are all handled, so
  the `else` is effectively a developer assert.
- Part of a 43-patch “drop old BUG()s” sweep; pull described it as
  cleanup, and it went to drm-next-7.3, not drm-fixes.
- Subject/body promise `WARN()` + error return; the patch does neither.
- After the change, unknown tables can return 0 with the smu_info clock
  rather than failing probe.

**Unresolved**
- Stable@ discussion unverified (lore 403).
- No public confirmation this `BUG()` ever fired on shipping hardware.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — 2-line deletion; maintainer
   + reviewer.
2. Real bug affecting users? **PASS** — panicking on unknown firmware is
   a real driver bug; firmware is untrusted/variable even if reports are
   absent.
3. Important (crash/security/corruption/deadlock)? **PASS** — failure
   mode is a kernel panic. Likelihood is low, severity is high.
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — the hunk exists in this lineage;
   the tree already contains the commit (`d7c595044965c`).

**Step 9.3: Exceptions**
- Record: None (not a device ID, quirk, DT, build, or doc fix).
  Qualifies on the crash-prevention rule, not an exception category.

**Step 9.4: Decision**

This tree is **v7.3-rc4**. The change is a two-line removal of a `BUG()`
in Navi+ VBIOS clock parsing. That assert can panic the machine during
amdgpu init if `gfx_info` is an unknown revision. That is the wrong
failure mode for firmware the kernel does not control. The patch is
trivial, standalone, and does not add features. Lack of a crash report
and the series being a BUG() cleanup do not outweigh a panic in GPU
probe.

It meets the stable criteria for this tree: real crash fix, small,
obviously correct, no dependencies.

---

## What the commit solves for stable users

On Navi and later, `amdgpu_atomfirmware_get_clock_info()` used `BUG()`
when the VBIOS `gfx_info` table had a revision the driver did not list.
That is a full kernel panic during device init. Stable systems keep a
GPU for years while VBIOS/firmware can still change; panicking instead
of skipping the override (or failing probe) is the bug. The fix only
deletes that `BUG()`.

Risk vs benefit: benefit is avoiding a boot-time panic; risk is
essentially none. The leftover behavior (continue with the smu_info
clock, no `WARN()`) is slightly sloppy versus the commit text, but it is
the old safe path from before v5.19 and is acceptable for stable.

---

## Verification
- [Phase 1] Parsed tags: Reviewed-by Kent Russell, SOB Alex Deucher; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Body claims WARN + return error; `git show d7c595044965c` is
  only `- } else {` / `- BUG();`
- [Phase 2] Diff: 2 deletions in `amdgpu_atomfirmware_get_clock_info()`
- [Phase 2] Read current function: `ret` starts `-EINVAL`; earlier
  tables set `ret=0`; unknown gfx_info no longer panics
- [Phase 3] `git blame` on parent: `BUG()` from `a8d59943b8846`
  (2022-04-28)
- [Phase 3] `git merge-base --is-ancestor a8d59943b8846 v5.18` → 1
  (absent); vs v5.19 → 0 (present)
- [Phase 3] Pre-BUG code in `9a530062d57fe` did not panic on unknown
  revisions
- [Phase 3] `git merge-base --is-ancestor d7c595044965c HEAD` → 0
  (commit is in this tree)
- [Phase 4] `b4 dig -c d7c595044965c` → lore/msgid
  20260615235645.737189-18; 18/43 series
- [Phase 4] `b4 dig -a`: v1 only; later resent as 05/30 with identical
  diff
- [Phase 4] `b4 mbox`: 44 messages, no NAK, no stable nomination; Kent
  review not on the mailed patch
- [Phase 4] `b4 dig -w`: To/Cc Alex Deucher + amd-gfx only
- [Phase 4] lore.kernel.org and lore stable search: HTTP 403 —
  UNVERIFIED
- [Phase 5] grep: only caller is `amdgpu_device.c` init when
  `is_atom_fw`; `is_atom_fw` set for Vega10+
- [Phase 5] `atomfirmware.h`: gfx_info structs v2.2, v2.3, v2.4, v2.7,
  v3.0 only — no v4
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] `git describe d7c595044965c` =
  `v7.2-rc2-1048-gd7c595044965c`
- [Phase 6] Current file lines 911–920: no `BUG()`
- [Phase 8] Failure mode: `BUG()` panic on GPU init — CRITICAL if hit
- UNVERIFIED: whether this `BUG()` has ever fired on shipping VBIOS;
  whether stable@ already considered it

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
index c7d32fb216e4e..ce2a4a15d5ecb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -806,8 +806,6 @@ int amdgpu_atomfirmware_get_clock_info(struct amdgpu_device *adev)
 				   (crev != 6)) {
 				spll->reference_freq = le32_to_cpu(gfx_info->v22.rlc_gpu_timer_refclk);
 				ret = 0;
-			} else {
-				BUG();
 			}
 		}
 	}
-- 
2.53.0

