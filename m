Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC0D2DF137;
	Thu, 16 Jul 2026 13:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209193; cv=none; b=ERMkxIc8EhHhrlo33o7ZT6S59hpZCxeu4vdWcEIZP5rJTtcWP3hsE/YaVfWRm6Y5RqBn9K5bOGvepr/r2uOz2lTCuiCB8VzYZ49ExVmWam7dVCImtippHRL+dbV1g5UkTNawWFEhoo/9Uonswce2jHK7rvJ+Q2jUG5TyzCgt5Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209193; c=relaxed/simple;
	bh=wzXeXSim8LlahByCgVJstEm6IIeaRggLF2SHZ0QTI0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1uVbXXNoGwXB1QfVXJEIej2/cFx6Xjkb9uIyqjlDEiyNZauxVWeXjogvP80X7+Nu6PJNfKQ+z1oczN4+N876rl/1XBkfvi1K0/KcYl3Q40CpeWIGWK9GIhHnOmg4HY3GsPoaqUzz+nFIzKJeB7KeK/GDQfmEGYiW2kN8aqV3os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4zDy3PG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4zDy3PG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35261F000E9;
	Thu, 16 Jul 2026 13:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209192;
	bh=MOyWkBbuTyJE4xqLYgMzKxJYbCQF0JlMiAYfJJAHj8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4zDy3PGx6OMMjqzNaAYrM1RJwMu6hTtAzo5LNUi4x8OeTPy0v5W5IxTnsrBuFdGI
	 ixtJU5p5UPHePh/qolBD62Ob2vtu9oPNjZp+on2FfZ8/uDU/8U8WAOI8MX0AQ05HSz
	 0ueRpsp0rdYjgtnkSsbsGo8Uu8bqaIxnm90hVnFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Graham <cam.graham@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 092/518] ALSA: hda/hdmi: Add force-connect quirk for HP EliteDesk 800 G5 Mini
Date: Thu, 16 Jul 2026 15:26:00 +0200
Message-ID: <20260716133049.880007114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


