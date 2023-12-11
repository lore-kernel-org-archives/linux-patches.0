Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FF020DDE;
	Mon, 11 Dec 2023 18:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOIn4X2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8238BC433C8;
	Mon, 11 Dec 2023 18:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319951;
	bh=vdK5dNqMN/UXkeR/9kDXzldaV6gjhG/4WDvvfER0bq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOIn4X2HH6Jd2RCWg55jL1veKHXVMlPASPFo6nzYdNAWJo8g9Y9mGqjPyjOluHEGc
	 6VuFKJ95olBhNIIt2HhlSkMqczGjEZP5iknuExOcTDYHlzuqHeHuhPxS6tg+21jVqZ
	 uNHk1nrEjYV6YPsC1cQBL/N5i3jP5aP5Od8+pjKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Li <bin.li@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 48/97] ALSA: hda/realtek: Enable headset on Lenovo M90 Gen5
Date: Mon, 11 Dec 2023 19:21:51 +0100
Message-ID: <20231211182021.779671736@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bin Li <bin.li@canonical.com>

commit 6f7e4664e597440dfbdb8b2931c561b717030d07 upstream.

Lenovo M90 Gen5 is equipped with ALC897, and it needs
ALC897_FIXUP_HEADSET_MIC_PIN quirk to make its headset mic work.

Signed-off-by: Bin Li <bin.li@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231204100450.642783-1-bin.li@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11227,6 +11227,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x17aa, 0x32f7, "Lenovo ThinkCentre M90", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3321, "Lenovo ThinkCentre M70 Gen4", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x331b, "Lenovo ThinkCentre M90 Gen4", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3364, "Lenovo ThinkCentre M90 Gen5", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3742, "Lenovo TianYi510Pro-14IOB", ALC897_FIXUP_HEADSET_MIC_PIN2),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),


