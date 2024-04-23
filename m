Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EED143882;
	Tue, 23 Apr 2024 21:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908732; cv=none; b=d17YgOFk9soCod/Y5O2O7dY7g9u/ERS5NAxrli4P/v0ngluj2+FzIXxdMRt9Q7H438awt9HY/DbnbzyiiOjdamO8RS+5KO6LezGRg8equexgf25z35yu43Q4rUeuL+Tn/ldeIYd2FEFSEeP4Qu2CRwlEenyd3rIX3Nqswu6XOi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908732; c=relaxed/simple;
	bh=xosoGJHljVVlSW63OVsn21qz2LTx47nSJU9RS34o/3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duRrexqz6fpphLqlb/iPaN/85xGjcS8E2TyEJ8eP2+sS9P0mNZw6KdyXEiK2smFXM3+IP64znLMkEFwFKwuXsP3aujEUuv5VTU7Z7UMVeGBGhhFIZC+7Xvl8MZHm2iXeIHpu1l+iMHLVsmvS8FP+HLbh5gkbiQiWevXZtXJT4GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfOmUShP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfOmUShP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A99AC32781;
	Tue, 23 Apr 2024 21:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908732;
	bh=xosoGJHljVVlSW63OVsn21qz2LTx47nSJU9RS34o/3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfOmUShPcoWlHKQyNeTLLrYMcSqsLAq4/TwmJ8xbiZ1Jxjnj90HnrDR9Z3nhSM+Ji
	 LHoU96CthQoUr0KmeSbcB4gdjTZgvehsNbhQcRB/9Pi9wHS04ABFPSdnwXJMCuHkAJ
	 BMsanSsRYKq9u27L3b7RhjiEhvD1FaqP43gD8Fng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 099/141] ALSA: hda/realtek - Enable audio jacks of Haier Boyue G42 with ALC269VC
Date: Tue, 23 Apr 2024 14:39:27 -0700
Message-ID: <20240423213856.384071886@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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
@@ -10122,6 +10122,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),


