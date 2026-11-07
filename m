Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062126;
	b=OI3imrKHP9IuRNGjA7f94ZxHVrPWzbjkcpAqcBMWyiVGBPMoIU/sa0zWb5lTovGNnwRO
	 LNI0mTYisIhfpvoqH/x4VP9oXLGvSkr43USymRpllO24K+AGoSMdRxv33tJwkRWR2qdAy
	 F5hZGQ6+mQiIgA4WaBSs/RPp23kosjFudBsfkfTv1mKZ+LdEGedeIlCtv1+FDy9w+7mRn
	 Ya3XgWV/ehRe6Rg908dx79Pell8Y7Y2/9UL7AUFlVtdK446iHSubKgGLAfU+5fXG/eLEd
	 B+ykI6oNY5/YNv/nl/vCwdNVNvFYIQiy/A3WxK3Xzu0wI7/l0Ixy+qgP9wf8s7vM5EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YiwUlw8QC+53b1ibB6+0YY2jaBD6l+SfGvpF5LOB7OQ=;
	b=DFKfVIe+6d5crZxiksYIUOmZgu1p8J6SVQlY3b/4j/9qxe6ZSN6NNccXtPC2GBFrMV8H
	 /SQSjl/sYkDrnCJ/73KMDBLclq8wc0My+g7r82NtVjdtQ2VIUJnp9SZlFY+tLnjn8ibBY
	 /20mIsDwpKrQQYTKKKhdEgirsUFg5JbOez6tdGPzeBC8cpFh518cdSFZghdqPtNUbEKAQ
	 gSYSKkzXPSrnfp/udbACHXbvoKq8ulDxc0sMadGfJYh+oiCB7cD5Z9TqLuDjDbGdoR0v3
	 +Nn/PMylrB6WB9RWT5w3oZcbrSL8gnwHCbpWI5uR5+x2W4ezqyL+STt0bwkwcSoDDpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plet0PKV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E76B606EE98;
	Sat,  7 Nov 2026 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plet0PKV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C24C1F008A1;
	Sat,  7 Nov 2026 14:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062126;
	bh=YiwUlw8QC+53b1ibB6+0YY2jaBD6l+SfGvpF5LOB7OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plet0PKV4FysZTxpUYB7399SO4FlpuqI1sOpnrzcOlDrJ3dDio6IiGR7Z9QfqGlJS
	 dxqGQUDCm9HIh1tjDBS/bsDFkO5DUam5c/CTlTKtYCElUMypI6Z5qSsXOGobNsBSl4
	 B0dPrCyQ9cfsFDZWK51+1F/1F+frm6Mayz0CcQtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore-ext@st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1095/1536] iio: adc: stm32: fix minimum sampling time values
Date: Sat,  7 Nov 2026 08:51:51 -0500
Message-ID: <20261107135028.454850435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Cheick Traore <cheick.traore-ext@st.com>

[ Upstream commit ef04fdc999ee40a58d513ea48d391c7dc78c908c ]

- On stm32mp15: vddcpu and vddq_ddr are not connected to internal
channel, so their sampling time shouldn't be set.

- On stm32mp13: vddcpu and vddq_ddr are connected to internal channels
and the value for vddcore was not correct. Values from the datasheet
are 1us (e.g. 1000ns) for ts_vddcore, ts_vddcpu and ts_vddq_ddr.

Fixes: 7cb2303dd024 ("iio: adc: stm32: manage min sampling time on all internal channels")
Cc: stable@vger.kernel.org
Signed-off-by: Cheick Traore <cheick.traore-ext@st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 2513146639171..ed75e7cb1c220 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2606,7 +2606,7 @@ static const struct stm32_adc_cfg stm32h7_adc_cfg = {
 	.ts_int_ch = stm32_adc_min_ts_h7,
 };
 
-static const unsigned int stm32_adc_min_ts_mp1[] = { 100, 100, 100, 4300, 9800 };
+static const unsigned int stm32_adc_min_ts_mp1[] = { 100, 0, 0, 4300, 9800 };
 static_assert(ARRAY_SIZE(stm32_adc_min_ts_mp1) == STM32_ADC_INT_CH_NB);
 
 static const struct stm32_adc_cfg stm32mp1_adc_cfg = {
@@ -2626,7 +2626,7 @@ static const struct stm32_adc_cfg stm32mp1_adc_cfg = {
 	.ts_int_ch = stm32_adc_min_ts_mp1,
 };
 
-static const unsigned int stm32_adc_min_ts_mp13[] = { 100, 0, 0, 4300, 9800 };
+static const unsigned int stm32_adc_min_ts_mp13[] = { 1000, 1000, 1000, 4300, 9800 };
 static_assert(ARRAY_SIZE(stm32_adc_min_ts_mp13) == STM32_ADC_INT_CH_NB);
 
 static const struct stm32_adc_cfg stm32mp13_adc_cfg = {
-- 
2.53.0



