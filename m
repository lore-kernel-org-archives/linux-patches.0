Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886A436A03D;
	Mon, 23 Feb 2026 12:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850300; cv=none; b=WBy8irGzpg1k2Lj35EcGnnzz1PNiManhIBk3JGpE09hK6NYtlWglfMcMHrkMeA459ACvbWfD0GXAnStW75ESOPZoRTsLFripGl5EQinqRk+vx5/eLF2V3vKk1v0c1mq0SZGU/MmC7ytQqkCtWfkThJJxtL/ID4nGd0zo2VVRdoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850300; c=relaxed/simple;
	bh=w0IZ/Kw3ri4vlwORCYYUX68W5h+gtKmT9vmml1pTib8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gc1tdRC6LP7X2Tp7tVeSV1FDLEg8QjlQY/2O/5PCx9yPHIzr1Nbv201uI/4uphRbbVTE5x6gwO5nwtSWFFR8pyfBm0EZ8VHjnpCSf/KbtQ1Ih0NozmTedkE1gvyGQfnci/bjIzDaxwiKXtqqOoNUmR276t4Q7iepDW9PdlTYB6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UoU8QDO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UoU8QDO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48260C116C6;
	Mon, 23 Feb 2026 12:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850300;
	bh=w0IZ/Kw3ri4vlwORCYYUX68W5h+gtKmT9vmml1pTib8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoU8QDO9QhX08vDjZUGYytsHeWtgAB6Tt6oHbox9Qolsy+fJXTRrciwFs8jCKxhUV
	 jfcPVEkqHkB8zLLiGP0PFaSijV6kiF7gstI5QKYP7IO9uZHEGTPoeCQZyB/55+4sX0
	 aWfkit5KzEcvTL7ircYonSgoG2ZQHy5NGxytUUA9yQ6is0PDKCCkTdBUhw7m2oSiG4
	 G2N1aYUnG+CHw1UNu5sNKhphPIxEyTEW+nFJNPuoIKc3Pq97sYh6Yl3ja9tU2erQW/
	 2p5mGCfeTOHKYavRY6m193MAinfHqkVygvYNoPDcTByv2pRDnRoclgPYfPfCgOjbDg
	 mmoemH6kKcDFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Erik Sanjaya <sirreidlos@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14 UX3405MA
Date: Mon, 23 Feb 2026 07:37:32 -0500
Message-ID: <20260223123738.1532940-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Transfer-Encoding: 8bit

From: Erik Sanjaya <sirreidlos@gmail.com>

[ Upstream commit 91062e119b4eafde553c894ca072cd615a6dae2e ]

The ASUS Zenbook 14 UX3405MA uses an ALC294 codec with CS35L41
amplifiers over SPI. The existing quirk for this model only configured
the amplifiers, leaving the headset microphone on the combo jack
non-functional.

Introduce a new fixup that configures pin 0x19 as headset mic input
and chains to ALC245_FIXUP_CS35L41_SPI_2 to preserve speaker
functionality.

Similar to the fix done for the UM3406HA in commit 018f659753fd
("ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14").

Signed-off-by: Erik Sanjaya <sirreidlos@gmail.com>
Link: https://patch.msgid.link/20260217102112.20651-1-sirreidlos@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14
UX3405MA

### What the commit does

This commit fixes a non-functional headset microphone on the ASUS
Zenbook 14 UX3405MA laptop. The device uses an ALC294 codec with CS35L41
amplifiers over SPI. The existing quirk (`ALC245_FIXUP_CS35L41_SPI_2`)
only configured the amplifiers for speakers, but didn't configure pin
0x19 for headset mic input.

The fix:
1. Adds a new fixup entry `ALC294_FIXUP_ASUS_SPI_HEADSET_MIC` that
   configures pin 0x19 as headset mic input and chains to
   `ALC245_FIXUP_CS35L41_SPI_2` (preserving speaker functionality)
2. Changes the quirk table entry for `0x1043:0x1a63` (ASUS UX3405MA)
   from `ALC245_FIXUP_CS35L41_SPI_2` to the new
   `ALC294_FIXUP_ASUS_SPI_HEADSET_MIC`

### Classification: Hardware Quirk Fix

