Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC2621ABD0;
	Tue, 12 Aug 2025 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023173; cv=none; b=WCe34DQOtHb4TV0Q3hIR09OJb8zY8NUxE18Fgov9PrAZpkR1//2hJvjJTjbT3oK5LwCSz6QGbc3MUoi7QX7cUr7wZdY5zjWEG+a1a3ZZY5hgg8Jad1YHnno9h3aA15fxqpMKqlBM41ah6tsigLtZ1GBnEB2lhMqNXu6ZiuJygsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023173; c=relaxed/simple;
	bh=n2e5PWQEMy3mfXuVcM7LrLxrTHfF/PuPlBym1lIIa2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJk32mH5B93uPMgsO1yGzpzbInf6I2wizgA5POPMMEb75DcAa7LWQwT69iPuK1/J2oRUY6QjzqNCDYRh9U7tSOx3dt6cT/Xcpmkwnbu6wLkGbaP9TkIpfq91rqginVLf2wM+8fE8lKrqUK0fdboHD1Qnjxcq/r8e6ePMnbQs5OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DH0zhcEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DH0zhcEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2275C4CEF0;
	Tue, 12 Aug 2025 18:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023173;
	bh=n2e5PWQEMy3mfXuVcM7LrLxrTHfF/PuPlBym1lIIa2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DH0zhcErDpcHx4GC/i+vMV6iLfmOncCwnwDX0TL1rsaNOc3n9JH4KLhCEz1GZXeBK
	 7v7CsTwUgyyfcWhuafm4hSk+uZFwoBHb2+dehEw0QBxDT5DaHXoN0gc6ysL9rD9ZtM
	 Qqu0is/I4pqKSXrkRdbS2bA5iZQJKJBG/RU0T/AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 357/369] ALSA: hda/realtek - Fix mute LED for HP Victus 16-d1xxx (MB 8A26)
Date: Tue, 12 Aug 2025 19:30:54 +0200
Message-ID: <20250812173030.121572244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edip Hazuri <edip@medip.dev>

commit a9dec0963187d05725369156a5e0e14cd3487bfb upstream.

My friend have Victus 16-d1xxx with board ID 8A26, the existing quirk
for Victus 16-d1xxx wasn't working because of different board ID

Tested on Victus 16-d1015nt Laptop. The LED behaviour works
as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250729181848.24432-4-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10678,6 +10678,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8a26, "HP Victus 16-d1xxx (MB 8A26)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a28, "HP Envy 13", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a29, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2a, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),


