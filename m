Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE11739B977
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302622; cv=none; b=sngIrEoix1nW0tUxG/V3xaccwIZ//8CF6nkyvreEY+5WH/vRgY/bWORFcOHBAuQnUa8ZDOPWqPzfPFiJi+wPrW7TX5YM0k4l5sHcWNNwtoD5DWuGRM0rvbQ/EDeVSJSjUnqaqyRTiOZbSCSHmQm1+wtCP3q9AlBy8xsLtJTlLgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302622; c=relaxed/simple;
	bh=8qgxvGt5bMKwiF2/kkKA22NHOWePkK/XjVvTCSF0xX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daJkcG8tHRMQde+qO04MV5y8jvL5K2/P3r6HiupaXepKMkn90Vyfg5kuupyOrrc741rcxcmTP+c/n6Kb26o1vYnzWoLgoHhzA9L3h72jQXs9TxklEy9xT0sXliDZ6J86lf4iX6KnwI9Hrrj2UGDWT/IGr5ttJA9NhV5KhDvNchE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rYZ31neB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rYZ31neB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190CAC116D0;
	Sat, 28 Feb 2026 18:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302622;
	bh=8qgxvGt5bMKwiF2/kkKA22NHOWePkK/XjVvTCSF0xX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYZ31neB2vkyARuZyzzszJYjd4+o8vg9HnJHL3axQOttBCqFhrNj0/nXuy4/4gRRC
	 pzDuLNiW69cIoMpO5Tej/7nelx9wn9dqIhPGv2+sM+ggl3efTYFGbz5rFNJxsN8hZU
	 tRHrnqxgtZ2gBnAYNUn3xIw5I+WAq9h/pzWgq9N6e4daGGAdPLMnsicxhk0Jcsvy17
	 +MulWYtoqdgRr8MsoDja6YC0MHkv9MS0cpa0aVrAhuF8ZRgq4CrjM/26/gyennUJef
	 yApqnvRKmpFHtaIKB6QpUy2VBzpfeOuGP42tcD28oJ5wy6dT69/OjkQkFsxp3YMiFt
	 +nw+sSunz6aXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/164] drivers: iio: mpu3050: use dev_err_probe for regulator request
Date: Sat, 28 Feb 2026 13:14:40 -0500
Message-ID: <20260228181505.1600663-141-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 5311bee5475ff..dcbc719275ceb 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1174,10 +1174,8 @@ int mpu3050_common_probe(struct device *dev,
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

