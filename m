Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C3364A888;
	Mon, 19 Oct 2026 14:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418811; cv=none; b=gXzXDlVwFjp2lmJvgy6E+BFhiq54uUsBChpyxNbietHWrTa7xO+N+XU3Ywv175bl+GulhmwT86PrFL/H5xWJiMfacR7sSARwqqJQXUMv9BaVIGLUwOR6BSBbBv9PCC5DSumAZG74kgjQm2NXY1rEqbBnJcMe93LR9b5hMu0shSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418811; c=relaxed/simple;
	bh=7eHM45NPLVbSB2rWEQrIR/3jDdUUMejk7jeUEPqlOqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=goKf0TwP4YTeBlB52ONSjP7iegSh2Af0VVpLs7buxhfhChjnOEo3bFmxvP6Og7OvyKpb98EVfheSgwe7cx0cRqK1hY6+dDlIRV/pWbmnwnhlr/vN2dJE1s9eYsJnC4w10dFm2cG5qB10FBe05R34J5IklMzsHjVmlOctuPzqdwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7pnl4xI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7pnl4xI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4161F000CC;
	Mon, 19 Oct 2026 14:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418807;
	bh=Ka3ZG+0/jaJUIN2HdnBaOl0wFNO/VMkQL9G6JtKgayE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7pnl4xInEy3Y20FiMePeIDiXxrcjlSQM6GOs/EFrOUljgX/ctYT5VJN6IhvUnL1A
	 vR8I8KUZsf1mYMkUlhKgzML9SIXsPH0Q8raUvXd4qTcNL5FoeS3HQY6mumktmjrRHD
	 6rJ8szeHSyBH0xCEvEP0jnJVyNAEsNGxjhthxlzszm111zRgjdKMgt/TcByMtKltag
	 lTs2qop/cIQide1mcU8Zwj5PMdM2fqzmzW/5UykON9BT5LorL1Zn1Qe5XubkhRpDWm
	 tLaHzEyKBgFRUgXXXv9fWMb2plDjMdQ5NUDiAntdCiZqH688dhw0xJ0MST0MZTlBI9
	 XiJVccnVwS9xw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: BingKun Yue <yuebingkun@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] fbdev: platinumfb: add error checking for ioremap calls
Date: Mon, 19 Oct 2026 09:53:21 -0400
Message-ID: <20261019135441.1420968-510-sashal@kernel.org>
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

From: BingKun Yue <yuebingkun@kylinos.cn>

[ Upstream commit ba13226fc966004713aed47931db8922b84d1960 ]

The ioremap() and ioremap_wt() calls in platinumfb_probe() were not
checked for failure. If any of these mappings fail, the driver would
dereference NULL pointers, leading to a kernel panic.

Add proper error checking and use goto-based cleanup to avoid code
duplication across the error paths.

Signed-off-by: BingKun Yue <yuebingkun@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: **[fbdev/platinumfb] [add] error checking for ioremap calls**
- Subsystem: `fbdev: platinumfb`. Action verb: **add** (defensive
  checks). Intent: stop using NULL mappings after failed `ioremap()` /
  `ioremap_wt()`.

**Step 1.2 — Tags**
- Record (committed message):
  - `Signed-off-by: BingKun Yue <yuebingkun@kylinos.cn>` (author)
  - `Signed-off-by: Helge Deller <deller@gmx.de>` (fbdev maintainer)
- Ignored as pipeline noise: any `[Upstream commit ...]` / `Signed-off-
  by: Sasha Levin`.
- Not in the committed message, but present on the mailing-list v1/v2:
  `Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")`. Helge Deller dropped that
  tag as having no value (it points at the git epoch, not a real
  introducing change).
- No `Reported-by`, `Tested-by`, `Reviewed-by`, `Acked-by`, `Link:`, or
  `Cc: stable` in the committed message.
- Absence of `Cc: stable` / `Fixes:` is expected for this review and is
  not a negative signal.

**Step 1.3 — Body**
- Record:
  - **Bug:** `ioremap()` / `ioremap_wt()` in `platinumfb_probe()` are
    unchecked.
  - **Symptom:** NULL dereference → kernel panic.
  - **Root cause:** probe maps framebuffer, platinum registers, and cmap
    registers, then immediately writes through those pointers
    (`out_be32`, `fbuffer[0x100000] = ...`).
  - **Fix approach:** check each mapping, return `-ENOMEM`, goto-based
    cleanup to avoid duplicated teardown.
  - **Version info:** none in the body. Hardware is Apple “platinum” on
    PPC32 Power Mac.

