Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D2D1465A8;
	Tue, 25 Jun 2024 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308769; cv=none; b=abzp42cZZijbA/M7taLh6zUCHCtLDf1lPT2YGgOfhMjA2RRSUuWxcEFuazaLbCklIChHn567jekUPjwMOjbNTjUz1cNcEJl6J8lFXOgG9f8XmJ4g8zMAkHaosZk4O7f58i0Yl78qFg9aJKROMWhgXWH4zBJP8hlD8AoCdV0eeO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308769; c=relaxed/simple;
	bh=dYI+4Yj8BYKVb8rZ7NhFOKcXJhlbmXepML6dfur7R1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cYRVe9Z7fcK4w2YnmfJhDT05vNikqAd0g5DcCk93AC2keeLmnMOyqZuYEDhfJb8lM0y+CZGk+BtI3zs74092/jBbOlU2YzjaoFGi18t14U9mm8qN2jafjZjb7iKlkcUNeZvcFNDXti66c7ckFPKpl7vigoXMUO77dN2jNDcdEr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3hms3+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3hms3+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C78C32781;
	Tue, 25 Jun 2024 09:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308768;
	bh=dYI+4Yj8BYKVb8rZ7NhFOKcXJhlbmXepML6dfur7R1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3hms3+c6kZeoWkIa8j6QEvn/YknWych0PbbvEvTYBkAs5v0s2SqvtXAextAp/bvW
	 ogIBhJ/M0mA8ySU5bHxEqaK0l/fQ9Hv1xC103sTdUotrH7EiJOWFDBQfPjqhAeRJlJ
	 NW/RUiBaXSFxGGtk0+2zcfHRUZwx38NR5WQrrIlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pablo=20Ca=C3=B1o?= <pablocpascual@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 202/250] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14AHP9
Date: Tue, 25 Jun 2024 11:32:40 +0200
Message-ID: <20240625085555.807359220@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Caño <pablocpascual@gmail.com>

commit ad22051afdad962b6012f3823d0ed1a735935386 upstream.

Lenovo Yoga Pro 7 14AHP9 (PCI SSID 17aa:3891) seems requiring a similar workaround like Yoga 9 model and Yoga 7 Pro 14APH8 for the bass speaker.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/20231207182035.30248-1-tiwai@suse.de/
Signed-off-by: Pablo Caño <pablocpascual@gmail.com>
Link: https://patch.msgid.link/20240620152533.76712-1-pablocpascual@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10518,6 +10518,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3882, "Lenovo Yoga Pro 7 14APH8", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3884, "Y780 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3886, "Y780 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3891, "Lenovo Yoga Pro 7 14AHP9", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38a7, "Y780P AMD YG dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38a8, "Y780P AMD VECO dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38a9, "Thinkbook 16P", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),


