Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10DC3D170B;
	Mon, 30 Mar 2026 12:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874343; cv=none; b=bqnZeibSIq4R06Pt4gzuSZCXAqvaik4x+SIvA3iitNnklEnAoL6RiDg4il8m6kiE/Kbed0uH/uDKcbVnbioB5MUSJyTZPqgwXeekWzwcYgHBR8hA8WKCPcBwt9ziZtwp+TZ1dg5uEit0Cal+brOUfwTJgsro035I/3pPc9CMagE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874343; c=relaxed/simple;
	bh=eu9zBxsm3QgOmOR+DlWWw2kJ0NvUDSOErEJ+8IvT1vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2EEjSqhILfuvkPEbRgkhABO+uG4mQjQyJyhCofGp5IxiYCNnBaKWa6YAA8iXMWTh9zSLXtl1sirsUE2qtLI2sQaLpytVEv+FtMps1MWP4VDhjuJr/TZnQgvszkjQtuuqPJ+DmKxuX1NzV02S9DiaFcQozJQ5d4+feWh+NxGkec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twSBNiRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twSBNiRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C38C2BCB3;
	Mon, 30 Mar 2026 12:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874341;
	bh=eu9zBxsm3QgOmOR+DlWWw2kJ0NvUDSOErEJ+8IvT1vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twSBNiRCjWwHqMLEHx+K6GaSugVEPZrsnLXEbwoQNxVE6hEanB+2FQD2kom3A91P1
	 Pqh+xlpT1XgbhEKSmXVzLinagGLdWjB0psPq75ka8KF4IHyn1Q44V7xQfaMLDD7MG5
	 Q4MTMpvSrCqyuBLEmYbaYDqL2SYPef2XB700CO857khqdw2usbc7ilH1vVQSktmNTM
	 Z+2JIJwdqMtDzpdsL3WTf73HpEOvxERgLbTPoXl0Vceo2qWWSs0c5R0rkWNyudwr5N
	 tV0qDbV41Ma3A4B9JjiZ3c0ZBhRhthNJNErSNyQgR6w21TSKujnkLAbAmACwWG6RVN
	 fHmrzKrQhN9MA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vee Satayamas <vsatayamas@gmail.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK BM1403CDA
Date: Mon, 30 Mar 2026 08:38:26 -0400
Message-ID: <20260330123842.756154-13-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vee Satayamas <vsatayamas@gmail.com>

[ Upstream commit f200b2f9a810c440c6750b56fc647b73337749a1 ]

Add a DMI quirk for the Asus Expertbook BM1403CDA to resolve the issue of the
internal microphone not being detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221236
Signed-off-by: Vee Satayamas <vsatayamas@gmail.com>
Reviewed-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260315142511.66029-2-vsatayamas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1:** Record: [ASoC: amd: yc] [Add] DMI quirk for ASUS
EXPERTBOOK BM1403CDA to fix internal microphone not being detected.

**Step 1.2:** Record:
- `Link: https://bugzilla.kernel.org/show_bug.cgi?id=221236` — user-
  filed bug report
- `Signed-off-by: Vee Satayamas <vsatayamas@gmail.com>` — patch author
- `Reviewed-by: Zhang Heng <zhangheng@kylinos.cn>` — peer review
  (notably Zhang Heng authored the sibling PM1503CDA quirk,
  `355aab1aaf77d`)
- `Link:
  https://patch.msgid.link/20260315142511.66029-2-vsatayamas@gmail.com`
  — mailing list posting
- `Signed-off-by: Mark Brown <broonie@kernel.org>` — ASoC subsystem
  maintainer merged it
- No `Fixes:` tag, no `Cc: stable`, no `Reported-by:`, no `Tested-by:`
  (absence expected for manual review)

**Step 1.3:** Record: Bug: internal microphone not detected on ASUS
EXPERTBOOK BM1403CDA. Symptom: no audio capture device appears. Root
cause: this board's firmware/ACPI does not properly signal DMIC
presence, requiring a DMI override entry. No version information stated.

**Step 1.4:** Record: Not a hidden bug fix — it is an explicit hardware
quirk addition. This falls squarely into the "QUIRKS and WORKAROUNDS"
exception category for stable.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1:** Record: Single file changed:
`sound/soc/amd/yc/acp6x-mach.c`, +7 lines, 0 removed. Only
`yc_acp_quirk_table[]` static data modified. Scope: single-file, data-
only, surgical.

**Step 2.2:** Record: Before: BM1403CDA has no match in
`yc_acp_quirk_table[]`. After: a new entry matches `DMI_BOARD_VENDOR =
"ASUSTeK COMPUTER INC."` and `DMI_BOARD_NAME = "BM1403CDA"`, setting
`driver_data = &acp6x_card`. The new entry is inserted just before the
table terminator `{}`.