**Step 1.4 — Hidden bug fix?**
- Record: **Yes, a real bug fix**, not style cleanup. The “goto cleanup”
  wording also **closes a pre-existing resource leak**: on
  `platinum_init_fb()` failure the old path `iounmap()`’d three mappings
  and called `framebuffer_release()` but never `release_mem_region()`
  for the framebuffer or cmap regions. `platinumfb_remove()` does
  release those regions, but `remove()` is not run after a failed probe.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record:
  - File: `drivers/video/fbdev/platinumfb.c` (~+23 / −8 in
    `platinumfb_probe()`; ~35 lines net as posted).
  - Function modified: **`platinumfb_probe()` only**.
  - Scope: **single-file surgical fix**.

**Step 2.2 — Code flow**
- Record:
  - **Hunk 1 (framebuffer):** `ioremap_wt(..., 0x400000)` was used
    unconditionally. After: if NULL, `rc = -ENOMEM`, `goto
    err_release_fb`.
  - **Hunk 2 (platinum regs):** `ioremap(..., 0x1000)` was used
    unconditionally. After: if NULL, `goto err_unmap_fb`.
  - **Hunk 3 (cmap regs):** `ioremap(..., 0x1000)` was used
    unconditionally. After: if NULL, `goto err_release_cmap`.
  - **Hunk 4 (init failure / cleanup):** old `platinum_init_fb()`
    failure only unmapped and released `fb_info`. After: shared labels
    unmap cmap → release cmap region → unmap platinum regs → unmap
    framebuffer → release framebuffer region → `framebuffer_release()`.
    Success path now `return 0` explicitly.

**Step 2.3 — Bug mechanism**
- Record:
  - **Category:** memory safety (NULL deref) + error-path resource leak.
  - **Mechanism:** failed `ioremap*` returns NULL; next statements
    dereference it (`out_be32(&pinfo->platinum_regs->...)`,
    `fbuffer[0x100000] = 0x34`, `out_8(&pinfo->cmap_regs->addr, ...)`).
  - **Cleanup:** goto chain matches acquisition order. Nathan Chancellor
    later had an unused `err_unmap_regs` label removed; the candidate
    diff is that folded version (no unused label).

**Step 2.4 — Fix quality**
- Record:
  - Obviously correct: each mapping is checked before use; unwind order
    is right.
  - Minimal: one probe function, no API/struct changes.
  - Regression risk: **low**. Same teardown operations already exist on
    the `platinum_init_fb()` error path and in `platinumfb_remove()`.
    Extra `release_mem_region()` on probe failure is the missing
    counterpart of `request_mem_region()`.
  - Pre-existing (unchanged): `request_mem_region()` for cmap is still
    unchecked; `dev_set_drvdata()` still happens before
    `platinum_init_fb()`. Not introduced by this patch.
  - `rc` is already declared in this tree and is set on every new goto
    path (`-ENOMEM`) or by `platinum_init_fb()`.

---

## Phase 3: Git history

**Step 3.1 — Blame**
- Record:
  - Unchecked `ioremap()` of platinum/cmap regs: present since
    `1da177e4c3f41` (Linux-2.6.12-rc2, 2005).
  - Framebuffer mapping: `cc5d0189b9ba95` (2005) then `e04e39507c3c3d`
    (2018, `__ioremap()` → `ioremap_wt()`), still unchecked.
  - Partial teardown on `platinum_init_fb()` failure: `2b7574da255fef`
    (2006, “ioremap balanced with iounmap”).
- The hole has been in this driver for the entire git history, including
  this 6.12 tree.

**Step 3.2 — Fixes: tag**
- Record: mailing-list `Fixes: 1da177e4c3f4` is the epoch commit, not a
  real regression. Helge dropped it. `1da177e4c3f41` **is** an ancestor
  of this tree (`git merge-base --is-ancestor` succeeded). The buggy
  code is here regardless of the tag.

**Step 3.3 — File history**
- Record: last change touching this file in-tree is `01ecc142ef7c8`
  (“fbdev: Switch back to struct platform_driver::remove()”). Recent
  platinumfb work is platform-remove/fb_ops/whitespace, not probe
  mapping. **Standalone**, not patch N/M.

