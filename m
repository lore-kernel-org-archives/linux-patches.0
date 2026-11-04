Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831269;
	b=JJx3fm6AyWUgisZYgemEH3OIwGIRJxVoD8XwaNQ9i1Sgd3up9NfQdTzc0TftE7ygpIMj
	 D7HqUaECSfBTqruTCy0VY4urpUToWlfR9jjtdrfuBGgpSMY0tuqOH/dKSsie/31/5Ha1e
	 pqPMIL04tMeu+2pYT7DQSYvztQsx2qTjPkO0JwVIPBcZnK2/PPHtxX9W5DRAuLMkycBH0
	 MkdNc4EcAeR1I+vDe24nv9I6UGxzcanqu6fLWa+9CGHA6Ko/wmSSIWQgp48KzmN24V4Iz
	 QVBEjdf+ulsd9guwjVvMVBmZl8PhCAWFA4Bo9aeQTdFA+rJ8MMW4hpYQrgx3cqQMMwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JCsoaisrh4PVil40wrdV6bLQzAFqnJlLcKnub8P8tX0=;
	b=0fYoL1gnvYTEznFwzf+0Wdg01L8O1xDn60ToACvhlxXLzf3QzrzEPKmaXom2PgTeAL3P
	 IwICC8DtHadgCcxKixxiQlCYVmkC6wcVs6Q/W9pbC+GmNcpBY6WpqjhdETj5ACnoVwGeq
	 IL1VKkj1ux3Pm3DTyXwXrrkQjW6DTToQw+7NMFHeVPxI/xvRX3T99iUIeNxRA76RyBN1B
	 Hf8dnsk8Bxvx7/7GwYcHzZG9KkBM4HjZTcMY86LnYZwzsU/H/6LrdU+h1LL0gMSFpz5Nn
	 m0/hb0e5pcJIxF4l0WKDZqO9MqWEKTKlq+uKze2kzurg5TowjNlC3G75wiNXqpNkMbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKPvPd8s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B33606A84C;
	Wed,  4 Nov 2026 22:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKPvPd8s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9099B1F000C1;
	Wed,  4 Nov 2026 22:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831268;
	bh=JCsoaisrh4PVil40wrdV6bLQzAFqnJlLcKnub8P8tX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKPvPd8swY8Dy11dWKCPkwH2YCEz9OYxJAif7rdnWBTm2gaTb71nXAtvvEeC+aRY2
	 o73nTJXGzFdAjKdcRl3rAdtGkMS0Pfmpk7uGTZRYjPf5TgwxcGhPypCBEuulW9MMwG
	 Cc3u98JOD6W2A1N6NJerzMvQkkf+bRJNLOOO+tVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Gawlik <jakubgawlik13@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0603/1005] ALSA: hda/realtek: Add micmute LED quirk for Acer Swift SFG16-72
Date: Wed,  4 Nov 2026 16:05:36 -0500
Message-ID: <20261104211100.742900704@linuxfoundation.org>
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

From: Jakub Gawlik <jakubgawlik13@gmail.com>

[ Upstream commit 819f6aacbb1d1621c6a62721e708835fe1fb75d8 ]

The Acer Swift SFG16-72 (1025:173b) uses the ALC245 codec, but its
mic-mute LED is not enabled by default. Apply the existing
ALC245_FIXUP_ACER_MICMUTE_LED quirk to enable the mic-mute LED.

Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Jakub Gawlik <jakubgawlik13@gmail.com>
Link: https://patch.msgid.link/20260930145839.374762-1-jakubgawlik13@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index d26277907b6a8..24bb4aa0f6845 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6641,6 +6641,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x172c, "Acer Nitro ANV16-41", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1731, "Acer Predator PHN16-72", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x173a, "Acer Swift SFG14-73", ALC245_FIXUP_ACER_MICMUTE_LED),
+	SND_PCI_QUIRK(0x1025, 0x173b, "Acer Swift SFG16-72", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1758, "Acer Nitro ANV15-41", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
-- 
2.53.0



