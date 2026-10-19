Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7D55CFA4B;
	Mon, 19 Oct 2026 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418485; cv=none; b=AF/m9yseKxKekVDJ4jSl91TqQkckyEN0cNDLxThzoUzk34G5MNRA9RcxyQhrUv1DYQjAhwuuFP4XabtteZ5FU1WFT1iJbVFzGssoCcMY67XbUYggZjp7QCA3jXPJxYL8eJBksOahJbSITzb/UJ5TghJ/r6QZkcP8tkB+4HdyU8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418485; c=relaxed/simple;
	bh=3zkUz8vKBzJk2PcRoTlwHiicQys/aPwdESXGrkdBgUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATFh1j9o1ZabuGDVEITe8BJZyN3yVH8Cd5BLKjJCJsvZURpcbsT0tptveWSa/aAdHhJgMq8NPQqe7VXeEZToulGY6A6WxjrqLfRoKfmjMdJ1V2v2LxfZ6eqj2NgNh4MJcQFTl2vjI04iaa+sHg6eURo5tNPVw4wtjPyMX7qQ8pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLaW5l9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLaW5l9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41AF1F000C9;
	Mon, 19 Oct 2026 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418482;
	bh=DTgVlcXPob2+dJEyJG/7iG8jOR3jrppL3zma4P8Fiac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLaW5l9Me1Tf9sLH0wnpLAMLPMxpWzrirJZldUHpvhH9GaF5HegleTxLQe6zaxZi9
	 cZQESWAZRhZeKtdpwURKL2YIRuyp1l76wSq90CNI43yyyrPARQAkfrlgMlM+mg7cVP
	 G+qVfZVhcFmHbd8MUpGuEz9/AlX+IbordWwvJsDEeJpJaSnDYia8O/NvNFLJXnV618
	 VkkYoDtQu8gK5gamlr7FP5MFWAhLNBn6sZsQZ46yTouP+WYc0o15/KkM/hNVfZS1jK
	 PDzSl96YTWNGGaj9okDOmj873whBLusCfv8HJ96VI8Rf1hS+Syshugr2vpOZtRo3sc
	 nMbeULERc0XXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] mmc: block: reject invalid perdev_minors before division
Date: Mon, 19 Oct 2026 09:49:31 -0400
Message-ID: <20261019135441.1420968-280-sashal@kernel.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 5253aee00a4383cb0482d5e99bde48b8054ae2c0 ]

The mmcblk.perdev_minors module parameter is parsed as a signed int and
is used during mmc_blk_init() to compute the number of supported block
devices.

Passing perdev_minors=0 makes the init path divide by zero when it
computes max_devices. Negative values are invalid as well and would make
max_devices negative before it is later used as an IDA limit.

Reject non-positive perdev_minors values before registering any mmcblk
resources.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the bug mechanism, history, and review thread. Compiling the
nine-phase verdict for this 7.3-rc4 tree.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: **[mmc/block] [reject] reject invalid `perdev_minors` before
  division**
- Subsystem: `mmc: block:`. Verb: **reject** (guard / prevent invalid
  input). Intent: do not use a non-positive module parameter as a
  divisor.

**Step 1.2: Tags**
- Record:
  - `Signed-off-by: Xu Rao <raoxu@uniontech.com>` (author)
  - `Signed-off-by: Ulf Hansson <ulfh@kernel.org>` (MMC maintainer;
    committed 2026-07-10)
  - **No** `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`,
    `Acked-by:`, `Link:`, or `Cc: stable@vger.kernel.org`
  - Absence of `Fixes:` / `Cc: stable` is expected for this review and
    is not a negative signal
- SHA in this tree: `5253aee00a4383cb0482d5e99bde48b8054ae2c0`

**Step 1.3: Body**
- Record:
  - **Bug:** `mmcblk.perdev_minors` is a signed `int` module parameter.
    `mmc_blk_init()` computes `max_devices` as `(1 << MINORBITS) /
    perdev_minors`.
  - **Symptoms:** `perdev_minors=0` → divide-by-zero in init. Negative
    values → negative `max_devices`, later used as an IDA upper bound.
  - **Version info:** none in the message.
  - **Root cause:** no validation before division / IDA use. Fix: reject
    `<= 0` before registering any mmcblk resources.

**Step 1.4: Hidden bug fix?**
- Record: **No disguise.** This is an explicit crash/UB fix, not
  cleanup-as-fix.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record:
  - File: `drivers/mmc/core/block.c` — **+5 / −0**
  - Function: `mmc_blk_init()`
  - Scope: **single-file surgical fix**

