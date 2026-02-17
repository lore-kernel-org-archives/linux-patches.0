Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C75A29A1;
	Tue, 17 Feb 2026 20:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361310; cv=none; b=SFD8KEI65m+XgW8nKQBGUvzxIyNGOV4q2JI/42J0LJ9hZiErIfqn4SwyyXcVcKGBvfgw8ptRH7ZM2j3XT2rMlUy9WLjr4xPycfIdOnhf/4E2xKIpBsaVtTh550KQ5je+nGECVOGBszjiWTlc5cDiz5gQgZdfVrDGqtFDEDgk/7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361310; c=relaxed/simple;
	bh=sFN78g18WjPugEbFuWHBVDKJXpRb9NXFn9VmGYK8yeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iketFaWoHD8XwqtiKKwz4oOOIoKK6scgjJgbTu5p6BqN4lGlOyENzkkKFze02JyCQdF2Fyejhb1b+QJFZ3d+bH2kibT2fqEg5FVh/vjkHctytgrGqfsYzmZUFJKD/CZ1v7K6Vd/6rA9BPhozVycYkXQ3hWenOj1vsgUx/2wLn+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWQc324/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWQc324/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41EFC4CEF7;
	Tue, 17 Feb 2026 20:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361310;
	bh=sFN78g18WjPugEbFuWHBVDKJXpRb9NXFn9VmGYK8yeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWQc324/KTFqijuCHRdmGpXldNX15JjAEm/32PpPBXhtg5civOUJ0pfipuo8/vtBg
	 5nUcsENKNjYSbjgApnwNmECrlRcj1jNU/zWzxS4ONYWdR+/i363omfovyCAe+5iWxG
	 EVKyGmvTiAYargOopXcU/R2sGPwSo54Yo4nkh50I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/64] ALSA: hda/realtek: Add quirk for Inspur S14-G1
Date: Tue, 17 Feb 2026 21:31:27 +0100
Message-ID: <20260217200008.683523357@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 9e18920e783d0bcd4c127a7adc66565243ab9655 ]

Inspur S14-G1 is equipped with ALC256.
Enable "power saving mode" and Enable "headset jack mode".

Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260126073508.3897461-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2fd52b6b4fb57..89410d40561d7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10454,6 +10454,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
-- 
2.51.0



