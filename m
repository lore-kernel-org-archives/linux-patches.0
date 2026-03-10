Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEB3313537;
	Tue, 10 Mar 2026 11:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141126; cv=none; b=EvrwAEOZDzJH+X6CrxMKGEKSqz3mRa4AlM8dieh4HKhIce3qexaLHILr1adfA3foXi+vWO3VNJ8u0VxeHkEyBLkTUuNdTw3erlPWoEY5Ezr4zErHKY8R0d1wDk9Uc2C7g0guO7S1KsAQDkp4d3w5pmRwg2IjLaSZHLuiGQGmb3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141126; c=relaxed/simple;
	bh=KixotNO3tHVkaXGTVgQuLs30oQt8kkicgdz0I8IhN1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gr5t6WYgok+AsGGRN9F4Qp5gLRsvwje5Ebv7DWyCQ+V0GFNvc1TGWbHht6e1eMBMEQotT098JW7cDRgqaoWTRubTdUaWBzSVSHfrGmVmksUdcHQv1p6e1JWY3kdNyIVxmOgbHwgtpNO/WIw38BfODrkyQUq211MNLmcCG4ztfR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qID0KKNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qID0KKNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5C9C19423;
	Tue, 10 Mar 2026 11:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141126;
	bh=KixotNO3tHVkaXGTVgQuLs30oQt8kkicgdz0I8IhN1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qID0KKNvsxtvyE4fROrLXv6O9kVyFexC7+KAI3zF9hR6pjJSXib54BC3fdhV0wggM
	 yzEP95+aJuWEmQo3hN/XbrrxV/Gja5KlaYyeHiS21YygdqqJZlxU6zGg5OknIcesxn
	 5iErAydMOZm64NnVcCS5tCGnMCRrjHsELT6X8TmL5T8e+OV+KNV5IE7iiCalf1cot5
	 dmMlIWEf+YZQqeH4uASPIHsOCwPJzvubmYSZO6QZ7DlESyVxLxLfzMGONJyvfVGmkb
	 XEhJHL3VkVfzLODizoCL3aJ1VOLyeP0Vcw2xBIqgqNs/W+eW0ypjTToG/DJAB5GGKI
	 kF6UrIJFrp7bQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Panagiotis Foliadis <pfoliadis@posteo.net>,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 129/311] ALSA: hda/realtek: Add quirk for Acer Aspire V3-572G
Date: Tue, 10 Mar 2026 07:02:56 -0400
Message-ID: <8f799721adc762ba67ed400b57a4093d09b8172c.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Panagiotis Foliadis <pfoliadis@posteo.net>

commit cbddd303416456db5ceeedaf9e262096f079e861 upstream.

The Acer Aspire V3-572G has a combo jack (ALC283) but the BIOS
sets pin 0x19 to 0x411111f0 (not connected), so the headset mic
is not detected.

Add a quirk to override pin 0x19 as a headset mic and enable
headset mode.

Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221075
Suggested-by: Charalampos Mitrodimas <charmitro@posteo.net>
Signed-off-by: Panagiotis Foliadis <pfoliadis@posteo.net>
Reviewed-by: Charalampos Mitrodimas <charmitro@posteo.net>
Link: https://patch.msgid.link/20260221-fix-detect-mic-v1-1-b6e427b5275d@posteo.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index df5c64b7d1f9e..f77f160504adc 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6591,6 +6591,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
 	SND_PCI_QUIRK(0x1025, 0x080d, "Acer Aspire V5-122P", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x0840, "Acer Aspire E1", ALC269VB_FIXUP_ASPIRE_E1_COEF),
+	SND_PCI_QUIRK(0x1025, 0x0943, "Acer Aspire V3-572G", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x100c, "Acer Aspire E5-574G", ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
-- 
2.51.0

