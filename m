Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1E3347FDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302453; cv=none; b=F0uuWu/E9i3auYJZwwhGadl3CL3EtaC0vJ4ttBdyT2s/nVtAhYvZZSIZAtrGqH3ZPs8/qNI+T7YmXrk3oqRwRAVGryP98I7qDNom+SIPz6QuMKOonBjE7PcjqzD/6SwYTamwmODJ9YQb7C3rL1nW5qgECCOhO4lVraGwcrhkICY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302453; c=relaxed/simple;
	bh=ZeMxINGHAYewNfZoj2wfT+r+/kdo2cOzvlBLE6Lc2Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8lNEeIOSiLtAoWzAS/zLkKhkO6cDoCj6mNh4wy1AjUxRqh6kFkcOyinIVncoIlWpUaXcm/E7yEJqiVGqJ69CshqbC5IvCnAVmka8Bc7+BXU76giZlaaETO0NOh+83CDR7z2XzJQUa5EkYYSEdNukJkntaxfML2RxARb3cc/64w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvXQusaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvXQusaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EDAC19423;
	Sat, 28 Feb 2026 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302453;
	bh=ZeMxINGHAYewNfZoj2wfT+r+/kdo2cOzvlBLE6Lc2Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvXQusaAXHyjC9XISXALK6zBOVl9w5BDKM7ioLNTgS/DCRqlBJ5YXZbOOUlqR+LS/
	 6a+MSYcL9S/IMrcB7EBdKOEoQRaotqFedOLIwX7vyHfexxNkb2bWdqGbuVbzlqcDdV
	 5MHDx6CX5A5C4HRP6Ng0wSrsWh//fgUe64hzO1RP8Cx8sApdAgSn4/KomfLBmuszWl
	 gu6hJKKeMXVFWsrRCSCdPz0t3cuz5JxgWYTvZQ1fSiXDNr8oaD2jmJi++cnTQGipVd
	 fjaKHNTMA4J9+no2VmLDMpt8P5b1XqHAbzjmGRYxGOWQ1BMaPuWNTLsSQrBeeOXH8r
	 35aoKwIhCHZuA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/232] drivers: iio: mpu3050: use dev_err_probe for regulator request
Date: Sat, 28 Feb 2026 13:10:47 -0500
Message-ID: <20260228181127.1592657-194-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 6a6d84a3deda6..b830ca6bea078 100644
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

