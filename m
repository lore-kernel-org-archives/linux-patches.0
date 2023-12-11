Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62A7FBE1;
	Mon, 11 Dec 2023 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSUNg6NV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF63EC433C8;
	Mon, 11 Dec 2023 18:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319426;
	bh=YhnsODmt1MSG6rqOqdzwu3gMInhth8cHiGYT7qqweLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSUNg6NV2i8UY1PVJ3Bu1e+KcXlI35MsNxt9si9YY+pDhlKRLpEtdbEheRlSXh9W+
	 8IVh8Syg4yT/6QK/JCYfz8ld6nf8u3fhq4GWyrduyZ/7fBPlMWHV5DJhJ5x5G+urdG
	 YrRJuxxNCchz3RyrKnrAOJKpnH1u+Wfr3N/z76qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/244] ASoC: codecs: lpass-tx-macro: set active_decimator correct default value
Date: Mon, 11 Dec 2023 19:19:53 +0100
Message-ID: <20231211182050.269226816@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit a2f35ed1d237c459100adb0c39bb811d7f170977 ]

The -1 value for active_decimator[dai_id] is considered as "not set",
but at probe the table is initialized a 0, this prevents enabling the
DEC0 Mixer since it will be considered as already set.

Initialize the table entries as -1 to fix tx_macro_tx_mixer_put().

Fixes: 1c6a7f5250ce ("ASoC: codecs: tx-macro: fix active_decimator array")
Fixes: c1057a08af43 ("ASoC: codecs: tx-macro: fix kcontrol put")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231116-topic-sm8x50-upstream-tx-macro-fix-active-decimator-set-v1-1-6edf402f4b6f@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 3e33418898e82..ebddfa74ce0a0 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -2021,6 +2021,11 @@ static int tx_macro_probe(struct platform_device *pdev)
 
 	tx->dev = dev;
 
+	/* Set active_decimator default value */
+	tx->active_decimator[TX_MACRO_AIF1_CAP] = -1;
+	tx->active_decimator[TX_MACRO_AIF2_CAP] = -1;
+	tx->active_decimator[TX_MACRO_AIF3_CAP] = -1;
+
 	/* set MCLK and NPL rates */
 	clk_set_rate(tx->mclk, MCLK_FREQ);
 	clk_set_rate(tx->npl, MCLK_FREQ);
-- 
2.42.0



