Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00335102A;
	Mon, 11 Dec 2023 18:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jgm8SCZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B5FC433C8;
	Mon, 11 Dec 2023 18:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320569;
	bh=I/JkLiPUPxvIMEryG+S71Gu8X9e78S0Q89VsCBDfHe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jgm8SCZ8XYyyH2Cnum1GptXq+OH6cAlCvKlzMiZCQw1Lhzm7PCKCbtjZH93oCQcfv
	 pMSUE55TLM6F/a7MQb+FDjfqK1NK5zkQ/TSdvv4cz4LJXgwrmjcfM/Rms1AvqL3fMF
	 gqWPWVTtoitqWFbbav3r59sLHQ5itXIhvNCRXeXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/194] ASoC: codecs: lpass-tx-macro: set active_decimator correct default value
Date: Mon, 11 Dec 2023 19:21:11 +0100
Message-ID: <20231211182040.096167349@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9f59518005a5f..840bbe991cd3a 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1871,6 +1871,11 @@ static int tx_macro_probe(struct platform_device *pdev)
 
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



