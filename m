Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397753ED101;
	Wed, 20 May 2026 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276031; cv=none; b=Jz/B8JDWif+LoUgld1JnUoFNqSm/To8IgztJ4Mf11KHvloDfN76nlnV66yLiwHvyMYKS+F5EeFghj21P+m//okCdGKoFkzw5/hAkK+CZuNiYaGymrmbwhH7xtN6qzDjD2Hx/GyLAG4hOYzyk4oNFvVH3pO02RoshmGeoJdM4Fsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276031; c=relaxed/simple;
	bh=/f1dkoMOYh2RR1CObnbD2BmpdshIha+UVPZO2IBiPlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gDQfI22nloFEscwASYkcwje/5zbf7MurQPKhT0+wOkyt7hkUNXDCLxDjVPWMXgoknxVEKMb68FUmMbeLonPOHLQmtR2TCff9SiDCMc0Gqos+kfjkhRw2sQobTFd0z3Mfww7dCKr7KJWtaUY/pFXju9QEbgfLhwjBLSnN4TfL/88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjJnj0Iu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjJnj0Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2151F00893;
	Wed, 20 May 2026 11:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276029;
	bh=Uh5pQeh7zolaDZ4VFIzk+6i9+Br/yH8uwlk6r6E+oBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjJnj0IuCsjdRVU+nzbLTEyfrYZzN0Co3TNTEtmyOEcjtxjk0gVV4GCnE6HsIRAOd
	 qB3DYUV/LfjbOdQpNByhegAmxtwmeB2NWRX0C5/G47oGFit7U2HNSjrGcwMDyYWE/K
	 PO/z8H6b+ZKZlvREyaSnL82fw0THPCuJMrreqj3qAIwKCNMoKlTSNe4qb6tmXOEBhk
	 VZ8dPT0d2uY6nLCjZZC0utaoaBDwD14wfRCaP8NMM3k3wyaHDey5j+Qr9teNZePRm7
	 ARhaCswPnfB22qugJJWEKj/bLqE7n5rAZkYzuIpaYl70OKFBLH68VOItu5ipH+SA3H
	 hR8lmWMyWNsIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] ALSA: hda/realtek: Limit mic boost on Positivo DN50E
Date: Wed, 20 May 2026 07:19:03 -0400
Message-ID: <20260520111944.3424570-31-sashal@kernel.org>
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

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

[ Upstream commit d02d2d51a50d1bbf44a50eda094aa2b10fecf023 ]

The internal mic boost on the Positivo DN50E is too high.
Fix this by applying the ALC269_FIXUP_LIMIT_INT_MIC_BOOST fixup to the machine
to limit the gain.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Link: https://patch.msgid.link/20260511181558.670563-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Stable Backport Analysis

### Phase 1: Commit Message Forensics
Record 1.1: Subsystem is `ALSA: hda/realtek`; action is “Limit” / “Fix”;
claimed intent is to cap excessive internal microphone boost on Positivo
DN50E.

