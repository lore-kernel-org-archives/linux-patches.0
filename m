Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EFB61F409;
	Mon, 19 Oct 2026 14:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418676; cv=none; b=SREVDodhIiHy1tnVs3Bxl7QboO4U++Ati42Zo2NJw9kKJ6DfFPXOz2LknAwHznu0Gh6whTIGY+A/pkG67p7nuV+mpBZsBqvJKc4RAVDCPDeza516r8cM2lE7FH8owkAOqhZedRCFJGKO9gjkBJ9qvzf5Cw+HPG27UMLP9WfWmFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418676; c=relaxed/simple;
	bh=DB+STu5H+6c4Cw5ms/rZflrtgzuWw2EIM5ItFW9hx0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcEtxfZoJXc9h2q1SrBwx69LAK9f/2jij/MEPu4N9gorwV+YElHB/lWrPKh3O1XWr95OzYvVxi0OoplsItbpJNLmtpMffTXt9ZMjYzzpzzdwX/+vAzmoF1K45xYZyL9JvbQsAhmh00KojFQWZ6KfJDJ2qjNs7vAP/oHI97V1aWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QS7vyg2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QS7vyg2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D861F000C4;
	Mon, 19 Oct 2026 14:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418672;
	bh=XByulFtl7pCyQd5j6nUCXg6ppkiV3QC5/6K/iDcrYwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QS7vyg2MrS6AJhIhs18wN+EPAahP66bYS4B163o1N9Eq85UW08c8R9f98e8OsvHu2
	 aI1iM0TqQsOEcz/bXCU+E/CBrwbVCvrd5qlwm62PikDijm8GM5fV684TFfjTcuIDCo
	 CY3CyE8skQhKCWy7FrM3ZYVbhG/alPaSAXycWUUD/NBEuLmDZjuYLFgIEdk2yqEwQ6
	 BtiDf/pEfAHQMmH/V7PjYObJZeb1iKGB4cboTIUs2zbc3gbXYUuFlpfDs7SRCIZta+
	 hW3eQZEEHIai+Rp3YSo5J9Nuaiu9q5SzXLJFfZzaqlqpVdqfkK1MTTQHjp+NiJ633F
	 B3mIh0rle2L5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yaroslav Dudkov <aroslavdudkov622@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	teackot@gmail.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] platform/x86: msi-ec: Add MSI Katana GF76 11UEK EC firmware
Date: Mon, 19 Oct 2026 09:51:46 -0400
Message-ID: <20261019135441.1420968-415-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Yaroslav Dudkov <aroslavdudkov622@gmail.com>

[ Upstream commit 0b30e6e583b2988864ffa7aeb2905bc2d0c7d575 ]

Add the firmware string '17L1EMS1.107' to the ALLOWED_FW_13 array.
This enables Embedded Controller support, including battery charge
thresholds, for the MSI Katana GF76 11UEK (MS-17L1) laptop.

Tested on MSI Katana GF76 11UEK with EC firmware 17L1EMS1.107 and
BIOS E17L1IMS.312.

Signed-off-by: Yaroslav Dudkov <aroslavdudkov622@gmail.com>
Link: https://patch.msgid.link/20260807180553.869371-1-aroslavdudkov622@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a one-line firmware-ID addition to an
existing `msi-ec` table that already exists in this 6.12 tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `platform/x86: msi-ec`
- Action verb: **Add**
- Claimed intent: add EC firmware string for MSI Katana GF76 11UEK

Record: [platform/x86 msi-ec] [add] [allowlist EC firmware 17L1EMS1.107
for Katana GF76 11UEK]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Fixes: none (expected)
- Reported-by: none
- Tested-by: none as a tag; body says tested on the target laptop
- Reviewed-by: Ilpo Järvinen `<ilpo.jarvinen@linux.intel.com>` (pdx86
  maintainer)
- Acked-by: none
- Link: `https://patch.msgid.link/20260807180553.869371-1-
  aroslavdudkov622@gmail.com`
- Cc: stable: none (expected)
- Signed-off-by: Yaroslav Dudkov (author); Ilpo Järvinen (maintainer)
- Ignore: any Sasha Levin SOB / `[Upstream commit ...]` pipeline markers

Record: Author SOB + maintainer Reviewed-by/SOB + lore msgid link. No
syzbot. No Fixes.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Bug: this laptop’s EC firmware is not in the driver’s allowlist, so
  `msi-ec` refuses to load.
