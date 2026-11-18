Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057559;
	b=1cZrQdKHmlxCVMmsMseqWE0aiOJS2NmrIgTZj5ckbprnhfPn9fvXAbl/BdjC1thgaeqc
	 7uTGNJpxkS7exEwSglJk6iC8DTiwwVvauTCnlKaNz1HV4uOz5Rxo3QBVmQF2JeUPqWSn4
	 VTsQm3muEta+z6kF7NialY90xMDMLlgrvqaG762JcgTmdhTRyFDYPqVb8UnYKltqyI6nF
	 9J9qUJ5pftFuacdcn9Lj/kf4GyneikfdhoSnMQuDO326XiY6/uC/8dOeUokY+mhWY600E
	 B4cEfjwXwaFv+uaEbv25xd+lV1Vcyvxg4Alv3HxnF3o5pXd7AaFHVVdToHbuD87hkRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J71JJ4W0Q1D8r6G4XyCD65kdGpRdHpuNUUXrfhg2rBM=;
	b=trTQlKoRdcLUq/LMvr4W/2IYaru2mCmLFQyMPU3Caw6mo4y05Q2HNQ8p46OTP+QMkrnk
	 UGRlCBQRdE8+v2Uu9Srowrf9T0PydqqQ0T0Tptyc48WZ3us+1d9l/0uVsfi/QqOMj+caF
	 KYbKSgTFqS1UBoRFsnWOFTvj8BnBwDk8AVMfA6Gg7FwkRs9UGZHuS3kLEipNxsh/fWsgj
	 IzzKcMm6kEZ6sg/S6O/0yQuqKqungNyT1W8X41KQVj9bQsOk+QSeqBSotFXzqXE5Yfsiz
	 Ef4oM5IYK2/+fecfyz8iORgp/eEQcb9YR1MrX8k08I+iZHCdvuJSTDOSQ71z495JwAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1rUUXyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAEF60A260A;
	Thu, 19 Nov 2026 03:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1rUUXyY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA5D1F000C4;
	Thu, 19 Nov 2026 03:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057559;
	bh=J71JJ4W0Q1D8r6G4XyCD65kdGpRdHpuNUUXrfhg2rBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1rUUXyYmQFcwCY/DS4HvR8Fe3thL8+YLS9ENse3Oa4QtZ7haAi9ASSkK91Rsh/x2
	 tC5F+XP+9e/jfTpjMpdSSpF6vAf9+12cp9B+sBhrb0595DYPsZZWtDiv17Mv1lQMHL
	 4r6zjk+XTQDB344q727gPAOLS4IsHfCKLz4w975k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Moroziuk <dmorozyk1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0172/1848] ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5
Date: Wed, 18 Nov 2026 15:36:50 +0100
Message-ID: <20261118145918.779762203@linuxfoundation.org>
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

From: Dmytro Moroziuk <dmorozyk1@gmail.com>

[ Upstream commit 191fe151eb85ff6cb24189fc88c970745497c057 ]

The HP ProBook 440 G5 requires the CXT_FIXUP_MUTE_LED_GPIO quirk to
properly toggle the physical mute and mic-mute LEDs via the CX8200 codec.
Without this quirk, the LEDs remain permanently dark.

Signed-off-by: Dmytro Moroziuk <dmorozyk1@gmail.com>
Link: https://patch.msgid.link/20260812121856.30353-1-dmorozyk1@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 3a4c874f727dd..d4e7d0ad1358a 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1055,6 +1055,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x837b, "HP ProBook 440 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
-- 
2.53.0



