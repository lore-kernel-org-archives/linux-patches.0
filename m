Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9C332E125;
	Wed,  3 Dec 2025 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777026; cv=none; b=TK7LcYWno91TsS28zXS2ghzyKVbvr/3JLXS8bwRl+Gm1zk9ZvHTA6WNwdPsEYge1sPfsNcujf5v1ji8Eqpdi5XBVCI5BM6bc0vc0Grq8qqRUfVxly8IbrJ7QSzfoy59c5LOCmgL9hGeTQIE3izt8d+yIAGyluJBhtmF7GpWSEew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777026; c=relaxed/simple;
	bh=lIlqhl54AoaOxlKoHUOTn5nnaJoAyGMMq8CO4GN40t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiTGFf4Hw8F8z9wnXAfLP9hICVYJo9N47gRhkF/mQoMj+biSj2K/7J40kJtTB+3IG/gfJhvsNHrntVQdaWCU+XH0/7Skm+F3h6+kWpcJl7kB5zikTWOw1mqY8SZrHwZl0MD6N+X0muZ4NwfL2RtQRBLB1wwZAFXbON0fmHBt4E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkM0KKIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkM0KKIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF4FC4CEF5;
	Wed,  3 Dec 2025 15:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777025;
	bh=lIlqhl54AoaOxlKoHUOTn5nnaJoAyGMMq8CO4GN40t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkM0KKIcelPBEh1CFonF33DrHGXS0fqPhNVjpsFlHrqhgw2J9V9BAxM8ircSAl8B4
	 c4rhyNE+swW79IXc/9OPZzWRItploHjW62IkxeqRStKMQC1B0UybOUEghdDIVu4vW3
	 YGwIA+kbbHu62HFe4eGuoUc0Brh7C14cCYI5qqzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 059/146] iio: imu: st_lsm6dsx: fix array size for st_lsm6dsx_settings fields
Date: Wed,  3 Dec 2025 16:27:17 +0100
Message-ID: <20251203152348.629216764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -270,6 +270,15 @@ struct st_lsm6dsx_event_settings {
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
@@ -355,23 +364,14 @@ struct st_lsm6dsx_settings {
 	struct st_lsm6dsx_odr_table_entry odr_table[2];
 	struct st_lsm6dsx_samples_to_discard samples_to_discard[2];
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


