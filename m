Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADD5426D27;
	Tue, 28 Apr 2026 10:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372989; cv=none; b=Q0N1PmWComRQZd8NrromCVJoke0Od20t2uHRenlSbEaX+2XQqBHwsPcoyhATm6Sp0HfMx5+ky/ICXOz/8UHFjvPddCH/jajCjmZBA+yVnSCEMgpxRf7S9nmZswanqBvzDICjvtMbFHEm41Eku9n5pHEKqwr0GZZNdoVPL75NclY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372989; c=relaxed/simple;
	bh=bOGZzxn7Sj3EcN54zE9zeI6CWug8E/poxJX5+V2dZCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWQSyhqBpaE4iD4jNzn4N4PP7DGKG7lsuSqPw20n3MXIGZ0AU84sN7h1WYCAoqY5eifU6ki1vausRf0GcSBaePBPYW0GsOdbZetj1C764X5yQBT4AA0rgMIHF2ifxzS70PtkF8P9+cwFHBZTMDdiSiz3Edui01Hdd843yzWUU1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrxEST3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrxEST3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A392C2BCC6;
	Tue, 28 Apr 2026 10:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372989;
	bh=bOGZzxn7Sj3EcN54zE9zeI6CWug8E/poxJX5+V2dZCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrxEST3rhauO85XheMvUPfHHMryCv2qXwPGjDqJfnzkgtt27pDLWFqGhT8AT6vlIB
	 F9XKI2fqIiutPi4/TCcIfSTTOjA550juLb5CkQ4362+ICUFhZ9U9i2vJb9SYAXq/qo
	 gHw8unfE4jQ9IL1YD+TFCFVi8+Yc9mrHEG85zoyefNiGvanPiGkAUJujHxEr/eH09/
	 Naisg+GJbRbMOcicM5gRvK+V3z6SyT8jncQvKnS0FQg9Vi3bad5GTCa0CaXUJ5R1dz
	 Jtsy9VzgGJMvvVGpwj2eRvUaCo4d/YjQcs/q3QS5REt1jL2hTMajZ6bNLcZ8ZOps+7
	 XTA8lET8f3nOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krishna Chomal <krishna.chomal108@gmail.com>,
	Thomas Arici <absolute3d86@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hdegoede@redhat.com,
	markgross@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] platform/x86: hp-wmi: Add support for Omen 16-wf1xxx (8C77)
Date: Tue, 28 Apr 2026 06:41:17 -0400
Message-ID: <20260428104133.2858589-66-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit 344bf523d441d44c75c429ea6cdcfa8f12efde4d ]

The HP Omen 16-wf1xxx (board ID: 8C77) has the same WMI interface as
other Victus S boards, but requires quirks for correctly switching
thermal profile.

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_thermal_params.

Testing on board 8C77 confirmed that platform profile is registered
successfully and fan RPMs are readable and controllable.

Tested-by: Thomas Arici <absolute3d86@gmail.com>
Reported-by: Thomas Arici <absolute3d86@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221300
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260410191039.125659-5-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete my analysis.

## Phase 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line parsing**
- Record: Subsystem `platform/x86: hp-wmi:`, action verb `Add`, summary
  = adding DMI board ID quirk for HP Omen 16-wf1xxx board 8C77.

**Step 1.2: Commit message tags**
- Record:
  - `Reported-by: Thomas Arici <absolute3d86@gmail.com>` — real user
    reported the issue
  - `Tested-by: Thomas Arici <absolute3d86@gmail.com>` — tested by the
    reporter on actual hardware
  - `Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221300` —
    bugzilla report
  - `Link: https://patch.msgid.link/20260410191039.125659-5-...` — lore
    reference (PATCH v2 4/4)
  - `Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>` —
    subsystem maintainer reviewed
  - `Signed-off-by: Ilpo Järvinen` — same maintainer committed it
  - No Fixes:/Cc:stable (expected for this review)

**Step 1.3: Commit body analysis**
- Record: Body explains HP Omen 16-wf1xxx (board 8C77) uses the same WMI
  interface as other Victus S boards but needs thermal profile quirks.
  Without this entry, the laptop's platform profile won't register
  correctly and fan RPMs won't be readable/controllable. Tester
  confirmed platform profile registers and fan RPMs work after fix.