**Step 3.4 — Author**
- Record: BingKun Yue has **no** other commits in this tree under
  `drivers/video/fbdev/`. Helge Deller is the fbdev maintainer and
  signed off. Nathan Chancellor (Clang/build) reviewed the applied
  version.

**Step 3.5 — Dependencies**
- Record: uses `ioremap_wt()`, `dev_err()`, `request_mem_region()`,
  `framebuffer_release()` — all present. **Can apply standalone.**
  Context in this checkout matches the “before” side of the diff
  exactly.

---

## Phase 4: Mailing list / external research

`b4 dig -c` was not used: the candidate is **not in this checkout**, so
there is no local SHA to feed it. Thread was recovered from
lore/openwall/patchew.

**Step 4.1 — Original discussion**
- Record:
  - v1 (duplicated cleanup, no gotos):
    `20260817055625.276500-1-yuebingkun@kylinos.cn`
  - v2 (goto cleanup, applied): `https://lists.openwall.net/linux-
    kernel/2026/08/17/346` — Message-ID
    `20260817063637.306865-1-yuebingkun@kylinos.cn`
  - Helge Deller: applied v2, dropped the epoch `Fixes:` line, asked for
    a real name on SOB.
  - Nathan Chancellor: unused label `err_unmap_regs` warning; suggested
    deleting it. Helge folded that in. Candidate diff matches the folded
    result (`err_release_cmap` falls through into
    `iounmap(platinum_regs)`).
  - A later “v3” wrongly changed `strscpy` → `strcpy` and reused this
    subject; reviewers called out the mismatch. **That v3 is not this
    candidate.**
  - Merged in Helge’s fbdev pull for **v7.3-rc1**.
- No NAK. No reviewer `Cc: stable`. No claim this was a production crash
  report.

**Step 4.2 — Recipients**
- Record: To Helge Deller; Cc `linux-fbdev`, `dri-devel`, `linux-
  kernel`. Right maintainer and list.

**Step 4.3 — Bug report**
- Record: **No user/syzbot report.** Static/code-review finding. Failure
  mode is still a panic if `ioremap*` fails.

**Step 4.4 — Series**
- Record: Standalone driver fix. Same family of Mac fbdev drivers:
  `controlfb.c` and `valkyriefb.c` **already** check ioremap failure in
  this tree. platinumfb is the outlier.

**Step 4.5 — Stable list**
- Record: lore.kernel.org/stable search returned **403**. **UNVERIFIED**
  whether this SHA was discussed on stable@. No evidence it was
  rejected.

---

## Phase 5: Semantic / call-chain

**Step 5.1 — Functions**
- Record: `platinumfb_probe()` only.

**Step 5.2 — Callers**
- Record: `.probe = platinumfb_probe` in `platinum_driver`. Called from
  platform/OF probe when the node name is `"platinum"`. Boot/device-bind
  path, not a syscall.

**Step 5.3 — Callees**
- Record: `ioremap_wt` / `ioremap`, `request_mem_region` /
  `release_mem_region`, `iounmap`, `platinum_init_fb()` (VRAM probe +
  `register_framebuffer()`), `framebuffer_release()`. After a successful
  map, probe immediately MMIO-writes the mapped addresses.

**Step 5.4 — Reachability**
- Record: Reachable only if `CONFIG_FB_PLATINUM=y` (`bool`, not
  tristate) on **PPC_PMAC && PPC32** with a `platinum` OF node. Not
  userspace-triggerable on other machines. If probe runs and `ioremap*`
  fails, panic is certain.

**Step 5.5 — Similar patterns**
- Record: `controlfb.c` already does `if (!p->cmap_regs ||
  !p->control_regs || !p->frame_buffer) goto error_out;`. `valkyriefb.c`
  already does a NULL check after the three ioremaps. Historical
  analogue: `13b7c0390a5d3` “video: imsttfb: check for ioremap()
  failures”.

---

## Phase 6: This tree (pending-6.12 / 6.12.111)

**Step 6.1 — Does the bug exist here?**
- Record: **Yes.** `drivers/video/fbdev/platinumfb.c` lines 569, 574,
  578: three unchecked maps, then MMIO at 581–608. `make kernelversion`
  → **6.12.111**. `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`.
  Subject grep on this file history: **commit not present**.

**Step 6.2 — Backport difficulty**
- Record: **Clean apply.** All four “before” contexts match this file
  byte-for-byte.

**Step 6.3 — Related fixes already here?**
- Record: **No** platinumfb ioremap-check. Sibling Mac drivers already
  have the check; this driver does not.

