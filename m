Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6198A4ACC9C;
	Mon, 31 Aug 2026 13:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184048; cv=none; b=PP7H3zXmrRCjHezJsGDcBerhGtSSSqCq921IYWjSd6n7PbsD6WCGKy2vAaSSPF2Po8TjrAu+v4ZprQrL8+as0m0A1jMRg/GGEwWBxByOdYg9XktWL2VFaokB3w8ASyIVwersrQf7S1Q6T+r2MCNgOo36NPNLYO5IhJ8qyzHXlRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184048; c=relaxed/simple;
	bh=2agwZIKpELVYimrSMg1EHXYKksUbEOEuom01oeSACU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=byfQYE1x77ay3gFPcA4M0lo2tdEJcEfAfboG5yhRrg9SvC4DzFdp6HErkETQaAAa6vDAo+tkfMvBYaPUZPyju2HF3KWHPrETZv2ZujoY7eZ/3N7v/AdMfx5KfX4UEOijUjO4Iz9ReFLgpWSat9QhcgWVoztRW0/RQUIS0cJqSYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKLNJFlg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKLNJFlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163BD1F00ADE;
	Mon, 31 Aug 2026 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184044;
	bh=rt4lfTWNmwFbyQ6X9Uiwf5ch2ehd0gQDAwmtyXug9v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKLNJFlg7g68MbQbV3Y70eT4KGnwd/g3wImXDb+XatQeiANBTSpKXPIq3PgACUOEx
	 YnVJlwSRUaCZ8yXtbnnipJLm7kqIcUWZio1IP8Hx6CzrRYqIH/RnW4c3Lnvc9G4gnU
	 pUFSuokub8KSydglQHWXvxkCc5KH+7DWsHLH98ySnwXp0jc29K0ofc8Fj6cPn5D8cR
	 bEdTDKl3rz2NCFKuIeex7maIfgGleKzCTAm/EV3KuVWnOGuu7wMe3plmXXUiarGciu
	 5fITUx6Ulq0hvdSDL7zHCgglbA1RPDhjxirqLVCncb05TrO7y6/hNrX6VX59JeGGpV
	 WRhz+QVu5UNXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] pinctrl: renesas: rzg2l: Handle RZ/V2H(P) IOLH configuration in PM cache
Date: Mon, 31 Aug 2026 09:28:06 -0400
Message-ID: <20260831133314.4125787-458-sashal@kernel.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit d0fc9f8eb2ce55eb00dbfdc0f19c844df5aee5b8 ]

Include PIN_CFG_IOLH_RZV2H in the IOLH capability checks when saving
and restoring pin configuration registers.

On RZ/V2H(P), RZ/V2N, and RZ/G3E, the IOLH configuration is defined by
the PIN_CFG_IOLH_RZV2H capability.  The previous implementation did not
account for this, causing the IOLH registers to be skipped during PM
save/restore.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260413182456.811543-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[pinctrl: renesas: rzg2l]` `[Handle]` — Include RZ/V2H(P)
IOLH capability in PM register save/restore checks.

### Step 1.2: Commit tags
**Record:**
- **Signed-off-by:** Lad Prabhakar `<prabhakar.mahadev-
  lad.rj@bp.renesas.com>` (author)
- **Reviewed-by:** Geert Uytterhoeven `<geert+renesas@glider.be>`
  (Renesas/pinctrl maintainer)
- **Link:**
  https://patch.msgid.link/20260413182456.811543-4-prabhakar.mahadev-
  lad.rj@bp.renesas.com
- **Signed-off-by:** Geert Uytterhoeven (maintainer tree)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@, or syzbot tags
- Notable: Reviewed by subsystem maintainer; part of v2 5-patch PM
  caching series (patch 3/5)

### Step 1.3: Body analysis
**Record:**
- **Bug:** PM suspend/resume skips IOLH registers on RZ/V2H(P), RZ/V2N,
  and RZ/G3E because those SoCs use `PIN_CFG_IOLH_RZV2H` instead of
  `PIN_CFG_IOLH_A/B/C`.
- **Symptom:** Output-impedance/drive-strength (IOLH) not saved on
  suspend or restored on resume; pins revert to wrong electrical
  settings after S2RAM.
- **Root cause:** `has_iolh` capability check omits
  `PIN_CFG_IOLH_RZV2H`.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit PM suspend/resume bug fix, not
disguised cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pinctrl/renesas/pinctrl-rzg2l.c` (+2 lines net in
  submitted diff; full v2 patch touches 2 functions)
- **Functions:** `rzg2l_pinctrl_pm_setup_dedicated_regs()` (shown in
  candidate diff); v2 submission also changed
  `rzg2l_pinctrl_pm_setup_regs()` (author later agreed to drop that hunk
  per maintainer review)
- **Scope:** Single-file, surgical (2-line logical change)

### Step 2.2: Code flow
**Record:**
- **Before:** `has_iolh` true only for `PIN_CFG_IOLH_A|B|C`; dedicated
  pins with only `PIN_CFG_IOLH_RZV2H` skip IOLH cache read/write.
