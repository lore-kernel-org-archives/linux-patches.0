Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B791C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE69C433B5;
	Wed, 23 Nov 2022 09:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195223;
	bh=5dDY1NPJIyPb8sR50fuoCWdWQ9FzrjWaVcV9w/BadrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMZ+rNL+CDNl6Xo0IANg1qoWi9zgPHSgwdWgT2WfqW+nTqsfH2f2UP9XRoA107Cz9
	 BW697K0JkVfWS2WBBKSj4A9ZQwkM8DwGK7jywhX64dVRMV3A3CftjpJN7LQG/k9PR1
	 BO4qCcoSUMiCdmSd4vQHVUU1OC2pdc1tft+XNJ4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/149] ASoC: codecs: jz4725b: Fix spelling mistake "Sourc" -> "Source", "Routee" -> "Route"
Date: Wed, 23 Nov 2022 09:50:06 +0100
Message-Id: <20221123084558.851052845@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit df496157a5afa1b6d1f4c46ad6549c2c346d1e59 ]

There are two spelling mistakes in codec routing description. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20221019071639.1003730-1-colin.i.king@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/jz4725b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/jz4725b.c b/sound/soc/codecs/jz4725b.c
index ab744e375367..8a830d0ad950 100644
--- a/sound/soc/codecs/jz4725b.c
+++ b/sound/soc/codecs/jz4725b.c
@@ -288,7 +288,7 @@ static const struct snd_soc_dapm_route jz4725b_codec_dapm_routes[] = {
 
 	{"Mixer to ADC", NULL, "Mixer"},
 	{"ADC Source Capture Route", "Mixer", "Mixer to ADC"},
-	{"ADC Sourc Capture Routee", "Line In", "Line In"},
+	{"ADC Source Capture Route", "Line In", "Line In"},
 	{"ADC Source Capture Route", "Mic 1", "Mic 1"},
 	{"ADC Source Capture Route", "Mic 2", "Mic 2"},
 	{"ADC", NULL, "ADC Source Capture Route"},
-- 
2.35.1