---

## Phase 7: Subsystem context

**Step 7.1**
- Record: **fbdev / Apple Platinum**. Criticality: **PERIPHERAL**
  (legacy PPC32 Power Mac only). Still a first-party in-tree driver, not
  staging.

**Step 7.2**
- Record: File is mature/quiet. Last platinumfb-specific functional
  change in this tree is older fbdev-ops/platform-remove work. Bug is
  long-standing, not a new-subsystem leftover.

---

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: **config- and platform-specific**: 32-bit Power Macintosh with
  platinum graphics (`CONFIG_FB_PLATINUM`). Tiny population, but those
  users take this path on every boot.

**Step 8.2 — Trigger**
- Record: Probe-time `ioremap*` failure (vmalloc/ioremap space
  exhaustion or mapping rejection). Unprivileged users cannot trigger it
  except by booting that machine. Uncommon, not theoretical in the “dead
  code” sense: the next instructions are unconditional dereferences.

**Step 8.3 — Failure mode**
- Record: **NULL deref → oops/panic during probe**. Severity: **HIGH**
  (crash), not a security hole. Secondary: mem-region leak if
  `platinum_init_fb()` fails after regions were requested.

**Step 8.4 — Risk/benefit**
- Record:
  - Benefit: avoid panic and leak on a real (if rare) probe failure;
    same check sibling drivers already have.
  - Risk: **very low** (~20 lines, error path only, maintainer-applied,
    unused-label already folded).
  - Ratio: favorable. Conservative stable policy still accepts small
    NULL-deref probe fixes in in-tree drivers.

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Unchecked `ioremap*` then immediate dereference is a real panic.
- Bug is in **this** 6.12 tree and dates to 2.6.12-era code.
- Small, obviously correct, applies cleanly.
- Also releases mem regions on `platinum_init_fb()` failure (old path
  leaked them).
- Maintainer SOB; Nathan’s warning fix is already in the candidate.
- Sibling `controlfb` / `valkyriefb` already check this.

Against:
- No crash report, no syzbot, no `Cc: stable`.
- Hardware is ancient PPC32 Power Mac; ioremap failure is uncommon.
- Helge treated the epoch `Fixes:` as worthless (not a tracked
  regression).
- Mixed into a 7.3-rc1 “fixes and updates” pull with many cleanups.

Unresolved:
- Exact mainline SHA (not in this tree).
- Whether stable@ already discussed it (lore/stable 403).
- `b4 dig` not run (no local SHA).

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — logic is straightforward;
   maintainer applied it; unused-label fixed.
2. Real bug affecting users? **PASS** — NULL deref on failed map; probe
   is the only path this driver has.
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   panic. User base is small; crash class still qualifies.
4. Small and contained? **PASS** — one function, one file.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — context matches; no missing prereqs.

**Step 9.3 — Exceptions**
- Record: none (not a device ID, quirk, DT, build, or docs patch).
  Ordinary crash-prevention fix.

**Step 9.4 — Decision**
This is a surgical NULL-deref/leak fix in code this tree actually runs
on PPC32 Power Mac. Sibling drivers already do the check. Benefit is a
avoided panic; risk is negligible. Meets stable rules for **this** 6.12
checkout.

---

### Problem for stable users
On Power Macs with Apple platinum graphics, `platinumfb_probe()` maps
the framebuffer and two register windows and then writes through those
pointers with no NULL check. A failed `ioremap*` panics instead of
failing probe. The new labels also `release_mem_region()` on
`platinum_init_fb()` failure, which the old error path skipped.

### Rules / risk
Small, maintainer-acked, applies cleanly to 6.12.111, no new API, no
extra dependencies. Regression risk is limited to probe error paths.

### Concerns
Rare hardware and no field report; Helge dropped the epoch `Fixes:` tag.
Those do not remove the panic if mapping fails, and they do not block
backport to this tree.

Verification:
- [Phase 1] Parsed committed tags: author + Helge Deller SOB only; no
  Reported-by/syzbot.
- [Phase 1] Openwall v2: original `Fixes: 1da177e4c3f4`; Helge dropped
  it as valueless.
- [Phase 2] Diff: three NULL checks + goto teardown in
  `platinumfb_probe()`; also `release_mem_region` on init failure.
- [Phase 2] Current probe (lines 569–633) dereferences maps with no
  checks; cleanup omits mem-region release.
