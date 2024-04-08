Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8385F768EA;
	Mon,  8 Apr 2024 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582553; cv=none; b=d91A4cLF2o/ySiOoLNybDK6CdU3HBe0neqwz0tKMR6uM2WbFQb6b2ZAMcjv9Bb+6vVgmjySIp0qjohQjfVfqiZaCnmn3W1Tnhtn4NcV6f5Kpc5mywsx+gElb7eYNHPzPDaJnikd0Q3VOe6uohqqc5k5UlNwNUd47JKoiIZ0imkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582553; c=relaxed/simple;
	bh=ZHAOTJJVgd/K+714pnObaIGlqgdS2uC+ohdceg+feIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6qHrboa9a9uuaodIt9aoAMF+SNsKqPdiCbtH/kpjEIFzOMDxieBCqIEe7c98B56Napr+6qjxWgdevnLE8pXUAO1IgyH/V3TqMlKrWr3dAZw49P8LS8mOD16UiUaz3B7fd7NCJc95YgUU5V472omIHSqSRTFGxCT9f6YTYpTAJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amFFXSYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amFFXSYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09629C433C7;
	Mon,  8 Apr 2024 13:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582553;
	bh=ZHAOTJJVgd/K+714pnObaIGlqgdS2uC+ohdceg+feIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amFFXSYxdm0c70nt3BtJ9pz14P6Ej6p3J+RT+JxfGmnliEkJfEq2bOR0DqIl6tfhI
	 t+d8xrvXetTlFaJdtDLtvnVDcDYphTxiybfdLF2HHWoOOHxDD5HIPhvkaTuwDAP+RB
	 W3lVlPz7GDdSx50sUK56ilmk8X6g+vBUuus89J+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 115/138] ALSA: hda/realtek - Fix inactive headset mic jack
Date: Mon,  8 Apr 2024 14:58:49 +0200
Message-ID: <20240408125259.807709025@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit daf6c4681a74034d5723e2fb761e0d7f3a1ca18f upstream.

This patch adds the existing fixup to certain TF platforms implementing
the ALC274 codec with a headset jack. It fixes/activates the inactive
microphone of the headset.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Message-ID: <20240328102757.50310-1-wse@tuxedocomputers.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10121,6 +10121,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d05, 0x1147, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),


