Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946BE3A542F;
	Mon, 20 Apr 2026 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691025; cv=none; b=fQYnGn4KrysO3OnD1qCUQPxE0Z9O5RWmxnNtAiKuyEAG/OP4nTUSI3YA1IRPWpmI/kbIiIzYvfZRTxA6g1LM8jjYaZaGi5fiWjEYRRK6PjStHKhmQ7c4HbmMGkyq/i8jOszoXm3VWAKgkhVdFfrpYYH39LSHMwFIOoVMOkb7mJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691025; c=relaxed/simple;
	bh=aV2gGEjt8S0Tj1d3oacW3apUNrBdas5THx9QEDYkIog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFsAF2/Y6CHFewq6b7ExHXx/tQfhMmYXiNTtddkjFMhAfkflfbA26zR5WWjaDvpbLtJP+yBaeJBC5p8hZvnpIn/ebUkh8rOer8+LolKfE+IXPofIpDyC3jHwJtjI/eCNdUK89SrwMm2De1HrpJHQo8yFj4X+JbOzPDju72s2e80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmP+7W1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmP+7W1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB5CC4AF09;
	Mon, 20 Apr 2026 13:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691025;
	bh=aV2gGEjt8S0Tj1d3oacW3apUNrBdas5THx9QEDYkIog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmP+7W1RNuKmh1YubDldwLci+Yhc2NCkBuuqrEth7yMNzpqBfKs+saPfV4e9n59WR
	 lEpxszvfac4e50BaKt84icgW3LcIY2PII+Ce6S9MubngfceWt7QBs8AC6jDmca3K3q
	 PZgXV+mAXyqMHXs72gZjzAh6XuAQeRMIclx9K5+DZbhAHt3ZrC7Cu7OCbnO6sARfOl
	 T3C5Jb64G4CoIY8M5sOfKeL6K3RGGTQD+hgJipwE/EuPm9x0IloPLiwZR27MuenDXQ
	 Qf6ZoTfxwKK2ZpZzlKgKng6pGI2hjafcvqP1SWtd4e3o34VYIY70x2MmhQdCfd4htF
	 54+PUhbtA4e5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wang Jun <1742789905@qq.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	FlorianSchandinat@gmx.de,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] fbdev: viafb: check ioremap return value in viafb_lcd_get_mobile_state
Date: Mon, 20 Apr 2026 09:08:36 -0400
Message-ID: <20260420131539.986432-50-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Wang Jun <1742789905@qq.com>

[ Upstream commit f044788088ef55e9855b17b7984ffe522c40c093 ]

The function viafb_lcd_get_mobile_state() calls ioremap() without
checking the return value. If ioremap() fails (returns NULL), the
subsequent readw() will cause a NULL pointer dereference.

Signed-off-by: Wang Jun <1742789905@qq.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for the full analysis. Let me
compile it.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `fbdev: viafb`
- Action verb: "check" (adding a missing safety check)
- Summary: Adds NULL check for `ioremap()` return value in
  `viafb_lcd_get_mobile_state()`
Record: [fbdev: viafb] [check] [Add missing ioremap NULL check to
prevent NULL deref]

**Step 1.2: Tags**
- Signed-off-by: Wang Jun <1742789905@qq.com> (author)
- Signed-off-by: Helge Deller <deller@gmx.de> (fbdev maintainer,
  committer)
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable tags
Record: Only author and maintainer SOBs. No Fixes: tag or Reported-by —
this appears to be a code-review/static-analysis finding, not a user-
reported bug.

**Step 1.3: Body Text**
- Bug: `viafb_lcd_get_mobile_state()` calls `ioremap()` without checking
  the return value.
- Symptom: If `ioremap()` returns NULL, the subsequent `readw()` causes
  a NULL pointer dereference.
- Root cause: Missing NULL check.
Record: [NULL pointer dereference if ioremap fails] [kernel oops/crash]
[No version info] [Straightforward missing check]

**Step 1.4: Hidden Bug Fix?**
Yes — this is a genuine bug fix. A missing NULL check before pointer
dereference is a real code defect.
Record: [Yes, this is a missing NULL check for a function that can fail]

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `drivers/video/fbdev/via/lcd.c`
- +3 lines added (NULL check, `return false`, blank line), 0 removed
- Function modified: `viafb_lcd_get_mobile_state()`
Record: [lcd.c +3/-0] [viafb_lcd_get_mobile_state] [Single-file surgical
fix]

**Step 2.2: Code Flow Change**
- Before: `ioremap()` → immediate `readw(biosptr)` — if biosptr is NULL,
  kernel oops
- After: `ioremap()` → NULL check → return `false` if NULL; otherwise
  proceed normally
Record: [Before: unchecked ioremap -> readw on potential NULL. After:
NULL check added, returns false on failure]

