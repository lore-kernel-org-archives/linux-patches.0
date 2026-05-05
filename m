Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6003E31E82B;
	Tue,  5 May 2026 09:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974746; cv=none; b=qwzLC24xayEXEF5Tl+7QgeFgSC7cThTYcCJ+frVgtgHY3yRIsEWQiPUvJzPM2825w6dv90FX2sLmOkIgiTPF0CGWi47buYtjW1Vj2H5bFOSs7DgAx4aR75StzqSQiPjx62mUi4guRRo3jk4IpiDYgWxzHMrNHkfw9OIixbv3FbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974746; c=relaxed/simple;
	bh=f84Y5TVEmr22zCYb60Nse16esybFpQ0wAWR5ZZ0YvII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jl+S0Rscme5diB3WGk1EtF5HmnIpGT5OLMsCPtJB9welYuqbaqRbKGO16uKdNiDDB3CF5GlO4InBU2HOa/WmbmphYOYQekByHL/y/FyhxgVZvaAHXrFio1wHduu8qFho6JX7ORP+SymU/Z5jbcvkIhwznWPBMCoh/6HiyZYsjrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTX1SJr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTX1SJr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA7AC2BCC9;
	Tue,  5 May 2026 09:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974746;
	bh=f84Y5TVEmr22zCYb60Nse16esybFpQ0wAWR5ZZ0YvII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTX1SJr2CoLRi6IleF5y9HaaFvRpvc5hvxF8tM5TR/7hzjXeuEPfc6RBF6qey3oWL
	 eUQ/H/3ovOx6HUUt9Lxn74iyWSf31boG1aboFDneOBYPmB1u/hQMCF4rsm+On5ZreJ
	 W+AtBaToSES1byN3zXcsZXJKGLbTMq/WVlIA7DEaKzTmmRHqfYz9vKhixmHyea2h56
	 h5C4mClYzTMBVjjxXVNOWk8oAXkl61eojIv8ZstytXfTOi/ihZk1GZluparu5QAcE/
	 iVE7L1VjKHYmEHXROr7kGPMUii+c2WwSWyhdKxec6spAYIo/MowdWOrdl/WnThEX4I
	 rCAPGI+UaC3YA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosalie Wanders <rosalie@mailbox.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ALSA: usb-audio: apply quirk for Playstation PDP Riffmaster
Date: Tue,  5 May 2026 05:51:27 -0400
Message-ID: <20260505095149.512052-11-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rosalie Wanders <rosalie@mailbox.org>

[ Upstream commit 110189f0268d0eb85895721526328cac5804a739 ]

This device, just like the Playstation 5's DualSense, has a volume
that's too low, hid-playstation solves this by raising the minimum
volume on the device itself by sending an output report, third party PS5
controllers/accessories do not support this output report format, so we
apply a quirk to raise the minimum volume by 6dB.

Signed-off-by: Rosalie Wanders <rosalie@mailbox.org>
Link: https://patch.msgid.link/20260426025520.3985-2-rosalie@mailbox.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem is `ALSA: usb-audio`; action verb is `apply`;
intent is to add a device-specific volume quirk for PlayStation PDP
Riffmaster controllers/accessories.

Step 1.2 Record: Tags present are:
- `Signed-off-by: Rosalie Wanders <rosalie@mailbox.org>`
- `Link:
  https://patch.msgid.link/20260426025520.3985-2-rosalie@mailbox.org`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>`
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`,
or `Cc: stable@vger.kernel.org` tags were present.

Step 1.3 Record: The commit says the PDP Riffmaster has too-low volume,
similar to the PS5 DualSense. It states `hid-playstation` compensates
for DualSense by sending an output report, but third-party PS5
controllers/accessories do not support that output report format, so
this patch raises the ALSA minimum volume by 6 dB. Symptom is functional
audio output being too quiet on this hardware. No affected kernel
version is stated.

Step 1.4 Record: This is not hidden as cleanup; it is explicitly a
hardware quirk/workaround. It fixes a device-specific functional
problem, not a crash, memory safety issue, or data corruption issue.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `sound/usb/mixer.c`, with 10
insertions and no removals. One function changed:
`volume_control_quirks()`. Scope is a single-file, single-switch-entry
hardware quirk.

Step 2.2 Record: Before, PDP Riffmaster USB IDs had no special handling,
so the device-reported volume range was used as-is. After, for USB IDs
`0x0e6f:0x024a` and `0x0e6f:0x0249`, if the ALSA control name is `PCM
Playback Volume`, the code logs the quirk and sets `cval->min = -2560`.

Step 2.3 Record: Bug category is hardware workaround / device-specific
USB-audio volume quirk. The mechanism is correcting the exposed minimum
playback-volume value before ALSA dB conversion and control
registration.

