Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055352;
	b=cKUOzXP37xx1YUI53ZOW9glN1OgrRLvqkSifbaoqrcMXczdBvXRcthbWAee95PIROs7E
	 JhEFpJix6DtwtzG4hsLHSPK18dyxd6n6UlWnwVID4PLS0uLj0pX0bNGYgw7OZGVASZydL
	 irXS8KFJIZdXHsaIEXTmygxtOaE+Iha/r7NZ76Dkobh57Sf4emT18iIZhmjHN9U3/wrfz
	 QKxL47ytftCbp/b/xbGvf/Z9DmdBJugGPSiqvzeB9QCl2+h3K9jSDZe9chSklS5vP5oPE
	 NLZfPh9rpY/CSggPzX8+7nabRoLnFAcaN0B8SPz4SSF3y+g3PelyROUgf2Fs6UND8Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C/L0z31Pf9TJlQmAog9YAVl2nlm+/pc3Qu/5je7/hh0=;
	b=Lr6Yg640eGoP7xySHbi36R4DNI05jCtUp8I578I7Rvda+kdy1JIARYHXur2AKt5Oc86V
	 XTBdpH7qYl4VEzSwhi9wIbKh1maTTLGOIZgk4EPBgoIshCAKoB6zedqYyNYF+95euIG3A
	 Vd9qugqGUiU1NyFythyVCn2tVKrvrPTvEkdVak/2hx0klpIDYpmLHZ0+/eRtTmd+KMqii
	 rhVlE7FeqzZndotxolPFLVRGvsIyuXzs5PY04T4WaKGLZhorieD0C8siVuGGwz7LI1FdR
	 QCUiIdjmA4cC27cahxCCHJB4w784V4dOvzzT1XblrgIh9Emov9NoM0Un+8w2aJ0t1fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLpMIudZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA867606A33E;
	Thu, 19 Nov 2026 02:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLpMIudZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EAA1F000C4;
	Thu, 19 Nov 2026 02:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055351;
	bh=C/L0z31Pf9TJlQmAog9YAVl2nlm+/pc3Qu/5je7/hh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLpMIudZcjoGl4b45tBqI/2HJT5VpUv8vc00l/I4cQKxEyDGtj6HFSjoL4xt8GftT
	 ONXgUeMS1Pmp2ZPlZrXoxcFXLxwxEPJtuqpE4jzhLTQnA0YIskpSbRq8ozg6rJDfx4
	 tjbo3fMtV8hsUAxUfQYLMUUdcXum9ud6umlYiSEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1593/2214] ASoC: fsl_asrc: use regmap_write_bits to update clock source registers
Date: Wed, 18 Nov 2026 15:54:29 +0100
Message-ID: <20261118150115.705961690@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3f36e3d2d9a20..a98cf1bef1117 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -517,10 +517,10 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
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



