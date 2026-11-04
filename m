Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831090;
	b=aP0sHVPNKuIXsKrrE7W1ecBX+3YUEDOM0TUBmQYbaltShetRhTLEG5gGvUmf2YCimSwi
	 pVKFZPH5s2DVvcdgi2FZCQFtd9yx9MJ6+C3BvcPo4hiCO7mN7oHU+Sf4F7qJ0MjgRlhNI
	 Vn/0OxQkVj8wrd2Do3hUy1wza7mHx1I9jC5alfG7tAoDMsbSmNj7q5i7q0UnKMTe08wJu
	 jAxcsQEYrUoC9E47Cl3Nm4zRE+DKzyYr/lY8o5dWTD1pwBKNTSqJjr1qZucE2NIHicjvW
	 WQrUNSSIrby0IMoATVvzEUy1cGVWDESG8nAm4RoDutZe0I9ZExByIGLZM+wyOcrSUzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4GLxT6g1hb1ELjjJxsexac7Dh+rsCidxiMPU8TdyiUw=;
	b=f6L7PaTNIWz1sxU/JNS58NKQFtslVbpg+vxqSkN53QuHWUIZ57kLkaJ0yWd+VQScE2li
	 8xJmkXjj1RDagb9Xy0pmipsQTzM8OmL50Lo+32RTYNkvt6Zi7ttmXVKQz7MeWxGT9a6VP
	 B3PyBmSAMXjJVvyfVp3zhgewETJn5zEhPp25VcYlNFDhXyoF8/bbvJ3U8RxpCEJL47sju
	 JYWN6URbGhHUvX4v13ib8r4742MPr2M5Li1ksPzYMC1TLlwx5gtCPpkAwILKAmS3jl+rp
	 pd4YX1TK+mGdXb+ec3R+LVRGJ7cwmIBqzQW2oR+Tc7RVnS64nx9WEzLZW/asC0oprHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VutXbcMa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8656D606AC39;
	Wed,  4 Nov 2026 22:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VutXbcMa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FEA1F00A15;
	Wed,  4 Nov 2026 22:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831090;
	bh=4GLxT6g1hb1ELjjJxsexac7Dh+rsCidxiMPU8TdyiUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VutXbcMawMPRv/SFhCs7FqwbFp1/uI8jjTd+KqFMi/sBR9DdJxUlizYRbpsxBGrFy
	 0dEE1c60nFOIfzWaoMOJdpQB4cykSNr9v4uqTOPC1PhSIegsnCFXo4ALRxG9fOCZD3
	 VeuqW4AHBri44EqVWqNfYhDd35ISZb9SKQfgACxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	erph.briones27@gmail.com,
	Krish Gulati <krishgulati7@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0498/1005] ALSA: hda/realtek: Add mute LED quirk for HP Victus 15-fb2xxx
Date: Wed,  4 Nov 2026 16:03:51 -0500
Message-ID: <20261104211057.901773197@linuxfoundation.org>
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

From: Krish Gulati <krishgulati7@gmail.com>

[ Upstream commit c748c42abb9b549fc79c41ea55e1f220eadb60ec ]

The HP Victus 15-fb2xxx (PCI SSID 103c:8c2f) with the ALC245 codec
does not turn on the mute LED when audio is muted.
Add a quirk entry to enable it.

Reported-by: erph.briones27@gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221946
Signed-off-by: Krish Gulati <krishgulati7@gmail.com>
Tested-by: Raphael Briones <erph.briones27@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260921131728.8999-1-krishgulati7@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0a3df8b78aae6..4eefd5d87f04b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7004,6 +7004,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8c2d, "HP Victus 15-fa1xxx (MB 8C2D)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8c2f, "HP Victus 15-fb2xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c3f, "HP Victus 15-fa1xxx (MB 8C3F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0



