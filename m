Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064965;
	b=WBF9udhrRTZrTXty2es91n7I4nxwbRcfuBPlidzOOQUAsg9fqaQaeN16rO3ZjkZaau19
	 Cft8PfNtIrKtxGjDDuC5YsAMxAzDa48fv+H3daBl4mJLZpIhj/0MA5qy3e9CJA5rMDV4I
	 uEf1Ms6syqkGbWTTWYpvdZHcleQ11WO2msBAqZexyG3UiDLreU3oDyaRcEy1B56zdfpbl
	 6Uc0GnbQYj07keSjJZYDDvuf/K3wppd1P882U+ff/q2o1OPp96mSOwmJofFOBLLuUd00w
	 EqDbtcxxt2oOks9xus9eAfzRZdWO3VsAGevBJjpjhCAsKKU7EmDrpWSb9zEy2Nk+zhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZwytqOTR/gjl8lXTBifHnmT7Q2svXNfrivBeAExJj0w=;
	b=KbOS2FLkjH3ZRLPqzvNfGNy3jXxr/Pte+VhcN/toF3HPvU2iM1aOPVfiV0cXcK90RBN2
	 fYnK/YvWSHwQDtYXMOaGNBrOJ/91qesVMmtMy03HLv6/7AVJBMG5hYV6qpK7TGEcMvvoG
	 Kxc1Yo78GCh8cvyXSf/rvqRkbtazkQ8XZ8m2j9QwZg2szaKwWmE/3Jwcfv9CJhgP0MVAV
	 2S8Tpdns5A4ejumbE3C6giE5Fndbfkxlxr9RT5mLocSkQqaqM8wLA5zVi1WydJahrNUux
	 3ujO/tno5rB0KYiFXROL86MDa9y+EGETmaImwpW4bScKNBaNRehSBka+A7+SVPkD//Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbDkV18G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB73606A9D9;
	Sat,  7 Nov 2026 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbDkV18G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D285C1F0089F;
	Sat,  7 Nov 2026 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064965;
	bh=ZwytqOTR/gjl8lXTBifHnmT7Q2svXNfrivBeAExJj0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbDkV18GXXHqWJXuGKkzdNd2eWxX06ZtXcGwBCSbwx8HPAYKATgnrqfuZ2++Q4g6O
	 Dwbh/YO+L4ONV0leoFBY1vBfUTYpZQBNXPpkZEms5ckZPT/qLkSGQKKBiY7lV6uZvi
	 RVI7QIu3BkrLbIDhvsrzKZE5U058dSmSm8PmkyCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0848/1257] ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P
Date: Sat,  7 Nov 2026 08:52:24 -0500
Message-ID: <20261107135002.746245292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>

[ Upstream commit d933955c456e0573b40eae4f72a3af37ab1c15c3 ]

The Acer Aspire AL16-31P (Intel Alder Lake-N, Realtek ALC269VC,
PCI/codec SSID 2782:1718) has its internal speakers wired to pin 0x1b,
but the BIOS marks that pin as not connected (0x411111f0) and only
exposes pin 0x14 as the speaker. As a result the internal speakers are
silent while headphones, HDMI and Bluetooth work.

This is the same layout as the Infinix Y4 Max and MEDION E15433, which
share the 0x2782 subsystem vendor. Reuse their fixup, which configures
pin 0x1b as an internal speaker and limits the internal mic boost.

Tested by booting with snd-hda-intel model=2782:1705: the fixup is
picked, pin 0x1b is used as a speaker output, the internal speakers
work, and they are muted when headphones are plugged in.

Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>
Link: https://patch.msgid.link/20261017005039.9139-1-gamaerry@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 946989d9315a5..e71f78b13a277 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -8460,6 +8460,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
+	SND_PCI_QUIRK(0x2782, 0x1718, "Acer Aspire AL16-31P", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x2782, 0xa128, "Positivo N15RPE-S", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0xa212, "Lunnen Ground 14", ALC269VC_FIXUP_LUNNEN_GROUND_14),
-- 
2.53.0



