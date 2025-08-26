Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE64352078;
	Tue, 26 Aug 2025 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217250; cv=none; b=VLeYwniT9NqZGB9YJM85+VxXmU61SfecZ5edlbDXeezYn677YKk+2Rjtr4ifQABpT84Q3D17uwsebOR7HWC4aV2bCPVx7cRBOW2M1qkWGM4VVzUVW1yOqdx8Vq7grhipZmrERFb5GYjaxRblFgp8u561qHjpsJfYYhtqstqAlM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217250; c=relaxed/simple;
	bh=VSK6K8/53q29rLYcmf0WpUDAxF7bg43PtyqwFGadCYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQXBsnFufAcPfvFBsSgjAqkvDTrkS5R+UB2ImKX5wDUGN0SA47EuRPBbgEVwqGJoLM60KmqZso+C5qCPw5fL27lzd+gFqaDrgEul0396OZ50KbybesI5vwQctaMmWD9Ej4RO5hO2DTnyYfZ1uaQuANS0ZrE1HXFagJsW0wgQq7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/1Ij69K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/1Ij69K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C791EC4CEF1;
	Tue, 26 Aug 2025 14:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217250;
	bh=VSK6K8/53q29rLYcmf0WpUDAxF7bg43PtyqwFGadCYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/1Ij69KIp3T+UfcIY1rYC1UAPCIFSmmFw+Jyo+xePimnmGm/+wwF2+AIfAxKPG1w
	 76kl0InlWpsrZypLUeeuClPPHvYlBfQeCPZJPpDi1SyWUc4aH1PLCvyCxAqnr4RqMO
	 V0a8KjxMlS6BoLiM9R+HNnYVUI3uqEcnY3UWflQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Rezler <dawidrezler.patches@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 065/523] ALSA: hda/realtek - Add mute LED support for HP Pavilion 15-eg0xxx
Date: Tue, 26 Aug 2025 13:04:35 +0200
Message-ID: <20250826110926.182911031@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Rezler <dawidrezler.patches@gmail.com>

commit 9744ede7099e8a69c04aa23fbea44c15bc390c04 upstream.

The mute LED on the HP Pavilion Laptop 15-eg0xxx,
which uses the ALC287 codec, didn't work.
This patch fixes the issue by enabling the ALC287_FIXUP_HP_GPIO_LED quirk.

Tested on a physical device, the LED now works as intended.

Signed-off-by: Dawid Rezler <dawidrezler.patches@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250720154907.80815-2-dawidrezler.patches@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9287,6 +9287,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87cc, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


