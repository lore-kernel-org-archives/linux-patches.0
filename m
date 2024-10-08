Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8C8189910;
	Tue,  8 Oct 2024 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392401; cv=none; b=LV0WXjcDiU2vuao8TsYA3coYdUroCQJroSrL1JQ1+eun5tYBowMwkTwvwQo9beTRhIcMsZJgkT8E4FXc2+QWpdAmG7cyYWUCEJuBcrcX86pgO4I7tBmb954bjFwSlZ7iNsgfc8bNEa4loIb8w/4uCOTCA1y+Y9Oqk7vkJqFXJCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392401; c=relaxed/simple;
	bh=XII1eTfOyLtLLzsAS6PX/NwGRrJI4EEtORg4z+5PEmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZufBKCQmCeFNkK49zNuzwtyjP6D3Wacv3NugDhDyipwqdf2cnMUXYPwiGHJ4qXubZv00m2NAzi+eHU+Pq4YyQg9olosvySQrh+iqxx1+rVEU/n4wzMsmXJuIP5CH2tvges2/eEkOq/hoBVeFE/iHy3d2UVCvGaE5A+wloNFiiTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k07Npu9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k07Npu9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E949C4CEC7;
	Tue,  8 Oct 2024 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392400;
	bh=XII1eTfOyLtLLzsAS6PX/NwGRrJI4EEtORg4z+5PEmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k07Npu9fVafz5TxK+ls7QgNHgRjmtazc7dV4N4uNc2jqZF2v+gqc3IXsdDdbGIWch
	 qv/e4lRS40G4bgVAXX6YKbKI9xKq6iqMiGnLqk27WyIIFYKEhbl2kjNV1LMIvBR/cK
	 iwCBasaRCFQu5mUmY+zCyR0Dw0GVxraI/iaKwQV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolai Afanasenkov <nikolai.afanasenkov@hp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 377/558] ALSA: hda/realtek: fix mute/micmute LED for HP mt645 G8
Date: Tue,  8 Oct 2024 14:06:47 +0200
Message-ID: <20241008115717.127919686@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolai Afanasenkov <nikolai.afanasenkov@hp.com>

commit cb2deca056d579fe008c8d0a4ceb04d2b368fe42 upstream.

The HP Elite mt645 G8 Mobile Thin Client uses an ALC236 codec
and needs the ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk
to enable the mute and micmute LED functionality.

This patch adds the system ID of the HP Elite mt645 G8
to the `alc269_fixup_tbl` in `patch_realtek.c`
to enable the required quirk.

Cc: stable@vger.kernel.org
Signed-off-by: Nikolai Afanasenkov <nikolai.afanasenkov@hp.com>
Link: https://patch.msgid.link/20240916195042.4050-1-nikolai.afanasenkov@hp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10529,6 +10529,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8ca2, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8caf, "HP Elite mt645 G8 Mobile Thin Client", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8cbd, "HP Pavilion Aero Laptop 13-bg0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8cdd, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8cde, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),


