Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061367;
	b=LjWa14pRF2Hp+mQfMu+pJRO86U1nlwFGGMEyRgVGrfmtvmM55m5KLZHb8XcxTBTtodi+
	 bR1OeMQ5JvodtuebwaBgA22tjDVwhwV4arQlyu+QB1s/K6X0XWx2TkS8hpkXe40QaWjf6
	 +dU4vBM7n79mRTRGimvOWr2bTxco380kE1cS+N2ujAtRuGc8pm3CxR79R70q+SSPOqVi8
	 q1phPJP4IBhUWkOaclODhmdTJAkmckhRzre32pYUohbGnjvkaZFzJc52Xo/9dp9gQwmgN
	 snB8RJacK4WRfXAymjo4hRRlyjiCPCXepBcWt1OKm1jLA4XVynMSshEQ1qxR5Susr7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UugVtGxXBQaDKcrkmKiT5nHoG6Eij5hM7VeXqJSBswA=;
	b=c8+27WfgvdDFYv5jB85jmhCdh/GXEN+HAv5pFOX2IvkPtaSwT+x0qbe59fSju0p1ja9E
	 pSO19K0B1sAVB6E5+rBPKzrtUza8rNfNVyhhnHiCAcDlh1ETaagioY1pn9Yg+mRLCccHb
	 aK+NKCgT/gStPsjYS0rbltAQI5Y7bk+JDjp2vxR6ZzTSgvdbspXFDQPvstXSdha/nx0B0
	 bcjOkoanWzsC+7/7oFcjzHbP7ViKNKnrOG7qXav6m67tAvMaDD18iAbS4qQpTjrMtpKjg
	 /b1JPG1KwiOLE8Ev/AKCFiM5StG0QvLZxj3ZT0l/u5GubJbEPNlP2y6jK87/fKkZwfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N/PWB5FH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFA4606D808;
	Sat,  7 Nov 2026 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N/PWB5FH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850CB1F0089F;
	Sat,  7 Nov 2026 14:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061366;
	bh=UugVtGxXBQaDKcrkmKiT5nHoG6Eij5hM7VeXqJSBswA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/PWB5FHGq8uTF9w3ypnlC/ZHKQ+pt2ksKA8CiPzX/BjKVfcqtkf+39Q42Jid3zM+
	 3sMOR5x/jaRc/gQOdOwwP1Q/qNRSc5qjR6fVe8tphE9+Apf/jVPBRpk4SS7OsrXGk4
	 syvENHTbQSezrkpj/HMVvWXM8SCUiQN0V60HEcuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0490/1536] ALSA: hda/realtek: Add quirk for TongFang X6SP45xU
Date: Sat,  7 Nov 2026 08:41:46 -0500
Message-ID: <20261107135011.234513943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit 26a94400ffa4fcbeff32e23abebb83a1a20eb401 ]

TongFang X6KK45xU and X6SP45xU have actually different PCI IDs. This patch
Adds the missing PCI ID to fix headphone detection and clarifies the
naming.

Fixes: d595255241e5 ("ALSA: hda/realtek: Add quirk for TongFang X6xx45xU")
Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260724190109.169889-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: e72d5659a260 ("ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2c76c6812a9ef..2eeb199f3bc95 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11749,7 +11749,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
-	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6xx45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3033, "TongFang X6SP45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6KK45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.53.0



