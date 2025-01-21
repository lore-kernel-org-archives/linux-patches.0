Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9E61F4275;
	Tue, 21 Jan 2025 18:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482712; cv=none; b=RCnO+DNLwMNGs+2gmgvKTMQMS55W4zVOedNITfORuAaof93JmLNKrqOgNaTYwmuEWIlPrnVz69u7Z1+xrMAMwJNvADa33AzMUeFCgPn+xLndHq9K2YYlmJmf97IM3ljc3lE3Hs+xceiPhkwy6gawbFrR2s2n31VkJ6Wg4KjJbBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482712; c=relaxed/simple;
	bh=vAFzcfIVd/hA3FGWgw2JTgpTmMGVTwe2XfrktpjmfOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIu0Cwd+6lVaFbbkzPXmU06/nKkJ6I1URiXlqxYy4c1/VRPNCoVimn6yRCoEbHqo+KczurA3e/0iDlwlmyv0O6b7rCFEsLj+3iIrH2xGF8codYwYPyq6iVk2QGSiqRaeQoJDsVY4n6xwoJe9Mj+YCBsG3/fm5FAfa2SS4uisjcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfUa9xFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfUa9xFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A689C4CEDF;
	Tue, 21 Jan 2025 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482712;
	bh=vAFzcfIVd/hA3FGWgw2JTgpTmMGVTwe2XfrktpjmfOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfUa9xFba7zfNs0LgdKuSJQTokQkOQ5ga6nWYDvIjVY6om2nu7hFo/5YkjgeVz+MH
	 pNhm+2uC7fCffKWN7dsYanodAGqLnvZrJfwC50shAUgstUuTQeVnBEipzVLJ8qsoQ9
	 ngdT2+eNbcSPA+YlXXQRQd1hc71rm0gNVYAiibes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 30/64] ALSA: hda/realtek: Add support for Ayaneo System using CS35L41 HDA
Date: Tue, 21 Jan 2025 18:52:29 +0100
Message-ID: <20250121174522.704247173@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

commit de5afaddd5a7af6b9c48900741b410ca03e453ae upstream.

Add support for Ayaneo Portable Game System.

System use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250109165455.645810-1-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10242,6 +10242,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),


