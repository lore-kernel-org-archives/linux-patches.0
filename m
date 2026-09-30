Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D49F2F25F3;
	Wed, 30 Sep 2026 18:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794411; cv=none; b=uvyktBxVhRIG9nzuCdODVYe4k5Fq1AKjcXINgJUVaVjkTHPdNC/3FavklBBuzbXmlkjngOnlDJRT7j7eexZ/ARaEeuB5IwQkAJPgCSin3wnZak+W72oGgwhG2Vp1fyWkKRRbMB4by0jPQ1hyA0u+lEjxwn3FdhZ/Kp8NG+HY7H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794411; c=relaxed/simple;
	bh=K6CvEMp4Sgg5iByW6j2vPOByo2N+9jf+kSSX4eDwsKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCr9wHENQa8dn/GYtZRyZgOjrQDIpWHAbQHcSNOFbzsJ2Z5N1bJA1m8I+GhdzYDZdfiD3EIkuQN/RF93sgwY/e0uzAEC4ses+k73paveMal+Yl1hmBRzkv+8gKcBTtBxPRGDj1g6KI5A6a6CAWyqG+M9rdZufvBn37/96jNNrb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RS1mgHzP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RS1mgHzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C041F000FF;
	Wed, 30 Sep 2026 18:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794410;
	bh=HXcdykNRuOPQp516UdT1xu83Fo8NzJVeL5NpmkAZQuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RS1mgHzP9KETnjSFcfSE5VZkV/rWlBHmR19n0HYACR73c56+AQ0BoCMI0YYMpc5lk
	 tl2Yn0vorC2+Kvzz1SBo/079uN0RnvN7P4mnQwCH8Jc2jQbCu6UbiES8urMmZHGGpZ
	 pYlp+CFHcuLSRjVn3qWjYGhpjL560uxEn/mAIw+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>,
	Moritz Baron <moritz.baron@stud.uni-hannover.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0202/1193] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IRH8
Date: Wed, 30 Sep 2026 17:14:46 +0200
Message-ID: <20260930152438.696198576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Moritz Baron <moritz.baron@stud.uni-hannover.de>

[ Upstream commit 853e10ec445984e99b3c7f6375f4e185614b842a ]

The Lenovo Yoga Pro 7 14IRH8 (ALC287 codec, subsystem ID 0x17aa:0x38b1)
has bass speakers on pin 0x17 that are not routed through a DAC with
volume control. This causes the bass speakers to play at full volume
regardless of the volume slider position.

Apply ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN which corrects the DAC
routing for pin 0x17, enabling proper volume control. This is the same
fix used for other Yoga Pro 7 models with identical audio topology
(14APH8, 14AHP9, 14ASP10, 14IAH10).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217949

Co-developed-by: Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>
Signed-off-by: Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>
Signed-off-by: Moritz Baron <moritz.baron@stud.uni-hannover.de>
Link: https://patch.msgid.link/20260609141648.60608-1-moritz.baron@stud.uni-hannover.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 855c9cb15aa4f..816a7c500378e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10566,6 +10566,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
 	SND_PCI_QUIRK(0x17aa, 0x3847, "Legion 7 16ACHG6", ALC287_FIXUP_LEGION_16ACHG6),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	/* Yoga Pro 7 14IRH8 shares PCI SSID 17aa:3852 with Yoga 7 14ITL5;
+	 * use codec SSID to distinguish them
+	 */
+	HDA_CODEC_QUIRK(0x17aa, 0x38b1, "Lenovo Yoga Pro 7 14IRH8", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
-- 
2.53.0



