Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061366;
	b=SL6rZxdMpmvXvVzA9775R7Z32PxHPoJ0LnX2bzkunTRBzUsbQFDgEsFNRgiSe+ztkyAQ
	 lsHbUx+UPPKtoWEU4/b7Qw+WEsc7UZ8YstkRDutvxSRKm4fCQvyBDqi6tKIzrBbiRj/UV
	 NCEe6Rf9hKKsDDbbnw3YSE23JGk8uOf4m47K2syXK+jVZ1WHUcsGBcVwOfBSVgUzGIHYY
	 mm2Km1v8wWCSPkZjA2yzjAT81WajX+6cUHNd1tXzHXJIK2uFPhWFzFlhx/tngyT+QFqV6
	 ql1vjnpC/8gUhNcUiIo8OTWqZYFfteSbyxps0oxDn2wD5D7Zs0Tum598+HZJ5FOhOag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XTI5cTw0DBlOq4YKFbLZLckSyw13f5ofp7ZRHE8GduA=;
	b=5pc75AapUG9mYQnmDvyDqyL80iQHInSEO7tHVEucQ1oh/IxCCxyQ89G50xBhvevgfF0Z
	 mMa2N3Ylyc9Yd765jrRJGX26rJld1fKfHKylawGlVLSX4V1q1aqumMnasWiAnkQ6xnykC
	 eQeML1F0V5Mzf3Goc1cDU5no7Uz6/pFQtkrOEAMokMmAt7mxosufHiQpjvfeafPsZnA7S
	 beBd7F24alY3vMfFtj3ZGtsRvPVJQ68xQ+Hu9T+2Po0+OdsGrZ4WFLVMUxxse0L03PAPG
	 0SSn2EllUE5WvpakcoT8Cd0UJolenP4Q97IxsnxiB5ilLrOq4Rd1FbvLmNEOth6Apeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KUtZ732s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13B1606A339;
	Sat,  7 Nov 2026 14:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KUtZ732s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E35B1F0089F;
	Sat,  7 Nov 2026 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061365;
	bh=XTI5cTw0DBlOq4YKFbLZLckSyw13f5ofp7ZRHE8GduA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUtZ732sFXlG7HzDd7f+PaKAD6w7e29eH1YxsaJGHiunt1xTOywnNM+jtJfEFsWAy
	 oAKrf3LpYYTP1Gvv2nr1Z8C4Yg+iyySqIkB47sWIUUkAR/F8Ml1DdTFLQs4bhOr8KW
	 gXSTlXP5eQJq7dte3AuyjAoknUC0dmZSyuzDL5O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0489/1536] ALSA: hda/realtek: Add quirk for TongFang X6xx45xU
Date: Sat,  7 Nov 2026 08:41:45 -0500
Message-ID: <20261107135011.208430423@linuxfoundation.org>
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

[ Upstream commit d595255241e5fec0c94adeebf2565524398e37c5 ]

Fix microphone detection on built in headphone jack for some devices.

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260708132135.102680-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: e72d5659a260 ("ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 159e9a6db49e8..2c76c6812a9ef 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11749,6 +11749,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6xx45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.53.0



