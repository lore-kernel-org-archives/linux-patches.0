Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED6220A5EE;
	Thu, 12 Dec 2024 17:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024648; cv=none; b=OJerlZZO3CWbK6eYVnpWhmVyfpTbCKmQLCx5P/gBvbNGloYQtqrH+AamPesUs/j/F/0EHnWBRZihr1jNUMkdEu9fCyiY5TmQ+SgMQcuh3Qidp0BlP5pvcJS6p979ipSa7wbcc77iFpVVmML9XAdFi1Eg/QYDBkiielRsHtYpeQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024648; c=relaxed/simple;
	bh=iUvHgM3/BuX7BHv1haWbnBIYkx+H7szf6bdUpcSCJ0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JefbU3IFF6oRCX+vIxEgovFdT3ZPS+PX8h9X7Ia9CwvhW9V+FEE26PglY03oLtCFmajkM/wAmTIcP/ENAK1LrvCQgfymYi2PmKrgFbMeY7DnVwSzrseNgoaMU3L8e7qNVZopMbmlSDURJeWS3cy88zIMZQtyK7nQXSyHDTE87rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=na0MUw/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="na0MUw/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF97C4CECE;
	Thu, 12 Dec 2024 17:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024647;
	bh=iUvHgM3/BuX7BHv1haWbnBIYkx+H7szf6bdUpcSCJ0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=na0MUw/BhFy/0nVNybSZWMGiJPpJ9ycSt6VXY7OePOdd7MMT5O2ZRnUZt1FCRjw0O
	 Odqb0rlCkXQryQJ/PmQJ25dxDUIj+m2GAEx8cecqKJh3nN0o94h27J9NPA881vLtvh
	 6DmzLT2InodonL8L+kwrusXd9w9TW1B/Lks2fy6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahas Leelodharry <sahas.leelodharry@mail.mcgill.ca>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 365/459] ALSA: hda/realtek: Add support for Samsung Galaxy Book3 360 (NP730QFG)
Date: Thu, 12 Dec 2024 16:01:43 +0100
Message-ID: <20241212144308.091815234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Sahas Leelodharry <sahas.leelodharry@mail.mcgill.ca>

commit e2974a220594c06f536e65dfd7b2447e0e83a1cb upstream.

Fixes the 3.5mm headphone jack on the Samsung Galaxy Book 3 360
NP730QFG laptop.
Unlike the other Galaxy Book3 series devices, this device only needs
the ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET quirk.
Verified changes on the device and compared with codec state in Windows.

[ white-space fixes by tiwai ]

Signed-off-by: Sahas Leelodharry <sahas.leelodharry@mail.mcgill.ca>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/QB1PR01MB40047D4CC1282DB7F1333124CC352@QB1PR01MB4004.CANPRD01.PROD.OUTLOOK.COM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9269,6 +9269,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xca06, "Samsung Galaxy Book3 360 (NP730QFG)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc868, "Samsung Galaxy Book2 Pro (NP930XED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),


