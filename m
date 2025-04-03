Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FA524E000;
	Thu,  3 Apr 2025 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693963; cv=none; b=H66m8R/jfMChmYaygveL8vTafJ2Nbxl9/f5NcABfNxOMg831j0t5pMT22U6/Ecc0CWJNg+emZTUNJk4uNU0oS2uVqslpWkM3drQN1Xdh/uzGfp1BU2izUQEh49X4uMTc9Ud397Mv3Oov+bcCx5jL7bqmmfBwVzvb3escHISHvq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693963; c=relaxed/simple;
	bh=dzOPjfDcIel5JaMn8kJE0HBJ3uaM5/9qhymEx8CXYh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZCLeYz1p01f6ij4JSkycZyeGNfn0LRhMbZsSp0/+1U4whueQw8dugxeaJvWd2Kxatj+Ji5K7K4D5F5DmCMZ4ii5FdZwlQUaTU8f5Zr/9Dj5rMCB43e/4O4opQQaT3oMsb/P5fmzsc5KbsIDclxVhUTpapaLOSeO4SAGT/tzldM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XD+VVe/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XD+VVe/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32E7C4CEE3;
	Thu,  3 Apr 2025 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693963;
	bh=dzOPjfDcIel5JaMn8kJE0HBJ3uaM5/9qhymEx8CXYh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XD+VVe/zfsNFSQQ5mC37Likdd0qeSu4d7+NCkKjtv0IHzaip6cdp05ndG8XmPBhQI
	 RoTj3hoeMHoLq+L4G14zq7vsZew1h0Zm+eGMbRsUcWVhXQsSe3ArapsQ8WOfYlN+AB
	 rOPSmffntYJcO5td6xgg0/F23t8FfuwR8qVTgyIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruv Deshpande <dhrv.d@proton.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 07/23] ALSA: hda/realtek: Support mute LED on HP Laptop 15s-du3xxx
Date: Thu,  3 Apr 2025 16:20:24 +0100
Message-ID: <20250403151622.487250541@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
References: <20250403151622.273788569@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhruv Deshpande <dhrv.d@proton.me>

commit 35ef1c79d2e09e9e5a66e28a66fe0df4368b0f3d upstream.

The mute LED on this HP laptop uses ALC236 and requires a quirk to function.
This patch enables the existing quirk for the device.

Tested on my laptop and the LED behaviour works as intended.

Cc: stable@vger.kernel.org
Signed-off-by: Dhruv Deshpande <dhrv.d@proton.me>
Link: https://patch.msgid.link/20250317085621.45056-1-dhrv.d@proton.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10472,6 +10472,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8811, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x8812, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x881d, "HP 250 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x881e, "HP Laptop 15s-du3xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8846, "HP EliteBook 850 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8847, "HP EliteBook x360 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884b, "HP EliteBook 840 Aero G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),


