Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831101;
	b=0qFlNBS/JVptnUTcop22sF5F+s9WYNmVTLIljgeRh1A7txVFhLtauouL3Hyp2VONsZQF
	 Gsr5kELNQoAJ0PBgSoxLurFY0cEtcCMgOfxA9VLdERPMSBR7xtRtitf7oF/SEX0pNqVa8
	 BE5R+1Wm5eC6ju5OrXIZyJx41ZIWfQvNSYdWW5XQrp75bLorn/FGN1US1fkrpE35z3gFL
	 saqve8aWpjg9dP6scwCx0NYL5YGBJjm3PRvjXuTlvvwjKhGiGlIH78f1QDQgra/DTGarx
	 rq+9bm1m5SUjG/mgQVoWyb3+O8BAFLV0BlQFaO2USNBXnS/anQ39HfbPdgCpQz9hfKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x6C5wJPYvcDiP33H+OZL4uQ921arov9CuaTD7GkWxZA=;
	b=RSU+koUi0yF52H961m9MpUrvTLF2ANeq5lLZYusf0lvdWiih0dKoOzHUen6/jB7xHi2L
	 X0RrYDuK2x7Y2TbDKt63E3t/Kk1bbw2L3zg2WxBgCSyjJyXJLNGgj0W2K9oaYIoK890eA
	 YTo4ynx67dGBBVtsb8OzGaQBqitB4tZCIdpN2W+ALb07tMAA1lYM6bq0fa5Iu3QgW/vEP
	 AZqQmxhVxk+o59LGqJ/6rGSdEWIOfyhdo1N66BN85CcVp2NV7MJPfs7gtdfVeYgoSTibx
	 Y1ro+NrjeZkLk/cPPgiOSKEIlsy/GiSxXOSBkpu5SqtksvesU66KmSty205t4cLRXKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qsv0YCDc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7FA606A326;
	Wed,  4 Nov 2026 22:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qsv0YCDc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8868E1F000C1;
	Wed,  4 Nov 2026 22:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831101;
	bh=x6C5wJPYvcDiP33H+OZL4uQ921arov9CuaTD7GkWxZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qsv0YCDcLfl51gOmPmf04OpY7pssy7eCAbzFaTB06MBMAwi6A0e4egaLrgQzVWhEI
	 M3Yq/rPRPkURdyca7++I/vPL0nDMActOyyJy60eJhOxhdyxAW07j53wrl/zxwTGhYh
	 yZE9iK0PeBQg3G/JOsDpmc4SvXxi96b71nnRi7Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	renpanpan <renpanpan@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0501/1005] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 14-dv1001TU
Date: Wed,  4 Nov 2026 16:03:54 -0500
Message-ID: <20261104211057.978915938@linuxfoundation.org>
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

From: renpanpan <renpanpan@kylinos.cn>

[ Upstream commit ece609abc95cc0f75e633d93f3d868b030d9a8fe ]

The HP Pavilion 14-dv1001TU (subsystem ID 103c:8987) uses a Realtek
ALC287 codec. The mute LED on this machine is controlled by GPIO bit
0x10, which was verified via hda-verb, but the subsystem ID is missing
from the quirk table. As a result, the ALC287_FIXUP_HP_GPIO_LED fixup
that drives GPIO 0x10 is never applied and the mute LED stays off even
though the associated LED class device toggles correctly.

Add the missing SND_PCI_QUIRK entry to map this subsystem ID to
ALC287_FIXUP_HP_GPIO_LED so the mute LED works as expected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221810
Signed-off-by: renpanpan <renpanpan@kylinos.cn>
Link: https://patch.msgid.link/20260930065504.24151-1-rppxj178543@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a40b85fbaf393..2a466ef894697 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6902,6 +6902,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8975, "HP EliteBook x360 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x897d, "HP mt440 Mobile Thin Client U74", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8981, "HP Elite Dragonfly G3", ALC245_FIXUP_CS35L41_SPI_4),
+	SND_PCI_QUIRK(0x103c, 0x8987, "HP Pavilion 14-dv1001TU", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898a, "HP Pavilion 15-eg100", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898e, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x898f, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