**Step 2.2: Code flow**
- Record: **Before:** `mmc_blk_init()` registers the RPMB bus and chrdev
  region, then does `max_devices = min(MAX_DEVICES, (1 << MINORBITS) /
  perdev_minors)` with no check. **After:** if `perdev_minors <= 0`, log
  and `return -EINVAL` **before** any of those registrations (no leak on
  the new error path).

Verified parent of the fix (no check):

```
max_devices = min(MAX_DEVICES, (1 << MINORBITS) / perdev_minors);
```

**Step 2.3: Bug mechanism**
- Record: **Logic / correctness + memory-safety (div-by-zero, invalid
  IDA limit)**
  - `perdev_minors == 0`: integer division by zero in `mmc_blk_init()`
    (oops / exception on init).
  - `perdev_minors < 0`: signed division yields a negative
    `max_devices`; `ida_alloc_max(..., max_devices - 1, ...)` takes
    `unsigned int max`, so the negative value **wraps** to a huge limit
    (`include/linux/idr.h`). Probe then uses `devidx * perdev_minors`
    for `first_minor`.
  - Same divisor is also used in `mmc_get_devidx()` (`disk->first_minor
    / perdev_minors`).

**Step 2.4: Fix quality**
- Record: **Obviously correct and minimal.** Matches Kconfig
  (`MMC_BLOCK_MINORS` range 4–256). Valid defaults (8) unchanged.
  Regression risk **very low**: only rejects values that already crash
  or mis-size the IDA. Early return happens before `bus_register`, so no
  new leak.

## Phase 3: Git history

**Step 3.1: Blame**
- Record:
  - `perdev_minors` module param: `5e71b7a64cb4c` (“mmc: make number of
    mmcblk minors configurable”, Olof Johansson, 2010) —
    **v2.6.37-rc1**.
  - Division `(1 << MINORBITS) / perdev_minors`: `a26eba614afff0` (“mmc:
    block: Increase max_devices”, Ben Hutchings, 2014) — **v3.19-rc1**.
  - Bug is over a decade old in this lineage, not new 7.x code.

**Step 3.2: Fixes: tag**
- Record: **No `Fixes:` tag.** Introducing commits above are in this
  tree (ancient ancestors of HEAD).

**Step 3.3: File history**
- Record: Recent `block.c` work is unrelated (RPMB unregister, MQ
  retry). `git log --grep=perdev_minors -- drivers/mmc/` shows only this
  fix plus old param/prefix commits. **Standalone, not a series.** No
  follow-ups on `block.c` after `5253aee`.

**Step 3.4: Author**
- Record: Xu Rao has one other recent MMC commit (`mmc: spi: reset
  bytes_xfered...`). Not the subsystem maintainer. **Ulf Hansson** (MMC
  maintainer) applied it.

**Step 3.5: Dependencies**
- Record: **None.** The check uses existing `perdev_minors` and
  `pr_err`. Applies on its own.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `b4 dig -c 5253aee00a438` matched patch-id
  `291b9622c960b2f250c74c590d7e9916013372a3`.
  - Lore/msgid: `https://patch.msgid.link/C7A17066496D0ABA+2026070609250
    1.853376-1-raoxu@uniontech.com`
  - **v1 only** (`b4 dig -a`); committed version is that v1.
  - Ulf Hansson (10 Jul 2026): **“Applied for next, thanks!”** — no NAK,
    no requested respin.
  - Direct lore.kernel.org fetch returned **403**; thread confirmed via
    b4 + LKML/openwall mirrors.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: `ulfh@kernel.org`, `linux-mmc@vger.kernel.org`, Avri Altman,
  Bean Huo, Shawn Lin, Jens Wiklander, **Kees Cook**, plus others.
  Maintainer was To: and merged the patch. No reviewer `Reviewed-by` in
  git.

**Step 4.3: Bug report**
- Record: **No `Reported-by` / syzbot / bugzilla.** Author describes the
  mechanism; no public crash log found.

**Step 4.4: Series**
- Record: **Standalone single patch**, not N/M.

**Step 4.5: Stable list**
- Record: Web search of `lore.kernel.org/stable` for `perdev_minors` did
  **not** turn up a nomination or a rejection of this patch. Direct lore
  fetch was 403. **UNVERIFIED** that nobody ever asked stable@; no
  evidence of a known NAK for stable either.

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
- Record: **`mmc_blk_init` only** (plus it protects later use of
  `perdev_minors` in `mmc_get_devidx`, `mmc_blk_alloc_req`,
  `mmc_blk_alloc_rpmb_part`).

**Step 5.2: Callers**
- Record: `module_init(mmc_blk_init)` only — boot (builtin,
  `CONFIG_MMC_BLOCK=y` default) or `modprobe mmcblk`. Not a hot path,
  not IRQ, not a syscall except via privileged module load / kernel
  cmdline.

