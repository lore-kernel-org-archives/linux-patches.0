Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583E46AC2;
	Tue,  5 Dec 2023 03:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAdDVRHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44D0C433C7;
	Tue,  5 Dec 2023 03:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747695;
	bh=CfH9LvbxzpHz93HOXO9LcomrqGO3u1J2FwSeZqi/zWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAdDVRHTUDDz2TZ8ZNZ4wcpwcBg1cmXMnYtHK2xQ6mM9HtnAnoc0ySrFMpbFDoXbr
	 IDcaaU03UniqmiupWe6i1y2ABAnwKe/20H9IvCDhvv8KlOLFRMZri1T5DoUU+3ZnhH
	 o+6jhHUWgG8F5HkRTTyyfZyZjkfaB4uXU8r9MyQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 10/67] ALSA: hda: Disable power-save on KONTRON SinglePC
Date: Tue,  5 Dec 2023 12:16:55 +0900
Message-ID: <20231205031520.404945262@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a337c355719c42a6c5b67e985ad753590ed844fb upstream.

It's been reported that the runtime PM on KONTRON SinglePC (PCI SSID
1734:1232) caused a stall of playback after a bunch of invocations.
(FWIW, this looks like an timing issue, and the stall happens rather
on the controller side.)

As a workaround, disable the default power-save on this platform.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231130151321.9813-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2210,6 +2210,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x17aa, 0x36a7, "Lenovo C50 All in one", 0),
 	/* https://bugs.launchpad.net/bugs/1821663 */
 	SND_PCI_QUIRK(0x1631, 0xe017, "Packard Bell NEC IMEDIA 5204", 0),
+	/* KONTRON SinglePC may cause a stall at runtime resume */
+	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
 	{}
 };
 #endif /* CONFIG_PM */


