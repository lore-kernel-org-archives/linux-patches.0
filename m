Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D289D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1808C433EF;
	Mon, 12 Jun 2023 10:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566964;
	bh=e6h7ezBfQxf3SpLekI03YTp+/3sYIf3ZR1MfP2Q9c9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Elbn+nMDfKvj5vKu0tExuJWADgi9Jc0y+TKM8DhRxZy0LlAb/Y5oiwTuU5PTO2o4e
	 XDfY4lpBLt4eLQ+jEOb9VWhsi8O2Hl3/SS5iIT+rJoNFK7mYcgX4ei5CgIWhL6Af3S
	 fM/Z3lH4I3NLTain+jT7kNd+ASn39qdmbnxZ0M+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.3 081/160] ALSA: hda/realtek: Add a quirk for HP Slim Desktop S01
Date: Mon, 12 Jun 2023 12:26:53 +0200
Message-ID: <20230612101718.712524917@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ai Chao <aichao@kylinos.cn>

commit 527c356b51f3ddee02c9ed5277538f85e30a2cdc upstream.

Add a quirk for HP Slim Desktop S01 to fixup headset MIC no presence.

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230526094704.14597-1-aichao@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11695,6 +11695,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x872b, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
+	SND_PCI_QUIRK(0x103c, 0x8768, "HP Slim Desktop S01", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x877e, "HP 288 Pro G6", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x885f, "HP 288 Pro G8", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x1043, 0x1080, "Asus UX501VW", ALC668_FIXUP_HEADSET_MODE),


