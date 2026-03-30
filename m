Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8031A3D16E5;
	Mon, 30 Mar 2026 12:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874338; cv=none; b=QXArrhZWLTuxPKCIhTKKmGoTVFlVT7m1nCKzxEu/bJ+Ch1UCESW2L1NEmW7XSdV0uIde40AxT0m6Q7EjqyXtMA+gq+TWpTDMUstcl0kS5Z0e9/3kOvBbY/YpASyYJrq66t7BucFzdTixWVr+CQ4GwYGcQOUFQmSGy5i8297S13E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874338; c=relaxed/simple;
	bh=lNnTyxFDuhsw1+MjDWI7JngK4wScW9vg6MGq567ugdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tSM2KMmiQeUcy6vMJXdFeoQ4g+MWzSQ6Kl9Tt5VNICVt6LsersKxF9flsGI/9IOvvbTRZPJkqgK6EboJB8FsM+m6imwXiEFBr4vkfGj4Sk8HtQBAs3vf9wn+GcBrqLAxsmzkPwmhETWIudMvvkahLVDXLFlmHnC/a2Pcjn21Ucw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RetctO0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RetctO0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23800C4CEF7;
	Mon, 30 Mar 2026 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874336;
	bh=lNnTyxFDuhsw1+MjDWI7JngK4wScW9vg6MGq567ugdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RetctO0lb+4wCIK/U6HgjCAFpaGaGZmFl8uCwM6mYXnrt/2oRtCE8iQBplCiOXAxn
	 HmtbSB2uhwB+QjKVbP/100l59pe9ZC1t9KRlkwHvnrOl9w+8NQistaZwqa20V9Njs+
	 RSyA4mm0D54a2FLB258Rf49Lm/LCLs6s//DfJ4sXMM/kVTT0418/IHB816YYS/epwb
	 47ciGxupouslCkT+DdQo40o/avRJpMiUDr4YYqyeqJEhju2o/nhP9gJ/OWONMpocTD
	 MwQ2QzHbF300kw5vYLwqDOEEqUQpZ3ABQHVLVDnuiNukUw0gAWayM4JMN4qg0QBOJ5
	 FjAAX2PxWxT/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krishna Chomal <krishna.chomal108@gmail.com>,
	WJ Enderlava <jie7172585@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] platform/x86: hp-wmi: Add support for Omen 16-wf1xxx (8C76)
Date: Mon, 30 Mar 2026 08:38:22 -0400
Message-ID: <20260330123842.756154-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Transfer-Encoding: 8bit

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit 84d29bfd1929d08f092851162a3d055a2134d043 ]

The HP Omen 16-wf1xxx (board ID: 8C76) has the same WMI interface as
other Victus S boards, but requires quirks for correctly switching
thermal profile (similar to board 8C78).

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_thermal_params.

Testing on board 8C76 confirmed that platform profile is registered
successfully and fan RPMs are readable and controllable.

Tested-by: WJ Enderlava <jie7172585@gmail.com>
Reported-by: WJ Enderlava <jie7172585@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221149
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260227154106.226809-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the data needed for the comprehensive analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [platform/x86: hp-wmi] [Add] [DMI board name 8C76 to Victus S
thermal profile table, mapped to omen_v1_thermal_params]

**Step 1.2: Tags**
Record:
- `Tested-by: WJ Enderlava <jie7172585@gmail.com>` — real user tested on
  hardware
- `Reported-by: WJ Enderlava <jie7172585@gmail.com>` — single reporter,
  real hardware user
- `Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221149` — user-
  filed bugzilla
- `Signed-off-by: Krishna Chomal` — author
- `Link: https://patch.msgid.link/20260227154106.226809-1-
  krishna.chomal108@gmail.com`
- `Reviewed-by: Ilpo Järvinen` — subsystem maintainer reviewed
- `Signed-off-by: Ilpo Järvinen` — maintainer committed
- No `Fixes:` tag (expected for manual review candidates)
- No `Cc: stable` (expected)
- No syzbot involvement

**Step 1.3: Body Text**
Record: Bug: Board 8C76 (HP Omen 16-wf1xxx) has the same WMI interface
as Victus S boards but requires quirks for correct thermal profile
switching (similar to 8C78). Symptom: without the entry, the board
cannot register the platform profile and fan RPMs are not
readable/controllable. Testing confirmed on real hardware that profile
registers and fans work after the fix. Root cause: missing DMI board
name in the quirk table.

