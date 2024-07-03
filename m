Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199191822CF;
	Wed,  3 Jul 2024 11:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004801; cv=none; b=B6G189z4d/X/3Zv5kOeDs8CKUM1OgJmLIOqFnPODRDdePpJYdv1vp5zPQPv2OYLIGyG23Of4vG8rZfKmD1n3AMoBHlLkK/kRWU5maZy2Rfz/A+u1BJliaggi0N39cydL5YVO/yRrKCmQw2oXNmvvJJd7ixHQ5YF/n6+UY2JtVI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004801; c=relaxed/simple;
	bh=hcnC96lm7EhsysznGLyjBFH+rLRQd/55FpfY4zO2yBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRVPQvu0ZI8JxPXmlbtAJ3+CD6jCRL0TSjekG4E+SKswhTKL0Yjkh0Bkan0r8xwrqY0hxWZurZAaASvVVADMqjYDOichnUKI7JQiFsuCw7zEmN3aAsI3EN+FAfCLOTTYw7WzAYUK/qo9OtkAUtO0Fuw7OUBs3I9xB7k9rT5m0YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrOHpAeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrOHpAeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90485C2BD10;
	Wed,  3 Jul 2024 11:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004801;
	bh=hcnC96lm7EhsysznGLyjBFH+rLRQd/55FpfY4zO2yBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrOHpAeVzxbxcYcqbN1hMidRYfJ4z79fyd1DyMsrsUhRkjBKsOKySO7AjNkq5vsi7
	 8hsFBaFe8LEyK5FyWI+lII0WLAXVwiWDj/3Urz3tEsaUTXIm+/8s5LiTLyb75K2SG8
	 VnV65xvKfWHExKC/swOkGNCD6KON+F/7MUS+e1Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 164/290] ALSA: hda/realtek: Limit mic boost on N14AP7
Date: Wed,  3 Jul 2024 12:39:05 +0200
Message-ID: <20240703102910.372385143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

commit 86a433862912f52597263aa224a9ed82bcd533bf upstream.

The internal mic boost on the N14AP7 is too high. Fix this by applying the
ALC269_FIXUP_LIMIT_INT_MIC_BOOST fixup to the machine to limit the gain.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240605153923.2837-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9380,6 +9380,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
+	SND_PCI_QUIRK(0x1c6c, 0x122a, "Positivo N14AP7", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1c6c, 0x1251, "Positivo N14KP6-TG", ALC288_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d05, 0x1132, "TongFang PHxTxX1", ALC256_FIXUP_SET_COEF_DEFAULTS),
 	SND_PCI_QUIRK(0x1d05, 0x1096, "TongFang GMxMRxx", ALC269_FIXUP_NO_SHUTUP),