**Step 2.3:** Record: Category: Hardware workaround / DMI quirk table
entry. Mechanism: In `acp6x_probe()`, if ACPI methods (`_WOV` /
`AcpDmicConnected`) fail to enable the DMIC, the code falls through to
`check_dmi_entry` (line 761) where `dmi_first_match(yc_acp_quirk_table)`
is called. If matched, `platform_set_drvdata()` is set to `&acp6x_card`.
Without a match, `platform_get_drvdata()` returns NULL and
`acp6x_probe()` returns `-ENODEV` (line 768-769), meaning no sound card
is registered and the internal microphone is entirely absent.

Verified in the source:

```761:769:sound/soc/amd/yc/acp6x-mach.c
check_dmi_entry:
        /* check for any DMI overrides */
        dmi_id = dmi_first_match(yc_acp_quirk_table);
        if (dmi_id)
                platform_set_drvdata(pdev, dmi_id->driver_data);

        card = platform_get_drvdata(pdev);
        if (!card)
                return -ENODEV;
```

**Step 2.4:** Record: Obviously correct. The entry is structurally
identical to the 96 existing `driver_data = &acp6x_card` entries in the
same table, including sibling ASUS EXPERTBOOK models BM1503CDA and
PM1503CDA. Regression risk: zero for other hardware — the DMI match is
specific to one exact board vendor/name pair.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1:** Record: `git blame` shows the neighboring ASUS entries
were added by: `b671f9384ffc8` (Vivobook M6501RR, 2026-02-10),
`5a859a7dfce6c` (BM1503CDA, 2026-02-21), `355aab1aaf77d` (PM1503CDA,
2026-03-04). The table itself originates from `fa991481b8b22` ("ASoC:
amd: add YC machine driver using dmic", 2021-10-18), first appearing in
the v5.16 release cycle.

**Step 3.2:** Record: N/A — no `Fixes:` tag in the commit message.

**Step 3.3:** Record: Recent history of `acp6x-mach.c` is dominated by
single-entry DMI quirk additions for various laptop models (HP, ASUS,
Lenovo, Acer, MSI). This is a well-established, routine pattern. No
indication this patch is part of a multi-patch series requiring other
commits.

**Step 3.4:** Record: Vee Satayamas has no prior commits in
`sound/soc/amd/yc/` in this tree. However, the patch was reviewed by
Zhang Heng (who authored the PM1503CDA entry) and merged by Mark Brown
(ASoC maintainer), providing strong quality assurance.

**Step 3.5:** Record: No dependencies. The patch uses only existing
table infrastructure (`yc_acp_quirk_table[]`, `&acp6x_card`, `DMI_MATCH`
macros) that has been present since the driver was introduced in v5.16.
Fully standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.4:** Record: The commit references bugzilla.kernel.org bug
#221236 and a patch.msgid.link URL. External archive fetches are blocked
by Anubis challenge pages in this environment, so the exact mailing list
discussion and bugzilla details could not be retrieved. The commit
message itself documents the bug (internal mic not detected), the patch
was peer-reviewed (`Reviewed-by: Zhang Heng`) and merged by the ASoC
maintainer (`Signed-off-by: Mark Brown`). The message-id suffix `-2-`
suggests this may have been part of a small series, but the patch is
self-contained.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1:** Record: The diff modifies only the static data table
`yc_acp_quirk_table[]`. The runtime consumer is `acp6x_probe()`.

**Step 5.2:** Record: `acp6x_probe()` is the `.probe` callback of
`acp6x_mach_driver`, registered via `module_platform_driver()`. The
platform device `"acp_yc_mach"` is created by `snd_acp6x_probe()` in
`sound/soc/amd/yc/pci-acp6x.c` during PCI enumeration.

**Step 5.3:** Record: Within `acp6x_probe()`, key callees include
`ACPI_COMPANION()`, `acpi_dev_get_property()`,
`acpi_evaluate_integer()`, `dmi_first_match()`,
`platform_set_drvdata()`, and `devm_snd_soc_register_card()`. The quirk
only influences probe-time card selection.

**Step 5.4:** Record: Call chain: PCI enumeration → `snd_acp6x_probe()`
→ platform device registration → `acp6x_probe()` → DMI override → sound
card registration. Reachable automatically at boot on affected hardware.
Not a syscall-triggered path.

**Step 5.5:** Record: 96 existing `driver_data = &acp6x_card` entries in
the same file confirm this is the standard, well-tested pattern for
enabling DMIC on laptop models with broken/missing ACPI firmware
descriptions.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** Record: Verified via `git ls-tree`:
- `sound/soc/amd/yc/` is **absent** in v5.15
- Present since v5.16 (`fa991481b8b22`)
- Confirmed present in v6.1 and v6.6
- Fix is relevant to all active stable trees from v5.16 onward (6.1.y,
  6.6.y, 6.12.y, etc.)
- **Not applicable** to 5.15.y (driver does not exist there)

**Step 6.2:** Record: Expected clean apply or trivial context
adjustment. Older stable trees have shorter quirk tables, so the hunk
context will differ, but the semantic change is a single table entry
insertion before `{}` — trivial to backport.

**Step 6.3:** Record: No existing BM1403CDA entry found in git history.
No duplicate fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Record: Subsystem: ASoC / AMD Yellow Carp (ACP6x) machine
driver. Criticality: IMPORTANT — audio is essential for laptop users;
this is a shipping ASUS business laptop model.

**Step 7.2:** Record: Highly active subsystem — recent history shows a
steady stream of DMI quirk additions for various laptop manufacturers.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Record: Platform-specific: affects owners of ASUS
EXPERTBOOK BM1403CDA with `CONFIG_SND_SOC_AMD_YC_MACH` enabled.

**Step 8.2:** Record: Trigger: deterministic on every boot of this
hardware. The internal microphone is permanently non-functional without
this quirk. Not timing-dependent.

**Step 8.3:** Record: Failure mode: internal microphone not detected
(probe returns `-ENODEV`). Severity: HIGH for affected users — complete
loss of audio capture functionality (no video calls, no voice
recording).

**Step 8.4:** Record: Benefit: HIGH for affected users (restores
essential hardware functionality). Risk: VERY LOW (7-line data-only
change, exact DMI match, no logic modification, identical pattern to 96
existing entries). Ratio: strongly favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence compiled:**

FOR backporting:
- Real user-reported bug (bugzilla #221236)
- Fixes completely broken hardware (internal microphone non-functional)
- 7 lines added, single file, data-only change
- Zero regression risk (narrow DMI match, no logic change)
- Identical pattern to 96 existing quirk entries in the same table
- Reviewed by sibling-entry author (Zhang Heng) and merged by ASoC
  maintainer (Mark Brown)
- Driver and quirk infrastructure exist in all active stable trees
  (v6.1+, v6.6+)

AGAINST backporting:
- No evidence whatsoever against backporting

UNRESOLVED:
- Exact bugzilla details and mailing list discussion (blocked by Anubis)
- Whether the `-2-` message-id indicates a multi-patch series (but patch
  is self-contained)

**Step 9.2: Stable rules checklist:**
1. Obviously correct and tested? **YES** — identical to 96 existing
   entries; reviewed and merged by maintainer.
2. Fixes a real bug? **YES** — internal microphone not detected on
   shipping hardware.
3. Important issue? **YES** — complete hardware feature loss.
4. Small and contained? **YES** — 7 lines, one file, data-only.
5. No new features or APIs? **YES** — enables existing driver behavior
   for one board.
6. Can apply to stable? **YES** — for trees v5.16+ (6.1.y, 6.6.y, etc.);
   minor context adjustment may be needed.

**Step 9.3: Exception category:** Hardware quirk/workaround — DMI-based
enablement entry for an existing driver. This is explicitly listed as a
YES exception for stable.

**Step 9.4: Decision:** This is a textbook stable-backport DMI quirk.
Minimal risk, clear benefit, well-established pattern.

---

## Verification

- [Phase 1] Parsed commit message tags: found Link to bugzilla #221236,
  Reviewed-by Zhang Heng, merged by Mark Brown (ASoC maintainer)
- [Phase 2] Read `acp6x-mach.c` lines 695-779: verified existing ASUS
  entries at lines 706-719 and the DMI override path at lines 761-769
  (`dmi_first_match()` → `platform_set_drvdata()` → `-ENODEV` if no
  card)
- [Phase 2] Verified diff adds exactly one 7-line DMI table entry with
  no removals or logic changes
- [Phase 3] `git blame -L 700,730`: confirmed neighboring entries from
  `b671f9384ffc8`, `5a859a7dfce6c`, `355aab1aaf77d`; table terminator
  from `fa991481b8b22`
- [Phase 3] `git log --oneline -1 fa991481b8b22`: confirmed "ASoC: amd:
  add YC machine driver using dmic" introduced the driver
- [Phase 3] `git describe --contains fa991481b8b22`: confirmed driver
  first appears in v5.16-rc3 cycle
- [Phase 3] `git ls-tree v5.15 -- sound/soc/amd/yc/`: confirmed
  directory is **absent** in v5.15
- [Phase 3] `git ls-tree v5.16 -- sound/soc/amd/yc/`: confirmed
  directory is **present** in v5.16
- [Phase 3] `git log --oneline -20 -- sound/soc/amd/yc/acp6x-mach.c`:
  confirmed recent history is dominated by DMI quirk additions
- [Phase 5] `grep` count: verified 96 existing `driver_data =
  &acp6x_card` entries in the same file
- [Phase 6] `git ls-tree v6.1/v6.6 -- sound/soc/amd/yc/acp6x-mach.c`:
  confirmed file exists in both stable trees
- [Phase 4] UNVERIFIED: bugzilla.kernel.org and lore.kernel.org content
  blocked by Anubis; did not drive decision
- [Phase 3] UNVERIFIED: exact series context for `-2-` message-id
  suffix; patch is self-contained regardless

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1324543b42d72..c536de1bb94ad 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -717,6 +717,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "PM1503CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "BM1403CDA"),
+		}
+	},
 	{}
 };
 
-- 
2.53.0

