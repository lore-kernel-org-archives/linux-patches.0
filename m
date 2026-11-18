Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048677;
	b=f5AYGslfd2h4mvLOMTY1vT0EdRTeIJ1mxeEKach5ytuwLngIHlx3i10T0Eiw6RtqC+SE
	 W3cj7vkL3OvyuWp1cqfBsmsKeDfOLC089wSqF3MxDR9BHyYa7o11MoDac6LzEvJH5kenb
	 G1lCk8lqBc0rNGTMeLL34s5Z+7+0/HahpqVL/cbWcNlDYN7H8ruGZwLDb3UzU7Ebat83y
	 lNbKPrYGydGlbGuRBOuDqoAuRsa2UNyG8RdsdNMUtia+W8MEhMM7WRBvbH26t7HlSuosD
	 WmeSnOZARNq1jbLim0Wbzo1Zp+AvuWrzEWe8e6ekBmsgbDQ20IjIhuYjkMeUKiTwl1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TSGJ4PJujFQeypeB0CZf72ukj98dyMqnSOK4V//8j4A=;
	b=XFUpIRfvjJWKBxIOGKEftUP9/zSNqpHXTFv6T1b2go+krCsuS7KlcubYAq0R7fMKia6P
	 QJE4hnXCTvPSfnzBvflEUaBH0DkY/8U89mL3hi7rLnxwIE8E4dos7Iro5cuYMOI3jvkkJ
	 F02ABYJmaIZ9hc2sdCKfIARPYg92CSUzrbwMOZTdPqJhii4uwB8rtBDOLAdPmMDgvuR0p
	 Rpt9OnqQiT58scqhWPHOJ748K4gW4hKJ4QiqqWkgjqZSXtxDrB+w5PgTDLxpbUzxfWcex
	 t012GkX9IvFYxvlAZYGmb7skVO5CrnZlQP7DSoNqv93Xed3X9rqfpvBH49W0oI16j0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kJo9EMke;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54F0606A320;
	Thu, 19 Nov 2026 00:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kJo9EMke
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C937E1F000C4;
	Thu, 19 Nov 2026 00:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048677;
	bh=TSGJ4PJujFQeypeB0CZf72ukj98dyMqnSOK4V//8j4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJo9EMket9R7Med723RJ9Z3btyhQ06d6fWQplHQQyD2VXFM/wHIi9AW4+nnIyo1ht
	 C2MaQhLtk4Tlha1dnKCcPpLHOGir4GMDVfGtJkzq2g3SWtRJEGG9sgrOJhqeB5BWBj
	 3M6Rz06Y6ffRrNcKKO8K3yM7T7WPAx2uNJIrRzlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2040/2857] ASoC: fsl_asrc: use regmap_write_bits to update clock source registers
Date: Wed, 18 Nov 2026 15:51:14 +0100
Message-ID: <20261118150314.865190376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 92871abc1302b852b88d86114115f8fd6b50b9b9 ]

After a warm reboot the REG_ASRCSR register may not be in its hardware
reset state. regmap caches the register value as 0 (the assumed default),
so when the desired clock source index is also 0, regmap_update_bits()
skips the actual hardware write because it believes the register already
holds the correct value. This leaves a stale clock source in the hardware.

Replace regmap_update_bits() with regmap_write_bits() so that the masked
fields are always written to hardware regardless of the cached value.

Fixes: 3117bb3109dc ("ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and platform drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://patch.msgid.link/20260916094043.1496709-1-shengjiu.wang@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 3ec5b88bd9a29..4a1229c29b2e2 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -521,10 +521,10 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
 			   ASRCTR_USR(index));
 
 	/* Set the input and output clock sources */
-	regmap_update_bits(asrc->regmap, REG_ASRCSR,
-			   ASRCSR_AICSi_MASK(index) | ASRCSR_AOCSi_MASK(index),
-			   ASRCSR_AICS(index, clk_index[IN]) |
-			   ASRCSR_AOCS(index, clk_index[OUT]));
+	regmap_write_bits(asrc->regmap, REG_ASRCSR,
+			  ASRCSR_AICSi_MASK(index) | ASRCSR_AOCSi_MASK(index),
+			  ASRCSR_AICS(index, clk_index[IN]) |
+			  ASRCSR_AOCS(index, clk_index[OUT]));
 
 	/* Calculate the input clock divisors */
 	indiv = fsl_asrc_cal_asrck_divisor(pair, div[IN]);
-- 
2.53.0



