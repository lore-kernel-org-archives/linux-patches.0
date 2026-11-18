Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043580;
	b=pnSLllFA8t3E6P13pYR+3N/ZJ5KZNqTk7WHkgN9cGOvJxdGD0M/QYXFojHRzzh74N8iX
	 9gIzPsW5/ZCcuaKoaJ0yWvGNO757lmmUlZLqqD11F9ClVnycbI6vrwf+EQFf0WzH61iRe
	 knZxdkMJTLsg5ccZjJ5Io2LLTlbEf/xQyvEqPL7KzSQdL65gcGfKLrmt4+WfH73fIzmun
	 r7X3c1//hInS9xf1rF+RjLKPXQAd8vk8bbp4my8N3QhMJPWypKKKYm8qJr0bjTlB7giom
	 HE8v3PVhOghL1vN0/hsBKvodR/t+HRSu7UWmkVbFtLHpqOcumCzfu/YzakF5fw4vFDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JCQPdkRese6mwrVIrYNbH2U2J0gVqG0umR2XwagG2RQ=;
	b=jaC6Hu7uUb7NX77sWoqxYRSerIz0WmUwMLqL8cq5fg+rYpb/deF1lhzWpYY+kEYWsSR+
	 b0YMdyDkKnsvZ61Fha1j+NTpTOd3JkhDY5yeqt8xAeDfcsH9dYTXwzyOc9puzMLlHuYlI
	 4Au2WWl2FWl+KUvO1Hhlnt4QVRNzRUEbRT7hleAhHxXpeRo9Wm/TGMysLBcLA8wR4mQoY
	 kbVSjFgWgFYXfjA6bkIEfRYeM+VB66D8YLJffvT4UnUh0DyCY6MkYf872ChUYr1vL3PjA
	 k7AAssap52/tblQzF1yMdNMvbeVe7MMjjaVrjKacql7o4Eg8QUgKLK3oDzhJqVgDmow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YpTttnK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DA8606A320;
	Wed, 18 Nov 2026 23:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YpTttnK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75741F000C4;
	Wed, 18 Nov 2026 23:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043580;
	bh=JCQPdkRese6mwrVIrYNbH2U2J0gVqG0umR2XwagG2RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YpTttnKNqEnL9F4KN02HaaeKmgpWnoIxHLQAXJ66pMw3zy0qdTfQahKbQH4ntp1n
	 vajOrHLfehneYYnWb1EyFUdMiVWPLkWASNoZBTmR/et6YZeAUKaBPJGxGxz+LSJDpQ
	 Y+Lu2HpgNwdiv4pI55U5qHELr55hgYO9F+3GEUcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Moroziuk <dmorozyk1@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0234/2857] ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5
Date: Wed, 18 Nov 2026 15:21:08 +0100
Message-ID: <20261118150209.878994635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmytro Moroziuk <dmorozyk1@gmail.com>

[ Upstream commit 191fe151eb85ff6cb24189fc88c970745497c057 ]

The HP ProBook 440 G5 requires the CXT_FIXUP_MUTE_LED_GPIO quirk to
properly toggle the physical mute and mic-mute LEDs via the CX8200 codec.
Without this quirk, the LEDs remain permanently dark.

Signed-off-by: Dmytro Moroziuk <dmorozyk1@gmail.com>
Link: https://patch.msgid.link/20260812121856.30353-1-dmorozyk1@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 44b1d5c3ff993..f631dc0650e4d 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1125,6 +1125,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x837b, "HP ProBook 440 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
-- 
2.53.0