- [Phase 3] `git blame`: unchecked ioremap since `1da177e4c3f41` /
  `cc5d0189b9ba95`; `ioremap_wt` from `e04e39507c3c3d`.
- [Phase 3] `git merge-base --is-ancestor 1da177e4c3f41 HEAD`: yes.
- [Phase 3] `git log --oneline --grep='add error checking for ioremap'
  -- drivers/video/fbdev/`: not in this tree.
- [Phase 3] Author search in fbdev: no other BingKun Yue commits here.
- [Phase 4] Thread: v2 applied by Helge; Nathan unused-label fold
  matches candidate; bogus v3 strcpy not this patch.
- [Phase 4] lore.kernel.org/stable: 403, UNVERIFIED.
- [Phase 4] `b4 dig`: UNVERIFIED (no local candidate SHA).
- [Phase 5] Only caller: `platinum_driver.probe`; Kconfig `FB_PLATINUM`
  depends on `PPC_PMAC && PPC32`, `bool`.
- [Phase 5] `controlfb.c` / `valkyriefb.c` already check ioremap NULL in
  this tree.
- [Phase 6] `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` = 6.12.111.
- [Phase 6] Before-context of all four hunks matches this file.
- [Phase 8] Failure mode: NULL deref oops on probe, severity HIGH;
  trigger rare but on the only probe path.
- UNVERIFIED: mainline SHA; stable@ discussion.

**YES**

 drivers/video/fbdev/platinumfb.c | 35 ++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/platinumfb.c b/drivers/video/fbdev/platinumfb.c
index a08d955d9b439..81fdaa3541db9 100644
--- a/drivers/video/fbdev/platinumfb.c
+++ b/drivers/video/fbdev/platinumfb.c
@@ -567,15 +567,30 @@ static int platinumfb_probe(struct platform_device* odev)
 	/* frame buffer - map only 4MB */
 	pinfo->frame_buffer_phys = pinfo->rsrc_fb.start;
 	pinfo->frame_buffer = ioremap_wt(pinfo->rsrc_fb.start, 0x400000);
+	if (!pinfo->frame_buffer) {
+		dev_err(&odev->dev, "failed to ioremap frame buffer\n");
+		rc = -ENOMEM;
+		goto err_release_fb;
+	}
 	pinfo->base_frame_buffer = pinfo->frame_buffer;
 
 	/* registers */
 	pinfo->platinum_regs_phys = pinfo->rsrc_reg.start;
 	pinfo->platinum_regs = ioremap(pinfo->rsrc_reg.start, 0x1000);
+	if (!pinfo->platinum_regs) {
+		dev_err(&odev->dev, "failed to ioremap registers\n");
+		rc = -ENOMEM;
+		goto err_unmap_fb;
+	}
 
 	pinfo->cmap_regs_phys = 0xf301b000;	/* XXX not in prom? */
 	request_mem_region(pinfo->cmap_regs_phys, 0x1000, "platinumfb cmap");
 	pinfo->cmap_regs = ioremap(pinfo->cmap_regs_phys, 0x1000);
+	if (!pinfo->cmap_regs) {
+		dev_err(&odev->dev, "failed to ioremap cmap registers\n");
+		rc = -ENOMEM;
+		goto err_release_cmap;
+	}
 
 	/* Grok total video ram */
 	out_be32(&pinfo->platinum_regs->reg[16].r, (unsigned)pinfo->frame_buffer_phys);
@@ -623,13 +638,21 @@ static int platinumfb_probe(struct platform_device* odev)
 	dev_set_drvdata(&odev->dev, info);
 
 	rc = platinum_init_fb(info);
-	if (rc != 0) {
-		iounmap(pinfo->frame_buffer);
-		iounmap(pinfo->platinum_regs);
-		iounmap(pinfo->cmap_regs);
-		framebuffer_release(info);
-	}
+	if (rc != 0)
+		goto err_unmap_cmap;
+
+	return 0;
 
+err_unmap_cmap:
+	iounmap(pinfo->cmap_regs);
+err_release_cmap:
+	release_mem_region(pinfo->cmap_regs_phys, 0x1000);
+	iounmap(pinfo->platinum_regs);
+err_unmap_fb:
+	iounmap(pinfo->frame_buffer);
+err_release_fb:
+	release_mem_region(pinfo->rsrc_fb.start, resource_size(&pinfo->rsrc_fb));
+	framebuffer_release(info);
 	return rc;
 }
 
-- 
2.53.0

