Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573ED539797;
	Thu, 17 Sep 2026 17:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664583; cv=none; b=vFAYh82F31SICFUqHxcnHAazJk4rqHCvDD/LzJ0UzQKxCTKpJ+Zm122zTCKe8zdQwlIxwfe43UwGoDlxJevVNUEWlIjusVJ6avEItt4A/9PwgtlRXOFx6nWHoYigZQ8Qa1ZgrZz3EuS9oEgtDLiSw51TsPI3subA169RM1L0b8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664583; c=relaxed/simple;
	bh=ZEiS01/60rP8TDqx3O3hHcRrbtIkNM4nT1ZYS4J2jiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apF3rfwO3ktaj94L73jxsTFWfMRJnpXHGad6OqBqcg/gauq41tW/W74+FewugPRhEtyO7tOdZ5S7kv4IdkcVJUJQ6O8pHuq1fNGgeon03mcEYLcoFpQXpxEs/LvCtKIXJQD+QOmlCMc9hUDbJWDmJnZKjvIHcYDrzVbkW8kLS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klntWBLh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klntWBLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7F81F000FF;
	Thu, 17 Sep 2026 17:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664582;
	bh=C3fRbienXHuJ8Ao8pDnONqC5eQkYqBgifVDERkUalys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klntWBLh1VM7ppDxon2f7X+hiqIzkpH99gCEfs23RFTIUTF5KKZLUhoxw4/CUU5fE
	 hdvViJXBWZx3rFGZfXdz/TzVyZX/1NKoTOdNoLw11lQVcZQ4wa23GDeoYeNDO1hAPv
	 kY3ycPqnfgYil6trQdNUrza14QrZjIRCVaKTh8wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Menshin <ripeeerr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0419/1250] ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin 14 GT
Date: Thu, 17 Sep 2026 16:03:34 +0100
Message-ID: <20260917151603.377290039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a634f1c1ca4b8..2843171e9c718 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7508,6 +7508,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3912, "Lenovo Xiaoxin 14 GT", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_TXNW2781_I2C),
-- 
2.53.0



