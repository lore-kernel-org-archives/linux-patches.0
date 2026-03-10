Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ECB35AC23;
	Tue, 10 Mar 2026 11:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141122; cv=none; b=EQobP9gTdqkemKe+LkzXtolycqx9bSi379+LkriGfLlfwM7KiyLRMszB1pY2i7IQwh+axKVNO8nMXBHcoL7IcF0pl1cy1LASih38B0Zi+RPvjAZ78LneOgbDnOrfuTQUt4iTVbuZLS98yh0YTTDdwMQreRe48/0Na8rnLub4cbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141122; c=relaxed/simple;
	bh=z/NBKoIXz80DGgWdvkV7k+sKymY2mhUMD6pUpcQOSX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKoonZrNij2HZ7TV2qKRwoEGnn0t1FEDE5xBohtQNceBwyRu+Cr04mNhAoOGWTwSzeP/0I0dmrUqKQOWWqjeBCo6rPG3u0xCLWlbaTeQyHGM86fXHvSC3wR8KUyR1mCSx4hSuJO1RoAqdUIBxxiLlYp1K+xHyXyFON3+PAXjQ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4TfSDqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4TfSDqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DF7C2BC86;
	Tue, 10 Mar 2026 11:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141122;
	bh=z/NBKoIXz80DGgWdvkV7k+sKymY2mhUMD6pUpcQOSX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4TfSDqSKjy4vsmGMMTqYMKwnFN738RybNtnmRKZf/LlPtuD+tU+p/baR0uzDpmO7
	 tzZ6yj1y1pErNPRHn9HIVA6PLhTntBzg7x5/SyeVRj/+YXIIroQs651utztSZdZCaS
	 IVKfsSdc+TnhaIgiXy5VJ2QSxd4XlpLonUdSlg3QrANLxR4bjMAKwnzW1SSfnuoYWa
	 uutM7MfIRk2lAM2tPbp6D7dhJOZWmCom9r36hx/ZU8tBJloCysDsJ0i2VdNDJnaSep
	 fFzWeaKebCHGbRjp0fmY2ClEScHhS3PSPAcXttus+86Y1AA2JufXXZJAn8ay4Cwg0P
	 Uj1o7SBUSixlA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 124/311] ALSA: hda/realtek: Add quirk for HP Pavilion 15-eh1xxx to enable mute LED
Date: Tue, 10 Mar 2026 07:02:51 -0400
Message-ID: <fa8d05174a3c06258e87badad14796f8d6c61bff.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

commit 068641bc9dc3d680d1ec4f6ee9199d4812041dff upstream.

The HP Pavilion 15-eh1xxx series uses the HP mainboard 88D1 with ALC245
and needs the ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT quirk to make the
mute led working.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215978
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260227121327.3751341-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 36053042ca772..beff91f122c61 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6872,6 +6872,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88b3, "HP ENVY x360 Convertible 15-es0xxx", ALC245_FIXUP_HP_ENVY_X360_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x88d1, "HP Pavilion 15-eh1xxx (mainboard 88D1)", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
-- 
2.51.0

