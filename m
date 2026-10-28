Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213180;
	b=GoInNTbfd/oMm0xQC4aexxOVQPSqY6/SBzp3xI6bRoPCCZCGo0Mi6L7xGeKxWNnuOR6B
	 dC81CA50DOBVjNJc6f++hEgb0YURkb6shY6uGRg+5rqzroyRdevQ+vavQ6mh69+cKdvV7
	 gdmFLeXHLe1HW3Wo/VoBHfZm21oKF2lx2z18g638JrSY8Xb6nKTRSOVFa8iTM5a8V19Wb
	 sHl05iAUMD53qTs+WQpPp+ciiE7yz0kZg7CLCMj+rHMZsmfsGHjeAvwyuOL/XNAMVR703
	 T5McBULQ06bR43cdHv9r4w2te7gvlF5FMAlHMLpuU17xA/5xXBzoMTx/eiHSHbNhpFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MibzBob50z538L6PHOt7gPFRlVLx3nT2tZF/q8FBsYI=;
	b=mEGs2BqnM4qX5MT5mP90qApM3kSychCOp9yeJwwnI/4VyZ4SrOfkPV4Gom5zObRUmtTT
	 T2P80KZMKmHaqs1Bx/t5x/8/3OtKTproUGu3tu6rix1ny5C2VpyGT5o5WnQ3rLZKdPfLm
	 e+Wrvd2BocRWByn0KLnOb27eqwchXqsO33Yj55H8WNXFGrfmJjViOBRqDd/Dc2o5Wst8U
	 RHaImibGJ0PppoTJB592Wx1Mrj7xO79/MsG64268lr8MdnFNl59zw56Ogwcf0NqO0FiSJ
	 hGKOntArsEHNa51IVvIisKVfBmurd3lXlbLWmUTehVZwk20ntF1uQuh0k+6mwgeWUqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOZAjaMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C72C606A31D;
	Wed, 28 Oct 2026 18:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOZAjaMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2571F01825;
	Wed, 28 Oct 2026 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213180;
	bh=MibzBob50z538L6PHOt7gPFRlVLx3nT2tZF/q8FBsYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOZAjaMyFywTSBo/NxpohG/L9IFrebbJP2HCT2wVQIolGXUAK1e+zMprO5S3FpGcD
	 rL9kkTHPiCp9MsFUjqX/8J8F7boVV8/T3bXf1ZFVg4dlpo0Vn4TUsKQhO/xkYUq5eC
	 e84CFo6jp6ViTuL7DVoJHcbfP/hJawmvyT57iKzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0415/1887] iio: adc: axp288: Add TS bias override for Haier HV103H
Date: Wed, 28 Oct 2026 17:41:51 +0100
Message-ID: <20261028170508.679867612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>

[ Upstream commit 0f300db7b7315b2c7ea0e2d4437b88de162d191f ]

The Haier HV103H firmware configures the AXP288 TS pin bias
current to 60 uA. This causes the battery temperature reading to
cross the charging temperature threshold under load, incorrectly
stopping battery charging.

Setting the TS bias current to 80 uA fixes the temperature
measurement and prevents charging from being incorrectly disabled.

Add a DMI quirk to use the 80 uA TS bias current on the Haier
HV103H.

Fixes: 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling")
Fixes: 048058399f19 ("iio: adc: axp288: Override TS pin bias current for some models") # Add necessary infrastructure
Signed-off-by: Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Adjusted context to match the existing {} table terminator. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/axp288_adc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index 580361bd98492..3ccdfe9dea3f5 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -204,6 +204,14 @@ static const struct dmi_system_id axp288_adc_ts_bias_override[] = {
 		},
 		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
 	},
+	{
+		/* Haier HV103H */
+		.matches = {
+		  DMI_MATCH(DMI_SYS_VENDOR, "Haier"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "HV103H"),
+		},
+		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
+	},
 	{}
 };
 
-- 
2.53.0



