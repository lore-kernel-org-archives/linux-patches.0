Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADC130F925;
	Wed,  3 Dec 2025 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776715; cv=none; b=BXMpGyyyqgBjdeWn85ah+l8gm7Gc5/+ixmSRracbSCbcdBoJ2lLCHeiBVhq1fpSJ6Y6J2wF5+CiFm/FyGN9z0e06yYAwseKKd20CVLrF/gwt355/xZsZVRePfqZ5s0+sLh0ISDre0+RAXkSMc0pvxnQTOifOYNA7MGNpMgqFfaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776715; c=relaxed/simple;
	bh=fs2g1LE46cI1eFImU53WiedkhBfpfoThgjfBkR5R0e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4HsiQvn+ncYzQtCIgMmPIWL1nQsxFywc4DYhnRdiL1m6d5fiiUtPeTnoG6qqcQL8OXbfs97U4u5j2bidmtqiY0GUuFom4iqn8LvL+7DFs1bbclAplqMr031Uo2wSHYZpm9hr7rA3hUUMUCJKFWNIJppnujJKaNJVlxKVTQVgkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgAKtYWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgAKtYWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49695C4CEF5;
	Wed,  3 Dec 2025 15:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776714;
	bh=fs2g1LE46cI1eFImU53WiedkhBfpfoThgjfBkR5R0e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgAKtYWVREsA/ogEqSn6O6R/jcuSFxfksVk4DldD+CHjivh2sKLqV9AHKgjfv6ZHA
	 0GDhM7y+8k5YzB2o+dWE3OVxN9LZi3QF2iWQ6n59Q/BGqx/1pIIAMbXStIDgYp1zfl
	 GiH+YaRtJjnDvR/j1SWQnR90L1M8tDlyRGMbnL7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 265/300] iio: imu: st_lsm6dsx: fix array size for st_lsm6dsx_settings fields
Date: Wed,  3 Dec 2025 16:27:49 +0100
Message-ID: <20251203152410.452946631@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Francesco Lavra <flavra@baylibre.com>

commit 3af0c1fb1cdc351b64ff1a4bc06d491490c1f10a upstream.

The `decimator` and `batch` fields of struct st_lsm6dsx_settings
are arrays indexed by sensor type, not by sensor hardware
identifier; moreover, the `batch` field is only used for the
accelerometer and gyroscope.
Change the array size for `decimator` from ST_LSM6DSX_MAX_ID to
ST_LSM6DSX_ID_MAX, and change the array size for `batch` from
ST_LSM6DSX_MAX_ID to 2; move the enum st_lsm6dsx_sensor_id
definition so that the ST_LSM6DSX_ID_MAX value is usable within
the struct st_lsm6dsx_settings definition.

Fixes: 801a6e0af0c6c ("iio: imu: st_lsm6dsx: add support to LSM6DSO")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -221,6 +221,15 @@ struct st_lsm6dsx_event_settings {
 	u8 wakeup_src_x_mask;
 };
 
+enum st_lsm6dsx_sensor_id {
+	ST_LSM6DSX_ID_GYRO,
+	ST_LSM6DSX_ID_ACC,
+	ST_LSM6DSX_ID_EXT0,
+	ST_LSM6DSX_ID_EXT1,
+	ST_LSM6DSX_ID_EXT2,
+	ST_LSM6DSX_ID_MAX
+};
+
 enum st_lsm6dsx_ext_sensor_id {
 	ST_LSM6DSX_ID_MAGN,
 };
@@ -307,23 +316,14 @@ struct st_lsm6dsx_settings {
 	struct st_lsm6dsx_reg drdy_mask;
 	struct st_lsm6dsx_odr_table_entry odr_table[2];
 	struct st_lsm6dsx_fs_table_entry fs_table[2];
-	struct st_lsm6dsx_reg decimator[ST_LSM6DSX_MAX_ID];
-	struct st_lsm6dsx_reg batch[ST_LSM6DSX_MAX_ID];
+	struct st_lsm6dsx_reg decimator[ST_LSM6DSX_ID_MAX];
+	struct st_lsm6dsx_reg batch[2];
 	struct st_lsm6dsx_fifo_ops fifo_ops;
 	struct st_lsm6dsx_hw_ts_settings ts_settings;
 	struct st_lsm6dsx_shub_settings shub_settings;
 	struct st_lsm6dsx_event_settings event_settings;
 };
 
-enum st_lsm6dsx_sensor_id {
-	ST_LSM6DSX_ID_GYRO,
-	ST_LSM6DSX_ID_ACC,
-	ST_LSM6DSX_ID_EXT0,
-	ST_LSM6DSX_ID_EXT1,
-	ST_LSM6DSX_ID_EXT2,
-	ST_LSM6DSX_ID_MAX,
-};
-
 enum st_lsm6dsx_fifo_mode {
 	ST_LSM6DSX_FIFO_BYPASS = 0x0,
 	ST_LSM6DSX_FIFO_CONT = 0x6,


