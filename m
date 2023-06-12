Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25949196
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E29C433D2;
	Mon, 12 Jun 2023 10:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566127;
	bh=cviko2KcqNoi5gQ+jv2556p7hXeDOWEezwpNXoGHsgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fj73zzzMF7Wf//C+qlLa654icqh1v+II+81Z/LMQXfji9WOSUVsntSwu6ywaA0KMm
	 ALx7oTFrZgQSZ+RAFGMfmqzkGnnL+xqQSx31q7ju7zUqRiZe+6tyqYhMpjSEWXYREC
	 MbdJgtyk7k6LCaSlECo7J98nbFhh5cbFG1R3665I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 55/68] ASoC: codecs: wsa881x: do not set can_multi_write flag
Date: Mon, 12 Jun 2023 12:26:47 +0200
Message-ID: <20230612101700.722000105@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 6e7a6d4797ef521c0762914610ed682e102b9d36 ]

regmap-sdw does not support multi register writes, so there is
no point in setting this flag. This also leads to incorrect
programming of WSA codecs with regmap_multi_reg_write() call.

This invalid configuration should have been rejected by regmap-sdw.

Fixes: a0aab9e1404a ("ASoC: codecs: add wsa881x amplifier support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230523154605.4284-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa881x.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/wsa881x.c b/sound/soc/codecs/wsa881x.c
index 15b3f47fbfa35..9f66f6dc2c67f 100644
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -646,7 +646,6 @@ static struct regmap_config wsa881x_regmap_config = {
 	.readable_reg = wsa881x_readable_register,
 	.reg_format_endian = REGMAP_ENDIAN_NATIVE,
 	.val_format_endian = REGMAP_ENDIAN_NATIVE,
-	.can_multi_write = true,
 };
 
 enum {
-- 
2.39.2



