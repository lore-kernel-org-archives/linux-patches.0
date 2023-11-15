Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9193DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMOCwQNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF90C433C9;
	Wed, 15 Nov 2023 20:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078516;
	bh=M0FH9nc/UesJ2/L8HucZuZevfn9R5GrqCj4Ae7wiZf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMOCwQNHcCPtMTWfxjhFiygzMvZqBLMsVl2htLaHjATygab6sUt0eZBELlqI0cc7l
	 fj2U106oc8hLIXQjogImXe//cbltM8PvPVRFWyUZwqxsyCIgRVtZrnozvYyzGCg7aM
	 frEYqVdb8m8p4It7Crqfo+5ouF4aj/pfie2hohVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 370/379] ASoC: dapm: fix clock get name
Date: Wed, 15 Nov 2023 14:27:25 -0500
Message-ID: <20231115192707.048220397@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 4bdcbc31ad2112385ad525b28972c45015e6ad70 ]

The name currently used to get the clock includes the dapm prefix.
It should use the name as provided to the widget, without the prefix.

Fixes: 3caac759681e ("ASoC: soc-dapm.c: fixup snd_soc_dapm_new_control_unlocked() error handling")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20231106103712.703962-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 879cf1be67a9f..6eb8c6cb5e673 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3670,7 +3670,7 @@ snd_soc_dapm_new_control_unlocked(struct snd_soc_dapm_context *dapm,
 		dapm_pinctrl_event(w, NULL, SND_SOC_DAPM_POST_PMD);
 		break;
 	case snd_soc_dapm_clock_supply:
-		w->clk = devm_clk_get(dapm->dev, w->name);
+		w->clk = devm_clk_get(dapm->dev, widget->name);
 		if (IS_ERR(w->clk)) {
 			ret = PTR_ERR(w->clk);
 			goto request_failed;
-- 
2.42.0



