Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AD35DB997;
	Mon, 19 Oct 2026 14:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418529; cv=none; b=qNdcIA5soiatCeerUHQ3JWDX98ca8cCfGYFlBRUkrzbcTaB1ZEkEHohjFSO122XVznvLfCEemz5fuO7OSQHXXDkrnFrtYfLy2BTAYn8HwnI6DPGTpZpHuUmUpF1KCnro4LUf4TZAFrBs1a5x9GCSWTeVItnVO/8f3xZX8tHY5aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418529; c=relaxed/simple;
	bh=qucnsg15qvbXGKCdAJ3NkLpeWzosADriYjgjdfeZ6eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsaxjCAB6Vo1u0jY6W1oYBNBz6J/vSbfdKaowLJdlAdB+FySwj/zbP1Ep2fv/obhgK/S0bautO9OmQiujZUQTQFtY2MpVBImqArfhWW+ZUhWDfMbDzGVXZMqdT/fnzAoBdq08fYLAdBKcHkPZy+Q/FCaW8P2Nf8dvU7ejApjQCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCXQSKrE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCXQSKrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B06A1F000CB;
	Mon, 19 Oct 2026 14:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418527;
	bh=jPvwjKS5G//xPAfl0ZnkZI6UltJ9LKGAm9jgfnQVCe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCXQSKrEvH2+cpjnWEQmA44Oz7uYhKUEfonlf07q1t3qbH1JnXTtxN14wxTPbVdjP
	 ciJ+e799QQkTPPdyH6nbTR9ZyzjpjeK1BXO9IuYJaODcFMLBEeRCzLwRMFZ8nI6Vgg
	 kzxMWtxwyKrNSI0x/NL/Cu8IOoAtYYdqRDex5aYdBe8/mUpVCzzOy3UnSH8Fr9svjc
	 3PToelc8smAUmUaxc/5qxztTL/5IUdLy4vGmdLjjRNf1L9va6nMdvwbi1nnxMeuPky
	 huy+jAcO/4x1zjlLnPOq2Qx5CzOSJde1Oxpdnj/81xV3/Qw/Esl17ILnlx16xZV/G3
	 jFgoPzPq4afyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: amd: yc: Add DMI entry for Alienware m18 R1 AMD
Date: Mon, 19 Oct 2026 09:50:02 -0400
Message-ID: <20261019135441.1420968-311-sashal@kernel.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit fd8ed52ecea6b93e23d52cb2758fb4fb4029067f ]

Add DMI entry so the YC machine driver probes on this model and
the internal DMIC works.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221485
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260824130302.553419-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a DMI quirk that enables the existing Yellow Carp DMIC driver on
one Alienware laptop. The local tree is **6.12.111** (`pending-6.12`);
the entry is not present here yet, and the surrounding driver/table are.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ASoC/amd/yc] [Add] Add DMI entry for Alienware m18 R1 AMD**

- Subsystem: `ASoC: amd: yc:` (ALSA SoC, AMD Yellow Carp ACP6x machine
  driver)
- Action verb: **Add** — here it is a DMI/quirk table addition, not a
  new driver
- Intent: make the YC machine driver probe on this model so the internal
  digital mic works

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record (from `git show fd8ed52ecea6b93e23d52cb2758fb4fb4029067f` and the
mailing-list mbox):

- **Closes:** `https://bugzilla.kernel.org/show_bug.cgi?id=221485` —
  user-filed kernel.org bug
- **Link:** `https://patch.msgid.link/20260824130302.553419-1-
  zhangheng@kylinos.cn`
- **Signed-off-by:** Zhang Heng `<zhangheng@kylinos.cn>` (author)
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer;
  applied to `sound.git for-7.3`)
- **No Fixes:** tag (expected)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by**
- Ignore pipeline SOB markers

Notable: Closes a public bugzilla; ASoC maintainer applied it. No
syzbot/KASAN.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:

- **Bug:** BIOS on Alienware m18 R1 AMD does not cause the YC machine
  driver to bind, so the internal DMIC is not registered.
- **Symptom:** internal microphone does not work (no ACP DMIC capture
  device).
- **Root cause (author):** missing DMI match in `yc_acp_quirk_table[]`.
- **Version info:** none in the message. Driver exists since 2021
  (`fa991481b8b22`).
