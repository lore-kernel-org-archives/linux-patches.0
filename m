Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B12143C6B;
	Tue, 23 Apr 2024 21:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908645; cv=none; b=bpOUh+cMINRX+2jXcQ/GIr2Eow+172pz3LMhb/7sTdZqmRjIRSbzCscOHyj83kU3z1EZIf4lhNzDFZX3P8CalswKU5sc8fvZLSv0kYuPGN2008IwKItYi47ppemiJj/TTk/72kKP+xYhQMzJ6ceWz5asQTJ3HVM2CkpDclnr7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908645; c=relaxed/simple;
	bh=PFGOgcQ9JhR5sGs/FW/YA1ROzQ4zKnhDt6idlFEnfyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkmHDc15kzTJ7n3fMJx1yj0IkFYtteDo+1TaDAv5YbUsX6lPK3afNSFG2nyMaPyIPe3qYyrctVPcCOb0X8i4wNLi484rkK5Me3gC/DzN3OlrOBbzVFLC8VqzNCxNDqqKERnNezhfGL7pS6lwev7KQXZZ5gDDax/DB+KLAmZfGqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkCiBNJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkCiBNJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D78C3277B;
	Tue, 23 Apr 2024 21:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908645;
	bh=PFGOgcQ9JhR5sGs/FW/YA1ROzQ4zKnhDt6idlFEnfyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkCiBNJBL3pXqSw2AalGuUn6w0h1XhwtpSfw8drZc/c/pNYbjzkZYDI2cyige+Lu9
	 0R3Skxodhpe+Gat6U/QD3hxMnZL8WwWspEgVOvV9BtGPuwSpyMmm4gwqEYOC/61dlu
	 Unefzl8wMGLsvSzu8+FNEiNAnHxvOt5DD2gglmUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 103/158] ALSA: hda/realtek: Add quirks for Huawei Matebook D14 NBLB-WAX9N
Date: Tue, 23 Apr 2024 14:39:00 -0700
Message-ID: <20240423213859.101055200@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Mauro Carvalho Chehab <mchehab@kernel.org>

commit 7caf3daaaf0436fe370834c72c667a97d3671d1a upstream.

The headset mic requires a fixup to be properly detected/used.

As a reference, this specific model from 2021 reports
the following devices:
	https://alsa-project.org/db/?f=1a5ddeb0b151db8fe051407f5bb1c075b7dd3e4a

Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <stable@vger.kernel.org>
Message-ID: <b92a9e49fb504eec8416bcc6882a52de89450102.1713370457.git.mchehab@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10098,6 +10098,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x152d, 0x1082, "Quanta NL3", ALC269_FIXUP_LIFEBOOK),
+	SND_PCI_QUIRK(0x152d, 0x1262, "Huawei NBLB-WAX9N", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x0353, "Clevo V35[05]SN[CDE]Q", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x1323, "Clevo N130ZU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x1325, "Clevo N15[01][CW]U", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


