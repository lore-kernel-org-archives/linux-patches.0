Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE420255E43;
	Sat, 17 Oct 2026 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257086; cv=none; b=N2hAll34RSRckD57YPo5xpcHK3g/qiMqA6RmmjeRvlDdvjyHynopUqwcHh0G7Q7ITqicEVrujhJQpcdnAi9NkmPtYMrhg2WZRxb+I7DdqWBZG8dJ6xd1zsTUqzhTJYl0ANnwqVi7b1mkxdPKlmXEuhF5gIWi/CcetzzvxVRFDs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257086; c=relaxed/simple;
	bh=mVignLPZRFTBxj3uqtmNOHiOdbJuJKWDB3f5eKDzVig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=owQPs/OqgXIwhBedxq2C3KZ30d8O562SOyLqZUMIknMvwwzlR3nDqRT1OCc0d+Ga3jvhTC6M+OdiYLk484biiU4/GkSJ+pyY/QvjQZ1UiBhrzHFdyWuPQ/kdwKNQTv8aI64sDSmCTYPmXvZy11K/WoXjBF5yMp/Bwbajw0SKQIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvkI+F3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvkI+F3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5171F000C4;
	Sat, 17 Oct 2026 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257085;
	bh=4HXCITCQRWD9WLPjlYuHG+yZaNhUnl+x7rj1IHACXSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvkI+F3TOULnZHLpikhavIAl89BP1Ca0NMnSF3mAnzMFfOTlBmELRc50cvjQpV016
	 9LnxUJXGR+BRVjORDS9YTsko7yQOlHUg/uROKvoE1PGbjZ/t+NGi3okcp/VZyKK1lZ
	 UGl0i+0TEP7BA/a0f76VUdo2dupXpAx335M1buB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0448/1674] iio: adc: axp288: Add TS bias override for Haier HV103H
Date: Sat, 17 Oct 2026 17:45:20 +0200
Message-ID: <20261017160442.618088612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context to match the DMI table’s empty terminator formatting. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/axp288_adc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index 49fff1cabd0dc..3b7612dcaba6f 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -207,6 +207,14 @@ static const struct dmi_system_id axp288_adc_ts_bias_override[] = {
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



