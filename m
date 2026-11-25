Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625322;
	b=I0VbLHCleKK8zEF5XFgt2jQ+eIEqGTZSCMwePfodHkxZaVe8nSUD7KeGa3WTou2VIXZw
	 XO5SHOvCchPxT1Kg6lPXSIErXiYp2lvHAo8Zn5tml7Uv9VM+rPUa/yMireuqhwZd0GdVZ
	 2NcL954j2ixDVqJFuvWCrxjvhaHpaSryzmbZxwtS5tsQ8mEKLNJXQDt2PQwaGytwJqSlL
	 KWc0zGIMjPoUUIk2B6mrJ5iu+dMZfF06HkXmG97dFgUK61IquR3sJseBEAFWgl1JJqXda
	 JLJSjEfC9I7mSJ05kkLQzpluGaFl4DKI3jP1mXNVMY8sEgb6JVhk9sIm0GRN6FbGE+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NrbKca1HjxdS2fIu8rU63k5OIsu9PDQfm+YOmScF/IY=;
	b=QWtAEIDc+pkay3giJisiKKD+FGWvLfesr3kVhcuIcGXIl6YolWK7FgdNbJllluYuehtQ
	 dP0XjPIN0Lzm/L1GZzE0OQ4JaYS9GfMJ3sAQgavhwV4oEIdkxGUJc+VU3IHbEtb3lQbAi
	 WsK2yytq+iWf6hDkrnH9iW380utMfrMXDXjfdO9x/7bGmRPYrB86Crv431bOh6p5USr3t
	 rKu0OuK7Cge6iCqES7Fm7YNAaf6wbV0iNTTQHMwu1IJxaVgN9onplU+M5XDUsSEzLgjs8
	 mcj/uYn4Qa0MZWsLKhTzEp7FOGMKS9mGjDHRfQJTdrjuiKjYN4TdnsPp1hrxjSgY9NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ko8/IjqP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E65D606A327;
	Wed, 25 Nov 2026 16:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ko8/IjqP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8036A1F000CF;
	Wed, 25 Nov 2026 16:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625322;
	bh=NrbKca1HjxdS2fIu8rU63k5OIsu9PDQfm+YOmScF/IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ko8/IjqPSZatN72Goxdj9mLvy3GUr/iUP1hMmxVyOLgnmrktIvXPOTXfO0/pwghAp
	 Kul9HBPhvi1Uu3q7HJeQBQOhz3pjidlCtv+IR9JNwecYtXtmZAcPKAX9NMqljVk8dq
	 7HOAN/avYdrTUojAOajIy8fQgdhXuOy7Jdb6LTOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksim Krasutski <krasutskimaksim@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 479/816] ALSA: hda/realtek: Fix mute LEDs on HP ENVY 17-cr1xxx
Date: Wed, 25 Nov 2026 15:33:47 +0100
Message-ID: <20261125143900.285085712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Maksim Krasutski <krasutskimaksim@gmail.com>

[ Upstream commit dd83323e4d5e22bd04f7506a9ec33533465c8393 ]

The HP ENVY Laptop 17-cr1xxx with subsystem ID 103c:8be8 uses an
ALC245 codec and two CS35L41 I2C speaker amplifiers. Its existing
quirk configures the amplifiers but does not enable the speaker
and microphone mute LED handlers.

Select ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS to retain the
amplifier setup and enable both mute indicators.

The equivalent change was tested on an HP ENVY 17-cr1xxx running
Kubuntu 26.04.1 with kernel 7.0.0-38-generic. Both keyboard mute
indicators were confirmed working.

Fixes: aa8e3ef4fe53 ("ALSA: hda/realtek: Add quirks for various HP ENVY models")
Assisted-by: LLM
Signed-off-by: Maksim Krasutski <krasutskimaksim@gmail.com>
Link: https://patch.msgid.link/20261010185335.30949-1-krasutskimaksim@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Applied the same one-line quirk change in the older Realtek HDA file path, since the upstream file location does not exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index bfc75a1733fb5..b18eb7974c8eb 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11154,7 +11154,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8be5, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be6, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be7, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8be9, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8bfd, "HP Pavilion 15-eg3xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



