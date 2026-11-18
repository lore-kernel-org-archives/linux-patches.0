Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060830;
	b=PNqM9kbVPWogVYdpsXFI8eUl2GN3kdBJIEmekSXtMARK15Soqa/DP2rs0XEdtt+QDnEX
	 bxMabGoQPGo1PjP5unYCtTottStzXLZyFGC5I84whzxw7MbJlqNlOeP9Qv7YyWhwESDWt
	 aFU+iQnsCVygxXORIU1iT2ZgCvjidP4iB5YfhJzPv4MUowe8/ecgKC4Bxzx8hpRlwjHm1
	 P6DuWvzLdiNTiY+gl3KxbiGyM+GnfHAs9h3lV6o/O+3g/4Groa6X7Wgw1U/3T73aSH4jZ
	 5vhUpWy/gROsTHA24OJAe1zFsSmABp4ZDXJfHr5jebrtlDRxhgRXyySDfM0nfRftojQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t3fjEZ6/kUuctse88gx0IIKIOw6eZ5ZEUXaD4i4u3Zs=;
	b=P3Mb7n+M7daxAVbkiqWIrhcQTz3PLL2otxvf6YJT5n5CUzNgiX/CJAvst7uXsg7wZWxq
	 3uPV+o/kiLhwEknv5eqGwuEucwJ5r4mBA2/OqEnhUAfDKabhS3FBbLa6Yt3jZC7gXLHFi
	 +QVw6mYEkpNt6BHLFMHHsUgUh80BXg/Iok0hXRUVoi+8tBVmE0Hoz59n7yS4tmjWHRgR7
	 ejCU3UJOTW74xMzcGA31UNXkUvU/94dZ1oZ+aIvG+zg8oKbvq0b3GuiquAVwRJW/+vGJz
	 Wcj/VA2K1VO+xIk/lDdjRFAgei67962kcm2ODL18GVWBt1iL1+pHAZxyZrX5i5UKjPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y01c4JST;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2779A606A325;
	Thu, 19 Nov 2026 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y01c4JST
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8262E1F000C4;
	Thu, 19 Nov 2026 04:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060830;
	bh=t3fjEZ6/kUuctse88gx0IIKIOw6eZ5ZEUXaD4i4u3Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y01c4JSTTQE8snLXfsyZV81dR7/Bs0s//F+syf/gMI86CjomK274lTcKVCS/w6gRe
	 atXT2D56B+lNeJ61WVctjHyNBzv0VP5kf6l+M5L8KiUPa6EbhJK9N5xLzc4W/eyx3j
	 SBudF0ilRT3KydG1pHNqILSi1oMIVCieABB18/aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1340/1848] ASoC: fsl_asrc: use regmap_write_bits to update clock source registers
Date: Wed, 18 Nov 2026 15:56:18 +0100
Message-ID: <20261118150015.798469679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cf6d3c549707b..45879c861ddf9 100644
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



