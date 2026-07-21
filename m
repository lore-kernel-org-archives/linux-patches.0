Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F4346AA60;
	Tue, 21 Jul 2026 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647943; cv=none; b=QY6U5fl+4prWd47inOANitk3M1yzVPXcU9jpP9DnfQlS48XqW23C7rYQu5Gw5PeGINoICIMj8opU4d+LGUaWJ/i2Mb53eW9I8Z389kN+DdTYlmSjI3zjblbHARIVSHC1h/KcCkZH4IWUmcElvHQlcarfCRqwMRXZcSYek+OQrIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647943; c=relaxed/simple;
	bh=y1tIjxM1LjxLtN+r1+GuyLDOTjw57GAOQAG44+0sOOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFLviQc/jcqLd2yCMUKXdolS/2ZUqAC6nZv0F/RcLDuT+uxLvmzLbjm5i1hldZAKqzoXqXZt+L15LnO81Qmbh8nBIn/UjwN5lCiitMLkUgv05fqLfLQGXneKJKK8SEzCTG71cFGFArXZsTzbZbvfa5dTnb6HZn0zC+/PH97ncso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUy4N46N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUy4N46N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE4D1F00A3A;
	Tue, 21 Jul 2026 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647942;
	bh=MST/4YasbgNLfTeMKdPyBz2eBAQobxh4AJqI8lj84l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUy4N46Na3sdzwbqA54uDsYHKRwvdnH5DSbRQ11Bl2eBvKFzcLt31ORxItLe4GyVu
	 87aGDLBDL4q5Gs6DUxu1nU3bAD/hJUzqFt4sYPtXnphXnjJR5tZIYhIwrt0gEWHZxs
	 8NEX8YpELvqBNOAAZKhVeRrFgiSm+X8rTsZAUHx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 0005/2077] ALSA: hda/realtek: Add quirk for TongFang X6xx45xU
Date: Tue, 21 Jul 2026 16:54:38 +0200
Message-ID: <20260721152552.787996307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

commit d595255241e5fec0c94adeebf2565524398e37c5 upstream.

Fix microphone detection on built in headphone jack for some devices.

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260708132135.102680-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7840,6 +7840,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6xx45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),


