Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC52663B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF6DC433D2;
	Mon, 20 Feb 2023 13:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900403;
	bh=sxgSfA1i2cTOt1jlI9pwIPaZUJgX8V76Y+0rQ35juww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btlRGHnIVwRsgcaL/hwn5VtJZh6JPuUuwJDfzZeYHmGZilAyDHNuksuRKijQAQ50X
	 WJl8qvcFnfcIm3dn7MIXEEyz12qh1yD2Y+XEjO6z4JEJkoxkwtvZJLUw3ITU7RrKsT
	 4S6wumFDfx0ohB/mfpcydz9kBy5YozOqWGpQEer4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/89] iio: adc: stm32-dfsdm: fill module aliases
Date: Mon, 20 Feb 2023 14:35:11 +0100
Message-Id: <20230220133553.532897423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit cc3304052a89ab6ac887ed9224420a27e3d354e1 ]

When STM32 DFSDM driver is built as module, no modalias information
is available. This prevents module to be loaded by udev.
Add MODULE_DEVICE_TABLE() to fill module aliases.

Fixes: e2e6771c6462 ("IIO: ADC: add STM32 DFSDM sigma delta ADC support")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20221202152848.45585-1-olivier.moysan@foss.st.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-dfsdm-adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/stm32-dfsdm-adc.c b/drivers/iio/adc/stm32-dfsdm-adc.c
index 1c492a7f4587..bb90b22b809c 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1099,6 +1099,7 @@ static const struct of_device_id stm32_dfsdm_adc_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, stm32_dfsdm_adc_match);
 
 static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
 {
-- 
2.39.0



