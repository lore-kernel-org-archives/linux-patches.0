Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5856B1BFDFC;
	Mon, 14 Oct 2024 15:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919192; cv=none; b=ipLrt+4VvEJZF4GLzFop+9O2RaZxoPPsgoFmNCSTnyppY6denWdT7JJR7b6FAxmgJxk47p02oJAkvJiiof9DzxBVKpvXn2NXKKaCvskxfT/3J1kJtou9d5pJNqCebEVWlTvZpCkczfDvpadlFHMszL5Ogm9b/wrIU6g5Sqc8vd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919192; c=relaxed/simple;
	bh=eeqES1JrHdZPBMiMNHDiOWKMHxtL9nwaN/ivM/l/M4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQkpIN8IvUC3vzNS0THOTdFZuTUzQN3AedATqnbZqG4CALopTa89CR8cNnAIy1f47M/7S4ol8U31KQxsJk2S7XIN/xrOQOZZ/xbOmMf1VH/RvsRG6y2rtbOupi18n9WPyGVVtmkaMwyWwDnHAGQZ3L4xMKVggJ/lAhAaksnDt0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQVp3usw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQVp3usw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE615C4CEC3;
	Mon, 14 Oct 2024 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919192;
	bh=eeqES1JrHdZPBMiMNHDiOWKMHxtL9nwaN/ivM/l/M4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQVp3usw8gUroKIxtKhZ0hVx4Im5xZAGKFT5ExaYqeoApQzPLE20wFtaeBWuA1nKg
	 8oamh9SDkeUbWCJY6qY7TzuIBb6r+UjrsOLYQNsEx9CPPCNI4PkZX3WkQ26o7m+K4J
	 E0GKufAZEFL7OsdtPAqd5gnR68k0tmm+u8DdkwDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 539/798] ALSA: hda/realtek: Add quirk for Huawei MateBook 13 KLV-WX9
Date: Mon, 14 Oct 2024 16:18:13 +0200
Message-ID: <20241014141239.174242436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
@@ -10175,6 +10175,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x19e5, 0x3212, "Huawei KLV-WX9 ", ALC256_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
 	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),
 	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),