- **Fix:** add `DMI_BOARD_VENDOR "Alienware"` + `DMI_PRODUCT_NAME
  "Alienware m18 R1 AMD"`.

Same class as existing sibling entries already in this tree (m15 R7 AMD,
m17 R5 AMD).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. It is an explicit hardware-quirk / device-enablement
fix. Stable exception category: DMI quirk for existing driver.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:

- File: `sound/soc/amd/yc/acp6x-mach.c` — **+7 / -0**
- Function: none; one new initializer in `yc_acp_quirk_table[]`
- Scope: **single-file surgical quirk addition**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:

- **Before:** `dmi_first_match(yc_acp_quirk_table)` in `acp6x_probe()`
  does not match this product. If ACPI `_WOV` / `AcpDmicConnected` also
  fail (typical on these Dell/Alienware BIOS images),
  `platform_get_drvdata()` is NULL and probe returns `-ENODEV`. No
  `acp6x` DMIC card.
- **After:** DMI matches, `platform_set_drvdata(pdev, &acp6x_card)`,
  card registers. Log: `Enabling ACP DMIC support via DMI`.
- Path: probe/init only; no hot path, no locking, no API change.

Verified in this tree:

```817:826:sound/soc/amd/yc/acp6x-mach.c
check_dmi_entry:
        /* check for any DMI overrides */
        dmi_id = dmi_first_match(yc_acp_quirk_table);
        if (dmi_id)
                platform_set_drvdata(pdev, dmi_id->driver_data);

        card = platform_get_drvdata(pdev);
        if (!card)
                return -ENODEV;
        dev_info(&pdev->dev, "Enabling ACP DMIC support via %s", dmi_id
? "DMI" : "ACPI");
```

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **(h) Hardware workaround / DMI quirk**

BIOS does not advertise DMIC via ACPI; the machine must be listed.
Without the entry, the existing ACP6x PDM path never registers.
Mechanism is identical to m15 R7 / m17 R5 entries already here.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:

- Obviously correct: same struct shape as every other table entry;
  `driver_data = &acp6x_card`.
- Minimal: 7 lines, one model.
- Regression risk: **very low**. Match is vendor+product-name specific.
  Other machines are unaffected. If this SKU has no ACP6x PCI device,
  `acp6x_probe()` never runs and the entry is inert.
- No public API, no data-structure layout change, no new Kconfig.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:

- Insertion is after the m17 R5 AMD entry, blamed to `d40b6529c6269`
  (Brent Mendelsohn, 2022-10-24): “This model requires an additional
  detection quirk to enable the internal microphone - BIOS doesn't seem
  to support AcpDmicConnected”.
- m15 R7 AMD: `c70f006356fac` (already in this 6.12 tree).
- Machine driver introduced: `fa991481b8b22` (2021-10-18, v5.16-era).
  Present long before 6.12.

The “bug” is absence of this SKU from a table that has existed for
years.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No Fixes: tag. N/A. Introduced-by is “never listed this DMI
string,” not a later regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: This file on 6.12.y is a long series of standalone DMI additions
(`git log --oneline --grep='Add DMI' -- sound/soc/amd/yc/acp6x-mach.c` →
24 commits). Parent of the candidate is `e2aa5ad3be41a` (“Add DMI entry
for MSI Thin A15 B7UC”), already in this tree as `aacaae0b94875`.
**Standalone, not patch X/Y.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Zhang Heng is a regular DMI-quirk contributor in this same file
on this tree (HP Victus 16-e1xxx, Thin A15 B7VF, ASUS EXPERTBOOK
PM1503CDA, Acer TravelMate P216-41-TCO). Not the subsystem maintainer;
Mark Brown applied the patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. Relies only on `yc_acp_quirk_table` and `acp6x_card`, both
in this checkout. `git merge-base --is-ancestor fd8ed52ecea6 HEAD` is
false (fix not yet here). No follow-up/revert grepping `Alienware m18`
on this path.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:

- `b4 dig -c fd8ed52ecea6` →
  https://patch.msgid.link/20260824130302.553419-1-zhangheng@kylinos.cn
- `b4 dig -a`: **v1 only** (no later revision)
- Thread (2 messages, saved via `b4 mbox`):
  1. Zhang Heng, 2026-08-24: the patch
  2. Mark Brown: **Applied** to
     `git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
     for-7.3` as `fd8ed52ecea6`
