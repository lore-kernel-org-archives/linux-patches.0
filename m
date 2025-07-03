Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C422E7BB6;
	Thu,  3 Jul 2025 14:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554500; cv=none; b=bmScGmPJdxdhymRsC1BkL8QcG1hF23D4oPLVfbqQ0GbD0Fc1yOUWfPbawg+ewtzhxndLXtbwKL8tY70e1Ixj9+XflE/xZOSW/Q32MqlfPGt3+qOeXjyLkHXNFCgr9r5q4l2+bOuoO1gwNkLAU/ZrsHTtUtJMht3SaB5K7ryr4hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554500; c=relaxed/simple;
	bh=0ZNedpu9aeENyeEqy+z9lN8hrpKPGoad/cZ0o0XVAYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFlHyiwQLw6aYEMY1eBsSfnACesq1svhzzJcpMKfyxb7XxVh0i5H+lhZtgLNJYS6wVsJWQoLNLJuYz200uGc3TfFGnqMyxrEfvpfI+Atjrfx2jBlHEo8AHhOQYiIR2Bxb7YrHRtOYdiJuhYsAiVoEwq1CbSwOdnboTQIu/8GO5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAQSVR9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAQSVR9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148B8C4CEE3;
	Thu,  3 Jul 2025 14:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554500;
	bh=0ZNedpu9aeENyeEqy+z9lN8hrpKPGoad/cZ0o0XVAYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAQSVR9T+/PGeiKjCEi9MCXBDZs2/0JRawFuz8k/RdOlHI9Qy1GHipU3S3udl41gR
	 8986C4ccG71ekXW4IfnQvvmtFhRaXTR9UKtnYkT8PlXXBrgKHx9OgTiYwl5c2pX01E
	 2g7+aoonwAlnzppJIHzYP4ArrWIyAV4/8IzJjpdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andres Traumann <andres.traumann.01@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/218] ALSA: hda/realtek: Bass speaker fixup for ASUS UM5606KA
Date: Thu,  3 Jul 2025 16:42:36 +0200
Message-ID: <20250703144004.535367227@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andres Traumann <andres.traumann.01@gmail.com>

[ Upstream commit be8cd366beb80c709adbc7688ee72750f5aee3ff ]

This patch applies the ALC294 bass speaker fixup (ALC294_FIXUP_BASS_SPEAKER_15),
previously introduced in commit a7df7f909cec ("ALSA: hda: improve bass
speaker support for ASUS Zenbook UM5606WA"), to the ASUS Zenbook UM5606KA.
This hardware configuration matches ASUS Zenbook UM5606WA, where DAC NID
0x06 was removed from the bass speaker (NID 0x15), routing both speaker
pins to DAC NID 0x03.

This resolves the bass speaker routing issue, ensuring correct audio
output on ASUS UM5606KA.

Signed-off-by: Andres Traumann <andres.traumann.01@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250325102535.8172-1-andres.traumann.01@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 94c5151c456d6..30e9e26c5b2a7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10859,6 +10859,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1204, "ASUS Strix G615JHR_JMR_JPR", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x1214, "ASUS Strix G615LH_LM_LP", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x125e, "ASUS Q524UQK", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x1264, "ASUS UM5606KA", ALC294_FIXUP_BASS_SPEAKER_15),
 	SND_PCI_QUIRK(0x1043, 0x1271, "ASUS X430UN", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1290, "ASUS X441SA", ALC233_FIXUP_EAPD_COEF_AND_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1294, "ASUS B3405CVA", ALC245_FIXUP_CS35L41_SPI_2),
-- 
2.39.5



