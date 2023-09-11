Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3AC1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE535C433C8;
	Mon, 11 Sep 2023 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441115;
	bh=PZ/VrB+mkpnz9F2oLSaTfpWKq7lX09tVAcgZqfXba7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9BtTSS8b3jz/BVwJIEkC7rkYzU+1pdFdFeVKeJx++8GbSR6/naJd3NoUtbIoF96w
	 827VksmKwl0MLDUwptVhM9tXBZ5jAOzZ0P/vg5NPlivgp5gMxNOApACnWeIM7O/Odx
	 uFOw7NDE/a1R4EcwemdGZ2sIsWcgzbPYDvr/T05U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	YingKun Meng <mengyingkun@loongson.cn>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 283/739] ASoC: loongson: drop of_match_ptr for OF device id
Date: Mon, 11 Sep 2023 15:41:22 +0200
Message-ID: <20230911134659.026910721@linuxfoundation.org>
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

From: YingKun Meng <mengyingkun@loongson.cn>

[ Upstream commit c17bd30d0ba5ca59266771cdfc387f26271a7042 ]

The ASoC Sound Card driver can be compile tested with !CONFIG_OF
making 'loongson_asoc_dt_ids' unused:

sound/soc/loongson/loongson_card.c:200:34: warning: unused variable 'loongson_asoc_dt_ids' [-Wunused-const-variable]

As krzysztof advice, we drop of_match_ptr so the device id
can also be used on ACPI.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202307242008.xqdjgk04-lkp@intel.com
Fixes: d24028606e76 ("ASoC: loongson: Add Loongson ASoC Sound Card Support")
Signed-off-by: YingKun Meng <mengyingkun@loongson.cn>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230726110516.703342-1-mengyingkun@loongson.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/loongson/loongson_card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/loongson/loongson_card.c b/sound/soc/loongson/loongson_card.c
index 9ded163297477..406ee8db1a3c5 100644
--- a/sound/soc/loongson/loongson_card.c
+++ b/sound/soc/loongson/loongson_card.c
@@ -208,7 +208,7 @@ static struct platform_driver loongson_audio_driver = {
 	.driver = {
 		.name = "loongson-asoc-card",
 		.pm = &snd_soc_pm_ops,
-		.of_match_table = of_match_ptr(loongson_asoc_dt_ids),
+		.of_match_table = loongson_asoc_dt_ids,
 	},
 };
 module_platform_driver(loongson_audio_driver);
-- 
2.40.1



