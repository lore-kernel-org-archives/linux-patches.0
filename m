Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0025134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E43C4339B;
	Mon, 12 Jun 2023 10:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566647;
	bh=ZmUaaXT7VrsTT+oBEVLg1mVfw4WlHlUAyC9bKJZIVnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGQJJdQwS57qVTPIZgOIbCmrt3zmn9Nuph753AjaHEIgL1jHd+pZmhLMT2GuXeYQG
	 fuFPXkBm1BFPzKphqVdvg3rGAa5SzZ1e+Pus7UQa24vpvPVD1/E3v1/ojBj7KLVye6
	 1GslLFH2CZUAk8pWi06ny/NwKSl3dwN7XiumH6yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/132] ASoC: codecs: wsa883x: do not set can_multi_write flag
Date: Mon, 12 Jun 2023 12:27:18 +0200
Message-ID: <20230612101715.039212268@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
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

[ Upstream commit 40ba0411074485e2cf1bf8ee0f3db27bdff88394 ]

regmap-sdw does not support multi register writes, so there is
no point in setting this flag. This also leads to incorrect
programming of WSA codecs with regmap_multi_reg_write() call.

This invalid configuration should have been rejected by regmap-sdw.

Fixes: 43b8c7dc85a1 ("ASoC: codecs: add wsa883x amplifier support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230523154605.4284-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 6e9a64c5948e2..b152f4e5c4f2b 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -950,7 +950,6 @@ static struct regmap_config wsa883x_regmap_config = {
 	.writeable_reg = wsa883x_writeable_register,
 	.reg_format_endian = REGMAP_ENDIAN_NATIVE,
 	.val_format_endian = REGMAP_ENDIAN_NATIVE,
-	.can_multi_write = true,
 	.use_single_read = true,
 };
 
-- 
2.39.2



