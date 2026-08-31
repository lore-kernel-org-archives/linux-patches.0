Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB634A64D7;
	Mon, 31 Aug 2026 13:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183890; cv=none; b=mzxA0kc2ao1NlCxk0sYRAFr6zzakbQ0vO+47w0+1yILnkOP1rPASNigm/44l3fsjWs09B7P2QeMqtHmcANrwcCxse18FRq79N6YitKrn56r78U8aaLSvsOFg9V6fD90fch+fVNPzqX/A60gTy4sUDcsO9CgxU9SBg908rtMSMs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183890; c=relaxed/simple;
	bh=TGuY1fY4zmGNM3mSK0PgK5IAT6dikXccGEZgUBO8wUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQ/zE22XehKN0xvNlPmcvjplV+z359JSLK6ErVcHz3zje2rE14JF0X9uOKjic8VWA+3dV4Fhh1ZLN8+349+EZc6Q2YKREi4gVnkEAY/IUzutqtkxBYL1nAHBgUnZXAFrmLU/vGUPyFPGtaIgMA64yE7zDGbX8gLsOwWF7DASaPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCKUyz7x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCKUyz7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A735C1F000E9;
	Mon, 31 Aug 2026 13:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183887;
	bh=U5BTuxmrI7v0CTeKOwS95n7YBO2pzdcYeyI9VrAW1xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCKUyz7xt+qEtfcqNQLE7A0Wi1FINycGV7QBuPGgZ0xdlp+Ky729DMn/3+uz7n4za
	 wb5/5ZnG5hAVnaRZsSLmWtze1EKxJ1rykwCOHHfygVEUj8ksr+oT6NwgYh6PIsdPvV
	 Sv9+BpDfeXKmvA+DmFEarSWD70aX2yMxDde3rdfSGuYgaUgcsXlRYlAoBlybEFYtBN
	 zkBw/aCnEAtWnv9eIDXwL4Qlr6KE+75jhUwyYiutObsdd236pWtpRIcWFf1O+O2DBn
	 J8Z1RzsVt6OqRapaQf6sLkUEyAyY+7c+4frvmFzmBsvFhqxUtFmHGqTPG9z1mmuR1h
	 6QrrN5XwQfzBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	andrew@lunn.ch,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] net: dsa: realtek: rtl8365mb: add support for RTL8367SB
Date: Mon, 31 Aug 2026 09:26:30 -0400
Message-ID: <20260831133314.4125787-362-sashal@kernel.org>
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

From: Mieczyslaw Nalewaj <namiltd@yahoo.com>

[ Upstream commit 28702a215c96917d85558ad6309a57ab224808c0 ]

Add chip info entry for the Realtek RTL8367SB switch. This device has
chip ID 0x6367 and version 0x0010. It exposes two external interfaces:
port 6 supports MII, TMII, RMII, RGMII, SGMII and HSGMII, while port 7
supports MII, TMII, RMII and RGMII. Use the existing 8365MB-VC jam table
for initialization.

Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Link: https://patch.msgid.link/3c6d822b-0e85-4173-86ba-2badb140bbf1@yahoo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[net: dsa: realtek: rtl8365mb]` `[add]` — Add chip-info
table entry for Realtek RTL8367SB switch variant in the existing
rtl8365mb DSA driver.

### Step 1.2: Commit Message Tags
**Record:**
- **Reviewed-by:** Luiz Angelo Daros de Luca \<luizluca@gmail.com\> —
  subsystem reviewer who also provided technical feedback during review
- **Signed-off-by:** Mieczyslaw Nalewaj \<namiltd@yahoo.com\> — author
- **Signed-off-by:** Jakub Kicinski \<kuba@kernel.org\> — netdev
  maintainer merge
- **Link:** https://patch.msgid.link/3c6d822b-0e85-4173-86ba-
  2badb140bbf1@yahoo.com
- **No** Fixes:, Reported-by:, Tested-by:, Acked-by:, or Cc:
  stable@vger.kernel.org
- Notable: no user bug report or syzbot reference; reviewed by a driver
  contributor

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug description:** RTL8367SB (chip ID `0x6367`, version `0x0010`) is
  not recognized by `rtl8365mb_detect()` because it has no entry in
  `rtl8365mb_chip_infos[]`.
- **Symptom:** Probe fails with `unrecognized switch (id=0x6367,
  ver=0x0010)` and `-ENODEV`; the switch never registers as a DSA device
  and networking through it does not work.
