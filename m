Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C720D3368B2;
	Mon, 20 Apr 2026 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700075; cv=none; b=h/0JerPlxeXCoeiP2AduZzjQR8Hbo6NtIGRJhIaEBihDhkaj56ceHsA6KbjheVD4nc4Nc77WhZLo8GJbNNPZbod6JFA7kQxt9ueWrk0F3w1+VIE7+vUXHBNMqJ0zq4mrEPRbGuKIFoOX8O6ecMcjIuv+YKyY6aMcqrD3thstxIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700075; c=relaxed/simple;
	bh=dhn8UXs3OgH3IpS4AOyFaQuKLj7r9zOIeKhejY1ow2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faolq60YhVLtRVQ0gUWCGN/qFiIj5qHJI6JGJHrCO65dclJl1EBZ+WwwSR3RagGHafUIVdEFpnaI095wYjdHygdG30aqAqdPmGUfuE2PUtPcmsNiU1x3CJUpuKKV1BPQen43iTKcrvXzJKB2YY1GUFplW6Aqjwl7pK7TYJ25bv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtsdxLfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtsdxLfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBF0C19425;
	Mon, 20 Apr 2026 15:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700075;
	bh=dhn8UXs3OgH3IpS4AOyFaQuKLj7r9zOIeKhejY1ow2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtsdxLfuYsfvX+MrNczOWWd9NERhefCGqoovnEAe6GJSqixnA0b0Zw/jUVHu70OZT
	 FBw1MvcgW/2wGRAkFPIDhrZqIeng7Uzpr3BYxNKSdnGJeEHLBCkogAtL50u7/WC1zH
	 1LnqkO6Hpng3bkoDU42NPXF2vsmEc6rwcDu6DsRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Garcicasti <andresgarciacastilla@gmail.com>,
	songxiebing <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 031/220] ALSA: hda/realtek: Add quirk for Lenovo Yoga Slim 7 14AKP10
Date: Mon, 20 Apr 2026 17:39:32 +0200
Message-ID: <20260420153935.151754742@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: songxiebing <songxiebing@kylinos.cn>

[ Upstream commit e6c888202297eca21860b669edb74fc600e679d9 ]

The Pin Complex 0x17 (bass/woofer speakers) is incorrectly reported as
unconnected in the BIOS (pin default 0x411111f0 = N/A). This causes the
kernel to configure speaker_outs=0, meaning only the tweeters (pin 0x14)
are used. The result is very low, tinny audio with no bass.

The existing quirk ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN (already present
in patch_realtek.c for SSID 0x17aa3801) fixes the issue completely.

Reported-by: Garcicasti <andresgarciacastilla@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221298
Signed-off-by: songxiebing <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260331033650.285601-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 61ca80ff3757b..edbac69d3d99d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7668,6 +7668,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
+	SND_PCI_QUIRK(0x17aa, 0x391a, "Lenovo Yoga Slim 7 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3929, "Thinkbook 13x Gen 5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
-- 
2.53.0



