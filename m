Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590690;
	b=K8Hryl/L+7wEJ3Pn9AQ7Qg3JdxDd9as7+rIFASd5vE4QLjJkFXNCEYzK2iNK1KyEyhmg
	 DsqiUNlQlMW8kLeV07Gl5/GEnPHSMEKzR476Ukxacr7qbiEdUazy1GxxscwsEArNOrgp0
	 xJZlICxE7P/qom2W4+XxMV0BB2cdy9vqceBVUf58NMitbtTJbm8T+e7tELBuStANW8Nso
	 mhox/ST76vUv2f56iJXBP773/bg5aKdr8SS1/lZOjjQqUDQ9Ja8puy/Mo5tM7jvfpws/0
	 1KPOsLVoxOoZjZEi0Ca/MWJ/zdO3T3vY33eQbCK7HkxB7SV25ug3e1qSzhHO9xRDVQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BYx0vOuQxYj7SX5ggDTMaUeT5aXBIsoSpdHz9xSmTcA=;
	b=TlfhSr7bCi1B3NCbnlfNI3n/vJnOgOriMJhI8n9Gi5wlg5+WE6K4OPuCH8TCx1CZgh1Y
	 skcyuY+tA72DmUIvWm4+uuu2jlRW7QHUi3nyQOVMnqYRGDfcZNhHHjc1XyDvfVKLZUB2l
	 b3/L+QBYLd7miMZCv7xhoKGIPIp+dJjwPs3cOJ4UcCrOx2x15wwlhdv0ntP+1RsSTAIIn
	 pudkY3INJPInYiayERoS897PEilcH9dkaFnIdFtDqWzQAIauTtkFH2Az9Gv3zPua/payO
	 uVlnMmgzuFIwqdDYGOFM/OeKG3wZT8mK6evH7eq0UnJyfgwL3/yqApgFOXIGxj4pWVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfINq2Kh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246A1606B225;
	Fri, 13 Nov 2026 17:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfINq2Kh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49EE1F000C4;
	Fri, 13 Nov 2026 17:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590690;
	bh=BYx0vOuQxYj7SX5ggDTMaUeT5aXBIsoSpdHz9xSmTcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfINq2KhLhSL6v009A3ftui7hS+goRDVkLGGGjfSTb6svULTm9jOxx88d3buD67DO
	 m4WBRTJB9DiGIV0D6hqwwKy7ntAozfviPENV4vwbm3AaKx9CKuLn4GdV6it0WPAml4
	 Gq8qF72CdK07SA5hxjYVlWwx2fm4Q1lvQHHno9nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?R=C3=A1mon=20van=20Raaij?= <ramon@vanraaij.eu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 559/686] ALSA: hda/realtek: Add codec SSID quirk for Lenovo Yoga Pro 9 16IMH9
Date: Fri, 13 Nov 2026 10:51:32 -0500
Message-ID: <20261113153840.528377644@linuxfoundation.org>
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

From: Rámon van Raaij <ramon@vanraaij.eu>

[ Upstream commit 56722cfbb78d7eb41756cd78dc5192d08bd14f3d ]

The Yoga Pro 9 16IMH9 (codec SSID 17aa:38d6) shares PCI audio device
subsystem ID 17aa:3811 with the Legion S7 15IMH05. The existing
SND_PCI_QUIRK entry for the Legion routes both machines to
ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS, which does not bind the TAS2781
smart amplifiers, resulting in near-silent built-in speakers.

Add an HDA_CODEC_QUIRK entry immediately before the conflicting PCI quirk
that matches the Yoga Pro 9's unique codec SSID and routes it to
ALC287_FIXUP_TAS2781_I2C. Codec quirks are evaluated after PCI quirks and
take precedence, leaving the Legion S7 15IMH05 entry unaffected.

This follows the same pattern used to disambiguate PCI SSID 17aa:3847
(shared between Yoga Pro 7 14IMH9 and Legion 7 16ACHG6), where a
HDA_CODEC_QUIRK for codec SSID 17aa:38cf resolves the conflict.

Signed-off-by: Rámon van Raaij <ramon@vanraaij.eu>
Link: https://patch.msgid.link/20260430191224.patch1-ramon@vanraaij.eu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 1c36207da794 ("ALSA: hda/realtek: Fix silent speakers on Lenovo Legion S7 15IMH05")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 99d3fda16f3a2..5bf382eb4646e 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7544,6 +7544,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3801, "Lenovo Yoga9 14IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x3802, "DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga Pro 9 14IRP8", ALC287_FIXUP_TAS2781_I2C),
+	/* Yoga Pro 9 16IMH9 shares PCI SSID 17aa:3811 with Legion S7 15IMH05;
+	 * use codec SSID to distinguish them
+	 */
+	HDA_CODEC_QUIRK(0x17aa, 0x38d6, "Lenovo Yoga Pro 9 16IMH9", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3811, "Legion S7 15IMH05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
-- 
2.53.0