**Step 2.3: Bug Mechanism**
- Category: NULL pointer dereference / memory safety
- The ioremap() call can fail and return NULL. Without a check,
  `readw(biosptr)` dereferences NULL.
Record: [NULL pointer dereference] [Missing ioremap NULL check → readw
on NULL crashes kernel]

**Step 2.4: Fix Quality**
- Obviously correct — standard ioremap error-checking pattern used
  across the kernel
- Minimal — 2 lines of logic
- Return value of `false` is appropriate: the caller in `via_utility.c`
  simply won't set `LCD_Device` in the connect state, which is the
  correct degraded behavior
- Zero regression risk
Record: [Obviously correct, minimal fix, no regression risk]

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy code was introduced in commit `ac6c97e20f1bef` by Joseph Chan
on 2008-10-15 — the original viafb driver submission. This code has
existed since approximately v2.6.28.
Record: [Buggy code from ac6c97e20f1bef (Oct 2008), present since
~v2.6.28]

**Step 3.2: Fixes: Tag**
No Fixes: tag present. Expected for autosel candidates.
Record: [N/A — no Fixes: tag]

**Step 3.3: File History**
Only cosmetic changes in recent years (spelling fix, I2C terminology,
fallthrough macro). The function is completely unchanged since 2011
(`b65d6040e3a7cd` by Stephen Hemminger was the last substantive touch).
Record: [No prerequisites. Completely standalone fix. No series.]

**Step 3.4: Author**
Wang Jun has only 2 commits in the tree. Helge Deller is the fbdev
subsystem maintainer who signed off.
Record: [Author is not a subsystem regular; maintainer (Helge Deller)
signed off]

**Step 3.5: Dependencies**
None — the fix is completely self-contained.
Record: [No dependencies. Applies standalone.]

---

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.5:**
b4 dig failed to find the original patch submission. Lore.kernel.org is
behind Anubis anti-bot protection and could not be fetched. No mailing
list discussion could be reviewed.
Record: [b4 dig: no match found] [Lore: blocked by Anubis] [UNVERIFIED:
Could not review mailing list discussion]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
`viafb_lcd_get_mobile_state()` — the only function touched.

**Step 5.2: Callers**
- `viafb_lcd_get_mobile_state()` is called from
  `viafb_get_device_connect_state()` in `via_utility.c` (line 31)
- `viafb_get_device_connect_state()` is called from the ioctl handler
  `VIAFB_GET_DEVICE_CONNECT` in `viafbdev.c` (line 558)
- This makes the buggy path **reachable from userspace** via ioctl.
Record: [Call chain: ioctl(VIAFB_GET_DEVICE_CONNECT) →
viafb_get_device_connect_state() → viafb_lcd_get_mobile_state() →
ioremap → readw(NULL)]

**Step 5.3-5.4: Callees/Call Chain**
The function calls `ioremap()`, `readw()`, `readb()`, `iounmap()`. It
maps the VGA BIOS ROM at physical address 0xC0000 to check if the system
is mobile (laptop) hardware.
Record: [ioremap maps VGA BIOS ROM; readw/readb parse BIOS tables]

**Step 5.5: Similar Patterns**
Missing ioremap checks are a common class of bug across the kernel. Many
similar fixes have been applied.
Record: [Common bug pattern - missing ioremap NULL check]

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable?**
Yes. The buggy code was introduced in 2008 and is present in ALL active
stable trees. Only cosmetic changes since v5.15 (spelling fix, I2C
terminology).
Record: [Present in all stable trees: 5.10, 5.15, 6.1, 6.6, etc.]

**Step 6.2: Backport Complications**
None. The file has barely changed. The patch should apply cleanly to all
stable trees.
Record: [Clean apply expected in all stable trees]

**Step 6.3: Related Fixes in Stable**
None found. This bug has never been fixed before.
Record: [No related fixes in stable]

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem Criticality**
- Subsystem: `drivers/video/fbdev` (framebuffer device drivers)
- Sub-subsystem: VIA framebuffer (viafb) — legacy VIA chipset graphics
- Criticality: **PERIPHERAL** — very niche, legacy hardware from
  mid-2000s
Record: [fbdev/viafb, PERIPHERAL criticality]

**Step 7.2: Subsystem Activity**
Very low activity. Last substantive changes to this file were years ago.
The driver is effectively in maintenance-only mode.
Record: [Very low activity — maintenance only]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Only users of VIA framebuffer hardware with this specific ioctl call
path.
Record: [Driver-specific, very niche hardware]

**Step 8.2: Trigger Conditions**
- Requires `ioremap(0xC0000, 0x10000)` to fail
- This maps the standard VGA BIOS ROM — on VIA hardware this should
  almost always succeed
