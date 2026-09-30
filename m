Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C4B2DEA95;
	Wed, 30 Sep 2026 18:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794408; cv=none; b=b0Qg0N+xKUPWbPbQhBOSMfa9/1Ieve/u7/rNPTk3kOHrmwrW7OAdAbmR3QZMttUDVpkCjFUaJZRBmY1ZGEIiqJqYkGdunVSBmbr+W/TLktmnLcOAslh486/rmnH39rJEHNrfZFIsaz6Ozqp8xvtpjwjyYHUZpxT/d44jWTypXQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794408; c=relaxed/simple;
	bh=VXUgj/xGblW2r3+WDEix9+C0Ro+OorQiIksa2hnokas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8V/EwHTSA0Z07HrcSfCQrgq7/f8Dq20vUEZ+ONw1WjPU4DP9u2TF2wrd/1GkWPKXQogX9m605jf4ye9OSQtM0aTPUr2E/1pWj/KORfVgYIRT89QGR+NdTHBrihZbSYwkNbDYA+9FgRiHLnbZkmlY73rdG9aMz6meiPkGXvWbho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rw7Dkk4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rw7Dkk4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10491F00898;
	Wed, 30 Sep 2026 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794407;
	bh=rRp+9dMHcBC7cjdobB+IK6UYeYkppuGXxFpmr2Gr69I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rw7Dkk4LWs/i5fF9jhN1KwqXdH1yrHDmtAYnBAhji/g6luGFrXHc13q7ABIn+AkUO
	 jIo6QFJoqdeNCipUIHQJFZG6iKfGE9jLOdE1TSAIPTyG9zZYx4wRw4qf8b3DDzNpHM
	 0WFe6BdIJ+Ww+IPNM5V9EYvsnqnX3b+0/oL3RWks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furst Blumier <seal@furst.blue>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0201/1193] ALSA: hda/realtek: Add quirk for HP 255 15.6 inch G9 Notebook PC
Date: Wed, 30 Sep 2026 17:14:45 +0200
Message-ID: <20260930152438.674052505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Furst Blumier <seal@furst.blue>

[ Upstream commit 98e157916f83c26a41448267180944048d2f1460 ]

The HP 255 15.6 inch G9 Notebook PC (PCI SSID 103c:8a1b) uses the
ALC236 codec but lacks an entry in the quirk table, causing the kernel
to fall back to a null SSID match (103c:0000) and skip the necessary
fixup. Add a quirk entry using ALC236_FIXUP_HP_MUTE_LED_COEFBIT2,
matching the HP 255 G8 which uses the same codec and fixup. This fixes
the mute-button LED and fixes an issue with unplugging and replugging a
headset jack not being recognized as an audio sink.

Signed-off-by: Furst Blumier <seal@furst.blue>
Link: https://patch.msgid.link/20260609201706.502075-1-seal@furst.blue
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index caf5347406cdd..855c9cb15aa4f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10177,6 +10177,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a1b, "HP 255 15.6 inch G9 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
-- 
2.53.0



