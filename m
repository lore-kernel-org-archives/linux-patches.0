Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D731230CD88;
	Fri, 21 Nov 2025 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731089; cv=none; b=g+WyA09zVNGFbqugYw+8E/DYjtvipsD7Qug344bWgpHnSqK3mcmAVttPCj/ZaYRtjnm0pv0R6zHecLssTprGnOgX+JuBfHo1KnCr7rFDDWGjj834ffa+e+j79xgQI0D92XH0MVpCFLNFJTZDm9+MjRYWF1G3V0H/uSlVJP0qq8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731089; c=relaxed/simple;
	bh=NDXIxDdqm64Df4Q9j4hWa1uJ6zyiOO/39cCx0W7/shU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar6hY/cuchGTHKzio/6B+qwej0RE5RztY9c5g5A4LujiX1FSOSIUXQO8PbX7bQOG22er0d60Pi0hBsr3vkT56Vu3mi0MbgSesVdGVbFt9DJfi0JomFgXeZ+k9Li75StZti0b8vvweee3fdjc8USmzMB8pVs+len2hdYj1KyBFOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkJ1OBEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkJ1OBEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615F5C4CEF1;
	Fri, 21 Nov 2025 13:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731089;
	bh=NDXIxDdqm64Df4Q9j4hWa1uJ6zyiOO/39cCx0W7/shU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkJ1OBEqU5eviQ1NBpbiU1fXEwVjKHoKxfGHYALXBH6bKJ36HVjoJwh+E2KJYAtKe
	 nuEJoyR1ieGqwlPnUKlZcKEtIEYp49uXbD/Kg7sBgTNGqHjZI16onowuF9uBTN/LXz
	 04bqBzn0t3isbq25I8vLIJ3vvV52Yj+TLkv0x9a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawn Gardner <dawn.auroali@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 044/247] ALSA: hda/realtek: Fix mute led for HP Omen 17-cb0xxx
Date: Fri, 21 Nov 2025 14:09:51 +0100
Message-ID: <20251121130156.184589542@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawn Gardner <dawn.auroali@gmail.com>

[ Upstream commit 2a786348004b34c5f61235d51c40c1c718b1f8f9 ]

This laptop uses the ALC285 codec, fixed by enabling
the ALC285_FIXUP_HP_MUTE_LED quirk

Signed-off-by: Dawn Gardner <dawn.auroali@gmail.com>
Link: https://patch.msgid.link/20251016184218.31508-3-dawn.auroali@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 28297e936a96f..19604352317dd 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6399,6 +6399,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x854a, "HP EliteBook 830 G6", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x85c6, "HP Pavilion x360 Convertible 14-dy1xxx", ALC295_FIXUP_HP_MUTE_LED_COEFBIT11),
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
+	SND_PCI_QUIRK(0x103c, 0x8603, "HP Omen 17-cb0xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x860c, "HP ZBook 17 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
-- 
2.51.0



