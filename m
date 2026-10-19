Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618E263BD7F;
	Mon, 19 Oct 2026 14:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418763; cv=none; b=kmPalLzZ4mhRSJejESDxdHZpVjwTu996ab0xho5yruUTknSe6uu9nSMjnhs31hmnJU5QV57gSkn86X2dkwnLd+f7unH7RQRBPQWXj9RX9sv57ohDrt2u1+zMZCaCdY/FrL2uIZ7OzQo8zLYlHFAIIqXbep1qJSdYHt3iFmCRokA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418763; c=relaxed/simple;
	bh=3YltFmY9N7kbysiNIO+UyKtWhnRA7hvTxPMVyfxGlfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FSiHjvUZ5KaP/5lQNixH32I1/Uvtw09WMKo7h2+wBBj3oZYTKgIbDbkMDxA5ZAdtBEue0BcAmW8X0RUSABLmv6mfcSiXEtHAPf25+6G+hVtFD7IzRo6WBfgF5pWQyU4gTDbI1/7vfkw/GExmX6pp6FvCVDmfwY7oqqyvj7MVLY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyyufjem; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyyufjem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF461F000C6;
	Mon, 19 Oct 2026 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418760;
	bh=vL0aMmlhmyfOvr1cE0UydkyOyMeVhiddQr8CQPh9wYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyyufjemd2Rmxl+Cv8OGaSlCi8cTDDk6bZhyf66gALhj8LWUaHeskGXdpCmAWWZoY
	 QFw02wKfTvxM7E+XOq8IhTuKXRxuFoOgyyLPIMLtrSmnyG6dMvbH1/mwB6KFllnMI6
	 RunFobR9vyCZOVBp9cjdu6fVxjraQL1PYn06RBOwwJV4g9YW2zVCWm7OEFpmFe542p
	 3X8Bj+YpDoa7lo6J/0sFqdIXyb96lqOaCQDGIEypHkCKTaGbvUGnZ8ff109jtCJyXu
	 ra83iUsJbitJPqr1GI4BrD5og2GtL2zIB7UJEahLNh357T24HWD458CvOohwVPOr8j
	 YWKEeHColCmEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mehmet Aysel <mehmet4ysel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: amd: acp3x-es83xx: Add HVY-WXX9/M1060 DMI quirk
Date: Mon, 19 Oct 2026 09:52:47 -0400
Message-ID: <20261019135441.1420968-476-sashal@kernel.org>
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

From: Mehmet Aysel <mehmet4ysel@gmail.com>

[ Upstream commit c1a39c228aceebc0ede83781ea906d257e324009 ]

Add matching DMI table entry for the ES83xx machine driver, so the
HUAWEI HVY-WXX9 / M1060 board (MateBook D16 2021, Ryzen 5 4600H) can
successfully probe its ES8316 codec via the acp3x-es83xx machine
driver, consistent with the existing M1010/M1020/M1040 entries for
the same board name.

Signed-off-by: Mehmet Aysel <mehmet4ysel@gmail.com>
Link: https://patch.msgid.link/20260825092432.56292-2-mehmet4ysel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis

Local tree: **pending-6.12** (`p-6.12-3-gc504cf0baa3d8`, `make
kernelversion` = **6.12.111**). Verdict is for this tree only.

