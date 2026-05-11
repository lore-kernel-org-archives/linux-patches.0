Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7171836A373;
	Mon, 11 May 2026 22:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778538013; cv=none; b=U2NsFC8Tg8MbeW0RqVTaBGHbfU4sUK5mmdIAcRMbdH/DF5wv2Q3W5ef7pDYemQsuu3DWlnudlWVnO6N5Ib5QOL0fcXtqy7LdScZWdfaj3JqD+PzlV7M7IbMsgz5MyS8Vz2gBRVYvtCUALP6L+b0lXIajumE3GmwgdXEMjAT/dcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778538013; c=relaxed/simple;
	bh=NGPS82dFju4rpw26IMrBXC1852ms9DsElWuvBCBev1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QD4zNcpvENqduGFS44zAZuXzKpyTPiOeaSwn0j4n7UFIASLWphw81CE/E06IeY3DiAMBvL09MN93VKwBqLBUk6CM4laI4lb+wgxFR62TY2XxBoDHAfOowp6b6Vu/0jgd9XX32edF3DzYrYlwytA509hXSIea3jI6O+9+sLsQC1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o35BiZuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o35BiZuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C6EC2BCF7;
	Mon, 11 May 2026 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778538013;
	bh=NGPS82dFju4rpw26IMrBXC1852ms9DsElWuvBCBev1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o35BiZuVftIteICAtc8+s9nIZhd6P2prx/leGeSjzbGxDWqx8u7i4ScE0hJZGI53z
	 psHBVHyspCT8av2U7yzUjjw/hhglBipuXKH3kE/Aq0NPSn7Tle26q/QeLbPPmeZnGN
	 cCGkfiItx0oVdQIITBuKpACmMCVyHgjhrRhOJLgpcQCvSgN/diuqeVL1Q+cD10t5AP
	 X6iPXwiAw7LEGODjGzEWE4yZbOYMzw6y93NBrOKtzSH0zI6gqKBkkyKUbgxOH9HYPf
	 dOAuiGblE0sGrB9FM114IqIL801T2+O/tTnAtXWH0H2HG2Y9vCApuU2F5hiNUvWv09
	 yUfPcBuh6vXtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicola Lunghi <nick83ola@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ALSA: usb-audio: add clock quirk for Motu 1248
Date: Mon, 11 May 2026 18:19:27 -0400
Message-ID: <20260511221931.2370053-28-sashal@kernel.org>
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

From: Nicola Lunghi <nick83ola@gmail.com>

[ Upstream commit 320e55722ca466a7d40dd69e1aea982cb6189006 ]

The Motu 1248 (and probably other older Motu AVB interfaces) take more
than 2 seconds to switch clock. During the clock switching process the
device return that the clock is not valid. This is similar to what
already implemented for the Microbook II interface. Add the Motu
1248 usb id to the existing Motu quirk.

Signed-off-by: Nicola Lunghi <nick83ola@gmail.com>
Link: https://patch.msgid.link/20260504144520.699522-2-nick83ola@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

Phase 1:
- Record 1.1: Subsystem `ALSA: usb-audio`; action verb `add`; intent is
  to add Motu 1248 USB ID `07fd:0005` to an existing clock-validity
  delay quirk.
- Record 1.2: Tags: `Signed-off-by: Nicola Lunghi`, `Link:
  https://patch.msgid.link/20260504144520.699522-2-nick83ola@gmail.com`,
  `Signed-off-by: Takashi Iwai`. No `Fixes:`, `Reported-by:`, `Tested-
  by:`, `Reviewed-by:`, or `Cc: stable`.
- Record 1.3: Commit body describes Motu 1248 returning clock-invalid
  for more than 2 seconds while switching clock, causing the existing
  ALSA clock validation to fail too early. No kernel-version range
  given.
- Record 1.4: This is a hardware quirk fix, not a hidden
  memory/synchronization bug.

Phase 2:
- Record 2.1: One file changed: `sound/usb/clock.c`, `+11/-4`. Modified
  function: `uac_clock_source_is_valid_quirk()`. Single-file surgical
  hardware quirk.
