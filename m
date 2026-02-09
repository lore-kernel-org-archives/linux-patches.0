Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B8D37A48A;
	Mon,  9 Feb 2026 14:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647447; cv=none; b=ip3J0KpQj1uh/w1frHsYJDwChCkcrqbkKa/S6fjqmXSVQb/dSyXqfNuNaBFy3XmhWT+kj8oy2OiFLrd80VFLzOYuaoBDQ/g6fswjV37gosE5CNacG3vvz5fl3mT4MjeKGDIJsga1qS9AQ1rK9VwZ4r9Es/5zNOpn/XAo/690cOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647447; c=relaxed/simple;
	bh=5l8WVaqnf1DjWiusG2wi1SA3Q2Uo4g8K7cb6hogHrSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ox/X7b/3tQC89mCG5icK/7BrKYJu4bZyZoHM0wW4luWzftWBvkDz8gAhoriSY1L2/D6JG1+PVHWp5rmxA/95e9F35dN7yEw/cTTH1Ycm1hknYEraoy4nZdb8ejkNbEYfWLyYxMT1BjqkgBBpqIIMB/MOxG7Yd9l6ASKS9iPPVZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O66Svi+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O66Svi+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840A0C19424;
	Mon,  9 Feb 2026 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647446;
	bh=5l8WVaqnf1DjWiusG2wi1SA3Q2Uo4g8K7cb6hogHrSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O66Svi+9Mv+uTHc1bnuVhVfE99S5LzbNF1Ju8X11lGLkL3JTbaT8jbMuYx8o+tu/E
	 IhcX05daAkbdLp1oke1AoECAteeT8dyYOS1cM1TaMwAQ9Uf3f3xV1Z0V38Oh8AW6zY
	 Gg46/iBPbWobZ8R0T93OnJSu1JG9ZhMEc+KFlw2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/175] ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU
Date: Mon,  9 Feb 2026 15:22:56 +0100
Message-ID: <20260209142324.122718862@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>

[ Upstream commit b48fe9af1e60360baf09ca6b7a3cd6541f16e611 ]

Add a PCI quirk to enable microphone detection on the headphone jack of
TongFang X6AR55xU devices.

Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260119151626.35481-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index dc2e3ede7a23b..e9022f751c959 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7679,6 +7679,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x12, 0x90a60140},
 		{0x19, 0x04a11030},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1d05, "TongFang", ALC274_FIXUP_HP_HEADSET_MIC,
+		{0x17, 0x90170110},
+		{0x19, 0x03a11030},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0282, 0x1025, "Acer", ALC282_FIXUP_ACER_DISABLE_LINEOUT,
 		ALC282_STANDARD_PINS,
 		{0x12, 0x90a609c0},
-- 
2.51.0



