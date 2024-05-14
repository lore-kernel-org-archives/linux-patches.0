Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD3F6CDC8;
	Tue, 14 May 2024 10:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682270; cv=none; b=goED14XJ32EqsfObRI019m9ySJRtIoMkUs/qcP1YvBbEPLPqKWacK6MNDKQ8vTKUf1XAFhKgoxWMudK58VzBHgU5yIalo6ZolKRbYjM//klNmW9PRN+Izqht5Skktb9CaTjjFQ/UmmG2dFMZaQAqwy8gluXwJLraO7dHOG3tcyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682270; c=relaxed/simple;
	bh=Uwcjg/zsmT7YVrfxQ6WeFXd1bsAnpzbrmBLLFB07K8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGJ+Kc+5MFNoYpfx/5YrCZlAQA/GUOp49kmBkjzIXt10JWv+Mjb5Ty1HYlo33wEJZuE8W566OqzucHRA/aXAavAHWajEvS7W7e2fbdFnYr5XNIOCbZA809RuREOa5WwY++ZN5VVlbOmrmmskyoQ/TGR+dwCT9OTg9gCED1k1LkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GuG7lli1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuG7lli1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03544C2BD10;
	Tue, 14 May 2024 10:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682270;
	bh=Uwcjg/zsmT7YVrfxQ6WeFXd1bsAnpzbrmBLLFB07K8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuG7lli1NmJELiey0/0fWYOMqQpIjIY6MdzE8pf0Yq00tP9rQcfEEtBPBmSqpUDSW
	 pOt/goKNTpVQog7fxEr0UFXancS/iONFBnm66/W9GgasSyaQeDt1at9wa2iV+HmZEk
	 NgxPuwDM8EpJ5IHgwMqI53QWMRdywZyGgt+h3+AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 037/336] ASoC: codecs: wsa881x: set clk_stop_mode1 flag
Date: Tue, 14 May 2024 12:14:01 +0200
Message-ID: <20240514101040.009433780@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 32ac501957e5f68fe0e4bf88fb4db75cfb8f6566 ]

WSA881x codecs do not retain the state while clock is stopped, so mark
this with clk_stop_mode1 flag.

Fixes: a0aab9e1404a ("ASoC: codecs: add wsa881x amplifier support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240419140012.91384-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa881x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wsa881x.c b/sound/soc/codecs/wsa881x.c
index 3c025dabaf7a4..1253695bebd86 100644
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -1155,6 +1155,7 @@ static int wsa881x_probe(struct sdw_slave *pdev,
 	pdev->prop.sink_ports = GENMASK(WSA881X_MAX_SWR_PORTS, 0);
 	pdev->prop.sink_dpn_prop = wsa_sink_dpn_prop;
 	pdev->prop.scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY;
+	pdev->prop.clk_stop_mode1 = true;
 	gpiod_direction_output(wsa881x->sd_n, !wsa881x->sd_n_val);
 
 	wsa881x->regmap = devm_regmap_init_sdw(pdev, &wsa881x_regmap_config);
-- 
2.43.0



