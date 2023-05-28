Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3AD569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDB4C433D2;
	Sun, 28 May 2023 19:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302148;
	bh=+HyKeF7UemH5qvbVsZDQV7KjY2Ng0nHx4Q7AWORy3Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP+/UOu88c/B7rmljVy8wEaxbklX3bGzygFDm4+HNLNM8DKSiKCLaSTeQoRScIE9T
	 0ycnAmR7Ss8iCc5Xizj+m23uWyrv8F3ZxhCouOZyKGJ/KoW3bqi9hvb1kVMZL8dgd8
	 u9WJwwTI3OmFd17jy8yTahKhpLUvJth02rAbqyeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Li <bin.li@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.3 019/127] ALSA: hda/realtek: Enable headset onLenovo M70/M90
Date: Sun, 28 May 2023 20:09:55 +0100
Message-Id: <20230528190836.858112953@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bin Li <bin.li@canonical.com>

commit 4ca110cab46561cd74a2acd9b447435acb4bec5f upstream.

Lenovo M70/M90 Gen4 are equipped with ALC897, and they need
ALC897_FIXUP_HEADSET_MIC_PIN quirk to make its headset mic work.
The previous quirk for M70/M90 is for Gen3.

Signed-off-by: Bin Li <bin.li@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230524113755.1346928-1-bin.li@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11699,6 +11699,8 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x17aa, 0x32cb, "Lenovo ThinkCentre M70", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cf, "Lenovo ThinkCentre M950", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32f7, "Lenovo ThinkCentre M90", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3321, "Lenovo ThinkCentre M70 Gen4", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x331b, "Lenovo ThinkCentre M90 Gen4", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3742, "Lenovo TianYi510Pro-14IOB", ALC897_FIXUP_HEADSET_MIC_PIN2),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),


