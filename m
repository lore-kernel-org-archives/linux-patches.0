Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064069;
	b=2J3kiHsWtMRv9P04qQDChPdWgfRm02iUCvz4+pJTPdo2eYssamES7mzusTNB2iWLrIIl
	 pr6AzhL92AoDhFIvRTRnQW+upSH2NZp05aLRB6i1t/SiIM/zda+7i+HKAGHxKBiOkJJHr
	 9xD3+k9qG8f6uw0hLlfdn15SwcOM/XuaBcO7WWdb4TocZcNqqxVYZTELU3Y10k1H/zo6u
	 mlBXpk79qIGR1P509e2OlNnKqXfnRDoYthhHrRdhbUs7ck8/WqP7BDknnLiolxD+F+KoB
	 1m5pQZB/9K0TR5LJq5QoOpx6ymQpbpDfetjKiXUVmRmaj66FedG6XWQ1cE/HVdgX31Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q5pfywB1WJ609VKeFhc6fjLsDSu88vRnmrse/BgHVpM=;
	b=hQdZhZTgk7RgNiCUJ8hwcXA7Xw4FXLTaByamODGwm/8g3tIeNonGIYVQ42hjtKAf4VgI
	 M0PZmQLr4tb9Rx625UzCFFENzIBeCYNZ+ql1WiblFSS/V2GrTAlIMOC1Td3vGBXZ0RuJz
	 TPOZ4VadJD8fM5t2z/CPAYU0SSEJG74P6t6KCtxYB/6dU/lCHnEgctrNKYU4RfuK+S/td
	 f5iH0iYrFbOn70hNjfHA2aNT0RxFEq3ntp6kTt0Pc6bZZRBAdMeOnuQ+ZZHNaiawAiONt
	 c9KqSx9ZgHFAG2FMRf1uj+WO5eSEzAUjPecC3q0O6nqo4f2BVxU4LqDIXaXCIy/ZkQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DwXu0waA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D71B606A9F1;
	Sat,  7 Nov 2026 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DwXu0waA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06AF1F0089F;
	Sat,  7 Nov 2026 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064069;
	bh=q5pfywB1WJ609VKeFhc6fjLsDSu88vRnmrse/BgHVpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DwXu0waAEachlKN5tMrICgw2HnZWH8/bdvdu/I/zO8cgv7dxmOKQEdxYLZCcx1GIz
	 JX6shl+eNCiRDC9D2JTRJlRPyPnLtRARVPHtcPmEFYCslk0gL9VzZfhNV8I9buECo8
	 /lYWA9IeTZB1Ik9vmu/aKPAOz1GpMYHnOpYQLvU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Ariana Lazar <ariana.lazar@microchip.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0210/1257] iio: dac: mcp47feb02: initialize dac_data field in channel data struct at probe
Date: Sat,  7 Nov 2026 08:41:46 -0500
Message-ID: <20261107134945.341407792@linuxfoundation.org>
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

[ Upstream commit fc8d14d75345cb6f43d836be6b32cbc714c19b6b ]

Prevent operations which use cache from overwriting default hardware values
with zeros by reading active DAC registers during probe to correctly
initialize the channel struct DAC values.

Fixes: bf394cc80369 ("iio: dac: adding support for Microchip MCP47FEB02")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260804134616.1D8A21F00A3E@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Ariana Lazar <ariana.lazar@microchip.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp47feb02.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/mcp47feb02.c b/drivers/iio/dac/mcp47feb02.c
index 8640b0ef4433d..6a3875e1d6a2c 100644
--- a/drivers/iio/dac/mcp47feb02.c
+++ b/drivers/iio/dac/mcp47feb02.c
@@ -1019,7 +1019,12 @@ static int mcp47feb02_init_ctrl_regs(struct mcp47feb02_data *data)
 	gain_ch = gain_ch & MCP47FEB02_GAIN_BITS_MASK;
 	for_each_set_bit(i, &data->active_channels_mask, data->phys_channels) {
 		struct device *dev = regmap_get_device(data->regmap);
-		unsigned int pd_tmp;
+		unsigned int pd_tmp, dac_val;
+
+		ret = regmap_read(data->regmap, REG_ADDR(i), &dac_val);
+		if (ret)
+			return ret;
+		data->chdata[i].dac_data = dac_val;
 
 		data->chdata[i].ref_mode = (vref_ch >> (2 * i)) & MCP47FEB02_DAC_CTRL_MASK;
 		data->chdata[i].use_2x_gain = (gain_ch >> i)  & MCP47FEB02_GAIN_BIT_MASK;
-- 
2.53.0



