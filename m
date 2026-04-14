Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF653DD535;
	Tue, 14 Apr 2026 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165922; cv=none; b=u5cMSE0PqX4uEBg5JpxDEi/uzSfRpyaNLz+VJWLUM2kkZVD20ZmXCQ4l67fvQCcdiVi3k0FThhtDE4Smlwt+j1A/mEDK30/MDCF8pQhoB01V8glxwtS2mgAwgvyuiYa9CVKYMgA9VgGCU98PC7bPznGlEwBA6gkl14e7KZus0y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165922; c=relaxed/simple;
	bh=eJ4IrVXHQAYcEuU5xTdgqvm7FzCBunhqyztIZT0ThCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LsLT12kW/8v592xsah9VgxRr6GfFNLnKAwN7DQ13qDSMpurs8alpGEc3CGyZfTxY313SZPJdM4kth+iEOunmNoRfNxKMSKntO5+ZarDL4zdblSh4dgu4cIxVoDxut0v3iBYak10FUkgUfCfHsuwkgnCtzpkwDEotGCl31ip7Puo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ct1b/7tc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ct1b/7tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5C3C2BCB0;
	Tue, 14 Apr 2026 11:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776165921;
	bh=eJ4IrVXHQAYcEuU5xTdgqvm7FzCBunhqyztIZT0ThCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ct1b/7tcEUzMtLvKnZz09bN9muv2sqwHSDqORPERjOjYDPfDzDasUwebTgFxMK8zh
	 fEKlGOr1YPpqI3XqlDYDiVy49Jr+5iJFYGIBbzzXNfc3ucK3E+7uCdTPtfwefU6kU3
	 6eqhdq+R7gqcGOCXIj0eTAxy3BYPdFOxJqw6McX9J1iWG9AczhT71sEfWNhaVGsFf7
	 uLnEjAgisgecMHTOxJRixMCtr2fPF8SQ36/8KPICrQouAeKgsQFztdFe0G+lKrUkSB
	 uNHJB8LmuOGUdzft8ovrk0Bmbo2/SKsu39+1ni9xk+bXBVUeNHM0bE0v9F+K2TfsKV
	 bGkG0omaLtanw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: songxiebing <songxiebing@kylinos.cn>,
	Fernando Garcia Corona <fgarcor@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IAH10
Date: Tue, 14 Apr 2026 07:25:04 -0400
Message-ID: <20260414112509.410217-8-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414112509.410217-1-sashal@kernel.org>
References: <20260414112509.410217-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.12
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: songxiebing <songxiebing@kylinos.cn>

[ Upstream commit f0541edb2e7333f320642c7b491a67912c1f65db ]

The bass speakers are not working, and add the following entry
in /etc/modprobe.d/snd.conf:
options snd-sof-intel-hda-generic hda_model=alc287-yoga9-bass-spk-pin
Fixes the bass speakers.

So add the quick ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN here.

Reported-by: Fernando Garcia Corona <fgarcor@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221317
Signed-off-by: songxiebing <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260405012651.133838-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The fixup `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` was introduced in
v6.0-rc1, so it exists in all active stable trees (6.1.y, 6.6.y, 6.12.y,
etc.).

Record: [Fixup function exists since v6.0, present in all active stable
trees. Clean apply expected — this is a simple table entry addition.]

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- **Subsystem:** ALSA/HDA — audio codec driver (IMPORTANT category —
  affects laptop users)
- **Maintainer:** Takashi Iwai (signed off) — the ALSA subsystem
  maintainer himself accepted this
- **Activity:** Very active — constant stream of quirk additions

Record: [ALSA/HDA, IMPORTANT criticality, accepted by subsystem
maintainer]

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
Users of Lenovo Yoga Pro 7 14IAH10 laptops running Linux.

### Step 8.2: TRIGGER CONDITIONS
Every boot — bass speakers simply don't work without this quirk.

### Step 8.3: FAILURE MODE SEVERITY
Without the quirk: bass speakers are non-functional. This is a hardware
enablement issue.
Severity: MEDIUM (hardware not working, but has a workaround via
modprobe.d).

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** HIGH — makes bass speakers work automatically for all
  users of this laptop
- **Risk:** ESSENTIALLY ZERO — 1-line table entry, only affects matching
  PCI SSID, uses proven fixup function
- **Ratio:** Excellent — high benefit, near-zero risk

Record: [High benefit, zero risk, clear positive ratio]

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE
**FOR backporting:**
- Hardware quirk addition — explicit exception category for stable
- 1 line change, zero regression risk
- Uses well-tested fixup already applied to 7+ other Lenovo models
- Real user report with bugzilla entry
- Accepted by ALSA subsystem maintainer Takashi Iwai
- Fixup function exists in all active stable trees (since v6.0)
- Fixes non-working hardware for real users

**AGAINST backporting:**
- (None identified)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — identical pattern to many
   existing entries, user-confirmed workaround
2. Fixes a real bug? **YES** — bass speakers don't work
3. Important issue? **YES** — hardware doesn't function properly
4. Small and contained? **YES** — 1 line
5. No new features or APIs? **YES** — just a table entry
6. Can apply to stable? **YES** — the fixup function exists since v6.0

### Step 9.3: EXCEPTION CATEGORIES
This falls into the **Audio Codec Quirk** exception category —
`SND_PCI_QUIRK` entries for specific laptop models. These are explicitly
listed as automatic YES for stable.

## Verification

- [Phase 1] Parsed tags: Reported-by real user, Closes bugzilla link,
  maintainer SOB (Takashi Iwai)
- [Phase 2] Diff analysis: +1 line SND_PCI_QUIRK table entry in
  alc269_fixup_tbl[]
- [Phase 3] git log -S: ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN
  introduced in commit 3790a3d6dbbc4 (v6.0-rc1)
- [Phase 3] Grep: fixup used by 7+ other Lenovo devices (lines 7571,
  7591, 7604, 7607, 7614, 7643, 7927)
- [Phase 3] Recent file history: constant stream of similar quirk
  additions
- [Phase 6] Fixup exists since v6.0, present in all active stable trees
  (6.1.y, 6.6.y, 6.12.y)
- [Phase 7] Accepted by ALSA maintainer Takashi Iwai
- [Phase 8] Failure mode: non-functional bass speakers, severity MEDIUM,
  zero regression risk

This is a textbook stable backport candidate — a single-line hardware
quirk addition to an existing driver, using an already-proven fixup
function, fixing real hardware for real users, with zero regression
risk.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index cb39054bfe79c..c023ca273b6d9 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7641,6 +7641,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38fd, "ThinkBook plus Gen5 Hybrid", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_TXNW2781_I2C),
-- 
2.53.0

