Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D4612F59C;
	Tue, 23 Jan 2024 01:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971763; cv=none; b=DaeWWOeiBSHBhHi6OXbKywImOhEW+CuxD9efs4YRgMvEcvOBV6WYI2BatwcHHbKS2CYPX55/38lYkgBGurHd5Uxu5q7SN8FUGM/9QIgf+XFV5Y6CWe0IX5AaJMaCIg4u3BXf8I3ZGD00kXdNE+h97FMrvAYpJounB9FXboLOoG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971763; c=relaxed/simple;
	bh=PWoxXgIq8WkWCVmYh7CYBmcxvsc4Xo+JF0V//Q6MmSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S+XkkMbBlo/jcDogAnft+XTmuXwdeSuYe78hI4HW3rRNWwYovPx8dc6mmVJHyP6uHAUeuouvpBALPRdIZWjZ+79A5Q9t9/cwvkd7o/s0mfIIWfhRs8GqYCHH684+qG/lyncsdbh6TQriS+/Z/kJv5kT2ohrs1FE4iBSVAiLmoR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyGlLa7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyGlLa7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B70C433C7;
	Tue, 23 Jan 2024 01:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971763;
	bh=PWoxXgIq8WkWCVmYh7CYBmcxvsc4Xo+JF0V//Q6MmSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyGlLa7K24oepkF4357H6FsYFDdgmjNgoIJCeKxAeNKaBOWbetHcEZOFvytAEkXGe
	 BDiX4N+lFN4+CzEDUqgKSIRGc3weeOlO2zK1cfXeTSnI1YMClWvdJMKip+oZeWqyOV
	 9B6lYtHr+tAvE9ho6vtuLyAwcGbyZQE5cJuW0tC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=87a=C4=9Fhan=20Demir?= <caghandemir@marun.edu.tr>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 221/286] ALSA: hda/relatek: Enable Mute LED on HP Laptop 15s-fq2xxx
Date: Mon, 22 Jan 2024 15:58:47 -0800
Message-ID: <20240122235740.583415823@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9034,6 +9034,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f6, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
+	SND_PCI_QUIRK(0x103c, 0x87fe, "HP Laptop 15s-fq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8811, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),


