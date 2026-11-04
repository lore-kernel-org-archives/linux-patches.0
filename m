Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829758;
	b=wP/4JuxPq7NRSkKBCnR6XZN6vZNyGKoRm1BZGHydOPjHgeWOLCFFFaoX98soqZ3McBmD
	 VkcPskLxuveEqlCyVo59jHcYhJbHEXp0Is5YIacVcA3Tfvrs7xve7lKdJtydpZnsHRNMU
	 FBJPhvnv+y3V4HRTIPD1+Zmxx130jdAfoeKi9H9+TarubglqLISjJTdJ3AKGKZWj5iiD8
	 kANIqLZ4oAW3AmJH39aHBVUlw8ETAa9kzjG9wYpRWhCdTHzcR24IOceuMHkll4XDei2GM
	 QJfWudv9qIKVysPv2uJzH767WvwTqAGkrVVEF0X6aWfVu8W1Ts1dYpCfsJfECIWMCRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pWsgt125TsJIIQX6kdEROyjIGJ7d93vwg3FRCoN2VGA=;
	b=R2GrsTS7/Irm54FWSMhPrXC5r/kLKj6+v18a/AumPGLR3O1BiF2P0OwxPMNb8JFF9kgv
	 SZYi2bq+X0ydxAxGdo2aO+Rpr3Nu5Qd/khMmweDueqEaBuPZOvU9ItJObaH8YOC3qSG52
	 oCoPOK+ToJ38gX81kLcsxWfj1dzAL2I4A8rQrnsF+AAmLli7/FUkF4ik3EVzrGWCV3RGW
	 BYb/gdVrXfO3R6alP40mjuvndHwopLqnT1aNc2JhqLIS8484A8z9vw6bpCSvspUn7FqKr
	 20/aU/LbncYbVv5kYJYvwBFROVGqRCE09DTP7XtQKZS3hKnsmNqeAPZaicbaHfvMbuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AFDsJV4z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD50E606C5AD;
	Wed,  4 Nov 2026 22:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AFDsJV4z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6A01F000C1;
	Wed,  4 Nov 2026 22:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829757;
	bh=pWsgt125TsJIIQX6kdEROyjIGJ7d93vwg3FRCoN2VGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AFDsJV4zvI+GG4m5SpaVoAjpR1cdYtfi1cEM/kTMqKZVPOo9P7upV+ao2AcFBdc4M
	 mTXM6QiPl4pb8HbE/LF1g8aFPHQoupEovSqukOPK4jCRVP+neU2o9HnmkqUhqqifFo
	 VHiugGlFXSMm1RmAd/ppJwSCD5CifDxv0o3eg4FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Castaldini <luca.castaldini96@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0324/1005] ALSA: hda/realtek: Add mute LED support for HP Pavilion 15-eh2xxx
Date: Wed,  4 Nov 2026 16:00:57 -0500
Message-ID: <20261104211053.027246990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Castaldini <luca.castaldini96@gmail.com>

[ Upstream commit daf55a381dca9bda12cc8c3a47605698f2d560e9 ]

Add the subsystem ID 103c:8a0e to the ALC287 HP GPIO LED quirk
table so the mute LED follows the speaker mute state.

Tested on HP Pavilion Laptop 15-eh2xxx with ALC287 codec.
The mute LED now follows the speaker mute state.

Signed-off-by: Luca Castaldini <luca.castaldini96@gmail.com>
Link: https://patch.msgid.link/20260805122907.52302-1-luca.castaldini96@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 4cadbad99537a..68d5e5aa7f62d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6881,6 +6881,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a05, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a06, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a0e, "HP Pavilion Laptop 15-eh2xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a1b, "HP 255 15.6 inch G9 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0



