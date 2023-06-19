Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863E55381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03585C433C8;
	Mon, 19 Jun 2023 10:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170944;
	bh=8oY3D+RIKGPL5ElnSwxsDlpQj5rp1X61q6uYoOUHvE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/BabWUkSu9BSrcRQlz8bG30Q4OQ7cA1VMd2UU0pQGwV8DKvUDTsOybNv5Iba6cEI
	 nBcuDOxLw0/pV5Vgni/HLa3+XR5hgVQyDGIXrG/eDhTBj2nOpanY54vMn9AhMM6V3a
	 oGb7cLCQwlWcYQw9TZkySZj2kNTbV7m7xPJY8yzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.3 091/187] ALSA: hda/realtek: Add a quirk for Compaq N14JP6
Date: Mon, 19 Jun 2023 12:28:29 +0200
Message-ID: <20230619102202.008093832@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

commit a2a871483161014f1bcc4e9a04354b01aa77cedb upstream.

Add a quirk for Compaq N14JP6 to fixup ALC897 headset MIC no sound.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230609201058.523499-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11738,6 +11738,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1b0a, 0x01b8, "ACER Veriton", ALC662_FIXUP_ACER_VERITON),
 	SND_PCI_QUIRK(0x1b35, 0x1234, "CZC ET26", ALC662_FIXUP_CZC_ET26),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
+	SND_PCI_QUIRK(0x1c6c, 0x1239, "Compaq N14JP6-V2", ALC897_FIXUP_HP_HSMIC_VERB),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


