Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BA16FAF;
	Tue,  5 Dec 2023 03:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjvKCeNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB00C433CA;
	Tue,  5 Dec 2023 03:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746837;
	bh=sYfdqpfXYqW7yMugmceXKhJD5zUut7YQ0K1EqIZwRRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjvKCeNfsy/cMuc2uZOnclKfPErIlJJjoOKk0RchdxRydUv1khFA7fxRCOTLbpXgP
	 hmZWGCrHh7LUj9WXJv50OlUb6PvCLYc7li/ZOQWB3eIvq9hMY62lLsqvp0QfTjxtLM
	 AK/zj9YQyhYaxt8HFZDKah4igmrnJ4v0gXIrjOw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 38/71] ALSA: hda/realtek: Headset Mic VREF to 100%
Date: Tue,  5 Dec 2023 12:16:36 +0900
Message-ID: <20231205031520.057134535@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit baaacbff64d9f34b64f294431966d035aeadb81c upstream.

This platform need to set Mic VREF to 100%.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/0916af40f08a4348a3298a9a59e6967e@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1917,6 +1917,7 @@ enum {
 	ALC887_FIXUP_ASUS_AUDIO,
 	ALC887_FIXUP_ASUS_HMIC,
 	ALCS1200A_FIXUP_MIC_VREF,
+	ALC888VD_FIXUP_MIC_100VREF,
 };
 
 static void alc889_fixup_coef(struct hda_codec *codec,
@@ -2470,6 +2471,13 @@ static const struct hda_fixup alc882_fix
 			{}
 		}
 	},
+	[ALC888VD_FIXUP_MIC_100VREF] = {
+		.type = HDA_FIXUP_PINCTLS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x18, PIN_VREF100 }, /* headset mic */
+			{}
+		}
+	},
 };
 
 static const struct snd_pci_quirk alc882_fixup_tbl[] = {
@@ -2539,6 +2547,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x106b, 0x4a00, "Macbook 5,2", ALC889_FIXUP_MBA11_VREF),
 
 	SND_PCI_QUIRK(0x1071, 0x8258, "Evesham Voyaeger", ALC882_FIXUP_EAPD),
+	SND_PCI_QUIRK(0x10ec, 0x12d8, "iBase Elo Touch", ALC888VD_FIXUP_MIC_100VREF),
 	SND_PCI_QUIRK(0x13fe, 0x1009, "Advantech MIT-W101", ALC886_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte EP45-DS3/Z87X-UD3H", ALC889_FIXUP_FRONT_HP_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1458, 0xa0b8, "Gigabyte AZ370-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),


