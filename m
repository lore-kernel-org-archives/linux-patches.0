Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532108C06
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5C1C433C0;
	Mon, 19 Jun 2023 11:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172411;
	bh=yzJwUkaPvVFLgyhDpqaU3cqKFscMMNjsabCwJ31bjKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLSikvBzg4PjCvY+qv/GtzW+qrsPYsuozeoCbpIEb9xMhXxzZADqxt0ZYESxfmhp/
	 +dnLeNO6hg6eTGYuMToq3KqtfEgFp5qGkboH31XvwmuUoWetRvnlZhHUuxreh4wlum
	 wUhS8HDFk+/jSJ6uUbdtDJZA5PY/S2FQH7L7dhfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 051/107] ALSA: hda/realtek: Add a quirk for Compaq N14JP6
Date: Mon, 19 Jun 2023 12:30:35 +0200
Message-ID: <20230619102143.938801658@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
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
@@ -11287,6 +11287,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1b0a, 0x01b8, "ACER Veriton", ALC662_FIXUP_ACER_VERITON),
 	SND_PCI_QUIRK(0x1b35, 0x1234, "CZC ET26", ALC662_FIXUP_CZC_ET26),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
+	SND_PCI_QUIRK(0x1c6c, 0x1239, "Compaq N14JP6-V2", ALC897_FIXUP_HP_HSMIC_VERB),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


