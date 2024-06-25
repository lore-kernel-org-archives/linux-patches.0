Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1A51465A8;
	Tue, 25 Jun 2024 09:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308766; cv=none; b=rTBQj4DqY86BxZuDlsqEmrio6R7PzLsLdQfFKfOb9fFk66ENcn2ElJReXvJnJ+jiC1M7GTJOU0yzdzNguX6Lt/yUxbk9NU9DbbKK2ZCF1JHi/yF/h+Ee1edyyIEmRXCLeFes1bB6vsR85U+ehyZruOS4tUzgoNcwSLYqrnbPQ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308766; c=relaxed/simple;
	bh=8JllP211jmNe0o2d70a7O7fXbfGEYhkbnMnZ9kYc/B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdG71LwLwlIVP8/BCn3vmV1ps1hXgAdY9knqMqVe/FhI48WIihRzH+9Y5R5LDlOdp0KTQPXWbSR8RwEDNbCqQzcmBD3oNzm1XeyZj4A7wbbR7sxALzvEK4Ju9JxsH7wCwM6GildncJUYvKjtv7NRmUU9Y4NKubBuh024SlnYXV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAOpD9TP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAOpD9TP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859AEC32786;
	Tue, 25 Jun 2024 09:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308765;
	bh=8JllP211jmNe0o2d70a7O7fXbfGEYhkbnMnZ9kYc/B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAOpD9TPJ2Amwk9aqZFcFr9wvwDUFcE2Mq9OPJrerywul7wBbcBVsKz/phksnpEkv
	 xRJWcMq5fnJpQ2B6dj4qUqSJO1GDJoFxnDsc/wUtTmrMgdCEIORoi0fgrJZsUiNJ1i
	 tcliHOM20e37p8mfNc5PTtIxXElcj0YXDQKiKXjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 201/250] ALSA: hda/realtek: Limit mic boost on N14AP7
Date: Tue, 25 Jun 2024 11:32:39 +0200
Message-ID: <20240625085555.769020554@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10572,6 +10572,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
+	SND_PCI_QUIRK(0x1c6c, 0x122a, "Positivo N14AP7", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1c6c, 0x1251, "Positivo N14KP6-TG", ALC288_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d05, 0x1132, "TongFang PHxTxX1", ALC256_FIXUP_SET_COEF_DEFAULTS),
 	SND_PCI_QUIRK(0x1d05, 0x1096, "TongFang GMxMRxx", ALC269_FIXUP_NO_SHUTUP),


