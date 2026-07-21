Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9E93BE641;
	Tue, 21 Jul 2026 21:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670462; cv=none; b=gR9SyDSUSSmDBbZhKH6QAwBL45QpDwmWJHfN2euJ5tP6dLW7YE7hFx+pgDEHWpCIyQZ2FVnjmikuTI/jzPUfDZN9PGKE/Xn6w4X6smqdb1MuqjG61Gv6e34nmR+B95M/1lNfyAHxr0Fzo5/tOeDxNObTa3LtFujU353ziZyeJYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670462; c=relaxed/simple;
	bh=NL65QRulvMn0dJpQJdExLE8nouH/SP9bFM1ZehgYb9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDagqPa/IeoPVg58GrrQLoPzZoOBhKwP3PuRfHfygxqKFWIQpODFKJbljwoes8+TbIgo8l3FxAwoT0rV8t/QT/ZXWtp6SfGCnqXWlVDyO1rmVVRBRxw9Ot/1YQ0OZ6SNGK3DASMYm11dAZ/Re4VpiUTCoKPKVwQnABR8KcTNBpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ym2nADyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ym2nADyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061EE1F000E9;
	Tue, 21 Jul 2026 21:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670460;
	bh=pr8Pw6/s83/YMwrr0HVYGIAD3kfrMYAu+7ebTeymbrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ym2nADyKSC33YtXrpcVf5ENW4oQ9uvnGucRjVxE3xi2w9KOWlhZEx8E4Vq+NlZPEl
	 o6jQh1TB+jezuR5LWEyupVS1QyXOVIiLsrOxTBbIyzLHtOlLaWvQESPmdpVR0D1NQ7
	 Z8nMUeywUN+rn4igqswzmz3YSxvjsJuEv9vWLTO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0942/1067] iio: imu: inv_icm42600: make timestamp module chip independent
Date: Tue, 21 Jul 2026 17:25:43 +0200
Message-ID: <20260721152445.605939096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


