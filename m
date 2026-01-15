Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F302D7DED;
	Thu, 15 Jan 2026 17:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498890; cv=none; b=N3MpA8rrR5CpJVrMY4h92JIg5UU8e9MFDKaqcYaNW+yAWAvouY9MefOUxvELvS9rQP5iUg1BZ7wnaudUumPfdVfV3J3dVEVT+Tf6270v0srGFKI+Nrw9sSY8Vb85MJCFIIDr0605VKGnbC1F+G3dPMRu9B265LuBCsPxvxeX5IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498890; c=relaxed/simple;
	bh=eKxp0ptVtyrUh3qlhZBcf4lkjDr2d+A3Uxh1SC270NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ8H4q+Zurgln8JxBsgnHBdxcwcUnE2keePI7KNxjj2/6TEhp2pUjTwMpNV9jczazMrZc0YG2HaU/aSS2QT97eMPdIbdoVgxe58hDojaRQ/dsdX1XGKgDQcT4Yi+UcURJ25xXov+FAzgbezfIgnG5L+5r6c4Tg4sqFpuhjMyqqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIIXsoI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIIXsoI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F8DC116D0;
	Thu, 15 Jan 2026 17:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498890;
	bh=eKxp0ptVtyrUh3qlhZBcf4lkjDr2d+A3Uxh1SC270NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIIXsoI+7CRZ4kEZa7CYEV8G1SkSqT76piTBc3FsyZfq3oljBCDqSGB8lRawYDyNq
	 yHB2U/f4XRptbWCO5M3aQjAj5tSqCiVkQQ2DZkDhw+DlYPvUvM0DtT/5U4mxlYxMHE
	 wMl5APRn/PwiDyqDEz7x6yegGcplgb32yxsHPJ1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/451] iio: imu: st_lsm6dsx: introduce st_lsm6dsx_device_set_enable routine
Date: Thu, 15 Jan 2026 17:43:56 +0100
Message-ID: <20260115164232.162691052@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit cd83c5c10036a2a156d725725daf3409832c8a24 ]

Introduce st_lsm6dsx_device_set_enable utility routine and remove
duplicated code used to enable/disable sensors

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/e3fbe5d4a3bed41130908669f745f78c8505cf47.1665399959.git.lorenzo@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: c6d702f2b771 ("iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h        | 11 +++++++++++
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c | 14 +++-----------
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c   | 14 ++------------
 3 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index 6cf8c3321d6a8..b2202c5ad51e3 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -499,6 +499,17 @@ st_lsm6dsx_get_mount_matrix(const struct iio_dev *iio_dev,
 	return &hw->orientation;
 }
 
+static inline int
+st_lsm6dsx_device_set_enable(struct st_lsm6dsx_sensor *sensor, bool enable)
+{
+	if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
+	    sensor->id == ST_LSM6DSX_ID_EXT1 ||
+	    sensor->id == ST_LSM6DSX_ID_EXT2)
+		return st_lsm6dsx_shub_set_enable(sensor, enable);
+
+	return st_lsm6dsx_sensor_set_enable(sensor, enable);
+}
+
 static const
 struct iio_chan_spec_ext_info __maybe_unused st_lsm6dsx_accel_ext_info[] = {
 	IIO_MOUNT_MATRIX(IIO_SHARED_BY_ALL, st_lsm6dsx_get_mount_matrix),
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index 2e6c634c56c7e..2ac08b8478968 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -678,17 +678,9 @@ int st_lsm6dsx_update_fifo(struct st_lsm6dsx_sensor *sensor, bool enable)
 			goto out;
 	}
 
-	if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
-	    sensor->id == ST_LSM6DSX_ID_EXT1 ||
-	    sensor->id == ST_LSM6DSX_ID_EXT2) {
-		err = st_lsm6dsx_shub_set_enable(sensor, enable);
-		if (err < 0)
-			goto out;
-	} else {
-		err = st_lsm6dsx_sensor_set_enable(sensor, enable);
-		if (err < 0)
-			goto out;
-	}
+	err = st_lsm6dsx_device_set_enable(sensor, enable);
+	if (err < 0)
+		goto out;
 
 	err = st_lsm6dsx_set_fifo_odr(sensor, enable);
 	if (err < 0)
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 2c528425b03b4..ce06ef7d80ee1 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2450,12 +2450,7 @@ static int __maybe_unused st_lsm6dsx_suspend(struct device *dev)
 			continue;
 		}
 
-		if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
-		    sensor->id == ST_LSM6DSX_ID_EXT1 ||
-		    sensor->id == ST_LSM6DSX_ID_EXT2)
-			err = st_lsm6dsx_shub_set_enable(sensor, false);
-		else
-			err = st_lsm6dsx_sensor_set_enable(sensor, false);
+		err = st_lsm6dsx_device_set_enable(sensor, false);
 		if (err < 0)
 			return err;
 
@@ -2486,12 +2481,7 @@ static int __maybe_unused st_lsm6dsx_resume(struct device *dev)
 		if (!(hw->suspend_mask & BIT(sensor->id)))
 			continue;
 
-		if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
-		    sensor->id == ST_LSM6DSX_ID_EXT1 ||
-		    sensor->id == ST_LSM6DSX_ID_EXT2)
-			err = st_lsm6dsx_shub_set_enable(sensor, true);
-		else
-			err = st_lsm6dsx_sensor_set_enable(sensor, true);
+		err = st_lsm6dsx_device_set_enable(sensor, true);
 		if (err < 0)
 			return err;
 
-- 
2.51.0



