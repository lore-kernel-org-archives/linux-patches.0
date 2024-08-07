Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9B278C92;
	Wed,  7 Aug 2024 15:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043469; cv=none; b=LCyVL6inMbjE/FVtukDrK1jxGw5uBjR4JUbbJC6MYXSj6jfA179XwDQCGtkdE9YlGK3fxqIp/LPhTMHzn0PoSUIsE21NsQg5pfoR7afrXPXQWaVIFwsgDxKwHi6xXvNh7ccjcvDZZLNgCMAleLOmmPJcUDnxc18rli6DywdPWfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043469; c=relaxed/simple;
	bh=8Yi0AUecKAxtttnZqqNoLpyWQielX1Py9SC195WIRLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOnkez/fX9LeufsPG4mHhehK4ctA/d6DUFhAQEDc8VyqZtreIX/K8t1nV0CayeTCtYFBv/2kRQfphpb71rMBaIepInzHy/Rcv1W4q1xKxW9G7LXOuv8KSAHEz3+f2t36BQjuygWbIUYyDx9xYTgrL0ovdm1bekL/CC8++PSZ/qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10jMP91R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10jMP91R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D4EC32781;
	Wed,  7 Aug 2024 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043468;
	bh=8Yi0AUecKAxtttnZqqNoLpyWQielX1Py9SC195WIRLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10jMP91REjrT4ayC/2H61JymTWQJ0AM0iqd9fhQRKorWebB/O5b2cf3KvLXfWUVfF
	 Hs51jjKcZwGa0K6TWeaaFmFL+PKcXaVF+wqhOZD1WGT/TNtX33cDBJRERLsvvQinV5
	 LFlaA8lcQL5IoWZRVrEpoIhEJThMu2PimuSBIK6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mavroudis Chatzilazaridis <mavchatz@protonmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 102/121] ALSA: hda/realtek: Add quirk for Acer Aspire E5-574G
Date: Wed,  7 Aug 2024 17:00:34 +0200
Message-ID: <20240807150022.735398605@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mavroudis Chatzilazaridis <mavchatz@protonmail.com>

commit 3c0b6f924e1259ade38587ea719b693f6f6f2f3e upstream.

ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST fixes combo jack detection and
limits the internal microphone boost that causes clipping on this model.

Signed-off-by: Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240728123601.144017-1-mavchatz@protonmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9639,6 +9639,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
 	SND_PCI_QUIRK(0x1025, 0x080d, "Acer Aspire V5-122P", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x0840, "Acer Aspire E1", ALC269VB_FIXUP_ASPIRE_E1_COEF),
+	SND_PCI_QUIRK(0x1025, 0x100c, "Acer Aspire E5-574G", ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1065, "Acer Aspire C20-820", ALC269VC_FIXUP_ACER_HEADSET_MIC),