**Step 1.4: Hidden bug fix detection**
- Record: This isn't disguised; it's explicitly a quirk/device
  enablement for a specific laptop model. Per stable rules, DMI/device-
  ID/quirk additions to existing drivers are an EXCEPTION category
  that's allowed for stable.

## Phase 2: DIFF ANALYSIS

**Step 2.1: Change inventory**
- Record: One file changed — `drivers/platform/x86/hp/hp-wmi.c`, +4
  lines, -0 lines, single `dmi_system_id` entry added to
  `victus_s_thermal_profile_boards[]` table. Single-file surgical
  change.

**Step 2.2: Code flow change**
- Record: Before: board `8C77` was not in the DMI match table →
  `dmi_first_match()` in `setup_active_thermal_profile_params()`
  returned NULL → `is_victus_s_board` stayed false → thermal profile/fan
  quirk paths never activated. After: `8C77` matches →
  `is_victus_s_board=true`, `active_thermal_profile_params =
  omen_v1_thermal_params` → full thermal/fan support works.

**Step 2.3: Bug mechanism**
- Record: Hardware workaround (category h from checklist). Adds DMI
  match entry for a specific board, analogous to adding a PCI/USB ID or
  an entry to a DMI quirk table.

**Step 2.4: Fix quality**
- Record: Obviously correct - table entry inserted in sorted order
  between 8C76 and 8C78; driver_data points to `omen_v1_thermal_params`
  (same as sibling boards 8C76, 8C78). Zero risk to any board that
  doesn't match `8C77`; DMI match is exact-string, so no spillover.
  Tested by the hardware owner.

## Phase 3: GIT HISTORY INVESTIGATION

**Step 3.1: blame the changed lines**
- Record: The `victus_s_thermal_profile_boards[]` table was restructured
  to use `struct dmi_system_id` and `driver_data` in recent commits
  (appeared in the mainline around v6.18-era development). The table has
  been actively extended.

**Step 3.2: Fixes: tag follow-up**
- Record: No Fixes: tag (expected for hardware enablement; this is not a
  regression from a specific commit).

**Step 3.3: File history / series**
- Record: `git log -- drivers/platform/x86/hp/hp-wmi.c` shows a steady
  stream of similar board-ID additions: 8A4D, 8C76, 8BCA, 8E41,
  16-d0xxx, 16-wf0xxx, 16-xd0xxx, 16-wf1xxx fan support, etc. This
  commit is part of series "PATCH v2 0/4 platform/x86: hp-wmi: Improve
  support for some HP boards" but the 8C77 entry is self-contained.

**Step 3.4: Author's other commits**
- Record: Krishna Chomal is an active hp-wmi contributor (8C76 in Feb
  2026, 8BCA earlier, and now the 4/4 series in April 2026). Maintainer
  Ilpo Järvinen routinely reviews these.

**Step 3.5: Dependencies**
- Record: Self-contained. `omen_v1_thermal_params` already exists in
  stable trees (referenced by 8BCA, 8BCD, 8C78, etc.). No dependency on
  any sibling patch in the v2 series.

## Phase 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Find original patch discussion**
- Record: `b4 dig -c 344bf523d441d` found the submission at https://lore
  .kernel.org/all/20260410191039.125659-5-krishna.chomal108@gmail.com/ —
  this is PATCH v2 4/4 of the series "platform/x86: hp-wmi: Improve
  support for some HP boards".

**Step 4.2: Patch evolution**
- Record: `b4 dig -a` shows v1 (April 1, 2026) and v2 (April 11, 2026);
  the applied commit corresponds to v2, the latest revision. No dangling
  newer revision.

**Step 4.3: Recipients**
- Record: `b4 dig -w` shows patch was sent to Ilpo Järvinen
  (maintainer), Hans de Goede (maintainer), platform-
  driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, plus the
  reporter/tester Thomas Arici. Proper audience.

**Step 4.4: Thread contents**
- Record: Saved full thread to mbox; grep for
  "stable@|NAK|objection|regression|concern" showed none — no NAKs, no
  stable nominations, no concerns raised.

**Step 4.5: Bug report**
- Record: bugzilla.kernel.org/show_bug.cgi?id=221300 is referenced
  (Anubis protection prevented fetch content, but the Closes: tag
  confirms a real user-filed bug). Reporter is also the tester — real-
  world impact verified.

