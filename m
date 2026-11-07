Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064083;
	b=POc4oyiZvjeiVlRohoofxD+/vSTy11TbPvmXeS+mCzcLizdw1g6d31292D+dTH4P9Ua1
	 PYh+wDQ2XJ/wZkYi4pOIJj5MxBX+kIUR81t55CXb39FkhEiAbiHWwZYRSSVPHzTduQlya
	 qBEZhd7VOR0udmr+85CetEc/uA/tGXAGGper8VT9QAw9JsxlLhkT/61Cngrd8fWj1x8sR
	 kYnXhhK7/7InSQenxPkb1PrpsGOGd3tPEsfTGpDiTmvvl4Suapy7IixMAQ66CI4oeMCDy
	 tfPSgrSibVkQz0XDHV/j7jUI3p7qMBz6ONnILRSPV6IiuGMcOEEQOO3CSHpaFY8GmWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2sRcyCzOPo4YFPjEaFy/VcFIKJLI/dFV0pUcNqqvn3U=;
	b=bX3CyyiQ5BtBuFMYRXpmW3tbnQFI8dQGX8P8wn+b2eAgcIb9Y9Qkq8BXlyRZHMhh5gzL
	 VC7yLspjieGgGizo/f4rRq6ZgoUwv3mtOsF4A8mquEzg/o7HNfsGBvvNgYuwvcjy5nnLu
	 D0ITawJmuY0y4FoqUhgpXhgA2swwpRPL6xDOtdPMP95dzJj8sozFqStZsXWkmWEK4f/t4
	 ii1EoNOhj6O5/xyEZOuKqDudD83c6at6WA6wUl+wlV/wnlQ2JthZ5RPW/jwKlJYR9pDJf
	 XlwB7uLiRs4NYFdnV6LLnLXMJSn2HAXygVLe9KG6nuODR+0tgjyJ+lY9gKloC0KjrdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbDmwDji;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BF9606A9F2;
	Sat,  7 Nov 2026 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbDmwDji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1E61F0089F;
	Sat,  7 Nov 2026 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064082;
	bh=2sRcyCzOPo4YFPjEaFy/VcFIKJLI/dFV0pUcNqqvn3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbDmwDjirvqfpIfF7jyaIGhPCoqc0jgZuYTE9J4/8Utopn1tWSUgDRzy/TYAwJyZ5
	 d7HG5Ddfn2ceMTHVdFPncYlJHxFMjeQ3EiYx4im6dmph8uVTs/xdol3hs014SxYtvs
	 DeR9DzUpQtWu0fi6rMXQK8vVInbgpGoDtkWbw1JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Ariana Lazar <ariana.lazar@microchip.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0211/1257] iio: dac: mcp47feb02: Fix gain field initialization for active channels
Date: Sat,  7 Nov 2026 08:41:47 -0500
Message-ID: <20261107134945.369503843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Ariana Lazar <ariana.lazar@microchip.com>

[ Upstream commit 29491c675c2babb9a4a8cf9b33b38347e4565dee ]

As per MCP47FXBX48 Datasheet, in the format of the Gain Control and System
Status Register each DAC channel has one bit to control its gain,
starting at bit 8, while bits 0-7 contain status or unimplemented bits.

The previous formula didn't initialize correctly all channels, being
replaced by using field_get() with the already defined macro used in write
operations where needed in the rest of the driver implementation.
DAC_GAIN_MASK(i) extracts the gain control bit for each active channel
correctly in one step.

Fixes: bf394cc80369 ("iio: dac: adding support for Microchip MCP47FEB02")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260804134616.1D8A21F00A3E@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Ariana Lazar <ariana.lazar@microchip.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp47feb02.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/iio/dac/mcp47feb02.c b/drivers/iio/dac/mcp47feb02.c
index 6a3875e1d6a2c..1b1a4972f7719 100644
--- a/drivers/iio/dac/mcp47feb02.c
+++ b/drivers/iio/dac/mcp47feb02.c
@@ -36,7 +36,6 @@
 #define MCP47FEB02_DAC_CTRL_MASK			GENMASK(1, 0)
 
 #define MCP47FEB02_GAIN_CTRL_STATUS_REG_ADDR		0x50
-#define MCP47FEB02_GAIN_BIT_MASK			BIT(0)
 #define MCP47FEB02_GAIN_BIT_STATUS_EEWA_MASK		BIT(6)
 #define MCP47FEB02_GAIN_BITS_MASK			GENMASK(15, 8)
 
@@ -1016,7 +1015,6 @@ static int mcp47feb02_init_ctrl_regs(struct mcp47feb02_data *data)
 	if (ret)
 		return ret;
 
-	gain_ch = gain_ch & MCP47FEB02_GAIN_BITS_MASK;
 	for_each_set_bit(i, &data->active_channels_mask, data->phys_channels) {
 		struct device *dev = regmap_get_device(data->regmap);
 		unsigned int pd_tmp, dac_val;
@@ -1027,7 +1025,7 @@ static int mcp47feb02_init_ctrl_regs(struct mcp47feb02_data *data)
 		data->chdata[i].dac_data = dac_val;
 
 		data->chdata[i].ref_mode = (vref_ch >> (2 * i)) & MCP47FEB02_DAC_CTRL_MASK;
-		data->chdata[i].use_2x_gain = (gain_ch >> i)  & MCP47FEB02_GAIN_BIT_MASK;
+		data->chdata[i].use_2x_gain = field_get(DAC_GAIN_MASK(i), gain_ch);
 
 		/*
 		 * Inform the user that the current voltage reference read from the volatile
-- 
2.53.0



