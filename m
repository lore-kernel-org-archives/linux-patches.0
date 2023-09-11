Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C794411716
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A68C433CB;
	Mon, 11 Sep 2023 14:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441649;
	bh=Uay2A6HFMFHtlxqD2n/wWLqrubh+01zMuqF3cc/piRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXAWYOePcLuldhaNU0xSH038df+1fCDuXjVi6Y9hMIOaQ4rzR6qr1QeoTgmCkYK8+
	 tgXdLkhbC6Hpbfk6phSC6LkTLC0GFP+VMxvweJlV6HnZrGZW+tzckeCe/rzE3RHqcy
	 +HKZMtNL/91ES1GjIx4A0U+k/MJv0tNQM6oc1lww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 487/739] iio: accel: adxl313: Fix adxl313_i2c_id[] table
Date: Mon, 11 Sep 2023 15:44:46 +0200
Message-ID: <20230911134704.737699584@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit f636554c4cd1c644109cc525900a056495b86cc9 ]

The .driver_data in adxl313_i2c_id[] for adxl312 and adxl314 is
wrong. Fix this issue by adding corresponding adxl31x_chip_info
data.

Reported-by: Jonathan Cameron <jic23@kernel.org>
Closes: https://lore.kernel.org/all/20230722172832.04ad7738@jic23-huawei
Fixes: a7a1c60bc4c9 ("drivers: iio: accel: adxl312 and adxl314 support")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230725171624.331283-2-biju.das.jz@bp.renesas.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl313_i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/adxl313_i2c.c b/drivers/iio/accel/adxl313_i2c.c
index 524327ea36631..e0a860ab9e58f 100644
--- a/drivers/iio/accel/adxl313_i2c.c
+++ b/drivers/iio/accel/adxl313_i2c.c
@@ -40,8 +40,8 @@ static const struct regmap_config adxl31x_i2c_regmap_config[] = {
 
 static const struct i2c_device_id adxl313_i2c_id[] = {
 	{ .name = "adxl312", .driver_data = (kernel_ulong_t)&adxl31x_chip_info[ADXL312] },
-	{ .name = "adxl313", .driver_data = (kernel_ulong_t)&adxl31x_chip_info[ADXL312] },
-	{ .name = "adxl314", .driver_data = (kernel_ulong_t)&adxl31x_chip_info[ADXL312] },
+	{ .name = "adxl313", .driver_data = (kernel_ulong_t)&adxl31x_chip_info[ADXL313] },
+	{ .name = "adxl314", .driver_data = (kernel_ulong_t)&adxl31x_chip_info[ADXL314] },
 	{ }
 };
 
-- 
2.40.1



