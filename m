Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32761171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70225C433C9;
	Mon, 21 Aug 2023 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648163;
	bh=adNeTA6UCBMGs89uy7+1mM07DmILyAIlGVuqun5oPU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEGe0yub1R+jGRvPlGWa6XOzCXPorUWTgBZ1P5LZxxd1Yk1lNl47DO4NvR6Qz8uM+
	 MOI/Eizs/wczS8dPE49koMSeSSJcUuitA90XC0yM29DEiOGmK0LKEu6c+GB8TURxaz
	 OXXvVP+UA5Wchyvemx2jbfFTGDSOtrnDr/Qg6yTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 078/234] ALSA: hda/realtek: Add quirk for ASUS ROG G614Jx
Date: Mon, 21 Aug 2023 21:40:41 +0200
Message-ID: <20230821194132.210392132@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 33d7c9c3bf70ed91191a2bedbbc03783b824b5de ]

Adds the required quirk to enable the Cirrus amp and correct pins
on the ASUS ROG G614J series which uses an SPI connected Cirrus amp.

While this works if the related _DSD properties are made available, these
aren't included in the ACPI of these laptops (yet).

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20230704044619.19343-5-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1d0f43017f255..9278362e4edb2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9657,6 +9657,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1c62, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
+	SND_PCI_QUIRK(0x1043, 0x1c9f, "ASUS G614JI", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1caf, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1d1f, "ASUS ROG Strix G17 2023 (G713PV)", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.40.1



