Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6614E73A1;
	Thu, 17 Sep 2026 18:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668107; cv=none; b=YE1Jh3ZFe0LDWoZG86C03d53q4fsjZzSSNKvjq1IsMr0PLT4V8Ve0AGJWZwHHay+cyHIEzOWHN/tuuVn9qLOLeyXzRhaejVdgKXix4PVqfjffGDXKQYiVwT+4Lx/MFwrKxH7H1NTaFiNDd+Mivp96xzBXkkU0Znb2PAQej3yezg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668107; c=relaxed/simple;
	bh=GIfllvyOawjsCqBVGQkjmy3gG72oijiHBt2k6WY2pi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdtPWoIGJC4I37uC/UV6bZ/kKXKRz884RRBaZV4X2sNnHdQ2YVwnWQNMEbkz4jowHfUNOI2Exdf17fig3N8+5cU2uA3K8RVQ8O40JVB4OwC8RRf4x8lhvm/CgkL9peS7Pv7c8SHZST1tPtHHn0yXmZf+fnf+q/woRfV6DQX3rQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJxCoQbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJxCoQbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6473D1F00893;
	Thu, 17 Sep 2026 18:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668105;
	bh=P64en3iBWo/0vrdny9ewus54K25TzfXME/jP4/6qokc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJxCoQbziJLbNVtlItbj9Jjvlvt20rUybZjKi3wSv3OtvSfWAPMlrH0gLCB88681k
	 WJHnXiXZCBGi5Kg+7Tr1eP4c8isGhN0YFD6j8xgkjUgMpR9eGKTQbHMyN7F3ZOozDk
	 ZQuEdZZ5Mta3rcfgLbtZ1jR+7XaNHfrmTAG27g78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Menshin <ripeeerr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0314/1102] ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin 14 GT
Date: Thu, 17 Sep 2026 16:04:17 +0100
Message-ID: <20260917151547.506011099@linuxfoundation.org>
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

From: Viktor Menshin <ripeeerr@gmail.com>

[ Upstream commit 3a3e810e91080a5121170ee11554a55ed89a1c8b ]

The Lenovo Xiaoxin 14 GT (Chinese market model, AMD Ryzen AI 9 365)
produces constant electrical hissing and crackling noise from both
internal speakers and 3.5mm headphone jack during audio playback.
Audio works correctly on Windows.

The PCI SSID 17aa:3912 is not present in the quirk list. The device
shares the same AMD platform and ALC287 codec as neighboring Lenovo
14" AMD models (17aa:3911, 17aa:390d), so apply the same fixup.

Note: the fixup selection is based on similarity with neighboring
models and has not been verified by testing a compiled kernel.
Guidance from maintainers on the correct fixup is welcome.

Signed-off-by: Viktor Menshin <ripeeerr@gmail.com>
Link: https://patch.msgid.link/20260615092515.1082-1-ripeeerr@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index cce7e2e5f6e67..5978ea4bb3b85 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11588,6 +11588,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3912, "Lenovo Xiaoxin 14 GT", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_TAS2781_I2C),
-- 
2.53.0



