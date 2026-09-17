Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3BA3D9523;
	Thu, 17 Sep 2026 17:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665148; cv=none; b=b3+oiTuMiUO8ezOJipqTSiy4RCXVSqVOOMmwPJ8pq7ocHM+RSehagmz7x9CPZ4u4WElwjlqPJtwadnFJKYVQbd/tBNia7QUQ9DqIwi7kSmNnXlYMceownHe/f4qeEDKcUNEaThdIl5YvjMXHpy/1w7C45qIPMumHa9ZWTkPTpz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665148; c=relaxed/simple;
	bh=fkPHuEBFnMc+T8mkrp/00d5OIJOK8K5aMMBBjgcz0Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kh7bXAKnlMaNXPPh5l3eV/ofXiGsrXfojJZB2kBBwDYemV/8o9ZgLSvHAiObnTrFnpOF8CfHYoHmilJzDkrbaqtr6mjhCQVg7KhMbe1FgVZdoBxFMpvz95Vm68eT0wnn4avgu5kVhGYtLIez7Jlt1F1xsCSqO024x+s+lDv8EOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElfaQ8TV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElfaQ8TV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77AA1F000FF;
	Thu, 17 Sep 2026 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665147;
	bh=6IxSUqwT7wd/eMkMi9/eaqRqWgUwm6Qld9u2ArKir7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ElfaQ8TVCk2IgSjJs7w857maQiYIs40DhaVZ0iQlRLJ+Y+a2s3Q4rQBbvwNM6LY3+
	 TTAOqXC3kzSWX0EGwVhtbaMMJzqKbKHgilwCir8GqF0Kz9ZRRE5fdHAoaYvbLd81E3
	 oak8OHzr6hN3lyfbgOcC1YjpC1FSDc1G36mtouM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Pragosa?= <pragosa512@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0555/1250] ALSA: hda/realtek: Add mute LED quirk for HP Victus 16-e0xxx (MB 88ED)
Date: Thu, 17 Sep 2026 16:05:50 +0100
Message-ID: <20260917151606.975943789@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Pragosa <pragosa512@gmail.com>

[ Upstream commit 630c45e92db44b738d1e9224c5f3c032c76a33ca ]

Add subsystem ID 103c:88ed to the existing HP Victus 16-e0xxx
mute LED quirk list.

The HP Victus 16-e0xxx with subsystem ID 103c:88ed uses the same
mute LED coefficient configuration as the already supported
103c:88eb variant.

The mute LED was verified by manually toggling coefficient index
0x0b (bit 3) using hda-verb. After adding the quirk, the LED is
registered as hda::mute and follows the audio mute state.

Signed-off-by: André Pragosa <pragosa512@gmail.com>
Link: https://patch.msgid.link/20260728221129.14680-2-pragosa512@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 34edda8c2de42..aab2456bacaf6 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6831,6 +6831,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x88d1, "HP Pavilion 15-eh1xxx (mainboard 88D1)", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x88ed, "HP Victus 16-e0xxx (MB 88ED)",
+		      ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x88ee, "HP Victus 16-e0xxx (MB 88EE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0



