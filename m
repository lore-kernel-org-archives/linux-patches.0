Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864D127713;
	Tue,  9 Jul 2024 11:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524418; cv=none; b=rffTvhkUNoBgCibalPP183H+ldfScRsEJjTVHwNqmFjyFGTkP4p1soC+xrDywVFIaOWCq/qAjDTgl31IixyqvSt9q7jR3FG1pod6NV61MMbcVF9YQpP9VgDtyTuVt72rlsQJqNQUPUHTOJ25+eX02tgLWCkV0WOJLn+pERyivsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524418; c=relaxed/simple;
	bh=Jv1eG//8koTusrXg6vDKCu533q6BYiBJGNKzQL6UM/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDsBdl6aCFymBFv/Y3sLIKKQhSBqqSOkpbpX/sMYlzJ9q5IgXzLrpf8vYFOAieLPZfjwSlXx6LPRbeJw8UlxzgEeXqPHhAKhxiCjEQXPfg5d0LQvdtIZQQACx12NMiO/U/LMmp6yuJWPGaFP9s0OPTuAiPaFjkFkYBfEnjc9Eoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SltF9VtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SltF9VtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BA6C32786;
	Tue,  9 Jul 2024 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524418;
	bh=Jv1eG//8koTusrXg6vDKCu533q6BYiBJGNKzQL6UM/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SltF9VtVFD1o/I7FoMsncvu0vSFZFJRzksW1gxdu2kP2Gynur7I2QXYn4E9taFdaH
	 GRFTc3vcxmwZxbAOGBOIp6Poz+NaLia4HEQ4FfKunSUSK+toEZ2tNgvINWucLJPuhK
	 veR4WCDNujLEN2IC5PSxUNxCnEsAkuUI1J+ngbak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian-Hong Pan <jhp@endlessos.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 176/197] ALSA: hda/realtek: Enable headset mic of JP-IK LEAP W502 with ALC897
Date: Tue,  9 Jul 2024 13:10:30 +0200
Message-ID: <20240709110715.757608868@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian-Hong Pan <jhp@endlessos.org>

[ Upstream commit 45e37f9ce28d248470bab4376df2687a215d1b22 ]

JP-IK LEAP W502 laptop's headset mic is not enabled until
ALC897_FIXUP_HEADSET_MIC_PIN3 quirk is applied.

Here is the original pin node values:

0x11 0x40000000
0x12 0xb7a60130
0x14 0x90170110
0x15 0x411111f0
0x16 0x411111f0
0x17 0x411111f0
0x18 0x411111f0
0x19 0x411111f0
0x1a 0x411111f0
0x1b 0x03211020
0x1c 0x411111f0
0x1d 0x4026892d
0x1e 0x411111f0
0x1f 0x411111f0

Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Link: https://lore.kernel.org/r/20240520055008.7083-2-jhp@endlessos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3a56434c86bd9..c0530d4aa3fc3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12029,6 +12029,7 @@ enum {
 	ALC897_FIXUP_LENOVO_HEADSET_MODE,
 	ALC897_FIXUP_HEADSET_MIC_PIN2,
 	ALC897_FIXUP_UNIS_H3C_X500S,
+	ALC897_FIXUP_HEADSET_MIC_PIN3,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -12475,10 +12476,18 @@ static const struct hda_fixup alc662_fixups[] = {
 			{}
 		},
 	},
+	[ALC897_FIXUP_HEADSET_MIC_PIN3] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x03a11050 }, /* use as headset mic */
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1019, 0x9087, "ECS", ALC662_FIXUP_ASUS_MODE2),
+	SND_PCI_QUIRK(0x1019, 0x9859, "JP-IK LEAP W502", ALC897_FIXUP_HEADSET_MIC_PIN3),
 	SND_PCI_QUIRK(0x1025, 0x022f, "Acer Aspire One", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x0241, "Packard Bell DOTS", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x0308, "Acer Aspire 8942G", ALC662_FIXUP_ASPIRE),
-- 
2.43.0



