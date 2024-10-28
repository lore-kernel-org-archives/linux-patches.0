Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210978837;
	Mon, 28 Oct 2024 06:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098337; cv=none; b=bPmS3sQNuwa84WWtlhuLZJ0bdzg638VaH+6IUPgoH/y7LFnl3+uHdwUmzGDBGFTJALBUva8RQ5LBAU59zMYuG6KcMkPSjC/vND12SV22g0z/3ssQbduHxPbh9TJhJ5NVXxZaDAXBi+2A4QXNecDonu12fmGuO8ScveLY19/9pz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098337; c=relaxed/simple;
	bh=6mqtye1wsMdrlIS6qe3STxMxC/e1VPWZNNTttlxI6o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLaChBTue8xP+pKWHiwHesl2IVyEX1uoq0r313QXZ9ucZB9hLdUt16HXracnCbJtVe48LAT87lJ8ntxI+lps4DX26gWkDAIk+XVeb7Qm/B4zQRAYG2LycklKttseuyHn4IMGbNTDf/uhUcJOIP7wZnoLON6shkGfgitg0pq2WVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPMleQQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPMleQQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7450CC4CEC3;
	Mon, 28 Oct 2024 06:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098336;
	bh=6mqtye1wsMdrlIS6qe3STxMxC/e1VPWZNNTttlxI6o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPMleQQ+TPA0uEWjBo5sfHtD/JW0v6xi35xd/I7RwLVqeFQEFa5+uPsRO2w/ugjR/
	 Hm9hADdD5WnSLb6Y8SnDytPFOue9xi7ymkhEE6EA0VFeTJNRlL+ssrvOJHvZ5fdkqr
	 YxzC5BO8/qbXuBAR2sn6+EnBTrFUsIOJ48ZumDIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 183/261] ASoC: loongson: Fix component check failed on FDT systems
Date: Mon, 28 Oct 2024 07:25:25 +0100
Message-ID: <20241028062316.593707175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit a6134e7b4d4a14e0942f113a6df1d518baa2a0a4 ]

Add missing snd_soc_dai_link.platforms assignment to avoid
soc_dai_link_sanity_check() failure.

Fixes: d24028606e76 ("ASoC: loongson: Add Loongson ASoC Sound Card Support")
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Link: https://patch.msgid.link/6645888f2f9e8a1d8d799109f867d0f97fd78c58.1728459624.git.zhoubinbin@loongson.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/loongson/loongson_card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/loongson/loongson_card.c b/sound/soc/loongson/loongson_card.c
index 2c8dbdba27c5f..cc0bb6f9772e1 100644
--- a/sound/soc/loongson/loongson_card.c
+++ b/sound/soc/loongson/loongson_card.c
@@ -137,6 +137,7 @@ static int loongson_card_parse_of(struct loongson_card_data *data)
 			dev_err(dev, "getting cpu dlc error (%d)\n", ret);
 			goto err;
 		}
+		loongson_dai_links[i].platforms->of_node = loongson_dai_links[i].cpus->of_node;
 
 		ret = snd_soc_of_get_dlc(codec, NULL, loongson_dai_links[i].codecs, 0);
 		if (ret < 0) {
-- 
2.43.0



