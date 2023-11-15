Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA583C470
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qF9mJljh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FD2C433C9;
	Wed, 15 Nov 2023 19:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077143;
	bh=UstgYHvvids6YVIQD3nnE4oCE4MTZKFtXmaNALB6aH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qF9mJljhVBgJdL0IUQxRX37u8i8D91J4jlKySVqcGGnZue3HpF9cI8v1dNjBmh8OX
	 RUrzp9TnOlVhD4n3DvtdLJVK+cm2zAQUtyyzHCE6ANX/VaNDWxp2Hd/F0LjbmbXhVc
	 0bAnZI6S/XX6UWARl19EcBOJ2Mly/C0x6RounkK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 535/550] ASoC: dapm: fix clock get name
Date: Wed, 15 Nov 2023 14:18:39 -0500
Message-ID: <20231115191638.031131432@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 5fd32185fe63d..de279e51dc571 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3668,7 +3668,7 @@ snd_soc_dapm_new_control_unlocked(struct snd_soc_dapm_context *dapm,
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