- No NAK, no requested changes, no reviewer concern about the DMI
  strings
- Also listed in sound fixes for 7.3-rc1 (lkml.iu.edu sound-fix pull)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc = Zhang Heng, `broonie@kernel.org`, `linux-
sound@vger.kernel.org`, `linux-kernel@vger.kernel.org`. ASoC maintainer
was the recipient and applied it. No extra reviewer Ack.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record:

- Closes bugzilla.kernel.org 221485.
- Direct fetch of bugzilla and lore HTML was blocked by Anubis (403 /
  PoW). **Full bugzilla comments UNVERIFIED.**
- Commit body + Closes: tag still document a real user-facing DMIC
  failure on this model.
- Unrelated Ubuntu bugs about Intel Alienware 18 Area-51 / SOF are a
  different machine; not this ACP6x DMI.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone `[PATCH]`, not a series. Sibling Alienware YC entries
already in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: Web search of lore.kernel.org/stable for this subject found
**no** discussion. No record of a prior rejection. Absence is expected;
this is why the commit is under review.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**

Record: Table data only. Consumer: `acp6x_probe()`.

**Step 5.2: TRACE CALLERS**

Record:

- `acp6x_probe` is `.probe` of `platform_driver acp6x_mach_driver`
  (`name = "acp_yc_mach"`).
- Platform device created in `sound/soc/amd/yc/pci-acp6x.c` when ACP pin
  config is PDM mode (`pdevinfo[2].name = "acp_yc_mach"`).
- Context: boot / ACPI+PCI enumeration. Not IRQ, not a syscall hot path.

**Step 5.3: TRACE CALLEES**

Record: `dmi_first_match`, `platform_set_drvdata`,
`devm_snd_soc_register_card`. No alloc/lock change in this commit.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: PCI ACP6x device → create `acp_yc_mach` → `acp6x_probe` → DMI
table → ALSA card `acp6x` / “DMIC capture”. Reachable on this laptop at
boot. Userspace then sees a capture device. Unprivileged apps can use
the mic once the card exists; they cannot trigger a kernel crash with
this patch.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Entire `yc_acp_quirk_table[]` (~200 `DMI_MATCH` lines) is this
pattern. Same Alienware vendor/product matching is already used for m15
R7 and m17 R5.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:

