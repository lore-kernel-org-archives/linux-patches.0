Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060967;
	b=5EDOA+ob4KwENg0QI7tWHPica8ucXphGKXZgm/ND4LmzoVDKE+o3e6LWuiJ+AEkJU8gW
	 J4jPPHgQFLw29Nt7Mq91lcAjb+oSZrXjXe5M8ru/KIC69h+ItZ5sjXyX+az06CTosTscL
	 kAB9nwOdStsxcDuMJihwnZ9T1mh0qaU23aR6GxUdQZ6LpWB4FJiCu6XZGJMVAKDg+MB6m
	 250dklToUUNqyaCuyUElrd49f/Dx+dWZVrkgth70pZXlv/bQ2wIOeLuUmLM0VMdcf3isd
	 NlkNTG9M3LxWcBoInkjI2qjGohnPzXlPT0IOorTbtCB6ofjAeurcGkhlVD9jQniJifA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lUPdChVahaCPqNHLRLyOZj182uqC+/jWol4/THIEUyw=;
	b=rkFab1NU9xd9wwRf531MqsObNR0Uq4O8Juhd0w1Cv+FGAiG8EFwFdcHKtBdGxlFCOs4X
	 jt+QUQS06+WxHyIlYGXmvvZWk6o12X0Y2eaJ/4HC5ZLEARtlq51ICvsDbf9mZaMIkFZch
	 wMTlaT6/p82POG+fruIGjkHXnC+bbT6EMzavnPJTYVuQY/PAM1WsEno0dVyt0Gp7IDkaX
	 pRhZwLtCQjKlMrpNn8o2I5u1cXNzi/ObpyykB8Hhe+oj6HGNxc+TwNkpE330BrD+92mYN
	 wHhkmZx20OqzvM3JYoBzLk/DGQWd0/cQ/4LQQHs5h5gk8GGYdZzUJ8arn31iM7MKkhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zC2FtXsR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE82606A330;
	Sat,  7 Nov 2026 14:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zC2FtXsR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1CD1F008A1;
	Sat,  7 Nov 2026 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060967;
	bh=lUPdChVahaCPqNHLRLyOZj182uqC+/jWol4/THIEUyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zC2FtXsRGglVNDJnYLOvZDV5lrRcZYppyyTAKchS3iPGkgGGbRQPWyVXxsTjeMC84
	 p2LVkpVuo1Bta7f+YuHXmrxR+lCeKSqJds+zlpjPPhWrnckWTu+FGSiZnaJkQ1g+yD
	 BNmnPxiBWbpUXJwWf3OeurMHNGf6ptL6kAeIRb6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Moroziuk <dmorozyk1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0321/1536] ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5
Date: Sat,  7 Nov 2026 08:38:57 -0500
Message-ID: <20261107135006.736466199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmytro Moroziuk <dmorozyk1@gmail.com>

[ Upstream commit 191fe151eb85ff6cb24189fc88c970745497c057 ]

The HP ProBook 440 G5 requires the CXT_FIXUP_MUTE_LED_GPIO quirk to
properly toggle the physical mute and mic-mute LEDs via the CX8200 codec.
Without this quirk, the LEDs remain permanently dark.

Signed-off-by: Dmytro Moroziuk <dmorozyk1@gmail.com>
Link: https://patch.msgid.link/20260812121856.30353-1-dmorozyk1@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 03ac96476c3c2..6b688832d71d4 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1107,6 +1107,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x837b, "HP ProBook 440 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
-- 
2.53.0



