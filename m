Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5481C41B343;
	Mon, 11 May 2026 22:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778537989; cv=none; b=IjNU3kjLP16stEg2KKtl3mi573YQ7+3q4ObNoE4MyVExexK7EFIEljbDKIC0K+sqKaEkD1I4HisD27+P25qHaE/HT+Ng1cWf5EYcZ9i0waIBLDHaoDq7yKVEv4cH7siezwfCurgIe+vgoJ3aY+zDnfK38h20ud7tB7D6zBdNjvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778537989; c=relaxed/simple;
	bh=GJYylXcn2nsU8fJDFYpyDxNo2CMymQnw6UwK2SAQfhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t853AQFJUMvt5w7wm2iPT6F1fDVt834XF0cSEy85kFm7V1n9f5RFDIDL5Z+Bt9igGPsiBOyjLNiID4Amq77WVPBBu5SBlxfnUiSBk4W2vPFc7V0meEGfR/+WDMKRwMYyFOniJPsg2p2U5meNmYenuh4/lzU6VcMHRZjtBj3C/ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKRcEzYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKRcEzYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E25BC2BCB0;
	Mon, 11 May 2026 22:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778537988;
	bh=GJYylXcn2nsU8fJDFYpyDxNo2CMymQnw6UwK2SAQfhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKRcEzYRVI1a02tyzGOeYlM2h1zfNafDPfo+yC/NTk0P+NygZiRI6N1jxpDk+E9Zm
	 CHVAFisZcq57O0VuAA+y/9RG43Ou6auGwX/VnazI7bsJQrYUTgizjyIEK8ntuOfAkw
	 HHE3mIjjJQK5U2cuL+oDIAFYFTqUmJnu47vUkdrYSoyCeVukOU70XB6ONqYylJ+o1T
	 FL4NC1z71i1aHb6n5PXGAGPEpFq1aR9Lsek2FxLhP8mUhPTUqtnNrCAHtQ8RbP+OS5
	 Cfpl9yp+pjKpdW1gt4O8GVZOZ1IhgSDZJ259bgekj23F8rRZYDuEiD0iuzjV2lEmv/
	 GcoP6H371oNJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pauli Virtanen <pav@iki.fi>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] ALSA: usb-audio: add min_mute quirk for Razer Nommo V2 X
Date: Mon, 11 May 2026 18:19:10 -0400
Message-ID: <20260511221931.2370053-11-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit ad39a189bfebb3de580f390bc000f9e121c6aca3 ]

ID 1532:055e Razer USA, Ltd Razer Nommo V2 X
is tested to have muted min playback volume. Apply quirk for that.

Link: https://gitlab.freedesktop.org/pipewire/pipewire/-/work_items/5235
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Link: https://patch.msgid.link/94449577332d14d7974864903825f27e5824ddbc.1777579951.git.pav@iki.fi
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `ALSA: usb-audio`; action verb `add`; intent:
add a playback-minimum-is-mute quirk for USB ID `1532:055e`, Razer Nommo
V2 X.

Step 1.2 Record: tags in supplied message: `Link` to PipeWire work item,
`Signed-off-by: Pauli Virtanen`, `Link` to patch msgid, `Signed-off-by:
Takashi Iwai`. No `Fixes`, `Reported-by`, `Tested-by`, `Reviewed-by`,
`Acked-by`, or `Cc: stable`. The lore patch mbox verifies the Pauli SOB
and PipeWire link; Takashi replied “Applied now.”

Step 1.3 Record: bug description is device-specific: Razer Nommo V2 X
has muted minimum playback volume. Symptom: userspace may expose the
minimum playback volume as a normal low audible volume even though
hardware treats it as mute. Version info: none in commit message. Root
cause: device has nonstandard mixer semantics.

Step 1.4 Record: yes, hidden bug/hardware workaround. It is a quirk for
incorrect USB-audio volume semantics on real hardware.

## Phase 2: Diff Analysis
Step 2.1 Record: `sound/usb/quirks.c`, `+2/-0`, in
`quirk_flags_table[]`. Scope: single-file surgical hardware quirk.

