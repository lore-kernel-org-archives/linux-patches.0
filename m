Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037857;
	b=3+NDwnbSIY4VcD6olQ/fASIj3wM7DDT673YXBJjCxWCE+wERjEoy1q+ARRD9NuQC3vHR
	 db9zskqZzGoyA0IUGOBiA7N5L9YK0NPinuBml8qI9HmtOk5aMhfmsUAbwTwcvQd4/p2dO
	 IKXhtSJj25ap+ZgkvM+RY19h+8PXmhREaWU10MlszY5OSlXzA1yqU/51HiulR3aPkJ3V6
	 lI9PbgQ8SZ6NeFk4cOZXBt5rmQ6mMPWneE5TgOBULBVjwgPfF//m0oGaDOU2KwsEso6Bb
	 eM2EAxz1OpyN3S7pxMmx4UQg9DPBeyrvNbc1q8kTSVDfMMPUEISlv7Wl0mKRxeo/Zsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YN7FDiAsGXtxhc94rFlinAMM+9zSB5vSmJSaYi+ds9I=;
	b=et4xFPcinmnPB3cEHvNNY7rL3jsYsFEvdV+bagvfiaQT7dTJsnxEXIH+pXtiG2MEqOp6
	 mp0sHrgC79r27Kfc5jhPDPI+7cKCFe5CxxvI4VyzBi3A/dz/0r3hEgb30ioiLgC+s+m3p
	 CQFxFuxwJMJPXtscXdhqKjn5O4RC/Yv4hVO7R7AOhMw515DsZd3NQ2uDgANZPDwityprx
	 ZuRxKWLLygsZNLfyLEieDKTb/mRcO+H5LUNfK/UpxL6YIRIPwSo/S4Tss70sSYI4k7WdO
	 KNcZr/av9dsZ9LkxqRkIq32cmxj+rJmsS5wzPvrLuKytce1kfUnPAmTPR3I2dYQ72Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NWQQw6vu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24955606A31C;
	Wed, 18 Nov 2026 21:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NWQQw6vu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7465B1F000C4;
	Wed, 18 Nov 2026 21:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037857;
	bh=YN7FDiAsGXtxhc94rFlinAMM+9zSB5vSmJSaYi+ds9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWQQw6vu6kbDhp5jj2ejDLI1Ga/g2iWEcj/yfNmFd/70Iuf/qQHhXZ4PbZmq6tRWQ
	 XzcnkSoT26t92IevrsI45bOS1knPNHkREOmLorJF7UWLZ/e3brfDWTO1dRWOSd13/R
	 JJ6U83J6HbaS4rrn87Am5If81PpQ/v5uIiwMChis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Simpson <chris@nilk.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1541/3318] ALSA: hda/realtek: Enable bass speakers on Alienware m17 R3
Date: Wed, 18 Nov 2026 15:36:03 +0100
Message-ID: <20261118150407.208073132@linuxfoundation.org>
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
index f13da29f4b90b..d711cd7292b2e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10041,6 +10041,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x097e, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x098d, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x09d1, "Alienware m17 R3", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a38, "Dell Latitude 7520", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET),
-- 
2.53.0



