Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DD0171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1124DC433D2;
	Mon, 22 May 2023 19:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785087;
	bh=lxwGDSxdaQjbSM6AnjPAuhTXSpLtvj68Nnf9e3IxRbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jujkQ99ZlM2WuZ+IEwzrdU48VNlwYEzQ0wFYIWOYRsAm3JEPIf8iv+OBvw7EHl8Sf
	 Vz/fVjQUfcwRMvx2XTs/ip3ya1IedWonhHXZ6h7bs6OGl5BpUFHotmYrbUSuXmp0H9
	 L33iVOq2xxPyMilzpMyR3xUX++qBfzJtQv2NQHCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Soller <jeremy@system76.com>,
	Tim Crawford <tcrawford@system76.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.3 303/364] ALSA: hda/realtek: Add quirk for Clevo L140AU
Date: Mon, 22 May 2023 20:10:08 +0100
Message-Id: <20230522190420.347177576@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Soller <jeremy@system76.com>

commit 0a6b36c5dc3dda0196f4fb65bdb34c38b8d060c3 upstream.

Fixes headset detection on Clevo L140AU.

Signed-off-by: Jeremy Soller <jeremy@system76.com>
Signed-off-by: Tim Crawford <tcrawford@system76.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230505163651.21257-1-tcrawford@system76.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9618,6 +9618,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x7716, "Clevo NS50PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x7717, "Clevo NS70PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x7718, "Clevo L140PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x7724, "Clevo L140AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8228, "Clevo NR40BU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8520, "Clevo NH50D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8521, "Clevo NH77D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