Step 2.2 Record: before, USB ID `1532:055e` had no built-in quirk flag.
After, matching that device sets `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE`.
Affected path is USB-audio device initialization and mixer control
construction.

Step 2.3 Record: bug category is hardware workaround / quirk table
entry. Mechanism: `snd_usb_init_quirk_flags_table()` ORs the flag into
`chip->quirk_flags`; `snd_usb_mixer_fu_apply_quirk()` sees that flag on
Playback controls and sets `cval->min_mute = 1`;
`snd_usb_mixer_vol_tlv()` then reports `SNDRV_CTL_TLVT_DB_MINMAX_MUTE`.

Step 2.4 Record: fix is obviously correct for kernels with this quirk
infrastructure: one ID-specific table entry, no public API, no locking
or lifetime changes. Regression risk is very low and limited to this
VID:PID.

## Phase 3: Git History Investigation
Step 3.1 Record: blame around the insertion area shows the surrounding
quirk table is longstanding, with the nearby `NeuralDSP Quad Cortex`
exception from `bc5b4e5ae1a67` and Denon entries from older Takashi Iwai
commits. The common min-mute quirk infrastructure comes from
`2c3ca8cc55a3` and follow-ups.

Step 3.2 Record: no `Fixes:` tag, so no introducing commit to follow.

Step 3.3 Record: recent `sound/usb/quirks.c` history contains many
similar device-specific quirk fixes. Related min-mute commits include
`2b929b6eec0c7` Logitech H390, `9af61fc91486c` MS LifeChat, and
`b98b69c38512c` SteelSeries Arctis.

Step 3.4 Record: Pauli Virtanen has prior USB-audio quirk commits in
this exact area, including Logitech H390, MS LifeChat, and SteelSeries
Arctis min-mute quirks.

Step 3.5 Record: dependency is the min-mute quirk infrastructure.
Present in current `7.0.y`; present in `v6.18` with
`QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE`; `v6.17` has older
`QUIRK_FLAG_MIXER_MIN_MUTE`; `v6.16`/`v6.12` did not show the generic
flag.

## Phase 4: Mailing List And External Research
Step 4.1 Record: no local commit hash was found, so `b4 dig -c` could
not be used successfully. `b4 am` and `b4 mbox` by message-id found a
single-patch thread at the supplied msgid. Thread has patch plus Takashi
Iwai reply: “Applied now.” No NAKs or concerns found in fetched thread.

Step 4.2 Record: original patch To/Cc from mbox: `linux-
sound@vger.kernel.org`, Pauli Virtanen, Jaroslav Kysela, Takashi Iwai,
`linux-kernel@vger.kernel.org`. Appropriate sound maintainers/lists were
included.

Step 4.3 Record: PipeWire link was blocked by Anubis via WebFetch, so
details could not be verified. GitHub OpenRazer issue independently
verifies device name and VID:PID `1532:055E`, but it is not the PipeWire
volume bug report.

Step 4.4 Record: thread is a standalone one-patch submission. Similar
prior min-mute quirk patches exist, but this patch does not depend on a
same-series patch.

Step 4.5 Record: lore stable search via WebFetch was blocked by Anubis;
local stable branch searches found no existing Razer Nommo V2 X commit.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: modified data object is `quirk_flags_table[]`; affected
functions are `snd_usb_init_quirk_flags_table()`,
`snd_usb_init_quirk_flags()`, `snd_usb_audio_create()`,
`snd_usb_mixer_fu_apply_quirk()`, and `snd_usb_mixer_vol_tlv()`.

Step 5.2 Record: `snd_usb_audio_create()` calls
`snd_usb_init_quirk_flags()` during USB audio card creation; that calls
`snd_usb_init_quirk_flags_table()`. `build_feature_ctl()` calls
`snd_usb_mixer_fu_apply_quirk()` while building mixer controls.

Step 5.3 Record: key callees/side effects are table lookup, setting
`chip->quirk_flags`, setting `cval->min_mute`, and TLV reporting through
`copy_to_user()`.

