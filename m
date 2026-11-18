Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061181;
	b=1Mh2+709fkSKMUpc6on6mXqwS+Wm2e9VKLv3/kobveY1aZtj1eAdpODjzaQ8DhuvwMYA
	 GZhNzHpgiZWnP1zz6OGMtIm0GjukvXMvO/eKS0qDm/eTHsv3QoH9DgRxRC/x3MyHh5PuM
	 9wb5nFIthEVnPyYcHBMtMU87KyAdENjNM1a9TIa5VCSeZF9K8QQNavf9zldiufKHRsbyG
	 x46U08hE+HduekMmoSuTixuAkzCkd1KtQ44Og/nrucFNuze6PJbKJe4SQ9Xk+k8AwehrR
	 88KNXsh6Tm+ah5/nknL1aOZp0BEYXL9jD9VRDzFt3kxoT90YhHxJbIKM4o5WRENJtHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Zud8/fbOneTfG2xq2NmuXzcoMSpCqpbOJY0CXnL+Ao=;
	b=tIsvoxcDqqwGqqrVJyfJfaRZMHNVx1q69EfcQBhS16VZ05e9OwFdk20lifHQ1UUIewk9
	 GtAT7mRcRBfdmJAvpVUekdxPxXrCWT5yP+H7wpFpXIR3jqQOs/3NekJCPS0j4HsxY/ngG
	 uuM8L1dbCiV/gURqlPV1Ev0XbnpypMtoJH2BYaB6bScfOcxdylEhRKcb+5ls0b7yF/meN
	 TqQucppRVPk1uwT192B3nbjzKtrUCqRMfXjUHXD/NUzH66m8rNqtZi44tT/aTWy1exrhs
	 VG8py+jpnkcEauqqWu6++v8rNJX474II9xaowpCdZ1TP4SsIr9+85Oc8eCGQVpL/aow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cOfXoRH/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB842606A320;
	Thu, 19 Nov 2026 04:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOfXoRH/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426221F000C4;
	Thu, 19 Nov 2026 04:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061181;
	bh=8Zud8/fbOneTfG2xq2NmuXzcoMSpCqpbOJY0CXnL+Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOfXoRH/W0duJ6nAcF1+3r5MF7nzFvw8ELTZGbrM1IzIhqzAE4JTo8F5NNm+5M4xG
	 DMF3b/8r7iOn6JpZJsyC+C81d6Mux/tFTsGhG4TFcABQT99RGzBvn98H5N0Sfvy5Kj
	 MOHVa9yFEFprjkYtoNnrZCUoiSP8knhb2H4qkMDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gene Chen <gene_chen@richtek.com>,
	linux-mediatek@lists.infradead.org,
	Lee Jones <lee.jones@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1459/1848] mfd: Standardise MFD_CELL_* helper names
Date: Wed, 18 Nov 2026 15:58:17 +0100
Message-ID: <20261118150020.444928953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit db783e769a950b3f9502dfbc0f7fdbea499a1da6 ]

Start all helpers with "MFD_CELL_".

