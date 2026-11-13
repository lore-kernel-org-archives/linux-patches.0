Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585815;
	b=MMvLRLVZbdDGr7S7RXWnBIOoilqQ71gU4deMPpH+YRt+beLfFzgZqJaOFDA7fK0rdYtu
	 gnZ3SGBIy15uXXujmPAsJlN6iNO87p+/Hvn00ReP/x+ajW46AK7ariPiajB7THvr5sned
	 50ZJCaE8GTXHmKoI8MCFmNp7KFlmxE060WpuOTEfr70BXytUCqlue7z85fXN69Ke19agV
	 s6cdUIiJmMEQSGcy7PE+i9MqPfYWPVAGZR6+/OOuxV6gMGH5v5AJNipODPs/hzAAmn9d+
	 LFZUBDYsucDLw1wpXt7JZcBdBDL1TPbsu6lLgW/SEBKnkUdzrpVCem+3UUp+Cg/E1cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SsKSDLNHUnIYvfiwTP/Dvklp/KFsw6cetBzoSmP3BjE=;
	b=JMS0J407xA0SgaakZbeeUTjXVoBMPQf1e/VteGJpo6MU9+EMOy0JPMHjBZr7ASggBQHc
	 dPSbasGzQLygREeqF/uPtE+xmOzneD9Hq1GEaHv1uO3PotDzKFnV4ajr1dIst480YtHOi
	 7zdAL94QIa+hVFda2vFABXXX7u1U/uC1upxMQjKFKbIpqjj2F24nVBV68ZGbubkw562g/
	 S5QYZ9WzuaT1OiUSAM42oBADcahYp/xyHleCd3C8ruA+PZJoMaloCsfkk7A5UWGxP8SVM
	 N+vmFURwoLdyUqAAgfQsNWQbf276hb43vqHnn4ZUbKSKhT0Nq8kYetAxlIP3DGD6oaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN9hrGac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D8D606C554;
	Fri, 13 Nov 2026 16:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN9hrGac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CE71F000C5;
	Fri, 13 Nov 2026 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585815;
	bh=SsKSDLNHUnIYvfiwTP/Dvklp/KFsw6cetBzoSmP3BjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gN9hrGacZuTqII1wt4nmOSh9eAnFA2PqFKOqIQAf5rMrZwYwNOkZof2yswIAv0T+v
	 3kVPnPVQNmjvCYsdMbMBMgG5H288yURGmQf8EDzUlhEe/JlN8qt0iJX2n8UdfdZTqb
	 SaC3YCub8zB+bvuaFJ6r12DUy5L4c3MtvzsRna3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr <youdoit@mail.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 397/507] ALSA: hda/realtek: Enable mute and mic-mute LEDs on HP ENVY 17-cr0xxx
Date: Fri, 13 Nov 2026 10:51:41 -0500
Message-ID: <20261113153810.203913774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandr <youdoit@mail.ru>

[ Upstream commit cf79cc4996bf936fe159af2a600519b3ebd4ccb7 ]

The HP ENVY Laptop 17-cr0xxx (subsystem ID 103c:8a2e) has mute and
mic-mute LEDs on the F8 and F5 keys that never light up on Linux: the
existing quirk entry only sets up the CS35L41 amplifiers.

The board uses the same LED wiring as the HP ENVY x360 15-ey0xxx
(103c:8a31): the mute LED is driven by COEF 0x0b bits 3:2 and the
mic-mute LED by GPIO2 with inverted polarity. Both were verified with
hda-verb on the actual hardware. Switch the entry to
ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS, which chains the amplifier
setup with ALC245_FIXUP_HP_X360_MUTE_LEDS, and use the DMI product name
of the board.

Fixes: aa8e3ef4fe53 ("ALSA: hda/realtek: Add quirks for various HP ENVY models")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexandr <youdoit@mail.ru>
Link: https://patch.msgid.link/20261103142121.74032-1-youdoit@mail.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1288b180df752..dd3466c3129d7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7606,7 +7606,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8a2b, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2c, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2d, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP ENVY Laptop 17-cr0xxx", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP ENVY x360 2-in-1 Laptop 15-ey0xxx", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8a34, "HP Pavilion x360 2-in-1 Laptop 14-ek0xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
-- 
2.53.0



