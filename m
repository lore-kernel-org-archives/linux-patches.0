Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D7A3DC4C4;
	Tue, 14 Apr 2026 11:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165918; cv=none; b=uWManq72iVTczE0B+z6V/mSatzmSTyGVAZfdhF2ZmZSisI0ap1qO703cyaPhOrRYXfiRBfj/fSDdgrp7XWID6D2q+EhsZThIUWkPdNBvPviS6eSuYCf7D15r9wz4797wdStkBKChvoxJPe4k+JRPPyCmDKsa/YZRbmP3pZDI4a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165918; c=relaxed/simple;
	bh=whNo55U9x1E6T13inTkHwz1zqMrj4x7G+rQSoBR7x4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BIK5yUia27HAghU6mvPzMj+Qv5gLG4OSvc489+3oONEZ9LF9WhGFreGhx4X8II0+aBq9nw6V1GeYLOciIzpWM8S6Y82xSuGUljefZh9r83ktMzTKgQOOozm/3MYhPQKYhMMmXY24BjYMoW6qxFZaSnykEFdlpup0DLuBULDdoeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eE7pH+ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eE7pH+ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0B5C19425;
	Tue, 14 Apr 2026 11:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776165918;
	bh=whNo55U9x1E6T13inTkHwz1zqMrj4x7G+rQSoBR7x4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE7pH+ra/PM3tm7hNfGj3d3ZkwPni6wIo3BRCy7F80NRkHBW9HvcgW62xeNwaoFB2
	 CL/hHjr6QeLlcmubfwC9LZtjfPcQn0E8rZaUAZusfhtncYTiyiyB6y1mhc7xmnARXX
	 XShdmPVeQRZ7TOK2TS8k7vShUXaxMvIXqkFjnTfQoMVAJprEgvdbLUIPfjv292tsNs
	 cJspY71c2ptndzqbU4+ZenKQMx7cG9YRVeLZAM3Sct4xm7K/E7g2sFvDAKse8BTO2k
	 T5hj1Q7NU7exGzrAmGNLDrP0KIQELI/Wb6mY020un+6LU3624ECGnP7vZq3NZeM3nT
	 mNCQWxiRYTxsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Imrane <ihalim.me@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] platform/x86/amd: pmc: Add Thinkpad L14 Gen3 to quirk_s2idle_bug
Date: Tue, 14 Apr 2026 07:25:01 -0400
Message-ID: <20260414112509.410217-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414112509.410217-1-sashal@kernel.org>
References: <20260414112509.410217-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.12
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 1a9452c428a6b76f0b797bae21daa454fccef1a2 ]

This platform is a similar vintage of platforms that had a BIOS bug
leading to a 10s delay at resume from s0i3.

Add a quirk for it.

Reported-by: Imrane <ihalim.me@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221273
Tested-by: Imrane <ihalim.me@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260324211647.357924-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

External sources are blocked by Anubis. No matter — the commit itself
has sufficient information. Let me complete the analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `platform/x86/amd: pmc`
- Action: "Add" (adding hardware to quirk table)
- Summary: Adding Thinkpad L14 Gen3 to `quirk_s2idle_bug` DMI table
- Record: [platform/x86/amd/pmc] [Add] [DMI quirk entry for Thinkpad L14
  Gen3 to workaround s2idle BIOS bug]

**Step 1.2: Tags**
- Reported-by: Imrane <ihalim.me@gmail.com> — real user report
- Closes: bugzilla.kernel.org #221273 — tracked bug
- Tested-by: Imrane <ihalim.me@gmail.com> — reporter tested and
  confirmed the fix
- Signed-off-by: Mario Limonciello (AMD PMC subsystem author/maintainer)
- Reviewed-by: Ilpo Järvinen (platform/x86 maintainer)
- Link: patch.msgid.link to original submission
- Record: User-reported bug, user-tested fix, reviewed by subsystem
  maintainer.

**Step 1.3: Commit Body**
- Bug: BIOS bug on this platform causes a 10-second delay at resume from
  s0i3 (suspend-to-idle)