## Phase 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Key functions**
- Record: The only code affected is the
  `victus_s_thermal_profile_boards[]` table, consumed by
  `setup_active_thermal_profile_params()` (line 2605 of hp-wmi.c), which
  is invoked from `hp_wmi_init()`. On any board not named `8C77`,
  behavior is identical to before.

**Step 5.5: Similar patterns**
- Record: The table currently has 13 sibling entries (8A4D, 8BAB, 8BBE,
  8BCA, 8BCD, 8BD4, 8BD5, 8C76, 8C78, 8C99, 8C9C, 8D41, 8D87), each a
  4-line addition. Pattern is well-established.

## Phase 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Buggy code in stable?**
- Record:
  - `stable/linux-6.19.y`: `victus_s_thermal_profile_boards[]` is
    present with identical `struct dmi_system_id` format; 8C77 missing
    (as is 8C76). HP Omen 16-wf1xxx (8C77) owners running 6.19.y lack
    working thermal/fan support.
  - `stable/linux-6.18.y`: Same as 6.19.y — table format matches, 8C77
    missing.
  - `stable/linux-6.17.y`: Table exists but uses older string-only array
    format — would need trivial adaptation to backport.
  - `stable/linux-6.12.y`, `6.6.y`: Table doesn't exist — not
    applicable.

**Step 6.2: Backport complications**
- Record: For 6.18.y and 6.19.y the diff applies cleanly (modulo the
  absence of the 8C76 entry — the insertion point is just between 8BD5
  and 8C78 or wherever sorted order dictates). For 6.17.y would need
  format conversion. Difficulty: trivial.

**Step 6.3: Related fixes already in stable**
- Record: Multiple sibling commits (Add Omen 16-xd0xxx, Add Omen
  16-wf0xxx, fix platform profile values for Omen 16-wf1xxx, Add Omen
  MAX 16-ah0xx, Fn+P hotkey, Add Victus 16-d0xxx, Omen 14-fb1xxx, mark
  Victus 16-r0/s0) are already in `stable/linux-6.17.y`, `6.18.y`,
  and/or `6.19.y`. This establishes a clear precedent for backporting
  hp-wmi board-ID additions.

## Phase 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem criticality**
- Record: `drivers/platform/x86/hp/` — PERIPHERAL (driver-specific), but
  affects real users of HP Omen/Victus laptops. Fan control and thermal
  profile are user-visible features.

**Step 7.2: Activity**
- Record: Actively developed; maintainer routinely accepts board-ID
  additions.

## Phase 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
- Record: Owners of HP Omen 16-wf1xxx laptops with board 8C77.

**Step 8.2: Trigger conditions**
- Record: Triggered on every boot on matching hardware: thermal profile
  doesn't register, fan RPM readback/control unavailable. Not a security
  issue.

**Step 8.3: Failure mode**
- Record: Missing functionality (no thermal profile switching, no
  controllable fan) on the specific laptop model. Severity: MEDIUM
  (functional defect, not a crash/corruption).

**Step 8.4: Risk-benefit**
- Record:
  - Benefit: Enables working thermal/fan control for owners of a
    specific HP laptop model — a real user confirmed it fixes their
    system.
  - Risk: Near-zero. The change only runs on boards matching the exact
    DMI string `8C77`, which is currently a no-op entry. Cannot regress
    any other hardware. 4-line addition to a well-understood table.

## Phase 9: FINAL SYNTHESIS

**Step 9.1: Evidence compilation**

FOR:
- Pure hardware quirk/DMI match addition — a documented stable exception
  category
- 4-line change, surgical, no logic modification
- Tested on actual hardware by the reporter
- Reviewed and committed by subsystem maintainer
- Real user-facing bug (bugzilla 221300)
- Patchwork precedent: many similar hp-wmi board additions already in
  stable 6.17.y / 6.18.y / 6.19.y
- Zero regression risk (only activates on exact-string DMI match of
  "8C77")

AGAINST:
- The sibling 8C76 commit isn't yet in stable 6.19.y (easily resolved —
  8C77 can be inserted between 8BD5 and 8C78 on backport)
- Older stable branches (6.17.y, 6.12.y, 6.6.y) may need adaptation or
  the hardware is simply newer than the tree