- Symptom: no in-kernel EC extras, including battery charge thresholds.
- Version info: tested with EC `17L1EMS1.107`, BIOS `E17L1IMS.312`,
  board MS-17L1.
- Root cause: firmware-string matching is how this driver binds; missing
  string means `-EOPNOTSUPP`.

Record: [unsupported firmware string] [driver does not load / no charge
thresholds] [Katana GF76 11UEK] [allowlist gap, not a logic bug]

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: [Not a hidden UAF/race/leak fix. It is hardware enablement via
firmware ID, which stable rules treat as a device-ID addition.]

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
- File: `drivers/platform/x86/msi-ec.c`
- +1 line, 0 removed
- Data only: `ALLOWED_FW_13[]`
- Scope: single-file, one-line table addition

Record: [msi-ec.c +1] [ALLOWED_FW_13] [surgical ID addition]

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before: `ALLOWED_FW_13` is only `"1594EMS1.109"` (Prestige 16 Studio
A13VE).
After: also `"17L1EMS1.107"` (Katana GF76 11UEK).
Path: `__init` firmware match in `load_configuration()`. Other models
unchanged.

Record: [init allowlist miss → exact-match bind to existing CONF13]

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **h) Hardware workarounds / device ID addition**
Mechanism: driver matches EC firmware with `match_string()` against
`CONFIGS[]`. Unknown FW logs `Firmware version is not supported` and
returns `-EOPNOTSUPP`. Adding the string attaches this model to existing
CONF13 (charge control at 0xd7, etc.).

Record: [device/firmware ID] [missing allowlist entry; add string to
existing config]

**Step 2.4: ASSESS THE FIX QUALITY**
- Minimal, obviously correct as an ID add.
- Author tested on the machine; maintainer reviewed.
- Regression risk is confined to this firmware string. Wrong map could
  write bad EC registers, but the string is unique and the author tested
  it.
- No API, locking, or hot-path change.

Record: [high quality, 1-line] [risk limited to this FW ID]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
`git blame -L 1055,1058 -- drivers/platform/x86/msi-ec.c`:
- `ALLOWED_FW_13` and `"1594EMS1.109"` introduced in `8abba08944663`
  (Nikita Kravets, 2023-10-06), `platform/x86: msi-ec: Add more EC
  configs`.
- Driver itself: `392cacf2aa10d` (2023-03-27), contained in v6.4-rc1.

Record: [allowlist table from 8abba08944663 / v6.7 era] [driver since
v6.4; present in this 6.12 tree]

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: [No Fixes: tag; not applicable. This does not revert a
regression; it adds an ID.]

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
This tree’s `msi-ec.c` history is short. Same pattern already present
here:
`03f404cbe8e9e` `platform/x86: msi-ec: Add support for MSI Pulse GL66
12th Gen` — one firmware string added to `ALLOWED_FW_10`.

Record: [related: Pulse GL66 one-line FW add already in this tree]
[standalone, not patch X/Y]

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
`git log --author='Yaroslav Dudkov' -- drivers/platform/x86/`: empty in
this tree.
Original recipients were `teackot@gmail.com` (msi-ec author), Hans de
Goede, Ilpo Järvinen.

Record: [first-time contributor for this file here] [reviewed/applied by
pdx86 maintainer]

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Needs `ALLOWED_FW_13` / `CONF13` / `CONFIGS[]` entry. All exist in this
checkout. Context around the hunk matches the patch exactly.

