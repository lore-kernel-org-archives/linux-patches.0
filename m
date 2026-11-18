Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040115;
	b=hRjmwJpW58cDeQEZ2nf6vd8s8GuWut63krBmWgo45LwKMiWqzEK0jqcI8uvHI/X4nlfc
	 KpqUrfkB8i+nhoRgqpkZWsOYmpbGkGrzz+JwveNHJKmYDh6JVMiXAEnq9GVEJkSlbpFCo
	 a0Nn9EBYTTkAOjNPKzR0oTaxE3RF0wbNlAGuuzfF48jXUxA5nxyx4sk+DdS9eyem9uX0i
	 7gsYLNg0xhEAcoQcH7jZTWQDI0goPqTqX6LJJrdW97vk4LjavKW30HttNKwk7YI4IVlHZ
	 //wB7sJXX8L9daoUVxKWwkR02kAdVh+ZROPwY+bO2XoAvmxwWU6OUY2Rc43fuVSRaJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tkUtl2/0gTr/PQ8ckSRs1m1G84KKehzA8jC8XdGSd7k=;
	b=0K9GAhUndCM4fhmdPSGsftlTn/apgJfFgntgGrfm2q7JmqRo/PsenPy8irJ5RftvRXsz
	 3VZsmzNc2jBE/njCFq/b+8GjzwwMkyZkYaR/S2yYfno1hiz8ZJ1wbS7q+4MbU12BrNMo7
	 f6fgViMUb0Y+zBZN+QUlhamOSuXpvpQezA1UOlt1NdlaGPkKThIm8QIG3Ejo8YEv7aWw3
	 8+DvO8yru8YOi/oIbSCPqQyKyGRj2w4aZyFIlsvMFaYxZxpIAQiTGeoNSoXhHvMdB9n32
	 gc2ZCWT+wXEVCRcABocd9iLG7k/hOu0eKjrfByTO+hoL3jk9uw7dT2LnlpzH8D/ZR7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lK8Y4hys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C420606A32A;
	Wed, 18 Nov 2026 22:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lK8Y4hys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F4E1F000C4;
	Wed, 18 Nov 2026 22:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040115;
	bh=tkUtl2/0gTr/PQ8ckSRs1m1G84KKehzA8jC8XdGSd7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lK8Y4hysq+2ASVPsasm+dfz29j9pGAmKmWeeU34hz7HV3mM3VmwyINL4sCLXpY74C
	 Esfc4ay1/ID5Xqq9Iv8Y14PdgxP2MNS4wKDt2EwGMOv5/78TTXMJ6LwgVWCXTpv/a4
	 Zvu38xHavyURKBWxeOU0t4AYepDcvlS5EO47AlEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2342/3318] ASoC: fsl_asrc: use regmap_write_bits to update clock source registers
Date: Wed, 18 Nov 2026 15:49:24 +0100
Message-ID: <20261118150431.887203671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 72dc23c994bcd..c6fc03e364a61 100644
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



