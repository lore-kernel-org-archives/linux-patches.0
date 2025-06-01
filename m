Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C4827CCEB;
	Sun,  1 Jun 2025 23:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820530; cv=none; b=ikuNUe6mqV/QoEDjSmtZJ+iycC3zmMPjAZeAqDBGfVjIwYTSPckHweHOD0VGRgO22+bjSSP+ZHM/q3kMI/pGKV32dtj9AaCqa33uf7PlLjgsCZrIXZLP2SKtWjzJCwNo41YI228WEQd8xQyGusHzxfYaCNXxMwNOBZMqcdNBYMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820530; c=relaxed/simple;
	bh=xt1922hGTLaMdflCLOntAvppka8T3QMYTAxfOubtOSc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QcpH8XOf9m+dEzGdQqa42f+vClw4642wKPoVDFIRhmzuW0Tff78uXp8JndugFGt9ZV3KVAbfnmNQjBSVjl3rhBbsPgtow9XZfnWPUzLJNaYog9nkVOrEO8PfdMmaYo2zL15/S2qk3oKnXxPS4XQOpQ0Nd/El26Us9ZMpJiq5wMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rC+c9D+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rC+c9D+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9E8C4CEE7;
	Sun,  1 Jun 2025 23:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820530;
	bh=xt1922hGTLaMdflCLOntAvppka8T3QMYTAxfOubtOSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rC+c9D+qK2KGql3q+2y8EGME5cuQREcRxWxBbsok75B5SniKmZLlq/vccluLsogNP
	 emdWuAoQ03JIR+xX4W+YutNrM9YkOO9hGAw0iWAy3CG3+U6AY2bj5cbMpa7p7c1nsO
	 sHWeW1expijrhu16OlWqEqFgchrEsGvvT9zKNX+q/2k42v6hILx5pyBMcUeLrP/uib
	 7Z9BpFyEdtjHI9yaZM2QNKVMRlWjx7Qv7jsJGACqfnX5ek9U4cQhYPbasiFHg/Eecx
	 jRUCiVaxcPVq2xYhGRWVBvXkiH+L3OpJDYZXQ4VnyX3U9wF4LcMrQU/VIM+4gSl1Dm
	 y/9qZwkF6nTtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	kailang@realtek.com,
	simont@opensource.cirrus.com,
	josh@joshuagrisham.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 088/110] ALSA: hda/realtek: Add support for Acer Helios Laptops using CS35L41 HDA
Date: Sun,  1 Jun 2025 19:24:10 -0400
Message-Id: <20250601232435.3507697-88-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232435.3507697-1-sashal@kernel.org>
References: <20250601232435.3507697-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
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

Based on my analysis of the commit and comparing it to similar commits
that were marked with "Backport Status: YES", I can now provide my
assessment: **YES** This commit should be backported to stable kernel
trees. **Detailed Analysis:** **Code Changes Analysis:** 1. **Enum
Addition**: The commit adds `ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2` to
the enum list at line 8029, which is a standard pattern for adding new
HDA fixups. 2. **Fixup Implementation**: Lines 9303-9307 add the actual
fixup implementation: ```c [ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2] = {
.type = HDA_FIXUP_FUNC, .v.func = cs35l41_fixup_i2c_two, .chained =
true, .chain_id = ALC255_FIXUP_PREDATOR_SUBWOOFER }; ``` This follows
the exact same pattern as existing CS35L41 fixups in the codebase. 3.
**Device Quirks**: Lines 10444-10446 add three new Acer Helios laptop
models: ```c SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC",
ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2), SND_PCI_QUIRK(0x1025, 0x182c,
"Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
SND_PCI_QUIRK(0x1025, 0x1844, "Acer Helios ZPS",
ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2), ``` **Comparison to Similar
Commits:** This commit is nearly identical in structure and purpose to
Similar Commits #1-4, which were all marked with "Backport Status: YES".
Like those commits: - It adds hardware support for specific laptop
models - Uses existing CS35L41 infrastructure (`cs35l41_fixup_i2c_two`
function) - Chains to existing predator subwoofer fixup
(`ALC255_FIXUP_PREDATOR_SUBWOOFER`) - Makes minimal, contained changes -
Follows established patterns for HDA audio fixups **Backport
Suitability:** 1. **Important Bug Fix**: This enables audio
functionality on specific Acer Helios laptop models that would otherwise
have non-functional speakers 2. **Small and Contained**: The changes are
minimal and isolated to the realtek patch file 3. **Low Risk**: Uses
existing, well-tested CS35L41 and predator subwoofer code paths 4. **No
Architectural Changes**: Simply adds new device IDs and combines
existing fixups 5. **Hardware Enablement**: Essential for users with
these specific laptop models The commit message indicates this adds
support for CS35L41 amplifiers with I2C interface and external boost,
which is critical for proper audio functionality on these laptops.
Without this fix, users would have non-functional speakers on these
specific Acer Helios models. This follows the stable tree criteria
perfectly: it's an important hardware enablement fix with minimal risk
of regression.

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

