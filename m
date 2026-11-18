Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030104;
	b=4X5q2z+FI+68fnLoWPADhnV2LPCKuQRXsyiCnOmX6UtiMLnF2P4OsF3kP+ZF/95+/WNd
	 cvFyFuppvhoCe+L4jnt1r5R+JIvAcmcd8LxMJMmBiN9DljWKMZnJXQywPhiEkw01p4jQQ
	 TCFu1+ovTLbuEMXI4ZoM36Z352AHfwzQQLmpCr/mK7kLATrr8NR6D62jSFxUtR9E/Mb+7
	 jMysqXZsMhAE87aHeTbI3EXto4v5ADzu2WpMO7O4fi+uqEFnoC8UIro0mDsL+Rw1iLCdn
	 9GmoanfA0p1RLo/l+KPAlC+UCf8qbgW/pt98ah77OGEGQIl9IjlHClcnlRGKIcZJVuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ky+vqAjgJMTc7v1KrfkqHovODDbb4u/jhNCmOsRszrU=;
	b=HKa4rQ8ns2DBwjkmT5alVCGwsuZSsB/6JYTz79WX7/33G0ns3TXeAfJYE30ytV1N3Wo2
	 h0GpkyHeYOHPHxpWFV/AIyt95bB8F+v01zzid2sCqtsRMUN7hOb/mSK6nLqVeSRybyKcI
	 VYh78HNl2+Av1dY4yBkSa3s4wDTfyso1WUHEdPQbzFSbyOaDmZ3l1VYQHYVNTz/ys3TBg
	 b/U51LLL2zn3F4vbEuOL4RpOjr9GL0qNoaJTTrUKFPj4LwlvfiaUn4EbzUhgQgmYFB2+P
	 CpY3K/wbuKydQ1kvWlRhVhmS3F7PZT/TNvOAMp4dZ0/HoIsCaI2sDiadfVzrUvm6DWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sO2tPe8q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D5E606FF6E;
	Wed, 18 Nov 2026 19:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sO2tPe8q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D5C1F000C5;
	Wed, 18 Nov 2026 19:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030104;
	bh=ky+vqAjgJMTc7v1KrfkqHovODDbb4u/jhNCmOsRszrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sO2tPe8qIhdnN/Gd3CxlEzOly1WzhJ06I376aBa1cyn8WSU7o7v63fcIbhqNt2gng
	 u2j/unH6is2ke81PxgoiRE2c/p4/DSuQkvrRSZUk4xBnksokTV8ZYUF8i47nQcCD7I
	 xOX6xIpo5aX4X+IB2QnxBkhZCX1j7vo7Qtja2S8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0559/1756] ASoC: fsl_asrc: use regmap_write_bits to update clock source registers
Date: Wed, 18 Nov 2026 15:44:46 +0100
Message-ID: <20261118150031.343589154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ffd4a6ca5f3cb..f68b53ba17dd7 100644
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



