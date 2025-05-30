Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC59233128;
	Fri, 30 May 2025 12:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608752; cv=none; b=kovz5GYjFZTHIBPOBNWNWq7z23eDYnFLd9kT51FdrtEn40KjRtSEhfJjC9T64WTaobJ1Y7FJY/3PriuwcIzxCm7Q+8C3wZKOKMHK1rIfPv8WKCSNKwxkBKTfc2FBCLr5z8S9hmZ1K6rKZAHTyiPdslEe1IAZmILog8snScFlc+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608752; c=relaxed/simple;
	bh=lTIFbvUzVtrdoyRg87m1jXHUYMw1CfmB2wmzwJv1abU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RtFN9vZZQKgdRvGzfG8uoGOhfbQDkdefe+gcRxRJGZ2hC8aYKnILchHLbSm7YBjSQyP+DWt/5P/GlAjLSOgpM2wEGTSSP7z7/3hs1FfroiQKWeVHRln1j5stg9+RxsUByW90VrByUBBP2jupi1LliyXzCSYhMBM5aBGjU7tQoc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ttCOqqwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ttCOqqwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF19C4CEEB;
	Fri, 30 May 2025 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608751;
	bh=lTIFbvUzVtrdoyRg87m1jXHUYMw1CfmB2wmzwJv1abU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttCOqqwb4zy0D/vfC2sHm+oZJ9yINNruHUIKdfafEGtFhunjQUD5rK0OWgCIhp0LK
	 f75CS417JFYx/xpN6E9U0J1H8EjmcIQxDD4p2kKvMa6ksdn9gD/DKykUZ86SmHWxDH
	 JKicwSqyocifwuX/8QzsqMMc5Kcs8281rGyi6jYqvNOfq2fSYNv+N4nNeQqCvMKa5x
	 DtJG+h1Vnx3kzcn+XNI8zpcHdWkOxILIPnYgpmO21j/23xDL1qY0do0IzWng8Sz8ep
	 YM8PcbWvzSEGCU1bFdSSC97+AbHSqNRvXI0jCsR4VjUmWvRttU5cCX+6OQApZFcBQY
	 EAYWo+qWxNWpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	kailang@realtek.com,
	gregkh@linuxfoundation.org,
	edson.drosdeck@gmail.com,
	oder_chiou@realtek.com,
	desikumar81@gmail.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 14/30] ALSA: hda/realtek: Add support for Acer Helios Laptops using CS35L41 HDA
Date: Fri, 30 May 2025 08:38:36 -0400
Message-Id: <20250530123852.2574030-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530123852.2574030-1-sashal@kernel.org>
References: <20250530123852.2574030-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit d64cbb5ed9227566c068ac9300a85912234d10aa ]

Laptops use 2 CS35L41 Amps with HDA, using External boost with I2C.
Similar to previous Acer laptops, these laptops also need the
ALC255_FIXUP_PREDATOR_SUBWOOFER quirk to function properly.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250515162848.405055-2-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. ##
Analysis ### What the commit does: This commit adds audio support for
Acer Helios laptops using CS35L41 HDA amplifiers. The specific changes
are: 1. **Adds new enum**: `ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2` 2.
**Adds new fixup entry**: Chains `cs35l41_fixup_i2c_two` with the
existing `ALC255_FIXUP_PREDATOR_SUBWOOFER` quirk 3. **Adds 3 PCI quirk
entries** for specific Acer models: - `0x1025, 0x1826, "Acer Helios
ZPC"` - `0x1025, 0x182c, "Acer Helios ZPD"` - `0x1025, 0x1844, "Acer
Helios ZPS"` ### Comparison with approved similar commits: This commit
follows **exactly the same pattern** as the four similar commits marked
"YES": - **Similar Commits #1-4**: All added PCI quirk entries for ASUS
laptops using CS35L41 HDA, with identical structure - **Same approach**:
Extending the quirk table to map new hardware IDs to existing, proven
fixup mechanisms - **Same scope**: Hardware-specific audio support using
well-established CS35L41 amplifier functionality ### Hardware support vs
bug fixing: This is **new hardware support** that enables audio
functionality on specific Acer Helios laptop models. The CS35L41
amplifier support and ALC255_FIXUP_PREDATOR_SUBWOOFER quirk already
exist - this simply extends support to new hardware variants. ### Risk
assessment: **Very low risk** because: 1. **Isolated impact**: Only
affects the three specific Acer Helios models listed (PCI IDs 0x1826,
0x182c, 0x1844) 2. **No architectural changes**: Pure quirk table
additions with no modifications to core audio logic 3. **Proven fixup
chain**: Both `cs35l41_fixup_i2c_two` and
`ALC255_FIXUP_PREDATOR_SUBWOOFER` are existing, stable fixups 4. **No
regression risk**: Doesn't modify behavior for any existing hardware ###
Stable kernel criteria alignment: ✅ **Fixes important bugs**: Enables
audio functionality that would otherwise be broken on these laptops ✅
**No new features**: Uses existing CS35L41 and Predator subwoofer
infrastructure ✅ **No architectural changes**: Only extends PCI quirk
tables ✅ **Minimal regression risk**: Changes are completely isolated to
specific hardware IDs ✅ **Subsystem-confined**: Limited to ALSA HDA
realtek driver quirks This commit perfectly matches the established
pattern of stable-worthy ALSA HDA hardware support commits and should be
backported to ensure audio functionality works properly for users with
these Acer Helios laptops.

 sound/pci/hda/patch_realtek.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 20ab1fb2195ff..cd0d7ba7320ef 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8029,6 +8029,7 @@ enum {
 	ALC283_FIXUP_DELL_HP_RESUME,
 	ALC294_FIXUP_ASUS_CS35L41_SPI_2,
 	ALC274_FIXUP_HP_AIO_BIND_DACS,
+	ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9301,6 +9302,12 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		}
 	},
+	[ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_i2c_two,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_PREDATOR_SUBWOOFER
+	},
 	[ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -10456,6 +10463,9 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
+	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1025, 0x1844, "Acer Helios ZPS", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
-- 
2.39.5

