Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CAD611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076B7C4339C;
	Sun, 28 May 2023 19:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301660;
	bh=Twf2qty+y0C3DnrihkGryYjT9AncWKe0VXU1xeoFMo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=On3FT2Mxh3lvRtQoj42JNwVejldPQKzs8oOWhXGkindHPT/UyNMNJDpVgzQwz3twa
	 2JUPZQEliK1rHS7JAT6WPq/NvfGAPgM6sozXz1QcGu/QWWoqJKI5QmE7SI8C0JkLSk
	 aDeDZDY5QR+8x/8jdi0DoCF4IkR6ONVYejOjXjqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian-Hong Pan <jian-hong@endlessm.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/132] ALSA: hda/realtek - Enable headset mic of Acer X2660G with ALC662
Date: Sun, 28 May 2023 20:10:28 +0100
Message-Id: <20230528190836.310290377@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jian-Hong Pan <jian-hong@endlessm.com>

[ Upstream commit d858c706bdca97698752bd26b60c21ec07ef04f2 ]

The Acer desktop X2660G with ALC662 can't detect the headset microphone
until ALC662_FIXUP_ACER_X2660G_HEADSET_MODE quirk applied.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200317082806.73194-2-jian-hong@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 90670ef774a8 ("ALSA: hda/realtek: Add a quirk for HP EliteDesk 805")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a47946b4b22e1..f361bfd86846c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8648,6 +8648,7 @@ enum {
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
 	ALC671_FIXUP_HP_HEADSET_MIC2,
+	ALC662_FIXUP_ACER_X2660G_HEADSET_MODE,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -9005,6 +9006,15 @@ static const struct hda_fixup alc662_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc671_fixup_hp_headset_mic2,
 	},
+	[ALC662_FIXUP_ACER_X2660G_HEADSET_MODE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1a, 0x02a1113c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC662_FIXUP_USI_FUNC
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -9016,6 +9026,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x0349, "eMachines eM250", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
+	SND_PCI_QUIRK(0x1025, 0x124e, "Acer 2660G", ALC662_FIXUP_ACER_X2660G_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1028, 0x05d8, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x05db, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x05fe, "Dell XPS 15", ALC668_FIXUP_DELL_XPS13),
-- 
2.39.2