- Record 2.2: Before: the 5-second retry loop applied only to
  `USB_ID(0x07fd, 0x0004)`. After: the same loop also applies to
  `USB_ID(0x07fd, 0x0005)`, with comments expanded.
- Record 2.3: Bug category is hardware workaround/device quirk.
  Mechanism: ALSA rechecks clock validity up to 50 times with
  `msleep(100)` instead of failing on the initial transient invalid
  response.
- Record 2.4: Fix quality is high: it reuses existing code and only
  widens the device match. Regression risk is very low and limited to
  MOTU product ID `0x0005`.

Phase 3:
- Record 3.1: `git blame` shows the existing MOTU retry quirk was
  introduced by `2edb84e3047b9` in 2020. Later nearby changes came from
  clock refactoring and multi-control-interface support, but the retry
  logic remains the same.
- Record 3.2: No `Fixes:` tag, so no introducing commit to follow.
- Record 3.3: Recent `sound/usb/clock.c` history shows related clock
  fixes/refactors, but this patch is standalone and only changes the
  device match.
- Record 3.4: Author has prior usb-audio quirk commits in local history;
  Takashi Iwai applied the patch and is the ALSA maintainer/committer
  for this area.
- Record 3.5: No functional dependencies found. The patch applies
  cleanly to checked pending stable branches.

Phase 4:
- Record 4.1: `b4 dig -c 320e55722ca46` found the original submission at
  the patch.msgid.link URL. `b4 dig -a` showed only `v1`; no newer
  revision found.
- Record 4.2: `b4 dig -w` showed Nicola Lunghi, Jaroslav Kysela, Takashi
  Iwai, `linux-sound`, `linux-kernel`, and `linux-usb` were included.
- Record 4.3: `b4 mbox` showed Takashi replied “Applied now. Thanks.” No
  objections or review concerns appeared in the two-message thread.
  WebFetch of lore was blocked by Anubis.
- Record 4.4: No multi-patch series or related required patches found.
- Record 4.5: Stable-list web search was blocked by Anubis; no stable-
  specific discussion was found through the available local/b4 data.

Phase 5:
- Record 5.1: Key function: `uac_clock_source_is_valid_quirk()`.
- Record 5.2: Call path verified: `uac_clock_source_is_valid()` calls
  the quirk when the device reports invalid clock;
  `__uac_clock_find_source()` and `set_sample_rate_v2v3()` call clock
  validation; setup is reached from format parsing, stream setup,
  endpoint preparation, and sample-rate initialization.
- Record 5.3: Key callees are `snd_usb_ctl_msg()`,
  `snd_usb_find_ctrl_interface()`, `snd_usb_find_clock_source()`, and
  `msleep(100)`.
- Record 5.4: Reachability is real for users of affected USB audio
  devices during sample-rate/clock setup and PCM endpoint preparation.
- Record 5.5: Similar existing pattern is the MicroBook IIc quirk for
  the same vendor and same delayed clock-validity behavior.

Phase 6:
- Record 6.1: The existing quirk code exists in checked pending stable
  branches `pending-5.4`, `pending-5.10`, `pending-5.15`, `pending-6.1`,
  `pending-6.6`, `pending-6.12`, and `pending-7.0`.
- Record 6.2: Backport difficulty is clean: `git apply --check`
  succeeded on all those pending branches.
- Record 6.3: No alternative Motu 1248 fix was found in local
  stable/current history.

Phase 7:
- Record 7.1: Subsystem is ALSA USB audio driver. Criticality: IMPORTANT
  for users of affected MOTU hardware, not core-wide.
- Record 7.2: Subsystem is active; recent history contains multiple usb-
  audio fixes and quirks.

Phase 8:
- Record 8.1: Affected users are driver/hardware-specific: Motu 1248 and
  likely related older MOTU AVB/hybrid devices with product ID `0x0005`.
- Record 8.2: Trigger is changing sample rate or clock source, or
  validation during device/audio setup. Unprivileged trigger depends on
  local audio-device permissions; I did not verify distro policy.
