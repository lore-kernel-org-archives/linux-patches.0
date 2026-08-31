Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5127E46C836;
	Mon, 31 Aug 2026 13:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184054; cv=none; b=O6Maj1iV+44XSJPlnEK7fOsy46M8cqcsrsVKbifrL0E4rDvi/Qp5f/99iuFI0tGs2hbBBvS99BK7G4qfIyT0HI6c+39FeVAK4uPT9bLVvHKYyE/KiN7H/CpmErY7lg/uC7uO0uLiPI1kE+qOBA1JQlFCABUrZblcZPbYqeI8pls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184054; c=relaxed/simple;
	bh=Bsr9lZMj2YpFm0DKXbamRJxcRVX+1CESuY09Bs/c3B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fBoC5bqR6EiNZoLoPSO6PQ2TLPC6HHLqH95PZ/SUv34zIXreGOQJ8QyYAVvNALyuk3WJ+ONyWC7t5I+SYFl/tM1F5IyI2CZoqFwTk4vGPw4aD8PQwsi10kKPnj1Norj8AnNwpyadVBhsAM3XDmLage8ByvDenSYNHvuwHW+1B/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YU8mwBpl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YU8mwBpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727E51F00ACA;
	Mon, 31 Aug 2026 13:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184051;
	bh=OELHXWwG8PsGWExvJkYO4gN+2Y1ENCkqY6pnjaQQrYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YU8mwBplU/Kij9j6qnBBAutiptfECZjOCHMBt28eXnqXaHL0Rfzq6mYTdyBtlj2wB
	 ym+/yli9GVWH2CavdHTiKPN/WyTzc9BOnQXNktOQ5dhicPUiqe1EkGrRr1Vs0+xqCK
	 F4hq6is7aMcV3Cvdrgw2prKdpdD45zo6jCeHJhQkIAatZUxtw7hZHtE4MdFgxGO74U
	 X64DBhsZRoHraWgR1A2Tv2KwsYP2ruzi6SZmqja7dHsPRed+moKI2PBTNd/qph3SrR
	 K1/jIIbdAKdRJjY8rpXXV4TOk9l6woXuge3X7XViLr6LNlcZVYX22dPhUot/alKuq9
	 w6fijxujIt3Hw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wei Qisen <weixiansen574@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] net: sfp: add quirk for OEM 2.5G optical modules
Date: Mon, 31 Aug 2026 09:28:10 -0400
Message-ID: <20260831133314.4125787-462-sashal@kernel.org>
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

From: Wei Qisen <weixiansen574@163.com>

[ Upstream commit 5af067bf8a64dac896f120a98fe2ca656df92562 ]

Some OEM-branded SFP modules are incorrectly detected as
1000Base-X and fail to establish link on 2.5G-capable ports.

These modules do not properly advertise 2500Base-X capability
in their EEPROM and require forcing the correct SerDes mode.

Add sfp_quirk_2500basex for:

  - OEM SFP-2.5G-LH03-B
  - OEM SFP-2.5G-LH20-A

Both modules report:

  Vendor name: OEM
  Vendor PN: SFP-2.5G-LH03-B / SFP-2.5G-LH20-A

Tested on OpenWrt with successful 2.5G link establishment.

Signed-off-by: Wei Qisen <weixiansen574@163.com>
Link: https://patch.msgid.link/20260526055206.1750-1-weixiansen574@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: sfp: add quirk for OEM 2.5G optical
modules`

**Local tree:** Linux **6.18.44** (`stable/linux-6.18.y`, detached HEAD)
**Mainline commit:** `5af067bf8a64d` (not yet in this stable tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[net: sfp]` `[add]` — add hardware quirk entries for two
OEM 2.5G optical SFP modules that misreport their EEPROM capabilities.

### Step 1.2: Parse all commit message tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Wei Qisen \<weixiansen574@163.com\> (author) |
| Link |
https://patch.msgid.link/20260526055206.1750-1-weixiansen574@163.com |
| Signed-off-by | Jakub Kicinski \<kuba@kernel.org\> (netdev maintainer,
committer) |

**Notable patterns:** No `Fixes:` tag (expected for manual review). No
`Reported-by: syzbot`. No explicit `Cc: stable@vger.kernel.org`.
Maintainer merge by Jakub Kicinski is a quality signal.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** OEM SFP-2.5G-LH03-B and SFP-2.5G-LH20-A modules do not
  advertise 2500Base-X in EEPROM; kernel detects them as 1000Base-X.
