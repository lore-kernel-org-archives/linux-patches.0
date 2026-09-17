Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C67B3B0586;
	Thu, 17 Sep 2026 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668287; cv=none; b=mamnzD2uCYT8HPnUJOQ1ao8g+2Dz5giaJx/OXHcFVIBynPiNyD+etkO6M1V+G9jzJhJZFWUhm2CGXXEzr+IZM3PEPtrcL02wRq+2dCPyu/k2mqxxxrq4vr2aIwYYkIfzxObP5hwfN66OiCI46CBvp29qcLa0JThCCHmdeZqTu7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668287; c=relaxed/simple;
	bh=1dq8v1l+LLf42YUewmYaig7rExfC0KY26gG896Vz554=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMUEA+mAHD07X6VzZ7/P/AR0yJ2Vd/0qqIUQFE8Gqfjsi/chMMC9E1cZ5d46jeE6qcSv6XBYFD9SnHErBemQBXBZqPghYJy4LNgRVRr/jDalV6lMoMCPcdCD33XmHVSB/+vtNSnO04N2OBDnid9Fr0kLt2o0/Tm9CCcXqRIrSD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGC2XwCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGC2XwCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FA01F000FF;
	Thu, 17 Sep 2026 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668285;
	bh=fsRO9Tx6GQuXj5amRzrF6uM/nPYCL7hqu4cDyg/+6BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGC2XwCspmBMjDEsNlfMHxa8eRC8bzMRHHcCUR7LfvzomCV/0waQsrgNyifH073po
	 8yOBft4S1wc0HTQ9I03sECA9F64I/dMvOinc0FjNJPOyEJzD8ODW+tTNcwDCPYM1Qz
	 va0cCdGSqt5kGVA8BixZfyDFiyTF0X94wmBIT5SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Nayak <shubhamnayak392reborn@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0375/1102] ALSA: hda/realtek: Add quirk for HP Victus 16-e0xxx (88EE) to enable mute LED
Date: Thu, 17 Sep 2026 16:05:18 +0100
Message-ID: <20260917151549.067184812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Shubham Nayak <shubhamnayak392reborn@gmail.com>

[ Upstream commit 6c18817c01f6f76d9e2739903abde4d69397f2c6 ]

The mute LED on the HP Victus 16-e0xxx (board ID 88EE, ALC245 codec)
does not function by default. Add the ALC245_FIXUP_HP_MUTE_LED_COEFBIT
quirk to enable it. Tested on my HP Victus 16-e0xxx with kernel 7.1.2.

Signed-off-by: Shubham Nayak <shubhamnayak392reborn@gmail.com>
Link: https://patch.msgid.link/20260629-hp-victus-16-mute-led-v1-1-ab0f4a8a533b@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1b01c88ed9aad..a03f94a1bcd18 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10943,6 +10943,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x88ee, "HP Victus 16-e0xxx (MB 88EE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



