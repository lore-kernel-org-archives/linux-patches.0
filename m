Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0F6325491;
	Tue,  5 May 2026 09:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974713; cv=none; b=dA7oSuMYLEau7Cj2PIWOybPjf3gw64HelpPkMOnuxdsCwktu87w7KZ1pWSgmZMLOETPazbOKC8IQG09Ii2CQ80GwNLacpVgGvO2wENPFOLtb4nKFXUDEVdXlALbZ+eLvXoi2fDwQ6fDmh7cEdkynlXhzRcBYlFELqvcXvsVWmGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974713; c=relaxed/simple;
	bh=sb6o6Unc0M66XMHsZpONLOYyiHRqwcTBufVToiYEHDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sE0ZEb7fnBPlH1GY8ogxnL9NQ8BvYFbsdSr4oftMAxYQJH8Lp7th9EE/sqQKYpc2rdik8C3mBO6OjT9DCIVIYCk3iAddThGqW24XmHlxHJXKDSuOAUiaYYhJ89WZsM8ryBNhgO8UWnGxPj1hm7Pgs7ewV2fOWGoYJ4yEHWuKLiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErT3+8In; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErT3+8In"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A12C2BCB9;
	Tue,  5 May 2026 09:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974713;
	bh=sb6o6Unc0M66XMHsZpONLOYyiHRqwcTBufVToiYEHDw=;
	h=From:To:Cc:Subject:Date:From;
	b=ErT3+8InskYEioA1u3kT8gO1IPkEiX+2lLBbP3kqofLgqYnpJyhsbp423FFRRlOvz
	 IyYwG3Qdfk30N6uDrRBzcJCgtpe3KXJcPfJyjfcThSUv59faUciFtOChSmjdDoGafA
	 rrqBr3uTIl/OCBNcEtedijPHpA7GCwParL/zebn710SM+fgQS/nbfouqtEawSbTQrq
	 ZyRXTC9zDgyjFUwxMo2/fk1XurVimidxDa7sW9cJrHSJ+193/gzkcVtQyhcUcxi6Ek
	 hji3+fO5N8ddsxmKmfhIQk6Rx/L5ygKUALIcNVXe2jBeU3QGrOEFXpSxGib8PKwSNE
	 U3c958UwyaOWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ALSA: hda: Avoid WARN_ON() for HDMI chmap slot checks
Date: Tue,  5 May 2026 05:51:17 -0400
Message-ID: <20260505095149.512052-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 077c593dacf7ee33511468e4f29417d795cf07a4 ]

At parsing the channel mapping for HDMI, the current code may spew
WARN_ON() unnecessarily for the case where only invalid (zero) channel
maps are given from the hardware.  Drop WARN_ON() and reorganize the
code a bit for avoiding the hdmi_slot over the array size.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221390
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260428061800.80527-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 Record: subsystem is `ALSA: hda`; action verb is `Avoid`;
claimed intent is to avoid unnecessary `WARN_ON()` during HDMI channel-
map slot checks.

