Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051424;
	b=JFVaE2DXPDviXb/x26ssOobI4TEphiAtaAdUycf3Q9OmH4f3DCA5VXn/tkzVG3r95p4z
	 RZ0poJ4JPACcdQgdCITruVG0RrKU0y7nMeyPjUybhHS8gxjk8e20ETsb+mHPQiLtnwPen
	 2F+f3Ofg09757xpr0utXhn4TrZfULx6pDb0u6gO+chbRU4r2FAcogVIGosyDXKiYgCkyH
	 ztl8dEa3472G+xr5+396HxCZhoKkvTU3pclm9NSof+6NIogJkgT0BbVVt4LeM5W+TcOfO
	 /UToQ66hNERKmpgBTEngc+H2LOH1XK6FZV2JCDEihxLJBPRDef24zBxeVCSvtXJO9PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQTzZoroYU3dnmgR5p/M3aC9vUwY1dV/xoraY+svXsw=;
	b=ATHqTEfPHnuuU5Vj2NZvvHmY8zEvH6qgzXKc+3TmWfBrz04p59AuIQ3AtyMIHuP2lUyh
	 s1eku79bM7UEfK/LfoyYFQOPJu0R4+BgdCmFidrrs1/siAvEGPgwhb/TqOKmi1xctpiDv
	 obqMt83ndqBXNTZt3JOdHmjNxZAM7vr9nLmhTq9051opYMjZVWvXE3NbHroj7Zb3tNZqe
	 j0g8C0H1AZyUg2iXsBloKrvErKvuH/bZA+umTXMdd2Hq7lNad/26zKHNd9vYSFJbusg3h
	 45ZVYV9LwLaA123M1RLsUHNeVrbEMs7Z4sEaeCBJHFhKyVwcthVLo6yn1SCZAS2edxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0zA6TRlo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D91E606A31C;
	Thu, 19 Nov 2026 01:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0zA6TRlo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972F41F000C4;
	Thu, 19 Nov 2026 01:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051424;
	bh=tQTzZoroYU3dnmgR5p/M3aC9vUwY1dV/xoraY+svXsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zA6TRlo0qv8oaQrdmrP+kNqaTPLtf1LDNg4KBvYn45spYSaaskAFcEnaw/8xvo3B
	 q3K7wSmf0tH+ykUbsNJPdPJtpIlUDVLfRRiL/+nxXmmAi4QMQZJ9b84PDWV/T1lqbJ
	 an1wSQOt1HWiDnS156GrJSFBgfE5hJ4dhtESKzW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Moroziuk <dmorozyk1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0202/2214] ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5
Date: Wed, 18 Nov 2026 15:31:18 +0100
Message-ID: <20261118150018.293560265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 44b1d5c3ff993..f631dc0650e4d 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1125,6 +1125,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x837b, "HP ProBook 440 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
-- 
2.53.0



