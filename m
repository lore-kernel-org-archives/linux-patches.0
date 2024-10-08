Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66661DEFED;
	Tue,  8 Oct 2024 13:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393805; cv=none; b=LzKECypWNMII+P4e2hxOAVc289rB7uUBY6BLrgZOPVavnbxmWHITRj01yLVce14dG/y+zxeCfjCAyekkrMXyhXnXfx0dDxCwBcHw5JWAO2aGxPSpWz6n4Z8k+GItcgRJEtiW7L4nEsY7ixR3I+6YL+iIf9bey/Is72dEnhvzmv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393805; c=relaxed/simple;
	bh=TROrSsryoJsKQ6ZqrjykbvBiqTIfeJWtI5HIBSS8xg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeMLO9vqRIiSYzQi5LLIMyaPIgH/YkOQLz9rRqzey6c7JgstJaAJVFsVZOuadM5Da4sKOiH5SHe3NVdJn8W3KaDhgMAL2RCKYYlpF5Ig+1mx1B+3hPZz3rCSs9ONf7x9UT5hyQckNHg8K/O35maN048MCkN0SNURgGfkdf6w8kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6weZr0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6weZr0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22B1C4CEC7;
	Tue,  8 Oct 2024 13:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393805;
	bh=TROrSsryoJsKQ6ZqrjykbvBiqTIfeJWtI5HIBSS8xg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6weZr0i34EQxMbZ9Yv2qxl/DwF22En/+fxFyd0uyO21/221CzPsAqymn5UMeA612
	 6a+p5BjJDU6bF7aZt6rpIT8bdoABhA33EUPgJFXVXmG2qasjPMzRYmXC8vEf7OLxy5
	 udYT7hM6aDYuL8JUNJiw39sXScNrElBxjZfVE1kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 229/386] ALSA: hda/realtek: Add quirk for Huawei MateBook 13 KLV-WX9
Date: Tue,  8 Oct 2024 14:07:54 +0200
Message-ID: <20241008115638.415653664@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
@@ -10363,6 +10363,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x19e5, 0x3212, "Huawei KLV-WX9 ", ALC256_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
 	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),
 	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),


