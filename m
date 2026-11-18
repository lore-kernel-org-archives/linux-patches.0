Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022053;
	b=FzC2P7Aj81781VRGticrsuB9CLR7RTk3BvyYekrSnkrbW/NnofaCbqQcfbRoWWzhGzDL
	 XY3LHb+wTfR6Ue/Un+ZGA3QFrW7dtbYC8Wjdug2BX9bbvRJwxqXYHMcW8tIeE6ZqNyDOB
	 RVM7w3EdUpLpVdRzRUI7FFEmmhzTlX8BTzpl0JKvKxiAELYGpO3hLa37agt8DVmfUY6PZ
	 hmIwZsR8QqHSn5M3JTqjVjYfEDoevHfpWrDamYQbzoxkDgF1HWhQcu2O2i5YQjoQfilLo
	 ceGkHYVrxq38O85/+6D7YBYUiD9xE8Q9j0sD05tKKKnTGMhl0m8wxatV7gxuYNf3hNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBbuRuTnYgc55ujQS/loJQ36NF6sxmoNG/l2JjaDET0=;
	b=oDAMPs1aKFaxTWcIDa7GjFR8HEwftuXzhyKjHu8sRuHX6uxBjitjjw8XHQiopUuf9KQE
	 2SqA2dhiPV2GCKNtlKsoHgGQw1G3YH/CyxcSZgG2MplrJyjVMKBRMM6JWcbFypKGrr4W4
	 fO3PbfQJeYop02OsnA1g8alLY/AXkpc/DuxlpP7mldwSKCj8MHKCHuxi1GqVJP6NN8rjK
	 TkvRWGcU4q2nzR883qHwhMm5emDswfCcXDRGbxcAGSYxxlZAd4MkTFHHvla0MU/US6b4J
	 JxKBCstoiRLoi20eshnmFgOvuzTyoy4s4JWtXywpHFby9tuVn9LAG8ULSbe3cpRAGzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAjg4exG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7039E606A320;
	Wed, 18 Nov 2026 17:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAjg4exG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFCC1F000C4;
	Wed, 18 Nov 2026 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022053;
	bh=hBbuRuTnYgc55ujQS/loJQ36NF6sxmoNG/l2JjaDET0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAjg4exGgaj3vujoU0krejVOc7HUbgbIzpZMlCiZ6oZ0OwcvVpialUMT8jTcX5R/A
	 uV0mqOmROffa920QxKOIbuhe25d9poJfaRtX/NmItvdJWmy1GLeZJKHdLmsKVs0AUl
	 gTTq/1hfjKYCgqRj5KyFMDPTlac3S0Qy6Wx83G4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	"Gaddipati, Naveen" <naveen.gaddipati@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2524/2651] ASoC: xilinx: formatter_pcm: Fix read-modify-write of AUD_CTRL in hw_params
Date: Wed, 18 Nov 2026 16:02:44 +0100
Message-ID: <20261118150415.528479829@linuxfoundation.org>
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
index 95312b4ddc5b8..4d1de7cb9c615 100644
--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -6,6 +6,7 @@
 //
 // Author: Maruthi Srinivas Bayyavarapu <maruthis@xilinx.com>
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -55,8 +56,8 @@
 #define CFG_S2MM_XFER_SHIFT	29
 #define CFG_S2MM_PKG_MASK	BIT(28)
 
-#define AUD_CTRL_DATA_WIDTH_SHIFT	16
-#define AUD_CTRL_ACTIVE_CH_SHIFT	19
+#define AUD_CTRL_DATA_WIDTH_MASK	GENMASK(18, 16)
+#define AUD_CTRL_ACTIVE_CH_MASK		GENMASK(22, 19)
 #define PERIOD_CFG_PERIODS_SHIFT	16
 
 #define PERIODS_MIN		2
@@ -507,28 +508,29 @@ static int xlnx_formatter_pcm_hw_params(struct snd_soc_component *component,
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