**Step 5.3: Callees**
- Record: After the new check: `bus_register`, `alloc_chrdev_region`,
  `register_blkdev`, `mmc_register_driver`. The new path calls none of
  these.

**Step 5.4: Reachability**
- Record: **Yes, from admin/boot configuration.**
  `module_param(perdev_minors, int, 0444)` — set at load
  (`mmcblk.perdev_minors=0`) or on the kernel command line if builtin.
  **Not** writable later (0444). **Unprivileged users cannot set it** on
  a normal system. Kconfig `range 4 256` cannot produce 0; only the
  module/boot param can.

**Step 5.5: Similar patterns**
- Record: `perdev_minors` exists only in this file. No sibling mmc
  driver with the same hole. Pattern is the usual “signed module_param
  used as divisor without a positivity check.”

## Phase 6: This checkout

**Step 6.1: Buggy code in this tree?**
- Record:
  - `git describe HEAD` → **`v7.3-rc4-27-gf0100363d8c37`**
  - `make kernelversion` → **7.3.0-rc4**
  - The mmc block driver and the division **are present**. The
    **unfixed** sequence is the parent of `5253aee`; **HEAD already
    contains the fix** (`git merge-base --is-ancestor 5253aee00a438
    HEAD` → yes).
  - Commit first landed via MMC for **v7.3** (`git describe 5253aee` →
    `v7.2-rc2-25-g5253aee00a438`; **not** an ancestor of `v7.2`). Bug
    **introduction** is v3.19-era, long before this branch.
  - Being an ancestor of this mainline/rc HEAD is expected for a
    candidate; it is not “already selected for stable.”

**Step 6.2: Backport difficulty**
- Record: **Clean apply on this tree** (hunk matches `mmc_blk_init`
  exactly). No extra helpers required.

**Step 6.3: Related fixes already here**
- Record: This **is** the fix. No alternate/earlier validation of
  `perdev_minors`. No follow-up revert.

## Phase 7: Subsystem context

**Step 7.1:**
- Record: **`drivers/mmc/core` (MMC block)** — **IMPORTANT** (eMMC/SD
  block devices; `CONFIG_MMC_BLOCK` defaults to `y`). Not core mm/VFS,
  not staging.

**Step 7.2:**
- Record: File is actively maintained (RPMB, MQ recovery, etc.). The
  **bug site** (`max_devices = … / perdev_minors`) has been stable since
  2014.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Users of `mmcblk` who pass **`mmcblk.perdev_minors=0` or a
  negative value** (cmdline or `modprobe`). Default Kconfig path is
  fine. Population: **config/admin-specific**, not universal.

**Step 8.2: Trigger**
- Record: One-shot at `mmc_blk_init`. **Not** timing-dependent. **Not**
  triggerable by an unprivileged syscall on a typical system.
  Commonness: **low** (must override a param whose Kconfig range is
  already 4–256).

**Step 8.3: Failure mode**
- Record:
  - `= 0`: divide-by-zero → **oops / exception during MMC block init**.
    Builtin + `panic_on_oops` → boot failure; otherwise mmcblk fails and
    eMMC/SD never appear (root-on-eMMC can fail to boot).
  - `< 0`: negative `max_devices` → **unsigned wrap in
    `ida_alloc_max`**, wrong minors, possible further corruption of
    device numbering.
  - Severity: **HIGH** if triggered (crash / failed storage), **MEDIUM
    overall** because the trigger is an invalid privileged parameter.

**Step 8.4: Risk–benefit**
- Record: **Benefit: high for a tiny hardening/crash fix** (prevents
  init oops; clean `-EINVAL`). **Risk: very low** (5 lines, error path
  only, no API/lock/struct change). Ratio: **favorable**.

## Phase 9: Synthesis

**Step 9.1: Evidence**

**For backporting**
- Real divide-by-zero in `mmc_blk_init` when `perdev_minors=0`.
- Negative values produce a negative `max_devices` and wrap in
  `ida_alloc_max()`.
- 5-line, obviously correct check before any resource registration.
- Bug in code since ~v3.19; param since v2.6.37; MMC block present in
  this 7.3-rc4 tree.
- No dependencies; standalone; maintainer applied it with no objections.
- `CONFIG_MMC_BLOCK` is default y — driver is widely built.

**Against**
- No `Reported-by` / syzbot; no evidence of production hits.
- Trigger is privileged (boot arg / `modprobe`), param is 0444.
- No `Reviewed-by`; v1 merged as-is.
- Not a hot-path race or unprivileged UAF.