Step 2.4 Record: Fix quality is high: tiny, isolated, matches existing
nearby patterns for device-specific volume quirks, changes no API, and
is gated by exact USB IDs plus exact control name. Regression risk is
very low and limited to the two PDP Riffmaster IDs.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows `volume_control_quirks()` was
introduced by `dcaaf9f2c16b56` and is present since `v3.2-rc2~23^2~3`.
The immediate insertion context includes the Asus USB DAC quirk from
`4020d1ccbe55bd` (`v5.7~16^2~2`) and, on newer branches, MOONDROP
quirks. For this commit, the “buggy code” is effectively the absence of
a quirk for this hardware, not a bad prior line.

Step 3.2 Record: No `Fixes:` tag is present, so there is no introducing
commit to follow.

Step 3.3 Record: Recent `sound/usb/mixer.c` history contains multiple
related USB-audio volume/control fixes and quirks, including MOONDROP,
Huawei, MS LifeChat, and volume-range checking work. No prerequisite
commit was identified for the Riffmaster quirk itself.

Step 3.4 Record: `git log --author='Rosalie Wanders'` under `sound/usb`
found this one sound commit. The patch was committed by Takashi Iwai,
and `MAINTAINERS` lists Takashi Iwai and Jaroslav Kysela as `SOUND`
maintainers.

Step 3.5 Record: No functional dependencies found. The code assumes only
existing `USB_ID()` matching and `volume_control_quirks()`
infrastructure. Backport may need minor contextual placement on some
branches.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 110189f0268d0` found the original thread at
`https://patch.msgid.link/20260426025520.3985-2-rosalie@mailbox.org`.
`b4 dig -a` found only v1. Patchew and b4 showed Takashi Iwai replied
“Applied now. Thanks.” No objections or NAKs found.

Step 4.2 Record: `b4 dig -w` showed recipients: Rosalie Wanders,
Jaroslav Kysela, Takashi Iwai, `linux-sound@vger.kernel.org`, and
`linux-kernel@vger.kernel.org`. The appropriate sound maintainers/list
were included.

Step 4.3 Record: The only `Link:` is the patch submission itself. No
separate bugzilla, syzbot, or user report link was found.

Step 4.4 Record: The patch is standalone v1, not part of a multi-patch
series. No related Riffmaster patches were found in local
`origin/master` history.

Step 4.5 Record: Direct lore stable search was blocked by Anubis, and
web search did not find stable-list discussion for PDP Riffmaster. No
stable-specific nomination or rejection was verified.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: Modified function: `volume_control_quirks()`.

Step 5.2 Record: Call path verified manually: USB probe creates streams
and mixer via `snd_usb_create_mixer()`, mixer parsing reaches
`snd_usb_mixer_controls()`, feature units call `build_feature_ctl()`,
which calls `get_min_max_with_quirks()`, which calls
`volume_control_quirks()` when a `kctl` exists.

Step 5.3 Record: Relevant callees are `usb_audio_info()` and later ALSA
dB/range handling in `get_min_max_with_quirks()`. The patch changes
`cval->min` before `dBmin`, `dBmax`, initialization, and control
registration.

Step 5.4 Record: Reachability is via USB device enumeration and ALSA
mixer creation for this specific hardware. Userspace impact is through
normal audio/mixer use after the device is connected. I did not verify
the actual device descriptor/control name on hardware.

Step 5.5 Record: Similar patterns exist in the same switch for
CM102-A+/102S+, Asus USB DAC, MOONDROP Quark2, Huawei CM-Q3, and
MOONDROP JU Jiu. A similar MOONDROP JU Jiu quirk was explicitly tagged
for stable.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: Checked `remotes/stable/linux-5.10.y`, `5.15.y`,
`6.1.y`, `6.6.y`, `6.12.y`, `6.18.y`, `6.19.y`, and `7.0.y`: all contain
`volume_control_quirks()` and the call from `get_min_max_with_quirks()`.
None contained the Riffmaster IDs.

Step 6.2 Record: Current `7.0.y` working tree accepts the patch with
`git apply --check`. `git merge-tree` suggests most checked branches can
merge the addition automatically, but `5.15.y` shows a minor context
conflict around another quirk entry after the Asus DAC entry.

Step 6.3 Record: No related Riffmaster fix already present in the
checked stable branches or `origin/master` history beyond
`110189f0268d0`.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: Subsystem is ALSA USB audio under `sound/usb`.
Criticality is driver-specific/peripheral: it affects users of the PDP
Riffmaster hardware, not the whole system.

Step 7.2 Record: Recent history shows `sound/usb` is actively
maintained, with nearby fixes and quirks. The patch was committed by a
listed sound maintainer.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: Affected population is hardware-specific: PDP
Riffmaster PS4/PS5 users with USB-audio playback exposed as `PCM
Playback Volume`.

