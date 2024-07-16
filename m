Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFE11DDCE;
	Tue, 16 Jul 2024 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146308; cv=none; b=s4u+eHtkoy8iCtiQEEIxOaWhLdxnfJF2ZSmUZyblyGEuSZ37jT25XOrsm90o9LPNhcXzl8vsy5AFxM3MDpogo9S3SUz24+19s8zd+GuICzQ92qFDaOruCVzjPB9inFR3GDIBIQREKTIO1UtAtLOQCDgHPp79TbBmyi86sqpIUgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146308; c=relaxed/simple;
	bh=FQ2lwE2VdUcdXyXIgRjpEpQJ1WrkUoDanRdGb13sqe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5RwlaQDUzS5iKaIqJTlWWS7Yhq+btrAalUvau1eg7Lix8iW+B14Jqr5HGv4YtcUEzYNvAydGw/bJn8vYaE0FJyG9UERZKKaSuwj8pn6N38OBDDPGLxmR/NpGc5ssSHJaGieDmJLiDL2ql5m72n6eqeD846By7PYrzUcHIyJ+qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7cDTN+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7cDTN+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56D8C116B1;
	Tue, 16 Jul 2024 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146308;
	bh=FQ2lwE2VdUcdXyXIgRjpEpQJ1WrkUoDanRdGb13sqe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7cDTN+JzsHikkLSdB+oEUrtpGbDvkFXC8C9m719aoOI6K3vQhP6nDTMWLWbyLLYl
	 6sP4J46PUB2vsXmWsRM4I98sgoPozspcnmpkFuu8qZLSxV2W/lro12RI0cmcHEOMnv
	 +VBLk490A2KsgbLm6g7PGjZ7gIBlDOd1BfgQ3dV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nazar Bilinskyi <nbilinskyi@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 122/144] ALSA: hda/realtek: Enable Mute LED on HP 250 G7
Date: Tue, 16 Jul 2024 17:33:11 +0200
Message-ID: <20240716152757.212603246@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nazar Bilinskyi <nbilinskyi@gmail.com>

commit b46953029c52bd3a3306ff79f631418b75384656 upstream.

HP 250 G7 has a mute LED that can be made to work using quirk
ALC269_FIXUP_HP_LINE1_MIC1_LED. Enable already existing quirk.

Signed-off-by: Nazar Bilinskyi <nbilinskyi@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240709080546.18344-1-nbilinskyi@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9122,6 +9122,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x841c, "HP Pavilion 15-CK0xx", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	SND_PCI_QUIRK(0x103c, 0x84a6, "HP 250 G7 Notebook PC", ALC269_FIXUP_HP_LINE1_MIC1_LED),
 	SND_PCI_QUIRK(0x103c, 0x84ae, "HP 15-db0403ng", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),


