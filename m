Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB9852CCC5;
	Thu, 17 Sep 2026 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664463; cv=none; b=G9WSTwMMYVCWpOIt+DqopHkSyRrvhLTuHP2dQ4Gx1LbZSJBOqc99ATFIouQ71T6p5DGmDQwO9xoSZKWn5moR0BEd4541sUtwar5qQ78AjBEqZidUiCSZfnhnv13rgSYFzo7Au/C3bGiF/TYSBG6X2WpiTJnp8PdNVGmEp0r447I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664463; c=relaxed/simple;
	bh=j4hh6uvFbsQPQTooWVQDjRPemvNHY4dveDvqFYJY0tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxA8jzg4NeU202+SoM6Ecwf/VMOcTv00RAX+wjVWYa2M7tiqyFMf24k8cJUK9x2K70ZGi6956OiIfqY9S8RjbjXApXdvhT/N16BagHti5gYvEHhX9xt2m8BSiYF387WisxVsaykslpvw2f7KZVH63yqQ2Gdxw14JXucKMjk6vBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qe6NztWT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qe6NztWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2051B1F000FF;
	Thu, 17 Sep 2026 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664461;
	bh=7OruyZGGKt72ondKiDesxNOQEWfg7sL5ajFIHoUfkSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qe6NztWTxA6oj2NnZz6xNSHV14LWqY3EXwu4UoDqn/qkaFrpZL5fBkzNQY2onZqvg
	 xj0PXByaMoZE62XjGGV2Xxl6o9slgHVwpMOJgzz9+dRsuCGKFIWxwjo6KGBj5+on/7
	 yo+DY1+gUpE96ZWy3w5EuD+u4x9Fr0Whg7/gVujY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>,
	Moritz Baron <moritz.baron@stud.uni-hannover.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0380/1250] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IRH8
Date: Thu, 17 Sep 2026 16:02:55 +0100
Message-ID: <20260917151602.349619730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 3321d8d3571da..a634f1c1ca4b8 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7439,6 +7439,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	HDA_CODEC_QUIRK(0x17aa, 0x38cf, "Lenovo Yoga Pro 7 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
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



