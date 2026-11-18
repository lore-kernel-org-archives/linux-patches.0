Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016452;
	b=3xkAgWHucNo3UO28KBtdM4Kam+4UwtN19jYIyV5VspEU1G3+9G91ZplDP3vF9RoPOjCM
	 V3lMPVSU28CnZ7o0ZR37zeblz7ogdRQwsFq58/v68rVfii8/u7RJl07GoP8/yKEYds085
	 2Ac1eEyv78+kHZlIq+HKZUAJ89zcdkk8zzhAQBTvkAx6YVkuQ+pPYlQoWm4lWNd4FuKqi
	 UTUfKf3876HMfmeezWWrlW8Vsxx46BJIBJQ9rHMePPiV5SI2iGUwa1OPcah0k+i2Je9V9
	 SIPUyv9pun3ZL+C1uRlTwjvdc6tri3F6WR1hhP8LBxVbDyrr3H/UgRm0ZrDjgUJXQCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tn6AGaWQQhpmXzYXdtn6AWxjqvnJe+LqWsOG6pddehI=;
	b=tghrOs6DMqu7EqI+5J4gCZsWnRRAJ89b3ot+tUm+XX3aYkXvnatrn4HWiu5Xg4p7VFPs
	 yTru9l0WHwsxwopZVnTcX25xxfv1y1wat0F9aZjEnX6CwC5fy7QXCdOxZOwLasy3M0yAX
	 GcyuxopST4RJy+64VxtAuR8JxCe5q2WFVop7A1BqSqIz6mizmq18V1VB3J9SHty1L4UST
	 bJ46iESYPpZwG+1ecC7ptZAOrvl8skud2OIhdddLmnKcdXvdHZZXvORapyj5lqJT6NcKx
	 sAa27CLw+Abh1fwmWo5Rl9yfAnu/t5wNDDiGxqtGAi1IqqS9cpVhRa5q206x5FRv7+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1jsJtQ82;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53300606A33B;
	Wed, 18 Nov 2026 15:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1jsJtQ82
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CCD1F000C4;
	Wed, 18 Nov 2026 15:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016452;
	bh=tn6AGaWQQhpmXzYXdtn6AWxjqvnJe+LqWsOG6pddehI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jsJtQ82f0l8/eQcckzo1rQH9YwXTuO+W9sJZrKeOun8nSkUSsIWAB5Mjql3LpY0y
	 f/kHuy6zVT0Bunex/srW+2D/Z6X22gJZ7r8mf1Qa9q27+vGYZkQAYjks2hIG6vBXf5
	 r1ZXOe6aR1jxPTrJP69VjvvqvzBg72P6gZJkl6RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0534/2651] ASoC: mediatek: mt8189: Validate TDM MCLK frequency
Date: Wed, 18 Nov 2026 15:29:34 +0100
Message-ID: <20261118150306.987673310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 197ec30e1b608ade5d2eb9271d01c59480a6f9a1 ]

mtk_dai_tdm_cal_mclk() accepts zero or negative frequencies.
Reject invalid frequencies before configuring the TDM clock.

Fixes: 9f202872ba04 ("ASoC: mediatek: mt8189: support TDM in platform driver")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260916050020.14575-13-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-dai-tdm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mediatek/mt8189/mt8189-dai-tdm.c b/sound/soc/mediatek/mt8189/mt8189-dai-tdm.c
index 9aebd0320614e..e113c52fe06a9 100644
--- a/sound/soc/mediatek/mt8189/mt8189-dai-tdm.c
+++ b/sound/soc/mediatek/mt8189/mt8189-dai-tdm.c
@@ -383,6 +383,9 @@ static int mtk_dai_tdm_cal_mclk(struct mtk_base_afe *afe,
 	int apll;
 	int apll_rate;
 
+	if (freq <= 0)
+		return -EINVAL;
+
 	apll = mt8189_get_apll_by_rate(afe, freq);
 	apll_rate = mt8189_get_apll_rate(afe, apll);
 
-- 
2.53.0



