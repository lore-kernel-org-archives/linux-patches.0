Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2949340290
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301213; cv=none; b=hLI29ZP0MaxLWM7tbvBrs2j5cJXtI8vEVJo0DyiczUu8+PDMnf/YufuubNNy9WDxAh0z6FFZh7Q1uXyhMdb+QYU8+XLNdngU8kNM/YdCU1OoRXx3OpTcQOb7tjDD4xAGeVXG0hvqX82uCWslsbv8NMEc4ktwBFd0xXga6XUbvZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301213; c=relaxed/simple;
	bh=FmRr01DdfDLLOruObW/tsEkSx9zOqwHGqIC11f0aC08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1rsMoH81BqoaID27n0Og19/+QcDltjQgJGaYVao1r5ZfKaqWf8W44KONnyKPxsxbOfJwrWqhQ73CS5gMlnRb8fanWJsw8x7qu42pA86T0XQkZqT3S9YrY1LgZuRqRNZqT03KuVwhtmteI9cci4yBYoIui+jKDH4/8sm6u3+HvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijJxwefK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijJxwefK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEBAC116D0;
	Sat, 28 Feb 2026 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301213;
	bh=FmRr01DdfDLLOruObW/tsEkSx9zOqwHGqIC11f0aC08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijJxwefK2gBkPAJ+cb0JNewJ+1OZbhqyzbF8pVsKU2Yvx3JLHb4ZXQI83fpCu43Xm
	 XpEhT/bQpXDcJyrtpcW7VDq9L7I5yN3X0MWRZEx3e2pZsyalUguzmwoGPPrhGLdbMP
	 /g8B3Tqt94k/1fQBbAm8cuwZtrw6gYrYxFXaLCdsONZuILRYbUjko/VO0ZQ34VA4ZT
	 RB3dy6XrlrcK7+5jGWdY4QdGOmWf4CEPwY7Ouoh1pw3PgSun46wC1eS+5BWSiKbHEn
	 RICop5iQ/j/OgblwPcoAIOQTIn01t/FcLUqP7gDDfOdGZZGiBDh24Q14HsJCEuqKff
	 Cz0cUaR24Jakw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Aaron Erhardt <aer@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 389/752] ALSA: hda/hdmi: Add quirk for TUXEDO IBS14G6
Date: Sat, 28 Feb 2026 12:41:40 -0500
Message-ID: <20260228174750.1542406-389-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Aaron Erhardt <aer@tuxedocomputers.com>

[ Upstream commit d649c58bcad8fb9b749e3837136a201632fa109d ]

Depending on the timing during boot, the BIOS might report wrong pin
capabilities, which can lead to HDMI audio being disabled. Therefore,
force HDMI audio connection on TUXEDO InfinityBook S 14 Gen6.

Signed-off-by: Aaron Erhardt <aer@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260218213234.429686-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/hdmi/hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/hdmi/hdmi.c b/sound/hda/codecs/hdmi/hdmi.c
index 111c9b5335afc..c2e3adc7b3c00 100644
--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -1557,6 +1557,7 @@ static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x86ae, "ASUS", 1),  /* Z170 PRO */
 	SND_PCI_QUIRK(0x1043, 0x86c7, "ASUS", 1),  /* Z170M PLUS */
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
+	SND_PCI_QUIRK(0x1558, 0x14a1, "TUXEDO InfinityBook S 14 Gen6", 1),
 	SND_PCI_QUIRK(0x8086, 0x2060, "Intel NUC5CPYB", 1),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", 1),
 	{}
-- 
2.51.0

