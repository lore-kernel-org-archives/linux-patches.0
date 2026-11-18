Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039031;
	b=NRqR47PY+k71dJy6Xy4/C5rnYotXl14oZ6QymCtTFut9QCjy8WZDBsxNBVwPgWHvXiNg
	 8OwkxKSSpSEy/1xEB6XZ6tAEbk1eiBKQCGWynxeiRsFtNKF4tWFjD/lFiuJztbRZudjqA
	 WKqBReE4XSlQTvw0Mgfoq9atn9CRucuog3DQwzpZ24FJqoBRazXO4EmZX/zuXEoR1Shon
	 Cy3DxDqwwaquZXLxiYXm403eSG3KTi+ImeZpM7X2r8mVDDNFLkAFkpencVD/4wp/K5sin
	 p+ORYWicSrxKBwGcs9RYNpPHrLOh1Ks4Cc8Zar5JwQjGwOD5wNWMtGcEcbSodrSMFPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3hzY9UE2iv7SJMELjlppm60Ws59UxzcrofEpLchutk=;
	b=kjZ9MYtqgaDLvMvJRWeEWLCsNN/13oKTUJo/Ho+kYIlRkbujmzHgrMDtYPmompHAvPek
	 MJBlX/ycJbsceUbFptrd/HAlhakzoj6lTvDhUCwSA622QxZW5XfgGOLkIFOfv3K1jKcV5
	 /M+W+CDW7MniBxUwTrnDexH5lEmzPnyf1VnHDXO46HptTE3rYhjhz7o9sYzTCauFYqVZd
	 aN8XQ9eDo+O1idI41sNQcfOqQnM3LaGWBi5CwNQndbLZUECi/1m1rf29YBGo7gz5fZBra
	 IlpP6/KdHhM8/3KQ1EXQLpeaPu+hqnvzqxQkiIwLIySndPgLNeE2NHYzImMIfi6bNTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taNqQ+IQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29525606A31C;
	Wed, 18 Nov 2026 21:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taNqQ+IQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797521F000C4;
	Wed, 18 Nov 2026 21:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039031;
	bh=Q3hzY9UE2iv7SJMELjlppm60Ws59UxzcrofEpLchutk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taNqQ+IQjqwdBty/QlWyFyC80lvOsT3ZLxh5KYLsYYEN6r/AFZVtSziNP80Y39Jdz
	 qhTbetZxUWtjH1awuKaeHW5LztORWg9jDpHDVLWcyspSm165FhM6oUCB9R+P6EU1NC
	 wYuH92UI1XZEubxnCrgGOLeFQrAM4kNwtBqT2+6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1953/3318] ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P
Date: Wed, 18 Nov 2026 15:42:55 +0100
Message-ID: <20261118150420.667305541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted quirk-table context for the older driver layout with missing neighboring device entries. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d711cd7292b2e..17b81ffb6ff5b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10770,6 +10770,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
+	SND_PCI_QUIRK(0x2782, 0x1718, "Acer Aspire AL16-31P", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
-- 
2.53.0



