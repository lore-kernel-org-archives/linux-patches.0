Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEF933C532;
	Mon, 20 Apr 2026 13:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690942; cv=none; b=sXspeals/LXifgDS006JiCu0iPas7Vr4XoVWx0sMwN5chleJHMOJFOXmTdn1/j2XFl3UM0wSCLMAI13EwFomMhkyzCiDnpOem4b2zV8C0AhwrNLMQWUv1we98x6OcKr5I63wCWXpt8RrgtJZVqCpcDt8cVm4Zuz6HYwT09nU1Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690942; c=relaxed/simple;
	bh=IJRaeUrOT4uxjtqct0t5ecqTdc2mzEjDLrfsy60+b04=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fEcu8G7ASU6FWqgdZJEDu7Rk7SD1Nw9Aa6heQ2gEpVufRecbVvMY0vjUVUrd2SnoYbRTwP4z6IW+c2VRK3ZRdmnxLusXKohY5m3wSz3eW7CGfvR8tsAfuujrU8kziDIkOkbdN3bcD7BQ/4ixtjw18KBm+e1xtFInKujFvChLilA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A66MNC5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A66MNC5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F1EC19425;
	Mon, 20 Apr 2026 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690941;
	bh=IJRaeUrOT4uxjtqct0t5ecqTdc2mzEjDLrfsy60+b04=;
	h=From:To:Cc:Subject:Date:From;
	b=A66MNC5uAmJo3ESN/UeRL5KYSrrJpUPBO/M+Op3676M/ng2lvo8t2qFXCla795G2D
	 8HgKXSnWg3CGDnvkb70/8J4XloUsFNTNyFeTuFuTTp8wYKtT7tW2c20O/rngGiqaj+
	 JC91iMAwm9PDGSkytJkyke6ZcEmK74VeUKcY1/PMFWWgH9vvk/5ztztz1WmBMUl3/Z
	 E16Tx3c7epPg1edgsp2CbYrdVSj2+MeUUgYf2oNCuIo+J0NzmjmHxEahGAO/57z8PR
	 ftgmv52tjYom+x2DuiWV2IGQuZbK7vHk8R4Iz/RKYG3JaMyPKs5W8BNWd+OqyYcDEd
	 HUVoDdBgyrUmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: add quirk for Lenovo Yoga 7 2-in-1 16AKP10
Date: Mon, 20 Apr 2026 09:07:47 -0400
Message-ID: <20260420131539.986432-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 7bae956cac0433c4d41aac9f1d04e42694e0b706 ]

This machine is equipped with ALC287 and requires the quirk
ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN to fix the issue
where the bass speakers are not configured and the speaker
volume cannot be controlled.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221210
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260313080624.1395362-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1b64292220ac8..4b06cb48252e2 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7429,6 +7429,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38ab, "Thinkbook 16P", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38b4, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
 	HDA_CODEC_QUIRK(0x17aa, 0x391c, "Lenovo Yoga 7 2-in-1 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	HDA_CODEC_QUIRK(0x17aa, 0x391d, "Lenovo Yoga 7 2-in-1 16AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38b5, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38b6, "Legion Slim 7 16APH8", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38b7, "Legion Slim 7 16APH8", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0