**Step 9.2: Stable rules checklist**
1. Obviously correct & tested? YES (tested on hardware, maintainer-
   reviewed)
2. Fixes real bug affecting users? YES (user-reported via bugzilla)
3. Important issue? MEDIUM (broken fan/thermal on a specific laptop)
4. Small and contained? YES (4 lines, 1 file)
5. No new features/APIs? YES (no new API; DMI quirk addition, explicitly
   allowed)
6. Applies to stable trees? YES for 6.18.y/6.19.y cleanly; minor
   adaptation for 6.17.y

**Step 9.3: Exception category**
- Record: Matches the "QUIRKS and WORKAROUNDS" and "NEW DEVICE IDs"
  exception categories — adding DMI match entry to an existing driver's
  quirk table.

**Step 9.4: Decision**
- Record: Clear YES — stable-appropriate hardware enablement matching
  established backport precedent.

## Verification

- [Phase 1] Parsed tags: Reported-by/Tested-by same person (Thomas
  Arici), Closes: bugzilla 221300, Reviewed-by/SOB from maintainer Ilpo
  Järvinen. No Fixes:/Cc:stable (expected).
- [Phase 2] Diff: +4 lines, 1 file, a single `dmi_system_id` entry
  between `8C76` and `8C78`. Verified with `git show 344bf523d441d
  --stat`.
- [Phase 3] Author history: `git log` shows Krishna Chomal has authored
  similar additions (8C76, 8BCA). Verified via `git log --oneline --
  drivers/platform/x86/hp/hp-wmi.c`.
- [Phase 4] `b4 dig -c 344bf523d441d` found thread at lore.kernel.org/al
  l/20260410191039.125659-5-krishna.chomal108@gmail.com/
- [Phase 4] `b4 dig -a`: v1 (2026-04-01) → v2 (2026-04-11); applied
  version is v2 (latest).
- [Phase 4] `b4 dig -w`: maintainers Ilpo Järvinen, Hans de Goede, and
  platform-driver-x86 list were recipients.
- [Phase 4] `b4 dig -m /tmp/8c77_thread.mbox` + grep confirmed no NAK,
  no concerns, no stable nomination in thread.
- [Phase 5] `rg victus_s_thermal_profile_boards` in hp-wmi.c: referenced
  only at lines 184 (table) and 2613 (consumed in
  `setup_active_thermal_profile_params()`).
- [Phase 6] `git show stable/linux-6.18.y:drivers/platform/x86/hp/hp-
  wmi.c` and `stable/linux-6.19.y`: both have the `struct dmi_system_id`
  table format — backport applies cleanly. `stable/linux-6.17.y` uses
  older string-array format — needs trivial adaptation.
- [Phase 6] `git log stable/linux-6.18.y -- drivers/platform/x86/hp/hp-
  wmi.c`: many sibling hp-wmi board additions are already backported
  (Fn+P, 16-wf0xxx, 16-xd0xxx, 16-ah0xx, fix platform profile values,
  Victus 16-r0/s0, Victus 16-r1, etc.).
- [Phase 8] Failure mode: confirmed via reading
  `setup_active_thermal_profile_params()` at lines 2605-2627 — without a
  match, `is_victus_s_board` stays false and
  `active_thermal_profile_params` is NULL, disabling thermal/fan
  functionality.
- UNVERIFIED: bugzilla.kernel.org/show_bug.cgi?id=221300 content (Anubis
  protection blocked WebFetch); Closes: tag and Reported-by/Tested-by
  confirm the bug is real.
- UNVERIFIED: Whether the sibling 8C76 commit is already queued for
  autosel in 6.19.y (doesn't affect this commit's decision — 8C77 can be
  applied independently).

The change is a textbook hardware-quirk / DMI match-table addition,
which is one of the explicit stable exception categories. It is tiny,
maintainer-reviewed, user-tested, has zero collateral risk, and follows
a strong precedent of similar hp-wmi board-enablement commits already
accepted in stable trees.

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 988a0acc9622b..c1dcc1e9038b7 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -214,6 +214,10 @@ static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8C76") },
 		.driver_data = (void *)&omen_v1_thermal_params,
 	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8C77") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8C78") },
 		.driver_data = (void *)&omen_v1_thermal_params,
-- 
2.53.0

