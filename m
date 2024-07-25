Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116EC13C816;
	Thu, 25 Jul 2024 14:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919290; cv=none; b=V54nWuCIQqVzxLs61GcbjQt4JZgZt1CJyjSFi/cy7TDq957kqZQ/wwVHrDh0aLIpW99+LXvTQ8ZqTZL2/DWXZuenmY9tfHxSNk8Lh2rX6/FDDzauunpER9qzJabX/HINKCt29giXthEN963hzkiuExYryiDgsJHdmkEMTMtProU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919290; c=relaxed/simple;
	bh=W1TWfIPaOcamgjDQSqFor/TxZNYXXO+pKZspNDlO6P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6opeNcm2s4t2XfESoCs3/vwxQAvln5yAKLsBYydHwBkoj4u1LSMycLuAPcB7jEjo9ooJXqJYn4PUfYn89rVRJ/4EUUhlr5RXnjM6Bg03ThjfPfSZQDtT3PD4lUKsGl2047XN3NYN/uEqLWpAlgYAxLqe9WWAPH6bWP74fvq3/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0Ojen9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0Ojen9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFE5C116B1;
	Thu, 25 Jul 2024 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919289;
	bh=W1TWfIPaOcamgjDQSqFor/TxZNYXXO+pKZspNDlO6P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0Ojen9ZyCqVy5qZSDRkAgJeCF3T8Ss830to2pKM6WHgFhjQvznwLP4Ns7+U6ImVE
	 XhKKa7nXYnSl/T2UUCtUPvhQM3OKsT+WN2pS4qpeEqUblc6RcgkOemJ1q06d35YFHG
	 MEJdbbf5lMOS7XVzZeVmYoXzFp/84dLwucdQhiNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 82/87] ALSA: hda/realtek: Enable headset mic on Positivo SU C1400
Date: Thu, 25 Jul 2024 16:37:55 +0200
Message-ID: <20240725142741.532059031@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

commit 8fc1e8b230771442133d5cf5fa4313277aa2bb8b upstream.

Positivo SU C1400 is equipped with ALC256, and it needs
ALC269_FIXUP_ASPIRE_HEADSET_MIC quirk to make its headset mic work.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240712180642.22564-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9273,6 +9273,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
+	SND_PCI_QUIRK(0x10ec, 0x119e, "Positivo SU C1400", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x11bc, "VAIO VJFE-IL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x10ec, 0x1230, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),


