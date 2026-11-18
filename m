Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034003;
	b=HIMHJGiK/Fi2w6NZRrA5RWp/oIwuJpDbLOIQYwYJ30E7cIAbeOH0poa+bMjnPVrClbDI
	 Vx0k+469er4/18ONaE3ZuJ252muJxVEGEGjnVueadBqcIVoeGn6NlSBftQt1YjOxBi8dj
	 U701eLCFSkEA2mtzdhMyKF4wOzjafdPxqjet3v01yRWl/M5R4EPA5YqFAvAohDIBm390L
	 FSE7ZJAHOT2M7r2zRTPHYZPJCswgHZ10ScA8JJcofe2WEHkwnhRQMuTh1w7xA/W738Crs
	 zo50Tomj41m5exHBD6o8MANPDRX6LJf5EYna95ox91sYBiwSJ09e31a0adAMv9q/XMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+crEwasHJN5XH1c7Rc8JdsjS/5N8sGUP3gGg14B7HB0=;
	b=Jt3eF4gtM45hiG2fFq3tVkHMpUHMmga85wCMtoSqjCsA4bNd1mP7nfwmxyS4Iq/zsT80
	 9HjjzGhXx7/PheiM5OpP7wI2Sfv5JMmEnOU/jEaVw4WfeIAVjxmhOfJY5OaA++FYyoBAh
	 we38ZlXpE9bzrWaASI62a0tNxBF3H5e/EgGuP8JcxBFrp9ZOv2PM2dKmXZLUcSeYQC/hz
	 qzTv+NIj62KaUxlxW4TseXm9Gl4/442zbtfXpLXGLHXcC+cK1P4tvyFK4dju374PbXXjP
	 HL5PTlq0Bm0psxC6mbJhq7w3mkKsDwz91QuuIHDVzfU5X1L2aR1JzCSBfXEfyYUJzQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hE831xId;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85875606A32C;
	Wed, 18 Nov 2026 20:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hE831xId
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EDB1F000C4;
	Wed, 18 Nov 2026 20:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034003;
	bh=+crEwasHJN5XH1c7Rc8JdsjS/5N8sGUP3gGg14B7HB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hE831xIdruD9HrtZKNJDHrKRZ9GF0HRdc2ovpWutLX743A0hublFAwSx1H3QKxRQ7
	 HfqvcP2RZmrSwyltWsEHvznleV/Wzae2b2pETELnfvZ5zWqxMC23TZerkVSWlCSj/6
	 yTkTSDRDjsmIvfDClhV7Fprh0Z/POMpqjG8EivlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Orozco <maudob@live.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0216/3318] ALSA: hda/realtek: Add quirk for ASUS VivoBook M515DA/X515DAP
Date: Wed, 18 Nov 2026 15:13:58 +0100
Message-ID: <20261118150321.439945759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauricio Orozco <maudob@live.com>

[ Upstream commit a9fa2a016e805504223abf8c9b373ac9f7bfb9b3 ]

The ASUS VivoBook M515DA/X515DAP (subsystem ID 1043:1e3e)
requires the ALC256_FIXUP_ASUS_MIC_NO_PRESENCE fixup to
enable the internal microphone.

Without this quirk, the internal microphone captures only
silence under Linux, while it works correctly under Windows.

The fix has been verified on real hardware.
Tested on an ASUS VivoBook M515DA/X515DAP running Linux Mint
22.3 with Ubuntu HWE kernel 7.0.0-28.

Signed-off-by: Mauricio Orozco <maudob@live.com>
Link: https://patch.msgid.link/20260730033506.8958-1-mauoro3@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 16ad87a2c6f07..76b316fb1fcb4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10394,6 +10394,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1da2, "ASUS UP6502ZA/ZD", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e10, "ASUS VivoBook X507UAR", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x1e3e, "ASUS VivoBook M515DA/X515DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
-- 
2.53.0



