Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034370;
	b=asc7qA8ggS1SisZvw3SFZCgf/Xw/5a/nNRRyjdqTGSr4uhigjy1yKg8m40usWydBIc7P
	 2xaqpSR0Ela6AMkztlHqgRCiQBB8FolFFck1AgZHfLHc10CPtBHPdFteWShh0ZYr7jcH9
	 I3I7KDqXSvYmDFIwrKaXkKUD+63KIqa5ve0AODBQIRwWHJood0ROxawrCabJfpkXmgQos
	 aReqDrze8BFB5E5J6mQwX6ZiXeSEHicoVqubVz1J+/VAxHe2YHkmVVM0csguGS1LkY2ko
	 Tz9bTeeX9x3QOR0fq1OkekgqToOmKTZhTXhR/Ez81E0RLCYc0C330EBaf9BYZ9nYA6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KM2c33kN7Jut5mkAnGmZnxdKChKy+ntMyXZMFSEaCtg=;
	b=2osfq5qlL/jxSCc9DdQF9WqrVWtXt+9Vuf3pwirHuZ8+BNyaSPaEipg6Fd9c8wNhczju
	 hgNGI8oVIE+1tH0iDAAy5N+mEPMCntd8xDYsRhKQw2HXHQwzySWpJLcWE8Wp30gdcss+M
	 ILI/iuKiAV7VagRACyxEytFEqriPcACgxfiNzxrFJ6+LMXXYuATUx2Df4MZ5PRpiiBwtI
	 fRiee8U4iziexLITxH7cP2CxsyZA6iXwniFkaZjQ1R4hNt/04Aq2lMAv8x7RFvTDlHt/b
	 SZg7v8R/dC86dqi/eLWJtwR7QKKsHSjih3v8IEyARLAUJGX7cWX/TKbMPHg20LLp6gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpzj6PFr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F54606A320;
	Wed, 18 Nov 2026 20:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpzj6PFr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35CD1F000C4;
	Wed, 18 Nov 2026 20:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034370;
	bh=KM2c33kN7Jut5mkAnGmZnxdKChKy+ntMyXZMFSEaCtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpzj6PFrz+iC1Fcq++Zq/ZCd8UAXPSZwLrTLSF+nRJEWLXDXEacx9Ii0aQPLoDp2C
	 z1mdgjQ71gdYdBL7nR00BkoKriQZPfmuZX/LJ2n9/aufBKDm+yCe4UTtjSBZquYTYl
	 tXnpyjWPOV8QD+O5xeORtBN0EZhpCbnhKO93fUYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0346/3318] ALSA: hda/realtek: Add quirk for Acer Nitro AN515-45
Date: Wed, 18 Nov 2026 15:16:08 +0100
Message-ID: <20261118150326.410927378@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 0d90a929836344f1d3b39f22f08ccecc62378a59 ]

The Acer Nitro AN515-45 requires ALC2XX_FIXUP_HEADSET_MIC to make the
headset microphone work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221925
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260921124450.639601-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 06a72fafdb8d3..7910e31584c61 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9968,6 +9968,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
+	SND_PCI_QUIRK(0x1025, 0x151e, "Acer Nitro AN515-45", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
-- 
2.53.0



