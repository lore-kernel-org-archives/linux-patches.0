Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A677F525A9E;
	Mon, 31 Aug 2026 13:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183864; cv=none; b=hgfuRmj49srTGQjmzwUrZBQ53FubD2wZPyKq5xWhR/eId9EHcoCLLo7tKTxpn1KuSqFHFUD601CbeQyo68EBrW+n1i4cM9RFL3EH4eemdzjBOlMq4kY6T+HVHbWEd5hX+Od3QRFEpnwsKaRiseam2Uv7rU2m8oGdFwzbppuXLMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183864; c=relaxed/simple;
	bh=iIoLSThhvBNpdNvI4xmyVzoJqgONVjjSmzWQnmCZs6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qV2g72JocLK492Qgs/NOT869z8G+oJDXL5FZt4mCd8JG84zqJlp17m7yoxVepTh+/Q9VcPVJnqDdnaSq4BzHhbRUnVRGjyrxQXS+C1/yRrqZGyFrdIOUhn0wLH4dO/QkQmCLB0A9qVFDiIhejFT1hQQTT5Xy0E2hGK04N25YH9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lg4qFprw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lg4qFprw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DE41F00A3E;
	Mon, 31 Aug 2026 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183861;
	bh=BCUcAlchfVkJ6CooKk/wH8zMbjYepLYVbdrAMkbfdaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lg4qFprwRYqFRESe+s3dK2JNk4HjWODdINGyDaTh49ut60lnzf5C6lV7U5IX83uus
	 mQmVbegVS2ilGDcta5O7txbOCB46VHSLSvjdLHyaprSQ/NYI/YnbHUeNYdg49Begnv
	 Xe77O97RLwV/B20qLXlW3ZYoBPVq+NaJ2DdL6KlpijIscXy74qKxgv9oxq54VhP4ct
	 U9Hae2d6lAYUpZkg0Ysc2rHidRbEg3XmOTIa9OVebszR2I/h/jdXS4qRrvy6YPB6qn
	 lpQfB78l1CLZAzCMTaWV/vLM4cNitJwOeOHJXDjxElKpGpXwkUgDjxxm69gHFPxTLF
	 MNMWJXwZzgC9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <haoxiang_li2024@163.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] fbdev: pm2fb: unwind WC setup on probe failure
Date: Mon, 31 Aug 2026 09:26:16 -0400
Message-ID: <20260831133314.4125787-348-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 16eb19f0c90af03bda6ba66586d7bb0e9cf85b43 ]

