Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8C51E6329;
	Tue, 15 Oct 2024 13:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998209; cv=none; b=biRNZ3rHFjQpUH+Pzg/PBu5YXZ2FDtfPpduOWrYL0ElC5Q7fpyg9L8yQ8Sz8ej0tTl4MyskR8VksQBzAyFm8CSnrrK+g36lrnRCA9GBlBBmNxJMgVTVk/n82TDVtPtvNOxL090aSualemQk32e+ovmyYo/oPxFR2xFaW5VWtpBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998209; c=relaxed/simple;
	bh=6MoK9odIby6/oGXLv7cOHZom+5ftbdMINYuPGv9AF3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ut5kZQXY5hoxtVQGOJGAWb5QNRd3xk85zjrnzk7vP88OeiKAkfAfkuO74IXRgCpvWdHwXcviu8OxN9m+Bk+hJUamK15azeC/vS6PtzyqNs+6QWDDYRiNkoU8tK35t6grc85dyrBKkDwxPcsMMsaaBrY4OkOmSIM0jQhVclZwZM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtnZGYJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtnZGYJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFA5C4CEC6;
	Tue, 15 Oct 2024 13:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998209;
	bh=6MoK9odIby6/oGXLv7cOHZom+5ftbdMINYuPGv9AF3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtnZGYJQ45XRqRpsiX2MKq1kNzs0ngyXflxElwao6yZ5Vw0/rk8gL5eQCLIyQff9+
	 ter6+QU+NtdqMdADLbOdrh7Q4utyCFsG3B5WTaQWvZ2ZxdQXtuHE1dxT/6qMc7e8Mr
	 0/TzajsQ/SYlbmpjCp1nyNHlFTbj1nIaV6pZ6tY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 369/518] ALSA: hda/realtek: Add quirk for Huawei MateBook 13 KLV-WX9
Date: Tue, 15 Oct 2024 14:44:33 +0200
Message-ID: <20241015123931.216347727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
@@ -9419,6 +9419,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x19e5, 0x3212, "Huawei KLV-WX9 ", ALC256_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
 	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),
 	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),


