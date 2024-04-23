Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F6D14388F;
	Tue, 23 Apr 2024 21:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908509; cv=none; b=a+teRE/0g42FUJ43JO2A1SL1PwkOZu3NAzQZfs1EaaNutB7XuhuGuVrAvoFijVPMiRKZFs/Pm5z8kWzzCMM/YwwEdYWOC9omJE89SXkBBtvX06EltnQLtF1nq/JpjuDWBXiTECUV5Xip5025Ypq7xQwpPx2bUp/+3oshXgyAVjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908509; c=relaxed/simple;
	bh=xnRvX7HOn618nWbRmW5jqDDF1xWyfMWAReY/enHeFu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZc7mk5DMFkLFTeYgrm1M3fNUnHz11tjsFNF4f8vT4/ogiTTpkLCc/p3M78fZe8htJke+sUYe7RfX6AYlYnBzm4b0ixEEgOMnwvFLvhNb1keZ61zBQG8kf1+9u2rLgzkpxvCxLP/+vwL0kZeHa4zXztWT9OsUbxVelY3FivRHPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6BK+ZH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6BK+ZH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C533C32786;
	Tue, 23 Apr 2024 21:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908509;
	bh=xnRvX7HOn618nWbRmW5jqDDF1xWyfMWAReY/enHeFu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6BK+ZH4PTFdKKZb7gTjRbCYpl9HNFJYs1BHnRlOGQFGNrDRDG9nbVyezXh+bWHME
	 o2ZF0uwZuq+lE32NFUt1BxiM/Rvd+xNmZlfr7htH9YjcuRCbt8wy8XLsveG/3lOh2q
	 WR68gDGlAMVUq88MU3naxfA8TGViDZGG0+pBpEc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 093/158] ALSA: hda/realtek - Enable audio jacks of Haier Boyue G42 with ALC269VC
Date: Tue, 23 Apr 2024 14:38:35 -0700
Message-ID: <20240423213858.977739528@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ai Chao <aichao@kylinos.cn>

commit 7ee5faad0f8c3ad86c8cfc2f6aac91d2ba29790f upstream.

The Haier Boyue G42 with ALC269VC cannot detect the MIC of headset,
the line out and internal speaker until
ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS quirk applied.

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Cc: <stable@vger.kernel.org>
Message-ID: <20240419082159.476879-1-aichao@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10444,6 +10444,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),


