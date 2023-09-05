Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A72DDA8
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 16:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE39C433C8
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 16:31:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="lC+6OB+C"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Sep 2023 17:31:19 +0100
Resent-Message-ID: <ZPdX18JfW7EFzsGr@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Sep 2023 15:07:49 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=DI8x=EV=baylibre.com=jneanne@kernel.org>)
	id 1qdWiZ-00AF95-1o
	for broonie@sirena.co.uk; Tue, 05 Sep 2023 15:07:49 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 4089760919
	for <broonie@sirena.co.uk>; Tue,  5 Sep 2023 14:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id BC9C0C433CA; Tue,  5 Sep 2023 14:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3008C433C7
	for <broonie@kernel.org>; Tue,  5 Sep 2023 14:07:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org B3008C433C7
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2bcb89b4767so38795361fa.3
        for <broonie@kernel.org>; Tue, 05 Sep 2023 07:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1693922858; x=1694527658; darn=kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iAbMWGT5YKvgyZeI9ML3fVvXmxnZ59xnof4HH5lFrT0=;
        b=lC+6OB+CWMpIebqnk0W7g9qonhURKZZ4R6naYVRixz1nmnjZHqVWIHnwHuxPKaOn0p
         KlsMvROHi8QWgeQipzLGFy3cZqjVgfJnTA4QwkcwrvKxKEBC3gsooh0z5e/4bsdn8L6w
         ubkVUWG8td2OxzFqjapOXV6i9zxryKLzv7tWKeFB4RdFHcFCKNlN7vjmuBxiRGIblP1F
         9oTK3RX4cgiBB6zXnC90selgXtVmcyVlSaekRs34OVB5zU1Mp/IIDLTAryu1A/JwBlcf
         Fs2KtvroSbd5f8d2jZPZVbdFp2WAxckalg1J6C85BvnhnIwVA8mpe3v4MStVgVv/phpV
         IEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693922858; x=1694527658;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iAbMWGT5YKvgyZeI9ML3fVvXmxnZ59xnof4HH5lFrT0=;
        b=UbVRAZdAuffZeOUiW+NmgeGehkO6o83mCPULMfeodBnd7py0FDOnu+WSjCLcIP0o1H
         wix4GmfHGm05Q5h1ROM+/qpdaPytPfUl+VJvLqVHTTCZCYsqdfUek9PiDo9Fln1/tf1b
         Qb/RQ2BHO2G/5GPQs65+pkVcECVsznkQwo1RJhTu+o8LV+M5ckMhERcZpSJKyG44dUp1
         cbINuyo+XUl2zOtyN7Yf+CZ56r04zQlDB22+dpvcfYW0gjpbNld9zRzLei73C4Ij1gZV
         n30tFTuJTG+/M9Y8HaeNgLwmoGE0gPLzXeH6rtbsQelIjS4W9u4NLzItW5GMqyF3CsL1
         /Ohw==
X-Gm-Message-State: AOJu0YwqPu9zTwND2F9kzSgdfKvxbW4+lQN4GiPx+rin45sHIaf4ml00
	HImmpmk497PSYc8OA8zhNicvsg==
X-Google-Smtp-Source: AGHT+IFSVjTm7ZrO3NeGlfqLpx3B9hLTXvmgWHioUcoPOtejX8IkvEA1LRIWSqy+3uvaYrrwEwWJEw==
X-Received: by 2002:a05:6512:4005:b0:500:bffa:5b86 with SMTP id br5-20020a056512400500b00500bffa5b86mr10652186lfb.6.1693922857788;
        Tue, 05 Sep 2023 07:07:37 -0700 (PDT)
Received: from [127.0.1.1] ([85.68.201.192])
        by smtp.gmail.com with ESMTPSA id a2-20020adff7c2000000b003177074f830sm17617239wrq.59.2023.09.05.07.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 07:07:37 -0700 (PDT)
From: Jerome Neanne <jneanne@baylibre.com>
Date: Tue, 05 Sep 2023 16:07:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230828-tps6594_random_boot_crash_fix-v1-1-f29cbf9ddb37@baylibre.com>
X-B4-Tracking: v=1; b=H4sIACY292QC/x2OUQrCMBAFr1LybTCm1dReRSRsmo1dsEnZLSKU3
 t3Uz4F5w9uUIBOKGppNMX5IqOQKl1OjxgnyCzXFysoa25re9npd5Ha9d54hxzL7UMrqRwaZfKK
 vTq4DkyK61hlVGwEEdajuOB2VGSi/KeN5BlmRD2NhrMP/g8dz33/u9MltkQAAAA==
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, 
 Esteban Blanc <eblanc@baylibre.com>