Add arch_phys_wc_del() on error path to keep the
write-combining setup balanced when later probe
steps fail.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `fbdev: pm2fb: unwind WC setup on probe
failure`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `HEAD` detached)
**Candidate commit:** `16eb19f0c90af03bda6ba66586d7bb0e9cf85b43`
(mainline only; **not** in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[fbdev: pm2fb]` `[unwind]` — Add missing write-combining
teardown when `pm2fb_probe()` fails after WC setup.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>` (author)
- `Signed-off-by: Helge Deller <deller@gmx.de>` (fbdev maintainer,
  applied the patch)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`, or `Link:` tags
- Notable: maintainer ack via application; no user/fuzzer reports

### Step 1.3: Body analysis
**Record:**
- **Bug:** `arch_phys_wc_add()` is called during probe, but later probe
  failures skip `arch_phys_wc_del()`.
- **Symptom:** Leaked MTRR/WC mapping on x86 systems where
  `arch_phys_wc_add()` actually allocates an MTRR (PAT disabled, MTRR
  enabled, `nomtrr` unset).
- **Root cause:** Missing symmetric cleanup on `err_exit_pixmap` and
  downstream error labels (`err_exit_both`, `err_exit_all`).
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although titled “unwind WC setup,” this is a probe
error-path **resource leak** fix, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/video/fbdev/pm2fb.c` (+1 / −0)
- **Functions:** `pm2fb_probe()` error path only
- **Scope:** Single-file, surgical one-liner

### Step 2.2: Code flow change
**Record:**
- **Before:** After `arch_phys_wc_add()` at lines 1655–1657, failures at
  pixmap alloc (`err_exit_pixmap`), cmap alloc (`err_exit_both`), or
  `register_framebuffer()` (`err_exit_all`) skipped WC teardown.
- **After:** `err_exit_pixmap` calls
  `arch_phys_wc_del(default_par->wc_cookie)` before unmapping smem —
  matching `pm2fb_remove()` at line 1738.
- **Affected paths:** Error paths only (not the success path).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Error-path resource leak
- **Mechanism:** `arch_phys_wc_add()` may consume an MTRR slot on PAT-
  less x86; without `arch_phys_wc_del()`, that slot stays allocated
  after failed probe. On PAT-enabled or non-x86 systems,
  `arch_phys_wc_add()` is effectively a no-op and `arch_phys_wc_del(0)`
  is also a no-op.

### Step 2.4: Fix quality
**Record:**
- Obviously correct; mirrors `pm2fb_remove()` and the pattern in
  `tdfxfb.c` (line 1556).
- Minimal, no API changes.
- **Regression risk:** Very low — `arch_phys_wc_del()` is documented to
  be safe for handle `0` and error returns.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `arch_phys_wc_add()` introduced in `f8f05cdc767fa` (Apr 2015, “use
  arch_phys_wc_add() and ioremap_wc()”).
- `f8f05cdc767fa` **is** an ancestor of this tree (`merge-base` exit 0).
- Error-path labels date to 2005–2008; WC cleanup on error was never
  added when MTRR code was converted in 2015.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug introduced by `f8f05cdc767fa`,
which is present in 6.18.y.

### Step 3.3: Related file history
**Record:**
- `a943710407120` — identical fix for `uvesafb_probe()` error path,
  **already in 6.18.y**
- `ed359a464846b` — `pm2fb` missing `pci_disable_device()` on probe
  error path, **already in 6.18.y**
- `tdfxfb.c` already has `arch_phys_wc_del()` on probe error path (line
  1556)
- Standalone patch; not part of a series

### Step 3.4: Author context
**Record:** Haoxiang Li submits probe error-path leak fixes across
subsystems; Helge Deller (fbdev maintainer) applied this patch.

### Step 3.5: Dependencies
**Record:** None. Requires only
`arch_phys_wc_add()`/`arch_phys_wc_del()` and `wc_cookie` in `struct
pm2fb_par`, all present since `f8f05cdc767fa`. Applies cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 16eb19f0c90af`: https://patch.msgid.link/20260621071935.380
  2673-1-haoxiang_li2024@163.com
- Single-patch submission; Helge Deller replied “applied. Thanks!”
- No series revisions (`-a` not needed; single patch)
- No stable nomination in thread
- No NAKs or concerns

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: To/Cc — Haoxiang Li, Helge Deller, `linux-
fbdev@vger.kernel.org`, `linux-kernel@vger.kernel.org`

### Step 4.3: Bug reports
**Record:** N/A — no `Reported-by:` or `Link:` tags; no syzbot/fuzzer
involvement.

### Step 4.4: Related patches
**Record:** Direct analogue: `a943710407120` (uvesafb, same maintainer,
same pattern).

### Step 4.5: Stable list history
**Record:** Lore fetch blocked by bot protection; no stable-list
discussion found via `b4`. Precedent established in-tree via uvesafb
backport.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `pm2fb_probe()`, `arch_phys_wc_add()`, `arch_phys_wc_del()`

### Step 5.2: Callers
**Record:** `pm2fb_probe()` registered as `.probe` in `pm2fb_driver`
(PCI core during device enumeration/module load). Not a hot path; runs
once per device attach attempt.

### Step 5.3: Callees
**Record:** On failure after WC setup: `kfree()`, `fb_dealloc_cmap()`,
`iounmap()`, `release_mem_region()`, `framebuffer_release()`,
`pci_disable_device()`. WC teardown was the missing piece.

### Step 5.4: Reachability
**Record:** Trigger requires `CONFIG_FB_PM2` built/loaded, Permedia2
hardware present, probe progressing past smem ioremap + WC add, then
failing at:
1. `kmalloc(PM2_PIXMAP_SIZE)` → `-ENOMEM`
2. `fb_alloc_cmap()` failure
3. `register_framebuffer()` failure

Reachable from module load / PCI hotplug; no userspace syscall needed
beyond normal device binding.

### Step 5.5: Similar patterns
**Record:**
- `tdfxfb.c`: has probe-error `arch_phys_wc_del()` ✓
- `uvesafb.c`: fixed in `a943710407120` (in this tree) ✓
- `s3fb.c`, `i740fb.c`: WC add after success point or missing probe-
  error del (latent issues elsewhere; out of scope)

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Lines 1655–1657 call `arch_phys_wc_add()`; lines
1713–1715 (`err_exit_pixmap`) lack `arch_phys_wc_del()`. Bug present
since `f8f05cdc767fa` (2015).

### Step 6.2: Backport complications
**Record:** Clean apply expected — one line at `err_exit_pixmap`,
identical context to mainline diff.

### Step 6.3: Related fixes already present?
**Record:**
- `a943710407120` (uvesafb WC probe-error fix) — **present**
- `ed359a464846b` (pm2fb `pci_disable_device` probe fix) — **present**
- `16eb19f0c90af` (this fix) — **absent** (`merge-base --is-ancestor`
  exit 1)

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/video/fbdev/pm2fb.c` — legacy framebuffer driver
(`CONFIG_FB_PM2`, tristate). **PERIPHERAL** — affects users of 1990s-era
Permedia2 hardware (PCI/SPARC).

### Step 7.2: Activity
**Record:** Low churn; occasional maintenance fixes from Helge Deller’s
fbdev tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with Permedia2 hardware, `CONFIG_FB_PM2` enabled,
probe failing after WC setup. Narrow population.

### Step 8.2: Trigger conditions
**Record:**
- **Real leak only on:** x86, PAT disabled, MTRR enabled, `nomtrr=0`
- **Failure modes:** ENOMEM or framebuffer registration failure after WC
  add
- **Likelihood:** Low (legacy hardware + rare probe failure)
- **Unprivileged trigger:** Indirectly via module load / device
  presence; not a typical attack vector

### Step 8.3: Failure severity
**Record:** Leaked MTRR slot (finite resource, typically ~8–10 entries).
Can degrade performance or block other drivers needing MTRR on PAT-less
systems. **Not** a crash, deadlock, or data corruption. **Severity:
LOW–MEDIUM** (resource leak, not security).

### Step 8.4: Risk–benefit
**Record:**
- **Benefit:** Correct probe teardown; consistency with uvesafb/tdfxfb;
  prevents MTRR exhaustion on affected configs
- **Risk:** Negligible — one line, symmetric with remove path, no-op on
  modern PAT-enabled systems
- **Ratio:** Low benefit magnitude, but also near-zero risk; established
  fbdev stable pattern

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable resource leak since 2015 WC conversion
- One-line, obviously correct fix
- Identical pattern already backported in this tree (`a943710407120`
  uvesafb)
- Same maintainer (Helge Deller) applied both uvesafb and pm2fb fixes
- Buggy code confirmed present in 6.18.y; fix not yet applied
- Matches `tdfxfb` probe-error pattern already in tree

**AGAINST backport:**
- Very obscure hardware (Permedia2)
- No user reports, syzbot, or security angle
- Effective only on PAT-less x86 with MTRR (rare on 6.18 deployments)
- Impact is resource leak, not crash/corruption
- “Important issue” bar is borderline for severity

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors remove path;
   maintainer applied; no objections
2. Fixes a real bug? **PASS** — MTRR leak on probe failure (on affected
   configs)
3. Important issue? **PASS (borderline)** — resource leak, not
   crash/security; but same class already accepted for uvesafb in this
   tree
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — prerequisite code present; clean
   apply

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
probe error-path resource cleanup.

### Step 9.4: Decision rationale

For **linux-6.18.y**, this is a legitimate probe error-path resource
leak fix. Severity is low and the hardware is legacy, but the patch is
trivial, zero-risk, and the **same tree already carries the identical
uvesafb fix** (`a943710407120`). Backporting maintains consistency in
fbdev probe teardown and closes a gap that has existed since the 2015
`arch_phys_wc_add()` conversion.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Reported-by/syzbot
- **[Phase 2]** Diff: +1 line `arch_phys_wc_del()` at `err_exit_pixmap`
  in `pm2fb_probe()`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `git blame` → WC add
  from `f8f05cdc767fa` (2015)
- **[Phase 3]** `git merge-base --is-ancestor f8f05cdc767fa HEAD` → exit
  0 (bug source in tree)
- **[Phase 3]** `git merge-base --is-ancestor 16eb19f0c90af HEAD` → exit
  1 (fix not in tree)
- **[Phase 3]** `git log stable/linux-6.18.y..master -- pm2fb.c` → only
  `16eb19f` and unrelated pci_device_id change
- **[Phase 3]** Related: `a943710407120` (uvesafb), `ed359a464846b`
  (pm2fb pci_disable) in tree
- **[Phase 4]** `b4 dig -c 16eb19f` → lore URL found; maintainer
  “applied”
- **[Phase 4]** `b4 dig -w` → fbdev maintainers CC’d
- **[Phase 5]** Read `arch_phys_wc_add/del` in
  `arch/x86/kernel/cpu/mtrr/mtrr.c` and stubs in `include/linux/io.h`
- **[Phase 5]** Compared `tdfxfb.c:1556` (has probe-error del) and
  `pm2fb.c:1738` (remove-path del)
- **[Phase 6]** Confirmed missing `arch_phys_wc_del` at lines 1713–1715
  in current tree
- **[Phase 6]** `git show a943710407120` — identical uvesafb probe-error
  fix already in 6.18.y
- **[Phase 8]** Assessed impact: MTRR leak on PAT-less x86 only;
  LOW–MEDIUM severity

**YES**The background lookups finished and matched what the analysis
used:

- **pm2fb history:** The commit isn’t in this `v6.18.44` tree yet;
  recent `pm2fb.c` history shows maintenance fixes like the
  `pci_disable_device()` probe cleanup.
- **Candidate hash:** Mainline commit is `16eb19f0c90af` (“fbdev: pm2fb:
  unwind WC setup on probe failure”).
- **Stable precedent:** `6.18.y` already has the same pattern for
  uvesafb (`a943710407120`); this pm2fb fix is not in stable yet.

**Verdict for 6.18.y: YES** — one-line probe error-path MTRR/WC cleanup,
same class of fix already accepted in this tree.

 drivers/video/fbdev/pm2fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index f34429829b7d7..82408503c2812 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1711,6 +1711,7 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  err_exit_both:
 	kfree(info->pixmap.addr);
  err_exit_pixmap:
+	arch_phys_wc_del(default_par->wc_cookie);
 	iounmap(info->screen_base);
 	release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
  err_exit_mmio:
-- 
2.53.0

