Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024341;
	b=kbG5g98sE5roI/lUFM4Q84ik1Z2W7Kz6x0yYEZeqfoLlI1ckCIZyHsaj9YFJ/PRF57hC
	 gnaIzuzZkOiwwk0CAFkTnxRP6l2ZrJ3fUJ4rLXYTYtKEz/ab5jTEH7wizILFac5iugWIf
	 XxhiwGtcg07gtJC8dvz5jzuLHOcqWSzO49zr6UnJkD3dAsw/YsAUH1tZqG9kKi7HcG1E4
	 /yRcIx4m81ZZO2JdfTFY40tXZmIlw6S8V/5Z/qcl8tUkb+HyiYi5TTGgEmfUMNjZfuSVV
	 /bLXnuRa5cWY+wC3M1H7VxEOyRJB56JBxpx0i63dowluWDxCfCQzQeiGuZIY+NIEu6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=70eWB5wsCiyjvP6HCQ3ZtDdET5opJUgHlTZoIeMAT1k=;
	b=aSbBvWBgCtZp3T+ZDVi9Pz+u7J9hgY8kLohQd0y8MJnMCbc5dcObZdoLhQ0ENZvYGP5q
	 7Qj6CfhQ+DQ/k+SlE4jMLVY6bgz1n2hwfg8MOXyAqhZlD4W7j53GbV+wQEBf9Ofio8BRZ
	 Jc2xtP+NLWPJQ44b6qXCja9bYwMKzlinuDCdMwO+uGOaYtPt9V1f9kLYlRAS/Tg2U4SpA
	 WOPFXeF0oImW8mNzNCbdX50QzX22OVt/W8VJ+1A09LeySMdWle2rlKAoXIReSfgRQzYY9
	 HWzPzARoUofR2WXbts/dwRcL09oHlm5qqDmb6UzuYE9h3hUIU6VXzfvqhG3kaOJoDew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNqZT+a6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9414B606A332;
	Wed, 18 Nov 2026 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNqZT+a6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAA81F000C6;
	Wed, 18 Nov 2026 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024341;
	bh=70eWB5wsCiyjvP6HCQ3ZtDdET5opJUgHlTZoIeMAT1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNqZT+a6taE7jL3uLZa/BupgeyIZQQa37EZG3zXaOEJdoixSxoLqYqL/Bgwo59JJL
	 CxpcrpCvHknTAt26Y+tkFeBS3NUXKiQJUcHZuHlKX+Aqiy3jnbmUC3lTl1mwg59r7L
	 iz9HnLPDCOoFy3LivO+Lc8JCaEnqT74eX5PMTUkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0689/2151] ASoC: fsl_asrc: use regmap_write_bits to update clock source registers
Date: Wed, 18 Nov 2026 15:40:24 +0100
Message-ID: <20261118150146.894503100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 40279becb8d96..be55182071a28 100644
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



