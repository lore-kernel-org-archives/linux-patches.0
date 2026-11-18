Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060142;
	b=V5zpkbSioWmBwLj/gC4kWYimUeFMrdNj8w/tauRECO1N++2ghPYgGVfMFOZHE/dNoBFi
	 9aTC71DymscFA+PEg+ysUKJysQxiqrMRJ0hDra8v+23iyeShE8/ii4+83YtsQG20T32jq
	 nWDU/Ik27dASNUYtfmbtq9++cqYnceLzSgBKJcMlaMj1/NPyMNXGHAq7n8wh8QNUoEJzF
	 bzqOtm4A0NaRgBzhOMvrBosXN9sqvKHG9ZOX0+V85S9EazEs/+ogPFE5M27qFbOJKwLse
	 5kkTZ/+4TbCq+JxeWhqptRwhR61Yh92fDx5WWaITIiU3e8sCMmBXp2ZXXaSl0U3o83Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=buSxE+n2c3qe2wEoDxwyJm+SPwXu85pDViSGpmoofys=;
	b=a97/0yOzmYdGQBN4N81kML0WdK6iqCZMaKhKr28NWnl0g8CKkWLj1YyIdb/zek3hsJOR
	 G+d1a1Z1QeUOGfLGhRa3nV/RQUGTkaiZfq6lt1Gv3plZybzfi4X3XeNGDimLaEK/OM44u
	 Hjyi2oSpJNDofZe0DpPHDpRJSWBX2Qz10mlBT5Un3eqH9OdKSI1XKzc0akIEXZgUa42cZ
	 DyhX1nTM04ydtM+ZTvz63t1qDICv4/CkYI5hr5sm3SAQODFsgNp6RDLQuy5V9diM0oRA0
	 /Pz6ZemAdVIKvEOot8TAF9GXaAPfIh+NRGjWuArIVuuqgoVFu8MqKSIRiD4/VFA4R0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lnHPjVA/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B42606A325;
	Thu, 19 Nov 2026 03:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnHPjVA/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562541F000C4;
	Thu, 19 Nov 2026 03:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060141;
	bh=buSxE+n2c3qe2wEoDxwyJm+SPwXu85pDViSGpmoofys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnHPjVA/XMWxjgkua6UBBMHIt3SPBSWvVl8mm0lBnyTK8khsauE/7fK48mtKt4qLc
	 MqwMky+lYIy4hiBO4LpB6QQpvTq9JYZpAba4QHPWjpx2K9piM5toA3woTMytKUJAhX
	 G/cmyDN/un1bltbLUblM4mB5NqOOpzPSAZcrXyQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1092/1848] ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P
Date: Wed, 18 Nov 2026 15:52:10 +0100
Message-ID: <20261118150004.505791377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context to the existing snd_pci_quirk table ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4edd1e022797d..132142770f056 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9635,6 +9635,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
+	SND_PCI_QUIRK(0x2782, 0x1718, "Acer Aspire AL16-31P", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
-- 
2.53.0



