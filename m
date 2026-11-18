Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034604;
	b=CidKf/xEeD+dFrbqIGa9gzfUNp3tZrmC4UjExBCVCe6b9yket62TNImtibffL7uS48wf
	 Qr22eBoMYgWBfMfjABYwTiCHsdQBqqGBqNoQ5YPLBwxI3Cygc0MiIaQclPBDqZcdxsrZq
	 lqejI/3d3LCz3/Q5MYZFVWkVQNiJTwT6fatW5ZnzvSIPUVLXQNEqDEr898MhjNXyL1TKR
	 aivByKAqLFcK+GyeazHAnC56/aRAKoPgCMmbzQc4NEXCQn6GywFUTSzhZap25QpsSV93Q
	 DxVbfAQFFqIjS1Hf6te1XZDk5dmg2v4vISauuba60M/zODyAxuaLvJBzh9ker1qeWsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Dqxess2xP8o9fh2NF6pRXemQ3ohahWSAeqjxo1cnYM=;
	b=5Z0DqfQgKfiike8HGbF9/82eaYgeCsNkj5AasGPxeZNz5pt2udkvIm7ba8f4x45Urkmq
	 exVGjHpzhRAMUuUCO4UlUK1DikaGoOiCqX9Q/voKLy3oPNaXVZQa3kc7BKPVJ2cdpJrhW
	 DO7kmgTCjSxyO5+6GgJ22HIPDGSxF/lQG86iy84uaUTtLGB38fyAcxbWmiw+uZKiPRLY5
	 bFDJs0Ijr3QD4YMu2H3Q1/eNPVwBUUzv19Rvw8XUhLC7WDSv01Gw9ZJE7I6dNlqaG6LJy
	 TTKg9x1aTUQfzreV2CRoPM4kfjTXRsdK1fS62hA3asn8FcHihgzA+RdAUtuhvoZLJkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/BE7DNq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0324860A3826;
	Wed, 18 Nov 2026 20:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/BE7DNq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C35E1F000C5;
	Wed, 18 Nov 2026 20:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034603;
	bh=/Dqxess2xP8o9fh2NF6pRXemQ3ohahWSAeqjxo1cnYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/BE7DNqsh6wGfJAdJxieCvJs2q/Ie717ow7ah7uClhhpwi88GsGZMvxM4ITpeCAX
	 2WkgC4tQvkcDmAodq8aMXvq8l1YQnca8lWycE0lsmV0NA0DpoCQYljRT0NSPd+b4IF
	 KaI6Zo09UxFPtkzNFeDBMDh6Pb7hFyHAXBbz01zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0426/3318] ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx
Date: Wed, 18 Nov 2026 15:17:28 +0100
Message-ID: <20261118150329.376757055@linuxfoundation.org>
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

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit e72d5659a2606056a0c34af212b46a3275a55bbf ]

Fix microphone detection on built in headphone jack for some devices

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260821144437.27233-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 58c057027d97d..24c7ce5f08660 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10739,6 +10739,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3033, "TongFang X6SP45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6KK45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x30ba, "TongFang XxAF5xxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.53.0



