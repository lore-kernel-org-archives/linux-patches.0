Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDBC29E0F6;
	Tue, 17 Feb 2026 20:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360864; cv=none; b=FwvbdGh6Z0dD5wxrUZpE+obIVPuG2doFtdXqHZJR8RbG6XJcaWtwMspp6MRUD+AjrQ2FJiGjIigN3NoahZditlzTOoJn/Qo821V7qSdELgDzxTUU66oZ5xax/RLixQrc+SpJU+9lhIIoqdwhGdKVY/NgHe7+yqZZFt1Y4m8A1r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360864; c=relaxed/simple;
	bh=b9Puen0w5OUBrZ+S2T1eGwHote/1bZWBHFwIzNfRW54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD8qAMLbaE0vd3fit6m2AMby2gyFcPp78rhcvbglpyDRCEdk+Qw7mMUyE0t4RCkb3HyOz0QvDYHDkHnkOCAc60Qt8BXTJ0YVp5pedgvkn+nz0eaXmIO3DrexY+QNMcIqSUempOPVUvewh62T3z/BwrafQt5x7TqtOYmq7sEelU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eflc4Tzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eflc4Tzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01C0C4CEF7;
	Tue, 17 Feb 2026 20:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360864;
	bh=b9Puen0w5OUBrZ+S2T1eGwHote/1bZWBHFwIzNfRW54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eflc4TzxC5II4i4YUXuM9mTpgoaMLV4vBVO36Go69E0YW2O5Zn5kouv+063/hevZ7
	 dTg8DhHDfO/ZJqhsibHHbMQ33VOvN0h9qK6u+tYuJzTpdkfkA3SKW1Nrp7RxrfRuMy
	 17d5AfBlZfQqgtbnoLa1g+K6bhZ3OMNAQEdxDE/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/39] ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU
Date: Tue, 17 Feb 2026 21:30:28 +0100
Message-ID: <20260217200004.474386818@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c60358a4a7572..95e650493dc5b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11102,6 +11102,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
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