Cc: linux-kernel@vger.kernel.org, u-kumar1@ti.com, jpanis@baylibre.com, 
 khilman@baylibre.com, s.sharma@ti.com, aseketeli@baylibre.com, 
 Jerome Neanne <jneanne@baylibre.com>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1693922857; l=3254;
 i=jneanne@baylibre.com; s=20230511; h=from:subject:message-id;
 bh=CHIa+Z8rM52FfhpakBheBiw1hnuHCRMmo3h835NJgHg=;
 b=LsSWC8HcosT0dzJLPdifSuV6XggNoku+YfhsWvQXzGQJ6A2M4yrChwgvrts99byziKIr0cD2h
 DaAAhN9tZfTB5nYWRukslpr8yF5pjHAIIq6h99LboNwgT5JYPKcIs2G
X-Developer-Key: i=jneanne@baylibre.com; a=ed25519;
 pk=5rvbqNoG+28jQjC9/50ToY7TgKWf9rJukuCI8b6jkUo=
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=DI8x=EV=baylibre.com=jneanne@kernel.org
Subject: [PATCH] regulator: tps6594-regulator: Fix random kernel crash
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: ZrncKxmSJOCK

Random kernel crash detected in TI CICD when regulator driver is added.
This is root caused to irq index increment being done twice causing
irq_data being allocated outside of the range.

- Rework tps6594_request_reg_irqs with correct index increment
- Adjust irq_data kmalloc size to the exact size needed for the device

This has been reported on TI mainline. No public bug report associated.

Reported-by: Udit Kumar <u-kumar1@ti.com>
Fixes: f17ccc5deb4d ("regulator: tps6594-regulator: Add driver for TI TPS6594 regulators")
Signed-off-by: Jerome Neanne <jneanne@baylibre.com>
---
Random kernel crash detected in TI CICD when regulator driver is added.
This is root caused to irq index increment being done twice causing
irq_data being allocated outside of the range.
---
 drivers/regulator/tps6594-regulator.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/tps6594-regulator.c b/drivers/regulator/tps6594-regulator.c
index d5a574ec6d12..47c3b7efe145 100644
--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -384,21 +384,19 @@ static int tps6594_request_reg_irqs(struct platform_device *pdev,
 		if (irq < 0)
 			return -EINVAL;
 
-		irq_data[*irq_idx + j].dev = tps->dev;
-		irq_data[*irq_idx + j].type = irq_type;
-		irq_data[*irq_idx + j].rdev = rdev;
+		irq_data[*irq_idx].dev = tps->dev;
+		irq_data[*irq_idx].type = irq_type;
+		irq_data[*irq_idx].rdev = rdev;
 
 		error = devm_request_threaded_irq(tps->dev, irq, NULL,
-						  tps6594_regulator_irq_handler,
-						  IRQF_ONESHOT,
-						  irq_type->irq_name,
-						  &irq_data[*irq_idx]);
-		(*irq_idx)++;
+						  tps6594_regulator_irq_handler, IRQF_ONESHOT,
+						  irq_type->irq_name, &irq_data[*irq_idx]);
 		if (error) {
 			dev_err(tps->dev, "tps6594 failed to request %s IRQ %d: %d\n",
 				irq_type->irq_name, irq, error);
 			return error;
 		}
+		(*irq_idx)++;
 	}
 	return 0;
 }
@@ -420,8 +418,8 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 	int error, i, irq, multi, delta;
 	int irq_idx = 0;
 	int buck_idx = 0;
-	int ext_reg_irq_nb = 2;
-
+	size_t ext_reg_irq_nb = 2;
+	size_t reg_irq_nb;
 	enum {
 		MULTI_BUCK12,
 		MULTI_BUCK123,
@@ -484,15 +482,16 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (tps->chip_id == LP8764)
+	if (tps->chip_id == LP8764) {
 		/* There is only 4 buck on LP8764 */
 		buck_configured[4] = 1;
+		reg_irq_nb = size_mul(REGS_INT_NB, (BUCK_NB - 1));
+	} else {
+		reg_irq_nb = size_mul(REGS_INT_NB, (size_add(BUCK_NB, LDO_NB)));
+	}
 
-	irq_data = devm_kmalloc_array(tps->dev,
-				REGS_INT_NB * sizeof(struct tps6594_regulator_irq_data),
-				ARRAY_SIZE(tps6594_bucks_irq_types) +
-				ARRAY_SIZE(tps6594_ldos_irq_types),
-				GFP_KERNEL);
+	irq_data = devm_kmalloc_array(tps->dev, reg_irq_nb,
+				      sizeof(struct tps6594_regulator_irq_data), GFP_KERNEL);
 	if (!irq_data)
 		return -ENOMEM;
 

---
base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
change-id: 20230828-tps6594_random_boot_crash_fix-f74a0fde7370

Best regards,
-- 
Jerome Neanne <jneanne@baylibre.com>