- **Symptom:** Link fails to establish on 2.5G-capable ports.
- **Root cause:** Incorrect EEPROM transceiver capability reporting;
  SerDes mode must be forced via `sfp_quirk_2500basex`.
- **Version info:** None stated; tested on OpenWrt.
- **Testing claim:** "Tested on OpenWrt with successful 2.5G link
  establishment."

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit hardware workaround.
Functionally it fixes a link-establishment failure (hardware
enablement), not a kernel crash. Falls squarely under the **hardware
quirk/workaround** stable exception category.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `drivers/net/phy/sfp.c` (+2 lines, 0 removed)
- **Functions modified:** None — only `sfp_quirks[]` static table
- **Scope:** Single-file, surgical, 2-line table addition

### Step 2.2: Code flow change
**Record:**
- **Hunk (OEM quirk block):** Before → two new `SFP_QUIRK_S("OEM", ...,
  sfp_quirk_2500basex)` entries for `SFP-2.5G-LH03-B` and
  `SFP-2.5G-LH20-A`, inserted after existing OEM BX10 entries. After →
  `sfp_lookup_quirk()` matches these modules and applies the existing
  `sfp_quirk_2500basex` callback during module insertion.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workaround (h)
- **Mechanism:** Without the quirk, `sfp_module_parse_support()` uses
  EEPROM data and advertises 1000Base-X. `sfp_quirk_2500basex()` adds
  `ETHTOOL_LINK_MODE_2500baseX_Full` and `PHY_INTERFACE_MODE_2500BASEX`
  to module caps, forcing the correct SerDes mode. Identical to the
  already-in-tree OEM BX10 quirk (`a850355610250`).

