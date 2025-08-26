Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8C23376A5;
	Tue, 26 Aug 2025 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213957; cv=none; b=XKliEVnt6i4Q3cnCFEHRJlSNQE+KuRlBksQB1OaBiM16z/PMreZQ0a93cQLx9zgpy/hJeh4SrfK5j6lMwHcvatVVo+05CmwIJda6ZE1oOOJDBlL9KCJ8qC8bkX92aI/w5ZS+eQRVawUyftivtRgjh0VkoRy7BVzrNO77C3qKszU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213957; c=relaxed/simple;
	bh=ncrm5XD4J8G1nxkrmU5bviJX2SIyRmDoel0eZlUS0yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGmAQFZ2/hgx52y20r5X4/S1UX845Tnajm1PcXwbriA4bVRafMilHUJ30fe/LmJtbZh6/V07EmLBMpuky/v/G9WuqJWxpnfnAP5d5e2sbvtRtxXassBZp+fd6w08F7XmUvgm6gRqY2Zmq7MgfIq5mQWKSKq1epbfl3Pdw28ZhSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rg0WPw/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rg0WPw/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71FCC4CEF1;
	Tue, 26 Aug 2025 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213957;
	bh=ncrm5XD4J8G1nxkrmU5bviJX2SIyRmDoel0eZlUS0yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rg0WPw/seA2a01VEPYE4TQGbrblFn5v5j1qEcKxzi+w9I+2lE/7vqnrwIUPninH/J
	 UwuOywpnj5NaQ6//3KOUUvWE5zM5KHxm0jdhKj4HnrzimaHgzVaDFIgLVVW6YNAM90
	 wDMhOi9vCGlZaluVI99ZUSDdculzQ3qqhc/77tAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 542/587] iio: imu: inv_icm42600: Convert to uXX and sXX integer types
Date: Tue, 26 Aug 2025 13:11:31 +0200
Message-ID: <20250826111006.805933936@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a4135386fa49c2a170b89296da12c4a3be2089d9 ]