Record: [no missing prereqs] [applies standalone]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c` could not be used: original SHA
`ef2c7d3b75d9270979f9a3fb32edee811c383fbc` is not in this repo (`fatal:
Not a valid commit name`).
Fallback: `b4 mbox` on msgid
`20260807180553.869371-1-aroslavdudkov622@gmail.com` — 2-message thread.

lore/openwall: https://lists.openwall.net/linux-kernel/2026/08/07/1803
Apply ack: https://lists.openwall.net/linux-kernel/2026/08/18/1409

Single v1 patch (not a series). Ilpo applied it unchanged to `review-
ilpo-next`. No NAK, no v2.

Record: [v1 applied as-is] [commit ef2c7d3b75d9…] [no reviewer concerns]

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
To/Cc from the mbox: Nikita Kravets, Hans de Goede, Ilpo Järvinen,
platform-driver-x86, linux-kernel.

Record: [pdx86 maintainers on To; Ilpo Reviewed-by and applied]

**Step 4.3: SEARCH FOR THE BUG REPORT**
No bugzilla/syzbot. Author is the tester. Downstream msi-ec issues show
Katana GF76 17L1* users hitting “firmware not supported” (related
11UG/`.106`, not this exact `.107`/11UEK). Confirms the allowlist is how
support is gated.

Record: [hardware enablement submitted by device owner] [same failure
mode seen on sibling 17L1 models downstream]

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: [standalone 1/1; no series dependencies]

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Web search of lore.kernel.org/stable for this model/firmware returned
unrelated hits.

Record: [no stable-list discussion found for this ID]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Diff does not change functions. Runtime users of the table:
`load_configuration()` via `CONFIGS[i]->allowed_fw`.

Record: [data: ALLOWED_FW_13] [consumer: load_configuration()]

**Step 5.2: TRACE CALLERS**
`load_configuration()` is only called from `msi_ec_init()`
(`module_init`). `git grep` found no other callers.

Record: [module init only; not IRQ/hot path]

**Step 5.3: TRACE CALLEES**
`ec_get_firmware_version()` → `ec_read_seq()` → `ec_read()`. Match:
`match_string()`. On success copies `CONF13` into static `conf` and
later `battery_hook_register()`.

Record: [EC read + string match + optional battery hook]

**Step 5.4: FOLLOW THE CALL CHAIN**
Reachable when `CONFIG_MSI_EC` is enabled and DMI vendor is MSI (`MICRO-
STAR INT` / `Micro-Star International`). Unprivileged userspace cannot
crash other machines; only this FW string newly binds.

Record: [boot/module load on MSI laptops] [this ID only affects
17L1EMS1.107]

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Same file: many `ALLOWED_FW_*` arrays. This tree already has the Pulse
GL66 one-line add to `ALLOWED_FW_10`.

Record: [standard msi-ec firmware-ID pattern]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Local tree: branch `pending-6.12`, `git describe HEAD` =
`p-6.12-3-gc504cf0baa3d8`, `make kernelversion` = **6.12.111**.

`ALLOWED_FW_13` exists at `drivers/platform/x86/msi-ec.c:1055` with only
Prestige `1594EMS1.109`. `17L1EMS1.107` is **not** present (`git grep`
empty). `git merge-base --is-ancestor ef2c7d3b… HEAD` fails because that
SHA is not in this object database.

Record: [yes, allowlist hole exists here] [CONF13 since 8abba08944663,
in this 6.12 tree]

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Exact context is present; python check: `exact context present: True`.
Would apply cleanly.

Record: [clean apply]

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
No Katana/17L1 string. Pulse GL66 is a sibling ID add, not a substitute.

Record: [this ID not already present]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
`drivers/platform/x86/msi-ec.c`, `CONFIG_MSI_EC` (ACPI + ACPI_BATTERY).
Laptop EC extras: charge thresholds, etc.

Record: [platform/x86 msi-ec] [PERIPHERAL / driver-specific, but a
documented device-ID exception]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
File is mature in this tree (configs from 2023; occasional FW-ID adds).

Record: [stable driver; ID table is the ongoing extension point]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Only MSI Katana GF76 11UEK with EC firmware `17L1EMS1.107`. Everyone
else: no behavioral change.

Record: [driver-specific / one firmware ID]

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Trigger today: load `msi-ec` on that laptop → unsupported FW, module
fails. After: driver binds, battery charge-threshold sysfs appears.

Record: [every boot/modprobe on that model] [not a security trigger for
other users]

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Current: missing hardware support (charge threshold control), not
oops/corruption.
Stable rules explicitly allow “just add a device ID” even without a
crash.

Record: [missing device support] [MEDIUM for those users; exception
category still qualifies]

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Benefit: enables EC/charge-threshold support on a real, tested laptop in
6.12.y.
Risk: one unique string; existing CONF13; no shared-path change.
Residual risk is a wrong EC map for this ID only, mitigated by on-
hardware testing + maintainer review.

Record: [benefit: hardware enablement] [risk: very low] [favorable]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- `Documentation/process/stable-kernel-rules.rst`: patches may “just add
  a device ID”; this driver’s IDs are EC firmware strings.
- Driver + CONF13 already in 6.12.111; only the ID is new.
- +1 line, exact context match, clean apply.
- Tested on the Katana GF76 11UEK; Reviewed-by pdx86 maintainer; applied
  as v1.
- No effect on other firmware versions.
- Same class of change already in this tree (Pulse GL66 →
  `ALLOWED_FW_10`).

AGAINST:
- Not a crash/UAF/corruption fix.
- Author is not the original msi-ec author (mitigated by maintainer
  review and testing).
- Wrong config would be bad for this model only (unverified beyond
  author’s test + review).

UNRESOLVED:
- Could not `b4 dig -c` the mainline SHA (not in this clone).
- lore.kernel.org HTTP fetch returned 403; used b4 mbox + openwall/LKML
  mirrors.
- No stable@ thread found.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 1-line ID; tested on target;
   maintainer reviewed.
2. Fixes a real bug that affects users? **PASS** — as device-ID
   enablement; without it the driver refuses this laptop.
3. Important issue? **PASS** under the device-ID exception (not a
   panic).
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — no new ABI; existing CONF13/sysfs
   for a new ID.
6. Can apply to the local tree? **PASS** — CONF13 present; context
   identical.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: [NEW DEVICE ID — EC firmware string on an existing
driver/config]

**Step 9.4: MAKE YOUR DECISION**
This is a textbook stable device-ID addition. The local 6.12 tree
already has `msi-ec` and `ALLOWED_FW_13`; the patch only names one more
firmware. Benefit is real for Katana GF76 11UEK users; regression risk
for everyone else is essentially zero.

Verification:
- [Phase 1] Parsed subject/tags/body: Add firmware ID; Reviewed-by Ilpo;
  Link msgid 20260807180553.869371-1; tested on 17L1EMS1.107 / BIOS
  E17L1IMS.312
- [Phase 2] Diff: +1 line in `ALLOWED_FW_13[]` in
  `drivers/platform/x86/msi-ec.c`
- [Phase 3] `git blame -L 1055,1058`: table from `8abba08944663`
  (2023-10-06); driver `392cacf2aa10d` since v6.4
- [Phase 3] No Fixes: tag; sibling ID add `03f404cbe8e9e` (Pulse GL66)
  already in this tree
- [Phase 3] `git log --author='Yaroslav Dudkov' --
  drivers/platform/x86/`: empty here
- [Phase 4] `b4 dig -c ef2c7d3b…`: SHA not in this repo; used `b4 mbox`
  msgid instead (2 messages)
- [Phase 4] Maintainer applied v1 unchanged as
  `ef2c7d3b75d9270979f9a3fb32edee811c383fbc`; no NAK
- [Phase 4] Recipients: Kravets, de Goede, Järvinen, platform-driver-x86
- [Phase 4] No stable@ discussion found
- [Phase 5] Callers: `load_configuration()` ← `msi_ec_init()` only;
  match via `match_string()`
- [Phase 6] `git describe HEAD`: p-6.12-3-gc504cf0baa3d8; `make
  kernelversion`: 6.12.111
- [Phase 6] `17L1EMS1.107` absent; exact ALLOWED_FW_13 context present;
  would apply cleanly
- [Phase 7] CONFIG_MSI_EC in `drivers/platform/x86/Kconfig`; not staging
- [Phase 8] Failure mode: module load `-EOPNOTSUPP` / missing charge
  thresholds on one MSI model; severity MEDIUM, device-ID exception
- UNVERIFIED: exact EC-map correctness beyond author test + maintainer
  review; mainline object `ef2c7d3b` not fetchable from this clone

This one-line firmware-ID addition matches stable’s device-ID exception,
applies cleanly to this 6.12 tree, and does not change behavior for any
other hardware.

**YES**

 drivers/platform/x86/msi-ec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/msi-ec.c b/drivers/platform/x86/msi-ec.c
index 0157e233e4300..0cec54d497d1e 100644
--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -1054,6 +1054,7 @@ static struct msi_ec_conf CONF12 __initdata = {
 
 static const char * const ALLOWED_FW_13[] __initconst = {
 	"1594EMS1.109", // MSI Prestige 16 Studio A13VE
+	"17L1EMS1.107", // MSI Katana GF76 11UEK
 	NULL
 };
 
-- 
2.53.0

