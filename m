Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044005;
	b=e3CTx7yZqyOc8za0ZNx3WhzzYMljkZtckkUx2m3ZAHalCA2MDT3LjNDGjL6vMQVgvm6S
	 4+1EGksS18LBRGQrTuFnL/C2as7z+c6DB50KOQKfQSW4AhmV3GSx8Kwn+EFtuiFZ8y234
	 HDhrBRnUqyjekxbqXHfp+1kcNRIL/O5Mk05dYi2JXTtE2ryGHSBB3fEZ5mBNX+mayLg81
	 MGugBmI+fLIGO45haXsODHhdy1i1vAKS5zqX8E5NCM1ug8020AlMnBkhQ02wO2xfh1jl0
	 p8TSRb/EJMfT2jl17eqROu64YCzNJG6L/L6okRXmAy8SWiyWpId2zk85yfUcic7mceA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U6QhG/16P0OmBQtc23UujuiYonhCpV6Qz3S9iIk8fh8=;
	b=JCfl/o1lhqSMGvQ+WFKZ+H8ju3gWuPxq56RoRXhr1gH+tlMpefO2z9M3jSf+neivATnl
	 rfDd/WGSGOV2pKYwGw2cfKQbqYfpT3IbEi354wFsge0e1kWX7U3U+fz+vma260JC0kRmo
	 ZgdVZKYZEiWNj1Nc6jPtqboqWSj2RlbbYI4T5tzwfv3U1R4w8X+xjNVbMXptXWdvMpshG
	 QAmcKwQhttrjjf+vKcZFpu+ttfoiyn2Sna54k76jFVmzkY0sCIH0Hmify8RJw5RfBABFI
	 zbUPPwFNpn99f+N3+G0o9rnQe1lcNoB+YyLBFGJaUt6ItnxH20E5SUCetI7h6xUBD1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ls9RJLlK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D258A606A32F;
	Wed, 18 Nov 2026 23:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ls9RJLlK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325551F000C4;
	Wed, 18 Nov 2026 23:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044005;
	bh=U6QhG/16P0OmBQtc23UujuiYonhCpV6Qz3S9iIk8fh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ls9RJLlKGvj4C+b6E2gZ4jc6ERsRpm6BsPW3tS+KT42aH0+rH48Sl+19JsvgNBwXQ
	 F8hcZ1khnFhYzkUnqM363lwWzfhl/fTg9j97Lw5fGY9sIBeywbJmz7PFvShTCSeeKp
	 QRKia6ARJUx0s1+HT9tPSjzceyCCUZfecsVNpC8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0368/2857] ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx
Date: Wed, 18 Nov 2026 15:23:22 +0100
Message-ID: <20261118150214.670921046@linuxfoundation.org>
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

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit e72d5659a2606056a0c34af212b46a3275a55bbf ]

Fix microphone detection on built in headphone jack for some devices

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260821144437.27233-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4b489e7ad7f3b..5d4b8ccc6cd08 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10497,6 +10497,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3033, "TongFang X6SP45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6KK45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x30ba, "TongFang XxAF5xxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.53.0



