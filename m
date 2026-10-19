Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD23B5AAA58;
	Mon, 19 Oct 2026 14:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418438; cv=none; b=IsA7FqEn7z93/oDY9UVyqRWpoaqwKDJDtCL4E5t9EeKBE7szUvp3pYctx9jeqyx3l/eAUDqFw+MT8hzwF7+7bDvoQhjfPiHubXk8C+vtY87WI7HfBsXp9Dd7wEQcCZRY4iqCI83tyt9qOQChfZwkd+szlARS24T9LNZwfiDbnGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418438; c=relaxed/simple;
	bh=ykslW100lOSqo/UUJsC+LI0VyjBgFKk9wc+1qs9RvQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUjtpYpYPRG/EhWOHwTEJOkYNEJ9x820ubJTSRzZbTNvp9eRdDdmaOgDZ1O7H5bUO7FA80XWO8M5dKoYDb2nZRNK+Ghlp7RBjoEo6hsLgvU8T3BaRymRaHLoVLaAj9WIBoaba/xOM+FGtCZSVlBXkXrw9yP8kSY6KwjF5gzaFdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KZ97VlBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KZ97VlBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEFE1F000C7;
	Mon, 19 Oct 2026 14:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418435;
	bh=Yjbc0LAnj7QlsZQtLoEmr1Zb0PtvOYs17wYrifYf6O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZ97VlBKKbNCT/WjUlIHQ24RTyR5Ae0QZgZusoduw+z05KqicNVaPWjYXy7cqO/ex
	 LJl3b9YVh2BpfPBT7XXlvU/j7n/e29ULGPShcWgd2Wd1kl6TcP4YY/k0O5VJRL1sR8
	 eTB2zGIcuWAbCo6EqwARq+uV8lMxLpONq0dq4zjzVVfArlaQtmwiV8RPeLneSdXusy
	 bPu6QQtkhjck2R852zUbWjieZrlDtnTZY3biALNig/BW5iyCG9H7ELYxCDqAkP4NTU
	 n2kR6o0ScMtaAo7awLHvPSMpn5qN/2+gDV/6ft1nKTjbLK0Ao3dQ/BxnevnY7AALUl
	 iD31QmqjNJ/NQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] net: sfp: add quirk for HORACO copper SFP+ module
Date: Mon, 19 Oct 2026 09:48:58 -0400
Message-ID: <20261019135441.1420968-247-sashal@kernel.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 1bb028baab541900d3603d4f93c1c0fb5aba5401 ]

Add quirk for a copper SFP+ module that identifies itself as "OEM"
"HC-10GE-113C". It uses RollBall protocol to talk to the PHY.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260719100158.874882-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **v7.3-rc4** (mainline `7.3.0-rc4`). The candidate is
`1bb028baab541` (`net: sfp: add quirk for HORACO copper SFP+ module`).
The SFP quirk table and `sfp_fixup_rollball()` are present here, so this
is evaluated as a hardware-quirk backport on technical merit.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[net: sfp:] [add] [quirk for HORACO copper SFP+ module]**
- Subsystem: `net: sfp` (SFP cage / phylink)
- Verb: **add** — here it is a hardware quirk table entry, not a new
  driver or API

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected; this is not a regression from a prior
  kernel commit)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Andrew Lunn `<andrew@lunn.ch>` (PHY/SFP reviewer)
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260719100158.874882-1-olek2@wp.pl`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Aleksander Jan Bajkowski `<olek2@wp.pl>` (author);
  Jakub Kicinski `<kuba@kernel.org>` (netdev maintainer)
- Ignored: any pipeline “Upstream commit” / Sasha Levin SOB (none on
  this commit)

Notable: reviewed by Lunn, applied by Kicinski. No syzbot, no multi-user
reports.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** copper SFP+ identifying as vendor `"OEM"` / part
  `"HC-10GE-113C"` talks to its PHY with the RollBall I2C-to-MDIO
  protocol, which the EEPROM does not describe in a way the generic path
  understands.
- **Symptom:** PHY probe uses the wrong MDIO protocol (typically
  `MDIO_I2C_NONE` or C45), so the copper PHY is not found and the link
  does not come up.
- **Version info:** none in the message. Patch was sent as `[PATCH net-
  next]` on 2026-07-19; applied 2026-07-21; `git describe --contains` →
  **v7.3-rc1**.
- **Root cause (author):** module uses RollBall; needs an `sfp_quirks[]`
  match so `sfp_fixup_rollball()` runs.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not a hidden cleanup.** It is an explicit hardware quirk. That
is an allowed stable class (SFP_QUIRK_* / `stable-kernel-rules.rst`
“hardware quirk”), not a disguised leak/race.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/phy/sfp.c` — **+3 / −0**
- Data only: `sfp_quirks[]` (static const table)
- Scope: **single-file surgical quirk addition** (one `SFP_QUIRK_F` +
  comment)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** EEPROM vendor `"OEM"` + PN `"HC-10GE-113C"` does not match
  any quirk. `sfp_sm_mod_probe()` sets `mdio_protocol` from EEPROM
  (`MDIO_I2C_C45` if 10GBASE-T ECC, else `MDIO_I2C_NONE` for a module
  that does not identify as copper). `sfp_sm_probe_for_phy()` then
  either skips PHY probe or probes at the wrong address/protocol.
