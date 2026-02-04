Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A0927702D;
	Wed,  4 Feb 2026 15:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219127; cv=none; b=BoFwRhlHcSXq3oGrgdWRu0c51ei8od+AmeYTqyHn5IszcwddIIxfG5cszSmAIcFinaHh+1r3joIGS4cAwxySKMIK7BDhPllkEePgSbU6HolfgVxG5+8vnuboSRMGazzsF3I+N23QB7Zarkbt5Rypbw1hK7Bqw9m56w34uZWx6Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219127; c=relaxed/simple;
	bh=pFgG7TZUw70D0FufeXNaG3uOsXPZdLAhm4Kzw52bjgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBy6aqB/GjBgQeBW6hRjWvD+WA7aCRxcjxqjUHtVa8TsvxE3jloIWEUTFM+5Q+so4S4RFL7HeGQ8MVOsIdwsinYiBd3aQ7fNQPC0V6L5vFSZ0C34ATCjNSBqyhGCX9a0g98UwcnJXsEGnYVwWVR0t8v5MUKBXSOjV4/ZHbavP0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evdHA9uW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evdHA9uW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7994C4CEF7;
	Wed,  4 Feb 2026 15:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219127;
	bh=pFgG7TZUw70D0FufeXNaG3uOsXPZdLAhm4Kzw52bjgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evdHA9uW00CdnHSBR5PUCTiuc4rq8w6KkUvrGrprjp7ivaD34UC4ivCiwgWaCO4v7
	 gcZr0+w5xqcI4MIGnQ7izbwuOv3bmgtOTrJZEOxvORY1P5wwt87FWn9mS4RZqFT0Yw
	 u+c5xnwOwegqHbZ8TIqR9z1OaS5N9Q+1tBjoLHZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 076/122] ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP machine
Date: Wed,  4 Feb 2026 15:40:58 +0100
Message-ID: <20260204143854.586225540@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

commit 891b77d459d0ce993c68365d899134bc9fd47ac0 upstream.

The HP EliteBook 630 G11 (103c:8c8f) is using ALC236 codec which used 0x02
to control mute LED and 0x01 to control micmute LED. Therefore, add a quirk
to make it works.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220828
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260126073508.3897461-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6631,6 +6631,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8c8c, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8d, "HP ProBook 440 G11", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8e, "HP ProBook 460 G11", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c8f, "HP EliteBook 630 G11", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c90, "HP EliteBook 640", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c91, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),


