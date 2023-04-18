Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EC32566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15C5C433EF;
	Tue, 18 Apr 2023 12:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821048;
	bh=wqytyHKH3AunKWoZr+cYGkW9Ob1JiMMPozrLnSddOfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8dvskLP972LtLJ+4Fi1dr+M+4KKaRGsk+xhR0EsU60RWEUfjTTWrlBV6KPaiAtsA
	 Ed9ssAF7MALz2xq9hYm6z8dn0S82zoGcDGah7xXBKK6zKBp1bo4pnirhk+0fIwxEX3
	 SvoodRpD+WP+gPF/F+8XGJD1UxHwQP7ZgdEJICYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Soller <jeremy@system76.com>,
	Tim Crawford <tcrawford@system76.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 32/92] ALSA: hda/realtek: Add quirk for Clevo X370SNW
Date: Tue, 18 Apr 2023 14:21:07 +0200
Message-Id: <20230418120305.962348222@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Soller <jeremy@system76.com>

commit 36d4d213c6d4fffae2645a601e8ae996de4c3645 upstream.

Fixes speaker output and headset detection on Clevo X370SNW.

Signed-off-by: Jeremy Soller <jeremy@system76.com>
Signed-off-by: Tim Crawford <tcrawford@system76.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230331162317.14992-1-tcrawford@system76.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2574,6 +2574,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1462, 0xda57, "MSI Z270-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK_VENDOR(0x1462, "MSI", ALC882_FIXUP_GPIO3),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),
+	SND_PCI_QUIRK(0x1558, 0x3702, "Clevo X370SN[VW]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x50d3, "Clevo PC50[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d1, "Clevo PB51[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),


