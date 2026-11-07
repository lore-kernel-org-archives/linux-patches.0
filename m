Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061104;
	b=5duMbMh1R8EPel0E1eE6magv3agkqdTcsmDjMJ8O5le2t7FWp7xIRRQ1C2HeohOd5q4P
	 VNYtIV9pHCn1uORvGO9q/PW37HjZ45ALN8LpiF+GqL/qYffi+1xK7IUQ/fMyqbX19ZWYF
	 lrTcGoEeVgxnj+ZloHE1KcMkAvYL5lmvWZhSgNLGdYzZQTtzk+YV4IeacI34xWXD9dQmV
	 l+/oyJ3bcwT4Akpyo/vxULtcf5xct5izUEBMZ2xDP195Ec0iQP2vqRhmgKYPOt+mGF4Us
	 IMDfE34wSYTpuiIOTesUsrSmPzVdxLMRiAEhbP5NbQopvulYSSDldDdUYWKFawhsm+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7pzD4IvOoSjhso1VjTiNqQH1VQGFiwhiQfAg07u2iqE=;
	b=w3QBPBTgjbbT9wXmDF1KaXO5I0kKCq8k46Cn47nmp6PaK2ktNbqbjGHKrw7Uje5IElG5
	 Z3e7cedhC+0yLv4sF07J9SvQ6htbnp281oYaK6JsOgcweZAsQ9sia7wOySRPuQulq1dnr
	 4s05QaQ7xgPqrXwpNwYKKd07lBfMlDe6IEL1b3pwgb1j9Eia/9sEpBDuDKGsF3vGEfXvr
	 LJ7DHdwFqtPJ1nUDdl0DcGu0jpmLqKPZk51u5Aij7tzhtY4UVsa60MYBW4x9P5irCkuhh
	 rN+uszB19fFTBfbxXgKsVmyuwCYWZRLza9payEcqbaiDA7+O28QZ9EEAust7bFkIvpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJq9nQoy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C48606A32D;
	Sat,  7 Nov 2026 14:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJq9nQoy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366071F008A2;
	Sat,  7 Nov 2026 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061104;
	bh=7pzD4IvOoSjhso1VjTiNqQH1VQGFiwhiQfAg07u2iqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJq9nQoy9ap+7eTeeECnqYG8+ORKD3rpd1bhjlaQf0RbqeDE/qtHoLDqpPzp4NohD
	 NanWodAyM5o2RGz8HWRx/DWnG9qQLKTtQY6rVMa5A+vnFBLy934pU72Juhvl7yXaEG
	 qlZvsNUCP0ueAABnowhZHANDv4jq+N3jpGZyzUjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0423/1536] ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H
Date: Sat,  7 Nov 2026 08:40:39 -0500
Message-ID: <20261107135009.453451639@linuxfoundation.org>
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

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit 9a44b828dd7c0be1d0d6d6cf178d9727ceb6da6e ]

Fix headphone jack detection for some devices

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20261001183403.103990-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 30758dbca8ced..4a471dd67662a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11714,6 +11714,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
+	SND_PCI_QUIRK(0x1849, 0x6256, "ASRock NUC Box 358H", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1854, 0x0440, "LG CQ6", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x1854, 0x0441, "LG CQ6 AIO", ALC256_FIXUP_HEADPHONE_AMP_VOL),
-- 
2.53.0