Record 1.2: Tags present are `Signed-off-by: Edson Juliano Drosdeck`,
`Link: https://patch.msgid.link/20260511181558.670563-1-
edson.drosdeck@gmail.com`, and `Signed-off-by: Takashi Iwai`. No
`Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or
`Cc: stable` tag was present.

Record 1.3: The described bug is excessive internal mic boost on this
machine. The existing fixup comment verifies the mechanism: boost levels
2 and 3 are “too noisy” on internal mic input, so the fixup limits boost
to levels 0 or 1.

Record 1.4: This is not a hidden bug fix; it is an explicit hardware
quirk for a user-visible audio problem.

### Phase 2: Diff Analysis
Record 2.1: One file changes: `sound/hda/codecs/realtek/alc269.c`, 1
insertion, no deletions. The modified object is the `alc269_fixup_tbl`
quirk table. Scope is a single-line, single-driver hardware quirk.

Record 2.2: Before the change, PCI SSID `0x1e50:0x7007` had no matching
quirk. After the change, `snd_hda_pick_fixup()` can select
`ALC269_FIXUP_LIMIT_INT_MIC_BOOST` for Positivo DN50E.

Record 2.3: Bug category is hardware quirk/workaround. The existing
fixup runs at `HDA_FIXUP_ACT_PROBE`, finds internal mic pins, and calls
`snd_hda_override_amp_caps()` to limit mic boost steps.

Record 2.4: Fix quality is high: one table entry, no new logic, no API
change. Regression risk is very low and limited to machines with that
exact PCI SSID.

### Phase 3: Git History Investigation
Record 3.1: There is no buggy code line to blame; the bug is a missing
quirk entry. I verified the existing `ALC269_FIXUP_LIMIT_INT_MIC_BOOST`
machinery is present in checked stable tags including `v4.19`, `v5.4`,
`v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.19`, and `v7.0`.

Record 3.2: No `Fixes:` tag is present, so there was no introducing
commit to follow.

Record 3.3: Recent history of this file shows frequent Realtek HDA quirk
additions and fixes. No prerequisite commit was identified for this
patch beyond the already-existing fixup.

Record 3.4: The author has multiple prior accepted Realtek HDA quirks
for Positivo and VAIO systems, including Positivo ARN50, P15X, K116J,
C6400, and SU C1400.

Record 3.5: The patch is functionally standalone. Older stable trees
before the 2025 file move use `sound/pci/hda/patch_realtek.c`, so those
need a path/context backport. A direct `git apply --check` against the
current checked-out 7.0 stable tree failed due context drift, not
missing functionality.

### Phase 4: Mailing List And External Research
Record 4.1: The exact standalone commit hash was not present in local
history, so `b4 dig -c <commit>` could not be used as specified. `b4 am`
by message-id found one patch and a two-message thread. The maintainer
reply from Takashi Iwai says “Applied now. Thanks.” No NAKs or concerns
were present.

Record 4.2: The original recipients included Takashi Iwai, Jaroslav
Kysela, Zhang Heng, Stefan Binding, Kailang Yang, `linux-
sound@vger.kernel.org`, and `linux-kernel@vger.kernel.org`.

Record 4.3: No separate bug report was found. Web search confirmed
public hardware data for Positivo DN50E and related Positivo mic-boost
patches.

Record 4.4: Related patches exist for the same fixup pattern, including
Positivo ARN50 and N14AP7 in git history, plus a public Positivo DN50F
patch using the same fixup.

Record 4.5: I found no stable-specific discussion or explicit stable
nomination.

### Phase 5: Code Semantic Analysis
Record 5.1: No function body is modified. Affected code paths are
`alc269_fixup_tbl`, `snd_hda_pick_fixup()`, `snd_hda_apply_fixup()`, and
`alc269_fixup_limit_int_mic_boost()`.

Record 5.2: `alc269_probe()` calls `snd_hda_pick_fixup()` with
`alc269_fixup_tbl`, then later calls `snd_hda_apply_fixup(codec,
HDA_FIXUP_ACT_PROBE)`.

Record 5.3: Key callees are `snd_hda_codec_get_pincfg()`,
`snd_hda_get_input_pin_attr()`, and `snd_hda_override_amp_caps()`.

Record 5.4: The path is reached automatically during HDA codec probe on
matching hardware. The bad behavior affects internal mic capture; it is
not a syscall-triggered crash/security issue.

Record 5.5: Similar uses of `ALC269_FIXUP_LIMIT_INT_MIC_BOOST` are
already present for many laptops, including other Positivo systems.

### Phase 6: Stable Tree Analysis
Record 6.1: The reusable fixup exists in all checked stable tags from
`v4.19` through `v7.0`; the DN50E entry itself was absent in checked
tags.

Record 6.2: Backport difficulty is low but not always clean apply:
`v6.19+` uses `sound/hda/codecs/realtek/alc269.c`, while older trees use
`sound/pci/hda/patch_realtek.c`.

Record 6.3: I found no existing DN50E fix in checked stable tags or
current local history.

### Phase 7: Subsystem Context
Record 7.1: Subsystem is ALSA HDA Realtek codec support. Criticality is
driver-specific, but important for affected laptop audio users.

Record 7.2: The subsystem is active, with many recent quirk additions in
the same file. The pattern is mature and widely used.

### Phase 8: Impact And Risk
Record 8.1: Affected population is users of Positivo DN50E systems with
Realtek HDA audio.

Record 8.2: Trigger is normal codec probe plus internal microphone use.
It is not an unprivileged security trigger.

Record 8.3: Failure mode is user-visible broken audio quality from
excessive internal mic gain/noise. Severity is medium for affected
hardware, not crash-level.

Record 8.4: Benefit is high for affected hardware users. Risk is very
low because this adds one exact-match PCI SSID quirk using existing
code.

### Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: hardware quirk exception, one-line
targeted change, existing tested fixup machinery, maintainer applied it,
related Positivo fixes use the same pattern. Evidence against: no
separate bug report/test tag and direct apply may need context/path
adjustment. Unresolved: exact upstream commit hash was not available
locally, and no independent DN50E test report beyond the submitter’s
patch text was found.

Record 9.2: Stable rules: obviously correct: yes; fixes a real user-
visible hardware bug: yes; important enough under hardware-quirk
exception: yes; small and contained: yes; no new APIs/features: yes;
stable apply: yes with likely minor path/context adjustment on older
trees.

Record 9.3: Exception category applies: hardware-specific
quirk/workaround in an existing driver.

Record 9.4: This should be backported. The patch is exactly the type of
low-risk Realtek HDA laptop quirk that stable trees routinely carry.

## Verification
- Phase 1: Parsed the supplied commit message and b4 mbox; confirmed
  tags and absence of `Fixes:` / stable / reporter tags.
- Phase 2: Read the patch mbox; confirmed 1 insertion in
  `alc269_fixup_tbl`.
- Phase 3: Used `git grep` across stable tags to confirm
  `ALC269_FIXUP_LIMIT_INT_MIC_BOOST` exists and DN50E is absent.
- Phase 3: Checked author history; found multiple accepted Positivo/VAIO
  Realtek HDA quirk commits.
- Phase 4: `b4 am` found the patch and thread; full mbox showed Takashi
  Iwai replied “Applied now.”
- Phase 4: Web searches found related Positivo DN50F/ARN50 mic-boost
  patches and a DN50E hardware listing.
- Phase 5: Read `snd_hda_pick_fixup()`, `snd_hda_apply_fixup()`,
  `alc269_probe()`, and `alc269_fixup_limit_int_mic_boost()` to verify
  call flow and behavior.
- Phase 6: Checked `v4.19`, `v5.4`, `v5.10`, `v5.15`, `v6.1`, `v6.6`,
  `v6.12`, `v6.19`, and `v7.0` for fixup availability and file paths.
- Unverified: exact final upstream commit hash was not available in
  local history, and no separate user bug report was found.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 4e0885c1fc496..b1fb5e1cf0078 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7799,6 +7799,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1e39, 0xca14, "MEDION NM14LNL", ALC233_FIXUP_MEDION_MTL_SPK),
+	SND_PCI_QUIRK(0x1e50, 0x7007, "Positivo DN50E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f4c, 0xe001, "Minisforum V3 (SE)", ALC245_FIXUP_BASS_HP_DAC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0

