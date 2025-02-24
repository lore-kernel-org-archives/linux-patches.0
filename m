Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B7B1B7F4;
	Mon, 24 Feb 2025 14:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409174; cv=none; b=I+koa51NfO1XyUbNXWNvjYLWeE7Dczu09dEU1CEXn8GD5sa2k/Y75kp8edgCTUKM9Hln5KNlsOvUWvbf1n0Wn+VhtwrBxjFAaOz5Je5m6jalsq7qts2QxM7MS5N01T5On17Er38kMdQ5wJSF6wGWJa+IKJyzqtFFimcpHR+SGs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409174; c=relaxed/simple;
	bh=F4PyRwAR3WyT+jLk0oYqGiq4oN4ZDqIKUWAtDNrxNic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBEynatjwv+53yU+UPUIf26T+EezodQRvf09qTCvztBLXjEkFyoUZ1cLIYvn8qri3W1HCRJ7wua1BQpmerTGJIV5qKjL3sWA922hHE2yBXgqvAbaOFUvkashu/kutyPJ9S1THpnqr+uueip0PmM4koLiBTKu1gbMP6ov05XpNAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTuAYwpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTuAYwpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE77EC4CED6;
	Mon, 24 Feb 2025 14:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409174;
	bh=F4PyRwAR3WyT+jLk0oYqGiq4oN4ZDqIKUWAtDNrxNic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTuAYwplqBxan7oIwRISe1CNnSYD6qwDZHGJkjxlnYf0Zmir5CMgZgZ8u6RBCQonm
	 Gug5RbvYNuokpU3VKSbJp30myG1m0x5E4IjtHVwS+GRqd93WZ+HTpEITeudp9+TRD3
	 ai6IQmwSFEBlPUaa0+HNgYFft5dGOSR34VBKZYO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Veness <john-linux@pelago.org.uk>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 118/138] ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED
Date: Mon, 24 Feb 2025 15:35:48 +0100
Message-ID: <20250224142609.113342764@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Veness <john-linux@pelago.org.uk>

commit 6d1f86610f23b0bc334d6506a186f21a98f51392 upstream.

Allows the LED on the dedicated mute button on the HP ProBook 450 G4
laptop to change colour correctly.

Signed-off-by: John Veness <john-linux@pelago.org.uk>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/2fb55d48-6991-4a42-b591-4c78f2fad8d7@pelago.org.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1080,6 +1080,7 @@ static const struct hda_quirk cxt5066_fi
 	SND_PCI_QUIRK(0x103c, 0x814f, "HP ZBook 15u G3", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8174, "HP Spectre x360", CXT_FIXUP_HP_SPECTRE),
 	SND_PCI_QUIRK(0x103c, 0x822e, "HP ProBook 440 G4", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x8231, "HP ProBook 450 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),


