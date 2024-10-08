Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D171B81CC;
	Tue,  8 Oct 2024 12:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390546; cv=none; b=A3PuFZmMK93AjLt/2crbXrGB3OERnVCOcm94ql/u03DzoPaszZlRZMDpLlg4M/iy50tgVqItfDiZaAKAnreZvy0HJdZAsyk678u+FrWSpgtXsOMR7mDzc2TJch8SxuQGzN7wsao5YJFp1c9iJxyuC2sWiyimV765oUVIB7YJxlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390546; c=relaxed/simple;
	bh=YK/4XItn1KfnS/QGgKjc/mlsgnBOOwAqTk8nGp2VmAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJmOtKayqJacGT28diVFvstm0kJz+E3/NYGWwztr7MMN4PiwyfrmiIKcLudi+CDv59Y10qJfdKJV/NavBNYUwR0C4OIOYx8q+plvhUq2nCQYG+z8zjCY/GszpLHRdmjSfNn57ucobNNPLBd1tbMdJ2JfqD3dXX+eyTgyErEeMsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+noW1u4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+noW1u4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D51C4CEC7;
	Tue,  8 Oct 2024 12:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390545;
	bh=YK/4XItn1KfnS/QGgKjc/mlsgnBOOwAqTk8nGp2VmAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+noW1u46FOAgWmgWZW6GpvkTqGwu+UYYEz9p5eZspAuFsTQdy331LYra9JthiSfA
	 Gp2gxBEnPxQWZM4bgg/0bgz9z4D2BKsOXYYylFGk+lx+BfkvNErKAaEKVWrLrD1nft
	 HtquE5p6BPDLEKzlInS+jiFvXd98Q3RRpfyx7Y0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 320/482] ALSA: hda/realtek: Add quirk for Huawei MateBook 13 KLV-WX9
Date: Tue,  8 Oct 2024 14:06:23 +0200
Message-ID: <20241008115701.023060806@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ai Chao <aichao@kylinos.cn>

commit dee476950cbd83125655a3f49e00d63b79f6114e upstream.

The headset mic requires a fixup to be properly detected/used.

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240926060252.25630-1-aichao@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10687,6 +10687,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1854, 0x0441, "LG CQ6 AIO", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x19e5, 0x3212, "Huawei KLV-WX9 ", ALC256_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
 	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),
 	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),


