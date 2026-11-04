Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831086;
	b=rB0Dq7uOILtk1wfb4eheJRY0/F/RSiIVP35GrjUhqu60Af+5njfIvsACXbQ8y3bQgrcL
	 4GUHahzLsrjC9OdIg863v6PM9/57LnH1aIeFsuKrQ+ByaKz8xL0f2YdpXamUNBcgInqym
	 sGWa38UoxmnjaYTGtjFzHoOTRfYGRtzdxT1P/lWbDzvnBq+VIep8hk4pNMjWPAtTqDiDG
	 m3aFKRkuCR9WsdPU3ulVscKwOlenCPE26ofTrI6dKTKRqqrry8OOaHSHcuBwT3wrh1nKw
	 P2O7cfLh7+I/q5HQsjntScSWUj2SqAaytx0Zf1C1v6AZs/4KWhXGIC6KEUbfBmdaQSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gx8xEf7PqHpXVQNT6P2hTskRmzHzvlvqGEx1XBRPb3g=;
	b=a1RmgXjyKxzXaSG14Za0lAjg9mFLUlBpUibrZ17bxNzBauR1nYMWdgCZWFggs7ZzWMEw
	 VDegK291suEUSoE0t5UPve5NqxFqNCGO4uswr1+CXMpSGSlXJw41/2LNwviOVc/cC5Y05
	 kPoHgEhGH2qNgDH1Qagok6mgPkyCFdCEHi2g77mdV88jIlLEej7r+K00y1tZ6jAuaOira
	 h3gcA9x1bZOrfn7OJIdzSwgl2piUpb0EFgFjh6mkGtz+vj81IwYqauC8G+P9FFDcjKYC7
	 J8ZZl5hUyKqh+1EFTnbQ2gWje4QFFFQyU925p6R1D+sPMLRe2mtVshEY6lrvuqxzdUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQ4BTzq6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF333606AC29;
	Wed,  4 Nov 2026 22:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQ4BTzq6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ABD1F00A16;
	Wed,  4 Nov 2026 22:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831085;
	bh=Gx8xEf7PqHpXVQNT6P2hTskRmzHzvlvqGEx1XBRPb3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQ4BTzq653rfZZ6BhhMV94VWIdjIHXWAmzvXx2nw/C+DHZ6wUvwC9ev3ZbOjuJzNY
	 tCSUwX6Syv4nCkWuRjqCqlElwiIftvU049SrCsr/ayzjpTyCMuOEjuxCgh9katCKn7
	 GYrd1X6e38IHZWpw6MG9eYcXrvwr1O9gyGDwFxfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Banha <luisbanha26@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0496/1005] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx
Date: Wed,  4 Nov 2026 16:03:49 -0500
Message-ID: <20261104211057.851617039@linuxfoundation.org>
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

From: Luis Banha <luisbanha26@gmail.com>

[ Upstream commit 775aa96c310d59f3d15a6e5a9bd1796fd1ba95ec ]

The mute LED on the HP Pavilion Gaming Laptop 15-ec1xxx (103c:87b2)
does not work automatically. Add the ALC285_FIXUP_HP_MUTE_LED quirk
to fix this behavior.

Signed-off-by: Luis Banha <luisbanha26@gmail.com>
Link: https://patch.msgid.link/20260921230105.16844-1-luisbanha26@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 6afb35769f746..1fcf2ba795e8a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6822,6 +6822,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b2, "HP Pavilion Gaming Laptop 15-ec1xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



