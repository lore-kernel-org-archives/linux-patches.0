Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389D51A76A1;
	Tue, 30 Jul 2024 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360218; cv=none; b=hUPitmSwrKyA6/IzE/VS/c80P6JTCDO98+sGCH+srsuSiL+hMYmvmyehDFipEHPq3QYXudoYyuKhyfBI1+DnNPNwwRC4bYzKAAO3EleaP7oDpXJUnjbU3d43aL0mH6MR7IHFZJ1VzeUxdgPO2ctZ+wBl3nrgE64yatcY/uCDoWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360218; c=relaxed/simple;
	bh=nPUPu5wGxfRQb4HnpJEHyIikwg4MmVJWxd2rtxOBKeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjElbOUq4ItCwQ8g0Y/9/+ylmNnp32d9nYZzcAqW085HGBtsU43BcTeapDD48hOKiGUxueQ/WgP0bGvT6EP/1wNpclp0RbotuHq84XqIGyI1Y3yhSyYCnkxfCOxHOHAkwKO5L7j1xvnn/w3ap/5JGbQ2PaZCEbPJEX6FP/W2yoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fm8XvNKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fm8XvNKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B465EC32782;
	Tue, 30 Jul 2024 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360218;
	bh=nPUPu5wGxfRQb4HnpJEHyIikwg4MmVJWxd2rtxOBKeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fm8XvNKrfCr0vthE722Alg/iIfJEEd8gDvq6JQk9qY5q4uVoyPK7kf71uV9K42oM2
	 OEa7u+6FFSIKfaUdLLODOwLWSgqWw02yUMjmM4r4F9JbnHalctPLlQFRP69zvxJiRK
	 F6IiRwWca4v9yYMELq0o2I+wRdZyGkHbPeLmElWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 625/809] ALSA: hda/realtek: cs35l41: Fixup remaining asus strix models
Date: Tue, 30 Jul 2024 17:48:21 +0200
Message-ID: <20240730151749.526887049@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

commit e6e18021ddd0dc5af487fb86b6d7c964e062d692 upstream.

Adjust quirks for 0x3a20, 0x3a30, 0x3a50 to match the 0x3a60. This
set has now been confirmed to work with this patch.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Fixes: 811dd426a9b1 ("ALSA: hda/realtek: Add quirks for Asus ROG 2024 laptops using CS35L41")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240723011224.115579-1-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10360,10 +10360,10 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
-	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x3a30, "ASUS G814JVR/JIR", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
+	SND_PCI_QUIRK(0x1043, 0x3a30, "ASUS G814JVR/JIR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-	SND_PCI_QUIRK(0x1043, 0x3a50, "ASUS G834JYR/JZR", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x3a50, "ASUS G834JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a60, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),


