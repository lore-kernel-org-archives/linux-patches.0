Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8413293B46;
	Wed, 30 Jul 2025 09:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868737; cv=none; b=S8pOt5Ztn7N4frdN2ET/1ibHjjh3Vk1xrDIpD1r8JjE26ze3cuTd3DBBuCWdTdfSpMPLMETLE8HVWBCsyfRtLd/cOyEUKoCVY9g5XbjjKXMYKhc49oB46RiARPBAx+gDn7ws5y3XLa4iBjsjH6jPr4X+Sdoym+85JPhUzytXPYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868737; c=relaxed/simple;
	bh=N15vBg23N+FNg8plooxyMocamFfLsQxYGv4OK7fxLmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8Um8ZFag+ctKsEuiGaDI29us3CtUrXRw1QMgyWE6NeYj0+OmIbuN/9PSIUsV1dH5WM+h0CvN0QyumWX0JP/WI90b2/q6dZ0kuX+Qo/ssWBqifXMkgRhLUHYgrb6/xUbpjSUDjllw971rmrzskuocWiPAsHLzQmkCmjHfPIAKes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUN7JYBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUN7JYBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94ACC4CEF5;
	Wed, 30 Jul 2025 09:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868737;
	bh=N15vBg23N+FNg8plooxyMocamFfLsQxYGv4OK7fxLmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUN7JYBSuYSYL9TbE8IAGoPjwVSPAbr04ZcWh0UGG0cZUoVC4IKYQPyTTWPXsOoVc
	 ldKRT30xowYQESN/UEGity69L4ftyyz6FKjKWFFk+/iwRgLwkJ8JSnKA0h9oUnmWx+
	 SLwCUwl+ZE0bbKtrWVLVth0mjLNk5hrBy0VtvXpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SHARAN KUMAR M <sharweshraajan@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/117] ALSA: hda/realtek: Fix mute LED mask on HP OMEN 16 laptop
Date: Wed, 30 Jul 2025 11:35:01 +0200
Message-ID: <20250730093234.809186715@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: SHARAN KUMAR M <sharweshraajan@gmail.com>

[ Upstream commit 931837cd924048ab785eedb4cee5b276c90a2924 ]

this patch is to fix my previous Commit <e5182305a519> i have fixed mute
led but for by This patch corrects the coefficient mask value introduced
in commit <e5182305a519>, which was intended to enable the mute LED
functionality. During testing, multiple values were evaluated, and
an incorrect value was mistakenly included in the final commit.
This update fixes that error by applying the correct mask value for
proper mute LED behavior.

Tested on 6.15.5-arch1-1

Fixes: e5182305a519 ("ALSA: hda/realtek: Enable Mute LED on HP OMEN 16 Laptop xd000xx")
Signed-off-by: SHARAN KUMAR M <sharweshraajan@gmail.com>
Link: https://patch.msgid.link/20250722172224.15359-1-sharweshraajan@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f033214bf77fd..58e75687efff0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4755,7 +4755,7 @@ static void alc245_fixup_hp_mute_led_v1_coefbit(struct hda_codec *codec,
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->mute_led_polarity = 0;
 		spec->mute_led_coef.idx = 0x0b;
-		spec->mute_led_coef.mask = 1 << 3;
+		spec->mute_led_coef.mask = 3 << 2;
 		spec->mute_led_coef.on = 1 << 3;
 		spec->mute_led_coef.off = 0;
 		snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set);
-- 
2.39.5



