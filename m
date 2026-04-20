Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964D14DA53F;
	Mon, 20 Apr 2026 13:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692022; cv=none; b=MOFBkbnLHJKWB7wtVBqaBqP8JYwlIBCE0bUEppurQvlUMF4DVLtHzL9ph6GH+FSDU2lFJcTU6brlPBluC/w6QzfjxwQfyzwCexWJR08RiNrQRxbSMTaBTov4EiSbI60/RI2ZFWu/e8WiNvIu5pjZg0nREzvJHinakkwkRwswY+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692022; c=relaxed/simple;
	bh=zxKAbK2rhg0pUJRzrTfbWLXfC2u3Y60uOrR/VBiOZA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeljVQ+ADJ+T8IqOizIsECiBsG2Ih5h/57enBs6WxdG7DJzV5MghwKsOdJJq0JCESvGIQLLrIf+5C4MXeScXVuEq1XETwPzkFRwDnvG04BXGAogVk8f/5lvP8AUhV3uWfyGz5l9PEi5hGaNXOKslqj3Q+M/WAZfXWU+yyRSS1cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SjJWvB2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SjJWvB2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88269C2BCB4;
	Mon, 20 Apr 2026 13:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692022;
	bh=zxKAbK2rhg0pUJRzrTfbWLXfC2u3Y60uOrR/VBiOZA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjJWvB2e0GJeqnZD4k1/pCC+8bo2FOeGalmZJqJXgF5m5r6ZSA0cs27afllZfzXpm
	 P2E6YbJGMTGGsjc/VgwxqX/d2dSRdOwUxmdSxUD0bPoMHoxCMOKL5g//ROE1vBaOR9
	 zku9S92eXgXoLOzswihXhDmm4gxDh0j28NXaEePt0WBE3ZfEjwleh0kvHccIbzMOGs
	 D5cxU2smzg6+Jxdzmz8+FFaRNN9ClRZaalzMCfoeNFOq1zoVtyhptomhVp3+++sSHJ
	 uQy8mtIH4oLBpwm7QnBBwz599mfddPMf2DT9lVSzPb1G0WsFMXJeekcR2ro8Ya9vKn
	 nzJzEL8aQjH5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: add HP Laptop 15-fd0xxx mute LED quirk
Date: Mon, 20 Apr 2026 09:22:02 -0400
Message-ID: <20260420132314.1023554-328-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>

[ Upstream commit faceb5cf5d7a08f4a40335d22d833bb75f05d99e ]

HP Laptop 15-fd0xxx with ALC236 codec does not handle the toggling of
the mute LED.
This patch adds a quirk entry for subsystem ID 0x8dd7 using
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 fixup, enabling correct mute LED
behavior.

Signed-off-by: Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>
Link: https://patch.msgid.link/DHAB51ISUM96.2K9SZIABIDEQ0@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index c782a35f9239d..0c975005793e7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6977,6 +6977,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8da7, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da8, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8dd4, "HP EliteStudio 8 AIO", ALC274_FIXUP_HP_AIO_BIND_DACS),
+	SND_PCI_QUIRK(0x103c, 0x8dd7, "HP Laptop 15-fd0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8de8, "HP Gemtree", ALC245_FIXUP_TAS2781_SPI_2),
 	SND_PCI_QUIRK(0x103c, 0x8de9, "HP Gemtree", ALC245_FIXUP_TAS2781_SPI_2),
 	SND_PCI_QUIRK(0x103c, 0x8dec, "HP EliteBook 640 G12", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.53.0

