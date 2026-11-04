Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831093;
	b=yeOqqRPrlsZaB7NM+vXk9eZBeggKbAV9KVsfL1JWjLwzjF3lPQFpW+6ADXyfXP0GajvD
	 yd8PC5Hm+KtLhntd6YlzpoyIZ9oAYrMvF7FJ8lxuAZu6dVedAmMMur7TL9uVv+sHbFvfM
	 16f+Z8nM5J5VY7sbpNZUjiiCY7Ek/JtRNZYBZeu+IXb7TdxMTk8T1r0gFj7fezTDW69zj
	 nzPSuKeIz4iUKfCsz4hzkmY/FCVAhLrUmO+wkimncEVedT9ntiv2VkIKRYG3QHqe58tzY
	 paz0km0ft77fn2PzhSRhBU49HFILo6JLfG/TCQNYYJs8YwP1a5cd/YQrJd2mv4c1oQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DejV7SHRdkGkWRKNZSaw0SmWVxdTgg4pRRHBPsrPB9o=;
	b=c+LHtA+K9LvPe8JR62HGewruaOGX4d2vVaus4O4l8feRvFiQn18ao3W9DYtyXGwjdEfG
	 Qgf16FrGOEYQBn4bhRIwwfwEAicQKsVHDHEX/C84GIUjos/aMVRYhCJJIZdyo+7JjCu1s
	 BMMuSEdzNG5XnVra7e+c5D7tNAf+0drWCqLm1uQKEoDXqzCdvQwTs5R19EENGdqS7ytoK
	 4oDam5qAO0pfHpzLUYheXabFceWUWihZSjak/AKWo0dcr8gdR5KVpfR63Yjh/ET2c8d8t
	 +zicASJSFDnFDqgBMwsHmR5SX2Uy1O3oCj+8D+/Py9BNUBvI77HTBO5vc/TPoJ6vcQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KuC86d3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66A1606AC39;
	Wed,  4 Nov 2026 22:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KuC86d3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4288C1F00919;
	Wed,  4 Nov 2026 22:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831092;
	bh=DejV7SHRdkGkWRKNZSaw0SmWVxdTgg4pRRHBPsrPB9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuC86d3N1DzZ69xs4DYHg5UZG4BxNZnBlgeyL0yVedthGP96HyYZchtTRr9akekzd
	 42YoB86rIW1gjiNP3tlsvrHJHoyGtYJkJPywQI1WpbL8ov6AScFkT7O1zJUI58Ptv8
	 2m9XCAKD84pKFRWU7bG9Sd8i1dzHfO9IXv6iIQdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0499/1005] ALSA: hda/realtek: Add quirk for Acer Nitro AN515-45
Date: Wed,  4 Nov 2026 16:03:52 -0500
Message-ID: <20261104211057.927882085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 0d90a929836344f1d3b39f22f08ccecc62378a59 ]

The Acer Nitro AN515-45 requires ALC2XX_FIXUP_HEADSET_MIC to make the
headset microphone work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221925
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260921124450.639601-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 4eefd5d87f04b..fa5bc54ff083d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6615,6 +6615,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
+	SND_PCI_QUIRK(0x1025, 0x151e, "Acer Nitro AN515-45", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1539, "Acer Nitro 5 AN515-57", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
-- 
2.53.0



