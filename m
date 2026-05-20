Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60E83DC4CF;
	Wed, 20 May 2026 11:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276014; cv=none; b=BCiHq1sHoJ1ob1PkGD9OqbbEpQt5E0x7u7HTnrqGZt34v4IBwRAWcSIHLOHDJbryl6gwBL4YlOljXDEhrdOkPdSLkW4jj3G0kQn59dwC8d8pMqRA0LdDrU6KefbbzsoDf6r8S625w4yIvbGxl18JFJsfqoC04PoMYC8XsDVQbz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276014; c=relaxed/simple;
	bh=bYEAJZLZvjaQGGWWgBivvYd49X8IbAv/9B2lQ9MS10E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pc2bSxk0ynrPzlGT7qVi06Hc1JRpVck9xVAcVh3kP3VtxLuRjHkxBun1VVNzVDFatVhqn6O+PpPX+xGHh/aDQKaf6py9GryQOY7upje4Yd16IitLeqOzyIy8321YzXJ5vtWrWH3lfpKH9DTd62dBY84MxcKjr/tvYSRgcqP5xJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PyP/9Fdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PyP/9Fdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC04D1F00898;
	Wed, 20 May 2026 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276008;
	bh=WwcJ4MhtGZGnFzVpPs2B/62wLXslgGAVo58iwceQ0YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyP/9FdzwEsIuYy/mBhttkZh/b8oNhDS36L4EbxnhS+V6ngY8rX2VB9HKga0sad1+
	 SagshktGzeWuPrOSzum2l0TYRFhENwsn2ajMJtaBkX+ZnB/ksVX0NzXYlYcxX9YvxM
	 tE01j78oL3QjfrRQnfru+9xJruoUgVuw9v6t3bQFuFVzjV2aYdlBzAsVCIijQDYyIq
	 sQskYeNvwed2vfYCquoiesk35bNla9ABRzyL9ednq/P5vmEWD+28TnbWsiQqXSnnTb
	 vw83uetvJftG0LzfjAzJuDpYO5igGLfcEKjYTjVocPorRj2UVnPq5yGkOGD4QyrNgL
	 41Qi6mzOjZnWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jackie Dong <xy-jackie@139.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] ALSA: hda/realtek: ALC269 fixup for Lenovo Yoga Pro 7 15ASH111 audio
Date: Wed, 20 May 2026 07:18:49 -0400
Message-ID: <20260520111944.3424570-17-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jackie Dong <xy-jackie@139.com>

[ Upstream commit 83dca2530fb3ba63f47bad339d890bc30aa06ab5 ]

Volume control for the speakers on the Lenovo Yoga Pro 7 15ASH11 laptop
doesn't work.
The DAC routing is the same as on the ThinkPad X1 Gen7 function, so reuse
the alc285_fixup_thinkpad_x1_gen7 to get it working.

Signed-off-by: Jackie Dong <xy-jackie@139.com>
Link: https://patch.msgid.link/20260514153940.7320-1-xy-jackie@139.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
Phase 1 Record:
1. Subject: subsystem `ALSA: hda/realtek`; action `fixup`; intent is to
   fix Lenovo Yoga Pro 7 15ASH11 speaker volume control.
2. Tags: `Signed-off-by: Jackie Dong`, `Link:
   https://patch.msgid.link/20260514153940.7320-1-xy-jackie@139.com`,
   `Signed-off-by: Takashi Iwai`. No `Fixes`, `Reported-by`, `Tested-
   by`, `Reviewed-by`, or stable Cc tag.
3. Body: the reported bug is that speaker volume control does not work
   on Lenovo Yoga Pro 7 15ASH11. Root cause explanation given: DAC
   routing matches the ThinkPad X1 Gen7 routing case, so the existing
   routing fixup is reused.
4. Hidden bug fix: yes. Although phrased as a “fixup”, this is a
   hardware-specific quirk correcting broken speaker mixer/routing
   behavior.

Phase 2 Record:
1. Inventory: one file, `sound/hda/codecs/realtek/alc269.c`; one line
   added to `alc269_fixup_tbl`; single-file surgical hardware quirk.
2. Hunk behavior: before, PCI SSID `17aa:38fc` had no matching Realtek
   fixup entry. After, it maps to `ALC245_FIXUP_BASS_HP_DAC`.
3. Bug mechanism: hardware workaround / audio codec quirk. Verified
   `ALC245_FIXUP_BASS_HP_DAC` calls `alc285_fixup_thinkpad_x1_gen7`,
   which overrides DAC routing for NID `0x17`, sets preferred DAC pairs,
   and renames confusing volume controls.
4. Fix quality: obviously small and contained. Regression risk is very
   low because matching is limited to Lenovo PCI SSID `17aa:38fc`.

Phase 3 Record:
1. Blame: the added line is from candidate commit `83dca2530fb3b`;
   adjacent Lenovo quirk-table entries mostly come from earlier Realtek
   table history. Candidate is contained in `v7.1-rc4`.
2. Fixes tag: none, so no introducing commit to follow.
3. Related file history: recent `alc269.c` history is dominated by
   similar Realtek laptop quirk fixes. Related Lenovo Yoga Pro 7 quirks
   exist for 14IMH9 and 14IAH10.
4. Author history: Jackie Dong has this one Realtek commit in the
   checked history. Takashi Iwai committed it; `MAINTAINERS` lists
   Takashi Iwai as SOUND maintainer.
5. Dependencies: `ALC245_FIXUP_BASS_HP_DAC` was introduced by
   `e347430182492` in mainline and exists in `stable/linux-7.0.y`;
   `stable/linux-6.19.y` has an equivalent backport `3c756e813f212`.
   Older checked stable branches lack that symbol and need a
   dependency/backport adjustment.

