Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3781D1BD519;
	Tue,  2 Jul 2024 17:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941012; cv=none; b=AMoV59QuEJZI8r2fgQjC2txTIVSDWXZHygbFIk4lN5r3My2tn/8o1DF3u47eeJFPFP54iD1wLBxOUs1QDDvvVhKsNAbbJvfq/KKmEZB/kXFCKk6RN37FCaKJXCLnLYk63Fgq8gNIvEehSd/dKdsHvYbUY91tZ6yTI3Kife3eYzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941012; c=relaxed/simple;
	bh=zo6pKjSjdbE50MM5+bxV6+dwwBLrQmGs+aHrW0ifj30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a75gs3GTQzJB98Yv8hrhdoR9NRvFXRrIGqhstyphN+D6jGeh2F+nwly2VSWKkRg5t18Ezt6d7TNKHVZEBRpDIVbFHCnzgIIU7xro+lOKLIB+xngOcfXm4WRqfHj+7jaBTK07edfApLh4AdcJjJpdGAQhuY4Teb3NvIrj7Sqq82Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1+FiogI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1+FiogI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB85C116B1;
	Tue,  2 Jul 2024 17:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941012;
	bh=zo6pKjSjdbE50MM5+bxV6+dwwBLrQmGs+aHrW0ifj30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1+FiogISLotRq3BN+oBfuh/OUzLYdif0r6/kSwadhQlKQGRfOTWNLELPZXmtBYHO
	 TQXqJb71INND9fsx9Ac6LGb1O9beogyhT2FyMt65a4slt+IbetNX+7cq3Ef0GD8oWK
	 etErRqkyZ4RGx36u4GxJoHZiVI0DS6Hp5P9soPHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 101/163] iio: chemical: bme680: Fix calibration data variable
Date: Tue,  2 Jul 2024 19:03:35 +0200
Message-ID: <20240702170236.884599289@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit b47c0fee73a810c4503c4a94ea34858a1d865bba upstream.

According to the BME68x Sensor API [1], the h6 calibration
data variable should be an unsigned integer of size 8.

[1]: https://github.com/boschsensortec/BME68x_SensorAPI/blob/v4.4.8/bme68x_defs.h#L789

Fixes: 1b3bd8592780 ("iio: chemical: Add support for Bosch BME680 sensor")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240606212313.207550-3-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/bme680_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -38,7 +38,7 @@ struct bme680_calib {
 	s8  par_h3;
 	s8  par_h4;
 	s8  par_h5;
-	s8  par_h6;
+	u8  par_h6;
 	s8  par_h7;
 	s8  par_gh1;
 	s16 par_gh2;


