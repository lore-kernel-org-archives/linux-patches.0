Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE9D183CA6;
	Mon, 12 Aug 2024 16:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480533; cv=none; b=Kvy23rdM9hrwsn3j0qkOHHP1O5DkspLj3/facuX7ohmTpVxLmFvWW/Tp+hClR0HYArmLHhmbYDqHbqstfOXODSFfuibsXkuT6ydH/O/JaeZltwKeUBMi2U0ya5ZbVTwHdaO3wud7FB5+4/xAvvAVAhq8YRu+GnAQTKTaH5lWHpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480533; c=relaxed/simple;
	bh=hZ/GQloBnjg9t+zo/1ym6YtbBIoq570smZZslzqZY14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVt5PNz+3vGejMZH03SK6+yIB0oXdIDme6P+1ihEpvlWns5NBmXh4uBxh4v312Qz2gYhgJnu6VlYQunVhNLNAUWE2CCo+lKaSI53j1WOvfQdtmGmIbsVyHSXS0pzdMn70lnU70I+VknrJniUePqYTA5hOeftzdRuRM8u8vv2xtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJU26+30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJU26+30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9692AC32782;
	Mon, 12 Aug 2024 16:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480533;
	bh=hZ/GQloBnjg9t+zo/1ym6YtbBIoq570smZZslzqZY14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJU26+30woISgHybtF+AqLQi2OQBYJMo0SAMYVsVWp5pvWDLH7k3pMVAeOPulnxSJ
	 uM+nktDeK9XPsry1THbW/ejTQBwFlqPsSo+f6SEOn4bod9LNnoKgyQSc/ac2beDkSf
	 sFVuaPQ7wJ/Vk4EM85uVgew/UmCHvhPgTcfkV9t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 183/263] ALSA: hda: Add HP MP9 G4 Retail System AMS to force connect list
Date: Mon, 12 Aug 2024 18:03:04 +0200
Message-ID: <20240812160153.551956681@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Steven 'Steve' Kendall <skend@chromium.org>

commit 7e1e206b99f4b3345aeb49d94584a420b7887f1d upstream.

In recent HP UEFI firmware (likely v2.15 and above, tested on 2.27),
these pins are incorrectly set for HDMI/DP audio. Tested on
HP MP9 G4 Retail System AMS. Tested audio with two monitors connected
via DisplayPort.

Link: https://forum.manjaro.org/t/intel-cannon-lake-pch-cavs-conexant-cx20632-no-sound-at-hdmi-or-displayport/133494
Link: https://bbs.archlinux.org/viewtopic.php?id=270523
Signed-off-by: Steven 'Steve' Kendall <skend@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240806-hdmi-audio-hp-wrongpins-v2-1-d9eb4ad41043@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1989,6 +1989,7 @@ static int hdmi_add_cvt(struct hda_codec
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),