Step 1.2 Record: tags present are `Closes:
https://bugzilla.kernel.org/show_bug.cgi?id=221390`, `Signed-off-by:
Takashi Iwai <tiwai@suse.de>`, `Link:
https://patch.msgid.link/20260428061800.80527-1-tiwai@suse.de`, and
another `Signed-off-by: Takashi Iwai <tiwai@suse.de>` in the supplied
commit text. No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`,
`Acked-by:`, or `Cc: stable` tag was present.

Step 1.3 Record: the commit says HDMI channel-map parsing can emit
unnecessary `WARN_ON()` when hardware supplies only invalid zero channel
maps, and also says the code is reorganized to avoid `hdmi_slot` going
over the array size. The visible user symptom is kernel warning spam;
the linked Bugzilla content could not be fetched because Bugzilla
returned an Anubis bot-protection page.

Step 1.4 Record: this is a real bug fix, not just cleanup. The diff
removes a warning path reachable from bad hardware-provided mapping data
and adds an explicit bound exit before programming or storing an invalid
HDMI slot.

## Phase 2: Diff Analysis

Step 2.1 Record: one file changes: `sound/hda/core/hdmi_chmap.c`, with 7
insertions and 4 deletions. The only modified function is
`hdmi_std_setup_channel_mapping()`. Scope is a single-file surgical fix.

Step 2.2 Record: before the patch, the loop skipped empty speaker slots
using `WARN_ON(hdmi_slot >= 8)` as part of the while condition, but
after the warning fired the loop still proceeded to assign `hdmi_slot`
into `hdmi_channel_mapping`. After the patch, the outer loop stops when
`hdmi_slot` reaches 8, the inner skip loop jumps to `out` before
assignment when the slot limit is reached, and the remaining slots are
filled with the invalid ALSA channel marker as before.

Step 2.3 Record: bug category is logic/bounds handling plus spurious
warning removal. The broken mechanism is that `hdmi_slot` can reach the
8-slot HDMI limit while looking for a nonzero speaker slot, causing a
`WARN_ON()` and allowing an invalid slot number to be used in the
mapping path. The fix prevents the over-limit assignment.

Step 2.4 Record: the fix is obviously local and low-risk. It changes
only the invalid/edge path where slot scanning reaches the HDMI 8-slot
limit. It does not add APIs, data structures, or features.

## Phase 3: Git History Investigation

Step 3.1 Record: `git blame` shows the function and mapping logic came
from `2f6e8a8518f3` (`ALSA: hda - Move chmap support helpers/ops to
core`, first contained in `v4.6-rc1`), and the current
`WARN_ON(hdmi_slot >= 8)` ordering came from `960a581e22d9` (`ALSA: hda:
fix some klockwork scan warnings`, first contained in `v4.8-rc1`).

Step 3.2 Record: no `Fixes:` tag is present, so there was no tagged
introducing commit to follow. Blame identifies `960a581e22d9` as the
source of the current warning expression.

Step 3.3 Record: recent history for this file is sparse. Relevant later
changes include `c2432466f583c` HDMI/DP chmap reporting, `6278056e42d9`
input value sanity checks, and `b2660d1ebde` moving the file into
`sound/hda/core`. No prerequisite for this patch was identified.

Step 3.4 Record: author Takashi Iwai is listed in `MAINTAINERS` as a
maintainer for `SOUND`, and recent git history shows many HDA commits
authored/merged by him. This is a strong subsystem-authority signal.

Step 3.5 Record: no dependency on newer structures or helper functions
was found. The affected code pattern exists in active stable trees;
older trees before `v6.17` use the path `sound/hda/hdmi_chmap.c` instead
of `sound/hda/core/hdmi_chmap.c`.

## Phase 4: Mailing List And External Research

Step 4.1 Record: an exact candidate commit SHA was not found by subject
on the searched refs, so `b4 dig -c <candidate>` could not be run for
the candidate. Using the message-id instead, `b4 am
20260428061800.80527-1-tiwai@suse.de` found the patch, confirmed a
single patch, DKIM-signed by `suse.de`, and reported that it applies
cleanly to the current tree. `b4 am -c` found no newer revision.

Step 4.2 Record: `b4 mbox` showed the original patch was sent by Takashi
Iwai to `linux-sound@vger.kernel.org` and Cc’d `linux-
kernel@vger.kernel.org`. The fetched thread contained one message and no
code-review replies or review trailers.

Step 4.3 Record: the patch has a Bugzilla `Closes:` link, but WebFetch
for Bugzilla was blocked by Anubis. I could not verify reporter severity
or duplicates from Bugzilla content.

Step 4.4 Record: `b4 am` reported one total patch, and no series context
or newer revision was found. This appears standalone.

Step 4.5 Record: web searches did not find stable-list discussion for
the exact title. No stable-specific objection was found.

## Phase 5: Code Semantic Analysis

Step 5.1 Record: modified function is
`hdmi_std_setup_channel_mapping()`.

Step 5.2 Record: `rg` shows `hdmi_std_setup_channel_mapping()` is called
only by `snd_hdac_setup_channel_mapping()`. That exported helper is
called from HDA HDMI setup in `sound/hda/codecs/hdmi/hdmi.c` and ASoC
HDMI codec setup in `sound/soc/codecs/hdac_hdmi.c`.

Step 5.3 Record: the affected function computes slot/channel assignments
and calls `chmap->ops.pin_set_slot_channel()`, which writes the
`AC_VERB_SET_HDMI_CHAN_SLOT` HDA verb through the codec operation.

Step 5.4 Record: the path is reachable during HDMI/DP audio setup: PCM
prepare, ELD/presence update, channel-map control update when prepared,
and ASoC DAPM pin power-up call into the infoframe setup path. This is a
real runtime hardware path, not dead code.

Step 5.5 Record: `rg` found no other `WARN_ON(hdmi_slot >= 8)` or
similar `hdmi_slot` warning pattern elsewhere in `sound/`.

## Phase 6: Cross-Referencing And Stable Tree Analysis

Step 6.1 Record: the exact `WARN_ON(hdmi_slot >= 8)` pattern exists in
active stable branches checked: `stable/linux-5.10.y`, `5.15.y`,
`6.1.y`, `6.6.y`, `6.12.y`, `6.18.y`, `6.19.y`, and `7.0.y`.

Step 6.2 Record: backport difficulty should be clean or minor. `git
apply --check` succeeds on the current `7.0.y` checkout. For `5.10.y`
through `6.12.y`, the code is effectively the same but the file path is
`sound/hda/hdmi_chmap.c`; `6.18.y+` uses `sound/hda/core/hdmi_chmap.c`.

Step 6.3 Record: searches for the exact subject and bug number in stable
history found no existing matching stable fix.

## Phase 7: Subsystem And Maintainer Context

Step 7.1 Record: subsystem is ALSA HDA HDMI channel mapping under
`sound/`. Criticality is IMPORTANT: it affects users of HDA HDMI/DP
audio hardware, not all kernel users.

Step 7.2 Record: subsystem activity is active; recent `sound/hda`
history contains HDA HDMI fixes, quirks, cleanups, and device IDs. The
touched file itself has low churn.

## Phase 8: Impact And Risk Assessment

Step 8.1 Record: affected users are driver/hardware-specific: systems
using HDA HDMI/DP audio channel mapping, especially hardware that
reports invalid zero channel-map data.

Step 8.2 Record: trigger is HDMI channel-map setup with invalid/zero
mapping data from hardware, reached during audio infoframe/channel
setup. I did not verify whether an unprivileged user can force the exact
bad hardware data; the runtime setup path itself is reachable during
normal audio/display operation.

Step 8.3 Record: failure mode is warning splat/log spam and invalid slot
handling. Severity is MEDIUM normally, and potentially higher on systems
configured with `panic_on_warn`, but I did not verify `panic_on_warn` in
the bug report.

Step 8.4 Record: benefit is medium: avoids a user-reported warning and
prevents invalid HDMI slot use on affected hardware. Risk is very low:
11-line single-function change in an edge path with no API or behavior
expansion.

## Phase 9: Final Synthesis

Step 9.1 Record: evidence for backporting: user-reported Bugzilla-linked
issue, maintainer-authored ALSA fix, small and isolated diff, removes a
spurious runtime `WARN_ON()`, adds explicit bounds handling, code exists
across active stable trees, and current-tree apply check succeeds.
Evidence against: primary verified symptom is warning/log noise rather
than confirmed crash, data corruption, or security issue; Bugzilla
details could not be fetched; older stable trees need a path-adjusted
backport because of the `sound/hda/core` rename.

Step 9.2 Record: stable rules checklist:
1. Obviously correct and tested: yes for obvious correctness by
   inspection; external testing is not evidenced by tags.
2. Fixes a real bug: yes, commit has a Bugzilla `Closes:` and fixes a
   concrete warning/bounds condition.
3. Important issue: moderate importance; warnings from hardware-
   triggered paths are stable-worthy when the fix is tiny and safe.
4. Small and contained: yes, one function, one file, 7 insertions and 4
   deletions.
5. No new features/APIs: yes.
6. Can apply to stable: yes for current path; minor path adjustment
   needed for older stable branches.

Step 9.3 Record: no automatic exception category applies. This is not a
device ID, quirk table entry, DT update, build fix, or documentation
fix.

Step 9.4 Record: decision is YES. The patch is small, maintainer-
authored, fixes a real user-reported WARN/bounds handling issue in
existing HDA HDMI code present across stable trees, and has very low
regression risk.

## Verification

- [Phase 1] Read the supplied commit message and the fetched mbox:
  confirmed subject, body, `Closes`, and `Signed-off-by`.
- [Phase 2] Read the b4-fetched patch: confirmed
  `sound/hda/core/hdmi_chmap.c`, 7 insertions, 4 deletions, one hunk in
  `hdmi_std_setup_channel_mapping()`.
- [Phase 3] Ran `git blame` on the changed region: confirmed
  `2f6e8a8518f3` and `960a581e22d9` history.
- [Phase 3] Ran `git describe --contains`: confirmed `2f6e8a8518f3`
  appears in `v4.6-rc1` ancestry and `960a581e22d9` in `v4.8-rc1`
  ancestry.
- [Phase 3] Checked file history and author history: no prerequisite
  commit identified; Takashi Iwai is active in HDA history.
- [Phase 4] `b4 am` by message-id: found the exact patch, one total
  patch, DKIM signed, applies cleanly to current tree.
- [Phase 4] `b4 am -c`: found no newer revision.
- [Phase 4] `b4 mbox`: confirmed To/Cc and that the thread has one
  message.
- [Phase 4] WebFetch for lore and Bugzilla: blocked by Anubis, so bug
  details beyond the `Closes` URL are unverified.
- [Phase 5] `rg` call tracing: confirmed caller chain through
  `snd_hdac_setup_channel_mapping()` into HDA HDMI and ASoC HDMI setup
  paths.
- [Phase 5] Read caller code: confirmed use during audio infoframe
  setup, ELD/presence handling, PCM prepare, DAPM power-up, and prepared
  chmap update paths.
- [Phase 6] `git grep` on active stable refs: confirmed the exact
  `WARN_ON(hdmi_slot >= 8)` pattern exists in checked `5.10.y` through
  `7.0.y`.
- [Phase 6] `git diff` across stable refs: confirmed older branches
  mostly differ by file rename, with `5.10.y/5.15.y` having one
  unrelated PCM runtime-state line difference.
- [Phase 6] `git apply --check`: candidate patch applies cleanly to the
  current `7.0.y` checkout.
- [Phase 7] `MAINTAINERS` search: confirmed Takashi Iwai is listed as a
  `SOUND` maintainer.
- [Phase 8] Severity/risk assessment is based on the verified diff,
  commit message, and runtime call paths.
- UNVERIFIED: exact Bugzilla reporter details, number of affected users,
  and whether the reporter hit a panic rather than warning spam.
- UNVERIFIED: exact upstream commit SHA, because the subject was not
  found on searched local refs; candidate-specific `b4 dig -c` could not
  be performed.

**YES**

 sound/hda/core/hdmi_chmap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/hda/core/hdmi_chmap.c b/sound/hda/core/hdmi_chmap.c
index 7b276047f85a7..c897fc443467c 100644
--- a/sound/hda/core/hdmi_chmap.c
+++ b/sound/hda/core/hdmi_chmap.c
@@ -353,13 +353,16 @@ static void hdmi_std_setup_channel_mapping(struct hdac_chmap *chmap,
 	if (hdmi_channel_mapping[ca][1] == 0) {
 		int hdmi_slot = 0;
 		/* fill actual channel mappings in ALSA channel (i) order */
-		for (i = 0; i < ch_alloc->channels; i++) {
-			while (!WARN_ON(hdmi_slot >= 8) &&
-			       !ch_alloc->speakers[7 - hdmi_slot])
-				hdmi_slot++; /* skip zero slots */
+		for (i = 0; i < ch_alloc->channels && hdmi_slot < 8; i++) {
+			while (!ch_alloc->speakers[7 - hdmi_slot]) {
+				/* skip zero slots */
+				if (++hdmi_slot >= 8)
+					goto out;
+			}
 
 			hdmi_channel_mapping[ca][i] = (i << 4) | hdmi_slot++;
 		}
+	out:
 		/* fill the rest of the slots with ALSA channel 0xf */
 		for (hdmi_slot = 0; hdmi_slot < 8; hdmi_slot++)
 			if (!ch_alloc->speakers[7 - hdmi_slot])
-- 
2.53.0

