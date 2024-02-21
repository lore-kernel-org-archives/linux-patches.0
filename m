Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F48B3C2F;
	Wed, 21 Feb 2024 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523271; cv=none; b=G5SGU3lLdDHYtGsdN5MLcd+QH9SwivHIHOFov2LIEDPMKg83SslyizSP+1Oe5+VX8PTFBD8WdvqlmtQC3jau10BlbcYlXjM1kQZHcrVds6H3S4+tQal1W1yQApivjHUAHQsssf/sdfmzBlGKSIhvEAL3lom9msC8C/Ll0ugzXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523271; c=relaxed/simple;
	bh=u7UlUr+EGhFeKaLlsyn3GsjEg39miwmyoSOAnbh0iYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tu9DNI7HL8AGuEar6XqubmJIzgi1KuX/i1Ah9g6I8utqcpPmJUfrKQqfzRYIXncbAtmN01ECGZvVdkzZudJtLHOFqX4zQIdSHeKvKIT6hxf+hTxxA7xxpetVZwF9u19PuKLhYxeBnlgXzLbkMG4Hq7lzuWeZbfRAbtEOQViiSdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUn/8n1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUn/8n1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1565C433C7;
	Wed, 21 Feb 2024 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523271;
	bh=u7UlUr+EGhFeKaLlsyn3GsjEg39miwmyoSOAnbh0iYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUn/8n1r2iYQ1JhQJj92Xt5trjPCwvwwPz4KPXDD1mwvJy/xlvFDeEisT2BCmWe6Z
	 F7Wdbdx18svn0Ya5WXLaNdgctMq1TsE63wKWbdtyFhSPQu+KEmg9NE6hw4hiLeWueI
	 4Yb/6YDgnHNWzizHjHDtabGFx/YoEiA5VhgmpSxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 384/476] ALSA: hda/realtek: Enable headset mic on Vaio VJFE-ADL
Date: Wed, 21 Feb 2024 14:07:15 +0100
Message-ID: <20240221130022.235222011@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9415,6 +9415,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
+	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),