- Tree: `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → **6.12.111**; branch `pending-6.12`.
- File and table exist. m15 R7 and m17 R5 entries exist. **`Alienware
  m18 R1 AMD` does not** (`grep` no matches).
- ACPI fallback (`AcpDmicConnected` / `_WOV`) is the same as mainline;
  this SKU still needs DMI.
- Driver since 2021; 6.12 is affected.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply / trivial offset.** Insertion is immediately after
the m17 R5 AMD block, which is present at lines 503–509. The candidate’s
3-line context matches this file. Preceding MSI “Raider A18 HX A9WJG”
from a later mainline snapshot is **not** required.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No m18 R1 entry. No alternate fix for this product string.
m15/m17 quirks do not cover m18 (exact `DMI_PRODUCT_NAME` match).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **ASoC AMD Yellow Carp (`sound/soc/amd/yc/`)** —
**PERIPHERAL/driver-specific**, but the quirk table is the supported way
to enable DMIC on YC laptops. Kconfig: `SND_SOC_AMD_YC_MACH` depends on
`SND_SOC_AMD_ACP6x && ACPI`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature driver (2021), still actively receiving DMI quirks (many
already on 6.12.y). This is the normal maintenance pattern, not a new
subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / DMI-specific.** Only systems whose DMI board
vendor is `Alienware` and product name is `Alienware m18 R1 AMD`, and
that actually instantiate `acp_yc_mach`. Everyone else: no code path
change.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every boot on that laptop if ACP6x PDM mode is active. Not a
race. Not unprivileged-exploit. Common for owners of that model; zero
for others.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Internal microphone missing (ALSA card never registered).
**MEDIUM** functionally (hardware does not work), not a panic/UAF. Still
the exact class stable accepts as a quirk.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:

- **Benefit:** restores internal mic on a shipping AMD Alienware laptop
  for 6.12.y users (enterprise/LTS kernels). Documented via bugzilla
  Closes.
- **Risk:** very low (7 lines, DMI-gated, existing table format,
  maintainer-applied).
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:

- Real hardware bug: internal DMIC never enabled without DMI
- Closes kernel.org bug 221485
- Textbook stable exception: DMI quirk on an existing driver
- 7-line, obviously correct, matches m15/m17 entries already in 6.12
- File, probe path, and table exist here; patch applies
- Applied by Mark Brown; landed in sound 7.3-rc1 fixes
- Standalone; no prerequisites missing from this tree
- This tree already carries dozens of the same DMI additions

AGAINST:

- Not a crash/security/corruption issue
- No Tested-by/Reviewed-by besides maintainer apply
- Full bugzilla thread could not be fetched (Anubis)

UNRESOLVED:

- Exact bugzilla comments / reporter DMI dump (UNVERIFIED)
- Whether every m18 R1 AMD SKU is ACP6x vs a later ACP (if not, entry is
  a harmless no-op)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — identical to existing table
   entries; maintainer applied v1
2. Fixes a real bug that affects users? **PASS** — mic does not work;
   bugzilla Closes
3. Important issue? **PASS** as hardware-quirk exception (mic unusable
   on that model; not a panic)
4. Small and contained? **PASS** — +7 lines, one file
5. No new features or APIs? **PASS** — DMI ID on existing driver
6. Can apply to the local tree? **PASS** — YC driver + insertion point
   present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk / DMI table entry for an existing driver.**
Explicitly allowed.

**Step 9.4: DECISION**

Backport to this 6.12.y tree. It enables existing ACP6x DMIC support on
one DMI-matched laptop, is tiny, and matches the quirk pattern already
used here.

------------------------------------------------
What the commit solves for stable users
------------------------------------------------

On Alienware m18 R1 AMD, ACPI often does not flag the ACP DMIC. Without
this DMI row, `acp6x_probe()` returns `-ENODEV` and there is no internal
capture device. Adding the match makes the existing YC machine driver
bind and register the DMIC card. 6.12 users of that laptop keep a broken
mic until this lands.

Risk vs benefit: benefit is real hardware enablement; risk is confined
to that DMI pair. No locking, allocation, or ABI change.

------------------------------------------------
Verification
------------------------------------------------

- [Phase 1] Parsed subject/tags from `git show fd8ed52ecea6`: Closes
  221485, Link msgid, SOB Zhang Heng + Mark Brown; no Fixes/Cc-stable
- [Phase 2] Diff: +7 lines in `yc_acp_quirk_table[]` only
- [Phase 2] Read `acp6x_probe()` in this tree: DMI match sets drvdata;
  no match → `-ENODEV`
- [Phase 3] Blame: m17 R5 entry `d40b6529c6269` (2022); driver
  `fa991481b8b22` (2021); both ancestors of HEAD
- [Phase 3] `git merge-base --is-ancestor fd8ed52ecea6 HEAD` → not
  ancestor (not in this tree yet)
- [Phase 3] `grep 'Alienware m18 R1 AMD'` → no matches in `acp6x-mach.c`
- [Phase 3] Author history: several other YC DMI commits already on this
  branch
- [Phase 4] `b4 dig -c fd8ed52ecea6`: lore URL; v1 only; To/Cc include
  broonie and linux-sound
- [Phase 4] `b4 mbox`: Mark Brown applied to sound.git for-7.3; no NAK
- [Phase 4] Bugzilla HTML UNVERIFIED (Anubis 403). Closes: tag verified
  in commit and patch email
- [Phase 4] Stable list search: no prior discussion found
- [Phase 5] Callers: `pci-acp6x.c` creates `acp_yc_mach` in PDM mode;
  probe at boot
- [Phase 6] `git describe HEAD` / `make kernelversion`: **6.12.111**,
  branch pending-6.12
- [Phase 6] Insertion context after m17 R5 AMD present at lines 503–509;
  expected clean apply
- [Phase 8] Failure mode: missing internal mic, severity MEDIUM, quirk
  exception
- UNVERIFIED: full bugzilla comment text; whether every m18 R1 AMD SKU
  is ACP6x (mismatch would be inert)

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 666ac5b36e7d6..8e203c034851f 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -514,6 +514,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m18 R1 AMD"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0

