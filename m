Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829739;
	b=2qcbYOOu2pc/5yA3CpWY7zYY7nA0SxUWNxuP5tSDEuQaj5o49e/jKAuGllX0g4Mh1rnK
	 1PgJVbh9RrRsccGUoYmKu7UkkjEC+89EySgAje8707t6pz/Ldq4GqKbCUhBUh1V6rTWwy
	 c9AkUcrdFSKhVvMYFoPQsjWFQjo80uhwrkYRo2ldxmLCYbSGOM55o/Guks4okQYh6RzbS
	 NVeLO96Ut1nbuUFWpcYC9MapP18TwF00lq6OLwSc2f2Mf/MCXDCl9CTWMsCbirl92j+oG
	 uhIbYc4zyES6Ku4quNHQodxnT4iOceX1OPoQ4Uu0SQtBVRBtwGFV9taTs9tu3vBl42w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBIr0Kppa0XLa/y4pigHh8tG7xzQzo9zf44+JiUeQv4=;
	b=T03tbzudZBAdvhmAADZPXskSnNMWYxH9jn+xBZ+vsu4q8N2A8OVvoSZshTrgegn9ux1q
	 viVcV5HqWj7DFNC785xj954GiJRdqQ5Ofv48ymt0krzg/VFGrOcvVIEYHnqu7rTTxoxqo
	 q0LIhHVvxCozJR3aR4L0f1PlHpRCZTFSQHk3uwfgurxN6kokCseVgpACPn5fGodQtH2FK
	 wg1GbCGrp6tbCWsv9vX+gqtBm+U3hVs0kR6ZCwh6epvTKX09nDPh2r0hPPCVAdk3MSlFp
	 HGt6/dsO4Ecx+LxaAx6k6QTbUu6PD70vTdKvuhYBtkNbc1WzRnAd/5pDle1HNrFGmJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sy/3QOjf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010C2606CA12;
	Wed,  4 Nov 2026 22:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sy/3QOjf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C17E1F000C1;
	Wed,  4 Nov 2026 22:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829738;
	bh=sBIr0Kppa0XLa/y4pigHh8tG7xzQzo9zf44+JiUeQv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sy/3QOjf7s+fBuNPfAgOhcSbuJcXo1ZHLeW8DHeA/+zLd5c67Eyj7O1cm4iJD9aOC
	 KIqZsbK4XTojSvyQLAp5bFCWiSHA1/1VgWXjSUwtudHs9HtOYBVRnSD/f8axHKdNSZ
	 zwoEGnjHiHu4/ec2x5vldXkwSA2YDTk8iL5vu3uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Orozco <maudob@live.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0313/1005] ALSA: hda/realtek: Add quirk for ASUS VivoBook M515DA/X515DAP
Date: Wed,  4 Nov 2026 16:00:46 -0500
Message-ID: <20261104211052.699086504@linuxfoundation.org>
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
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 3364f6ad91fcb..4cadbad99537a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7196,6 +7196,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1264, "ASUS UM5606KA", ALC294_FIXUP_BASS_SPEAKER_15),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e10, "ASUS VivoBook X507UAR", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x1e3e, "ASUS VivoBook M515DA/X515DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e1f, "ASUS Vivobook 15 X1504VAP", ALC2XX_FIXUP_HEADSET_MIC),
-- 
2.53.0