**Step 1.4: Hidden Bug Fix Detection**
Record: Yes — phrased as "Add support" but this is a hardware-specific
DMI quirk. Without this entry, the board does not get routed into the
correct thermal handling path, meaning no platform profile registration
and no fan control. This is functionally a bug fix for users of this
specific hardware.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: 1 file changed: `drivers/platform/x86/hp/hp-wmi.c`, +4 lines, 0
removed. Single table entry added to
`victus_s_thermal_profile_boards[]`. Scope: single-file, surgical, data-
only change.

**Step 2.2: Code Flow Change**
Record: Before: board "8C76" is not in
`victus_s_thermal_profile_boards[]`, so `dmi_first_match()` in
`setup_active_thermal_profile_params()` does not match it;
`is_victus_s_board` stays false; thermal profile, fan, and power-source
handling all skip the Victus S path. After: "8C76" matches,
`driver_data` = `&omen_v1_thermal_params` (same as "8C78"), enabling the
full Victus S / Omen v1 code path.

**Step 2.3: Bug Mechanism**
Record: Category: Hardware workaround / DMI match table entry. Specific
mechanism: missing board name in DMI quirk table causes incorrect
thermal profile handling for this laptop SKU.

**Step 2.4: Fix Quality**
Record: Obviously correct — identical pattern to adjacent "8C78" entry.
Minimal and surgical (4 lines). Zero regression risk: only activates on
exact DMI board name "8C76". No API or ABI changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Record: `git blame -L 162,191` shows the entire
`victus_s_thermal_profile_boards[]` table (in its `dmi_system_id` form
with `driver_data`) was created by commit `e7cbd37292653` ("fix platform
profile values for Omen 16-wf1xxx", Krishna Chomal, 2026-01-13). The
table structure/`};` terminator originates from `6e4ab59b8391a` (Julien
Robin, 2025-01-16, original Victus S support).

**Step 3.2: Fixes: tag**
Record: N/A — no Fixes: tag present (expected for manual review). The
related prerequisite `e7cbd37292653` itself has `Fixes: fb146a38cb119`.

**Step 3.3: File History**
Record: Recent `hp-wmi.c` history shows: `e7cbd37292653` (per-board
thermal params refactor), `68779adbabdbb` (DMI ordering),
`fa0498f804753` (Omen MAX 16-ah0xx), `fb146a38cb119` (Omen 16-wf1xxx fan
support), `54afb047cd7eb` (Victus 16-r/s). This is a standalone single-
patch addition, not part of a numbered series.

**Step 3.4: Author**
Record: Krishna Chomal has 2 prior commits in
`drivers/platform/x86/hp/`: `fb146a38cb119` (Add Omen 16-wf1xxx fan
support) and `e7cbd37292653` (fix platform profile values for Omen
16-wf1xxx). Author is the original contributor for this specific
hardware support. Reviewed and committed by subsystem maintainer Ilpo
Järvinen.

**Step 3.5: Dependencies**
Record: This patch requires the `dmi_system_id` table format with
`driver_data` pointing to `struct thermal_profile_params`, introduced by
`e7cbd37292653`. It also requires `omen_v1_thermal_params` to be defined
(also from `e7cbd37292653`). Verified: `e7cbd37292653` is contained in
`v6.19.4~320`; `fb146a38cb119` is contained in `v6.18-rc7~24^2~18`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1–4.4:**
Record: WebFetch attempts to lore.kernel.org, patch.msgid.link, and
bugzilla.kernel.org were blocked by Anubis bot protection. Could not
independently verify the mailing list discussion or bugzilla details.
The commit tags (Reported-by, Tested-by, Reviewed-by, Closes:) provide
the evidence trail. UNVERIFIED: exact bugzilla content and mailing list
discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions in Diff**
Record: No function bodies modified. Data change only: one entry added
to `victus_s_thermal_profile_boards[]`.

**Step 5.2: Callers**
Record: Verified via grep: `victus_s_thermal_profile_boards` is consumed
by `setup_active_thermal_profile_params()` (line 2288), which calls
`dmi_first_match()` on this table. On match, it sets `is_victus_s_board
= true` and `active_thermal_profile_params = id->driver_data`.

**Step 5.3: Callees / Impact Surface**
Record: `is_victus_s_thermal_profile()` (line 1634) returns
`is_victus_s_board`. This function gates behavior in:
- `hp_wmi_platform_profile_probe()` — platform profile registration
  (line 1809, 2009)
- `hp_wmi_hwmon_is_visible()` — fan sysfs visibility (line 2169)
- `hp_wmi_hwmon_read()` — fan speed reading (line 2191)
- `hp_wmi_hwmon_write()` — fan speed control (lines 2227, 2233)
- `hp_wmi_init()` — power source event handler registration (line 2341)
- `hp_wmi_exit()` — cleanup (line 2364)

**Step 5.4: Reachability**
Record: Init path: `hp_wmi_init()` →
`setup_active_thermal_profile_params()` → `platform_driver_probe()` →
`hp_wmi_bios_setup()` → `thermal_profile_setup()`. This runs on every
boot/module load on affected hardware. Hwmon paths are userspace-
reachable via sysfs.

**Step 5.5: Similar Patterns**
Record: The table already contains identical patterns: "8C78" →
`&omen_v1_thermal_params`, "8BCA" → `&omen_v1_thermal_params`, "8BCD" →
`&omen_v1_thermal_params`. This is a routine board-ID addition.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Existence in Stable Trees**
Record: Verified via `git grep`:
- **pending-6.6, pending-6.12, pending-6.14**:
  `victus_s_thermal_profile_boards` NOT found. Not applicable.
- **pending-6.17**: Table exists (3 references) but uses the OLD string-
  list format. `omen_v1_thermal_params` and `struct
  thermal_profile_params` do NOT exist. Patch cannot apply.
- **pending-6.18**: Table exists in NEW `dmi_system_id` format.
  `omen_v1_thermal_params` exists. "8C76" NOT yet present. Patch applies
  cleanly.
- **pending-6.19**: Table exists in NEW `dmi_system_id` format.
  `omen_v1_thermal_params` exists. "8C76" NOT yet present. Patch applies
  cleanly.

**Step 6.2: Backport Complications**
Record: Clean apply for `6.18.y` and `6.19.y`. Not standalone for
`6.17.y` (would need the full `e7cbd37292653` refactor first). Not
applicable to `6.14.y` and older.

**Step 6.3: Related Fixes Already in Stable**
Record: No alternate "8C76" fix found in any checked branch.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
Record: `drivers/platform/x86/hp/` — HP laptop WMI driver. Criticality:
PERIPHERAL (specific HP laptop hardware). However, HP Omen/Victus is a
popular consumer laptop line.

**Step 7.2: Activity**
Record: Actively maintained — 20 recent commits show ongoing thermal/fan
work for various HP laptop models.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Record: Platform-specific: users of HP Omen 16-wf1xxx laptops with DMI
board name "8C76".

**Step 8.2: Trigger Conditions**
Record: Triggered every boot on affected hardware. DMI matching is init-
time, and the resulting behavior affects all platform-profile and fan-
control operations for the life of the session.

**Step 8.3: Failure Mode Severity**
Record: Without the fix: no platform profile registration, fan RPMs not
readable/controllable via the Victus S path, and power-source event
handling not set up for this board. Severity: MEDIUM — hardware
functionality (thermal management, fan control) is missing but no crash,
corruption, or security issue.

**Step 8.4: Risk-Benefit Ratio**
Record: Benefit: HIGH for affected users — restores correct thermal
profile switching and fan control on their laptop. Risk: VERY LOW —
4-line data-only change scoped to a single DMI board name match, cannot
affect any other hardware. Ratio: strongly favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
FOR backporting:
- Classic hardware quirk / DMI board ID addition (explicit stable
  exception category)
- Only 4 lines, data-only change, zero regression risk
- Reported-by and Tested-by from real user on real hardware
- Reviewed-by subsystem maintainer (Ilpo Järvinen)
- Bugzilla bug report (221149) filed
- Identical pattern to existing adjacent entries (8C78, 8BCA, 8BCD)
- Prerequisites already present in pending-6.18 and pending-6.19

AGAINST backporting:
- Not a crash/security/corruption fix — hardware enablement for missing
  fan/thermal control
- Narrow impact (single laptop model)
- Only applicable to 6.18.y and 6.19.y; 6.17.y needs prerequisite
  refactor

UNRESOLVED:
- Bugzilla 221149 content not fetchable (Anubis blocked)
- Lore mailing list discussion not fetchable (Anubis blocked)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — identical pattern to existing
   entries, Tested-by from hardware owner
2. Fixes a real bug? **YES** — missing quirk prevents thermal/fan
   control on real hardware
3. Important issue? **YES** under the hardware quirk exception — enables
   hardware functionality
4. Small and contained? **YES** — 4 lines, single table entry, one file
5. No new features or APIs? **YES** — extends existing quirk table with
   a board name
6. Can apply to stable? **YES** — cleanly on 6.18.y and 6.19.y

**Step 9.3: Exception Categories**
Record: This falls squarely into **QUIRKS and WORKAROUNDS** — a DMI
board name addition to an existing driver's quirk table. This is the
same category as USB quirks, PCI quirks, and audio codec quirks that are
explicitly allowed in stable.

**Step 9.4: Decision**
This is a textbook hardware quirk addition: a 4-line DMI table entry
that enables correct thermal profile switching and fan control for a
specific HP laptop model, using existing driver infrastructure. It
carries essentially zero regression risk and provides concrete benefit
to real users of this hardware. It should be backported to stable
branches that have the per-board thermal parameter infrastructure
(6.18.y and 6.19.y).

---

## Verification

- [Phase 1] Parsed all tags from commit message: Tested-by, Reported-by,
  Closes (bugzilla 221149), Reviewed-by (Ilpo Järvinen), Link, Signed-
  off-by x2
- [Phase 2] Diff analysis: +4 lines adding single DMI entry `{
  DMI_MATCH(DMI_BOARD_NAME, "8C76"), .driver_data = (void
  *)&omen_v1_thermal_params }`
- [Phase 3] `git blame -L 162,191`: confirmed table created by
  `e7cbd37292653` (Krishna Chomal, 2026-01-13), structure from
  `6e4ab59b8391a` (2025-01-16)
- [Phase 3] `git show e7cbd37292653`: confirmed this is the prerequisite
  commit that refactored the table to `dmi_system_id` format with per-
  board `thermal_profile_params`
- [Phase 3] `git describe --contains e7cbd37292653` → `v6.19.4~320`:
  prerequisite is in v6.19.4
- [Phase 3] `git describe --contains fb146a38cb119` →
  `v6.18-rc7~24^2~18`: original Omen 16-wf1xxx support is in v6.18
- [Phase 3] `git log --author="Krishna Chomal"`: confirmed 2 prior
  commits to hp-wmi.c
- [Phase 4] WebFetch to lore/bugzilla blocked by Anubis — UNVERIFIED:
  exact discussion and bug details
- [Phase 5] `grep` for `victus_s_thermal_profile_boards`: confirmed
  consumed by `setup_active_thermal_profile_params()` at line 2288 via
  `dmi_first_match()`
- [Phase 5] `grep` for `is_victus_s_thermal_profile`: confirmed it gates
  platform profile (lines 1809, 2009), hwmon visibility/read/write
  (lines 2169, 2191, 2227, 2233), init power source handler (line 2341),
  exit cleanup (line 2364)
- [Phase 6] `git grep victus_s_thermal_profile_boards` on all pending
  branches: NOT in 6.6/6.12/6.14; present in 6.17/6.18/6.19
- [Phase 6] `git grep omen_v1_thermal_params` on pending-6.17: NOT FOUND
  — old string-list format, patch cannot apply standalone
- [Phase 6] `git grep omen_v1_thermal_params` on pending-6.18: FOUND
  (lines 92-114, 159, 167, 179) — full infrastructure present
- [Phase 6] `git grep omen_v1_thermal_params` on pending-6.19: FOUND
  (lines 92-114, 167, 175, 187) — full infrastructure present
- [Phase 6] `git grep '8C76'` on pending-6.18 and pending-6.19: NOT
  FOUND — patch not yet applied to any stable branch
- [Phase 8] Failure mode: missing thermal profile/fan control on
  specific HP Omen laptop; severity MEDIUM (hardware functionality, not
  crash/security)
- UNVERIFIED: exact bugzilla 221149 content and severity rating
- UNVERIFIED: exact mailing list reviewer comments beyond tags in commit

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 24d065ddfc6ae..9c1bdf8e7b283 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -172,6 +172,10 @@ static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BD5") },
 		.driver_data = (void *)&victus_s_thermal_params,
 	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8C76") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8C78") },
 		.driver_data = (void *)&omen_v1_thermal_params,
-- 
2.53.0