The driver code is full of intXX_t and uintXX_t types which is
not the pattern we use in the IIO subsystem. Switch the driver
to use kernel internal types for that. No functional changes.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20250616090423.575736-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: dfdc31e7ccf3 ("iio: imu: inv_icm42600: change invalid data error to -EBUSY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |    8 ++--
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   26 +++++++--------
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   22 ++++++------
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h |   10 ++---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |    6 +--
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   36 ++++++++++-----------
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c   |    6 +--
 7 files changed, 57 insertions(+), 57 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -142,11 +142,11 @@ struct inv_icm42600_state {
 	struct inv_icm42600_suspended suspended;
 	struct iio_dev *indio_gyro;
 	struct iio_dev *indio_accel;
-	uint8_t buffer[2] __aligned(IIO_DMA_MINALIGN);
+	u8 buffer[2] __aligned(IIO_DMA_MINALIGN);
 	struct inv_icm42600_fifo fifo;
 	struct {
-		int64_t gyro;
-		int64_t accel;
+		s64 gyro;
+		s64 accel;
 	} timestamp;
 };
 
@@ -369,7 +369,7 @@ const struct iio_mount_matrix *
 inv_icm42600_get_mount_matrix(const struct iio_dev *indio_dev,
 			      const struct iio_chan_spec *chan);
 
-uint32_t inv_icm42600_odr_to_period(enum inv_icm42600_odr odr);
+u32 inv_icm42600_odr_to_period(enum inv_icm42600_odr odr);
 
 int inv_icm42600_set_accel_conf(struct inv_icm42600_state *st,
 				struct inv_icm42600_sensor_conf *conf,
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -77,7 +77,7 @@ static const struct iio_chan_spec inv_ic
  */
 struct inv_icm42600_accel_buffer {
 	struct inv_icm42600_fifo_sensor_data accel;
-	int16_t temp;
+	s16 temp;
 	aligned_s64 timestamp;
 };
 
@@ -142,7 +142,7 @@ out_unlock:
 
 static int inv_icm42600_accel_read_sensor(struct inv_icm42600_state *st,
 					  struct iio_chan_spec const *chan,
-					  int16_t *val)
+					  s16 *val)
 {
 	struct device *dev = regmap_get_device(st->map);
 	struct inv_icm42600_sensor_conf conf = INV_ICM42600_SENSOR_CONF_INIT;
@@ -182,7 +182,7 @@ static int inv_icm42600_accel_read_senso
 	if (ret)
 		goto exit;
 
-	*val = (int16_t)be16_to_cpup(data);
+	*val = (s16)be16_to_cpup(data);
 	if (*val == INV_ICM42600_DATA_INVALID)
 		ret = -EINVAL;
 exit:
@@ -359,11 +359,11 @@ static int inv_icm42600_accel_read_offse
 					  int *val, int *val2)
 {
 	struct device *dev = regmap_get_device(st->map);
-	int64_t val64;
-	int32_t bias;
+	s64 val64;
+	s32 bias;
 	unsigned int reg;
-	int16_t offset;
-	uint8_t data[2];
+	s16 offset;
+	u8 data[2];
 	int ret;
 
 	if (chan->type != IIO_ACCEL)
@@ -417,7 +417,7 @@ static int inv_icm42600_accel_read_offse
 	 * result in micro (1000000)
 	 * (offset * 5 * 9.806650 * 1000000) / 10000
 	 */
-	val64 = (int64_t)offset * 5LL * 9806650LL;
+	val64 = (s64)offset * 5LL * 9806650LL;
 	/* for rounding, add + or - divisor (10000) divided by 2 */
 	if (val64 >= 0)
 		val64 += 10000LL / 2LL;
@@ -435,10 +435,10 @@ static int inv_icm42600_accel_write_offs
 					   int val, int val2)
 {
 	struct device *dev = regmap_get_device(st->map);
-	int64_t val64;
-	int32_t min, max;
+	s64 val64;
+	s32 min, max;
 	unsigned int reg, regval;
-	int16_t offset;
+	s16 offset;
 	int ret;
 
 	if (chan->type != IIO_ACCEL)
@@ -463,7 +463,7 @@ static int inv_icm42600_accel_write_offs
 	      inv_icm42600_accel_calibbias[1];
 	max = inv_icm42600_accel_calibbias[4] * 1000000L +
 	      inv_icm42600_accel_calibbias[5];
-	val64 = (int64_t)val * 1000000LL + (int64_t)val2;
+	val64 = (s64)val * 1000000LL + (s64)val2;
 	if (val64 < min || val64 > max)
 		return -EINVAL;
 
@@ -538,7 +538,7 @@ static int inv_icm42600_accel_read_raw(s
 				       int *val, int *val2, long mask)
 {
 	struct inv_icm42600_state *st = iio_device_get_drvdata(indio_dev);
-	int16_t data;
+	s16 data;
 	int ret;
 
 	switch (chan->type) {
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -26,28 +26,28 @@
 #define INV_ICM42600_FIFO_HEADER_ODR_GYRO	BIT(0)
 
 struct inv_icm42600_fifo_1sensor_packet {
-	uint8_t header;
+	u8 header;
 	struct inv_icm42600_fifo_sensor_data data;
-	int8_t temp;
+	s8 temp;
 } __packed;
 #define INV_ICM42600_FIFO_1SENSOR_PACKET_SIZE		8
 
 struct inv_icm42600_fifo_2sensors_packet {
-	uint8_t header;
+	u8 header;
 	struct inv_icm42600_fifo_sensor_data accel;
 	struct inv_icm42600_fifo_sensor_data gyro;
-	int8_t temp;
+	s8 temp;
 	__be16 timestamp;
 } __packed;
 #define INV_ICM42600_FIFO_2SENSORS_PACKET_SIZE		16
 
 ssize_t inv_icm42600_fifo_decode_packet(const void *packet, const void **accel,
-					const void **gyro, const int8_t **temp,
+					const void **gyro, const s8 **temp,
 					const void **timestamp, unsigned int *odr)
 {
 	const struct inv_icm42600_fifo_1sensor_packet *pack1 = packet;
 	const struct inv_icm42600_fifo_2sensors_packet *pack2 = packet;
-	uint8_t header = *((const uint8_t *)packet);
+	u8 header = *((const u8 *)packet);
 
 	/* FIFO empty */
 	if (header & INV_ICM42600_FIFO_HEADER_MSG) {
@@ -100,7 +100,7 @@ ssize_t inv_icm42600_fifo_decode_packet(
 
 void inv_icm42600_buffer_update_fifo_period(struct inv_icm42600_state *st)
 {
-	uint32_t period_gyro, period_accel, period;
+	u32 period_gyro, period_accel, period;
 
 	if (st->fifo.en & INV_ICM42600_SENSOR_GYRO)
 		period_gyro = inv_icm42600_odr_to_period(st->conf.gyro.odr);
@@ -204,8 +204,8 @@ int inv_icm42600_buffer_update_watermark
 {
 	size_t packet_size, wm_size;
 	unsigned int wm_gyro, wm_accel, watermark;
-	uint32_t period_gyro, period_accel, period;
-	uint32_t latency_gyro, latency_accel, latency;
+	u32 period_gyro, period_accel, period;
+	u32 latency_gyro, latency_accel, latency;
 	bool restore;
 	__le16 raw_wm;
 	int ret;
@@ -451,7 +451,7 @@ int inv_icm42600_buffer_fifo_read(struct
 	__be16 *raw_fifo_count;
 	ssize_t i, size;
 	const void *accel, *gyro, *timestamp;
-	const int8_t *temp;
+	const s8 *temp;
 	unsigned int odr;
 	int ret;
 
@@ -538,7 +538,7 @@ int inv_icm42600_buffer_hwfifo_flush(str
 				     unsigned int count)
 {
 	struct inv_sensors_timestamp *ts;
-	int64_t gyro_ts, accel_ts;
+	s64 gyro_ts, accel_ts;
 	int ret;
 
 	gyro_ts = iio_get_time_ns(st->indio_gyro);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h
@@ -28,7 +28,7 @@ struct inv_icm42600_state;
 struct inv_icm42600_fifo {
 	unsigned int on;
 	unsigned int en;
-	uint32_t period;
+	u32 period;
 	struct {
 		unsigned int gyro;
 		unsigned int accel;
@@ -39,7 +39,7 @@ struct inv_icm42600_fifo {
 		size_t accel;
 		size_t total;
 	} nb;
-	uint8_t data[2080] __aligned(IIO_DMA_MINALIGN);
+	u8 data[2080] __aligned(IIO_DMA_MINALIGN);
 };
 
 /* FIFO data packet */
@@ -50,7 +50,7 @@ struct inv_icm42600_fifo_sensor_data {
 } __packed;
 #define INV_ICM42600_FIFO_DATA_INVALID		-32768
 
-static inline int16_t inv_icm42600_fifo_get_sensor_data(__be16 d)
+static inline s16 inv_icm42600_fifo_get_sensor_data(__be16 d)
 {
 	return be16_to_cpu(d);
 }
@@ -58,7 +58,7 @@ static inline int16_t inv_icm42600_fifo_
 static inline bool
 inv_icm42600_fifo_is_data_valid(const struct inv_icm42600_fifo_sensor_data *s)
 {
-	int16_t x, y, z;
+	s16 x, y, z;
 
 	x = inv_icm42600_fifo_get_sensor_data(s->x);
 	y = inv_icm42600_fifo_get_sensor_data(s->y);
@@ -73,7 +73,7 @@ inv_icm42600_fifo_is_data_valid(const st
 }
 
 ssize_t inv_icm42600_fifo_decode_packet(const void *packet, const void **accel,
-					const void **gyro, const int8_t **temp,
+					const void **gyro, const s8 **temp,
 					const void **timestamp, unsigned int *odr);
 
 extern const struct iio_buffer_setup_ops inv_icm42600_buffer_ops;
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -56,7 +56,7 @@ const struct regmap_config inv_icm42600_
 EXPORT_SYMBOL_NS_GPL(inv_icm42600_spi_regmap_config, IIO_ICM42600);
 
 struct inv_icm42600_hw {
-	uint8_t whoami;
+	u8 whoami;
 	const char *name;
 	const struct inv_icm42600_conf *conf;
 };
@@ -115,9 +115,9 @@ inv_icm42600_get_mount_matrix(const stru
 	return &st->orientation;
 }
 
-uint32_t inv_icm42600_odr_to_period(enum inv_icm42600_odr odr)
+u32 inv_icm42600_odr_to_period(enum inv_icm42600_odr odr)
 {
-	static uint32_t odr_periods[INV_ICM42600_ODR_NB] = {
+	static u32 odr_periods[INV_ICM42600_ODR_NB] = {
 		/* reserved values */
 		0, 0, 0,
 		/* 8kHz */
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -77,7 +77,7 @@ static const struct iio_chan_spec inv_ic
  */
 struct inv_icm42600_gyro_buffer {
 	struct inv_icm42600_fifo_sensor_data gyro;
-	int16_t temp;
+	s16 temp;
 	aligned_s64 timestamp;
 };
 
@@ -142,7 +142,7 @@ out_unlock:
 
 static int inv_icm42600_gyro_read_sensor(struct inv_icm42600_state *st,
 					 struct iio_chan_spec const *chan,
-					 int16_t *val)
+					 s16 *val)
 {
 	struct device *dev = regmap_get_device(st->map);
 	struct inv_icm42600_sensor_conf conf = INV_ICM42600_SENSOR_CONF_INIT;
@@ -182,7 +182,7 @@ static int inv_icm42600_gyro_read_sensor
 	if (ret)
 		goto exit;
 
-	*val = (int16_t)be16_to_cpup(data);
+	*val = (s16)be16_to_cpup(data);
 	if (*val == INV_ICM42600_DATA_INVALID)
 		ret = -EINVAL;
 exit:
@@ -371,11 +371,11 @@ static int inv_icm42600_gyro_read_offset
 					 int *val, int *val2)
 {
 	struct device *dev = regmap_get_device(st->map);
-	int64_t val64;
-	int32_t bias;
+	s64 val64;
+	s32 bias;
 	unsigned int reg;
-	int16_t offset;
-	uint8_t data[2];
+	s16 offset;
+	u8 data[2];
 	int ret;
 
 	if (chan->type != IIO_ANGL_VEL)
@@ -429,7 +429,7 @@ static int inv_icm42600_gyro_read_offset
 	 * result in nano (1000000000)
 	 * (offset * 64 * Pi * 1000000000) / (2048 * 180)
 	 */
-	val64 = (int64_t)offset * 64LL * 3141592653LL;
+	val64 = (s64)offset * 64LL * 3141592653LL;
 	/* for rounding, add + or - divisor (2048 * 180) divided by 2 */
 	if (val64 >= 0)
 		val64 += 2048 * 180 / 2;
@@ -447,9 +447,9 @@ static int inv_icm42600_gyro_write_offse
 					  int val, int val2)
 {
 	struct device *dev = regmap_get_device(st->map);
-	int64_t val64, min, max;
+	s64 val64, min, max;
 	unsigned int reg, regval;
-	int16_t offset;
+	s16 offset;
 	int ret;
 
 	if (chan->type != IIO_ANGL_VEL)
@@ -470,11 +470,11 @@ static int inv_icm42600_gyro_write_offse
 	}
 
 	/* inv_icm42600_gyro_calibbias: min - step - max in nano */
-	min = (int64_t)inv_icm42600_gyro_calibbias[0] * 1000000000LL +
-	      (int64_t)inv_icm42600_gyro_calibbias[1];
-	max = (int64_t)inv_icm42600_gyro_calibbias[4] * 1000000000LL +
-	      (int64_t)inv_icm42600_gyro_calibbias[5];
-	val64 = (int64_t)val * 1000000000LL + (int64_t)val2;
+	min = (s64)inv_icm42600_gyro_calibbias[0] * 1000000000LL +
+	      (s64)inv_icm42600_gyro_calibbias[1];
+	max = (s64)inv_icm42600_gyro_calibbias[4] * 1000000000LL +
+	      (s64)inv_icm42600_gyro_calibbias[5];
+	val64 = (s64)val * 1000000000LL + (s64)val2;
 	if (val64 < min || val64 > max)
 		return -EINVAL;
 
@@ -549,7 +549,7 @@ static int inv_icm42600_gyro_read_raw(st
 				      int *val, int *val2, long mask)
 {
 	struct inv_icm42600_state *st = iio_device_get_drvdata(indio_dev);
-	int16_t data;
+	s16 data;
 	int ret;
 
 	switch (chan->type) {
@@ -764,9 +764,9 @@ int inv_icm42600_gyro_parse_fifo(struct
 	ssize_t i, size;
 	unsigned int no;
 	const void *accel, *gyro, *timestamp;
-	const int8_t *temp;
+	const s8 *temp;
 	unsigned int odr;
-	int64_t ts_val;
+	s64 ts_val;
 	/* buffer is copied to userspace, zeroing it to avoid any data leak */
 	struct inv_icm42600_gyro_buffer buffer = { };
 
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c
@@ -13,7 +13,7 @@
 #include "inv_icm42600.h"
 #include "inv_icm42600_temp.h"
 
-static int inv_icm42600_temp_read(struct inv_icm42600_state *st, int16_t *temp)
+static int inv_icm42600_temp_read(struct inv_icm42600_state *st, s16 *temp)
 {
 	struct device *dev = regmap_get_device(st->map);
 	__be16 *raw;
@@ -31,7 +31,7 @@ static int inv_icm42600_temp_read(struct
 	if (ret)
 		goto exit;
 
-	*temp = (int16_t)be16_to_cpup(raw);
+	*temp = (s16)be16_to_cpup(raw);
 	if (*temp == INV_ICM42600_DATA_INVALID)
 		ret = -EINVAL;
 
@@ -48,7 +48,7 @@ int inv_icm42600_temp_read_raw(struct ii
 			       int *val, int *val2, long mask)
 {
 	struct inv_icm42600_state *st = iio_device_get_drvdata(indio_dev);
-	int16_t temp;
+	s16 temp;
 	int ret;
 
 	if (chan->type != IIO_TEMP)


