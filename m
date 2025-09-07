Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0EC4315A;
	Sun,  7 Sep 2025 20:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277858; cv=none; b=KJPpLWyLXWoQAcfn0AXp1HtjkGDJiZ8wuHuEB1AWXfeo6iQ/Nl0FWk3gJuUk+aiUqj1PKH65o1nnds/Os/6XatcN+TYPC5D24yA5xXeSN0vuJRqWOVvM5MwGX9oKzzuTV3eV8gBX6QLIo69rJEtcpYMizfwhM3JubOCCbU+dVBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277858; c=relaxed/simple;
	bh=4YWdtccDT6sMcqpzWMJTOoZ61thggpR9+EFKqHlxJfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugiBwwTarHjGgjvx3JDogJtQEVJIS+Gwrbs0Mido/heiSqHbHvpSW6Sf6jIIMYmWYXHusOR2NEvQJNut4Hh0v8zAAZ4vqhEdaTvwdq/8vyM3da2RJ9jpgDI3x1AMrLuNGpz7/wS5dp7Sx532AMzOkjRhpqr0O+yTCdLPjKPc2q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZ+50UmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZ+50UmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E25C4CEF0;
	Sun,  7 Sep 2025 20:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277858;
	bh=4YWdtccDT6sMcqpzWMJTOoZ61thggpR9+EFKqHlxJfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZ+50UmXtMAXoN9SNHPIZMyQ6drliu5082XnNpoIu0HyrkGUfxAXmakfs1rsHkzgM
	 B6owRleYUgERAeMbO7LxlPPZ2cuGl1pT+s98FppClbdEzyEJF2SAwe2jvb60jZTAbD
	 xn1l9MRr8NZCfkyXhgQ9qZ+E6CNoEmk8maSptWMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.16 144/183] ALSA: hda/hdmi: Add pin fix for another HP EliteDesk 800 G4 model
Date: Sun,  7 Sep 2025 21:59:31 +0200
Message-ID: <20250907195619.226646385@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit bcd6659d4911c528381531472a0cefbd4003e29e upstream.

It was reported that HP EliteDesk 800 G4 DM 65W (SSID 103c:845a) needs
the similar quirk for enabling HDMI outputs, too.  This patch adds the
corresponding quirk entry.

Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250901115009.27498-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1991,6 +1991,7 @@ static int hdmi_add_cvt(struct hda_codec
 static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
+	SND_PCI_QUIRK(0x103c, 0x845a, "HP EliteDesk 800 G4 DM 65W", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),


