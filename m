Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017196;
	b=CVaFM3pnBJH/R2QKJZC/QNMYVjMWT8Lxag06dyNTppx6Bz4++B29sUDzPSImWDIHrWLC
	 dOw8OwUCjtwCl2tl+lDn58NTjK2yHYIIUWVkx2KkXxfdL58XhMwhBDaVRc2wrwgAYs+io
	 5/CIgYWtfrYbdrXtBi1uDJ8Y7sG++Ud/EC8Pjfw4UKwbAviWb6n3/OAEAwrrMrBo1FF2t
	 Bf+N0clpfOZnsEyF0hdub+xHHjIVCEV2YejiR2y1MoVvAClEIns8Ld0G0l0FOA994L08h
	 9RTXWt39aW6Dlag48pfUW6S/vJp56ayenpbt9PzVjS0FESNoidf3cJD3wgxzpqAnEFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/rOPRmHOBD51nBFjwZy8hfoAG7BBvzJ16fo9yqbUZRU=;
	b=y6Ru0oXpekdfqLj5FORrbamR8aataNWfiMRLwf6CrdNre9H1pfXqUMIvXDXpK8sTwFqH
	 KZHI2h1HKyn9hFHmZyU6gos1+pOAzlJ8iu0AC8I0Yvvn9L1/MuUdD2+7yL89+Gi8UlxOy
	 +6ElRvbko1WsPKMMIB0U45hRz+pWmIC4jASl9eoti/yLeHRdx9BDat4X4azSe5aCal/OW
	 56QCBhSPBf5XAmP55GLNPSNm3KRHxxMjdoVqgI1qjQCmdnXtS4MBpoE3EFEEc2WaYfXqr
	 ENRhT+mh2cCWlraaoXS0xpbRvZ67VFJYM9PKAebtjStAbXQADDw27Kqvqv9nlY27mIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yLt/LMXq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB866606A31C;
	Wed, 18 Nov 2026 15:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLt/LMXq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110901F000C4;
	Wed, 18 Nov 2026 15:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017196;
	bh=/rOPRmHOBD51nBFjwZy8hfoAG7BBvzJ16fo9yqbUZRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLt/LMXqGrZ7lItH+NCejHxEAPXdSgeaTOTtfzFXDZYV6j+4TtxmocJTe1xqrJgIH
	 APaS8x2I0CO6IOVaYnTIEyc6AT/F54/wkEh7SWcjYUFhY/0TmUW+3P/lGTSPlLpq4s
	 0zjLzCPTSjS/DhDJgwFQFgqYdIIPeKlkJr0q+j8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0781/2651] ASoC: fsl_asrc: use regmap_write_bits to update clock source registers
Date: Wed, 18 Nov 2026 15:33:41 +0100
Message-ID: <20261118150316.005584195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b24737add001b..d80afe1bf4be3 100644
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



