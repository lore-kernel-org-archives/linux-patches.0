Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922928BF3;
	Sat, 30 Dec 2023 12:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsJ8kW5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA88C433C8;
	Sat, 30 Dec 2023 12:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937857;
	bh=ejibhIByliaRRuANjqivbvV2YfGMgA6fQehMnutLv28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsJ8kW5v13w9M6KM43wu8/7QD4MF/k/+hsBCilMksU2b6turzXUVw1Ww3tu5ikX5V
	 J3QIkrCbneEUZX8BXoYIz6ePHNxmOoIXyLnaLL9nWsw4H+7aRbe6N/N4gURC3WaLTM
	 lvFzCYpM1scMxbFiMhnYc+YOYd7JbeXof8QhRJLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 090/156] iio: adc: imx93: add four channels for imx93 adc
Date: Sat, 30 Dec 2023 11:59:04 +0000
Message-ID: <20231230115815.296488509@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

commit 2475ecdb9b6e177b133cf26e64e8d441d37bebde upstream.

According to the spec, this ADC totally support 8 channels.
i.MX93 contain this ADC with 4 channels connected to pins in
the package. i.MX95 contain this ADC with 8 channels connected
to pins in the package.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Fixes: 7d02296ac8b8 ("iio: adc: add imx93 adc support")
Link: https://lore.kernel.org/r/20231116071026.611269-1-haibo.chen@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/imx93_adc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iio/adc/imx93_adc.c b/drivers/iio/adc/imx93_adc.c
index 9bb1e4ba1aee..4ccf4819f1f1 100644
--- a/drivers/iio/adc/imx93_adc.c
+++ b/drivers/iio/adc/imx93_adc.c
@@ -93,6 +93,10 @@ static const struct iio_chan_spec imx93_adc_iio_channels[] = {
 	IMX93_ADC_CHAN(1),
 	IMX93_ADC_CHAN(2),
 	IMX93_ADC_CHAN(3),
+	IMX93_ADC_CHAN(4),
+	IMX93_ADC_CHAN(5),
+	IMX93_ADC_CHAN(6),
+	IMX93_ADC_CHAN(7),
 };
 
 static void imx93_adc_power_down(struct imx93_adc *adc)
-- 
2.43.0