**Unresolved**
- lore.kernel.org HTTP 403; used b4 + LKML mirrors.
- No hit on stable@ for this subject (search quality limited).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — trivial positivity check;
   maintainer merged to MMC next. No extra Tested-by, but the change is
   reviewable by inspection.
2. Fixes a real bug that affects users? **PASS** — div-by-zero / invalid
   IDA limit if the param is set wrong.
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   oops on init; storage devices never register. Not unprivileged
   security.
4. Small and contained? **PASS** — +5 lines, one function.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — same file/function; no missing
   prereqs.

**Step 9.3: Exception category**
- Record: **None** (not a device ID/quirk/DT/docs-only change). It is a
  normal small bugfix.

**Step 9.4: Decision**

This tree is **7.3.0-rc4**. The MMC block driver and the unvalidated
division exist here; the patch is self-contained and matches local
`mmc_blk_init()`. A 5-line reject of non-positive `perdev_minors`
prevents a real init-time divide-by-zero and a broken IDA limit, with
negligible regression risk. That meets stable-kernel-rules for this
checkout.

### Why it matters here
Invalid `mmcblk.perdev_minors` is enough to oops while bringing up
mmcblk (or to wrap the IDA max). On systems with builtin mmcblk (the
default), that is boot-time. The fix fails init with `-EINVAL` instead.

### Risk vs benefit
Benefit is avoiding a crash/failed MMC probe; risk is a check that does
not run for any Kconfig-legal default.

### Concerns
No in-the-wild report; trigger needs a bad privileged param. That lowers
urgency but does not make the patch unsafe or feature-like. No backport
rework needed on this tree.

---

**Verification:**
- [Phase 1] Parsed message/tags: author + Ulf SOB only; no
  Fixes/Reported-by/Cc stable. SHA `5253aee00a438`.
- [Phase 2] Diff: +5 in `mmc_blk_init()`; `git show
  5253aee^:drivers/mmc/core/block.c` confirmed unvalidated `(1 <<
  MINORBITS) / perdev_minors`.
- [Phase 2] `ida_alloc_max()` in `include/linux/idr.h` takes `unsigned
  int max` — negative `max_devices - 1` wraps (verified).
- [Phase 2] `MINORBITS` is 20 in `include/linux/kdev_t.h` (verified).
- [Phase 2] Kconfig `MMC_BLOCK_MINORS` `range 4 256`, `default 8`;
  `CONFIG_MMC_BLOCK` `default y` (verified).
- [Phase 3] `git blame`: param `5e71b7a64cb4c` (v2.6.37-rc1); division
  `a26eba614afff0` (v3.19-rc1).
- [Phase 3] `git log --grep=perdev_minors -- drivers/mmc/`: this commit
  + old param commits only; no series/follow-up.
- [Phase 3] `git log --author='Xu Rao' -- drivers/mmc/`: this + one
  unrelated spi fix.
- [Phase 4] `b4 dig -c 5253aee00a438`: msgid
  `C7A17066496D0ABA+20260706092501.853376-1-raoxu@uniontech.com`; v1
  only; Ulf CC’d.
- [Phase 4] LKML: Ulf “Applied for next, thanks!” — no NAK.
- [Phase 4] lore.kernel.org WebFetch: **403**. Stable@ search: **no
  relevant thread found**.
- [Phase 5] `mmc_blk_init` only via `module_init`; `module_param(...,
  0444)` — admin/boot only (verified in `block.c`).
- [Phase 5] Call sites of `perdev_minors`: init division,
  `mmc_get_devidx`, `md->disk->minors` / `first_minor` (grep verified).
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = `7.3.0-rc4`.
- [Phase 6] `git merge-base --is-ancestor 5253aee00a438 HEAD` = yes;
  `git merge-base --is-ancestor 5253aee00a438 v7.2` = not in v7.2.
- [Phase 6] HEAD already has the `if (perdev_minors <= 0)` block at
  `block.c:3340` (this is the mainline commit under review, not a
  stable-queue marker).
- [Phase 8] Failure mode: div-by-zero oops at mmcblk init, or IDA limit
  wrap for negatives.
- UNVERIFIED: full lore.kernel.org thread HTML (403); whether stable@
  ever discussed this hash.

**YES**

 drivers/mmc/core/block.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index e8e45b161a398..5077842b286fe 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -3407,6 +3407,11 @@ static int __init mmc_blk_init(void)
 {
 	int res;
 
+	if (perdev_minors <= 0) {
+		pr_err("mmcblk: invalid minors per device: %d\n", perdev_minors);
+		return -EINVAL;
+	}
+
 	res  = bus_register(&mmc_rpmb_bus_type);
 	if (res < 0) {
 		pr_err("mmcblk: could not register RPMB bus type\n");
-- 
2.53.0