- Record 8.3: Failure mode is ALSA failing clock validation early,
  returning errors such as `-ENXIO` from the code path and preventing
  successful audio setup. Severity: MEDIUM for the kernel generally,
  HIGH for affected hardware usability.
- Record 8.4: Benefit is high for affected hardware; risk is very low
  because this only enables an existing quirk for one USB product ID.

Phase 9:
- Record 9.1: Evidence for backporting: real hardware quirk, existing
  stable-accepted mechanism, small single-file change, maintainer-
  applied, cleanly applies to stable branches, external CCRMA
  documentation corroborates MOTU 1248 Linux sample-rate failures that
  succeed after waiting. Evidence against: no crash/security/data-
  corruption, no explicit stable tag, and no direct reporter/tested-by
  tag.
- Record 9.2: Stable rules: obviously correct yes; fixes real user-
  visible hardware failure yes; important enough under hardware-quirk
  exception yes; small/contained yes; no new API/features yes; applies
  cleanly yes.
- Record 9.3: Exception category: hardware quirk/workaround for broken
  device timing behavior.
- Record 9.4: Decision: backport. This is exactly the kind of low-risk
  device-specific quirk stable trees routinely take.

## Verification

- Phase 1: Parsed commit `320e55722ca46` with `git show
  --format=fuller`; verified tags and message.
- Phase 2: Verified diff with `git show --find-renames` and `--numstat`:
  `sound/usb/clock.c`, `+11/-4`.
- Phase 3: Ran `git blame -L 179,240 -- sound/usb/clock.c`; identified
  existing quirk origin `2edb84e3047b9`.
- Phase 3: Checked recent file history with `git log --oneline -20 --
  sound/usb/clock.c`.
- Phase 4: Ran `b4 dig -c 320e55722ca46`, `-a`, and `-w`; confirmed v1
  patch, recipients, and lore URL.
- Phase 4: Ran `b4 mbox`; confirmed Takashi’s “Applied now” reply and no
  objections in the fetched thread.
- Phase 5: Used `rg` and file reads to trace callers through `clock.c`,
  `format.c`, `endpoint.c`, `stream.c`, and `quirks.c`.
- Phase 6: Checked quirk presence in pending stable branches and
  verified `git apply --check` cleanly on `pending-5.4`, `pending-5.10`,
  `pending-5.15`, `pending-6.1`, `pending-6.6`, `pending-6.12`, and
  `pending-7.0`.
- Phase 8: Used WebFetch of CCRMA MOTU 1248 documentation; it reports
  Linux output/sample-rate attempts may fail initially and succeed after
  5-10 seconds.
- UNVERIFIED: Exact USB ID mapping for every model listed in the new
  comment beyond the commit’s own statement.

**YES**

 sound/usb/clock.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 842ba5b801eae..2e0c18e352812 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -208,11 +208,18 @@ static bool uac_clock_source_is_valid_quirk(struct snd_usb_audio *chip,
 	}
 
 	/*
-	 * MOTU MicroBook IIc
-	 * Sample rate changes takes more than 2 seconds for this device. Clock
-	 * validity request returns false during that period.
+	 * Quirk for older MOTU AVB / hybrid interfaces
+	 *
+	 * These devices take more than 2 seconds to switch sample rate or
+	 * clock source. During this period the clock validity request
+	 * returns false, causing ALSA to fail prematurely.
+	 *
+	 * Affected models (all use vendor 0x07fd):
+	 *   - MicroBook IIc          → 0x0004
+	 *   - 1248, 624, 8A, UltraLite AVB, 8M, 16A, ... → 0x0005
 	 */
-	if (chip->usb_id == USB_ID(0x07fd, 0x0004)) {
+	if (chip->usb_id == USB_ID(0x07fd, 0x0004) ||  /* MicroBook IIc */
+	    chip->usb_id == USB_ID(0x07fd, 0x0005)) {  /* 1248 / 624 / 8A / UltraLite AVB / ... */
 		count = 0;
 
 		while ((!ret) && (count < 50)) {
-- 
2.53.0

