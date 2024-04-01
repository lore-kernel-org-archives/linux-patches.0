Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4B31C0DE7;
	Mon,  1 Apr 2024 16:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990146; cv=none; b=QQOtKuAVlUEhtMhGvaQL3tQmNikQxnYvRY2ls5N602YR/sORaES1tYPN5eQCp2GlYfOXXYUU0dvjHVXIgvEOVYFvPX8gR4AywGewp5Dzz7hL+En0PsDevr1mP4fras5nkA2Xt0g/g91LiLvau+hUEX6LaTfiAHinOUTsGF8d8B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990146; c=relaxed/simple;
	bh=gZdzKc+qkRdMmJWXQvT+MUF0BIZqaQDUCre7x/m++GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWBdpxwK4BGtjlwKQLpbOkdGQ36KrwgQXjU/2h7pBWbq2ZdEhdv25INpet7k+JY7Q76afB9jmw+cm7j6X76TMZ1v5ZceeGt0S8IEKgtdFxQAG+RCutXq8ALxyx8YzLKqCz7mwYLcuv666w8UeRD0WVuKBcuCXx29T7fGjoJhctM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYKRPnpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYKRPnpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9C1C433C7;
	Mon,  1 Apr 2024 16:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990146;
	bh=gZdzKc+qkRdMmJWXQvT+MUF0BIZqaQDUCre7x/m++GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYKRPnpLkcM+yn4Vm8UYCaMmHcLgMrzxZG8ZZS7rONzI8LVG8zluDcwd4Afqc/KRb
	 XseMPtVJBeZ5VTxkuyLWVX6nKgsgSRw9xIybCYrFHGvR9fTovAW9qBpizWNnhwgNPI
	 AH05nXcKimfSd4mIVh5SI1ZqDeRy4KHLkSuseiQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 243/396] iio: accel: adxl367: fix I2C FIFO data register
Date: Mon,  1 Apr 2024 17:44:52 +0200
Message-ID: <20240401152555.158513251@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Cosmin Tanislav <demonsingur@gmail.com>

commit 11dadb631007324c7a8bcb2650eda88ed2b9eed0 upstream.

As specified in the datasheet, the I2C FIFO data register is
0x18, not 0x42. 0x42 was used by mistake when adapting the
ADXL372 driver.

Fix this mistake.

Fixes: cbab791c5e2a ("iio: accel: add ADXL367 driver")
Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240207033657.206171-2-demonsingur@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl367_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/adxl367_i2c.c
+++ b/drivers/iio/accel/adxl367_i2c.c
@@ -11,7 +11,7 @@
 
 #include "adxl367.h"
 
-#define ADXL367_I2C_FIFO_DATA	0x42
+#define ADXL367_I2C_FIFO_DATA	0x18
 
 struct adxl367_i2c_state {
 	struct regmap *regmap;


