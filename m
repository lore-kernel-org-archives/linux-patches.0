Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032145;
	b=w8n+NFG9CZO0ne+T/5VtqjTHN69CgtrmDDzCYrY6+pypBmebjs7bQlRnklnW5EsTq2MA
	 tp080wvEPeNmFlnHte855/bvCgW8/2RLJnrtTuovCPbzCqoXhMnY9ise6T5lcan1g+Ecu
	 X20rBRGjx5+cy4sBRK7hjvPnNhs4ijH5+uwCsr9sWFRAKG+GAzdvHHnWyXCHgLB3QcS31
	 OEHtQ76u436gzmOYIS7VeTGYnAPMgVt1pERPX66EBk1pU/eZCvVXCP5E0f6vQCz4o7Q03
	 zJA75TqklZG6wXejcbyswSe2CC0TGYVi9B0sqLQwh4eoRh/N79x42BW5Qg9CiUXm6pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1040k94nChZSma74BnIB4J7jYqsOgmDYLaKjCDkXKiQ=;
	b=nmUNRs+RPc3P/38lcGzi8LpmJkCIJeLGD59L+MjQ3UtRm5179hIZ3KPmMblvbGWsbuhm
	 +G/DtxO71z2ahz24GmdQuKjyXdfDcA8nO/0wmgI0C5P6cqr2oXHGgqZhwgBASi1w6tztd
	 nhFD4RICa5a4yprG/APkLgiovO+oZk0z55i0f0giw84W8meBTyRgA4vo7Fik9Ssvpa3bX
	 8GyJ0/CiBGAb2litGS2KoSN3iNJZ2wdLLjwKGwkA+4Wmnt9l739FpOOTC2wY4NX117ZSq
	 XyKw7l/rxAEMFISmGL5wSDI6fNrrJ8FJQWYMD34aVTSXA6iXsS4hZx0xJIzuvjg7+DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDCl9ver;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C1B606A325;
	Wed, 18 Nov 2026 20:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDCl9ver
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34E61F000C4;
	Wed, 18 Nov 2026 20:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032145;
	bh=1040k94nChZSma74BnIB4J7jYqsOgmDYLaKjCDkXKiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDCl9verKhh0spGsogYVlWT5AFOILVrSKHHtWXlFUOKKoy6yZrMqohzlfm7wIzFe5
	 fFh71PuiN1mh2utqTlQfEU4QzAgas8YZj+koyfZSszhcmRnYGMMEI4oQEJwwonNlpL
	 jy2nViGQynvWHrygTYmOVJ+N68l4RmHvMJy4+9U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1308/1756] ASoC: mediatek: mt8195: Check paired MEMIF clock enable in FE trigger
Date: Wed, 18 Nov 2026 15:57:15 +0100
Message-ID: <20261118150101.557689908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit a2ae972c75a18ecbdcbf331ddaab21e1a08333fb ]

Check the return value of mt8195_afe_paired_memif_clk_enable() on
START/RESUME. On failure, stop the MEMIF and disable the channel
merge before returning the error.

Also skip enabling the paired clock if mtk_afe_fe_trigger() fails.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-9-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 39cf72e07db40..7f771aaf04c18 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -466,7 +466,14 @@ static int mt8195_afe_fe_trigger(struct snd_pcm_substream *substream, int cmd,
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
-		mt8195_afe_paired_memif_clk_enable(substream, dai, 1);
+		if (ret)
+			break;
+
+		ret = mt8195_afe_paired_memif_clk_enable(substream, dai, 1);
+		if (ret) {
+			mtk_afe_fe_trigger(substream, SNDRV_PCM_TRIGGER_STOP, dai);
+			mt8195_afe_enable_cm(afe, cm, false);
+		}
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-- 
2.53.0