Commit under review: **ASoC: amd: acp3x-es83xx: Add HVY-WXX9/M1060 DMI
quirk** (mainline `c1a39c228ace`). It is **not** in this checkout (`git
merge-base --is-ancestor c1a39c228ace HEAD` failed).

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[ASoC/amd/acp3x-es83xx] [Add] [DMI quirk so HUAWEI HVY-WXX9
product version M1060 probes the existing ES8316 machine driver]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Fixes:` — none (expected for this review queue)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by:` — none
- `Acked-by:` — none
- `Link:` `https://patch.msgid.link/20260825092432.56292-2-
  mehmet4ysel@gmail.com`
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Mehmet Aysel <mehmet4ysel@gmail.com>` (author)
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (ASoC maintainer;
  applied the series)
- Ignore `Signed-off-by: Sasha Levin` if present (pipeline)

Notable: Message-ID `...-2-...` and subject history show this is **patch
2/2**. Companion is patch 1/2 to `sound/soc/amd/acp-config.c`.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** The MateBook D16 2021 (Ryzen 5 4600H) board `HUAWEI` / `HVY-
  WXX9` / `M1060` is not in `acp3x_es83xx_dmi_table`. Sibling SKUs
  `M1010` / `M1020` / `M1040` already are.
- **Symptom:** Machine driver does not probe the ES8316 codec; onboard
  audio does not come up. `acp3x_es83xx_probe()` logs that ACPI lists
  ES83xx but the DMI table has no match, and returns `-ENODEV`.
- **Version info:** None in the message. Hardware is a 2021 laptop;
  driver landed in v6.7.
- **Root cause (author):** Exact DMI version match omits this SKU. Same
  `ES83XX_ENABLE_DMIC` data as the other HVY-WXX9 rows.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. It is an explicit DMI quirk / hardware-
enablement addition, the audio analogue of a device-ID row.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c` — **+8 / -0**
- Function/data: `acp3x_es83xx_dmi_table[]` only
- Scope: single-file surgical table addition

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: Before, `dmi_first_match(acp3x_es83xx_dmi_table)` fails for
`PRODUCT_VERSION == "M1060"` (`DMI_EXACT_MATCH`). Probe takes the else
branch (`-ENODEV`). After, that SKU matches and `driver_data =
ES83XX_ENABLE_DMIC`, same as M1010/M1020/M1040.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Hardware workaround / DMI quirk (category h).** Missing table
row, not UAF/race/leak. Without a match, ES8316 never initializes on
this SKU.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Copy of existing HVY-WXX9 rows with version `M1060`. No new
APIs, no locking, no hot-path logic. Regression risk is limited to that
DMI triple being wrong (would only affect that SKU). Quality: obviously
correct, minimal.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Table introduced in `54fcd9dd44b2c` (“Add machine driver that enables
  sound for systems with a ES8336 codec”), **2023-09-11**, contained in
  **v6.7-rc1**. Original HVY-WXX9 rows: **M1020 and M1040**.
- M1010 row added in `5513c5d0fb3d5` (2024-01-29): “Previous commit that
  added support for Huawei MateBook D16 2021 … (HVY-WXX9 M1010) was
  incomplete.” Both commits **are ancestors of this HEAD**.
- M1060 was never added here.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Closest precedent is `5513c5d0fb3d5`, which
`Fixes: b5338b1b901e` because **acp-config alone is not enough**; the
es83xx DMI table must match too.

**Step 3.3: CHECK FILE HISTORY**

