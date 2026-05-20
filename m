Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522C53FB06C;
	Wed, 20 May 2026 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276066; cv=none; b=SVhBmm14Cjcielq65D+eheFs+KZdPMCf5gh9unZwA6r534eCtWS1LOoOCs21CSo0iSRliSjy5kSdedH1WTYBZ2lRdxaV78wmlZsS9CjqDvNHCxKjdn3u5K+vpWnMQUfZuq4XKq9pCnfNXQ0XtOqt1bPT+TfaQcOSFjT8ZO3jeWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276066; c=relaxed/simple;
	bh=aBw/JHFYhHY3TKJTHkxIi2GJB2S8Gem6EkJEPylpgYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bgr/2p/pr5MluwHYtoJwFwr5RqXSqm1pkRVgRt0C4GP83m+HRn771OMgOeeYgujUYNgUe/iXklokp+8JDYkG9G7asegrv/LbGCsVmwHD6A0oIxkqxft8pWvPQwxG3syYEAMrs2bk5a6uhB8mLkNDaXNuZURT9Mdi/3v57aFi5sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kroGMQ/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kroGMQ/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6491F00896;
	Wed, 20 May 2026 11:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276064;
	bh=GwHoWjI1bbJdJ2rnXbFba5rnxllSqbduAn8eFQS1hQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kroGMQ/5N3QyVhlB8lxkRDc0UtSq4ht6CaL3pu8NZGAFGPiRVArJ2+loQu/9L4I9c
	 pyWbeU7ianoLzlC9lkT8hZ13GaZIHe0Qao4PC2rbK0d3/3qGjvDr940Axcx7Fvj4cH
	 D/mhpQPeqPPtorX9kDk9SKB7nQN7nAH3aDwWbgiWnwbKLOgp2Yo04sEBFW4+mqdWdM
	 t0eDbOx5vOcfbAYHvfGXOPkfNTLaP2Vrpm0PIRuqdHL2kEAW4Qq7YKCBcMtllrjTA3
	 4SBdqzuPDsfSm2KtYMO0eeCahikrc/v8gOe+OKs7nC1HRqm+tIDggPJ6eUNrWz8Gj7
	 eX8jta7vy+cjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haichen Feng <2806891994@qq.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] platform/x86: hp-wmi: Add support for Victus 16-r0xxx (8BC2)
Date: Wed, 20 May 2026 07:19:28 -0400
Message-ID: <20260520111944.3424570-56-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Haichen Feng <2806891994@qq.com>

[ Upstream commit a59e45221df82e8a6246c617615c1ccc12e3545d ]

The HP Victus 16-r0xxx (board ID: 8BC2) has the same WMI as other Victus
S boards, but requires quirks for correctly switching thermal profile.

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_thermal_params.

Testing on board 8BC2 confirmed that platform profile is registered
successfully and fan RPMs are readable and controllable.

Signed-off-by: Haichen Feng <2806891994@qq.com>
Link: https://patch.msgid.link/tencent_8E29805D8DC7B6005244C3433C62DD9DF606@qq.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
### Phase 1: Commit Message Forensics
Record: Subsystem is `platform/x86: hp-wmi`; action verb is `Add
support`; intent is a DMI hardware quirk for HP Victus 16-r0xxx board
`8BC2`.

Record: Tags found: `Signed-off-by: Haichen Feng`, `Link: https://patch.
msgid.link/tencent_8E29805D8DC7B6005244C3433C62DD9DF606@qq.com`,
`Reviewed-by: Ilpo Järvinen`, `Signed-off-by: Ilpo Järvinen`. No
`Fixes:`, `Reported-by:`, `Tested-by:`, or `Cc: stable`.

Record: Body says board `8BC2` has the same WMI behavior as other Victus
S boards but needs quirks for correct thermal profile switching. The
author reports testing on board `8BC2`: platform profile registered, fan
RPMs readable and controllable.

