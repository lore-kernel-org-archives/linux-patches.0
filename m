Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0039C1DFD1;
	Tue,  8 Oct 2024 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392418; cv=none; b=bPw2whwl4Ag3W/s/9Vu6F+3wQHGiJwUKG63HpUAc0wDbIk+W2NjaPN1zu8Rt0+KChXg23rW485rM0QUSTkVP8hEubvjTMJFQ3CNxMCxCCJPipbjIxd4bWzRmMkE973bm7KXFjRoft9JBQB0NBArg7U/vC7y6PuN7NrsQRAcn8Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392418; c=relaxed/simple;
	bh=I2yHy4XjYqVeNsVlVIJBmuut6n5O3MSpfvWMxqSyVGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bxowh2DT+SYzF5F/eV8U0GU0RcCzdhhkMdSNO6U6VpUcatnvChQ/n0GZgz5wt6DkgPsURULedlI4R6j6lIHRgaH83VH6y3Zi0+Uc8ESVuVcOcYF1tPPmEB7p0BREwa+pqtL5ErZuV9YBshwXc+JgnpIzgkTQhzv7shI0KetpWu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTCDlZNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTCDlZNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C5EC4CECC;
	Tue,  8 Oct 2024 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392417;
	bh=I2yHy4XjYqVeNsVlVIJBmuut6n5O3MSpfvWMxqSyVGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTCDlZNuD636xND2cVgJyN8VbyI8u+yGPw5Z5Uuu9usahXECRz38cBVeOuXPj3tTg
	 ZH1UrZXK3H64LAVMEYWdvj5PUy8ZDvGY+kihx1H9Zkeuc4Ey6SJ4/awnhJAC2pT7/N
	 BAdwfFKZKhsNeCL1L+xlbVQFho3GY4KqWXq81OTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 378/558] ALSA: hda/realtek: Add quirk for Huawei MateBook 13 KLV-WX9
Date: Tue,  8 Oct 2024 14:06:48 +0200
Message-ID: <20241008115717.166910604@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10930,6 +10930,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1854, 0x048a, "LG gram 17 (17ZD90R)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x19e5, 0x3212, "Huawei KLV-WX9 ", ALC256_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
 	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),
 	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),


