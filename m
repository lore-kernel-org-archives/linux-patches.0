Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B41183CC4;
	Mon, 12 Aug 2024 16:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479533; cv=none; b=ULx1k+aKy3eS/g5LYR1khC6Pqx0zObBDvlTkewmm+SjVDfzXk6c4OOW8/6bifo44dkFvgABqYnjDXiySYZFhNGxULO3G6lDQYOA7hFXQJdRj7iQAfCgGMEkPyFWS4oeBDvQ+oVhLNBI2/uGkthPx8mOwaTI+g2pzwy4UAUPj6zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479533; c=relaxed/simple;
	bh=0V2daR+RuCGHZnkgCUIXRJo1e0YpL8b6SDtZNtD44Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvTuhK+Em5yTdvHF9Rbf2Hyp7jTiMyoMWdX37FEZoLkNZWaP3PVBKQ7WePSCcDrptE0v6kry4rAyF3EIa8U9Ge/E/S5qFsITUBwiCF7cNE5i9kfD5vEYaVZBLKZnQAB2ZnbVBQ0TY55LNVzfQttDmBGdOlZvpASrf7Qvh/NOsv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2C54ruj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2C54ruj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDB7C32782;
	Mon, 12 Aug 2024 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479532;
	bh=0V2daR+RuCGHZnkgCUIXRJo1e0YpL8b6SDtZNtD44Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2C54rujU8Rc6XfZEa/nTHN+Efuma2Cxf0nQGdd8KbIYlu0nQKLtDKz3c5jD2myiJ
	 MaHVYvXTpND8YTZYxfPLtgkoeCPHlgsAS5PXwb3xpxUNo4IfjqbGUyK1AIopkywayK
	 5lXWDnbIXZEeA5JIZlbZPEWThU2aHRcMIaCpoezU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 116/189] ALSA: hda/hdmi: Yet more pin fix for HP EliteDesk 800 G4
Date: Mon, 12 Aug 2024 18:02:52 +0200
Message-ID: <20240812160136.603765533@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 176fd1511dd9086ab4fa9323cb232177c6235288 upstream.

HP EliteDesk 800 G4 (PCI SSID 103c:83e2) is another Kabylake machine
where BIOS misses the HDMI pin initializations.  Add the quirk entry.

Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240806064918.11132-1-tiwai@suse.de
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
+	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),


