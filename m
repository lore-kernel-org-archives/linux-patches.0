Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7982949F2;
	Wed, 30 Jul 2025 09:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869232; cv=none; b=vFAd8XMNfMMk8jZCAoTUGL3Kv9emUhKa55EUg0nCP7aCVyP0l5ldie5K0jRwropoJRR9hTuFXXudrge72j6R4eg2uKNJ52WHxVphq5NnNEeXNe883Xn/mpdTQDgVQPme6i6uPP4CmKUk/bKxKRa8H3a/7xCANY+N2CsR3yj4aMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869232; c=relaxed/simple;
	bh=F5LlUituxm9a+kuNXtAZMTuw3RhPi5lEKC9zv5BL+/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYjkBJrr2Mh01EbGWWzUqJuy+ruRJMtUfNQ8vZgiHbplSnk7HcgTm1GQ/Nzr9UxL0eFbcb9/4gG6KefVG/TDl2bbul/mIqkCoUX9iv+pZOpnqyJqAv4x5a/8Td516pbG4jUoUv9Np54kGsP2uqwoOGuILrpOMpfzYQZgnyRlic0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/n9nCVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/n9nCVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A176C4CEF5;
	Wed, 30 Jul 2025 09:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869231;
	bh=F5LlUituxm9a+kuNXtAZMTuw3RhPi5lEKC9zv5BL+/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/n9nCVzD6TB8SUHy3rE7OVawwCYGp4D5lcmqQPiw/h2Mm/fj4OS4WQQo1usnDUN7
	 kcJhQATOqO+erpM3Jd1iCIVhpqtnNd7b4yvDPWB9FonIBv+j1yBzkONw6r/rCdXti5
	 aHgvB2f7tIMeVbErDYesqYhix4x0C2z9dOiyfBf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SHARAN KUMAR M <sharweshraajan@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 36/92] ALSA: hda/realtek: Fix mute LED mask on HP OMEN 16 laptop
Date: Wed, 30 Jul 2025 11:35:44 +0200
Message-ID: <20250730093232.151208725@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5a6d0424bfedc..347096dc354ec 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4753,7 +4753,7 @@ static void alc245_fixup_hp_mute_led_v1_coefbit(struct hda_codec *codec,
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