Record: This is a hardware quirk / DMI board enablement, not a hidden
memory-safety bug.

### Phase 2: Diff Analysis
Record: One file changed: `drivers/platform/x86/hp/hp-wmi.c`, 4
insertions. Modified object: `victus_s_thermal_profile_boards[]`. Scope:
single-file surgical DMI table addition.

Record: Before: `8BC2` did not match
`victus_s_thermal_profile_boards[]`. After: `8BC2` matches and gets
`.driver_data = &omen_v1_thermal_params`.

Record: Bug category is hardware workaround / DMI quirk. Mechanism:
`setup_active_thermal_profile_params()` uses `dmi_first_match()` on this
table, sets `is_victus_s_board = true`, and selects board-specific
thermal parameters. Without the entry, the Victus S-specific platform
profile and hwmon fan paths are not selected for this board.

Record: Fix quality is high: 4-line table entry, no API change, no
locking/memory lifetime change. Regression risk is very low and limited
to machines whose DMI board name is exactly `8BC2`.

### Phase 3: Git History Investigation
Record: `git blame` around the table shows the DMI table/refactor came
from `8ca7515d3c76` and nearby board entries came from prior hp-wmi
board-support commits. `git grep` against the candidate parent found no
existing `8BC2` entry.

Record: No `Fixes:` tag, so no introducing commit to follow.

Record: Recent file history shows many similar hp-wmi board additions
and fixes, including `8BCA`, `8C76`, `8A4D`, and Victus S support
commits. The candidate is standalone relative to its parent.

Record: `git log --author='Haichen Feng'` found no prior local hp-wmi
commits. The patch was reviewed and committed by Ilpo Järvinen, who also
appears in hp-wmi history.

Record: Dependency: the exact patch expects the `dmi_system_id` table
with `driver_data` and `omen_v1_thermal_params`. That exists in
`v7.0`/`v7.0.9`; older `v6.18`/`v6.19` have an older string table, and
`v6.12` and older checked tags did not show this Victus S table.

### Phase 4: Mailing List And External Research
Record: `b4 dig -c a59e45221df82e8a6246c617615c1ccc12e3545d` found the
original patch at the provided message-id URL.

Record: `b4 dig -C -a` found revisions v1, v2, and v4. Review history
shows v1 was asked to place `8BC2` in sorted order, v3/v4 discussion
asked for a proper commit message and a new thread for b4 tooling. The
standalone v4 was accepted by Ilpo, with applied commit
`a59e45221df82e8a6246c617615c1ccc12e3545d`.

Record: `b4 dig -w` showed the patch went to Haichen Feng, Ilpo
Järvinen, Hans de Goede, `linux-kernel`, and `platform-driver-x86`.

Record: No stable-specific request or rejection was found. `WebFetch`
for lore search pages was blocked by Anubis, so stable-list search via
web is unverified.

### Phase 5: Code Semantic Analysis
Record: Key functions affected indirectly:
`setup_active_thermal_profile_params()`,
`is_victus_s_thermal_profile()`, `thermal_profile_setup()`,
`platform_profile_victus_s_set_ec()`, and hwmon fan handlers.

Record: Callers: `hp_wmi_init()` calls
`setup_active_thermal_profile_params()` before probing; platform profile
and hwmon callbacks use `is_victus_s_thermal_profile()` to choose Victus
S behavior.

Record: Callees include `dmi_first_match()`, `ec_read()`,
`hp_wmi_perform_query()`, and `devm_platform_profile_register()`.

Record: Reachability: the path is reached during hp-wmi module
init/probe and through user-visible platform profile and hwmon
operations after registration. Impact is board-specific, not universal.

Record: Similar patterns exist in the same table: `8BCA`, `8BCD`,
`8C76`, and `8C78` map to `omen_v1_thermal_params`.

