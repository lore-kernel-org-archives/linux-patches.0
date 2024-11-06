Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EA71DF974;
	Wed,  6 Nov 2024 12:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896390; cv=none; b=pxEK2gpwwz3u2OZmuD7hWoS2rt6h3YCG7CN248N+bXuqqs2endBQGExUy3AzK/cV5nzHEct03mM7wPkitw80XdPvShjPpVk2etFfQ7llayko7EykjwMwNjeeQuY/xWYeR4Y7vOfcfKPBskXnkQO6dJfqGk69hPPGOexUMdDanMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896390; c=relaxed/simple;
	bh=wjTDGp0OC62NqMX9GQDo5ExmdyvCi5Dr7BklEMs6xoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaGOOyeIlwYUjmCJz1PwaMBp6bZ1qOujpWGH0k8YKllb3AAHluPkW78Wv3Kqj2eUZfvCYe3DD944b1h8EGrUVYpXgRtpMrXKXp6YeRH+vG7S3Hj7VkyN/EMSFlyNMKGoqYjlKcNI0tSMgIOFx2f1s2uPpEW2flQJg4lnM9xvBMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaPMgXVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaPMgXVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB11C4CECD;
	Wed,  6 Nov 2024 12:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896390;
	bh=wjTDGp0OC62NqMX9GQDo5ExmdyvCi5Dr7BklEMs6xoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaPMgXVF2oD2VKVWxBoMZ7/vQ6UdnmyaLrYl0AWqGyHN7+NXFxpys1Cy+Xq0X0YCV
	 ksiXqKhDx9gw11F+zswCSDo0lNYA1U8UGgVG/VONQdjomHh5fWkIxZ+nJvKFr0hr6l
	 MZuP2gJ4+kl9XHZQ7o4HhzpUoVmIQgpEzmQX0Xbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 185/245] ALSA: hda/realtek: Fix headset mic on TUXEDO Gemini 17 Gen3
Date: Wed,  6 Nov 2024 13:03:58 +0100
Message-ID: <20241106120323.795706194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

[ Upstream commit 0b04fbe886b4274c8e5855011233aaa69fec6e75 ]

Quirk is needed to enable headset microphone on missing pin 0x19.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029151653.80726-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8d6f446d507c2..25d4c417d3c07 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10729,6 +10729,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x1404, "Clevo N150CU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x14a1, "Clevo L141MU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x2624, "Clevo L240TU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x28c1, "Clevo V370VND", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x4018, "Clevo NV40M[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4019, "Clevo NV40MZ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4020, "Clevo NV40MB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
-- 
2.43.0



