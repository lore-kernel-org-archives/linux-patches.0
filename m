Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E7E36828A;
	Mon,  9 Feb 2026 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648031; cv=none; b=XP5VQL5Xa500FwuYSfbaG1LM9j6o32xLcTjyZeYmfRWCsagxEskiDw8wfQbVbKWnJPF86cL0Gq2SaASXevyKjiy1I4N01kB/fw/kzRRTfYQdRUUutRBYEO36pDcBblwRl9LnyXubEfQbelEQw1CvnUT0awm3lUHlFD/RIAIFb/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648031; c=relaxed/simple;
	bh=YAVfkZd/l7eqw4k7yZk0tarK4xUwWOHpJKWRON0fSJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDuvdgAlB8kU/X7ZSs6xNoWybWtyKTv+RJav1GdWd8KwE+EGUyeXq/0DkqFHuYpH/06Uw2DYx5GNqNCbegOTEcgXS4xCz8zfod2MqJbbxalM26FbEnKES6c4QolE8GKvKz0411SjFTN0Ny6rfAweap5ur0udrCFqLBJVgvL+s/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FC2cgTTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FC2cgTTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EE3C116C6;
	Mon,  9 Feb 2026 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648030;
	bh=YAVfkZd/l7eqw4k7yZk0tarK4xUwWOHpJKWRON0fSJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FC2cgTTyPL+EzRP905dyX4G8CM9+LlMSchJp2vlra7SOhUYP2hsd6M7Rliu4iDOzR
	 6O9vhslbdwYKcLbZH64aSR2lpizU2rFieNwVDkw9ZX7I4kchTISocdTUVvMpnzkkic
	 9eV4iR7ObdHiaXY9zvY25e/m0zWq/LzdGENtRPKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/113] ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU
Date: Mon,  9 Feb 2026 15:23:36 +0100
Message-ID: <20260209142312.599111451@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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
index b99be4602ee7b..8077cdb2987ab 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11812,6 +11812,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
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



