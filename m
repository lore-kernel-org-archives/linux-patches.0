Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04C12D023;
	Mon, 10 Mar 2025 17:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629432; cv=none; b=CRGyItxwYTUBKuNEhgHYzg+hD7pi6dxHTaFoGof/Bq25dxMWqtXaJKLw41KuAiWfE3dIFlR1W7AX14Vdb2yZxH47rtacGWQrY/cGsz/6xtEqS91Xe5zZQkKkX52yAQpbj6K+FVmbvhMKgkH/fpiYesngqQ4N7BMSAf22CAHNGak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629432; c=relaxed/simple;
	bh=X57/0YsDSerEl2Xdzw9b0xVzR3jcLwLxHQbbko3p/PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxOu703iN/IYmlISGlVTc0v2wxSD4MvZQVSjlwqmp5RdCpV9zFuttOnP6C+WrT20rvvpescDCoF62xZo8c6X6SwqhJISxWk0XalJLIcfc5YpTvNVAaa+s+5bPA+T8EV7bcpk72/YcDQ2IfDQHynhrhyHuBl7aysWMOChSmTuUDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muVT5/IH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muVT5/IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A6AC4CEE5;
	Mon, 10 Mar 2025 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629432;
	bh=X57/0YsDSerEl2Xdzw9b0xVzR3jcLwLxHQbbko3p/PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muVT5/IH2UUVPvVSL0EL/WKUX2lzmfYp0P9RKuGiQwkpRKNOLlCYx4c4e04+4oMYO
	 Niy7zowdvHcPDNcXidVr0ifGq6lXwrl8zdluZUX73abSaaE0QkxIlQ1LJ9VN/UyBhZ
	 ubXRQBzcEhfVs3iELMmVGrKBEBwi1VF9jN/pUdBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 293/620] ALSA: hda/realtek: Enable headset mic on Positivo C6400
Date: Mon, 10 Mar 2025 18:02:19 +0100
Message-ID: <20250310170557.185437175@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

commit 1aec3ed2e3e1512aba15e7e790196a44efd5f0a7 upstream.

Positivo C6400 is equipped with ALC269VB, and it needs
ALC269VB_FIXUP_ASUS_ZENBOOK quirk to make its headset mic work.
Also must to limits the microphone boost.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250114170619.11510-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9517,6 +9517,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),


