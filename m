Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DA423395D;
	Thu, 16 Jul 2026 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210585; cv=none; b=n8q0vMDeWrrI+9hjLZcYFl8rOe/qC4NcVSxK/sULX8vCQ3Bddqznwn4B1yPXzkz7Y5kF4LU5Tfw8kOTT6QsYUlplhwry4ou7I0727fUeKSmGgyj9orOZbKPgEAatrORAeqEamB2o44oz44eeaSwpXr88ONcUqxhxdi73kYEcmgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210585; c=relaxed/simple;
	bh=aEVj1oYYj0Pl0HO+lPEkYfYgz4WF6FaZ59qtHZ1zdAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJfFaUndf3AkOD/sfv+4g/UyroUFJGFOFsy74sol3tNVvO4kp66IFy6v7MevP63P0I6zHRhsoa9/6FZR+mFEIGT0xOO6Lz6NsY2HKcNsbSTkI1WfR1W7JRHvVII78vuixeE/ptfE7FG1EnCB4z83AQQgNC5QldARizORsI6FPns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrV38zu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrV38zu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045C81F000E9;
	Thu, 16 Jul 2026 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210584;
	bh=xG34TCIECqqUeQE7BHSLv1VSUl/07SmUWohlGnpIWC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrV38zu04yQVTMA2yNdaTOXlGzuijEIYOi1FQBA0ZzNI7jBH37KH7j1J3Tui1V+A+
	 bEbweqzcrVes5fIFwgL3esC1NyxgXc/m5KYWKXIzZ7zdJVHHEyV8dQ0dbO4PA3zvk5
	 kU29p/Fzuxxu+L4MxLyQENgzMUQuIMP6Ve44W4WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Graham <cam.graham@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 104/480] ALSA: hda/hdmi: Add force-connect quirk for HP EliteDesk 800 G5 Mini
Date: Thu, 16 Jul 2026 15:27:31 +0200
Message-ID: <20260716133046.962738716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cameron Graham <cam.graham@gmail.com>

commit 0ec17ee704615125c0b6e100c38129393a346bcc upstream.

The HP EliteDesk 800 G5 Mini (PCI subsystem 103c:8595) uses
Cannon Lake PCH cAVS HDA with DisplayPort audio pins 0x05 and
0x06 set to AC_JACK_PORT_NONE (N/A) in BIOS defaults, causing
hdmi_add_pin() to skip them and the DP audio device to not
appear in ALSA.

Add the board to the existing force_connect_list alongside the
similar HP EliteDesk 800 G4 entries.

Signed-off-by: Cameron Graham <cam.graham@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260612094601.1209845-1-cam.graham@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/hdmi/hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -1549,6 +1549,7 @@ static const struct snd_pci_quirk force_
 	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x845a, "HP EliteDesk 800 G4 DM 65W", 1),
+	SND_PCI_QUIRK(0x103c, 0x8595, "HP EliteDesk 800 G5 Mini", 1),
 	SND_PCI_QUIRK(0x103c, 0x83f3, "HP ProDesk 400", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),


