Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445091C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A984C433D7;
	Wed, 23 Nov 2022 09:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194865;
	bh=uRIb+m49OBhCrmfBdz8AcUfRxXEcuxfqhSK8uAUYD6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJcecDPbJLZC+AAKrEfl9PbAjw2wSQRGuWumVMdNGk3ntOsH4ok/oYESAzPuwB5Sf
	 b1rb3m7qOVaRVhZJraRbVsff6/gusjlUrhsTHsjOOh2elHyNhRKQVM49VWp1pGj/C+
	 ejbEjGp5c4eEbXOQPmVDcsbQ5JbfA9hTQ8BVhsz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/156] ASoC: codecs: jz4725b: Fix spelling mistake "Sourc" -> "Source", "Routee" -> "Route"
Date: Wed, 23 Nov 2022 09:50:38 +0100
Message-Id: <20221123084600.940520618@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
index ebe643e4aa2f..48c40a44b763 100644
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



