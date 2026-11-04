Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831190;
	b=XGG7UhMX8iovqaNy8sJZRnbLzs0c8RvFJ0pVgj6W1TtV3Gi3qjh6fBoh5kdS0syWMeQ9
	 ofhjcoLiytwJ9PHtcyGXYfpcePjQ5XQxyD6FGUtgVBfsBWkFtNIktGEonpAcEWwGlQ+fW
	 7ovYbXJPKMiuJZ65iYQlkqfMO+dsEantgfPLM0P5g78aCgl99Zvq564/eDhpY9LKraxAn
	 KXFYW+nMfbBS8IfNB004GDQVo9/Bevwt0tyJu0/X7lTkKEtVxCQhQp2AZSAnJmOJIus+h
	 hwGaY2HlNacQXvGFXHHbMJXmEHxwJGbx/ranX3jkPm2luSOvZQnpBfIctR0kHjqoovA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9AbjptmhXwiAmNDxK6U30/UgThLhMhE2KASNfo+6vL8=;
	b=Ke+YkOr6PKuwhU0jxpG9wzfTOB83MLPBDEKGreSfKNv4idOKT9hQ6V9odhSDK+y4sYml
	 8ioDVrjnnmUecC62vlyUnePZsrhbr/oyrvvJnFUzZBqjwZC2jqhARJLLX7q71ofieUbbm
	 KQgPr6wA9NrSMqAaOTZCkb9VCf6u+bJS4Dkee7QG6Desand6pJWLJUTdOCIFcHgPJtUuT
	 5Y/uySkPwDwLSGAg+K4jgDvrkH6v4RiMPLJKmm+iNZ4JOjwnLDrG8EKPtSkuWdjkDyimf
	 9qAI9ArGpCjpM7/32CFb2PDloJkZaGzTX5E2vPkMD+EJCjbElj//aHZ1lOjZrEB3Gwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNZ01XHW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23992606A853;
	Wed,  4 Nov 2026 22:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNZ01XHW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39D21F000C1;
	Wed,  4 Nov 2026 22:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831190;
	bh=9AbjptmhXwiAmNDxK6U30/UgThLhMhE2KASNfo+6vL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNZ01XHW7yv84+aJWaPS/kZmdt82/OVP/xUP8hgxFNm+iqLO/EBfYhpBTKu2NgL6n
	 D0l7iuTSpK5fmf53ei11rWbKU7nmIcUw6NFmpIBgaYSTBS3XU7nIjHKVhUwH2Bveak
	 SNTgALT01OoJpdhWmDwD1583TVfkFo2Kdxpy+nik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0504/1005] ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H
Date: Wed,  4 Nov 2026 16:03:57 -0500
Message-ID: <20261104211058.058708995@linuxfoundation.org>
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

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit 9a44b828dd7c0be1d0d6d6cf178d9727ceb6da6e ]

Fix headphone jack detection for some devices

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20261001183403.103990-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 2a466ef894697..0bfa64bee9d3b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7640,6 +7640,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
+	SND_PCI_QUIRK(0x1849, 0x6256, "ASRock NUC Box 358H", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1854, 0x0440, "LG CQ6", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x1854, 0x0441, "LG CQ6 AIO", ALC256_FIXUP_HEADPHONE_AMP_VOL),
-- 
2.53.0



