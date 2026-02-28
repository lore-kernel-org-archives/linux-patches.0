Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9AC340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301046; cv=none; b=o3+puhJMuJuUp1J9oJ4xrtGx35niuzxoCY8TFV9M9ydBGAhZ60TO7VeWHfLi7tsxOEHi2A2rfE8h+HnU1ZJFfRtHnUk4CziIFK3cFnpqjLzpYomAAxiMn+6226OVvTflNpKPOkUSHZ1gIsKD4aEB6sNJBUz/RR2lovfzt2GLFH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301046; c=relaxed/simple;
	bh=ihM/50EQk5ZYXzXdh2AxqEuLIbEdjM8Y4qOk8e9bSf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXwge9yVDY8ks9A4uVjjH5bIrsZc2txYiAvp4IVBWFzlPZ1/37vck7FelbHErEVmQsEZPfYLQN3isQ1bJkqyS+y9jekoqJ0wOlKN5BzKhMl+U3z+6YTOySAKzn9yHm+O9AkcZsPZzDCL+d+GwmS3eJm0wN6RiM2bZadr392fCt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZvnnnKL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvnnnKL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04E4C19423;
	Sat, 28 Feb 2026 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301046;
	bh=ihM/50EQk5ZYXzXdh2AxqEuLIbEdjM8Y4qOk8e9bSf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvnnnKL4U5uCHgAMHT+tP5pZ0Bhqz/NPgG1eK7oRhgItoZMhUAkFQNKMzYaeTaCb1
	 bB3pRsSjyU5UV/Vs73GwLK1vym8bWOgVwTbbFXbZsuYC3K7Cd+S5yBJPRoGwVoeZNl
	 5zOrF1NwoApi+xrMBI9T53pBYKyWG9is8Be8KKkAwsJ+EtHt1hmyp8MmNzY8JA4Kk3
	 sUIue9obXTQZqWbL13uYI/dbqQqiqPBxIv1AS73EGZwJby1lSYtkVo616BLVpyzde+
	 4dCyc3LZbnYHuZA+MGL+Ue0zC+zubqDsv8p57dLzPMHyKikOrZ6+sT1WGrVrd+qy+0
	 LJQKhc9oqMAFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: gongqi <550230171hxy@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 185/752] ALSA: hda/conexant: Add headset mic fix for MECHREVO Wujie 15X Pro
Date: Sat, 28 Feb 2026 12:38:16 -0500
Message-ID: <20260228174750.1542406-185-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: gongqi <550230171hxy@gmail.com>

[ Upstream commit f2581ea2d9f30844c437e348a462027ea25c12e9 ]

The headset microphone on the MECHREVO Wujie 15X Pro requires the
CXT_FIXUP_HEADSET_MIC quirk to function properly. Add the PCI SSID
(0x1d05:0x3012) to the quirk table.

Signed-off-by: gongqi <550230171hxy@gmail.com>
Link: https://patch.msgid.link/20260122155501.376199-5-550230171hxy@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index 0c517378a6d28..f71123a475464 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -1134,6 +1134,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad/Ideapad", CXT_FIXUP_LENOVO_XPAD_ACPI),
 	SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004", CXT_PINCFG_LEMOTE_A1004),
 	SND_PCI_QUIRK(0x1c06, 0x2012, "Lemote A1205", CXT_PINCFG_LEMOTE_A1205),
+	SND_PCI_QUIRK(0x1d05, 0x3012, "MECHREVO Wujie 15X Pro", CXT_FIXUP_HEADSET_MIC),
 	HDA_CODEC_QUIRK(0x2782, 0x12c3, "Sirius Gen1", CXT_PINCFG_TOP_SPEAKER),
 	HDA_CODEC_QUIRK(0x2782, 0x12c5, "Sirius Gen2", CXT_PINCFG_TOP_SPEAKER),
 	{}
-- 
2.51.0

