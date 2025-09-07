Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48841B424F;
	Sun,  7 Sep 2025 20:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276075; cv=none; b=fnayT3YzO9WvBWTnTLOT6oiyfE4XJ83V+M41jrLr71SvzI1WUCNYD98KO0/rLzMYYJvfFuZSQTjM67TwS8+ktZY/d8V0CAK9G88vqYhbEBjMFdYwWSZdMKdYct0hhrlz8R7+VDZvF3nKpFI/4wIrRh6IPNGntCbQbtUoP0exqE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276075; c=relaxed/simple;
	bh=LgePqHYOqcj4uIuWRNFc5iiilTRRyZbN1EstbVUgsdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4XdP8IRxLzkaA2EP+KtAjyvZmfkfPTsyNoa50GmaSXMwTwbC6mB9AV6adBqckQNV4NUhAvMNpDuOJ9ssfauMfngNwduguUeY4COFwDkI9r+No4PCJpb0wZ5bqqaqYbia2b6UlNX291X+Md7afTp/8zZ/2oOlBOA/p98s2YUj9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5d626op; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5d626op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A358C4CEF0;
	Sun,  7 Sep 2025 20:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276075;
	bh=LgePqHYOqcj4uIuWRNFc5iiilTRRyZbN1EstbVUgsdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5d626oppujpLm+cT22+kZJYDJ1wYC2yd5bGKwDlG5h61aKYyY/MKg7Q0r98obj8Z
	 err0bjWTS7Ixy68F5/TXDj2MLips3ITNP1H2tRf4VQfjep6B7DWqU6uI/MDo8/0wOK
	 Gitjakx8bgBiGKmR1m0ioJGD5u3TpAEfko66AHBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 55/64] ALSA: hda/hdmi: Add pin fix for another HP EliteDesk 800 G4 model
Date: Sun,  7 Sep 2025 21:58:37 +0200
Message-ID: <20250907195604.934480717@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1962,6 +1962,7 @@ static int hdmi_add_cvt(struct hda_codec
 static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
+	SND_PCI_QUIRK(0x103c, 0x845a, "HP EliteDesk 800 G4 DM 65W", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),


