Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058152;
	b=dGMbqbzsQNGQOX0A2s7Ecfvgnflrc3wBQKp/mv86Z6BtJ7GI4iAkBG5xk6XaAAEguqFD
	 ez7ebv+AMQMpvlxhNnmPCBShdGQJwP3UlHo8ZQ34SSEwZOBGEq6+4/blyuHJbwKc2dG11
	 /8P0dLWndO7n2l/kTpyZ9KYni6XcFKab6UDtdgYmVBXO0+MIqehxQVIzkKz7ZX9dZ6dqU
	 ZtOOcU5O0lonHDScro3BCUpV4nxyS+cQ/Hb/VPQ8VUUQfSVicdEX94UAK8+p4x6VZnaqe
	 Vs3HLPBgJmU/4rIwNTBT9JEWw45Dc6bZnT9XJCbdIeeHK8z/GM38ocMOU1GZJ8HyY9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z5ii4OkTZoqE1a46Ll2PduARXF+Zv10u45w1RU2Um4o=;
	b=vN+6PAufSlWIbchYIpIEv7A9EkMmejGwLZqYhhh71/tRBvy2eM/EBPFyXsSP5DUQcdFs
	 Tr36UG1QP2v4hSjlYBmq5v/IBWhTKR9sg1zfo60XVc505VC6OAVKppmTETh4Rk/F+5bA7
	 sBB1K/57UIjLuC3X2r+fPNVwRt0DUwe6/wBE4Xwajnocb7ZsprKoklAbblReVkpZBO7No
	 WzDJO3Dpc7qZjbtR69tuJPzI8VxxPRRWLEsqyC9zlQQDE0KLtTSZic47hsG7v6aKLDTdI
	 CYUHOyEq7cSjZPU6AtFBr5CKmHFSIWKzKeTi6Jd3S1STfRt/2GQyX26BEjPQTHxOn3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHdvpUWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D216E606A326;
	Thu, 19 Nov 2026 03:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHdvpUWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FCB1F000C4;
	Thu, 19 Nov 2026 03:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058152;
	bh=z5ii4OkTZoqE1a46Ll2PduARXF+Zv10u45w1RU2Um4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHdvpUWil/zfyC8MrA+nCxDVpbkfXEoMPMRQfN96YG9Ok+HcA5aAspDkwR4FsIqKU
	 +wXfnHbOiLqNrx+qQLBTOmKXqN/i3/EEh6clYxWOrKp4Gpi0Ot9mgZlWxjA8SSTyQf
	 sxJYfIFSqZVd5f2WfUkuqWGDtRpo/kMR92zlxadI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0383/1848] iio: imu: inv_icm42600: fix odr change not caught in certain cases
Date: Wed, 18 Nov 2026 15:40:21 +0100
Message-ID: <20261118145929.672034758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 55d1c684d8d2f..3ce77447fb2c0 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -773,15 +773,15 @@ int inv_icm42600_accel_parse_fifo(struct iio_dev *indio_dev)
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
index e44c41d8eed82..50dd6b371284e 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -784,15 +784,15 @@ int inv_icm42600_gyro_parse_fifo(struct iio_dev *indio_dev)
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