- Could theoretically fail under extreme memory pressure
- Reachable from userspace ioctl (unprivileged user could trigger it if
  they have access to the fbdev device)
Record: [Extremely unlikely trigger; ioremap of BIOS ROM address rarely
fails on real hardware]

**Step 8.3: Failure Mode Severity**
- If triggered: NULL pointer dereference → kernel oops/crash
- Severity: **HIGH** if triggered (kernel crash), but probability is
  very low
Record: [Kernel oops, HIGH severity, VERY LOW probability]

**Step 8.4: Risk-Benefit**
- Benefit: LOW-MEDIUM — prevents a theoretical NULL deref on niche
  hardware
- Risk: VERY LOW — 2 lines, obviously correct, zero regression potential
- Ratio: favorable — essentially zero cost to include
Record: [Low benefit, very low risk, favorable ratio]

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**

FOR backporting:
- Fixes a genuine NULL pointer dereference (kernel crash)
- Extremely small (2 lines of logic) and obviously correct
- Zero regression risk
- Present in all stable trees, applies cleanly
- Code is reachable from userspace via ioctl
- Standard defensive fix pattern used across the kernel

AGAINST backporting:
- Bug has existed since 2008 (~17 years) without any reports
- Target hardware (VIA framebuffer) is extremely niche/legacy
- ioremap(0xC0000) failure on real VIA hardware is near-impossible
- No Reported-by, no syzbot finding, no user complaints
- Appears to be static analysis / code review finding, not a real-world
  bug

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — standard ioremap check
   pattern
2. Fixes a real bug? **YES** — missing NULL check is a real code defect,
   though theoretical
3. Important issue? **BORDERLINE** — crash if triggered, but trigger is
   extremely unlikely
4. Small and contained? **YES** — 2 lines, single function
5. No new features or APIs? **YES** — purely defensive
6. Can apply to stable? **YES** — clean apply expected

**Step 9.3: Exception Categories**
None apply.

**Step 9.4: Decision**
This is a borderline case. The fix prevents a genuine NULL pointer
dereference but on a near-impossible code path for niche hardware that
no one has reported in 17 years. However, the fix is so small (2 lines)
and so obviously correct that it carries essentially zero regression
risk. The cost of including it is nil, while it does improve code
correctness and prevents a theoretical kernel crash reachable from
userspace.

---

## Verification

- [Phase 1] Parsed subject: "fbdev: viafb: check ioremap return value" —
  adding missing NULL check
- [Phase 1] Parsed tags: only author SOB and maintainer SOB, no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff analysis: +3 lines in viafb_lcd_get_mobile_state(),
  adds NULL check after ioremap(), returns false on failure
- [Phase 2] Verified: readw(biosptr) immediately follows ioremap()
  without check — confirmed NULL deref risk
- [Phase 3] git blame: buggy code introduced in ac6c97e20f1bef (Joseph
  Chan, 2008-10-15), present since ~v2.6.28
- [Phase 3] git log -20: confirmed only cosmetic changes to lcd.c since
  2008
- [Phase 3] git tag --contains: confirmed ac6c97e20f1bef present in
  p-5.10, p-5.15 (all stable trees)
- [Phase 4] b4 dig -c: failed to find matching patch — no lore URL
  available
- [Phase 4] UNVERIFIED: Could not review mailing list discussion due to
  b4 failure and Anubis blocking lore
- [Phase 5] Grep viafb_lcd_get_mobile_state: confirmed call chain ioctl
  → viafb_get_device_connect_state → viafb_lcd_get_mobile_state
- [Phase 5] Verified: VIAFB_GET_DEVICE_CONNECT ioctl at
  viafbdev.c:557-561 makes path reachable from userspace
- [Phase 5] Verified: on ioremap failure, returning false causes caller
  to skip LCD_Device — safe degradation
- [Phase 6] git log v6.6.. and v5.15..: confirmed minimal changes (only
  cosmetic), clean apply expected
- [Phase 8] Trigger analysis: ioremap(0xC0000, 0x10000) maps standard
  VGA BIOS ROM; failure is extremely unlikely on real VIA hardware

**YES**

 drivers/video/fbdev/via/lcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/via/lcd.c b/drivers/video/fbdev/via/lcd.c
index 8673fced87492..3fa2304fbda7e 100644
--- a/drivers/video/fbdev/via/lcd.c
+++ b/drivers/video/fbdev/via/lcd.c
@@ -954,6 +954,9 @@ bool viafb_lcd_get_mobile_state(bool *mobile)
 	u16 start_pattern;
 
 	biosptr = ioremap(romaddr, 0x10000);
+	if (!biosptr)
+		return false;
+
 	start_pattern = readw(biosptr);
 
 	/* Compare pattern */
-- 
2.53.0

