Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5321C286D57;
	Tue, 26 Aug 2025 11:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208874; cv=none; b=qcgXIw1iG971yWH2JScHzpaqVSSEVbladMVG8hCViF3cUFOXXqfdjqoQ5l/VMUlsj88d+6taJTofbsU83oOyw27myJaUTQH5SsYiC+ZNjY/SGfmrs0K5qmMVOLGJ45PbrhZbgFOO2FNd6qnX089t7TA6RmvlCMMLjQSPvPdrNok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208874; c=relaxed/simple;
	bh=hqGTZMlTN9PmVkfD9dOuLp027En1Zv8jf/cKI6plkS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4NEy0HMZivMajju47Ugw9aUpU6qy7c7X9VQwgu1e12Bk7tifZ9elaF1juNBgmq6V2iYk7w1SDOGV89SDL4AaVftqhqg4sGWAl7USCClUnOAunrrkT2OkqSA0WikDPITtewPlZan9mMs6JR75ud2x48JGW1uOTzr3Nny5YiMyP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Shs08DBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Shs08DBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F42C4CEF1;
	Tue, 26 Aug 2025 11:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208874;
	bh=hqGTZMlTN9PmVkfD9dOuLp027En1Zv8jf/cKI6plkS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Shs08DBZb5sa11ys5CXZ095gGfS8RwEB/TqVkALhxrSBG/RoFYCP9t7GpK78ycKG6
	 gJ6zC0BIUurMpl2f/H5DZfIKDA9XoCYZZvetSqJeGo16FzSc3M7ZEmS2w3yDw51un4
	 HJs4/spBxtBLirTmK+deTCbcg//jCD/jG95Vlih8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/322] iio: imu: inv_icm42600: switch timestamp type from int64_t __aligned(8) to aligned_s64
Date: Tue, 26 Aug 2025 13:11:02 +0200
Message-ID: <20250826110922.021831561@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 27e6ddf291b1c05bfcc3534e8212ed6c46447c60 ]

The vast majority of IIO drivers use aligned_s64 for the type of the
timestamp field.  It is not a bug to use int64_t and until this series
iio_push_to_buffers_with_timestamp() took and int64_t timestamp, it
is inconsistent.  This change is to remove that inconsistency and
ensure there is one obvious choice for future drivers.

Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20241215182912.481706-19-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: dfdc31e7ccf3 ("iio: imu: inv_icm42600: change invalid data error to -EBUSY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c |    2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -178,7 +178,7 @@ static const struct iio_chan_spec inv_ic
 struct inv_icm42600_accel_buffer {
 	struct inv_icm42600_fifo_sensor_data accel;
 	int16_t temp;
-	int64_t timestamp __aligned(8);
+	aligned_s64 timestamp;
 };
 
 #define INV_ICM42600_SCAN_MASK_ACCEL_3AXIS				\
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -78,7 +78,7 @@ static const struct iio_chan_spec inv_ic
 struct inv_icm42600_gyro_buffer {
 	struct inv_icm42600_fifo_sensor_data gyro;
 	int16_t temp;
-	int64_t timestamp __aligned(8);
+	aligned_s64 timestamp;
 };
 
 #define INV_ICM42600_SCAN_MASK_GYRO_3AXIS				\


