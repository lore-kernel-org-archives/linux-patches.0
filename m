Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1658612D7;
	Tue, 20 Feb 2024 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463523; cv=none; b=TvfLXKGvteXc+qUUWcssSShaLOgQY2s8Eed6xiaxAKMqu97B5/I6SOHvVZt81vu8ZuMHpDVMsaWUYKTLZPc4DrINqihUbrmXRwiYdZOIvPmcaouK8KBlKIsdEpU67czuK6W31ICQKq+u9Yj8YVAy7SVL1Q2sjVc4La3/pymlXHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463523; c=relaxed/simple;
	bh=PAnHzYpUVOiAY5Ow3Ju0MikOgeuvmjXAnGK5F6Pb7TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILdXwzN79Igzeurd83DbNZUQdQyXdoeOloUb0aColQndRJ0jrh67QHsr96iR6ejQ0NoBGJYYsp64VVqTV1EEf/fXIZEtCA6rNheSzAIlvnUNa5IJjjIj4vsgDfcsqlJmzcQagQRumJAUGCwZ4aRR00zjwe8XDr1M2md63EDLav8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwojsf9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwojsf9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2076FC433F1;
	Tue, 20 Feb 2024 21:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463523;
	bh=PAnHzYpUVOiAY5Ow3Ju0MikOgeuvmjXAnGK5F6Pb7TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwojsf9yvchiEEKPC3Fw8s66Hlzlj9TCTZ6oFJTLBv7Ur/hhoGt0hA6L1BJM+ilUT
	 T1goUav7yJpd4AnzdJGi2BogC2nz8eOGtea++x1XMwcXWOYtsxXkd4aERgp0bu4dV4
	 vZG5kwlUc9DkZ9sW0vK3zLQ0QvaO2jAc2nEyJINo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Guzenko <l.guzenko@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 070/331] ALSA: hda/realtek: Enable Mute LED on HP Laptop 14-fq0xxx
Date: Tue, 20 Feb 2024 21:53:06 +0100
Message-ID: <20240220205639.775897031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Luka Guzenko <l.guzenko@web.de>

commit f0d78972f27dc1d1d51fbace2713ad3cdc60a877 upstream.

This HP Laptop uses ALC236 codec with COEF 0x07 controlling the
mute LED. Enable existing quirk for this device.

Signed-off-by: Luka Guzenko <l.guzenko@web.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240128155704.2333812-1-l.guzenko@web.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9746,6 +9746,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


