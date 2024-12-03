Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A8A1EE00B;
	Tue,  3 Dec 2024 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242589; cv=none; b=FqXzBC0c8WHY36FhuOm8GF+uCp/4yqwzezRvptrZzy5OBYr6xwPrrkH7lP9l6c5Yh1Zlxa/Aa652ody/ayQNiutP7ZApKV+rqeby307vK09HbotRBE1grfru3qHcOjDK1uyvgTaIifEkT4drxm/oVDCeLnrnn5ivH3rok27bxh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242589; c=relaxed/simple;
	bh=HtuylQtVbhRKCwVbkXXh8MCLGZfqEqV7XD598rRHtsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXUkKQAenHonbBzorLEB8TUpHuS5fh/OLO8YhRkY8lhrYQN7tyctTvkrU+02456HO1Nn9ygtXr/JxrWnQ7/nSlIoY9a46eGBuW2m07doro7JW9Z5pw/4rNadqwFtS0lBVErsh1fatYWJWv6pLVq8xSSe/OpfbbwkW58suYUZvjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBL8ykE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBL8ykE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434A1C4CECF;
	Tue,  3 Dec 2024 16:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242589;
	bh=HtuylQtVbhRKCwVbkXXh8MCLGZfqEqV7XD598rRHtsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBL8ykE/fTjOpKnC+Avbo+o9E5breqn1EN9oE19Jak5m0+OB8B55cHYUDtcjIPu7a
	 vi5Jiymr2+0T99WyYrEhFhl8Vd4dj9UWYbxZ09VlmSNiJ6q+LBxaBPWnmr5rLb1IrY
	 8TZBxDigw/okxUPguP85324SmihRQveHootF4+uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 748/826] ALSA: hda/realtek: Apply quirk for Medion E15433
Date: Tue,  3 Dec 2024 15:47:55 +0100
Message-ID: <20241203144812.943559894@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ca0f79f0286046f6a91c099dc941cf7afae198d6 upstream.

Medion E15433 laptop wich ALC269VC (SSID 2782:1705) needs the same
workaround for the missing speaker as another model.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1233298
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241128072646.15659-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11034,6 +11034,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
+	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),


