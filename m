Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E5E51CF6A;
	Wed, 30 Sep 2026 18:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792796; cv=none; b=R9EXol8n70roq7a1xZa2Zq2Za0a3Ia38wjALui0RDIOXletFq8vaN+9rCIZqF++qpi0P3yWr6Ux4WgsrSdXMgcG37KPVKEic2XN2Agg/lBoI24w30SudpdANB9m7IClbf6U/waONz38oG8yfxOduL9n+45p+9nBNB0WjiSQj+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792796; c=relaxed/simple;
	bh=heVCQaqwXWY4FFMvsaSzD5wa06YPyYFnoPFP0AbxDD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B37sAUHgf75d+GvcvkLIvdyoBfOwcEmlJ7SC63/RDuo48+T9CORudUysSoSOcNEHUmfa6c16w+6Keapbwcm+dBN/gWLC4hsHrkY33Y7GYXfK2V+F0T5tTDQi2uAjD+Gu3G5OpNp8+Rmdc14HrQKAl1Ee4HH+6Ogq7juDorACggA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKf6+UtX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKf6+UtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A47A1F000FF;
	Wed, 30 Sep 2026 18:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792794;
	bh=4EzrojWRo7yKhBfl4fSqXva2Qa80wdLATa1UAiiVGyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKf6+UtXVCGInwLjNL6J3G4CALuh3GAnw4Z0rDGsTPXKjr8sfBimBGq8QHzgiFajD
	 WOXl4YS6z7m+10MKDvPblvF5a5FPXOUQ+eswftke6a7PEsOF4p3ggiG9yprT6mZlFt
	 WORIfZ5qt8XYkkAp9U9rgNOjTTOSvDuPQEED2RoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Rhodes <sean@starlabs.systems>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/395] ALSA: hda/realtek: Add StarFighter HDA SSID
Date: Wed, 30 Sep 2026 17:24:27 +0200
Message-ID: <20260930152340.720068385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit cd401c70df472d3eddd0b6b055726a03c212181a ]

Support the new StarFighter HDA SSID while keeping the existing SSID chained to the same quirk until the new match reaches backports.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/06865eaedf3de8dff199e9aa7e86cd135572f20f.1785532385.git.sean@starlabs.systems
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 5cc6c2d64e1af..681cdb00a11d3 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6475,6 +6475,8 @@ static const struct hda_fixup alc269_fixups[] = {
 	[ALC233_FIXUP_STARLABS_STARFIGHTER] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_fixup_starlabs_starfighter,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_STARLABS_LIMIT_INT_MIC_BOOST,
 	},
 	[ALC294_FIXUP_BASS_SPEAKER_15] = {
 		.type = HDA_FIXUP_FUNC,
@@ -7624,6 +7626,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0x2145, 0x0001, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
-- 
2.53.0



