Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1292213E6F;
	Thu, 12 Dec 2024 17:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024641; cv=none; b=bLXupkF+MSB+9SkvA1pGxqKFklsrt0jAZP/7e1BEVN/w5O9uQmPXoqS03mH5Z/4vxXDJeiPSDBFWtpOdlB2rns5ydyqYNu/1A10HBYC7cg5H20kvIK9/DLgQDSthvsPIxLbZo2ucMysMsPPPzDrCO2gMr0AbykSEUMygzWcVegA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024641; c=relaxed/simple;
	bh=v28xHSLjP0WEh4d49xZDcKS0l7x7kygEuUHvvRug1iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3PZ+qqxv+rlvX3KXVw2f53GOiI65QTFWoSBduKGACujYpUN6wQfOeUPl7C2xHm5ZSshXXRfiHKO4jMXFV02e73kGWGk0b6Fm15vtbN/rXy12NoedIHqmOpaIQ41wg+gCnjA+eM0P8oDQNeS4m7eRkmAy6GOZXTL9WkGXstaa+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIYhamNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIYhamNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4146BC4CECE;
	Thu, 12 Dec 2024 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024641;
	bh=v28xHSLjP0WEh4d49xZDcKS0l7x7kygEuUHvvRug1iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIYhamNONSSyZqRRXi01OuTJKbOcrcxhWC+V0uVgBTd8C3Ey/kOr4B6JM9A7eZ2oj
	 VO+Tm49gQ46tCzO8S3sBFcAm7MR7U0vM0X7RcRK2r/V3bSWpST7aH0oiB/7H6fmPmI
	 vAnv5tvOaLzQuy7drhciUeW8UPVvneQkeZ/7caeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nazar Bilinskyi <nbilinskyi@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 364/459] ALSA: hda/realtek: Enable mute and micmute LED on HP ProBook 430 G8
Date: Thu, 12 Dec 2024 16:01:42 +0100
Message-ID: <20241212144308.053683404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nazar Bilinskyi <nbilinskyi@gmail.com>

commit 3a83f7baf1346aca885cb83cb888e835fef7c472 upstream.

HP ProBook 430 G8 has a mute and micmute LEDs that can be made to work
using quirk ALC236_FIXUP_HP_GPIO_LED. Enable already existing quirk.

Signed-off-by: Nazar Bilinskyi <nbilinskyi@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241130231631.8929-1-nbilinskyi@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9149,6 +9149,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f1, "HP ProBook 630 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


