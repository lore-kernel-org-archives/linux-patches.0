Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5020136672;
	Tue, 14 May 2024 11:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684469; cv=none; b=gyocf/7OTLx8zLFVxBIVKi/zFOHzCx0Zy/6Nro70F6apuC2tCmwhNL05PzIxpN0863ybd6Biu/500P/1b4L0y8JgcWoE8Tts1ydLrfSlsuo0J5s/Tt4KuCBLwuXefpi34hQG1QjJKVJZowlHyXdfoExJtr0miNldPGxah728rLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684469; c=relaxed/simple;
	bh=yTtWZcbRRPkLN/Vv/8RgrZgEf13HK2U/83UcFHmXmFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1bqzWRN1A4JjqyA/iOJXCM11fzz1bm0qkVn638xGIHYPCczyloE/dA+jA++wcnYrhICx4J0VWuDhduaiXX9UApKrN/nOnPG5/0F/Rqh3ECuXCMdFe0hZwvJsRYZDUB4zE/ybkpby7+ghLLwN23LHZmyG62DaH5mni3/j+D/tuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kgx23xZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kgx23xZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85913C2BD10;
	Tue, 14 May 2024 11:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684469;
	bh=yTtWZcbRRPkLN/Vv/8RgrZgEf13HK2U/83UcFHmXmFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kgx23xZbdya0YJ72V7yRwEE25deb9EavfZdmEM/3Puzg+9oEG0RtHjV7kcfW3fzkA
	 iztsLpCSui+bgOFIsTSYQIxO7NIfOe08XL4AHeU5xL0zjsniJpJHCswhs/tepVs2e7
	 oIF9aKGY9P81rgTOWu+tDscht/sC39IlmjhsedzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/301] ASoC: codecs: wsa881x: set clk_stop_mode1 flag
Date: Tue, 14 May 2024 12:15:16 +0200
Message-ID: <20240514101033.946601347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