- **After:** `sfp_lookup_quirk()` matches exact vendor+part,
  `sfp_fixup_rollball()` sets `sfp->mdio_protocol = MDIO_I2C_ROLLBALL`
  and `phy_t_retry` to 1s. Probe uses `SFP_PHY_ADDR_ROLLBALL` and
  C45-over-RollBall.
- Path: **module insert / probe** (normal path for this SKU only).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** **(h) Hardware workaround** — SFP quirk
- **Mechanism:** broken/non-standard EEPROM vs actual RollBall PHY
  access. Fix is vendor/PN table entry calling existing
  `sfp_fixup_rollball()`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** obviously correct. Same pattern as FLYPRO `SFP-10GT-
  CS-30M`, Turris RTSFP-*, OEM SFP-10G-T. Match is exact (`sfp_match`
  requires equal length; this entry is not `SFP_QUIRK_F_PREFIX`).
- **Minimal:** 3 lines, no unrelated edits.
- **Regression risk:** very low. Only this vendor+PN pair.
  `sfp_fixup_rollball()` only sets protocol + retry interval.
- **Caveat (verified, not blocking):** some other OEM 10G copper entries
  use `sfp_fixup_rollball_cc` (also patches `extended_cc`). Author chose
  plain `sfp_fixup_rollball`; Lunn reviewed. If this SKU already has a
  valid ECC, CC extra is unnecessary.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- New lines authored in **1bb028baab541** (2026-07-19).
- Neighbors: YV XGSPON quirk (`dfec1c14aecee`, 2025) and OEM SFP-GE-T
  (`0805d67bc0ef95`, 2024).
- **Infrastructure:** `sfp_fixup_rollball()` introduced in
  **324e88cbe3b7b** (“net: sfp: add support for multigig RollBall
  transceivers”, 2022-10-03) — **v6.1-rc1**. Present in this tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Not a regression from a specific prior
commit. The module never worked without the quirk.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Same author, same pattern: `ddbf0e78a8b20` “net: sfp: add quirk for
  FLYPRO copper SFP+ module” (v6.17-rc5).
- Later on same file: hwmon leak fix; prefix-match for *other* OEM PNs
  (`f53167e29b8e9`); more ONT quirks. **None change the HORACO entry.**
- **Standalone**, not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Aleksander Jan Bajkowski is a regular PHY/SFP contributor
(FLYPRO quirk, intel-xway, realtek, mediatek). Not the SFP maintainer;
Lunn’s Reviewed-by covers that.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs: `SFP_QUIRK_F`, `sfp_fixup_rollball()`, `MDIO_I2C_ROLLBALL` —
  all in this tree (`sfp.c`, `include/linux/mdio/mdio-i2c.h`).
