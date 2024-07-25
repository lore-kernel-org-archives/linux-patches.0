Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1020C19A29C;
	Thu, 25 Jul 2024 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919049; cv=none; b=iWwN1Yr7TiiVqJl//8UiTBTf3YI3T+loQYZyHTrMmMvXI2BitEJPcKNHD14BiDlx9J3rVYctfXqgd743AFB0cUdIBfO460pmYiNoYe5cnGRoIm3PHwIQihaSvpz9980PLxq5fEBYmNh9MMrziFrPsbVmggWgZy1Rg3Q43g/cDGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919049; c=relaxed/simple;
	bh=tkJTqjpNdUZeZf/MQpZrmrMUxccWeRxg+CvXuCvbJ3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmwTZazFe28G5QgUesVvE0Zg4bNRCI79UhOlNdgHPZJTUJ3O2Q7JkOFIsyXMj6+0Ld8oZjm1rKAOLDYGeWtsZP0rG6SjJSN5ZyS1AvqsZf5cvwpIdAv+WSJkv5CFLWKs5zdzr2u/KYblKA+A3Arytgr+4JOH1iaVzTgkJtnrbaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVqxitgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVqxitgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B329C116B1;
	Thu, 25 Jul 2024 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919048;
	bh=tkJTqjpNdUZeZf/MQpZrmrMUxccWeRxg+CvXuCvbJ3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVqxitgE2WHdVEJiFKyO+LG/x4jJbU1+RolxYOyqkQHQZnvZb18LedfWxduMUZ5EP
	 fxiLgXBIwJgxkatH7zaOUyv/OVdXbiTkBXW7Z1Xd6tmuQ0GttDF84tbF69HaffkM9k
	 Fa1HOWf00HB1/V0pzNghIHrUgNmQs2vYBaUqOl38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 55/59] ALSA: hda/realtek: Enable headset mic on Positivo SU C1400
Date: Thu, 25 Jul 2024 16:37:45 +0200
Message-ID: <20240725142735.334673911@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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
@@ -9195,6 +9195,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
+	SND_PCI_QUIRK(0x10ec, 0x119e, "Positivo SU C1400", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x11bc, "VAIO VJFE-IL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x10ec, 0x1230, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),