Step 5.4 Record: reachable when the specific USB audio device is
connected and its mixer controls are created. This is device-specific,
not universal.

Step 5.5 Record: many existing `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE`
entries exist for similar USB audio devices, confirming this is an
established local pattern.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: current `7.0.y` lacks the Razer entry and contains the
necessary infrastructure. `v6.18`/`v6.19` contain the named playback
min-mute flag. `v6.17` has the older generic
`QUIRK_FLAG_MIXER_MIN_MUTE`; `v6.16`/`v6.12` did not show the generic
flag.

Step 6.2 Record: `git apply --check` succeeds on current `7.0.y`. Older
trees may need minor contextual adjustment; `v6.17` would need the older
flag name. Older LTS trees without the common quirk infrastructure would
need a nontrivial backport or prerequisite series.

Step 6.3 Record: no related Razer Nommo V2 X fix found in local
`stable/linux-7.0.y`.

## Phase 7: Subsystem Context
Step 7.1 Record: subsystem is ALSA USB audio driver under `sound/usb`;
criticality is driver-specific/peripheral, but real hardware user-
visible behavior.

Step 7.2 Record: USB-audio quirks are active, with recent commits
adding/fixing device-specific quirks and min-mute behavior.

## Phase 8: Impact And Risk
Step 8.1 Record: affected population is users of Razer Nommo V2 X using
USB audio.

Step 8.2 Record: trigger is normal volume-control use on that device.
Unprivileged audio clients can read/use ALSA mixer metadata, but no
security impact was verified.

Step 8.3 Record: failure mode is functional audio control
misrepresentation: minimum playback volume is mute. Severity: medium for
affected hardware, not crash/corruption.

Step 8.4 Record: benefit is high for affected device users and low
system-wide; risk is very low because the change is a two-line VID:PID-
scoped quirk.

## Phase 9: Final Synthesis
Step 9.1 Record: evidence for backporting: real tested hardware quirk,
established USB-audio pattern, two-line scoped change, maintainer
applied, clean on `7.0.y`, no global behavior change. Evidence against:
not a crash/security/data-corruption fix; older stable trees may need
adjustment or prerequisites. Unresolved: PipeWire bug details
unavailable due Anubis; no upstream commit hash found locally for `b4
dig`.

Step 9.2 Record: stable rules: obviously correct: yes for trees with
infrastructure; fixes real user-visible hardware bug: yes; important
enough: yes under hardware-quirk exception; small/contained: yes, 2
lines; no new APIs/features: yes; applies to stable: clean on current
`7.0.y`, minor/unknown adjustments for older trees.

Step 9.3 Record: exception category applies: hardware quirk/workaround
for an existing driver and existing quirk mechanism.

Step 9.4 Record: decision is to backport to stable trees that contain
the min-mute quirk infrastructure, especially `7.0.y`/`6.19.y`/`6.18.y`;
older trees should only take it with the appropriate small backport
adjustment or prerequisites.

Verification: performed semantic search; inspected current HEAD and
branch state; read `sound/usb/quirks.c`, `usbaudio.h`, `mixer_quirks.c`,
`mixer.c`, and `card.c`; used `rg` for quirk usage/callers; used `git
blame`, `git log`, `git show`, `git merge-base`, and `git apply
--check`; fetched lore thread with `b4 am`/`b4 mbox`; attempted `b4 dig`
but no commit hash/local commit match was available; attempted WebFetch
for PipeWire/lore search but Anubis blocked; verified device VID:PID via
OpenRazer/WebSearch.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 4cfa24c06fcdf..148bf7e4e4d72 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2307,6 +2307,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x152a, 0x880a, /* NeuralDSP Quad Cortex */
 		   0), /* Doesn't have the vendor quirk which would otherwise apply */
+	DEVICE_FLG(0x1532, 0x055e, /* Razer Nommo V2 X */
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x154e, 0x1002, /* Denon DCD-1500RE */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x154e, 0x1003, /* Denon DA-300USB */
-- 
2.53.0

