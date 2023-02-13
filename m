Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE828F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C43C433D2;
	Mon, 13 Feb 2023 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300650;
	bh=OCRM3eaWV1LLB3JIqkIOhVdGfCAKdWFyth2YXYJSQ4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJak36hUhlc7UpIUl9i867PEno0B3SCQ4ebTOzesvvKOeM7JCgCfE9hbL2VbcxNWE
	 ARgFiS0BxNwwDfv3C//cRVANG3a6ZTQyyuAdkOui5fme+8KVLZ5HG74xyXGk+ODDLy
	 xr1PzbM/RPNR+yvq6/87UdyiwwXTZouWBkJu0rsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Andreas Kemnade <andreas@kemnade.info>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/139] iio:adc:twl6030: Enable measurement of VAC
Date: Mon, 13 Feb 2023 15:50:40 +0100
Message-Id: <20230213144750.833159287@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit bffb7d9d1a3dbd09e083b88aefd093b3b10abbfb ]

VAC needs to be wired up to produce proper measurements,
without this change only near zero values are reported.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Fixes: 1696f36482e7 ("iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20221217221305.671117-1-andreas@kemnade.info
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/twl6030-gpadc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index 9ab23b29bee3f..024bdc1ef77e6 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -952,7 +952,7 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 	}
 
 	ret = twl_i2c_write_u8(TWL6030_MODULE_ID0,
-				VBAT_MEAS | BB_MEAS | BB_MEAS,
+				VBAT_MEAS | BB_MEAS | VAC_MEAS,
 				TWL6030_MISC1);
 	if (ret < 0) {
 		dev_err(dev, "failed to wire up inputs\n");
-- 
2.39.0



