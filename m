Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B773346BF;
	Wed,  3 Dec 2025 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777185; cv=none; b=Z82UtmLSm/WhPUd8RW5Da9eiIH4aQhT+jMuCk9sB+j7I9NpYH7IU7vnzoO6PPwaolWHKbesR6SHwYh3Pa0+vBLi/GU6o1Ul+r1xXjRYGGRSKKp404YwrWfHVZZjMWEJrpIo7EoYqyJTn/eQiTdbvS3r6VMg2lzoEc68u7MWTsdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777185; c=relaxed/simple;
	bh=IUIWCAkgasHRunhCFdFK+M+9uterBT/Nb4bQo9BJPdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e4SDk1ACq84JeLGfOiHUCiMc9GsvhO0ptaX6PwuJgBmZh1Rh/RxVZ2s21ESDW739R6oyWAPealN13ugB15Q/ax8bAA5C2G4o43V35Le4N8IIZcmpJrH8fFYoJcN60fWVKMg0TGrAmICAAwn7+sxr0KB+Jw+R3JXp02LPUoWnsmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wa49rrW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wa49rrW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A665C4CEF5;
	Wed,  3 Dec 2025 15:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777185;
	bh=IUIWCAkgasHRunhCFdFK+M+9uterBT/Nb4bQo9BJPdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wa49rrW1rJnsdPEpg9v98bXWLe9+kB6vLpZgnEVMjnRfLQW7akqPbFvJE8zDkLEWg
	 K99teDRtwVB4SOK9d5zaKYZYapMeemv9yvAXhgG8+jgdLM7GWXp0pYAhoiDQzjVY7y
	 PM/Lry6/phUCHLTO/Qb2tRu0p9TtcPsGggA1Gsgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	sstable@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 075/146] ALSA: hda/cirrus fix cs420x MacPro 6,1 inverted jack detection
Date: Wed,  3 Dec 2025 16:27:33 +0100
Message-ID: <20251203152349.210283280@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

commit 5719a189c9345977c16f10874fd5102f70094d8f upstream.

Turns out the Apple MacPro 6,1 trashcan also needs the inverted jack
detection like Mac mini patched, too.

Signed-off-by: René Rebe <rene@exactco.de>
Cc: <sstable@vger.kernel.org>
Link: https://patch.msgid.link/20251117.182351.1595411649664739497.rene@exactco.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/cirrus/cs420x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/cirrus/cs420x.c
+++ b/sound/hda/codecs/cirrus/cs420x.c
@@ -585,6 +585,7 @@ static const struct hda_quirk cs4208_mac
 	SND_PCI_QUIRK(0x106b, 0x6c00, "MacMini 7,1", CS4208_MACMINI),
 	SND_PCI_QUIRK(0x106b, 0x7100, "MacBookAir 6,1", CS4208_MBA6),
 	SND_PCI_QUIRK(0x106b, 0x7200, "MacBookAir 6,2", CS4208_MBA6),
+	SND_PCI_QUIRK(0x106b, 0x7800, "MacPro 6,1", CS4208_MACMINI),
 	SND_PCI_QUIRK(0x106b, 0x7b00, "MacBookPro 12,1", CS4208_MBP11),
 	{} /* terminator */
 };