### Phase 6: Cross-Referencing And Stable Tree Analysis
Record: Checked tags: `v7.0` and `v7.0.9` contain the required struct
DMI table and lack `8BC2`; `v6.18`/`v6.19` contain an older string-table
Victus S implementation; `v6.12`, `v6.6`, `v6.1`, `v5.15`, and `v5.10`
did not show the same target code.

Record: `git apply --check` of the candidate diff succeeded on current
`v7.0.9`, so expected backport difficulty for `7.0.y` is clean. Older
trees would need either prerequisites or a different backport, and the
exact tested `omen_v1_thermal_params` mapping is not directly applicable
to the older string table.

Record: No related stable alternative fix for `8BC2` was found in
checked local history.

### Phase 7: Subsystem And Maintainer Context
Record: Subsystem is `drivers/platform/x86/hp`, a platform/laptop driver
subsystem. Criticality is peripheral but user-visible for affected HP
hardware.

Record: File history is active, with multiple recent hp-wmi board quirks
and fixes. The review/commit path involved Ilpo Järvinen from the
platform-drivers-x86 maintainership path.

### Phase 8: Impact And Risk Assessment
Record: Affected population is users of HP Victus 16-r0xxx board `8BC2`
with hp-wmi enabled.

Record: Trigger condition is boot/probe and subsequent platform profile
or hwmon fan use on that exact DMI board. Unprivileged triggerability
beyond ordinary sysfs exposure was not established and is not needed for
this decision.

Record: Failure mode is missing/incorrect platform profile and fan
control support on affected hardware, not a crash/corruption bug.
Severity is medium for affected users.

Record: Benefit is high for affected hardware because it enables tested
thermal profile/fan behavior. Risk is very low because the change is a
single exact DMI match.

### Phase 9: Final Synthesis
Record: Evidence for backporting: it is a hardware-specific DMI quirk,
explicitly tested on the target board by the submitter, reviewed/applied
by the subsystem maintainer path, and only affects board `8BC2`.

Record: Evidence against: it is hardware enablement rather than a
crash/security/data-corruption fix, and older stable trees may not have
the exact prerequisite table structure.

Record: Stable rules: obviously correct yes; fixes a real board support
problem yes; important enough under the hardware quirk exception yes;
small and contained yes; no new API yes; clean apply verified for
`v7.0.9`, older applicability requires tree-specific handling.

Record: Exception category applies: hardware quirk / DMI board entry to
an existing driver.

## Verification
- [Phase 1] `git show a59e45221df82...` confirmed subject, tags, 4-line
  diff, and commit body.
- [Phase 2] Diff confirmed only `victus_s_thermal_profile_boards[]` is
  changed.
- [Phase 3] `git blame` and `git log` verified table history and related
  hp-wmi board entries.
- [Phase 4] `b4 dig`, `b4 mbox`, and local mbox reads verified review
  history, v1/v2/v4 revisions, maintainer feedback, and final
  acceptance.
- [Phase 5] `rg`/file reads verified the DMI table drives Victus S
  platform profile and hwmon fan code paths.
- [Phase 6] tag checks verified exact applicability to `v7.0.y` and
  structural mismatch in older checked trees.
- [Phase 8] Impact/risk is based on exact DMI matching and code-path
  inspection.
- UNVERIFIED: lore stable search pages via `WebFetch` were blocked by
  Anubis; no independent hardware test was performed here beyond the
  author’s commit-message report.

This should be backported to stable trees that contain the matching hp-
wmi DMI table infrastructure, especially `7.0.y`. It is the classic
stable-acceptable hardware quirk: tiny, reviewed, board-specific, and
low risk.

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 62fd2fe0d8d0e..71e0100455d9a 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -194,6 +194,10 @@ static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BBE") },
 		.driver_data = (void *)&victus_s_thermal_params,
 	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BC2") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BCA") },
 		.driver_data = (void *)&omen_v1_thermal_params,
-- 
2.53.0

