Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618507;
	b=FaVUZkOAA1NBuQGHmpA7Iq1jd2+729wcTqXfFCNUtc+DmSCnXIASqIxLWs0sJWXe5KjU
	 WenZT3PhWXjPyAq5yfkp16gT81egH+OVGGPsM9BDaWTl8DuSn9gEgVgR0fws3sLHVJ1aa
	 1mVl1xhQmX6bt0s6HKKuETFVjO25sTpG2124QhRqeQAJHwLYRL6OXbzZhUaam6t4/5Z4I
	 1SAqJbe7tIV6vSvfk+uWYguh8Rb57ifUQPENST049eySnk/PESY+e1owTsIjgnA/tsLJA
	 qVUzRpw+G9OidVrco3jIqa+vOFun6feDYp81XTfXKfaPS60AUxdMZ+TA4esUh+dBVzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Acb4dxNY5dMsuZliOJM7PKgUPS4xHZx0JMTvebAqiLA=;
	b=TZjNi15mX2Xk9gEa3AvqxZfBPuokB9DmoMWFtaUe892pwmvaJz9wPS9TANvQCjS9lduR
	 v3OfdAO8v2Vz7SbMiw7FoEEfBh5MIyVgZlDGl/UqEEQabL2OIiLj5l4UPACfTN1B2lEP0
	 AfPh77teZkGuTI1RU/ylTbC8jztLCen9gkprUbxOZfva7UGKAJZWTgbbfICbppHwjmZDu
	 ALgxZVI+HK2x4NL3jSnkwB5nfXAOVqfotGSVABkGVinnoga9UoN4KtqILbaHYmurdHrXD
	 yYoU2wS26hJLlfWjC/uZ2Cb/hmzLc9sEqwzeDFuvQY9ft9pUFodPWjHkcI7i/UDE4Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8+yQ3n7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DD8606A31E;
	Wed, 25 Nov 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8+yQ3n7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D211F000D0;
	Wed, 25 Nov 2026 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618507;
	bh=Acb4dxNY5dMsuZliOJM7PKgUPS4xHZx0JMTvebAqiLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8+yQ3n7WOlivdgAH4zGKI+Hry4bUN4FOq2iu8506sVxkacQABdOgq1nxTgeNH/t/
	 eztteWwrfN5OlQqc5Z48zn2o8au8l7YXvkSOGTigqWkrIXEOQFFb/7dcakEM/72DKl
	 D+kb5y304xUlkzaJVT+o8XpqpKv56fi2UgkOwGwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Madlani <shivammadlani5@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0300/1005] ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP OmniBook 7
Date: Wed, 25 Nov 2026 15:27:18 +0100
Message-ID: <20261125143828.763486988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivam Madlani <shivammadlani5@gmail.com>

[ Upstream commit 5cdee541b37c6d29a6e05cb2a875a365cfbcf520 ]

The HP OmniBook 7 Laptop 14-fr0xxx (PCI SSID 103c:8e3b) uses an ALC245
codec with CS35L41 amplifiers. The existing quirk
ALC287_FIXUP_CS35L41_I2C_2 does not configure the speaker mute or
mic-mute LEDs, leaving them non-functional.

Switch to ALC245_FIXUP_CS35L41_I2C_2_MUTE_MICMUTE_LED, which controls
the speaker mute LED via COEF index 0x0b, the mic-mute LED via GPIO
0x04, and chains to the CS35L41 amplifier setup. Also update the model
name from the internal board codename ("HP Agusta") to the retail
product name.

Fixes: 7150d57c370f ("ALSA: hda/realtek: Add support for HP Agusta using CS35L41 HDA")
Signed-off-by: Shivam Madlani <shivammadlani5@gmail.com>
Link: https://patch.msgid.link/20261101143818.17714-1-shivammadlani5@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 350003d406e79..2c12ab2f8d206 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7896,7 +7896,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8e36, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e37, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e3a, "HP Agusta", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8e3b, "HP Agusta", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e3b, "HP OmniBook 7", ALC245_FIXUP_CS35L41_I2C_2_MUTE_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e43, "HP Laptop 15-fd2xxx", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8e60, "HP OmniBook 7 Laptop 16-bh0xxx", ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



