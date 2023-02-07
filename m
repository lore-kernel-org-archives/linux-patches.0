Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1822C3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C0FC433D2;
	Tue,  7 Feb 2023 13:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775024;
	bh=p+nTreZJOEvTMCXLh1VqS5FkE6rkX+0h/IQAUqXfrgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgLOGfon2AmWEjwZkCis/bDjBq+IxD8Ue0w8tYTLCi2+sU1aFRiDdDjbop7R7X2hN
	 9h8AA03uzZ+WgsMzDvluXz+7Acsg3bnCuZRc/DNCz0TNadwpikJgEBaL7Exv4X7Auf
	 j+bsueGo73uixEWGWbMIyUYkxM8u5YY84L7WXACo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/208] iio: adc: stm32-dfsdm: fill module aliases
Date: Tue,  7 Feb 2023 13:56:05 +0100
Message-Id: <20230207125639.399556179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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
index 6d21ea84fa82..a428bdb567d5 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1520,6 +1520,7 @@ static const struct of_device_id stm32_dfsdm_adc_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, stm32_dfsdm_adc_match);
 
 static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
 {
-- 
2.39.0



