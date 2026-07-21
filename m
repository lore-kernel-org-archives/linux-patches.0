Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CBA43B6E1;
	Tue, 21 Jul 2026 22:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674558; cv=none; b=Tk/8qO1keoQ81yODM5QuDFuDKnxh4/38OwB83OT/OIo3xVolhI4EaxOpOLsNUYTKFXqihYKlS7F+Ii+SjjAUe2tQe0abUyqPxdG6Tnr2eU4GySUIkac/9uChIkCI8jNIEoIJqtCp7Q6RiUhO9Zl1M5WryIj5IFePZ4yMPcFI7UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674558; c=relaxed/simple;
	bh=TEhFc/rc3Ehic7QRvw6+dpCoNsr3Yy3ZEvUwoL8q2C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duAX/QgO4Ea7PkB4UsGiunx0E9wH3dE3hRtecU8C4+AlsGjfSQsOKigL9Xeqb56/O3N/rJ+BUOaq0sXTiAmpZ8i5R1LfcL1nA3AUKTou/3z1vosLoNLz6eOGRTelFvvvMrY0r8eAYCKvrMvWbTjySdIQCsBG2e+Na/wMjoUR6TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB9TVbAo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB9TVbAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334EE1F00A3D;
	Tue, 21 Jul 2026 22:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674556;
	bh=Zio82+suwSaOnJtJbT972zQq6BV9OsZ6GMQozpl/UcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JB9TVbAok2VYhhhLnofm8zxPC6XoCXI/yoEB0lr/d+2s3EH6xcCQMdB8jRRoU6YJj
	 nKg7StzRTFot4kgfY/TWEpb3ousZALPDuWhrYPTHd84zZX7NIieu2ZvthjljVgPjuw
	 7KDVxEWa8HsU3qZcegZNMFv6RUKySMs7lq8Knf0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 584/699] iio: imu: inv_icm42600: make timestamp module chip independent
Date: Tue, 21 Jul 2026 17:25:43 +0200
Message-ID: <20260721152408.889107816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit 6e9f2d8375cb24ba75e02e0272e9164d06a1522e ]

Move icm42600 dependent function inside the core module.
Do some headers cleanup at the same time.

Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20230606162147.79667-2-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: affe3f077d7a ("iio: imu: inv_icm42600: fix timestamping by limiting FIFO reading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c      |   11 +++++++++++
 drivers/iio/imu/inv_icm42600/inv_icm42600_timestamp.c |   14 +-------------
 drivers/iio/imu/inv_icm42600/inv_icm42600_timestamp.h |    6 ------
 3 files changed, 12 insertions(+), 19 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -522,6 +522,17 @@ static int inv_icm42600_irq_init(struct
 					 "inv_icm42600", st);
 }
 
+static int inv_icm42600_timestamp_setup(struct inv_icm42600_state *st)
+{
+	unsigned int val;
+
+	/* enable timestamp register */
+	val = INV_ICM42600_TMST_CONFIG_TMST_TO_REGS_EN |
+	      INV_ICM42600_TMST_CONFIG_TMST_EN;
+	return regmap_update_bits(st->map, INV_ICM42600_REG_TMST_CONFIG,
+				  INV_ICM42600_TMST_CONFIG_MASK, val);
+}
+
 static int inv_icm42600_enable_regulator_vddio(struct inv_icm42600_state *st)
 {
 	int ret;
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_timestamp.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_timestamp.c
@@ -3,11 +3,10 @@
  * Copyright (C) 2020 Invensense, Inc.
  */
 
+#include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/regmap.h>
 #include <linux/math64.h>
 
-#include "inv_icm42600.h"
 #include "inv_icm42600_timestamp.h"
 
 /* internal chip period is 32kHz, 31250ns */
@@ -56,17 +55,6 @@ void inv_icm42600_timestamp_init(struct
 	inv_update_acc(&ts->chip_period, INV_ICM42600_TIMESTAMP_PERIOD);
 }
 
-int inv_icm42600_timestamp_setup(struct inv_icm42600_state *st)
-{
-	unsigned int val;
-
-	/* enable timestamp register */
-	val = INV_ICM42600_TMST_CONFIG_TMST_TO_REGS_EN |
-	      INV_ICM42600_TMST_CONFIG_TMST_EN;
-	return regmap_update_bits(st->map, INV_ICM42600_REG_TMST_CONFIG,
-				  INV_ICM42600_TMST_CONFIG_MASK, val);
-}
-
 int inv_icm42600_timestamp_update_odr(struct inv_icm42600_timestamp *ts,
 				      uint32_t period, bool fifo)
 {
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_timestamp.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_timestamp.h
@@ -6,10 +6,6 @@
 #ifndef INV_ICM42600_TIMESTAMP_H_
 #define INV_ICM42600_TIMESTAMP_H_
 
-#include <linux/kernel.h>
-
-struct inv_icm42600_state;
-
 /**
  * struct inv_icm42600_timestamp_interval - timestamps interval
  * @lo:	interval lower bound
@@ -53,8 +49,6 @@ struct inv_icm42600_timestamp {
 void inv_icm42600_timestamp_init(struct inv_icm42600_timestamp *ts,
 				 uint32_t period);
 
-int inv_icm42600_timestamp_setup(struct inv_icm42600_state *st);
-
 int inv_icm42600_timestamp_update_odr(struct inv_icm42600_timestamp *ts,
 				      uint32_t period, bool fifo);
 