Record: This file in 6.12 has a short, stable history (`54fcd9dd44b2c` …
`5513c5d0fb3d5`). No later refactor of the table. Standalone data
addition; series companion is a parallel row in `acp-config.c`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: `git log --author="Mehmet Aysel" -- sound/soc/amd/` is empty in
this tree (new contributor). Driver author is Marian Postevca.
Maintainer Mark Brown applied the series to `for-7.3`.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Code-level: none (no new helpers). Functional: **patch 1/2**
(`acp-config.c` M1060, `FLAG_AMD_LEGACY`) is required for a full enable.
`acp_pci_probe()` only continues if `snd_amd_acp_find_config()` returns
`FLAG_AMD_LEGACY` or `FLAG_AMD_LEGACY_ONLY_DMIC`. That DMI table in this
tree has M1010/M1020/M1040 but **not M1060**. This commit still applies
and is harmless alone (unused table row). Precedent: `b5338b1b901e` then
`5513c5d0fb3d5` were the same two-table split.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c c1a39c228ace` →
  https://patch.msgid.link/20260825092432.56292-2-mehmet4ysel@gmail.com
- `b4 dig -a`: **v1 only** (no v2/v3)
- Thread: submit 2026-08-25; Mark Brown applied 2026-08-26 to `for-7.3`
  (`032bb633e0c3` + `c1a39c228ace`)
- No NAK, no review objections, no `Cc: stable` in-thread
- lore.kernel.org `WebFetch` returned **403**; thread recovered via `b4
  dig -m`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc Liam Girdwood, Mark Brown, Jaroslav Kysela,
Takashi Iwai, `linux-sound`, `linux-kernel`. ASoC maintainer applied it.
No extra Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No bugzilla/syzbot/Reported-by. Author describes a specific 2021
MateBook SKU missing from an existing DMI set. User count: that SKU only
(unverified beyond the commit text).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: **[PATCH 1/2]** `ASoC: amd: acp-config: Add HVY-WXX9/M1060 DMI
quirk` — same DMI triple, `FLAG_AMD_LEGACY` / `ACP_PCI_DEV_ID`. Both
needed for audio. This patch is still a self-contained table insert.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: `WebFetch` of lore.kernel.org/stable **403**. Original thread
has no stable discussion. **UNVERIFIED** whether anyone asked for this
on stable@ separately. This tree already carries many AMD ASoC DMI
quirks (e.g. `6599a33c97f45`, `33680092d71b4`).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: No function body changes. Data: `acp3x_es83xx_dmi_table`.
Consumer: `acp3x_es83xx_probe()`.

**Step 5.2: TRACE CALLERS**

Record:
- `acp3x_es83xx_probe` ← `acp_ops_probe()` (`acp-mach.h`) ←
  `acp_legacy_mach` platform probe
- ops installed by `acp3x_es83xx_init_ops()` when `hs_codec_id ==
  ES83XX`
- PCI gate: `acp_pci_probe()` → `snd_amd_acp_find_config()` (companion
  table)
- Context: boot/device probe, not IRQ/hot path

**Step 5.3: TRACE CALLEES**

Record: `dmi_first_match()`, then ACPI codec lookup / `devm_kzalloc`. No
new callees.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable on this laptop at boot if ACP PCI + ES83xx ACPI are
present. Not a syscall attack path. User-visible: missing sound device.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same file already has three HVY-WXX9 rows. Same pattern as
`5513c5d0fb3d5`. AMD ASoC in this tree is full of DMI quirk additions.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c` lines
357–381 have HVY-WXX9 M1010/M1020/M1040 and **no M1060**. Driver since
**v6.7**, long before 6.12. `acp-config.c` likewise has those three SKUs
and not M1060.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** (small line-number offset vs mainline).
Surrounding table matches the hunk. No refactor in this file since
M1010.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `git log --grep='HVY-WXX9'` / `M1060`: no M1060 fix. M1010
completion (`5513c5d0fb3d5`) is already here from mainline 6.12, not a
substitute for M1060.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **ASoC AMD ACP machine driver** (`sound/soc/amd/`). Criticality:
**PERIPHERAL** (one laptop SKU), but this is the supported path for that
hardware. Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: File is mature (few commits). Wider `sound/soc/amd` still gets
DMI quirks in this 6.12 tree. Pattern is well established.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Platform/SKU-specific:** HUAWEI MateBook D16 2021, DMI `HVY-
WXX9` / `M1060`. No effect on other machines.

**Step 8.2: TRIGGER CONDITIONS**

Record: Every boot on that SKU. Not a race. Unprivileged users cannot
exploit it; they just have no speaker/mic.

**Step 8.3: FAILURE MODE SEVERITY**

Record: Probe `-ENODEV` → **no audio**. Not panic/UAF/corruption.
Severity **MEDIUM** for that user; class is a **hardware quirk**, which
stable explicitly takes.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- Benefit: restores audio on a 2021 Ryzen MateBook SKU that 6.12 already
  supports via sibling DMI rows.
- Risk: **very low** (8-line table, existing flag).
- Ratio: favorable. Companion 1/2 should go with it for a working stack.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Explicit **hardware quirk / DMI ID** exception (same class as USB/PCI
  IDs).
- Driver and sibling HVY-WXX9 rows **already in 6.12.111**.
- Real user-visible bug: codec never probes.
- 8 lines, copy of existing entries, ASoC maintainer applied it.
- This tree already backports other AMD ASoC DMI quirks.
- Historical split (`b5338b1b901e` + `5513c5d0fb3d5`) shows **both**
  tables are required; this is the machine-driver half.

**AGAINST:**
- Not a crash/security/deadlock issue.
- Patch **2/2**; full audio also needs `acp-config` M1060.
- No Tested-by / Reported-by in the message.
- One SKU only.

**UNRESOLVED:**
- lore.kernel.org HTTP 403 (thread obtained via b4).
- Stable@ search not independently fetched.
- Author-tested DMI dump not in the mail.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — identical to existing rows;
   maintainer applied. No separate Tested-by.
2. Fixes a real bug that affects users? **PASS** — that SKU gets
   `-ENODEV` and no sound.
3. Important issue? **PASS via quirk exception** — missing audio on
   supported hardware, not a panic.
4. Small and contained? **PASS** — +8 lines, one table.
5. No new features or APIs? **PASS** — no new driver/API; only a DMI
   match for an existing path.
6. Can apply to the local tree? **PASS** — file and context present;
   M1060 absent.

