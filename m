Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043378;
	b=OhY7a4mLyUyUFI7li2lX/DlnxzvpiIHYBfM3y2X8jvWYZ1BK95DTyit9h3xlTQUQFljO
	 mXT5L+1dB6NNyOHqTgHFJkLfy2gmelqA7Aig+7h+ZF3alNabNV2xQaBLFSQKXVwREW1zb
	 72UxkUT9dQPGgV7AQFAqyDg+u2lXHrYvVrsMjCuqNEZuTbd19MicNN7UjpHQ7UU+rop+V
	 hEzdTn5EQVcmsYiI6S537n0dAyc9Q2b5dQf3mkqcL4EDPopGFzJn1J/OtuCYdpjXgVxdo
	 9XUIIMN7POE+752NGIxk5YysVtWwAAStDV2BNQwBuMlgxcvNIbQzvDlsFpG+pv7sxrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=buijN4ko0kn7tZv30F0mpTa6NU7I96xRUIIFtFwVDfw=;
	b=VvFf9XH0Xuik7j2rIKD/7PSxaqcukP72snt17SXsh+u2fJ0idXoOeHU9Z1MjpZistRrw
	 2DxRlMhb70bnVSYZ3HrBlsjPZM7SNKwJ2wHUI1wk5nUuShXgvLwJvIFrMSPt+B5+MBXUb
	 e3YzEeeNCzADhxSfgqSM+fBt4IN+g3Yw92cJUgC8KBwKKJk3OJLoA02IGH6Dr7aAHZB9h
	 Xhrp8jTrk4VS65723xr9FADSvxU1gGcjJ7RaF/S/Xz9OIXDlVafJePLWu98AA2Jze5jT5
	 R3T/0k44uidHLLQheuNT20RnOrE0ygnu/l9w+yTObBbbW2iRjx9miei4H8sqcjAiJXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SXh/QCo1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07B8606A325;
	Wed, 18 Nov 2026 23:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXh/QCo1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B21B1F000C4;
	Wed, 18 Nov 2026 23:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043377;
	bh=buijN4ko0kn7tZv30F0mpTa6NU7I96xRUIIFtFwVDfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXh/QCo1XfmbV7IE9D8Es/drrSImovQopDQRdA6IFtm07y/a8A2B1DxxxMhVH3/PL
	 IrlFPDkNhSMx4XbyNa5kpn1wSiKeNFVso8tl96v9XrUUVMHot+6R2cbHnWyfyXsBvd
	 iO81L2VqE+IQNpSqOVrg3NZtOskR0sk8oD0I38xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Orozco <maudob@live.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0187/2857] ALSA: hda/realtek: Add quirk for ASUS VivoBook M515DA/X515DAP
Date: Wed, 18 Nov 2026 15:20:21 +0100
Message-ID: <20261118150208.077772773@linuxfoundation.org>
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

From: Mauricio Orozco <maudob@live.com>

[ Upstream commit a9fa2a016e805504223abf8c9b373ac9f7bfb9b3 ]

The ASUS VivoBook M515DA/X515DAP (subsystem ID 1043:1e3e)
requires the ALC256_FIXUP_ASUS_MIC_NO_PRESENCE fixup to
enable the internal microphone.

Without this quirk, the internal microphone captures only
silence under Linux, while it works correctly under Windows.

The fix has been verified on real hardware.
Tested on an ASUS VivoBook M515DA/X515DAP running Linux Mint
22.3 with Ubuntu HWE kernel 7.0.0-28.

Signed-off-by: Mauricio Orozco <maudob@live.com>
Link: https://patch.msgid.link/20260730033506.8958-1-mauoro3@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3f74f485298cd..68ddad4689fd3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10191,6 +10191,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1da2, "ASUS UP6502ZA/ZD", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e10, "ASUS VivoBook X507UAR", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x1e3e, "ASUS VivoBook M515DA/X515DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
-- 
2.53.0