Phase 4 Record:
1. `b4 dig -c 83dca2530fb3b` found the original thread at the supplied
   patch URL.
2. `b4 dig -a` found v1 and v2; v2 is the committed version. The v2
   change was “Use `ALC245_FIXUP_BASS_HP_DAC` instead of creating a new
   quirk.”
3. `b4 dig -w` showed ALSA maintainers/lists and Lenovo contact were
   included.
4. Saved thread shows Takashi Iwai replied “Applied now”, with only a
   minor subject-line modification. No NAKs or risk objections were
   present in the matched thread.
5. Lore WebFetch searches were blocked by Anubis; WebSearch found
   related Yoga Pro audio issues but no additional specific 15ASH11
   report. Stable-list WebFetch was also blocked.

Phase 5 Record:
1. Modified object: `alc269_fixup_tbl` static quirk table.
2. Callers: `alc269_probe()` calls `snd_hda_pick_fixup()` with
   `alc269_fixup_tbl`; `alc269_probe()` is installed via
   `alc269_codec_ops`; ALC245 is listed in `snd_hda_id_alc269`.
3. Callees/effects: `snd_hda_pick_fixup()` matches PCI SSID first, then
   selects the fixup ID. `snd_hda_apply_fixup(...PRE_PROBE)` applies it
   before auto-parse.
4. Reachability: reachable during HDA codec probe on systems with
   Realtek ALC245/compatible hardware and PCI SSID `17aa:38fc`; normal
   boot/device initialization path.
5. Similar patterns: the table contains many Lenovo and other laptop
   Realtek quirks; `ALC245_FIXUP_BASS_HP_DAC` is already used for
   Minisforum V3 SE.

Phase 6 Record:
1. Stable presence: `stable/linux-7.0.y` and `stable/linux-6.19.y`
   contain the generic fixup but lack the new `17aa:38fc` entry.
   `stable/linux-6.18.y` and older checked branches lack
   `ALC245_FIXUP_BASS_HP_DAC`, though they do have ALC245 support and
   the underlying ThinkPad routing helper.
2. Backport difficulty: clean/simple for 7.0.y and 6.19.y. Older
   branches need either the generic fixup dependency or a small
   equivalent backport, and 6.12.y/older use
   `sound/pci/hda/patch_realtek.c` rather than the split path.
3. Related stable fixes: searches of 7.0.y and 6.19.y found no existing
   15ASH11 quirk.

Phase 7 Record:
1. Subsystem: ALSA HDA Realtek codec driver, driver-specific but common
   laptop audio path; criticality is important for affected hardware,
   not core-wide.
2. Activity: recent history shows many similar Realtek laptop quirk
   fixes, so this fits active subsystem practice.

Phase 8 Record:
1. Affected users: owners of Lenovo Yoga Pro 7 15ASH11 with PCI SSID
   `17aa:38fc`.
2. Trigger: normal audio use after codec probe; users see speaker volume
   control not working. No verified security or crash trigger.
3. Severity: medium functional regression/hardware enablement issue; not
   a panic/corruption bug.
4. Risk-benefit: benefit is high for the affected laptop; risk is very
   low because the change is a single SSID-scoped quirk using an
   existing fixup.

Phase 9 Record:
1. Evidence for: real user-visible audio control failure, hardware-
   specific quirk exception, one-line scoped change, existing fixup
   reused, ALSA maintainer applied, v2 incorporated review feedback.
2. Evidence against: not a crash/security/data-corruption fix; older
   stable branches may need prerequisite/backport adjustment.
3. Stable rules: obviously correct yes; fixes real user-visible bug yes;
   important issue yes under hardware quirk/workaround policy; small and
   contained yes; no new API yes; applies cleanly to trees with existing
   `ALC245_FIXUP_BASS_HP_DAC`, otherwise needs minor dependency
   handling.
4. Exception category: hardware-specific audio codec quirk. Decision:
   backport.

## Verification
- [Phase 1] `git show --format=fuller 83dca2530fb3b` verified subject,
  body, tags, author, committer, and one-line diff.
- [Phase 2] Diff verified one insertion in `alc269_fixup_tbl`:
  `SND_PCI_QUIRK(0x17aa, 0x38fc, ..., ALC245_FIXUP_BASS_HP_DAC)`.
- [Phase 3] `git blame origin/master -L 7762,7768` verified the
  candidate line attribution.
- [Phase 3] `git describe --contains 83dca2530fb3b` verified inclusion
  in `v7.1-rc4`.
- [Phase 3] `git log -S"ALC245_FIXUP_BASS_HP_DAC"` verified the generic
  fixup came from `e347430182492`.
- [Phase 4] `b4 dig -c`, `-a`, `-w`, and saved mbox verified the v1/v2
  thread, recipients, and Takashi’s “Applied now” reply.
- [Phase 5] Reads of `alc269.c` and `auto_parser.c` verified probe-time
  PCI SSID matching and fixup application.
- [Phase 6] Stable branch checks verified 7.0.y and 6.19.y have the
  generic fixup and lack `17aa:38fc`; older checked branches lack the
  generic fixup symbol.
- [Phase 8] Failure mode is verified from the commit body: speaker
  volume control does not work. No crash/security impact was verified.

This should be backported, with dependency/backport adjustment for trees
that do not yet have `ALC245_FIXUP_BASS_HP_DAC`.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 7e0289a1a1ca7..4e0885c1fc496 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7722,6 +7722,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38df, "Y990 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
+	SND_PCI_QUIRK(0x17aa, 0x38fc, "Lenovo Yoga Pro 7 15ASH11", ALC245_FIXUP_BASS_HP_DAC),
 	SND_PCI_QUIRK(0x17aa, 0x38fd, "ThinkBook plus Gen5 Hybrid", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-- 
2.53.0