- **Version info:** None stated.
- **Root cause (author):** Missing chip-info entry; the chip reuses the
  existing `8365MB-VC` jam initialization table. Port 6 supports
  MII/TMII/RMII/RGMII/SGMII/HSGMII; port 7 supports MII/TMII/RMII/RGMII.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not a crash/UAF/leak fix. This is hardware enablement
disguised as “add support.” It completes detection for a chip already
listed in the driver’s family documentation but absent from the runtime
chip table — functionally equivalent to adding a device/chip ID to an
existing driver.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/net/dsa/realtek/rtl8365mb.c` — +14 lines, 0 removed
- **Modified data:** `rtl8365mb_chip_infos[]` static table only
- **Scope:** Single-file, surgical table entry addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `rtl8365mb_detect()` iterates `rtl8365mb_chip_infos[]`;
  chip `0x6367`/`0x0010` matches nothing → `-ENODEV`.
- **After:** Same loop matches the new RTL8367SB entry → probe
  continues, switch initializes with the existing VC jam table and
  declared external interface capabilities.
- **Path affected:** Device probe / chip detection during
  `rtl83xx_register_switch()` → `priv->ops->detect()`.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness — incomplete chip identification table
  (hardware enablement).
- **Mechanism:** Driver documents RTL8367SB in its header comment list
  (line 81) but had no matching `chip_id`/`chip_ver` entry, so detection
  always failed for that silicon.

### Step 2.4: Fix Quality
**Record:**
- Fix is obviously correct in structure: follows identical pattern to
  RTL8367S and RTL8367RB-VB entries.
- Minimal scope; no logic changes beyond the table.
- **Regression risk:** Low. Wrong `extints` could misreport supported
  PHY modes, but v3 incorporated reviewer feedback on port-6
  capabilities; v4 is the reviewed final form.
- No API or structure changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / Introduction
**Record:** Current `rtl8365mb_chip_infos[]` entries (including RTL8367S
and RTL8367RB-VB) were introduced in `6bda50f4333fa` (2025-11-29, v6.18
base import). RTL8367SB was documented in the file header comment from
the same baseline but never given a table entry — an omission from
initial driver bring-up, not a later regression.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related File History
**Record:** Recent rtl8365mb changes in this tree are bug fixes (`fix
mode mask calculation`, `fix rtl8365mb_phy_ocp_write return value`,
stats cleanup). This RTL8367SB commit is not yet in the tree. Standalone
one-patch change (v1–v4 on mailing list, same functional diff in final
version).

### Step 3.4: Author Context
**Record:** Mieczyslaw Nalewaj has prior rtl8365mb fixes in this tree
(`b707f3109f1a7`, `5f5d956b2ce00`, `d95de5acbf9ed`). Active contributor
to this driver, not the original author of the whole file.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses existing
`rtl8365mb_init_jam_8365mb_vc` table and `PHY_INTF()` macros already
present. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **URL:** [PATCH v4 on
  lists.openwall.net](https://lists.openwall.net/netdev/2026/05/09/111)
  (Message-ID `3c6d822b-0e85-4173-86ba-2badb140bbf1@yahoo.com`)
- **Series revisions:** v1 → v2 (no changes) → v3 (expanded port-6 PHY
  mode mask per reviewer) → v4 (changelog only, repost)
- **Reviewer feedback:** Luiz Angelo Daros de Luca noted v2 port
  capabilities were too narrow for RTL8367SB; v3 corrected them. v3
  received `Reviewed-by:`.
- **Stable nominations:** None found in available thread content.
- **NAKs/concerns:** None found.

### Step 4.2: Reviewers
**Record:** Patch sent to netdev maintainers (Lunn, Oltean, Miller,
Kicinski, etc.). Cc’d Luiz Angelo Daros de Luca, who reviewed and
validated port capabilities.

### Step 4.3: Bug Reports
**Record:** No Reported-by, no syzbot, no bugzilla. Enablement driven by
hardware identification need, not a filed crash report.

### Step 4.4: Related Patches
**Record:** Standalone; not part of a multi-commit series.

### Step 4.5: Stable List History
**Record:** Could not access lore.kernel.org/stable (bot protection). No
stable discussion verified.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** Only `rtl8365mb_chip_infos[]` data modified. Detection logic
in `rtl8365mb_detect()` unchanged.

### Step 5.2: Callers
**Record:** `rtl8365mb_detect()` registered as `.detect` in
`rtl8365mb_switch_ops`, called from `rtl83xx_register_switch()` during
driver probe (platform/MDIO device init). Called once per device at
boot/module load.

### Step 5.3: Callees
**Record:** Detection reads chip ID/version registers via regmap; on
match, subsequent `rtl8365mb_switch_init()` uses `chip_info->jam_table`
and `extints` for PHY mode validation.

### Step 5.4: Reachability
**Record:** Triggered when a board with `compatible =
"realtek,rtl8365mb"` (or MDIO equivalent) has an RTL8367SB switch
attached. Requires `CONFIG_NET_DSA_REALTEK_RTL8365MB`. Affects
embedded/router platforms using this switch — not a syscall path, but a
common boot-time path for affected hardware.

### Step 5.5: Similar Patterns
**Record:** RTL8367S (`0x6367`/`0x00A0`) and RTL8367RB-VB
(`0x6367`/`0x0020`) entries use the same pattern. RTL8367SB sits between
them with a distinct `chip_ver` (`0x0010`) and combined port
capabilities.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Local tree is **6.18.43**
(`v6.18.43-1-gc7f0dac02d232`). `drivers/net/dsa/realtek/rtl8365mb.c`
exists with `rtl8365mb_chip_infos[]` containing RTL8367S and RTL8367RB-
VB but **no RTL8367SB entry**, despite RTL8367SB being listed in the
driver’s supported-family comment at line 81. Commit is **not** yet
applied to this checkout.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Current tree has RTL8367S
immediately followed by RTL8367RB-VB — exactly where the patch inserts
the new entry. No conflicting changes in that region.

### Step 6.3: Related Fixes Already Present
**Record:** No existing RTL8367SB support or alternate fix found (`git
log --grep` returned empty).

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **net/dsa/realtek** — IMPORTANT (networking driver
subsystem). Affects only platforms with this specific switch and
`CONFIG_NET_DSA_REALTEK_RTL8365MB` enabled. Known DTS usage:
`bcm47094-asus-rt-ac88u.dts` uses `realtek,rtl8365mb` (RTL8365MB-VC, not
RTL8367SB, but shows driver deployment on consumer routers).

### Step 7.2: Subsystem Activity
**Record:** Active — multiple rtl8365mb fixes landed in this 6.18.y
tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** **Driver-specific / platform-specific** — users with
RTL8367SB (`0x6367`/`0x0010`) on boards using the rtl8365mb DSA driver.

### Step 8.2: Trigger Conditions
**Record:** Boot-time probe of a Realtek DSA switch whose hardware
reports chip ID `0x6367` and version `0x0010`. Not user-triggerable via
syscall; requires specific hardware. Unprivileged users cannot trigger
directly, but affected systems fail networking at boot.

### Step 8.3: Failure Mode Severity
**Record:** Probe failure (`-ENODEV`, “unrecognized switch”).
**Severity: MEDIUM** for affected hardware — no kernel crash, panic, or
data corruption, but switch is completely non-functional. Networking
unavailable on those boards.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables RTL8367SB hardware on existing driver
  infrastructure; low user count but total failure without it.
- **Risk:** Very low — 14-line static table entry, reviewed, no
  behavioral changes to other chips.
- **Ratio:** Moderate benefit for a narrow audience, very low risk. Fits
  the stable **device ID / hardware enablement** exception category.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Adds missing chip variant ID to an existing driver (stable exception:
  device ID / hardware enablement)
- Fixes real functional failure on RTL8367SB hardware (probe `-ENODEV`)
- Small (14 lines), self-contained, no dependencies
- Reviewed by driver contributor who corrected port capabilities
- Driver and infrastructure already present in 6.18.43
- Should apply cleanly

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock fix
- No user bug reports or syzbot findings
- “Add support” language — feature completion rather than regression fix
- RTL8367SB was never supported in released 6.18.y; this adds new
  capability
- Affects a narrow hardware population
- No stable mailing list nomination found

**Unresolved:**
- No verified stable-list discussion (lore blocked)
- No DTS board in this tree explicitly using RTL8367SB (unverified
  whether any 6.18.y deployments need it today)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — table entry follows existing
   pattern; Reviewed-by from subsystem contributor; no Tested-by.
2. Fixes a real bug affecting users? **PASS** — probe failure on
   RTL8367SB is a real, reproducible functional bug for that hardware.
3. Important issue? **BORDERLINE PASS** — not crash/security class, but
   complete hardware failure for affected platforms.
4. Small and contained? **PASS** — 14 lines, one file, data table only.
5. No new features or APIs? **PASS with exception** — adds hardware
   support via existing driver mechanism (device ID exception applies).
6. Can apply to local tree? **PASS** — driver present, patch fits
   cleanly.

### Step 9.3: Exception Category
**Record:** **NEW DEVICE IDs / hardware enablement** — adding a chip
ID/version entry to an existing driver’s identification table, analogous
to PCI/USB ID additions. Driver (`CONFIG_NET_DSA_REALTEK_RTL8365MB`)
already exists in 6.18.43.

### Step 9.4: Decision Rationale

For **this** tree (6.18.43), the rtl8365mb driver is present and ships
with RTL8367SB documented in comments but missing from the detection
table. Boards with RTL8367SB silicon cannot use the switch at all. The
patch is a minimal, reviewed chip-identification entry using existing
initialization infrastructure — the canonical stable pattern for
enabling hardware on an existing driver without adding new APIs or
driver logic.

The fix is not security-critical and affects a limited hardware set, but
stable trees routinely accept such chip/ID table additions because they
fix real hardware failures with negligible regression risk. This meets
the stable exception criteria and applies cleanly to 6.18.43.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message;
  fetched v4 thread from lists.openwall.net
- **[Phase 2]** Confirmed diff: +14 lines to `rtl8365mb_chip_infos[]`
  only
- **[Phase 3]** `git blame -L 535,560`: chip table from `6bda50f4333fa`;
  `git log --oneline -20 -- rtl8365mb.c`: no RTL8367SB commit in tree
- **[Phase 3]** `git log --grep="RTL8367SB"`: empty — commit not present
- **[Phase 4]** openwall.net v4 thread: v1–v4 evolution, Reviewed-by,
  Luiz Angelo port-capability feedback
- **[Phase 4]** lore.kernel.org fetch: blocked by bot protection
  (UNVERIFIED for stable-list discussion)
- **[Phase 4]** b4 dig: could not run without commit hash in local tree
  (commit not merged here)
- **[Phase 5]** Read `rtl8365mb_detect()` at lines 2070–2099: confirmed
  `-ENODEV` on unrecognized chip
- **[Phase 5]** Read `rtl83xx_register_switch()` at line 228: `detect()`
  called at probe
- **[Phase 5]** Grep `realtek,rtl8365mb` in DTS: found in
  `bcm47094-asus-rt-ac88u.dts`
- **[Phase 6]** `git describe HEAD`: v6.18.43; `make kernelversion`:
  6.18.43
- **[Phase 6]** Read lines 523–560: RTL8367SB entry absent; patch
  insertion point matches
- **[Phase 6]** Read line 81: RTL8367SB listed in family comment but
  unsupported at runtime
- **[Phase 7]** `CONFIG_NET_DSA_REALTEK_RTL8365MB` in
  `drivers/net/dsa/realtek/Makefile`
- **[Phase 8]** Failure mode verified in code: `-ENODEV` at line 2098,
  not oops/corruption

**YES**

 drivers/net/dsa/realtek/rtl8365mb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index e10a789e22022..c806a24dcd031 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -544,6 +544,20 @@ static const struct rtl8365mb_chip_info rtl8365mb_chip_infos[] = {
 		.jam_table = rtl8365mb_init_jam_8365mb_vc,
 		.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
 	},
+	{
+		.name = "RTL8367SB",
+		.chip_id = 0x6367,
+		.chip_ver = 0x0010,
+		.extints = {
+			{ 6, 1, PHY_INTF(MII) | PHY_INTF(TMII) |
+				PHY_INTF(RMII) | PHY_INTF(RGMII) |
+				PHY_INTF(SGMII) | PHY_INTF(HSGMII) },
+			{ 7, 2, PHY_INTF(MII) | PHY_INTF(TMII) |
+				PHY_INTF(RMII) | PHY_INTF(RGMII) },
+		},
+		.jam_table = rtl8365mb_init_jam_8365mb_vc,
+		.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
+	},
 	{
 		.name = "RTL8367RB-VB",
 		.chip_id = 0x6367,
-- 
2.53.0

