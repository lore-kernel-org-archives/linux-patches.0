Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A1D36C590;
	Tue, 16 Dec 2025 12:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887452; cv=none; b=pePaeY4afm1262+167VqRN9JXxvyFGXd6FbQugY4XFIqaVzcWOoxTCGRuANcoElgIyCPmDaHMlGSGoFvh4dViResI+RhYoca+/7SeMnOP1mi/ZjBYTkoQ7AZ049WA9qddKysIo5Yvps7S/RzXosQIsoV9GasO+JG1PC04lekSHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887452; c=relaxed/simple;
	bh=o8g56qhUQt5sXnTTUXepVBWwHYhQnZXAW1Xm3E7RiAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZCTzHjYN+jtEHZInAH1h8W3pHNW0UO7vrvgrVi1hXmO6tgTLkAuYRFy+J5Qco8XQ2lWURuYyBj3hQboAC0frODQqST9ymyXVNkHCXVZfaH1Kfo7zIT2vAr2RSLTrOjahd7A54nWD3k+yBq6+rexfxOziQGDSPh8ed5ORSQGYrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfQvxZ5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfQvxZ5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76317C4CEF1;
	Tue, 16 Dec 2025 12:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887451;
	bh=o8g56qhUQt5sXnTTUXepVBWwHYhQnZXAW1Xm3E7RiAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfQvxZ5DcWpJiVJ+uT8FOXmhik1Sigyha3+2DvXQXDZUcUUn4Lbd6c7Fw6XcgY9Jn
	 6obdSaz6g7MiPE9oHA7dLQwq+e38M0Bv6eFNlSH+/q6cD8GVVQGiQNm1F7egGygvD+
	 vbG4cDPm9hYrR8VxT9cYRbPk4LkVdU/YYke0mG20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 233/614] iio: imu: bmi270: fix dev_err_probe error msg
Date: Tue, 16 Dec 2025 12:10:00 +0100
Message-ID: <20251216111409.812020813@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>

[ Upstream commit 02f86101e430cce9a99a044b483c4ed5b91bb3b8 ]

The bmi270 can be connected to I2C or a SPI interface. If it is a SPI,
during probe, if devm_regmap_init() fails, it should print the "spi"
term rather "i2c".

Fixes: 92cc50a00574 ("iio: imu: bmi270: Add spi driver for bmi270 imu")
Signed-off-by: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/bmi270/bmi270_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/bmi270/bmi270_spi.c b/drivers/iio/imu/bmi270/bmi270_spi.c
index 19dd7734f9d07..80c9fa1d685ab 100644
--- a/drivers/iio/imu/bmi270/bmi270_spi.c
+++ b/drivers/iio/imu/bmi270/bmi270_spi.c
@@ -60,7 +60,7 @@ static int bmi270_spi_probe(struct spi_device *spi)
 				  &bmi270_spi_regmap_config);
 	if (IS_ERR(regmap))
 		return dev_err_probe(dev, PTR_ERR(regmap),
-				     "Failed to init i2c regmap");
+				     "Failed to init spi regmap\n");
 
 	return bmi270_core_probe(dev, regmap, chip_info);
 }
-- 
2.51.0