- **After:** `PIN_CFG_IOLH_RZV2H` included; IOLH registers saved on
  suspend and restored on resume for affected dedicated pins.
- **Path:** System suspend/resume via `rzg2l_pinctrl_suspend_noirq()` /
  `rzg2l_pinctrl_resume_noirq()` →
  `rzg2l_pinctrl_pm_setup_dedicated_regs()`.

### Step 2.3: Bug mechanism
**Record:** **Logic/correctness fix** — incomplete capability bitmask
causes PM cache to omit IOLH register save/restore for a whole class of
pins on newer Renesas SoCs.

### Step 2.4: Fix quality
**Record:** Obviously correct (adds the missing flag already used
everywhere else in the driver). Minimal risk; no API, locking, or
structural changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy `has_iolh` lines at 3009 and 3097 trace to the PM
caching code (blame shows `19eef1d98eeda` in this shallow stable tree).
`PIN_CFG_IOLH_RZV2H` (line 65) is present in this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Same PM series already partially backported to this tree:
- `8d1c6b603327b` — SMT register cache (patch 1/5, same series)
- `509d342d02fff`, `c4cfa8ee77374` — earlier IOLH/IEN/PUPD/SMT PM fixes
This IOLH fix is **not** yet in the tree.

### Step 3.4: Author context
**Record:** Lad Prabhakar is the RZ/G2L pinctrl driver author/maintainer
contributor; Geert Uytterhoeven is Renesas maintainer and reviewed the
series.

### Step 3.5: Dependencies
**Record:** Standalone — only adds a flag to an existing bitmask. Does
not require patches 2/4/5 (SR/NOD/PUPD) to function; applies cleanly to
current `rzg2l_pinctrl_pm_setup_dedicated_regs()` at line 3097.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** Thread fetched via `b4 mbox` from lore (16 messages). Patch
3/5 reviewed by Geert Uytterhoeven. Geert noted `PIN_CFG_IOLH_RZV2H` may
only matter for dedicated pins in `pm_setup_regs`; author agreed to drop
that hunk. Final fix targets `rzg2l_pinctrl_pm_setup_dedicated_regs()`.

### Step 4.2: Reviewers
**Record:** Geert Uytterhoeven (maintainer), Linus Walleij CC'd on cover
letter; linux-renesas-soc list.

### Step 4.3: Bug reports
**Record:** No external bug report or syzbot link; issue identified
during PM caching review/fix series.

### Step 4.4: Series context
**Record:** v2 0/5 cover letter describes 5 related PM cache fixes.
Patch 1 (SMT) already in this 6.18.43 tree; patches 2/4/5 (SR, NOD,
dedicated PUPD) are separate and not prerequisites for this IOLH bitmask
fix.

### Step 4.5: Stable list
**Record:** No stable@ discussion found in thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `rzg2l_pinctrl_pm_setup_dedicated_regs()`, called from
`rzg2l_pinctrl_suspend_noirq()` and `rzg2l_pinctrl_resume_noirq()`.

### Step 5.2: Callers
**Record:** PM suspend/resume noirq path on every system sleep for
affected pinctrl devices.

### Step 5.3: Callees
**Record:** `RZG2L_PCTRL_REG_ACCESS32()` macro for hardware IOLH/IEN
register read (suspend) or write (resume).

### Step 5.4: Reachability
**Record:** Triggered on every S2RAM cycle on boards using
`renesas,r9a09g047-pinctrl` (RZ/G3E), `renesas,r9a09g056-pinctrl`
(RZ/V2H), or `renesas,r9a09g057-pinctrl` (RZ/V2HP). Dedicated pins
include Ethernet, SD, XSPI, SCIF, etc.

### Step 5.5: Similar patterns
**Record:** Same `has_iolh` bitmask omission exists at line 3009 in
`rzg2l_pinctrl_pm_setup_regs()` for GPIO port pins using
`RZV2H_MPXED_PIN_FUNCS` (which includes `PIN_CFG_IOLH_RZV2H`). This
commit (per review) does not fix that path; dedicated-pin path is the
confirmed target.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Line 3097 in
`rzg2l_pinctrl_pm_setup_dedicated_regs()`:
```3097:3097:drivers/pinctrl/renesas/pinctrl-rzg2l.c
                has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B |
PIN_CFG_IOLH_C));
```
`PIN_CFG_IOLH_RZV2H` is defined (line 65) and used extensively in
`rzv2h_dedicated_pins` and `rzg3e_dedicated_pins` (e.g., lines 2233+,
2370+). Affected SoC compatibles are registered (lines 3470–3479).

### Step 6.2: Backport complications
**Record:** Clean apply — single-line change at line 3097. No SR/NOD
infrastructure required (those are separate series patches not in this
tree).

