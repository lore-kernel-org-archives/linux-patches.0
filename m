Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B15A30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72C8C433C8;
	Wed, 20 Sep 2023 12:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212736;
	bh=QMipyxAv8nVB+R6nveI0/OwK6SaTYzEkObwCZe9E8Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeeReAUSWk2gRaZHKwpSr1+TV2F9X58Mo9/QGFDShzwYjjna7XGccUKJyfKwbanTK
	 7MZH09yn1PQ1S/yc/dnTlx4sIvRQBpMgStWBUxxqn2FHNhlAGNEviWttMa7mmFbt4m
	 ENk5y6vfPlexJnfGbW3rqVdMRKfhS92XdstCGW90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edgar <ljijcj@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/367] ASoc: codecs: ES8316: Fix DMIC config
Date: Wed, 20 Sep 2023 13:26:44 +0200
Message-ID: <20230920112859.223283343@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edgar <ljijcj@163.com>

[ Upstream commit d20d35d1ad62c6cca36368c1e8f29335a068659e ]

According to the datasheet, the DMIC config should
be changed to { 0, 2 ,3 }

Signed-off-by: Edgar <ljijcj@163.com>
Link: https://lore.kernel.org/r/20230719054722.401954-1-ljijcj@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index 131f41cccbe65..dd2df9a903e05 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -153,7 +153,7 @@ static const char * const es8316_dmic_txt[] = {
 		"dmic data at high level",
 		"dmic data at low level",
 };
-static const unsigned int es8316_dmic_values[] = { 0, 1, 2 };
+static const unsigned int es8316_dmic_values[] = { 0, 2, 3 };
 static const struct soc_enum es8316_dmic_src_enum =
 	SOC_VALUE_ENUM_SINGLE(ES8316_ADC_DMIC, 0, 3,
 			      ARRAY_SIZE(es8316_dmic_txt),
-- 
2.40.1