Cc: Gene Chen <gene_chen@richtek.com>
Cc: linux-mediatek@lists.infradead.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 1098c619ce75 ("power: supply: ab8500_charger: Handle detection errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ab8500-core.c  | 42 +++++++++++++++++++-------------------
 drivers/mfd/db8500-prcmu.c |  6 +++---
 drivers/mfd/mt6360-core.c  | 12 +++++------
 include/linux/mfd/core.h   |  6 +++---
 4 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 62741923440bf..e9f4b1e732900 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -604,52 +604,52 @@ int ab8500_suspend(struct ab8500 *ab8500)
 }
 
 static const struct mfd_cell ab8500_bm_devs[] = {
-	OF_MFD_CELL("ab8500-charger", NULL, &ab8500_bm_data,
+	MFD_CELL_OF("ab8500-charger", NULL, &ab8500_bm_data,
 		    sizeof(ab8500_bm_data), 0, "stericsson,ab8500-charger"),
-	OF_MFD_CELL("ab8500-btemp", NULL, &ab8500_bm_data,
+	MFD_CELL_OF("ab8500-btemp", NULL, &ab8500_bm_data,
 		    sizeof(ab8500_bm_data), 0, "stericsson,ab8500-btemp"),
-	OF_MFD_CELL("ab8500-fg", NULL, &ab8500_bm_data,
+	MFD_CELL_OF("ab8500-fg", NULL, &ab8500_bm_data,
 		    sizeof(ab8500_bm_data), 0, "stericsson,ab8500-fg"),
-	OF_MFD_CELL("ab8500-chargalg", NULL, &ab8500_bm_data,
+	MFD_CELL_OF("ab8500-chargalg", NULL, &ab8500_bm_data,
 		    sizeof(ab8500_bm_data), 0, "stericsson,ab8500-chargalg"),
 };
 
 static const struct mfd_cell ab8500_devs[] = {
 #ifdef CONFIG_DEBUG_FS
-	OF_MFD_CELL("ab8500-debug",
+	MFD_CELL_OF("ab8500-debug",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-debug"),
 #endif
-	OF_MFD_CELL("ab8500-sysctrl",
+	MFD_CELL_OF("ab8500-sysctrl",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-sysctrl"),
-	OF_MFD_CELL("ab8500-ext-regulator",
+	MFD_CELL_OF("ab8500-ext-regulator",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-ext-regulator"),
-	OF_MFD_CELL("ab8500-regulator",
+	MFD_CELL_OF("ab8500-regulator",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-regulator"),
-	OF_MFD_CELL("ab8500-clk",
+	MFD_CELL_OF("ab8500-clk",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-clk"),
-	OF_MFD_CELL("ab8500-gpadc",
+	MFD_CELL_OF("ab8500-gpadc",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-gpadc"),
-	OF_MFD_CELL("ab8500-rtc",
+	MFD_CELL_OF("ab8500-rtc",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-rtc"),
-	OF_MFD_CELL("ab8500-acc-det",
+	MFD_CELL_OF("ab8500-acc-det",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-acc-det"),
-	OF_MFD_CELL("ab8500-poweron-key",
+	MFD_CELL_OF("ab8500-poweron-key",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-poweron-key"),
-	OF_MFD_CELL("ab8500-pwm",
+	MFD_CELL_OF("ab8500-pwm",
 		    NULL, NULL, 0, 1, "stericsson,ab8500-pwm"),
-	OF_MFD_CELL("ab8500-pwm",
+	MFD_CELL_OF("ab8500-pwm",
 		    NULL, NULL, 0, 2, "stericsson,ab8500-pwm"),
-	OF_MFD_CELL("ab8500-pwm",
+	MFD_CELL_OF("ab8500-pwm",
 		    NULL, NULL, 0, 3, "stericsson,ab8500-pwm"),
-	OF_MFD_CELL("ab8500-denc",
+	MFD_CELL_OF("ab8500-denc",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-denc"),
-	OF_MFD_CELL("pinctrl-ab8500",
+	MFD_CELL_OF("pinctrl-ab8500",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-gpio"),
-	OF_MFD_CELL("abx500-temp",
+	MFD_CELL_OF("abx500-temp",
 		    NULL, NULL, 0, 0, "stericsson,abx500-temp"),
-	OF_MFD_CELL("ab8500-usb",
+	MFD_CELL_OF("ab8500-usb",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-usb"),
-	OF_MFD_CELL("ab8500-codec",
+	MFD_CELL_OF("ab8500-codec",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-codec"),
 };
 
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 8d5f8f07d8a66..5aa7b3a36f221 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2952,12 +2952,12 @@ static const struct mfd_cell common_prcmu_devs[] = {
 };
 
 static const struct mfd_cell db8500_prcmu_devs[] = {
-	OF_MFD_CELL("db8500-prcmu-regulators", NULL,
+	MFD_CELL_OF("db8500-prcmu-regulators", NULL,
 		    &db8500_regulators, sizeof(db8500_regulators), 0,
 		    "stericsson,db8500-prcmu-regulator"),
-	OF_MFD_CELL("cpuidle-dbx500",
+	MFD_CELL_OF("cpuidle-dbx500",
 		    NULL, NULL, 0, 0, "stericsson,cpuidle-dbx500"),
-	OF_MFD_CELL("db8500-thermal",
+	MFD_CELL_OF("db8500-thermal",
 		    NULL, NULL, 0, 0, "stericsson,db8500-thermal"),
 };
 
diff --git a/drivers/mfd/mt6360-core.c b/drivers/mfd/mt6360-core.c
index 4661c1b29a726..480722acf706b 100644
--- a/drivers/mfd/mt6360-core.c
+++ b/drivers/mfd/mt6360-core.c
@@ -292,17 +292,17 @@ static const struct resource mt6360_ldo_resources[] = {
 };
 
 static const struct mfd_cell mt6360_devs[] = {
-	OF_MFD_CELL("mt6360_adc", mt6360_adc_resources,
+	MFD_CELL_OF("mt6360_adc", mt6360_adc_resources,
 		    NULL, 0, 0, "mediatek,mt6360_adc"),
-	OF_MFD_CELL("mt6360_chg", mt6360_chg_resources,
+	MFD_CELL_OF("mt6360_chg", mt6360_chg_resources,
 		    NULL, 0, 0, "mediatek,mt6360_chg"),
-	OF_MFD_CELL("mt6360_led", mt6360_led_resources,
+	MFD_CELL_OF("mt6360_led", mt6360_led_resources,
 		    NULL, 0, 0, "mediatek,mt6360_led"),
-	OF_MFD_CELL("mt6360_pmic", mt6360_pmic_resources,
+	MFD_CELL_OF("mt6360_pmic", mt6360_pmic_resources,
 		    NULL, 0, 0, "mediatek,mt6360_pmic"),
-	OF_MFD_CELL("mt6360_ldo", mt6360_ldo_resources,
+	MFD_CELL_OF("mt6360_ldo", mt6360_ldo_resources,
 		    NULL, 0, 0, "mediatek,mt6360_ldo"),
-	OF_MFD_CELL("mt6360_tcpc", NULL,
+	MFD_CELL_OF("mt6360_tcpc", NULL,
 		    NULL, 0, 0, "mediatek,mt6360_tcpc"),
 };
 
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 7a29d5389982c..09db9f5db45ef 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -28,13 +28,13 @@
 		.id = (_id),						\
 	}
 
-#define OF_MFD_CELL_REG(_name, _res, _pdata, _pdsize, _id, _compat, _of_reg) \
+#define MFD_CELL_OF_REG(_name, _res, _pdata, _pdsize, _id, _compat, _of_reg) \
 	MFD_CELL_ALL(_name, _res, _pdata, _pdsize, _id, _compat, _of_reg, true, NULL)
 
-#define OF_MFD_CELL(_name, _res, _pdata, _pdsize, _id, _compat) \
+#define MFD_CELL_OF(_name, _res, _pdata, _pdsize, _id, _compat) \
 	MFD_CELL_ALL(_name, _res, _pdata, _pdsize, _id, _compat, 0, false, NULL)
 
-#define ACPI_MFD_CELL(_name, _res, _pdata, _pdsize, _id, _match) \
+#define MFD_CELL_ACPI(_name, _res, _pdata, _pdsize, _id, _match) \
 	MFD_CELL_ALL(_name, _res, _pdata, _pdsize, _id, NULL, 0, false, _match)
 
 #define MFD_CELL_BASIC(_name, _res, _pdata, _pdsize, _id) \
-- 
2.53.0



