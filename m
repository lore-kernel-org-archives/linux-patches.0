Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDB131E0E8;
	Mon, 18 Aug 2025 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522722; cv=none; b=A/oA2VdItt2mE/tCZiU7337rjzpbC6ReqrKzY1RT5zgo99EH1PjgibamfaUp5JPQs7WSfHzKOOcIoD9kKlJDVKA34Y11cAJ8vbbaDSrH9z8j35sT7Gq5oaX9kQWKr3AYKk3LGCc0N3RmusPdqDFGX8X+M2kW6A2QlLeCgyibkyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522722; c=relaxed/simple;
	bh=qtPhC6OY6Z8ydd7J6DdzX9tpQnkikVkJE2fm3rjffOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM1cEZsiQkdcDSMeH4yTcfu5fnKBV7DaKfLd5jdw/yh32UJqifn0dHk+u3sjtcwenLNYPICOK8ttiosewUxBqMKpuNNBusuE7pLbz85E+mQKsRcpPJ0A0tF4rl2c8K42S6de4aIyIBDNcOO0FpFTC8RaZFxdzzRKwLEvQvtKiB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnlFwyQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnlFwyQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF890C113D0;
	Mon, 18 Aug 2025 13:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522722;
	bh=qtPhC6OY6Z8ydd7J6DdzX9tpQnkikVkJE2fm3rjffOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnlFwyQRC80DS1WF/nbPKH/0g7MEeOEXX53Imh65RY0lsJuWS/5yXZTFs9HVuoL62
	 yY3/EQCa4cDw7fjnaIbyF9zFZN3WnA4Z7gOEWOG0azWjWHr30hFLbbodtrdYIx24E4
	 0HsyM0VMNdMPv3plqnvnajYb6zpv7A4/A16+j4v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Croft <thomasmcft@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 359/444] ALSA: hda/realtek: add LG gram 16Z90R-A to alc269 fixup table
Date: Mon, 18 Aug 2025 14:46:25 +0200
Message-ID: <20250818124502.371558918@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Croft <thomasmcft@gmail.com>

[ Upstream commit dbe05428c4e54068a86e7e02405f3b30b1d2b3dd ]

Several months ago, Joshua Grisham submitted a patch [1]
for several ALC298 based sound cards.

The entry for the LG gram 16 in the alc269_fixup_tbl only matches the
Subsystem ID for the 16Z90R-Q and 16Z90R-K models [2]. My 16Z90R-A has a
different Subsystem ID [3]. I'm not sure why these IDs differ, but I
speculate it's due to the NVIDIA GPU included in the 16Z90R-A model that
isn't present in the other models.

I applied the patch to the latest Arch Linux kernel and the card was
initialized as expected.

[1]: https://lore.kernel.org/linux-sound/20240909193000.838815-1-josh@joshuagrisham.com/
[2]: https://linux-hardware.org/?id=pci:8086-51ca-1854-0488
[3]: https://linux-hardware.org/?id=pci:8086-51ca-1854-0489

Signed-off-by: Thomas Croft <thomasmcft@gmail.com>
Link: https://patch.msgid.link/20250804151457.134761-2-thomasmcft@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 50b340876f09..840cde49935d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11302,6 +11302,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1854, 0x0440, "LG CQ6", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x1854, 0x0441, "LG CQ6 AIO", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x1854, 0x0488, "LG gram 16 (16Z90R)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
+	SND_PCI_QUIRK(0x1854, 0x0489, "LG gram 16 (16Z90R-A)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x1854, 0x048a, "LG gram 17 (17ZD90R)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.39.5



