Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE66033CD2;
	Wed,  7 Aug 2024 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043716; cv=none; b=bBn/s+6YQv9PZK1AufNZJZV1ZUM8NpOGrJBrfuHkDgiRoivbWXp8gbvjUmDTbMzunZ6Nv1CiauRY4r9tKH7nUOwoyMMaPusxD8v4LfT5PWnKMTXBLdV4hSluAegTd8XvGHp6mAX7BnCb8EKkZWGUrmtVZuTn2VaGzP1z2e5BxVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043716; c=relaxed/simple;
	bh=dc78y0FnzxyF0kgYT3OwiJ0bFj0hqvqlG30baD533NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cmpe2ZJQj8cbUrhuEluyF8RDr+RrYRWlRxCOeplzvCZUnLwGAfcAJjhaUJDELEO0lHTWWus9FG1fXN/esgFB98U9MBILio77CxuQvggU57STznXAsmqtHpzt1hreve1OAo43W/MpHe0J2PboleJYUcqZ0edmZ/OiIfMhxKN62bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qor88ELk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qor88ELk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03028C32781;
	Wed,  7 Aug 2024 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043716;
	bh=dc78y0FnzxyF0kgYT3OwiJ0bFj0hqvqlG30baD533NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qor88ELkHL4Iph7MqZD7/yBhsS7W78NKSjqbB9K+NtmJrnBiW0rOMnQTPD9132NiM
	 o/g8ACmq/19mOR1W+gTTbiGjYGTMHI3oTxE+IJmlad53kui/jDUFZZnha/xvP9248l
	 zEhuemCHzrG27UfrembMtvDUIZJhE4hn17/fh6eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mavroudis Chatzilazaridis <mavchatz@protonmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 73/86] ALSA: hda/realtek: Add quirk for Acer Aspire E5-574G
Date: Wed,  7 Aug 2024 17:00:52 +0200
Message-ID: <20240807150041.690682736@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

From: Mavroudis Chatzilazaridis <mavchatz@protonmail.com>

commit 3c0b6f924e1259ade38587ea719b693f6f6f2f3e upstream.

ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST fixes combo jack detection and
limits the internal microphone boost that causes clipping on this model.

Signed-off-by: Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240728123601.144017-1-mavchatz@protonmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9496,6 +9496,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
 	SND_PCI_QUIRK(0x1025, 0x080d, "Acer Aspire V5-122P", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x0840, "Acer Aspire E1", ALC269VB_FIXUP_ASPIRE_E1_COEF),
+	SND_PCI_QUIRK(0x1025, 0x100c, "Acer Aspire E5-574G", ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1065, "Acer Aspire C20-820", ALC269VC_FIXUP_ACER_HEADSET_MIC),


