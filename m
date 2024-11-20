Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858191B6CEE;
	Wed, 20 Nov 2024 13:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107671; cv=none; b=h/F96nC9iTx5VBHS0j1iiYFkQ9XqNAFsQxcFBUNmpbQKDOOBu+JJ9G0jKA0DNtx64nC7JYFuY/X9QmgIlj5UjBgdujL501g5driX9xSggw5ScDXUy9f1/s7myJ93XluFwjDYCF5FtLdXDt5bMtkybuSnTPuyRv6RB6t9QUlj+ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107671; c=relaxed/simple;
	bh=BnNB+IdYJGsbXs/PXp0Sf5honPwz4KEZhZLGXcqX8EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1WWcRrYWCxmijNyp3C9MDVyVMrRLICFBvFaf/G2KVsCCD8AUs+lXEP9+FV2m8Y9u5qEGQzeKg6InjQkO4qIA7EpFjWHRtFPVgwFxUJPgBVUdk9yLa51JXk81gZB5W6NIBtx83P0PO8SdZWHqGNoJx5XvO+NMppzVwOKzxCbUcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2ijq+n4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2ijq+n4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDF6C4CECD;
	Wed, 20 Nov 2024 13:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107671;
	bh=BnNB+IdYJGsbXs/PXp0Sf5honPwz4KEZhZLGXcqX8EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2ijq+n4nvaDcRTVQFIx44jCec/8bAEd/m240Kp+KRFFwrC95zO4GUfBU8NBu3Ioy
	 /fXKfC0uP3+zp15ZO2dX/g7xkrqQ+aTAZkJxKP/EwTsoh/Tk8oanqEN2pJtl4CXRew
	 Ru8xYjcB7n7Pg9kK7Gkvg9xMRMXYeH3olDb5Vy84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksym Glubokiy <maxgl.kernel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 27/73] ALSA: hda/realtek: fix mute/micmute LEDs for a HP EliteBook 645 G10
Date: Wed, 20 Nov 2024 13:58:13 +0100
Message-ID: <20241120125810.262725450@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Maksym Glubokiy <maxgl.kernel@gmail.com>

commit 96409eeab8cdd394e03ec494ea9547edc27f7ab4 upstream.

HP EliteBook 645 G10 uses ALC236 codec and need the
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to make mute LED and
micmute LED work.

Signed-off-by: Maksym Glubokiy <maxgl.kernel@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241112154815.10888-1-maxgl.kernel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9840,6 +9840,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8b59, "HP Elite mt645 G7 Mobile Thin Client U89", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8b5f, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b63, "HP Elite Dragonfly 13.5 inch G4", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b65, "HP ProBook 455 15.6 inch G10 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b66, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),


