Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061152;
	b=aIluVy3cRbvzgg1DoXKGifIYPTpCo2m2MkjHrlkOmJ0PCdMe6KpkDwRwwPN7NeXnsmqe
	 pS/Wm2QHjUKxYavOcysaWrib8Onkz+tuZI8THpvvrDw1d8vJtdro4MaoQtjkGVvf06PnP
	 HJB6JVwcazNEGwuTfdlgFCx0n7vySuOPJwQog6Fp44OB3vfCnW2otsCgJQ9rZeixf/ciW
	 uf+9JcIrQvFUmphMNLdLNW38EweMXE19UHXKANosHYe0+ZujbKgTAOkEhy9ZGaGZ5HOIY
	 Er8VvIsd0lwI1jor5818Lafs7EX7AV1IyYAAsEm++c1jBqECOlpLuBffRhbzOk1yt3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C1d9OZjWYV07u/loiLBvD2XDPBa4wapYIfCq4/4L7iA=;
	b=elziSldPXSsch4MhlFeGoSObF6d220kML7TmI2tF4Rf/jAUaDBiGKFET/IwhaldoO5VZ
	 VlavpWbiWdEoEPXnGKYMU0+jo9/nHUkjmhSpaJrqHXZHrqG3ikIPaaFnkZv+tEnGkZGMN
	 6KM9+Xya50MfHrF4qeX5CJ9gVapymlEZepKgMjpA+EY1jRVSQgpd4Rws69FT45ighvKjO
	 Hi2zttzLS4sp1sOia5LDY+C5GCQ79sYJb7qIlEUQA9X4se8lYRBcV3qGeKcc1DfVsY2XL
	 b8vMHZlToGwHoVr9IsOvvBnt4sfUIevfc0Wdw/Va9rr4vS73d17EPhXvN2DUj6B//7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HlJMNoDs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57095606A33E;
	Sat,  7 Nov 2026 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HlJMNoDs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074911F0089F;
	Sat,  7 Nov 2026 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061152;
	bh=C1d9OZjWYV07u/loiLBvD2XDPBa4wapYIfCq4/4L7iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HlJMNoDswjct21LzXpxEt5Bad+xPnL9k5CMmKdMOkZF6ykIeTcdEYJ8x877dwRiy6
	 4Uj2ZpbMiFOSBCg0+VWFehlefnkXJxXra2e94G92EUSpO68RycfttYPA4zRsfi7C18
	 Fle+zlcqdT1AlEFK9z95a3Zx8HisvHNCPTq1BJhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	renpanpan <renpanpan@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0420/1536] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 14-dv1001TU
Date: Sat,  7 Nov 2026 08:40:36 -0500
Message-ID: <20261107135009.371041666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e1cb5a95c1374..30758dbca8ced 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11037,6 +11037,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8975, "HP EliteBook x360 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x897d, "HP mt440 Mobile Thin Client U74", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8981, "HP Elite Dragonfly G3", ALC245_FIXUP_CS35L41_SPI_4),
+	SND_PCI_QUIRK(0x103c, 0x8987, "HP Pavilion 14-dv1001TU", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898a, "HP Pavilion 15-eg100", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898e, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x898f, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



