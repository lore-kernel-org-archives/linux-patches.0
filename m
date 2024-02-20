Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C5B446C9;
	Tue, 20 Feb 2024 21:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464836; cv=none; b=Z0cN0Uchr8Il9PrlFdfKqX9GSEhZeci9+eXyJTSP9p+jag5rNaWJRoqR/Wjzi38neCDvD6DzL9yObhZ+kYtvEZFifVBh0wLz6n6T0GuddXS8IYSFEm1bJ5X7A58dyE0+bpbm2xVEAyegYHTBzRiTVhPXe1f/eYGXZs+7GoIfhRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464836; c=relaxed/simple;
	bh=H+jUv4belu5s7kDQ0ezq6z/U5SBojhsJlRcGiwBa/kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kktlCQw0VKqmOG52b4Dym7Uwi2f66MQ85n58lL+0q3o605bIj5GjAI16frZ8F4wz1xIa/4p9PkOREd+HzVADGdjHWP9VkKJdoniSCm4w134vFoBCZYUYPPlWy00274R7Y7wV/rc/R6q6KtBw6KSFZwung84PP72WSmn4CiQ+TQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2GuCH2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2GuCH2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B535C433C7;
	Tue, 20 Feb 2024 21:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464835;
	bh=H+jUv4belu5s7kDQ0ezq6z/U5SBojhsJlRcGiwBa/kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2GuCH2Kk2EYPArlEC773XETzGTBXRNXzQdA9eFttt0yFY8fp+CMOhcZ256kr9N8G
	 t6WwhX0xgspFUArR3Z+7xHZxOWLLN22bhFUtFt/jpjPiNm/On5e5TdWUURJWA9LaeR
	 lllxG73XZZ3sdWdtcC4TyhD6bFR0++pZ5UfPYDjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 152/309] ALSA: hda/realtek: Enable headset mic on Vaio VJFE-ADL
Date: Tue, 20 Feb 2024 21:55:11 +0100
Message-ID: <20240220205637.927228291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

commit c7de2d9bb68a5fc71c25ff96705a80a76c8436eb upstream.

Vaio VJFE-ADL is equipped with ALC269VC, and it needs
ALC298_FIXUP_SPK_VOLUME quirk to make its headset mic work.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240201122114.30080-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10312,6 +10312,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
+	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),


