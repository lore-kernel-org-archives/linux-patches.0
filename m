Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DCE36C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302232; cv=none; b=q3HSFx4ZyODKcdjBfhRYFdtfbojsRVEIg/gJLKmWdOoQJwQ8DkoGBmrVN0flFObW8vwpHx9l3uKVuHSYZPkC3djvIKfyVNk+imN7pHuEKhyIZquGZ13czU3AKBQjG6JZzJGooRmeem/DrLGx6H7CFYTw7U9Lte9YkiCucg4s28c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302232; c=relaxed/simple;
	bh=fnH5eDXzk/vaiG7vYIKOuPEkzOyNIavrfQ5Je+a5fkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+F8f0VQwEO4UZVNLbwVVsXUSCwsyeDR1uzAPxigV8QDUdnXpDcX2HJ5wE96p3WCgjcOy47360m8zs/NrwkpwNN7kToCwcXofOAWcwJmqQ0YNr8va5f+Nc6mNQElTn/purtfDlvlP1bCyNxgnXtH/CmsZW/j9IyMsCdewGLtRNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irl34TaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irl34TaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F9EC19424;
	Sat, 28 Feb 2026 18:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302232;
	bh=fnH5eDXzk/vaiG7vYIKOuPEkzOyNIavrfQ5Je+a5fkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irl34TaPHIaQ2i5r9840/kMfn6FmDPAXjsRjUQMg9agkM3+TZNJQSWZ5SXExjsZFq
	 HUo5Ib7VwaOyADlpLvQtJ41XJfo4wXAOdxIjSb54ss1tIm+NoK9KgfJ4JtiZ5QfX80
	 Ht+osYR3OZKSuwaJceu/CIGSZiA309PQKTdt2cJr7dhvC1LwDCX8c4urCV5Uon8JtH
	 i5WkNegWhouZ7mXjkdjY0npka8G6gyFNu9eLS9sjAwOxOkvvBaiQF/OInDok7+SnOg
	 bEkR1KEHJ73sRSgRdCKusnfxbcjrTwm3hhZXstqpjWfqpuzy9OARdiVnh+xg4lhv24
	 DfXUp3WCbqLAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/283] drivers: iio: mpu3050: use dev_err_probe for regulator request
Date: Sat, 28 Feb 2026 13:06:24 -0500
Message-ID: <20260228180709.1583486-242-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit b010880b9936da14f8035585ab57577aa05be23a ]

Regulator requesting may result in deferred probing error which will
abort driver probing. To avoid this just use dev_err_probe which handles
deferred probing.

Fixes: 3904b28efb2c ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/gyro/mpu3050-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/gyro/mpu3050-core.c b/drivers/iio/gyro/mpu3050-core.c
index a791ba3a693a4..de126561f197d 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1172,10 +1172,8 @@ int mpu3050_common_probe(struct device *dev,
 	mpu3050->regs[1].supply = mpu3050_reg_vlogic;
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(mpu3050->regs),
 				      mpu3050->regs);
-	if (ret) {
-		dev_err(dev, "Cannot get regulators\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Cannot get regulators\n");
 
 	ret = mpu3050_power_up(mpu3050);
 	if (ret)
-- 
2.51.0