- **Applies standalone.** No new helpers.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 1bb028baab541`:
  **https://patch.msgid.link/20260719100158.874882-1-olek2@wp.pl**
- `b4 dig -a`: **v1 only** (`[PATCH net-next]`), 2026-07-19
- Thread (mbox): (1) patch, (2) Lunn **Reviewed-by**, (3) patchwork-bot
  applied to **netdev/net-next.git** as `1bb028baab54`
- **No NAK**, no requested respin, **no Cc: stable** in review

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Russell King
(`linux@armlinux.org.uk`), Andrew Lunn, Heiner Kallweit, netdev
maintainers (David, Edumazet, Kicinski, Pabeni),
`netdev@vger.kernel.org`. Right people; Lunn reviewed.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: no Reported-by, bugzilla, or syzbot. Author describes a real
module SKU. Severity from reporter: **module does not work** (PHY
protocol). User count: **unverified beyond the author**.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: **standalone**, not a series. Related only as the same quirk
pattern as FLYPRO.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org search returned **403**. Web search for “HORACO
… stable” found the net-next thread (LKML, Patchew, spinics), **not** a
stable-list NAK. **UNVERIFIED:** no stable@ thread found; no evidence it
was rejected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: **No function bodies changed.** New table entry consumed by
`sfp_lookup_quirk()` → `sfp_fixup_rollball()`.

**Step 5.2: TRACE CALLERS**
Record (from `sfp.c`):
- `sfp_lookup_quirk()` called from module-ID setup (~line 2677)
- If `quirk->fixup`, called under `st_mutex` (~2686–2687)
- `sfp_sm_probe_for_phy()` switches on `mdio_protocol`;
  `MDIO_I2C_ROLLBALL` probes `SFP_PHY_ADDR_ROLLBALL`
- Context: **SFP insert**, process/workqueue, not IRQ. Userspace-visible
  as “plug copper SFP+, no link”

**Step 5.3: TRACE CALLEES**
Record: `sfp_fixup_rollball()` assigns `MDIO_I2C_ROLLBALL` and
`phy_t_retry = 1s`. No alloc/lock.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: SFP cage driver (`CONFIG_SFP`, depends on I2C+PHYLINK) → EEPROM
read → quirk → PHY probe. **Reachable** when this module is inserted.
Not a syscall fuzzer path; **hardware + SFP cage**.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: many RollBall quirks already: FLYPRO, FS, Walsun, OEM SFP-10G-T
/ RTSFP-*, Turris. Same bug class; this SKU was missing.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD`: **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion`: **7.3.0-rc4**
- `drivers/net/phy/sfp.c` exists; `sfp_quirks[]` exists;
  `sfp_fixup_rollball()` exists (since v6.1).
- Without this entry, this SKU would not match. `git merge-base --is-
  ancestor 1bb028baab541 HEAD` → **yes** (already in 7.3-rc1+).
  Evaluation is still: would this tree *need* the quirk for the hardware
  — **yes, the driver is here**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **clean apply** on this tree (already applied as a 3-line insert
next to other OEM entries). No conflicting refactor of the table around
that site beyond later prefix-match macros unused by this entry.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: this exact quirk is the fix. No alternate HORACO workaround.
Follow-ups do not replace it.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record:
- Subsystem: **drivers/net/phy** — SFP cage (`CONFIG_SFP`)
- Criticality: **IMPORTANT** for machines with SFP cages (routers, NICs,
  embedded); **PERIPHERAL** as a single OEM copper module SKU. Not
  mm/VFS/core.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: active (many 2025–2026 quirk and RollBall commits). Quirk table
is the long-standing way to handle broken modules.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **driver-specific + hardware-specific** — users of HORACO
HC-10GE-113C (EEPROM `OEM` / `HC-10GE-113C`) in an SFP cage. No effect
on other modules.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: insert/probe that module. Common for owners of that SKU,
**never** otherwise. Unprivileged users cannot trigger it without the
hardware. Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failure: PHY not probed / no copper link
- Not oops/UAF/corruption
- **Severity: MEDIUM** for that hardware (link dead), **LOW** globally
- Still matches the documented **hardware quirk** stable exception

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** module works on stable kernels that already have
  SFP+RollBall (this tree does)
- **Risk:** very low (3 lines, exact match, existing fixup)
- **Ratio:** favorable — classic stable quirk

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- `Documentation/process/stable-kernel-rules.rst` explicitly allows
  **hardware quirks**
- Prompt class: **SFP_QUIRK_*** — “YES for stable”
- Real hardware: RollBall PHY, wrong/missing EEPROM description
- 3-line table add, existing `sfp_fixup_rollball()`
- Reviewed by Andrew Lunn; applied by Kicinski
- RollBall stack in this tree since v6.1
- Exact vendor+PN match; no new API/feature surface
- Same pattern as FLYPRO and other OEM 10G copper quirks

AGAINST:
- net-next, not `net`; no Cc: stable / Fixes (expected for new IDs)
- No public crash/CVE; only this SKU
- Submitted as “add quirk”, not a core bugfix
- Whether every OEM HC-10GE-113C also needs `rollball_cc` was not
  independently tested here (Lunn review is the available evidence)

UNRESOLVED:
- lore.kernel.org HTTP 403; stable@ history only via web search (no hit)
- No independent Tested-by besides implied author testing
- How many users have this module: unverified

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — table entry + Lunn Reviewed-
   by; applied to net-next
2. Fixes a real bug that affects users? **PASS** — module cannot talk to
   PHY / no link
3. Important issue? **PASS** under the **hardware quirk** exception (not
   a kernel oops)
4. Small and contained? **PASS** — +3 lines, one file
5. No new features or APIs? **PASS** — existing quirk hook only
6. Can apply to the local tree? **PASS** — SFP + `sfp_fixup_rollball`
   present; applies cleanly

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / SFP quirk** (and analogous to device-ID
addition on an existing driver). Qualifies automatically.

**Step 9.4: MAKE YOUR DECISION**
This tree has the SFP driver and RollBall fixup. The patch is a 3-line
SKU quirk so that copper module gets `MDIO_I2C_ROLLBALL`. That is the
stable exception, low risk, self-contained. Backport **yes**.

------------------------------------------------
What it solves for stable users
------------------------------------------------
Without the quirk, a HORACO HC-10GE-113C (`OEM` / `HC-10GE-113C`) never
uses RollBall, so the PHY is not probed and the 10G copper link stays
down. With it, insert matches the table and uses the existing RollBall
path (protocol + 1s PHY retry).

Risk vs benefit
------------------------------------------------
Benefit is that specific module working. Risk is negligible: exact
string match, no locking/API change. Later prefix-match work does not
apply to this exact PN.

Concerns
------------------------------------------------
None that block backport: no series, no missing helpers on this tree, no
review objections. Optional `rollball_cc` is unused; reviewers accepted
`sfp_fixup_rollball`.

Verification:
- [Phase 1] Tags: Reviewed-by Andrew Lunn; Link msgid
  `20260719100158.874882-1-olek2@wp.pl`; SOB Bajkowski + Kicinski; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Subject `[PATCH net-next]`; body states OEM HC-10GE-113C
  uses RollBall
- [Phase 2] Diff: +3 lines in `sfp_quirks[]`; `SFP_QUIRK_F("OEM",
  "HC-10GE-113C", sfp_fixup_rollball)`
- [Phase 2] `sfp_fixup_rollball()` sets `MDIO_I2C_ROLLBALL` and 1s
  `phy_t_retry` (sfp.c:412–421)
- [Phase 2] `sfp_sm_probe_for_phy()` uses `SFP_PHY_ADDR_ROLLBALL` for
  that protocol (sfp.c:2244–2246)
- [Phase 2] `sfp_lookup_quirk()` exact vendor+part match
  (sfp.c:668–684); fixup at 2686–2687
- [Phase 3] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4
- [Phase 3] Commit `1bb028baab541`; `git describe --contains` =
  v7.3-rc1~133^2~221
- [Phase 3] `git merge-base --is-ancestor 1bb028baab541 HEAD` succeeded
- [Phase 3] `sfp_fixup_rollball` from `324e88cbe3b7b` (v6.1-rc1)
- [Phase 3] Similar FLYPRO quirk `ddbf0e78a8b20` (v6.17-rc5); author has
  two sfp.c quirk commits
- [Phase 3] No later commit edits the HORACO lines (`git blame` 613–615
  = 1bb028baab541)
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; Lunn Reviewed-by; applied to
  net-next; CC list includes RMK, Lunn, Kallweit, netdev
- [Phase 4] lore.kernel.org WebFetch 403; mbox from b4 used instead
- [Phase 4] Web search: LKML/Patchew/spinics confirm review; no stable-
  list discussion found
- [Phase 5] Call path: module probe → lookup_quirk → fixup →
  sm_probe_for_phy; CONFIG_SFP (I2C+PHYLINK)
- [Phase 6] Quirk present in this checkout at sfp.c:613–614; RollBall
  enum in mdio-i2c.h
- [Phase 7] `stable-kernel-rules.rst` line 19: hardware quirk is in-
  scope
- [Phase 8] Failure mode: no PHY/no link for that SKU; not an oops
- UNVERIFIED: stable@ mailing list archives (HTTP 403); number of field
  users; whether this SKU also needs `sfp_fixup_rollball_cc`

**YES**

 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index af43530ffb2c3..195468bde2f29 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -576,6 +576,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	SFP_QUIRK_F("YV", "SFP+ONU-XGSPON", sfp_fixup_potron),
 
+	// HORACO HC-10GE-113C uses Rollball protocol to talk to the PHY.
+	SFP_QUIRK_F("OEM", "HC-10GE-113C", sfp_fixup_rollball),
+
 	// OEM SFP-GE-T is a 1000Base-T module with broken TX_FAULT indicator
 	SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
 
-- 
2.53.0

