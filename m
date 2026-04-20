Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F29C33AD9A;
	Mon, 20 Apr 2026 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700657; cv=none; b=d8KPfmtMXPR4m+K9uzQYfm5k8jMBW629mR6FTLh6M3T7Au7RHb2A8woee0WDKyisqx9vwoxXGq7uY/2bGZQKI3Xhx4jWHi5vgJQhbTKsPSVn8GJ8rbRteEEbmIJ+DzSRarh92kgpvW3qQpP1+GESKGRqpF+Z26Oq/akuKgoeakQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700657; c=relaxed/simple;
	bh=j9YH13FvaPsJUGpEUWwgRO49jUXjqo1Kb0l/RTIgEqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9Q6sq5mPPp2FY9HVVqQD7xs99aVIZkz3TNQK03q8smgSPCwtrNvYolLb+pxHWTMxSOgNSOS45LznlYSUJbUNyoiol0zFhJ+3wTcoDWCkyytvZdqM5HKUrQS/G3d53pQvHow733FBRgaIjuYYc7QvkuHanWpGJOQ9ORkinhtHE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/L8uEKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/L8uEKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6632C19425;
	Mon, 20 Apr 2026 15:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700657;
	bh=j9YH13FvaPsJUGpEUWwgRO49jUXjqo1Kb0l/RTIgEqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/L8uEKKBzp3aKlDWmUF4Y4BXHbEr0E6TXWYFQvR3/qjIw5MthpQfJaoi6wPiR0RW
	 734zIzOrCQkDFB5wNAZHA6gEKUc9tgNy1km5jBIOAPZUZ6S1JeOLqaMf+wKJ3wHHrc
	 4kzgIrZJkv/6NmDmXphDBeEWurgEQre4OO4GehmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/198] ALSA: hda/realtek: add quirk for Lenovo Yoga 7 2-in-1 16AKP10
Date: Mon, 20 Apr 2026 17:39:44 +0200
Message-ID: <20260420153935.805495978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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



