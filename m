Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211499;
	b=As8fg/9qp39vjEOSKkuk4IUgotjMiyGeLoVi28TX/7oiL4aPGcK1c95MctuR79ExOq67
	 AxYB6dVeOdDgayHyO/k8rk6/F5ESa/Sk7+hUxJxLD3pWHSe22rlr+Jma6CC+WHfTjxRmm
	 582CJDAVtCmTUV3D7obeGujt/GtN7M/7Ag6vfmpMBXd+74uUYUTTSBIeGrgUyvGRlsHbB
	 Y9mAlAcamXPFTQWXp0yyPz+4pz0t+NF93ic0eNYOJmL+D6F1dyaQfEzQkBsAwmcSwoTgo
	 R18lqGfVglQed8H5BNmDmMU+xtC4tAJA8mkjAIS4j9X0YEDK/HZ1Y6n1BoDnfg0Iwwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZeiupiaVj9TQ6F2S9CJWA2Lr4DLULZv004PKIDXWsV0=;
	b=HuWk3rIF3d9NvC1B3dy59DihZ3bMZdLdXVy4LVGpCNKs8FAneetWTJgBstji40l6fsqQ
	 oFGR6WUBXewPwY3+X4xx8Fm+miB/lmyGXc9x6otUtG0689fBNaDZ12Bhndsu8tzSkcUK2
	 LqeqNyOe8T+k8K7OVMYYe1YEufjk9naTC59VyJreVmdl+7oNYuYzkurRimeGabJYL9uxU
	 zXUnMEnCbigjxrUZNFh6+TnZ5H6QAEhSIMzgJUvnfBCF3Zk3dYoEWm3+8O1uc+U+ce6wZ
	 eM99xl9Jx1r0+bwFg6wyZlt58ALSUlmTETLxgajhedMmnmpQi7uEGQSFdhJA747cdMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7+d0HxF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EF2606A33B;
	Wed, 28 Oct 2026 18:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7+d0HxF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DAA1F031E0;
	Wed, 28 Oct 2026 18:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211498;
	bh=ZeiupiaVj9TQ6F2S9CJWA2Lr4DLULZv004PKIDXWsV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7+d0HxFzPfKZn2CgybT5o88LSsTeGJNF9rWOW4AAEh/iYKeGQmktuX5qnU7zDkQl
	 szz28Swlr0LQEb+3Xmvbddo/9ugOdG+kVZA+lxJRTjigGpiAvUEJvwZi/tK2jUujjs
	 dcmPPgx/Ul2p+7qspPREGHjgdYAK1KDZ/65TU69A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/571] ASoC: adau1372: fix invalid default state of output ASRC and DAC muxes
Date: Wed, 28 Oct 2026 17:59:05 +0100
Message-ID: <20261028170017.456694174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Šipraga <alvin.sipraga@analog.com>

[ Upstream commit 36d0e05815ce84266c8b138cd4f84c3feeaf15f4 ]

The chip has strange power-on reset values for the registers that
control the output ASRC and DAC source muxes - the values are actually
marked "Reserved" in the datasheet [1]. This means that until the
underlying kcontrols are modified, the codec will not function as
expected.

The registers in question are:

  register / field       reset value       valid values

  ASRCO_SOURCE_0_1       0x10
   ASRC_OUT_SOURCE0      0                 4 .. 16
   ASRC_OUT_SOURCE1      1                 4 .. 16
  ASRCO_SOURCE_2_3       0x10
   ASRC_OUT_SOURCE2      2                 4 .. 16
   ASRC_OUT_SOURCE3      3                 4 .. 16
  DAC_SOURCE_0_1         0x10
   DAC_SOURCE_0          0                 12 .. 13
   DAC_SOURCE_1          1                 12 .. 13

Set some sane defaults during the driver probe:

  ADC Decimator0 -> Output ASRC0
  ADC Decimator1 -> Output ASRC1
  ADC Decimator2 -> Output ASRC2
  ADC Decimator3 -> Output ASRC3
  Input ASRC0 -> DAC0
  Input ASRC1 -> DAC1

With this, the chip will behave as advertised by the default kcontrol
state exposed by the driver.

[1] https://www.analog.com/media/en/technical-documentation/data-sheets/ADAU1372.pdf

Fixes: 6cd4c6459e47 ("ASoC: Add ADAU1372 audio CODEC support")
Signed-off-by: Alvin Šipraga <alvin.sipraga@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20261006-asoc-adau1372-fixes-v1-2-599cc17fb5f6@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau1372.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/adau1372.c b/sound/soc/codecs/adau1372.c
index 4cd30dc35f429..ede7a94cf16a6 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -999,6 +999,17 @@ int adau1372_probe(struct device *dev, struct regmap *regmap,
 
 	regmap_write(regmap, ADAU1372_REG_OP_STAGE_MUTE, 0x0);
 
+	/*
+	 * Set sane default values for the Output ASRC and DAC input muxes,
+	 * since the power-on reset defaults are invalid "Reserved" states.
+	 */
+	regmap_write(regmap, ADAU1372_REG_ASRCO_SOURCE_0_1,
+		     0x54); /* Decimator0, Decimator1 */
+	regmap_write(regmap, ADAU1372_REG_ASRCO_SOURCE_2_3,
+		     0x76); /* Decimator2, Decimator3 */
+	regmap_write(regmap, ADAU1372_REG_DAC_SOURCE,
+		     0xdc); /* Input ASRC0, Input ASRC1 */
+
 	regmap_write(regmap, 0x7, 0x01); /* CLOCK OUT */
 
 	return  devm_snd_soc_register_component(dev, &adau1372_driver, &adau1372_dai_driver, 1);
-- 
2.53.0



