Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591630;
	b=uW1q/h3sJv4VdA7btgmHQpbwKhWARbdEPIO3vzmzDExdH87SNDZRZeBIENcBXDSdEwQk
	 1wiKgwu+jdKA+a1If8V/CJwq668NMDlcyGiZ6G/ysmyoNJHBMtPE/lqnE0/Dgn4KDr1mX
	 o8/bimkQFW//lLJ2oorXawR+v5EsMe9Go8c7mz6ETA1G8WoGyVuuoly0OkhQavPuKejRa
	 Y+l216TTzb+R0uO+FW50JTBI6yTd3aAEmoSTPsI8usl1VL38mxBVdoixfLKrg22S96jT4
	 fiVxnaDT8tM5/6IkslC25SNPPHS37l9L9t/C+0Fyywqr8HxJjrFs8CIiNODvZ5LmELw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=keOkrJMlOIkBzmQcIvjdUYlvAHf2Zrh2UDLjmWEVR5U=;
	b=0BK5Rm3uWv3XT575wSuYkANXfZlWuzc3fKvVdk87cL1WlqcECkAD5dbLaGchOYts/pKr
	 aUbM4b7rSm+bXGZB+EcQlfY0fouKVHy4F0v+7Ynl6uSI42PGEqK8zz4heno4K5lEiHTa6
	 EgDGCV/eUqTuA2FXlOUf4WwmqQpnu1aHgqO8rcOsr674mnFjoYRCcRxcJLrHvyoTM3xU0
	 jMlq+EUx1pYHHuI36y7Uj7prcMiz5AR26QZpEZBBgPuF4uZ5w3y+nyAWjRt6VmsK4bx9r
	 SNDCraxZtHBYzeQclIdTPJ57BfbtKsr1in1zwYgLGRcUXdxvkn1BGujzIKWO3mFG91A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAy+J8ut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F96606A331;
	Fri, 13 Nov 2026 17:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAy+J8ut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F851F000C4;
	Fri, 13 Nov 2026 17:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591630;
	bh=keOkrJMlOIkBzmQcIvjdUYlvAHf2Zrh2UDLjmWEVR5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAy+J8utvYFoypsIggprRhPBCPKKr0Ji7Bds7zVpzTK7TkCmRYqWDfThsb7b+aO4r
	 NAeB7xEtiTtbKDGpVM4GQLVoiI2ReBAZlZiOAIYpqOsl/AbWbFZwW+Kit/X9UDHFjf
	 8tS1bWn3ccBy4DsM4VgOqjvMswMA0Qf4X3PC5YaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Miguel=20Castellanos=20Valladolid?= <josstamy@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 669/670] ALSA: hda/realtek: Enable mute LEDs on HP OmniBook X Flip 14-fm0xxx
Date: Fri, 13 Nov 2026 10:53:53 -0500
Message-ID: <20261113153834.561629338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: added the missing mute LED fixup enum entry and initializer in the existing Realtek codec implementation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6f5fa76b78f11..1a68e683801b1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8212,6 +8212,7 @@ enum {
 	ALC287_FIXUP_LEGION_16ACHG6,
 	ALC287_FIXUP_CS35L41_I2C_2,
 	ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED,
+	ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS,
 	ALC287_FIXUP_CS35L41_I2C_4,
 	ALC245_FIXUP_CS35L41_SPI_1,
 	ALC245_FIXUP_CS35L41_SPI_2,
@@ -10414,6 +10415,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_MUTE_LED,
 	},
+	[ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_i2c_two,
+		.chained = true,
+		.chain_id = ALC245_FIXUP_HP_X360_MUTE_LEDS,
+	},
 	[ALC287_FIXUP_CS35L41_I2C_4] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cs35l41_fixup_i2c_four,
@@ -11219,7 +11226,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8d9c, "HP 17 Turbine OmniBook 7 DIS", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8d9d, "HP 17 Turbine OmniBook X UMA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8d9e, "HP 17 Turbine OmniBook X DIS", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8d9f, "HP 14 Cadet (x360)", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8d9f, "HP 14 Cadet (x360)", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8da0, "HP 16 Clipper OmniBook 7(X360)", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da1, "HP 16 Clipper OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da7, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



