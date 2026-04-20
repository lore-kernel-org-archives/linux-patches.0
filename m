Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9165933B975;
	Mon, 20 Apr 2026 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700654; cv=none; b=WaUUGC83fAVzeMX0c/8oYrzWztkPqGj52+YEpGD+3X+Y7ijuBJ6oM1/dIhXNQhY0aadnhmp22jSu9YshPKSys5PlQ7V53Ewhwljg0poybRblKz6x/FIFCEqeWi85wFOE9CIGY7qBqMBsyTrwdhuRb2od8YV/L3+M3LpdAYHGhw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700654; c=relaxed/simple;
	bh=7BXnMer3JHthG6VPN1l8HNu9XKmgwBQBP5kxKF9564c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E33VC5jEIQpo2IXAAVsiM38sHrjBVH7AUYwlwcEAp4iBk/RF1wh0tudcs8d29F5mQjW1ygEyroENGgO+RSCdsyNNF4nw3IkTJT1PhR+pny3pPmsW3MuImsz2lFRJS4qQhy1VGWFOy23cBVrqH94ySHNigX0pTw9HUqjUtSn0bjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdRRvfsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdRRvfsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EB0C2BCB4;
	Mon, 20 Apr 2026 15:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700654;
	bh=7BXnMer3JHthG6VPN1l8HNu9XKmgwBQBP5kxKF9564c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdRRvfsR4DiTl1Fn9vCcl1KjuqyfYYayzOVDmINUJscsA8Yo6zm3IASScQzfewfmM
	 iWuXTG9m8JjWzgzrOm+GMXm5LzwFXdZ340jmeOxgqQUAPcWVsKzr2+G3ojB2uqUbD/
	 XFpGnoXaEc9Fg2NQYO297C2XHWPwG3hwSHK1UDwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Kovalchuk <coderpy4@proton.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/198] ALSA: hda/realtek: Add HP ENVY Laptop 13-ba0xxx quirk
Date: Mon, 20 Apr 2026 17:39:43 +0200
Message-ID: <20260420153935.769874400@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Kovalchuk <coderpy4@proton.me>

[ Upstream commit 793b008cd39516385791a1d1d223d817e947a471 ]

Add a PCI quirk for HP ENVY Laptop 13-ba0xxx (PCI device ID 0x8756)
to enable proper mute LED and mic mute behavior using the
ALC245_FIXUP_HP_X360_MUTE_LEDS fixup.

Signed-off-by: Andrii Kovalchuk <coderpy4@proton.me>
Link: https://patch.msgid.link/u0s-uRVegF9BN0t-4JnOUwsIAR-mVc4U4FJfJHdEHX7ro_laErHD9y35NebWybcN16gVaVHPJo1ap3AoJ1a2gqJImPvThgeNt_SYVY1KaDw=@proton.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0654850687447..1b64292220ac8 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6732,6 +6732,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8730, "HP ProBook 445 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8735, "HP ProBook 435 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8756, "HP ENVY Laptop 13-ba0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP EliteBook 8{4,5}5 G7", ALC285_FIXUP_HP_BEEP_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x876e, "HP ENVY x360 Convertible 13-ay0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
-- 
2.53.0