**Step 9.3: EXCEPTION CATEGORIES**

Record: **Hardware quirk / DMI table entry** for an **existing** driver
(device-ID analogue).

**Step 9.4: DECISION**

This should be backported to **this** 6.12 tree. It is a small DMI quirk
so a MateBook D16 2021 SKU already described by HVY-WXX9
M1010/M1020/M1040 can probe ES8316. Risk is negligible; apply difficulty
is clean.

Companion **[PATCH 1/2]** (`acp-config.c` M1060) is not this commit, but
without it `acp_pci_probe()` still returns `-ENODEV` for M1060. That
does not make this commit a NO: the two additions are independent table
rows, and this one is necessary and safe on its own.

---

## What the commit solves (for stable users)

On this 6.12 tree, `acp3x_es83xx_probe()` only registers the card if
`dmi_first_match()` hits `acp3x_es83xx_dmi_table`. M1060 is missing, so
that SKU warns and returns `-ENODEV`. Adding the row (same
`ES83XX_ENABLE_DMIC` as the other HVY-WXX9 entries) is the standard,
low-risk way to enable already-supported hardware.

## Risk vs benefit

Benefit: working analog audio/DMIC on one existing 2021 HUAWEI board
revision. Risk: an 8-line DMI insert that cannot affect other DMI
triples. Meets stable rules under the quirk exception.

---

## Verification

- **[Phase 1]** Tags: author SOB, Mark Brown SOB, msgid.link; no
  Fixes/Reported-by/Cc stable. Subject is hardware quirk add.
- **[Phase 2]** Diff: +8 lines in `acp3x_es83xx_dmi_table` only;
  `ES83XX_ENABLE_DMIC`; no logic change.
- **[Phase 2]** Local probe: `acp3x_es83xx_probe()` uses
  `dmi_first_match`; else `-ENODEV` + “not registered in DMI table”.
- **[Phase 3]** `git describe HEAD` / `make kernelversion`:
  pending-6.12, 6.12.111.
- **[Phase 3]** `git blame`: M1020/M1040 from `54fcd9dd44b2c`
  (v6.7-rc1); M1010 from `5513c5d0fb3d5`; both ancestors of HEAD.
- **[Phase 3]** `git merge-base --is-ancestor c1a39c228ace HEAD`: commit
  **not** in this tree.
- **[Phase 3]** `5513c5d0fb3d5` documents that acp-config without es83xx
  DMI is incomplete.
- **[Phase 3]** `acp_pci_probe` requires `FLAG_AMD_LEGACY` from
  `snd_amd_acp_find_config()`; local `acp-config.c` has HVY-WXX9
  M1010/M1020/M1040, not M1060.
- **[Phase 4]** `b4 dig -c c1a39c228ace`: msgid.link thread; v1 only;
  Mark Brown applied both patches to for-7.3.
- **[Phase 4]** `b4 dig -w`: ASoC maintainers on To/Cc.
- **[Phase 4]** `b4 dig -m /tmp/thread.mbox`: no NAK; no Cc: stable in-
  thread.
- **[Phase 4]** WebFetch lore.kernel.org and lore.kernel.org/stable:
  **403** — UNVERIFIED via HTTP; b4 mbox used instead.
- **[Phase 5]** Call chain: `acp_pci_probe` → legacy mach probe →
  `acp_ops_probe` → `acp3x_es83xx_probe` → DMI table. Boot-time, SKU-
  specific.
- **[Phase 6]** Grep: no `M1060` in `sound/soc/amd`; HVY-WXX9 appears
  three times in es83xx + three in acp-config. Apply: clean.
- **[Phase 7–8]** Subsystem `sound/soc/amd`; this 6.12 tree already has
  many `ASoC: amd: yc: Add DMI quirk` commits. Failure mode: no audio,
  not oops.
- **UNVERIFIED:** Independent stable@ archive search; author-provided
  DMI dump; how many M1060 units exist.

**YES**

 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
index eb5d4a5baef24..b18a8971aec94 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -379,6 +379,14 @@ static const struct dmi_system_id acp3x_es83xx_dmi_table[] = {
 		},
 		.driver_data = (void *)(ES83XX_ENABLE_DMIC),
 	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "HUAWEI"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "HVY-WXX9"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "M1060"),
+		},
+		.driver_data = (void *)(ES83XX_ENABLE_DMIC),
+	},
 	{}
 };
 
-- 
2.53.0

