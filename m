Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CFE13C90B;
	Tue, 25 Jun 2024 10:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309777; cv=none; b=mTra2W0YJSVVL6XJPAkx81dohA9KbtE/p3F6/VyQAQ0ec9+olAlKlMUHVQzAjx0OlSwZbUouPkD7SXr2ttEr3xSlnz7XNLHm4BWwKf8gXW/H1Ed6dKjaSnCiS13YWuWSZRKQjsdGpi77pDR8Ofosfzq0X3JSSEIkrYSlP2Tztm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309777; c=relaxed/simple;
	bh=VIyxSNumIzEuoPhkwnkf2eQMu1n801iRbcw46CcU1Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRAqQ02AeWqx49g5D8V+piE+YXN5xHDbWLO9Gzbz3iLRkh4MBXVZIFujWHNW/uNtI6J7jGB56RCRT9TC87Pk9ZAXNZs+52BeUzv89vdl9KEsxqfTiKSyGuB5l0nlUlF4tyUyjSfEuCQ+gRi/YnNZ75PbJ+2pmL+O9s6OkTTdwxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nX89lPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nX89lPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B6DC32781;
	Tue, 25 Jun 2024 10:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309777;
	bh=VIyxSNumIzEuoPhkwnkf2eQMu1n801iRbcw46CcU1Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nX89lPPMkbouGhgBkJTSqGxd5j9O2t3zTv8t3xMSntjHT+amSU2LUjLnuziDd/JS
	 V17kt+RR96Cerz13G67Wy7dSjUA1/TSx6pDhQhfXf1nWrU4eM3aQAT+fMLOeitZ4Hg
	 h7s0X1yIvLpkIrY1rWudgxBzkPg20x5kuxmpZIUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 103/131] ALSA: hda/realtek: Limit mic boost on N14AP7
Date: Tue, 25 Jun 2024 11:34:18 +0200
Message-ID: <20240625085529.851767221@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10132,6 +10132,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
+	SND_PCI_QUIRK(0x1c6c, 0x122a, "Positivo N14AP7", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1c6c, 0x1251, "Positivo N14KP6-TG", ALC288_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d05, 0x1132, "TongFang PHxTxX1", ALC256_FIXUP_SET_COEF_DEFAULTS),
 	SND_PCI_QUIRK(0x1d05, 0x1096, "TongFang GMxMRxx", ALC269_FIXUP_NO_SHUTUP),


