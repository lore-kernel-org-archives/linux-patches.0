Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830844;
	b=zQRdbxpSezP4V4X08ctw0E2ovV2s/DaaaJQrAnslv1fXuKVvdK4+67tzR9rGMjDvSFPZ
	 MkKZWvYJkfjHekxkRs6XlfaghgCKAJFAxQWcvrWRq2JtX/UKB4+xsM+YfljjBpHFi4YND
	 rOcBaIo2wUxHymJsJBZSAVbU+FJiAgiRuV+9jaqQOl+9a+biPAQ8YThtpgpnT79KnTBwO
	 KANFzdBFIa4oxl9KPpjFiq0LWDBYUWLj8ZgUNhl4I4+/jCTrj2wzow295y6DIEUQvGW8h
	 Z52GLbqKYePUNYXM4huuSBD1umVlPuHTQwpvZe1rRfSeuf3xb7GT7HLXsXOkVi0V7mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ju7LmGadpFC5EW4Oo2ukpALPMiFpP6ItTK+iJ+BbEUA=;
	b=KJLmlTecWnwO43Qxv7N+Iuh3z0tAJzW6M7lSUNgC9izfPVcJQA357bpwy69wnqUU9+en
	 XywqPPMNCr0BhZLdufJ+y7VCQ4SeQ6me1WRs/GSvyrwX26PfXefLmhXE+6SlL9hGhhMQI
	 LiIGD2XDXB4vidMXXgW+PZzR+eOuKO6w0Mo7zgirNkDtuPzQz3ATFLwmQxBkg4ArqzZmm
	 zWZYMMDtgEWGQARcHV0CdUDMmT9amVmU/pfbFhpgNZzgkX7i3wdLAE65kY/XKgoxzZYX8
	 nV1zycPioVFH+CcEGQl32gUBNO9ZCc/RzeGVy2y2U6/89g0EBpGmvuTiV/zO/yQVwFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwWPg6D0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476D1606B2D8;
	Wed,  4 Nov 2026 22:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwWPg6D0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF961F0093A;
	Wed,  4 Nov 2026 22:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830844;
	bh=ju7LmGadpFC5EW4Oo2ukpALPMiFpP6ItTK+iJ+BbEUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwWPg6D0eHd55VS8u/VC53V7kQ0pdApSXCFigjkXMUXcGoW2vlKLRv6B/vcKiZ5sM
	 Artk0jRozSci/Tsc/3DEIMovP6YDH8Y4Iw2tGi1dq/wsoOxUaSjNDnlHmd3yvehauQ
	 2Ex5oW1Cu5YzbbwlQ8zdnngSTWNrJpEoq7Whf+2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0356/1005] ALSA: hda/realtek: Add quirk for Acer Nitro ANV16-42 headset mic
Date: Wed,  4 Nov 2026 16:01:29 -0500
Message-ID: <20261104211054.047576116@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit e00a6a89900dfa4cda3669558d2f3581cd41a656 ]

The Acer Nitro ANV16-42 (subsystem 0x1025:0x1909, Realtek ALC245)
does not detect the headset microphone jack. Adding the
ALC2XX_FIXUP_HEADSET_MIC quirk resolves the issue and restores
proper headset mic functionality.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221623
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260807125857.678297-1-zhangheng@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 05e7fcc2f67e6..9ec18f779a700 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6595,6 +6595,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x1844, "Acer Helios ZPS", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1025, 0x1909, "Acer Nitro ANV16-42", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
-- 
2.53.0



