Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047617;
	b=ju+sNsMKtUTsPvlpAuPfWaEa4hicUUjIO6JlD2mGtL1swoeqRNqeI6BIuJAajI1OScSV
	 +9kUBERpEqryYJnu2GV0JDzLVZLWM5jG2OWLyvfPhxoIN2nb6sW723mrjglh13Y0X4OkB
	 0d3ZdJ3e/FWhQczhzC9x3Ahl+AlOmTTzlArw0v1ozRnb0K1dO+B/sIVJd1+RumwzkBDMj
	 h//DiNmoGy//MaB1nmvklSK/Icz46+hJJEG9eDP3x7RvCRdVZ9jmPDnjVZY9RCgEuKH/L
	 WDF+F7cZX3VSAgJ6NvJFqDB/vJUqgAvGQ5RlmPHjugB/8X6ZZ82t6eHW19GYcCPoA7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tDvhXLABZRLSmai2F7NzP76hn+AWNxhxnRG6Tt7+X3Y=;
	b=dr40SQwJ2UJCNFDVWVmAKo2xZWfMsV8qBAjIItaR8gXOGsXXOUyhKnHLyiP5jg4RjlxZ
	 Va0bN/SVg30EXFQpSQ5d+9MymIa1Zf8CJYUwhzuwM5k5ZIvGoCJKb51AEpDg/V/1nI+oB
	 vCNGhb+8DcFWIFs9znpxWJMlRquEIuOlrTSPnJ4VgaAEIbYpu8P5SUxVDb27dGVQ3/OeO
	 5YgvLTM7K73w5qrP2QWu3yTFzU5UXTojyscJp5Rm6mGatWo24TAY3Hc9BLnMpVzP+ySF4
	 WL/JdWz8mdtEQFcGG4hfR5U+nQML5S5tC/9T6ssvHZB+mrwuA+APEjv41Bc/MEsDrDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCCjJbhj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDF5606A31C;
	Thu, 19 Nov 2026 00:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCCjJbhj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712821F000C4;
	Thu, 19 Nov 2026 00:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047617;
	bh=tDvhXLABZRLSmai2F7NzP76hn+AWNxhxnRG6Tt7+X3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCCjJbhj5oI3n0HGrVKz4Yw2o3yLCLyGnB2EWl/RdnpaHJiLU9+4pFGc/Jxa5eRFX
	 +I9gfrHgqZ7Ty2emwRpucS46rSOJ0WContVKX6/QUxXsesCwGk8XBWUKI7Ew2ppHyo
	 uoDNPsNmuF4HPhsr+AxWUsF9LWmu2P7gAfpRUQKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1702/2857] ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P
Date: Wed, 18 Nov 2026 15:45:36 +0100
Message-ID: <20261118150302.614015111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context for the snd_pci_quirk table in the consolidated Realtek driver. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f83afdc59e4e9..d49a2c74d5af3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10528,6 +10528,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
+	SND_PCI_QUIRK(0x2782, 0x1718, "Acer Aspire AL16-31P", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
-- 
2.53.0



