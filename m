Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9731605DF;
	Tue, 23 Jan 2024 01:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974720; cv=none; b=iI5j8TI5BaDN1XVEA0NKeotazoThbmnc8EeQids+zOZzU9uZRJQ95qVGuybBuiJfNSqKfyLayL5atYS+ymFTLptdMxpnLcVRh5ZgzjvO8gbvmikvPjeRqy3iSXi47el3tLqmZzUAcMsSuh9r1l62ejQpWXDue0yMMEsDCdbhnxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974720; c=relaxed/simple;
	bh=AecCS3PVnwh5PUo+yVpHnQxtA0GaCqcJA/QDXQVdjD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pyKlUb7kbw8fMYZ2XBvR4ggwxcOf3mjIv0/X3k3mvWOF4/MRJP2CKp6E0h2qCT7shUYIGNK7kVDp2M6UxKHCcbbx2BpvVwAezKvuCeddLhy7h49dX+noUTXdtAiOTtgseN4fvK2rZHqlNGmVp/i2+HnFdQvWbcT40pUAm4jXbOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aicyVnkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aicyVnkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC97C433C7;
	Tue, 23 Jan 2024 01:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974719;
	bh=AecCS3PVnwh5PUo+yVpHnQxtA0GaCqcJA/QDXQVdjD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aicyVnkcvcDc3DdtVEbIckChyRY810N4c9fk0G3OxDJ/xy0hEpeBRwQ+kBjeDf9+Y
	 nxxU2PhbXUBryKx9o3HFlybssiikxLnqwBvgciYcU2Uups5RHjtDkmaSGm1ufj83qY
	 xbGUxPuYMpm1zye2ILXnxIic2vZu9P9ybSDTXxi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=87a=C4=9Fhan=20Demir?= <caghandemir@marun.edu.tr>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 266/374] ALSA: hda/relatek: Enable Mute LED on HP Laptop 15s-fq2xxx
Date: Mon, 22 Jan 2024 15:58:42 -0800
Message-ID: <20240122235754.019725179@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Çağhan Demir <caghandemir@marun.edu.tr>

commit bc7863d18677df66b2c7a0e172c91296ff380f11 upstream.

This HP Laptop uses ALC236 codec with COEF 0x07 idx 1 controlling
the mute LED. This patch enables the already existing quirk for
this device.

Signed-off-by: Çağhan Demir <caghandemir@marun.edu.tr>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240115172303.4718-1-caghandemir@marun.edu.tr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9098,6 +9098,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f6, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
+	SND_PCI_QUIRK(0x103c, 0x87fe, "HP Laptop 15s-fq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8811, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),