- The platform is "similar vintage" to others already in the quirk table
- The fix is to add a DMI match to invoke the existing workaround
- Record: [10s resume delay from s0i3] [BIOS firmware bug] [Workaround
  via existing quirk mechanism]

**Step 1.4: Hidden Bug Fix?**
- This is an explicit hardware workaround addition, not disguised. It
  fixes a real user-reported issue with sleep/resume.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/platform/x86/amd/pmc/pmc-quirks.c`)
- Lines added: 9 (one DMI table entry + comment)
- Lines removed: 0
- Functions modified: None — only data (the `fwbug_list[]` DMI table)
- Record: Single file, +9 lines, data-only addition to static table.

**Step 2.2: Code Flow Change**
- Before: Thinkpad L14 Gen3 (DMI_PRODUCT_NAME "21C6") is not matched in
  `fwbug_list`, so no quirk is applied. The BIOS SMI handler runs during
  D3->D0 transition, causing 10s delay.
- After: The device matches, `quirk_s2idle_bug` is set, and
  `amd_pmc_skip_nvme_smi_handler()` runs during resume to clear bit 0 of
  the firmware scratch register, skipping the buggy SMI handler.

**Step 2.3: Bug Mechanism**
- Category: Hardware workaround (h)
- Mechanism: DMI match table entry for existing quirk. No code logic
  changes.

**Step 2.4: Fix Quality**
- Obviously correct — identical pattern to dozens of existing entries in
  the same table.
- Minimal — 9 lines of data addition.
- Zero regression risk — only affects this specific Lenovo model
  (DMI_PRODUCT_NAME "21C6").

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- The quirk table and `quirk_s2idle_bug` mechanism were introduced in
  commit 3bde7ec13c971, present since v6.6.
- The `pmc-quirks.c` file has been in the tree since v6.6-rc1 (commit
  92c2fb8fa56c4).

**Step 3.2: Fixes Tag**
- No Fixes: tag (expected for a quirk addition — there's no single
  commit that "introduced" this issue; it's a BIOS firmware bug).

**Step 3.3: File History**
- The file receives frequent quirk additions (many similar commits in
  the log). This is a well-established pattern.
- No dependencies — this is a standalone data addition.

**Step 3.4: Author**
- Mario Limonciello is the AMD PMC driver author (copyright holder, line
  8 of pmc-quirks.c). This is the subsystem maintainer adding a quirk.

**Step 3.5: Dependencies**
- None. The `quirk_s2idle_bug` structure and the DMI matching
  infrastructure exist unchanged since v6.6. This patch is self-
  contained.

## PHASE 4: EXTERNAL RESEARCH

- Bugzilla #221273 and lore.kernel.org were blocked by Anubis anti-bot
  protection.
- From the commit metadata: the fix was Reported-by and Tested-by the
  same user, reviewed by the platform/x86 maintainer. This is a
  standard, well-vetted quirk addition.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4:** No functions are modified. The change is purely data —
a new entry in the `fwbug_list[]` static DMI table. The execution path
is:
1. `amd_pmc_quirks_init()` calls `dmi_first_match(fwbug_list)` at probe
   time
2. If matched, sets `dev->quirks = &quirk_s2idle_bug`
3. On resume, `amd_pmc_process_restore_quirks()` calls
   `amd_pmc_skip_nvme_smi_handler()` which clears the problematic
   firmware bit

This path is well-tested by the dozens of other identical entries.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The `quirk_s2idle_bug` mechanism exists in:
- v6.6: Yes (introduced in v6.6 cycle, commit 3bde7ec13c971)
- v6.12: Yes (22 references to quirk_s2idle_bug)
- v6.1: No (pmc-quirks.c doesn't exist)
- Applicable stable trees: 6.6.y, 6.12.y, and any later LTS trees.

**Step 6.2:** The patch should apply cleanly or with trivial offset —
it's adding a new entry to a table. The surrounding context (other
Lenovo entries) exists in both v6.6 and v6.12. Minor fuzz may be needed
due to other entries added since branching, but the addition is
position-independent within the table.

**Step 6.3:** No other fix for this specific hardware (DMI "21C6")
exists.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** platform/x86/amd/pmc — IMPORTANT subsystem. AMD power
management affects many laptop users. Sleep/resume is a critical user-
facing feature.

**Step 7.2:** Very actively developed — frequent quirk additions for new
hardware.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected users: Owners of Lenovo Thinkpad L14 Gen3 (a
popular business laptop).

**Step 8.2:** Trigger: Every suspend-to-idle and resume cycle. Very
common — laptop users suspend/resume constantly.

**Step 8.3:** Failure mode: 10-second delay on every resume from s0i3.
Not a crash, but a significant usability issue for a standard laptop
operation. Severity: MEDIUM (user-visible, frequent, annoying).

**Step 8.4:** Risk-benefit ratio:
- Benefit: HIGH — fixes a real, user-reported, frequently-triggered
  issue on a popular laptop model. Tested by the reporter.
- Risk: VERY LOW — 9 lines of data-only change, only affects one
  specific hardware model, uses a proven quirk mechanism, zero chance of
  regression for any other system.

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Hardware quirk addition — falls in the automatic YES exception
  category
- Real user-reported bug (bugzilla #221273) with user-tested fix
- Author is the AMD PMC subsystem maintainer
- Reviewed by platform/x86 maintainer
- Tiny change (9 lines), data-only, zero code logic changes
- Uses well-established, proven quirk mechanism
- Fixes a frequently-triggered usability issue (10s resume delay)
- Zero regression risk (only affects specific DMI-matched hardware)
- Applicable to v6.6+ stable trees

**Evidence AGAINST backporting:**
- None identified.

**Stable rules checklist:**
1. Obviously correct and tested? **Yes** — identical to 20+ existing
   entries, tested by reporter
2. Fixes a real bug? **Yes** — BIOS firmware bug causing 10s resume
   delay
3. Important issue? **Yes** — sleep/resume is critical for laptop users
4. Small and contained? **Yes** — 9 lines, one file, data only
5. No new features or APIs? **Correct** — no new features
6. Can apply to stable? **Yes** — mechanism exists in 6.6+

**Exception category:** Hardware quirk/workaround — automatic YES.

## Verification

- [Phase 1] Parsed tags: Reported-by user, Tested-by same user,
  Reviewed-by platform/x86 maintainer, Closes bugzilla #221273
- [Phase 2] Diff analysis: +9 lines adding DMI table entry to
  fwbug_list[], data-only change, no code logic
- [Phase 3] git show v6.6:pmc-quirks.c: confirmed quirk_s2idle_bug
  structure exists in v6.6 with identical mechanism
- [Phase 3] git describe --contains 3bde7ec13c971: confirmed s2idle
  quirk introduced in v6.6 cycle
- [Phase 3] git describe --contains 92c2fb8fa56c4: confirmed pmc-
  quirks.c created in v6.6-rc1
- [Phase 3] git show v6.1: pmc-quirks.c does NOT exist in v6.1 (not
  applicable to 6.1.y)
- [Phase 3] Author Mario Limonciello confirmed as subsystem author
  (copyright line, git log)
- [Phase 4] External sources (bugzilla, lore) blocked by Anubis — could
  not verify mailing list discussion directly
- [Phase 5] No functions modified — data-only change to static DMI table
- [Phase 6] v6.6 contains quirk_s2idle_bug with same structure; v6.12
  has 22 references — patch applicable
- [Phase 8] Failure mode: 10s resume delay on every s0i3 cycle, severity
  MEDIUM, frequently triggered
- UNVERIFIED: Could not access bugzilla #221273 to verify exact bug
  report details (blocked by Anubis), but commit metadata (Reported-by,
  Tested-by, Closes) is sufficient

**YES**

 drivers/platform/x86/amd/pmc/pmc-quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index ed285afaf9b0d..24506e3429430 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -203,6 +203,15 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "82XQ"),
 		}
 	},
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=221273 */
+	{
+		.ident = "Thinkpad L14 Gen3",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21C6"),
+		}
+	},
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/4434 */
 	{
 		.ident = "Lenovo Yoga 6 13ALC6",
-- 
2.53.0

