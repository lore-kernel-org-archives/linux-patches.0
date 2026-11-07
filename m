Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061972;
	b=ONZCRu81USVT6L2kuoTf5sWnoUXphRsyCeIaGp7jAurjhwp1J/wnHCnmotnNQBJOwFWx
	 E4JLtSfEptY5DNGc24H8zEgBtfMz42rh31bQMrDnP2zbO7jZKCGqDYfHCptCxksWtdqv6
	 zB+xgp3UGGvTEiKqkrNCPhnLwjb4WE2LZXVd53QqsIVzQfeGwdRF38O/lYHYa7luATDZx
	 QHyf/ogGoHaysrYqQ6s6Yhp/+0y6vtif8gVGvBc7TNxP7yxXXVwTUifYxwm/AFEX4gmJn
	 B8NZ0irKOWYTeZD2HG3IMhZxUg/rKMRzi0U1KvK/2sZCE+E261q3CetLZxGqXAwrCLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/B4VUzTs4MlEfr4e08omDFT4tT66Vj6nbfjM1aa6j6Q=;
	b=WKZmZcxy8IaWYYQD/rl33mbjxiCHTezbXRc88uVJ/Id+JGJSkGqaIt9K6xiTjTtG8/nq
	 +1ysF+rSVXITx8LkyIsVU003x+l7BsN2MwzKj9NQhitIRNdjxFM8OmSy1C4SyccP/9OO4
	 4gIB/PfWxcc1eQYQE7HEuUNEKtl+6OGIg5/RMh0NeIH4s+SMt/3uhIhR+1VtWziM0NEZJ
	 tQUz1rZT568+TZigLD+bJRurjVDgQYcWUZKQPru7m5iVXMgiHneaBSswU18EnOyIIvZgC
	 837Fx6SmbjMUyDYps5V7Z5BcCHOIDzNriauYCYRFMU35OV+tXhasQau3Q91+7M7jFHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dW5idA75;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F385606A32E;
	Sat,  7 Nov 2026 14:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dW5idA75
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90DB1F0089F;
	Sat,  7 Nov 2026 14:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061972;
	bh=/B4VUzTs4MlEfr4e08omDFT4tT66Vj6nbfjM1aa6j6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dW5idA75QTEWiE7gWbbKfr4h8B2X30loy03IZtrohieVuFo0AEr4hP6sTY4egCvHZ
	 6CoPiv6n8+88Z21KTNyFosf+a9RogBVX7qkbNHKwcpW0WgRvmxZ+U474q1hheA+Ljw
	 TY+Bn4Wl2OqMOFS7EDaLUmxtcMJtsOt2DqdcvSUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0967/1536] iio: imu: inv_icm42600: fix odr change not caught in certain cases
Date: Sat,  7 Nov 2026 08:49:43 -0500
Message-ID: <20261107135024.809216243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit f670d4d3477386d62017936f0121909f93ac17f8 ]

When using both accel and gyro with different frequencies, the ODR
change flag in the FIFO header can be sometime in a packet with
invalid data. Since we are ignoring these packets, we miss the ODR
change and any further change are blocked until sensor is turned off.

Fix this by moving the packet data validity check after the ODR change
flag check.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c | 8 ++++----
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
index 3168bdeffd42a..37fe7ab353a56 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -918,15 +918,15 @@ int inv_icm42600_accel_parse_fifo(struct iio_dev *indio_dev)
 		if (size <= 0)
 			return size;
 
-		/* skip packet if no accel data or data is invalid */
-		if (accel == NULL || !inv_icm42600_fifo_is_data_valid(accel))
-			continue;
-
 		/* update odr */
 		if (odr & INV_ICM42600_SENSOR_ACCEL)
 			inv_sensors_timestamp_apply_odr(ts, st->fifo.period,
 							st->fifo.nb.total, no);
 
+		/* skip packet if no accel data or data is invalid */
+		if (accel == NULL || !inv_icm42600_fifo_is_data_valid(accel))
+			continue;
+
 		memcpy(&buffer.accel, accel, sizeof(buffer.accel));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
index 7997535fcb2f7..5ef684a0043ee 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -822,15 +822,15 @@ int inv_icm42600_gyro_parse_fifo(struct iio_dev *indio_dev)
 		if (size <= 0)
 			return size;
 
-		/* skip packet if no gyro data or data is invalid */
-		if (gyro == NULL || !inv_icm42600_fifo_is_data_valid(gyro))
-			continue;
-
 		/* update odr */
 		if (odr & INV_ICM42600_SENSOR_GYRO)
 			inv_sensors_timestamp_apply_odr(ts, st->fifo.period,
 							st->fifo.nb.total, no);
 
+		/* skip packet if no gyro data or data is invalid */
+		if (gyro == NULL || !inv_icm42600_fifo_is_data_valid(gyro))
+			continue;
+
 		memcpy(&buffer.gyro, gyro, sizeof(buffer.gyro));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;
-- 
2.53.0



