Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065E2343D6A;
	Tue, 26 Aug 2025 13:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214103; cv=none; b=Fyd2Pbao50xeOtjF9viiXPbO31YrOWUmXAue5yvzXfD5kLUKqSY5Rj6skJXou7XBLSv7fpVvc2XqUlfJYHmES8KN/gOn2acv8XmDTM7ecYISDEXVVMCqVNOX0KGVTD5yEeJX23T8E3/lTysxSlXeideOdui4PRUgWAcHImXFtkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214103; c=relaxed/simple;
	bh=GIijY4ceGvQosf1loWBLWu2Pz8PXt3rz+8fWuWtHydk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ed5gd5h3ESGfR3Tjimn+DsUt0ejzNzR1jIlNAgK7llMbdgHvAWNjSgypF3AWXVdd9+8GMQw2xKow5xqRQ/bmPfj6oCIFr4TLXZD3nJtl1C0mYnnWiN9aYQmaw8PR78NXTSqFGAux4aWUatoHcHgAC+zDfpKaCzFZVjH4+usO500=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUTx6uLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUTx6uLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CDDC113CF;
	Tue, 26 Aug 2025 13:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214102;
	bh=GIijY4ceGvQosf1loWBLWu2Pz8PXt3rz+8fWuWtHydk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUTx6uLn4AE8JbnjefO6+OHaFBVdEKM/gSY93YLLxvlR1ok8d6pkF2t2K23CgnxQN
	 cgqVEb7BNwjQNzl4RrlnSOQS+rfik16Ng0Kcz/KvHjbaePfqTfniJAjv8Xsug3SJwd
	 /HXeYUP9HpxaLU5DsuC9kmdXto5Mb4QBYTiLdg84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 004/482] ALSA: hda/realtek: Fix headset mic on HONOR BRB-X
Date: Tue, 26 Aug 2025 13:04:17 +0200
Message-ID: <20250826110930.887710265@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit b26e2afb3834d4a61ce54c8484ff6014bef0b4b7 upstream.

Add a PCI quirk to enable microphone input on the headphone jack on
the HONOR BRB-X M1010 laptop.

Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250811132716.45076-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10440,6 +10440,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