Step 8.2 Record: Trigger is connecting/using that hardware and its ALSA
playback volume control. This is common for affected users but
irrelevant to everyone else. Unprivileged users can observe/use ALSA
controls depending on system policy, but the patch itself runs at device
enumeration/control setup.

Step 8.3 Record: Failure mode is too-low audio volume / poor device
usability, not a crash or corruption issue. Severity is medium for
affected hardware.

Step 8.4 Record: Benefit is high for affected device users and zero-
impact for other devices. Risk is very low because the change is 10
lines, exact USB-ID gated, and follows existing quirk-table style.

## Phase 9: Final Synthesis
Step 9.1 Record:
Evidence for backporting: this is a classic hardware quirk, small and
contained, maintainer-applied, affects real hardware, and all checked
active stable branches have the infrastructure. Hardware quirks are an
accepted stable exception.
Evidence against: no `Cc: stable`, no `Tested-by`, no separate bug
report, and the failure is not crash/security/data corruption. `5.15.y`
may need minor manual placement.
Unresolved: no hardware test or descriptor dump was available to
independently verify that the device exposes the exact `PCM Playback
Volume` control.

Step 9.2 Stable rules:
1. Obviously correct and tested? Mostly yes on correctness; no explicit
   `Tested-by` or local hardware test.
2. Fixes a real bug? Yes, per commit and mailing-list submission: too-
   low volume on specific hardware.
3. Important issue? Medium severity hardware usability issue; stable
   exception applies for quirks.
4. Small and contained? Yes, 10 lines in one switch.
5. No new features/APIs? Yes, no API or broad behavior change.
6. Can apply to stable? Yes for current tree; likely minor context
   handling for at least `5.15.y`.

Step 9.3 Exception category Record: Hardware quirk/workaround for
specific USB devices. This is a stable-appropriate exception category.

Step 9.4 Decision: Backport. The technical risk is extremely low, the
change is device-specific, and stable policy explicitly allows
quirks/workarounds for real hardware problems.

## Verification
- Phase 1: Parsed `git show --format=fuller --stat --patch
  110189f0268d0`; confirmed subject, tags, commit body, author,
  committer, and 10-line diff.
- Phase 2: Verified the only code change is adding two `USB_ID()` cases
  in `volume_control_quirks()`.
- Phase 3: Ran `git blame` around the insertion context; identified
  historical context commits and version containment via `git describe
  --contains`.
- Phase 3: Ran local history searches without `--all`; found no
  prerequisite Riffmaster commits.
- Phase 4: Ran `b4 dig -c`, `b4 dig -a`, and `b4 dig -w`; confirmed one
  v1 patch, original recipients, and lore URL.
- Phase 4: Used b4 mbox and Patchew to read the thread; confirmed
  Takashi’s “Applied now. Thanks.” reply and no objections.
- Phase 4: Stable lore WebFetch was blocked by Anubis; WebSearch found
  no stable-specific Riffmaster discussion.
- Phase 5: Read `sound/usb/mixer.c`, `sound/usb/card.c`, and
  `sound/usb/quirks.c`; traced the mixer creation and feature-control
  path to `volume_control_quirks()`.
- Phase 6: Checked stable branches `5.10.y`, `5.15.y`, `6.1.y`, `6.6.y`,
  `6.12.y`, `6.18.y`, `6.19.y`, and `7.0.y`; confirmed infrastructure
  exists and Riffmaster IDs are absent.
- Phase 6: Ran `git apply --check` on current tree; passed. Ran `git
  merge-tree`; noted a minor conflict marker for `5.15.y`.
- Phase 7: Verified `MAINTAINERS` lists Jaroslav Kysela and Takashi Iwai
  for `SOUND`.
- Phase 8: Verified scope is exact-device gated by USB IDs and exact
  mixer control name.
- UNVERIFIED: Actual PDP Riffmaster USB descriptors and hardware
  behavior were not locally tested.
- UNVERIFIED: Older branches outside the checked active stable set were
  not analyzed.

**YES**

 sound/usb/mixer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 1ced9ba8be406..75c932ea77388 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1190,6 +1190,16 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 			cval->res = 1;
 		}
 		break;
+
+	case USB_ID(0x0e6f, 0x024a): /* PDP Riffmaster for PS4 */
+	case USB_ID(0x0e6f, 0x0249): /* PDP Riffmaster for PS5 */
+		if (!strcmp(kctl->id.name, "PCM Playback Volume")) {
+			usb_audio_info(chip,
+				"set volume quirk for PDP Riffmaster for PS4/PS5\n");
+			cval->min = -2560; /* Mute under it */
+		}
+		break;
+
 	case USB_ID(0x3302, 0x12db): /* MOONDROP Quark2 */
 		if (!strcmp(kctl->id.name, "PCM Playback Volume")) {
 			usb_audio_info(chip,
-- 
2.53.0

