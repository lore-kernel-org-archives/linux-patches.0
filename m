Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B2E749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AC9C433EF;
	Thu, 12 Jan 2023 14:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532500;
	bh=gihJot3oJNgntvCgukCheTf67coQHkcH43exqMvu04s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgZ4jxuKocInopZztecRZHP6Hbz8EKv+aHKk8E6NfYhC9UvqDH+KPlzEeFSy3Kk29
	 QBOTX1iJ7Zwzbn399AgNeeDjTs3PPS+yzhjHhcj2vvHxZpG8EmWvjkU+ol3oiYfLdi
	 +3k41xiOHllZsAVvPEwC+VgC/KPw2TikbNGIGwGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/783] ASoC: mediatek: mtk-btcvsd: Add checks for write and read of mtk_btcvsd_snd
Date: Thu, 12 Jan 2023 14:48:19 +0100
Message-Id: <20230112135532.807142169@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit d067b3378a78c9c3048ac535e31c171b6f5b5846 ]

As the mtk_btcvsd_snd_write and mtk_btcvsd_snd_read may return error,
it should be better to catch the exception.

Fixes: 4bd8597dc36c ("ASoC: mediatek: add btcvsd driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20221116030750.40500-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/common/mtk-btcvsd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/common/mtk-btcvsd.c b/sound/soc/mediatek/common/mtk-btcvsd.c
index 86e982e3209e..e1f57b0dedd0 100644
--- a/sound/soc/mediatek/common/mtk-btcvsd.c
+++ b/sound/soc/mediatek/common/mtk-btcvsd.c
@@ -1038,11 +1038,9 @@ static int mtk_pcm_btcvsd_copy(struct snd_soc_component *component,
 	struct mtk_btcvsd_snd *bt = snd_soc_component_get_drvdata(component);
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		mtk_btcvsd_snd_write(bt, buf, count);
+		return mtk_btcvsd_snd_write(bt, buf, count);
 	else
-		mtk_btcvsd_snd_read(bt, buf, count);
-
-	return 0;
+		return mtk_btcvsd_snd_read(bt, buf, count);
 }
 
 /* kcontrol */
-- 
2.35.1



