Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21802DF15E;
	Sun, 26 Oct 2025 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490275; cv=none; b=guvFX9TQlZZV2efrq+otAcnnPSePMtdLyJNz4G1wHxQKoT7tdDAk3gL/nJlAUOhX7rEQhx6/9H0zFVMnnIJdEZRaiuf8A6WD5P4UC/igKCQ/8RHC4ebUWMKiPp4gqEMgUdP1Ep4usQF1CZ/0dFjiHQqVsf3oIMMZBR4kFeBbJnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490275; c=relaxed/simple;
	bh=UhPJlnk6oqzw+kXq9UF+FRHpyVYBOApiknhaNghX/Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sVYcjUSwvwZCJ9t4AXNDFUOwCM6bhlrnEGxyPKPf4xJkLkEX3U/kjHBovkEnvKQfpWYVrEbJghldxffYKNirUHrA/+rdWeiM9Lms+x6CMC9i/7QbSxQmS+QCY9lQdpLBb8ZTeg66/frPqL10GpezYtsA31A7LgJnr8T62m8zup8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pmd2uNgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmd2uNgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AC1C4CEE7;
	Sun, 26 Oct 2025 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490275;
	bh=UhPJlnk6oqzw+kXq9UF+FRHpyVYBOApiknhaNghX/Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmd2uNgWLLvB5xjkVMjxf8Oe6ECC+cHXtpg+/JvPqJkQK0OtqdoEfxmnsmyMxNMWG
	 1RMuZ6bgQDQZONCkEECPWDZ67kNaXJMUi9m1NR6PMros2B1V0pCT6kriF6DvTmBq7j
	 Ub6zPIlf7yIxIyo7PNnZU4k1QMwKKC0d7+HraDBC1hIsRJ658TpU7HU/AsCw4sIttb
	 Wow1sih+d6KJ7afPpxalEgAl7DV3zzR+qX85T3ronpEYyiDv3cszzJnSfqpgvrE6ZN
	 3fEr3Dd0cSQRuE/zTwwBALllugr82i9xs1wEgAtGEDzsbTPxLykDiaK2nn3murN0/o
	 bI/NHixKrmRhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adam Holliday <dochollidayxx@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.17] ALSA: hda/realtek: Add quirk for ASUS ROG Zephyrus Duo
Date: Sun, 26 Oct 2025 10:49:12 -0400
Message-ID: <20251026144958.26750-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adam Holliday <dochollidayxx@gmail.com>

[ Upstream commit 328b80b29a6a165c47fcc04d2bef3e09ed1d28f9 ]

The ASUS ROG Zephyrus Duo 15 SE (GX551QS) with ALC 289 codec requires specific
pin configuration for proper volume control. Without this quirk, volume
adjustments produce a muffled sound effect as only certain channels attenuate,
leaving bass frequency at full volume.

Testing with hdajackretask confirms these pin tweaks fix the issue:
- Pin 0x17: Internal Speaker (LFE)
- Pin 0x1e: Internal Speaker

Signed-off-by: Adam Holliday <dochollidayxx@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – The change cleanly fixes a user-visible volume-control bug on the
ASUS ROG Zephyrus Duo 15 SE without touching other systems and should be
backported.

- `sound/hda/codecs/realtek/alc269.c:3740` appends a new enum ID
  `ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK` at the end of the fixup list, so
  no previously assigned indices shift, keeping existing quirks stable.
- `sound/hda/codecs/realtek/alc269.c:6170-6177` defines the quirk body
  with `HDA_FIXUP_PINS`, remapping pins 0x17/0x1e to the internal
  speaker and LFE path; these values match Realtek conventions
  (`0x9017015x`) and correct the bass channel attenuation defect
  reported in the commit message.
- `sound/hda/codecs/realtek/alc269.c:6733` wires the PCI SSID
  `0x1043:0x1652` for the GX551QS to the new fixup, tightly scoping the
  change to the affected laptop; other ASUS entries keep their existing
  fixups.
- No functional dependencies or architectural changes accompany the
  quirk—other ALC289 platforms retain their existing chains, and the new
  entry is not chained to anything else, keeping regression risk
  minimal.
- The bug is significant (volume slider leaves bass at full power) and
  has been validated with hdajackretask, so stable users of this
  hardware gain a real fix with negligible downside.

Given the targeted scope, tiny code delta, and user-facing impact, the
patch satisfies stable backport criteria. Suggested next step: queue for
the relevant supported stable series.

 sound/hda/codecs/realtek/alc269.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 8fb1a5c6ff6df..28297e936a96f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3737,6 +3737,7 @@ enum {
 	ALC285_FIXUP_ASUS_GA605K_HEADSET_MIC,
 	ALC285_FIXUP_ASUS_GA605K_I2C_SPEAKER2_TO_DAC1,
 	ALC269_FIXUP_POSITIVO_P15X_HEADSET_MIC,
+	ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6166,6 +6167,14 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE,
 	},
+	[ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x17, 0x90170151 }, /* Internal Speaker LFE */
+			{ 0x1e, 0x90170150 }, /* Internal Speaker */
+			{ }
+		},
+	}
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -6721,6 +6730,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1652, "ASUS ROG Zephyrus Do 15 SE", ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.51.0

