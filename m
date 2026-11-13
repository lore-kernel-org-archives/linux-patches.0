Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590796;
	b=a4Ea8rsZe5lhheymtDD6XWbtDfpW9i+n00dchnAt1NZAr4GvKlfp1eN+E1b4++tqo2RP
	 PtsRUSWQMqeNVfKAqthnM6cdy97wbHRJASWPEYYB92i2kDu7U+Pi+QaKCxzt4Cbnpl6v5
	 iMu4M0wcNAWw9qK4TNc3CHuZ/OVoF1IlCe4VqNLmrFSrmlDWzukaLMPGH8RxiVQNrcK2o
	 HZAE+rmxL+JUCxmpngp6mjDdiXaqnpadXjWEMMLCax2bYt1vav0uXIcFCEgervzCYK1eu
	 zTKkexd/DYguoUGMAuWqmXO4FndvJZSw8DkkkDf8nh2Un0M6iD6V4hE9q72HicDl0jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bIrMNDqJDRK/r9DIrB+F3Rc0sT3s0JVQfa9QS2nHZxE=;
	b=j8SaerXjfle5V5Qdtra/kh4xD92sGkrdAYwwfim+jKn49cOsw2gYr4jETPP1ofsv1szA
	 grTPc8S+7YDnzD04jZmpOsyI6kVr5iiY0oQ4/BqL0iX8H7EwspEqhBL6WeBfgE+wiNkJV
	 FveckTJb76RZbvyPSG2+0WG+eZ01LwuGIDZ95cflQ+n1odA7QhEtQKjzYzlIuRHECP9Rn
	 z2hhTtUF4W/CoT06UguspmXygkHyYKT7XDdkmewrYc1G6Rx4c8bM/SUMQI2c5fpwwr0ea
	 MgYq6gBzEfoeW9pF5YMu/9A7vhPOjCYkQVdsd3Iwi51humnsuPAMCt/xvyFu3yiJU7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=crj7+saD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C6A607D2E7;
	Fri, 13 Nov 2026 17:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=crj7+saD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A391F000C4;
	Fri, 13 Nov 2026 17:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590796;
	bh=bIrMNDqJDRK/r9DIrB+F3Rc0sT3s0JVQfa9QS2nHZxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crj7+saDK1qq49yff1UlmTiljV4+ulzDzPhKwN+/sbWg17u48P+N1Cr9sEk5Lk7Dx
	 w/CmseXRZl7ey9dknT82O1m0cL7YV58Y55UeahK9CS8QBUZKzLFn4XiuztuO+o20MO
	 sIsEoHvL3l2KnQMHh+6rsRP43QvXBvoOqXDPsHGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Miguel=20Castellanos=20Valladolid?= <josstamy@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 686/686] ALSA: hda/realtek: Enable mute LEDs on HP OmniBook X Flip 14-fm0xxx
Date: Fri, 13 Nov 2026 10:53:39 -0500
Message-ID: <20261113153844.862430939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Miguel Castellanos Valladolid <josstamy@gmail.com>

[ Upstream commit c80286aaa4acd52f9bd0b0d4914d2069fe6ba3a8 ]

The HP OmniBook X Flip Laptop 14-fm0xxx (subsystem ID 0x103c8d9f, ALC245
with two CS35L41 amplifiers over I2C) is currently handled by
ALC287_FIXUP_CS35L41_I2C_2. That binds the amplifiers but does not set up
the mute LEDs, so neither the speaker mute key LED nor the microphone mute
key LED lights up under Linux. With that fixup the codec GPIOs stay
disabled (IO[0..2] enable=0).

Switch the entry to ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS, which chains
cs35l41_fixup_i2c_two with ALC245_FIXUP_HP_X360_MUTE_LEDS. This keeps the
amplifier setup and adds the speaker mute LED through the ALC245 COEF
register and the mic mute LED through codec GPIO2. It is the same fixup
already used for the 17 Turbine OmniBook 7 DIS (0x103c8d9c).

Tested on the affected laptop with v7.2.11 using the equivalent
ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX fixup, which has the identical
cs35l41_fixup_i2c_two + ALC245_FIXUP_HP_X360_MUTE_LEDS chain: hda::mute
and hda::micmute LED class devices appear and both key LEDs light up
when muting.

Fixes: 29951021367f ("ALSA: hda/realtek: Add support for various HP Laptops using CS35L41 HDA")
Cc: stable@vger.kernel.org
Signed-off-by: José Miguel Castellanos Valladolid <josstamy@gmail.com>
Link: https://patch.msgid.link/20261017050615.14481-1-josstamy@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index ebeb6297f4715..7c89b3796e1b9 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7153,7 +7153,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8d9c, "HP 17 Turbine OmniBook 7 DIS", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8d9d, "HP 17 Turbine OmniBook X UMA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8d9e, "HP 17 Turbine OmniBook X DIS", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8d9f, "HP 14 Cadet (x360)", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8d9f, "HP 14 Cadet (x360)", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8da0, "HP 16 Clipper OmniBook 7(X360)", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da1, "HP 16 Clipper OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da7, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



