Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19118285C89;
	Tue, 12 Aug 2025 19:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026858; cv=none; b=sAAYNFuACm8xjx2rszzbWZZfpHNlzaPWrvIcKV2YHteI4Bh4s5wWFP77618VzbDDUq0+kyvIuaxbdYFH2sl8O0yVqC5yLZyFPRCpLa/ILcNGxDijRD4BjntNQUKSP5L47yb01ELL63HsVciFgmyQF5X65vix2+BA4kMdu4jcx9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026858; c=relaxed/simple;
	bh=unJ52IOLiS+wEXyO9MryNQF6qUk79UgX1Q2vCX10t4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dz/z2aOw7M3O1q4B8cinJa5Sv3z2kCSmQ4cMJbeso3vAS7VkO0oQmHKbk4WchhlDSYY7lsd7JqySKONjfiZ2h9HKrGBnVp7xPsidXL/LnCmuCWou2uxNPTn/9OcdK2H+PoLlr+dPX/se7HAJGj4vcla8t1XqVuRzFdciVe7Is18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ua+cLFK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ua+cLFK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A597C4CEF0;
	Tue, 12 Aug 2025 19:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026858;
	bh=unJ52IOLiS+wEXyO9MryNQF6qUk79UgX1Q2vCX10t4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ua+cLFK5cn2hoCiuO8kTMkxsdoG5aaWFwyOTIRlBH62k9wncetJ/WKM0o4ZVTUTZS
	 5p06i7jGU1aMeBxy4UU3tuoNe/GN5vJOytwvnp1flyl5T9/SxvSLJBIkfX8EB4Hk94
	 1TTB1YbRV01ky0ZKz/n1+WJVW5Uw6HQ30+CL7yyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 461/480] ALSA: hda/realtek - Fix mute LED for HP Victus 16-d1xxx (MB 8A26)
Date: Tue, 12 Aug 2025 19:51:09 +0200
Message-ID: <20250812174416.408275264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10741,6 +10741,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8a26, "HP Victus 16-d1xxx (MB 8A26)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a28, "HP Envy 13", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a29, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2a, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),