### Step 2.4: Fix quality assessment
**Record:** Obviously correct — reuses a well-established callback
already applied to ~10 other modules in the same table. Minimal, no new
logic. Regression risk: very low; only affects exact vendor+PN match
(`"OEM"` / `"SFP-2.5G-LH03-B"` or `"SFP-2.5G-LH20-A"`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** The two new lines do not exist yet. Adjacent OEM BX10 quirk
lines (584–585) were introduced by commit `a850355610250` ("net: sfp:
add quirk for 2.5G OEM BX SFP", Feb 2025), present in this tree.
`sfp_quirk_2500basex` was first introduced in `ad651d68cee75` (HG
MXPD-483II), ancestor of v6.18.

### Step 3.2: Follow Fixes: tag
**Record:** No `Fixes:` tag present — not applicable.

### Step 3.3: File history for related changes
**Record:** Recent `sfp.c` changes in this tree include Hisense/HSGQ
GPON quirks (`0a59c12ce50a7`), Ubiquiti fix (`3b4df3d43ae42`), Huawei
fixup (`ecb4ed7a723f0`). The OEM BX10 quirk (`a850355610250`) is the
direct precedent — same author pattern, same callback, same vendor
namespace. Standalone single-patch fix (v1→v2 series, no other patches
required).

### Step 3.4: Author's other commits
**Record:** Wei Qisen has no other commits in this stable tree. Jakub
Kicinski committed and maintains the SFP subsystem. The identical-
pattern BX10 quirk was authored by Birger Koblitz with `Reviewed-by:
Daniel Golle`.

### Step 3.5: Dependent/prerequisite commits
**Record:** No dependencies. Requires only:
- `sfp_quirk_2500basex` function ✓ (present)
- `SFP_QUIRK_S` macro ✓ (present)
- OEM quirk block ✓ (present, including BX10-D/U entries)
- `sfp_lookup_quirk()` / `sfp_init_module()` quirk dispatch ✓ (present)

All prerequisites are ancestors of v6.18 in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260526055206.1750-1-weixiansen574@163.com
- **Series revisions:** v1 (2026-05-20), v2 (2026-05-24) — committed
  version matches v2
- **Reviewer feedback:** Thread contains only the patch submission and
  patchwork-bot merge notification. No NAKs, no substantive review
  comments.
- **Stable nominations:** None found in thread.

### Step 4.2: Who reviewed the patch
**Record:** **b4 dig -w** recipients: Wei Qisen, netdev@vger.kernel.org,
kuba@kernel.org, avinash.duduskar@gmail.com, linux-
kernel@vger.kernel.org. netdev maintainer (Kicinski) was CC'd and
applied the patch.

### Step 4.3: Bug report search
**Record:** No external bug report (bugzilla/syzbot). Author-reported
hardware failure with OpenWrt testing as evidence.

### Step 4.4: Related patches/series
**Record:** Standalone 1-patch series. Direct precedent: `a850355610250`
(OEM BX10 2.5G quirk, already in 6.18.y).

### Step 4.5: Stable mailing list history
**Record:** No stable-list discussion found for this specific quirk.
(Lore web fetch was blocked by bot protection for manual URL access; b4
dig mbox download succeeded.)

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** No functions modified. Relevant existing functions:
`sfp_quirk_2500basex()`, `sfp_lookup_quirk()`, `sfp_init_module()`,
`sfp_module_insert()`.

### Step 5.2: Trace callers
**Record:** `sfp_lookup_quirk()` called from `sfp_sm_mod_probe()` (line
2491). `quirk->support` invoked from `sfp_init_module()` in `sfp-bus.c`
(line 328), called via `sfp_module_insert()` (line 2624) during SFP
module hot-insert state machine. Triggered on every SFP module insertion
for matching hardware.

### Step 5.3: Trace callees
**Record:** `sfp_quirk_2500basex()` calls
`linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT, ...)` and
`__set_bit(PHY_INTERFACE_MODE_2500BASEX, ...)`.

### Step 5.4: Call chain / reachability
**Record:** SFP cage hot-insert → `sfp_sm_mod_probe()` →
`sfp_lookup_quirk()` → module insert → `sfp_init_module()` →
`sfp_quirk_2500basex()`. Reachable from normal hardware operation
(plugging in an SFP module). Affects `CONFIG_SFP` users with these
specific modules on 2.5G-capable MAC/PHY ports.

### Step 5.5: Similar patterns
**Record:** At least 10 existing modules use `sfp_quirk_2500basex` in
the same table, including OEM `SFP-2.5G-BX10-D/U` (lines 584–585). This
commit extends the same pattern to two more OEM part numbers.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** The quirk table and `sfp_quirk_2500basex`
infrastructure exist, but `SFP-2.5G-LH03-B` and `SFP-2.5G-LH20-A`
entries are **missing** (`git log -S 'SFP-2.5G-LH03-B'` returns no
commits in this tree). Without these entries, affected modules fall
through to EEPROM-based detection and fail to link at 2.5G. Bug has
existed since the OEM BX10 quirk was added (modules were always broken
on 6.18.y for these PNs).

### Step 6.2: Backport complications
**Record:** **Clean apply confirmed.** `git show 5af067bf8a64d --
drivers/net/phy/sfp.c | git apply --check -v` succeeds on v6.18.44. Two-
line insertion at lines 585–586 after BX10 entries. No conflicts
expected.

### Step 6.3: Related fixes already present?
**Record:** The precedent OEM BX10 quirk (`a850355610250`) is already in
this tree. No duplicate fix for LH03-B/LH20-A exists.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/net/phy (SFP)** — IMPORTANT. Affects network
connectivity for SFP-based routers/switches/embedded devices (OpenWrt,
etc.). Not core-kernel-wide, but critical for affected hardware users.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — 20+ recent commits to `sfp.c` in this
tree, including multiple quirk additions in 2025–2026.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected?
**Record:** Users of OEM `SFP-2.5G-LH03-B` or `SFP-2.5G-LH20-A` optical
modules on 2.5G-capable SFP ports with `CONFIG_SFP` enabled. Platform-
specific / hardware-specific, but OpenWrt testing indicates real-world
router deployments.

### Step 8.2: Trigger conditions
**Record:** Inserting one of these two specific SFP modules into a
2.5G-capable port. Deterministic (EEPROM vendor/PN match), not a race.
Any user with this hardware hits it on every module insertion.

### Step 8.3: Failure mode severity
**Record:** **No network link at 2.5G** (module misidentified as
1000Base-X). Severity: **HIGH** for affected users (complete loss of
connectivity at intended speed), but not a kernel crash/oops/data-
corruption. Functional hardware enablement issue — same severity class
as other SFP quirks already in stable.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** HIGH for affected hardware users (2.5G link works)
- **Risk:** VERY LOW (2 lines, exact vendor+PN match, proven callback)
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compiled

**FOR backport:**
- Hardware quirk exception — explicitly allowed and common in stable
- Fixes real, reproducible hardware failure (no 2.5G link)
- Identical pattern to `a850355610250` already in 6.18.y
- 2 lines, applies cleanly, no dependencies
- Tested on OpenWrt
- Merged by netdev maintainer Jakub Kicinski
- All prerequisite infrastructure present in v6.18.44

**AGAINST backport:**
- Narrow hardware audience (two specific OEM part numbers)
- No kernel crash/security issue — connectivity only
- No explicit stable nomination or Reviewed-by in mailing list thread

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reuses proven callback;
   OpenWrt tested
2. Fixes a real bug affecting users? **PASS** — link failure on specific
   hardware
3. Important issue? **PASS** — complete link failure for affected users
   (hardware quirk category)
4. Small and contained? **PASS** — 2 lines, one file
5. No new features or APIs? **PASS** — table entries only, no new
   callbacks
6. Can apply to local tree? **PASS** — verified clean apply on v6.18.44

### Step 9.3: Exception categories
**Record:** **Hardware quirk/workaround** — SFP module EEPROM
misreporting, forced SerDes mode via existing `sfp_quirk_2500basex`.
Automatic stable qualifier per stable-kernel-rules exceptions.

### Step 9.4: Decision rationale

This commit adds two entries to the existing SFP quirk table so that OEM
2.5G optical modules (`SFP-2.5G-LH03-B`, `SFP-2.5G-LH20-A`) that
misreport their EEPROM capabilities can establish 2.5G links. The fix is
trivial (2 lines), applies cleanly to Linux 6.18.44, requires no
prerequisites beyond code already present in this tree, and follows the
exact same pattern as the OEM BX10 quirk already shipped in 6.18.y. For
users with this hardware — common in OpenWrt router deployments — the
module simply does not work without this quirk.

---

## Verification

- **[Phase 1]** `git show 5af067bf8a64d`: parsed subject, tags, body
- **[Phase 2]** Read `sfp.c` lines 454–591, `sfp-bus.c` lines 318–329:
  confirmed 2-line table addition using existing callback
- **[Phase 3]** `git describe HEAD`: v6.18.44; `git log --reverse -S
  'sfp_quirk_2500basex'`: first introduced `23571c7b96437`; `git merge-
  base --is-ancestor ad651d68cee75 v6.18`: 2500basex in v6.18; `git
  merge-base --is-ancestor a850355610250 v6.18`: BX OEM quirk in v6.18;
  `git log -S 'SFP-2.5G-LH03-B'`: no commits in stable tree
- **[Phase 3]** `git merge-base --is-ancestor 5af067bf8a64d HEAD`:
  commit NOT in stable tree yet
- **[Phase 4]** `b4 dig -c 5af067bf8a64d`: lore URL found; `b4 dig -a`:
  v1/v2 series; `b4 dig -w`: netdev maintainer CC'd; mbox saved and
  read: patchwork-bot merge notice only, no NAKs, no stable Cc
- **[Phase 5]** `grep sfp->quirk drivers/net/phy/sfp.c`: call chain at
  lines 2491, 2625; `grep quirk->support drivers/net/phy/sfp-bus.c`:
  line 328
- **[Phase 6]** `grep 'SFP-2.5G-LH'`: not in tree; `git show
  5af067bf8a64d -- drivers/net/phy/sfp.c | git apply --check -v`:
  applies cleanly
- **[Phase 7]** `git branch`: HEAD at `stable/linux-6.18.y`; `grep
  CONFIG_SFP drivers/net/phy/Kconfig`: tristate SFP cage support
- **[Phase 8]** Failure mode assessed from commit message and
  `sfp_quirk_2500basex` code: link failure, not crash

**YES**The background searches finished and matched the earlier
analysis:

- **Commit search:** `SFP-2.5G-LH03-B` / `SFP-2.5G-LH20-A` are not in
  the 6.18.44 tree; the fix is mainline commit `5af067bf8a64d`.
- **Author search:** Wei Qisen has no other commits here; the closest
  precedent is the existing OEM BX10 quirk (`a850355610250`).

**Verdict for Linux 6.18.y: YES** — a 2-line hardware quirk that applies
cleanly and follows the same pattern as quirks already in this tree.That
search confirms **`SFP-2.5G-LH03-B` is not in the 6.18.44 tree history**
— only the related OEM BX10 quirk (`a850355610250`) is present. The
backport recommendation remains **YES**.

 drivers/net/phy/sfp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 9683f9c2cd882..af43530ffb2c3 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -583,6 +583,8 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_S("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 	SFP_QUIRK_S("OEM", "SFP-2.5G-BX10-D", sfp_quirk_2500basex),
 	SFP_QUIRK_S("OEM", "SFP-2.5G-BX10-U", sfp_quirk_2500basex),
+	SFP_QUIRK_S("OEM", "SFP-2.5G-LH03-B", sfp_quirk_2500basex),
+	SFP_QUIRK_S("OEM", "SFP-2.5G-LH20-A", sfp_quirk_2500basex),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("Turris", "RTSFP-2.5G", sfp_fixup_rollball),
-- 
2.53.0

