Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26CF11714
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4DFC433C8;
	Mon, 11 Sep 2023 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440856;
	bh=p5kZRJPy6becEKGze/E8wQRGvbD8Pps2B78lYscLjgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gEUxzg3i7Fv/sYGlRhvZkR9zt580f1oyVwDKsWxzSrTyfJj0/vjZWf7YCA5JE8TA
	 LWSBnCLxbEz+GXYf6rICJgEUi4ZQwCy+ttE8yh9uA1T5WxW3BpjjYDqca8+dp5d8II
	 YUnRC+HFO9qiqXXUoKpdlzzcSKg0HnbvWUr9iI08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Mark Brown <broonie@kernel.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	alsa-devel@alsa-project.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 210/739] ASoC: stac9766: fix build errors with REGMAP_AC97
Date: Mon, 11 Sep 2023 15:40:09 +0200
Message-ID: <20230911134657.044890830@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c70064b96f509daa78f57992aeabcf274fb2fed4 ]

Select REGMAP_AC97 to fix these build errors:

ERROR: modpost: "regmap_ac97_default_volatile" [sound/soc/codecs/snd-soc-stac9766.ko] undefined!
ERROR: modpost: "__regmap_init_ac97" [sound/soc/codecs/snd-soc-stac9766.ko] undefined!

Fixes: 6bbf787bb70c ("ASoC: stac9766: Convert to regmap")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org
Link: https://lore.kernel.org/r/20230701044836.18789-1-rdunlap@infradead.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index c2de4ee721836..947473d2da7d2 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1708,6 +1708,7 @@ config SND_SOC_STA529
 config SND_SOC_STAC9766
 	tristate
 	depends on SND_SOC_AC97_BUS
+	select REGMAP_AC97
 
 config SND_SOC_STI_SAS
 	tristate "codec Audio support for STI SAS codec"
-- 
2.40.1