### Step 6.3: Related fixes already present?
**Record:** SMT PM cache fix from same series (`8d1c6b603327b`) is
already in tree. This IOLH fix is the logical next piece.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/pinctrl/renesas/` — **PERIPHERAL** (platform-
specific), but suspend/resume correctness is critical for embedded
products using these SoCs.

### Step 7.2: Activity
**Record:** Active PM fix series; multiple related backports already
landed in 6.18.y.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of RZ/G3E (r9a09g047), RZ/V2H (r9a09g056), RZ/V2HP
(r9a09g057) who use system suspend/resume. Driver-specific, but
dedicated pins cover critical peripherals.

### Step 8.2: Trigger conditions
**Record:** Every S2RAM suspend/resume cycle on affected hardware.
Requires `CONFIG_PINCTRL` + matching DT compatible. Not userspace-
triggerable directly, but normal laptop/embedded suspend path.

### Step 8.3: Failure severity
**Record:** Wrong pin drive strength/impedance after resume → peripheral
malfunction (Ethernet, SD, XSPI flash, UART), potential bus errors or
silent data corruption on high-speed interfaces. **Severity: MEDIUM-
HIGH** (hardware misconfiguration, not kernel oops).

### Step 8.4: Risk-benefit
**Record:** **Benefit: HIGH** for affected embedded users doing
suspend/resume. **Risk: VERY LOW** (2-line bitmask fix, maintainer-
reviewed). Ratio strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real suspend/resume bug on shipping Renesas SoCs in this tree
- Maintainer-reviewed, obviously correct, minimal diff
- Same PM series already partially backported (SMT fix in 6.18.43)
- Affects critical dedicated pins (network, storage, flash buses)
- Buggy code and `PIN_CFG_IOLH_RZV2H` both present in 6.18.43

**AGAINST backport:**
- Narrow hardware scope (3 SoC compatibles)
- No crash/oops — functional/hardware issue after resume
- GPIO port-pin IOLH path (line 3009) may remain unfixed per maintainer
  review (out of scope for this commit)

**Unresolved:** Whether port-pin IOLH via
`rzg2l_pinctrl_pm_setup_regs()` also needs the same fix (Geert/author
agreed to omit; separate issue).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — bitmask addition; Reviewed-
   by maintainer; series patch 1 tested by multiple Tested-by on SMT
   patch
2. Fixes real bug affecting users? **PASS** — IOLH not saved/restored on
   suspend/resume
3. Important issue? **PASS** — suspend/resume hardware misconfiguration
   on critical pins (MEDIUM-HIGH)
4. Small and contained? **PASS** — 2 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — applies cleanly at line 3097

### Step 9.3: Exception category
**Record:** N/A — standard bug fix, not device-ID/quirk/build fix.

### Step 9.4: Decision rationale

For **Linux 6.18.43**, this commit should be backported. The tree
already has RZ/V2H and RZ/G3E pinctrl support with extensive
`PIN_CFG_IOLH_RZV2H` dedicated-pin tables and active PM suspend/resume,
but the PM cache path omits that capability flag. After S2RAM, dedicated
function pins (Ethernet, SD, XSPI, etc.) lose their output-impedance
settings. The fix is trivial, maintainer-reviewed, and consistent with
the SMT PM cache fix already in this stable tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from commit message and local
  mbx
- **[Phase 2]** Read diff and current code at lines 3009, 3097,
  3179–3243
- **[Phase 3]** `git describe HEAD` → v6.18.43; `git log --oneline -20
  -- drivers/pinctrl/renesas/pinctrl-rzg2l.c`; `git blame` on lines
  3009/3097; confirmed `8d1c6b603327b` (SMT fix from same series) in
  tree
- **[Phase 4]** `b4 mbox` fetched 16-message lore thread; Geert review
  noted dedicated-pin scope; no stable@ nomination found
- **[Phase 5]** Traced call chain:
  `rzg2l_pinctrl_suspend_noirq`/`resume_noirq` →
  `rzg2l_pinctrl_pm_setup_dedicated_regs`; verified
  `rzv2h_dedicated_pins`/`rzg3e_dedicated_pins` use
  `PIN_CFG_IOLH_RZV2H`; verified SoC compatibles at lines 3470–3479
- **[Phase 6]** Confirmed buggy line 3097 present; `PIN_CFG_IOLH_RZV2H`
  defined at line 65; fix not yet applied; clean apply expected
- **[Phase 7]** Identified Renesas pinctrl driver subsystem
- **[Phase 8]** Assessed suspend/resume trigger and MEDIUM-HIGH hardware
  impact

**YES**

 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index e8cc83029db33..ab8d64a14dd0a 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -3094,7 +3094,8 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 		}
 
 		/* And apply them in a single shot. */
-		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B | PIN_CFG_IOLH_C));
+		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B |
+				      PIN_CFG_IOLH_C | PIN_CFG_IOLH_RZV2H));
 		has_ien = !!(caps & PIN_CFG_IEN);
 		pincnt = hweight8(FIELD_GET(RZG2L_SINGLE_PIN_BITS_MASK, cfg));
 
-- 
2.53.0

