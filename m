Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046600;
	b=S6+ShYPnIFPR7KQnMD3VKWNaACRKMexagno47E3T6GeJDuIw/dUsryv3xgqRGWJs6hiC
	 yirPXHWbQQ6p7RQT9hDCaowMUyzXGD5Xu1mS34WAkv+0QuplFQkoGirXeXjUXMuw0Mwfq
	 9Qr39JBDngSKW+CHMyya4RM+LlvJoCOVn0rcHIsxh6IDJyme9SqsNMWOM/SLy0uPnWGWO
	 B0/5Gi89fg/y9bU3VIzKf2TNqphTk91KlB7VsH1ZD1rRR9Ixa62aWhcsynHmDv0t7ZmqE
	 LJzaiMVghsYJbU/67pUOVG8pjxlJPli+BQjf5PC2tYYI+BzPgpymbWkNUsD0/B/2PkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cANgD2M2No1DYBJo9UMGgWx/25CKIyVBahQ8+J8Yp30=;
	b=r6AQBEeZnL46omAllzwrYeOxAXVF4jEECSRg7xcbfXbDA7qv/MHqPLrV7V5Hr6L8sE9m
	 Z4PnkKtULBxEKJZLwweaVncSKTjJbat5wbplS2tgbAAu0m5LHeo0FaX+ldYx/TNDwdJ/U
	 YCIuJ5CZ2eM0r8dPzoBhLB3fwZGdhR+gV9gPH5Sb6PJlqHJiqtNyo88TqUYkCVOET/sHN
	 kdWF/6ahbMwpVyRUOTs1Rbsxkn2WwxnwjspqiHmSPe09YixaiijCQ3SI5vvt7AH9jx033
	 keYfxPcpkZTNf9wN1LhVy8omfoz6j2pk2WuPAbDW/XIa6p2yMqYCBJVUZCQilqSLveA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJ688utl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A6C606A320;
	Thu, 19 Nov 2026 00:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJ688utl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115761F000C4;
	Thu, 19 Nov 2026 00:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046600;
	bh=cANgD2M2No1DYBJo9UMGgWx/25CKIyVBahQ8+J8Yp30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJ688utlDZmcO6ynna0u5m9sY09XiaobfDFCvdfJX55zApMxPqGhuQ7+/9hQRha8N
	 jlv9eki8YwKWRLPgQDP3WAzO2pn2WbaMETvjLYEw5REWev3XDGNJRyhqTxHhhNdPIx
	 7hDOhJtg23tYfBas7b2n4tNnqXnNUNuMQ2PtGRek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Simpson <chris@nilk.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1298/2857] ALSA: hda/realtek: Enable bass speakers on Alienware m17 R3
Date: Wed, 18 Nov 2026 15:38:52 +0100
Message-ID: <20261118150248.219790387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Simpson <chris@nilk.net>

[ Upstream commit eb296114d5ba4d335a640dbbbbc9618fded0ffe7 ]

The Alienware m17 R3 (ALC289, PCI SSID 1028:09d1) has a second speaker
pair, the bass speakers, on pin 0x17, which the BIOS leaves unconnected
(0x411111f0). No PCI SSID quirk matches the machine, so it gets
ALC269_FIXUP_DELL4_MIC_NO_PRESENCE from the fallback pin quirk table,
and only the speakers on pin 0x14 play.

Use ALC289_FIXUP_DUAL_SPK, as on the Alienware x16 R2 and Dell XPS 15
9510/9520: it sets pin 0x17 up as a speaker on DAC 0x02, so one volume
control covers both pairs, and chains to
ALC269_FIXUP_DELL4_MIC_NO_PRESENCE, so the headset mic setup is
unchanged.

Tested on an Alienware m17 R3 (BIOS 1.38.0), Linux 7.3 with this change
applied: the bass speakers play, and volume and mute cover both pairs,
also after suspend and resume. Headphones and a headset mic were not
tested.

I used Claude Code (Claude Opus 5.5) to find the unused pin, pick the
existing fixup and write this patch and changelog; I did the listening
tests myself.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chris Simpson <chris@nilk.net>
Link: https://patch.msgid.link/20261029-alc289-m17r3-v1-1-5d3eac605e7a@nilk.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index db583e3de2d04..f83afdc59e4e9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9860,6 +9860,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x097e, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x098d, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x09d1, "Alienware m17 R3", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a38, "Dell Latitude 7520", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET),
-- 
2.53.0



