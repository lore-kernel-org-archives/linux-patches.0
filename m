Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD9851B184;
	Thu, 17 Sep 2026 17:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664857; cv=none; b=K+ncgFBrl3jvyd3ZN1YWcHFa8kbiqifpLAuLpnrqKe4NVxHNGSUReUi7XUPxsdD8/wql03EzEQLgHmipLQd5Xw9e8kxrpyWisxut3yqoU6wJGrvqWWSKebIOf2WFBzwgRXMhrOkZldxIghIF/vKyOEZThL4xOrwVikvul6gpxNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664857; c=relaxed/simple;
	bh=myI8zFPZBXeHwWWw9EW5VOoMXw5Mw+Hb23AcsUu//6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kK0IHupezAMtIi7zn55Vps4FElQR0yrV1jUodgT17m49vl9GSbs6XzfGnhVCAdOclHOyItX0CMo6NLzB1wAV1T+8KeNfEAzy60T4quLF4F/QbYKVZ5qpC5sTDp0ll01pvxAJ1snYSQMZixGneWD4aQub4Az0HEhczS+XGOc+fuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7rt7kpN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7rt7kpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391EE1F000FF;
	Thu, 17 Sep 2026 17:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664855;
	bh=P2xziC67RL3bFNg9qARdcuRTEdpwcaNcj1OJyybeIQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7rt7kpNFluBJq2V3ZIKWYEf0vxjorsZYaadE4jsTSlEMMP9mgQ/z863n0AqFLoqd
	 CvrCCkxwqApg5tpguPm+PLl/x3Z3e4kR1jDgbVV8IpgSWvp0Nqe+70Z774nStlvh9I
	 30Ai1Zibo7BqdeRLyohE4wZiX94lQU1GEpt0SAsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Sinha <rohitsinha12043@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0510/1250] ALSA: hda/realtek - Add quirk for HP Victus 15-fa0xxx (MB 8A50)
Date: Thu, 17 Sep 2026 16:05:05 +0100
Message-ID: <20260917151605.779568572@linuxfoundation.org>
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

From: Rohit Sinha <rohitsinha12043@gmail.com>

[ Upstream commit 5c3f4b583c25911fad9890b463632761291f65ab ]

The mute LED on HP Victus 15-fa0xxx (board ID 8A50) uses ALC245 but
requires a quirk to work. This patch enables the existing
ALC245_FIXUP_HP_MUTE_LED_COEFBIT quirk for the device.

Tested on my HP Victus 15-fa0xxx. The LED behaviour works as intended.

Signed-off-by: Rohit Sinha <rohitsinha12043@gmail.com>
Link: https://patch.msgid.link/20260706211834.384022-1-rohitsinha12043@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 587df9ec885c4..d77239a03f259 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6868,6 +6868,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8a34, "HP Pavilion x360 2-in-1 Laptop 14-ek0xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a3d, "HP Victus 15-fb0xxx (MB 8A3D)", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8a50, "HP Victus 15-fa0xxx (MB 8A50)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x103c, 0x8a74, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a75, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.53.0



