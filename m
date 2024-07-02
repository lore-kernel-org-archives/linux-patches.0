Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9458263D;
	Tue,  2 Jul 2024 17:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941535; cv=none; b=Khcf/jT8WcUVhkFlTDXn1nc4qOFRblgs6//4kfK2HKyOXTcWZVwxEOrCnAdzmOaat/3nD02ls5dpzLYvU1F5FlHgqmf5hTVoKwm/WkgCV7pOe5Np6N/saexnYi7J4LejR9Znj5/fBZVMI+NKaTaBafuDth12AwN8sQJuI2DaDqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941535; c=relaxed/simple;
	bh=V/qcKav7FAJwVLJxOsq3Uv4L5jOM0Q1mcw3g1N4/q1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPTXUjPaqyIBu0Uq3tg1OyYy0mkvXjy+RMmwm7TgyaOx7E+/X/Bnh74g4puY+tqG5rAjBUSu0g3i3SG9SwctWlbOz4UKn4YD8HSFs8ss/YW6//lCfMnibjNdXhF1fElpFiInZfng3kpJp0KaNpwj5r2vZTYvB82s0j2bs/yOs8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0L/3HAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0L/3HAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BCAC116B1;
	Tue,  2 Jul 2024 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941535;
	bh=V/qcKav7FAJwVLJxOsq3Uv4L5jOM0Q1mcw3g1N4/q1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0L/3HAahLvuw3Ak4J/XyZDH8yjwLD9SUJp/+l0aNmKFGGr+Z8pZdS8YfJaU2Uv75
	 oQUGeh3BuC1p+WjHfRiTVvMD0tX252KTHJtjv0cwyhIUBmj4r2rLxQsTLrN7Y+bH3c
	 9wcAQw02+m9Jc6oWfmZhbApqgVlnGx1GXpKy8PPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Su <dirk.su@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 092/128] ALSA: hda/realtek: fix mute/micmute LEDs dont work for EliteBook 645/665 G11.
Date: Tue,  2 Jul 2024 19:04:53 +0200
Message-ID: <20240702170229.700882537@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dirk Su <dirk.su@canonical.com>

commit 3cd59d8ef8df7d7a079f54d56502dae8f716b39b upstream.

HP EliteBook 645/665 G11 needs ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to
make mic-mute/audio-mute working.

Signed-off-by: Dirk Su <dirk.su@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240626021437.77039-1-dirk.su@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9807,6 +9807,9 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c7c, "HP ProBook 445 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c7d, "HP ProBook 465 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c7e, "HP ProBook 465 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c7f, "HP EliteBook 645 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c80, "HP EliteBook 645 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c81, "HP EliteBook 665 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c89, "HP ProBook 460 G11", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8a, "HP EliteBook 630", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8c, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),


