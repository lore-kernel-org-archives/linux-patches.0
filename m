Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061059;
	b=F3sAO8AdT0tCOqa87hFtdNMrEGnSJiAmQiiUoIhwZsTCTzqbaRPXYdmbZyrvH+KyPxUR
	 ZT1dpR4KuUNmWQjp9zcI/iUuiJXHf9YnLqsojwOw5htMA9y9tqBjDaRR7f7uZENygLkmK
	 TfZRW4OlompjBLpgjrY3u4DWPHDb2pcvX7ijUtTNZv+tlgxanvOkxMhGijwiIUFGsm3at
	 sucPXYPv2ZR76N+KMwKvmjjeYVOPwyPwLv/NRoMgjlbwcnvCLtjCRWBK72DIiXkvulpnD
	 AFxBnQGOscpi0piKmyf1szg4dkkRWrA5NEzbrUrXU0FN6Q4QzrQ/225pzwMAeqlZBRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7VBWuZY7BaBCEqTvdhL7fAbEeIY0zvFQyIR2Pdj79Gg=;
	b=gNDo4q8ytfOWq5DGJroZ0Ue3BcsnbU+gIsi3/cek+hasQwPHv2Fx932JMH+oHFZaL0Q/
	 DHIhDzQMkb3c7Z5Kbxsrdho3kq42HjsQP0wLFsCMTfJQBel/0Mvn0aK4/favjYz9Djkmq
	 IPx34kGiIvS3KyMdQG7zG6Ze9rCLMC1eTjkqXNnd/AMW7A5+/aK2f7HR9y3cMX3MsWN3G
	 +vMU00vIuaQVy0NzkOpeoDceCGsk1o+m6MrHixrtGiWSljo7JnxzC5cvsR78hUgBghHTl
	 3LAh5cSW5dto2YvFh6BqGN6NyPg5gD5fagBQbnXSu5J0V+b/+lYhnS/TMjHtBR7Vhfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eyv54SZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19E16082BC0;
	Sat,  7 Nov 2026 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eyv54SZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6211F0089F;
	Sat,  7 Nov 2026 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061059;
	bh=7VBWuZY7BaBCEqTvdhL7fAbEeIY0zvFQyIR2Pdj79Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eyv54SZCx9+sOg6jbr+XFK12B0VrjmwZzqAQtFF693UHmVGtf7thLNg0ezowogHvt
	 6/marBr6unzmHeNAuRfm70Kw4SAI0GRstB8Ysh+WMoHD1MfVfad/za9QZfIM3y6S/U
	 wVKC/dqs/+TH58UkeK+fBj9OmJ8pEZlz4yWUv0tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0389/1536] ALSA: hda/realtek: Add quirk for Lenovo IdeaPad Slim 3 15ABR8
Date: Sat,  7 Nov 2026 08:40:05 -0500
Message-ID: <20261107135008.532458460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit be79a45e2ec289eb9fad519e8f5a3d4fc3789dd0 ]

The internal microphone on Lenovo IdeaPad Slim 3 15ABR8 (subsystem
17aa:3862) exhibits severe distortion at default gain levels. The
Capture Volume is fixed at 63 (max) and cannot be lowered without
explicit userspace intervention. The existing fixup
ALC269_FIXUP_LIMIT_INT_MIC_BOOST limits the gain range and resolves
the issue.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221891
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260824123752.525173-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index cb8f063345efa..e25664efd9c15 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11599,6 +11599,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
+	SND_PCI_QUIRK(0x17aa, 0x3862, "Lenovo IdeaPad Slim 3 15ABR8", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-- 
2.53.0



