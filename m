Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0695083E0;
	Mon, 19 Oct 2026 14:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418610; cv=none; b=N1ze6QBQAwItIvYXdLzsky99MpI7mCMhFVty0slRB5L+ggX0YG3uLmkueH+QboSOiET6kxPbGHBTKpxqQ9daWnOh1zbeW06c+n2hY7toi8Vt/b5Ndo2D9VSEiVeqphKnyDrXGisqSQgQfspdjNwIaeUBdr3602igtSPDkamKM24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418610; c=relaxed/simple;
	bh=/vk3W0OuB8uzko+mMXFxy4Zv/bmV187ISHDrW5g6WYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qxw0+t7t4QKwDPqV3Yey2bpXQ7DkH9VAbwaHas/tSsiFqpHs96pW6/ZgJlws6irhJepdvGiwxW9LW3r7P5N0MpgvzZwMTDgnVb3RXY4pV7bF2zwHRt68U+6FfUHb8tUKsADTcU7EQ4uRZ2PDXcxZVV4761xRtHfWXWi3BHdQLlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKSjTdaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKSjTdaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F6E1F000C9;
	Mon, 19 Oct 2026 14:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418606;
	bh=VcXNbrzKLhYN5V0hkHe94Cash4qRCSavaP+hGPLNDIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKSjTdaYnZ0dDvZYvl+j1Ur5BKSoAUnorFIX1OZsJItLz7bLUawBF6VuBktnSdRjA
	 4cDEWOGgZfNhZoghNTEIy/pZFliM6Ni4HghFdiIu9SRtjsbNsdMgXyt09FJ5b0N/tX
	 IOpnaNaZxytmjomimoOp1O7L5yoE9UpFtQEaykvGYVedCddwtIGrjVueNZ1Lfa2BNK
	 1sCt4y9oXNCtU7NcfhnIdS3lg/EQ9BYz/fI5qzMO1UrBfH5vhMs1WExnOnpiQRCppf
	 fZlekV5rIQIIz23TBym+kh6bYxTqFZ9rpZtY5e07JzdrT8FY9ifTy8g5bDbwYIGhWA
	 VmHgzXhLhrDrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Helge Deller <deller@gmx.de>,
	syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	tzimmermann@suse.de,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo
Date: Mon, 19 Oct 2026 09:50:59 -0400
Message-ID: <20261019135441.1420968-368-sashal@kernel.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 94e6a058b16820e02f25e1221a4c4e713ba23550 ]

Ensure the logo will not exceed the screen size, which then should
fix a reported KASAN: slab-out-of-bounds Read in fbcon_prepare_logo.

Reported-by: syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy `logo_lines`
walk is present here, and the candidate is a 7-line KASAN bounds check
that applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[fbcon] [Fix] [KASAN slab-out-of-bounds read in
fbcon_prepare_logo]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Reported-by: syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com
- Signed-off-by: Helge Deller \<deller@gmx.de\> (FRAMEBUFFER LAYER
  maintainer; applied the patch himself)
- No Fixes:, no Cc: stable, no Reviewed-by/Acked-by/Tested-by, no Link:
  in the committed message (the syzbot-forwarded submission did include
  `Link: https://syzkaller.appspot.com/bug?extid=0c815b25cdb3678e7083`)
- Notable: syzbot + maintainer SOB; absence of Fixes/Cc:stable is
  expected for this review pipeline

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: calculated logo height can exceed the console buffer, then
  `fbcon_prepare_logo()` reads past it.
- Symptom: KASAN slab-out-of-bounds Read (also KFENCE OOB and UAF-class
  reports on the same syzbot bug).
- Version info in the message: none. Syzbot shows crashes from Feb 2025
  through 2026 on upstream, and on linux-5.15.y / 6.1.y / 6.6.y.
