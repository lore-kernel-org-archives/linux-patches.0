Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042655;
	b=JRhfEM9CdxpVTyg3sNbYRbByyVgXAK+nF9hN2Oayp5+SxmCkgonFc9FAnRCzZsR6vY7T
	 zFQOpPSvxjChyEpKTDFfjYDmGMws3cSkLmmAGK6xVEql670/iLVU5RGoP0o3BxVqyC9gO
	 ckrXDG+DCZfx6V9eHrgQ5J2oiGOB+2m89QUzIeVIowOHElv2GiyJYK3e3s1lXZGsmjE22
	 icUqe50qL/W1WDfSYyjlf69WXJXvn7SfSKDtpLwGGS88IfcEg5CIkKkLfWsqVqjgxAqpN
	 4v1b8Qo5u3GIPC0+x2+nBccvqbKQxGHzJI5liWt1Fvx6TPeXxJ1z4mqkwIqJyDvjKYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Zm5T+nsNoooK5wQoKSI2/FFn0wFqTAb7brnVm4Y4Pw=;
	b=YVuz6bWJkhjejE8nkGSWj1itP2+bXTDd4xRkMHDpKrvRSoyJqz/G1ohCdeZdMfxSVQzc
	 zKXAZt8M5adnna2u7Krn9deypO4jzLzNCqIASA2ynUH64gbLyePu/E4zMbz66gjWvK0gV
	 JChFZGL2ImP0lOZfTi1jBHhvdVC4Uo/1A39fLtjn6JImyn2ibeUuQvJndvOf2+fwPgIU1
	 puR76Owvo6RURh1sydqBorO+AQMmtklLuA5o6wAWCF8DYVpWy5s1wfBNiFOtnX3wnBRH3
	 CyvmSpmcqWgZ/iV+/fWuJVotaVgH9MZDvP3+OMHCxG6SFYiiRIH5FghQJecAIxBgn/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zplE+0nu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00872606A320;
	Wed, 18 Nov 2026 22:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zplE+0nu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516571F000C4;
	Wed, 18 Nov 2026 22:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042654;
	bh=2Zm5T+nsNoooK5wQoKSI2/FFn0wFqTAb7brnVm4Y4Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zplE+0nueod/rQjCshFBk8FTXHgE3UY+m34WMqjnEKI2IjUgeUbOicRNjPeo0oItP
	 jugm04QLNQWwbsP8l07SkAdAslQqqs/TW5jcgaa/JQyRwRSWNzzR1+iCKsmh7NCMw7
	 0Rp+BS8aBDfqbiitOuaDStdU5Kf1uqy8NvT7+Urs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	"Gaddipati, Naveen" <naveen.gaddipati@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3207/3318] ASoC: xilinx: formatter_pcm: Fix read-modify-write of AUD_CTRL in hw_params
Date: Wed, 18 Nov 2026 16:03:49 +0100
Message-ID: <20261118150455.956980416@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3b54e739273752b370e49b09976da152fa3b802c ]

xlnx_formatter_pcm_hw_params() does a read-modify-write on XLNX_AUD_CTRL
but only ORs in the new data width and active channel values without
clearing the old ones. If hw_params is called more than once on an
open stream, these fields may retain bits from the previous configuration,
resulting in an incorrect sample width or channel count.

Clear both fields before writing the new values, and use FIELD_PREP() so
the values cannot spill into neighbouring bits.

Fixes: 6f6c3c36f091 ("ASoC: xlnx: add pcm formatter platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Gaddipati, Naveen <naveen.gaddipati@amd.com>
Link: https://patch.msgid.link/20261023102818.523331-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/xilinx/xlnx_formatter_pcm.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/soc/xilinx/xlnx_formatter_pcm.c b/sound/soc/xilinx/xlnx_formatter_pcm.c
index bb1488e392b8c..13e592496001f 100644
--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -6,6 +6,7 @@
 //
 // Author: Maruthi Srinivas Bayyavarapu <maruthis@xilinx.com>
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -57,8 +58,8 @@
 #define CFG_S2MM_XFER_SHIFT	29
 #define CFG_S2MM_PKG_MASK	BIT(28)
 
-#define AUD_CTRL_DATA_WIDTH_SHIFT	16
-#define AUD_CTRL_ACTIVE_CH_SHIFT	19
+#define AUD_CTRL_DATA_WIDTH_MASK	GENMASK(18, 16)
+#define AUD_CTRL_ACTIVE_CH_MASK		GENMASK(22, 19)
 #define PERIOD_CFG_PERIODS_SHIFT	16
 
 #define PERIODS_MIN		2
@@ -509,28 +510,29 @@ static int xlnx_formatter_pcm_hw_params(struct snd_soc_component *component,
 	writel(high, stream_data->mmio + XLNX_AUD_BUFF_ADDR_MSB);
 
 	val = readl(stream_data->mmio + XLNX_AUD_CTRL);
+	val &= ~(AUD_CTRL_DATA_WIDTH_MASK | AUD_CTRL_ACTIVE_CH_MASK);
 	bits_per_sample = params_width(params);
 	switch (bits_per_sample) {
 	case 8:
-		val |= (BIT_DEPTH_8 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_8);
 		break;
 	case 16:
-		val |= (BIT_DEPTH_16 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_16);
 		break;
 	case 20:
-		val |= (BIT_DEPTH_20 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_20);
 		break;
 	case 24:
-		val |= (BIT_DEPTH_24 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_24);
 		break;
 	case 32:
-		val |= (BIT_DEPTH_32 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_32);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	val |= active_ch << AUD_CTRL_ACTIVE_CH_SHIFT;
+	val |= FIELD_PREP(AUD_CTRL_ACTIVE_CH_MASK, active_ch);
 	writel(val, stream_data->mmio + XLNX_AUD_CTRL);
 
 	val = (params_periods(params) << PERIOD_CFG_PERIODS_SHIFT)
-- 
2.53.0



