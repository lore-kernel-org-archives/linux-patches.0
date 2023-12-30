Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8485B79D8;
	Sat, 30 Dec 2023 12:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x39EhKDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D311C433C8;
	Sat, 30 Dec 2023 12:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937906;
	bh=6rwUowES3/N6Dpx/daepCwLzRx6u8SliEX4rID6D4H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x39EhKDmpAq5+duIF+cMR9iYQpMFzyBtCmX8DW5T4MGoLzzCpD1W6dZIatPnyN/YC
	 zwPkSntN7jV21gSVCfTcGhbqjHNAguVlGy0S1pACCGj0cO3t1MTr0OoN30ekCYcY3E
	 k3CEAt1gAeRI0AYfPlg1YsWI3qnCvIYfnGP6CzU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Stark <gnstark@salutedevices.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/156] iio: adc: meson: add separate config for axg SoC family
Date: Sat, 30 Dec 2023 11:58:59 +0000
Message-ID: <20231230115815.138348196@linuxfoundation.org>
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

From: George Stark <gnstark@salutedevices.com>

[ Upstream commit 59b75dcb0953813676b5030877f3f37cedaed87d ]

According to Amlogic custom kernels ADC of axg SoC family has
vref_select and requires this setting to work nominally and thus
needs a separate config.

Fixes: 90c6241860bf ("iio: adc: meson: init voltage control bits")
Signed-off-by: George Stark <gnstark@salutedevices.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231127235558.71995-1-gnstark@salutedevices.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/meson_saradc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/meson_saradc.c b/drivers/iio/adc/meson_saradc.c
index 320e3e7e3d4d4..57cfabe80c826 100644
--- a/drivers/iio/adc/meson_saradc.c
+++ b/drivers/iio/adc/meson_saradc.c
@@ -1239,6 +1239,20 @@ static const struct meson_sar_adc_param meson_sar_adc_gxl_param = {
 	.cmv_select = 1,
 };
 
+static const struct meson_sar_adc_param meson_sar_adc_axg_param = {
+	.has_bl30_integration = true,
+	.clock_rate = 1200000,
+	.bandgap_reg = MESON_SAR_ADC_REG11,
+	.regmap_config = &meson_sar_adc_regmap_config_gxbb,
+	.resolution = 12,
+	.disable_ring_counter = 1,
+	.has_reg11 = true,
+	.vref_volatge = 1,
+	.has_vref_select = true,
+	.vref_select = VREF_VDDA,
+	.cmv_select = 1,
+};
+
 static const struct meson_sar_adc_param meson_sar_adc_g12a_param = {
 	.has_bl30_integration = false,
 	.clock_rate = 1200000,
@@ -1283,7 +1297,7 @@ static const struct meson_sar_adc_data meson_sar_adc_gxm_data = {
 };
 
 static const struct meson_sar_adc_data meson_sar_adc_axg_data = {
-	.param = &meson_sar_adc_gxl_param,
+	.param = &meson_sar_adc_axg_param,
 	.name = "meson-axg-saradc",
 };
 
-- 
2.43.0



