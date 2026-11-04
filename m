Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830839;
	b=g9Q0GvNqDADENKMcf0mAzQx9CwKpsIWSx+VHXNOAMnFzJuqHx4hiFy85bTGfy+5cWAdK
	 25wqQ+6ugYQvLu6yXP5DhLVxnq8qIBtsO630ZhVon6zcpLTn//VFxuDsfGyEX5VDopQz4
	 vKuuxWib8MZ349swwEg4wV2nnVcglkaJsI8gvuI5LdXXDcEgdglvV0NdGYKHp0mH1x4se
	 uCQmmYmckTXlmboh4rfemOFSBj1Qw1Nq2O+N+0WpiIrs3umSDGWimXEiU7lBRdZxVngUh
	 /rBk8MCRir8AJAyct1WQhRvdi1G6RqelF7AfFr8077OZ0azggBREXeRO+5UFfBv6DMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8V5tOTb8Ut/ERlXWHgCAp9NUuUcByZVHPwv8Qe+6Bg0=;
	b=WlKOidhPeHcKFx2ARlbkvdEA7Tjv1sSjyi8edwlDPzPRs6AK+l2MSqFeKPa18pHZSHSu
	 WJMCIfvGeYVWozPpQ42WIq5yWy8RxJqH2koCWDpUW1EzYyEvHhxv6Mw6N4qQuuyfh4MV1
	 UAn/4Unz8hY1fwXuUkyTcK8jqwqybsoP7cVXGRSH111mstrA5Ejg65yYS4P6ifSzziMLD
	 9SzEANfpFbYrB5yzUdH19ZT3Tn9UBBrbtqOptAoA2Cw8shuH/vStj1hOowNp0gtlMeuUu
	 1x2j95JQ2C57I1PIa8A9k8kJJY1vEUrnS0SaMz5+9EMY2wU8bYd2czSbRbgxWuUxn+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmkjG7vq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34AD606B2D8;
	Wed,  4 Nov 2026 22:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmkjG7vq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055191F00919;
	Wed,  4 Nov 2026 22:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830839;
	bh=8V5tOTb8Ut/ERlXWHgCAp9NUuUcByZVHPwv8Qe+6Bg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmkjG7vqe4NoP+/r6Pv1GeJk76z3iVtL07p6TVhyPms4l+hjAYFl+RCFEootMrCW1
	 nEs07VWUwq6YeBN6pvKARLP8lJF41NT8HXg5mL6cZxJeQ1tteab0lGh689hveN5eFV
	 yafJuidsnZ69icbQNSxog2vWCMzf+xsTIXq9LZKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0353/1005] ALSA: hda/realtek: Fix headset mic on ASUS Vivobook S14 S5406SA
Date: Wed,  4 Nov 2026 16:01:26 -0500
Message-ID: <20261104211053.961339613@linuxfoundation.org>
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

[ Upstream commit f2d08f3651fb12634347fef2c41687a807a7dcba ]

On the ASUS Vivobook S14 S5406SA (subsystem 0x104310c4, Lunar Lake
platform) with an ALC294 codec, the headset microphone (3.5mm jack)
fails to capture any audio. Adding the ALC2XX_FIXUP_HEADSET_MIC
quirk resolves the issue and restores proper headset mic recording.

Link: https://github.com/thesofproject/linux/issues/5729
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260807125857.678297-3-zhangheng@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 97ab2269dc472..8fdfe1bbe7aff 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7101,6 +7101,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10a4, "ASUS TP3407SA", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x10c4, "ASUS Vivobook S14 S5406SA", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1154, "ASUS TP3607SH", ALC287_FIXUP_TAS2781_I2C),
-- 
2.53.0