- Root cause as stated: logo not clipped to screen size before the
  buffer walk.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a hidden fix. Explicit KASAN OOB fix. The later `if
(logo_lines > vc->vc_bottom)` path already tried to disable an oversized
logo, but only **after** the out-of-bounds walk.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/video/fbdev/core/fbcon.c` (+7 / −0)
- Function: `fbcon_prepare_logo()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: After `logo_lines = DIV_ROUND_UP(logo_height,
vc->vc_font.height)` the code immediately walked `q - logo_lines *
cols`. Now it clamps `logo_lines` to `rows` and `new_rows - 1`, and if
that leaves nothing, sets `logo_shown = FBCON_LOGO_DONTSHOW` and
returns. Normal path with a logo that already fits is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety / out-of-bounds.** `fb_prepare_logo()` returns a
pixel height `<= yres`, but `DIV_ROUND_UP(height, font_height)` can be
one larger than `yres / font_height` (`new_rows`). Example: yres=100,
font=16 → logo_lines=7, new_rows=6. Then `q - logo_lines * cols` is one
row before `vc_origin`, and `scr_readw` / `scr_memcpyw` go OOB. The
existing `logo_lines > vc->vc_bottom` check runs too late.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct bounds clamp; 7 lines; no API change.
`new_rows == 0` yields `new_rows - 1 == -1`, then `logo_lines <= 0`
bails out. Regression risk is low: at worst the penguin is skipped on
tiny/odd geometries instead of walking off the buffer. A 2025 RFC (Wang
ShaoBo) described a related cols-mismatch after `vc_resize()`; this
clamp does not fully cover that variant, but it does not worsen it, and
syzbot named this commit as the fix for the 1873-crash report.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: The OOB walk (`q - logo_lines * cols` / `scr_readw` loop) is
from **^1da177e4c3f41** (v2.6.12 era). `logo_lines = DIV_ROUND_UP(...)`
is from **416e74ea781359** (Julia Lawall, 2008). This is long-standing
code, not a recent 6.12-only bug.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. The buggy pattern has been in the function for
~20 years. `6104c37094e7` ("fbcon: Make fbcon a built-time dependency
for fbdev", 2017) is in this tree (`merge-base --is-ancestor` exit 0);
Wang’s RFC cited it, but that is a different proposed patch.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Related but distinct history in this tree: `a6a00d7e8ffd7` /
`5c38052680f56` (kzalloc KMSAN false-positive, reverted);
`250038f5a7207` (2007 vertical overflow when making space for the logo —
different hunk). No prior clamp of `logo_lines` to `rows`/`new_rows`.
Standalone, not patch N/M.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Helge Deller is FRAMEBUFFER LAYER maintainer (`MAINTAINERS`). He
authors/applies fbdev fixes regularly in this tree.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `logo_lines`, `rows`, `new_rows`, `logo_shown`,
`FBCON_LOGO_DONTSHOW`. No new helpers. `git apply --check` succeeded
(hunk at line 596, offset −64). Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record: `b4 dig -c 94e6a058b168` →
https://patch.msgid.link/6a897c8e.dbb3a75c.13dd47.002f.GAE@google.com
(syzbot-forwarded `#syz test` from deller@kernel.org, 2026-08-22). `b4
dig -a`: v1 only. lore.kernel.org returned 403; openwall mirror confirms
the same single-hunk patch. No NAK found. Applied two days later by
Deller (commit date 2026-08-24).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w`: recipients were syzbot and linux-
kernel@vger.kernel.org only. No public Reviewed-by. Weight comes from
the maintainer applying it, not from a review thread.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: https://syzkaller.appspot.com/bug?extid=0c815b25cdb3678e7083
- Status: upstream, C repro, **prio:high**, **1873 crashes**, first
  2025-02-25
- Fix commit listed: **94e6a058b168**
- Patched on 20/29 syzbot instances
- Stack: `store_bind` → `vt_bind` → `do_bind_con_driver` → `visual_init`
  → `fbcon_init` → `fbcon_prepare_logo` → `scr_memcpyw`
- Same title also on linux-5.15.y (C repro), linux-6.1.y, linux-6.6.y
- Syzbot security assessment: DenialOfService yes, Exploitable yes,
  Unprivileged no (sysfs `bind` is `S_IWUSR`)

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Not a series. Related RFC 2025-09-25 from Wang ShaoBo added a
pointer-vs-`vc_origin` guard in the scroll loop; it was not applied in
this tree or in the candidate’s parent. Older kzalloc change is
unrelated (reverted KMSAN false positive).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable 403. No evidence this 2026-08-24 commit
was already discussed for 6.12.y. The same KASAN title is already
reproduced on older stable CIs, which supports that 6.12 is affected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `fbcon_prepare_logo()` only. Semcode MCP not available.

**Step 5.2: TRACE CALLERS**
Record: Two call sites in this tree:
1. `con2fb_init_display()` (line 826) — console mapped to a framebuffer,
   `show_logo`.
2. `fbcon_init()` (line 1155) — after setting/resizing the VC, if `logo`
   is set.

`fbcon_init` is `con_init` for fbcon, called from `visual_init()` during
bind/takeover. `store_bind` is the syzbot trigger (root sysfs write).
Also runs on normal fbcon takeover at boot when the logo is enabled
(`!MODULE`).

**Step 5.3: TRACE CALLEES**
Record: `fb_prepare_logo()`, `scr_readw`/`scr_memcpyw`/`scr_memsetw`,
`kmalloc`/`kfree`, `update_screen`. The new code only uses `min()` and
existing `logo_shown`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace (root) → `sysfs` `vtconN/bind` → `fbcon_init` →
`fbcon_prepare_logo`. Also boot-time logo on `CONFIG_FRAMEBUFFER_CONSOLE
&& !MODULE`. Path is real and reproduced.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: The too-late `logo_lines > vc->vc_bottom` check is the same bug
class, just after the OOB. No sibling drivers copy this logo-scroll
logic.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `drivers/video/fbdev/core/fbcon.c` lines 597–604 compute
`logo_lines` and walk `q - logo_lines * cols` with no clamp. `git merge-
base --is-ancestor 94e6a058b168 HEAD` is **false** — the fix is not in
6.12.111. Bug introduced long before 6.12.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: `git apply --check` **clean** (offset −64 from surrounding-line
drift / `fbcon_ops`→`fbcon_par` rename already in this tree). Expected
difficulty: **clean apply**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No `logo_lines = min(...)` in this file. The 2007 Geert overflow
tweak and the kzalloc revert do not clamp logo lines.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **fbcon** (`drivers/video/fbdev/core/fbcon.c`), the framebuffer
console used with `CONFIG_FRAMEBUFFER_CONSOLE` (default follows
`DRM_FBDEV_EMULATION`). Criticality: **IMPORTANT** — not mm/core, but
default console path on many DRM/fbdev systems.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature; still receiving OOB/NULL/font fixes in this tree
(`51b8258efe254`, `b5bb2c696e140`, `ac970358c5ca0`). Not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Users with framebuffer console (typical desktop/embedded DRM
fbdev emulation, vkms/syzbot, classic fbdev). Config-specific
(`FRAMEBUFFER_CONSOLE`), not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: (1) Console bind/takeover with a logo taller than the text grid
after integer rounding; (2) syzbot C repro via `vtcon` bind. Common on
fuzzing and on small/rotated/odd modes. Unprivileged users cannot write
`bind` (`S_IWUSR`); boot-time logo does not need that.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: KASAN slab-out-of-bounds **read** (and related UAF/KFENCE
reports). Can oops under KASAN/KFENCE; without sanitizers it is still an
invalid buffer walk. Severity: **HIGH** (memory-safety crash; syzbot
marked exploitable but not unprivileged).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit **high** (stops a reproducible KASAN OOB in a common
console path). Risk **very low** (7-line clamp, early return already
used elsewhere in the same function). Ratio strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, syzbot-reproduced KASAN OOB with C repro, 1873 crashes,
  prio:high
- Same bug title on 5.15.y / 6.1.y / 6.6.y — this 6.12 tree still has
  the unclamped walk
- Syzbot lists 94e6a058b168 as the fix commit
- Maintainer-authored, 7 lines, applies cleanly here
- Fixes a rounding hole (`DIV_ROUND_UP` vs `yres / font_height`) plus
  any logo taller than the VC
- No new API/feature; existing `FBCON_LOGO_DONTSHOW` path

AGAINST:
- Short commit message, no public review, no Fixes:
- Does not fully address the Wang RFC cols-mismatch-after-resize case
- Trigger via sysfs bind is root-only (boot logo path still matters)

UNRESOLVED:
- Could not read lore.kernel.org (403); used b4 + openwall instead
- Could not confirm whether post-fix syzbot “last: 2d” crashes are only
  on the 9 unpatched instances (likely, given 20/29 patched)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — clamp is local and readable;
   syzbot C repro; maintainer applied it
2. Fixes a real bug that affects users? **PASS** — KASAN OOB, thousands
   of syzbot hits, stable-tree crashes
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   HIGH memory-safety OOB
4. Small and contained? **PASS** — +7 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy code present; `git
   apply --check` clean

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. It is a normal memory-
safety bug fix.

**Step 9.4: MAKE YOUR DECISION**
This is a small, correct bounds check for a long-standing fbcon OOB that
syzbot can hit on this class of kernels. It belongs in 6.12.y.

Verification:
- [Phase 1] Parsed tags: syzbot Reported-by; Helge Deller SOB; no
  Fixes/Cc:stable/review tags in the committed message
- [Phase 2] Diff: +7 lines in `fbcon_prepare_logo()` after
  `DIV_ROUND_UP`; clamp `logo_lines` then early return
- [Phase 3] `git describe HEAD` / Makefile: **6.12.111**, branch
  pending-6.12
- [Phase 3] `git blame`: OOB loop from ^1da177e4c3f41; DIV_ROUND_UP from
  416e74ea781359 (2008)
- [Phase 3] `git merge-base --is-ancestor 94e6a058b168 HEAD` → not an
  ancestor (fix absent here)
- [Phase 3] `git apply --check` of 94e6a058b168 → clean, offset −64
- [Phase 3] Confirmed no `logo_lines = min` already in this file
- [Phase 4] `b4 dig -c 94e6a058b168` → msgid
  6a897c8e.dbb3a75c.13dd47.002f.GAE@google.com; v1 only
- [Phase 4] Syzbot extid 0c815b25cdb3678e7083: C repro, prio:high, 1873
  crashes, Fix commit 94e6a058b168
- [Phase 4] Same KASAN title on linux-5.15.y / 6.1.y / 6.6.y
- [Phase 5] Callers: `fbcon_init` (line 1155), `con2fb_init_display`
  (line 826); bind path `store_bind` is `S_IWUSR`
- [Phase 6] Local function still matches the pre-patch walk at lines
  597–604
- [Phase 7] Helge Deller listed as FRAMEBUFFER LAYER maintainer
- [Phase 8] Failure mode: slab-out-of-bounds read in
  `scr_memcpyw`/`scr_readw`; severity HIGH
- UNVERIFIED: full lore.kernel.org thread (HTTP 403); whether every
  post-Aug-24 syzbot crash is on unpatched instances only

The patch is a 7-line clamp in `fbcon_prepare_logo()` that stops a
syzbot-reproduced KASAN out-of-bounds read. The buggy walk is in this
6.12 tree, the fix applies cleanly, and the risk is limited to skipping
the boot logo when it cannot fit.

**YES**

 drivers/video/fbdev/core/fbcon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 532522c2aed05..903823c9ce567 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -600,6 +600,13 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 		erase &= ~0x400;
 	logo_height = fb_prepare_logo(info, par->rotate);
 	logo_lines = DIV_ROUND_UP(logo_height, vc->vc_font.height);
+	logo_lines = min(logo_lines, rows);
+	logo_lines = min(logo_lines, new_rows - 1);
+	if (logo_lines <= 0) {
+		logo_lines = 0;
+		logo_shown = FBCON_LOGO_DONTSHOW;
+		return;
+	}
 	q = (unsigned short *) (vc->vc_origin +
 				vc->vc_size_row * rows);
 	step = logo_lines * cols;
-- 
2.53.0

