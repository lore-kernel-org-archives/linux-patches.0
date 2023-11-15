Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC20D35F19
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGQ9TYE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB69C433CA;
	Wed, 15 Nov 2023 19:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076608;
	bh=/xFteLgLDumhIfmtiYuDUiytP64QIKL2LocD1lYHvu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGQ9TYE/T3fEPqOlPSXjAPoutQbLXltG1hkkpNkMqmMJicj51Di2lmq6URSM1nAa2
	 TGAfhwt5PPo+3UYdZLNezOI2vFkwn46r5Y9CR/IodyB7iGArx6C2ZIIpdh/neZ7Phz
	 M7+/xMpyMr7i+6gjFy4NryQEKFpVqA7hw0K37RdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 337/550] ASoC: Intel: sof_sdw_rt_sdca_jack_common: add rt713 support
Date: Wed, 15 Nov 2023 14:15:21 -0500
Message-ID: <20231115191624.121996672@linuxfoundation.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit b6d6e5abf64562985fdbbdbdfe8088cde634d834 ]

Adding rt713 support to sof_sdw_rt_sdca_jack_common.c.

Fixes: fbaaf80d8cf6 ("ASoC: Intel: sof_sdw: add rt713 support")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231012190826.142619-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c b/sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c
index 623e3bebb8884..4360b9f5ff2c7 100644
--- a/sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c
+++ b/sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c
@@ -58,6 +58,11 @@ static const struct snd_soc_dapm_route rt712_sdca_map[] = {
 	{ "rt712 MIC2", NULL, "Headset Mic" },
 };
 
+static const struct snd_soc_dapm_route rt713_sdca_map[] = {
+	{ "Headphone", NULL, "rt713 HP" },
+	{ "rt713 MIC2", NULL, "Headset Mic" },
+};
+
 static const struct snd_kcontrol_new rt_sdca_jack_controls[] = {
 	SOC_DAPM_PIN_SWITCH("Headphone"),
 	SOC_DAPM_PIN_SWITCH("Headset Mic"),
@@ -109,6 +114,9 @@ static int rt_sdca_jack_rtd_init(struct snd_soc_pcm_runtime *rtd)
 	} else if (strstr(component->name_prefix, "rt712")) {
 		ret = snd_soc_dapm_add_routes(&card->dapm, rt712_sdca_map,
 					      ARRAY_SIZE(rt712_sdca_map));
+	} else if (strstr(component->name_prefix, "rt713")) {
+		ret = snd_soc_dapm_add_routes(&card->dapm, rt713_sdca_map,
+					      ARRAY_SIZE(rt713_sdca_map));
 	} else {
 		dev_err(card->dev, "%s is not supported\n", component->name_prefix);
 		return -EINVAL;
-- 
2.42.0