This falls squarely into the **audio codec quirk** category, which is
explicitly listed as stable-worthy material. It's a `SND_PCI_QUIRK`
entry change for a specific laptop model, following the exact same
pattern as many other ASUS headset mic fixes in the same file.

### Stable Kernel Criteria Assessment

1. **Obviously correct and tested**: The pattern is identical to the
   existing `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC` (for the UM3406HA) and
   `ALC294_FIXUP_ASUS_HEADSET_MIC` fixups. The commit references a
   similar prior fix (commit 018f659753fd). The new fixup simply adds
   pin configuration and chains to the existing SPI amplifier fixup.

2. **Fixes a real bug**: Yes - the headset microphone on this specific
   laptop model is completely non-functional without this fix.

3. **Important issue**: Headset mic non-functionality is a significant
   usability issue for laptop users (video calls, voice recording,
   etc.).

4. **Small and contained**: The change adds ~10 lines for the new fixup
   entry, 1 line for the enum, and changes 1 line in the quirk table.
   Total impact is minimal.

5. **No new features**: This is a hardware quirk/workaround, not a new
   feature. It makes existing hardware work correctly.

6. **Applies cleanly**: The change is self-contained within a single
   file and follows established patterns.

### Risk Assessment

- **Very low risk**: The change only affects the specific ASUS UX3405MA
  laptop (PCI SSID `0x1043:0x1a63`). No other hardware is affected.
- **Well-established pattern**: This is the same pattern used for dozens
  of other ASUS laptop quirk fixes in this file.
- **Chains to existing fixup**: `ALC245_FIXUP_CS35L41_SPI_2` already
  exists in the codebase; the new fixup just adds pin configuration
  before chaining to it.

### Verification

- Reviewed the diff: The new `ALC294_FIXUP_ASUS_SPI_HEADSET_MIC` fixup
  follows the exact same structure as
  `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC` (visible in the diff context at
  the lines just above), differing only in the pin config value and
  chain target (SPI vs I2C).
- The quirk table change at line 7192 (old) / 7202 (new) replaces
  `ALC245_FIXUP_CS35L41_SPI_2` with `ALC294_FIXUP_ASUS_SPI_HEADSET_MIC`
  for the specific SSID `0x1043:0x1a63`.
- The commit message explicitly states the problem (headset mic non-
  functional) and the solution (pin configuration + chaining to existing
  SPI fixup).
- The commit has been accepted by the ALSA maintainer Takashi Iwai,
  confirming it is correct.
- The referenced similar fix for UM3406HA
  (`ALC294_FIXUP_ASUS_I2C_HEADSET_MIC`) is visible in the diff context,
  confirming the pattern is established.
- Could NOT verify whether the prerequisite `ALC245_FIXUP_CS35L41_SPI_2`
  and related enum entries exist in all stable trees (unverified), but
  this fixup has been in the kernel for several releases and is very
  likely present.

### Conclusion

This is a textbook audio codec quirk fix for a specific laptop model. It
fixes a real user-facing bug (non-functional headset mic), is small and
self-contained, follows established patterns, carries essentially zero
regression risk (only affects one specific hardware model), and has been
reviewed and accepted by the subsystem maintainer.

**YES**

 sound/hda/codecs/realtek/alc269.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b66965a521076..b560cc013e53e 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3652,6 +3652,7 @@ enum {
 	ALC294_FIXUP_ASUS_MIC,
 	ALC294_FIXUP_ASUS_HEADSET_MIC,
 	ALC294_FIXUP_ASUS_I2C_HEADSET_MIC,
+	ALC294_FIXUP_ASUS_SPI_HEADSET_MIC,
 	ALC294_FIXUP_ASUS_SPK,
 	ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 	ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
@@ -4997,6 +4998,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC287_FIXUP_CS35L41_I2C_2
 	},
+	[ALC294_FIXUP_ASUS_SPI_HEADSET_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x04a11020 }, /* use as headset mic */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC245_FIXUP_CS35L41_SPI_2
+	},
 	[ALC294_FIXUP_ASUS_SPK] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -6927,7 +6937,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
-	SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA", ALC294_FIXUP_ASUS_SPI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1a83, "ASUS UM5302LA", ALC294_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1a8e, "ASUS G712LWS", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x1043, 0x1a8f, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),
-- 
2.51.0

