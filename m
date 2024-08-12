Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8A3183CA6;
	Mon, 12 Aug 2024 16:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479526; cv=none; b=qt/hlsyZQPbTF28fqBC74SqtKsVktWEe+UUrUwaO+JZLdJ3jdZ4rAn6TsLk0oiFDdJE+UZ17pZTMHYSLOcVq3pn2uInENC+e8pszYepE1LXkilviTyZPoeeJ+3/tXGKVbPgULcwMwS7cyFKujhC6XSiUEx1uXnGGWQpHGs64XAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479526; c=relaxed/simple;
	bh=7lolnTzV/PbN92yGV+DmaA0maEkrDiJiONs/c4aO7SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDmGByyTuHXTkPmE9ijd8aYZNri+Twvt4EFH/U+rQmS1MLD5eff82Iwd37d2hKJDJcB5AEKYCVzI0xbSMFJ6oJ8dMW8TyR9n0zWh9o77C892Sxu2JWbFzZd5s7I1BvPwR1Ja1Ah+XNBzl4wogWtNq32LhfglDLGAsgUTUC4sP8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHY2xvRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHY2xvRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC17C4AF0C;
	Mon, 12 Aug 2024 16:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479525;
	bh=7lolnTzV/PbN92yGV+DmaA0maEkrDiJiONs/c4aO7SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHY2xvRhi1kfzn4Eo3bZhuvz1cJhhm3Foy9KjmVW9vxvd8WpfoBUjIFFn2ZQn/chE
	 des6r3mMM30hBqCCI/moUVtfH+lUhpQ8hRx05YidIUVRewUGOI3tkefZigNK2DhOj8
	 DROUJdGX/hwnz++O26XuS2IJuNUSTUBFUskt3zRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 114/189] ALSA: hda: Add HP MP9 G4 Retail System AMS to force connect list
Date: Mon, 12 Aug 2024 18:02:50 +0200
Message-ID: <20240812160136.528154630@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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


