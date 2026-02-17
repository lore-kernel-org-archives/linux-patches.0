Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345C029A1;
	Tue, 17 Feb 2026 20:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361622; cv=none; b=VsJQpg2FOn/J9XpGbGH8UAjZ1olaJwhADDvN8rBb5YvbbioDUAAG3eRmrD6AbnsVQ6yB2jX84kyUYdCcUs7shlKMPuk4sWuqOzN20G75X5MvSfj8p0oIGg8NXQZTFrJ4a5WBWqkHXWNIuSDxiIHOerQS1gsYF23+m3ADl1IAD20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361622; c=relaxed/simple;
	bh=2rdR2JMA9hO9pzLTLCuPv7tmbRxdET/EZgX6O1LIkP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvFJEY+J698Eoc/ePMK2IF6U+6IVabDF1iYJ98AjBbERNIhJkVUCOcsW8DVa0Pxf/bDynpRKoLj6DjgeL0EdnDVQNHdeCQHREMfe1twMQJib5hiZnPr7zGG0AmRgw4YPWrAyFy4rUU+w2+z9KMGI0tvMYIyV3+1pChNaRqwGkb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4TOOmrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4TOOmrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9759DC4CEF7;
	Tue, 17 Feb 2026 20:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361622;
	bh=2rdR2JMA9hO9pzLTLCuPv7tmbRxdET/EZgX6O1LIkP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4TOOmrzEoI5eWD7OHUV9qlkR8wSIbHnfXT5ucE1VRmrQQN7rNAA90lwRreiDSUjQ
	 dQxHty3zJjetUOA6HUIHbWSlyLQCr8RN+nLabNOZWJ2yx91uU44QTdAMLMRDqo8a5s
	 1oZTTemsZG8x8jLMjL5IP3EP/HQwAQXtb0ehiYKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 06/42] ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU
Date: Tue, 17 Feb 2026 21:31:57 +0100
Message-ID: <20260217200006.250714522@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7bb2647af654a..2bdad4e518032 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11835,6 +11835,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
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



