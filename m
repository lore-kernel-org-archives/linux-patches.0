Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C440C2E7386;
	Wed, 30 Sep 2026 18:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794746; cv=none; b=NjoiMRCc3DcrNCf5/C58VoUq+YP1QajxM4vTuXmUbRAqk8fccImbpERNLChvPdyEyRyf+1e/4h2lbZfyZhjZr1SnKX8X/i6mWPpLX2TZh+rQDVmSH9GAocolvt9pjVKVN+GKa/UNvUAjyFyJk3LxB+uHO/ifM8ySc6v8xCNElc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794746; c=relaxed/simple;
	bh=l1moqItBLgE5uwKvO9H2hbltNhVzVTcHS2u2J3CY2No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmzlOp+TYp58Iplcd0kfl3dWww9afNTAoMxQ3PKWz6QuIlDP97CCWMZJ9Aucf34Ea4hSHuc+PKPl9m5yW8pYKgXmJdqm8QVWiy3RNJ/7m5tp7PZvQcm2C7pDPrwtioPFyCO7BzYzqtPng5By4nw+2iSekS2Db5Um+cRxIQfK1Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMhNAD9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMhNAD9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB86B1F000FF;
	Wed, 30 Sep 2026 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794745;
	bh=kHUCWdiKr4R4tSKdaMdJ7jFq8R36xUmnjgrH4uoZm34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMhNAD9RRu/qFlBRoTiWwVEA+VbQJstIh6V85cKLDPpc/Fsq4zx1EOGMKoInFg+lh
	 Va061OWoIt0Nyk+63izGgSd7esq0B55vSPJjINXUW0dYQfGBPwy3Lz1f9mnlG+grY9
	 +8ZPAw/00eR+eZc1ph5e6MePCzidbKgb4fxPQAQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0317/1193] ALSA: hda/realtek: Add quirk for HP Pavilion x360
Date: Wed, 30 Sep 2026 17:16:41 +0200
Message-ID: <20260930152441.182217128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 02bbbf05d19f49c5cc9f249dd8844b2a7f2a2b8c ]

HP Pavilion x360 sets a bogus PCI SSID (103c:0000), hence the driver
picks up a wrong quirk entry, resulting in an almost silent output.
And yet, the existing quirk for x390 doesn't seem sufficing, and we
need the extra setup for the amp.

This patch adds the quirk entry for the codec SSID (103c:8486) to
initialize the amp via COEF verbs and chains to the existing quirk for
another x360 model to address the silent output.

Closes: https://lore.kernel.org/CAF2ktaUW2oaWwGazGtJQ3o1JyE2R4O2xPd-Dchr=qqi7_QRruQ@mail.gmail.com
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260716064916.540616-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1f98c1845bb4e..fb28935e1952e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7494,6 +7494,7 @@ enum {
 	ALC256_FIXUP_HUAWEI_MACH_WX9_PINS,
 	ALC298_FIXUP_HUAWEI_MBX_STEREO,
 	ALC295_FIXUP_HP_X360,
+	ALC295_FIXUP_HP_PAVILION_X360,
 	ALC221_FIXUP_HP_HEADSET_MIC,
 	ALC285_FIXUP_LENOVO_HEADPHONE_NOISE,
 	ALC295_FIXUP_HP_AUTO_MUTE,
@@ -8753,6 +8754,19 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HP_MUTE_LED_MIC3
 	},
+	[ALC295_FIXUP_HP_PAVILION_X360] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* force amp gain and processing state */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x07 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x7770 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x0d },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x3000 },
+			{}
+		},
+		.chained = true,
+		.chain_id = ALC295_FIXUP_HP_X360
+	},
 	[ALC221_FIXUP_HP_HEADSET_MIC] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -10073,6 +10087,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x82c0, "HP G3 mini premium", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x841c, "HP Pavilion 15-CK0xx", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	HDA_CODEC_QUIRK(0x103c, 0x8486, "HP Pavilion x360", ALC295_FIXUP_HP_PAVILION_X360),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84a6, "HP 250 G7 Notebook PC", ALC269_FIXUP_HP_LINE1_MIC1_LED),
 	SND_PCI_QUIRK(0x103c, 0x84ae, "HP 15-db0403ng", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0



