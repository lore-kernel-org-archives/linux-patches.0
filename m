Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035885;
	b=5UkSixS+GhEYUgTIncvEi7kabd1S7Z2ombyvHZdDZmhrS4sogXM8zQu46IFQfnQz30hK
	 vH0LEy0H16edK9qcOn9aXl0AG6oe/w1zl51ojZumJVEnEhOSkRNqxZEeXzW9vBvZo+z0H
	 NMLFpyJI3Ogs0OEDsk9kipTJW4raslKQq1luv5ZLahm71Uufkfmb/ApqlnMiI+AhNR70T
	 cTN4AZwfQNJYEdIE5JCUMfjGc9WxrDE7I1tsYWc2FnLh5MfUqojvC/XWezhurX0i1uhc9
	 BYVM7zRPjhuquz+5RJ+PDNa7Qnx1a+5+IEI2fERbRqzGJRiewXH1oP+bVQHnwWopWPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nndUG+BIEWVCu497RK96Lt091MmHV+fHWLwC+9vMNlA=;
	b=jvYLp6fmdjRst4Obw9OIHcKkN72TAjlLyUtX09Y0s5hHzPH/QsqQfYWiis8TZTUvhDb0
	 ioaxOFY8EJHlARF2W6Gmtt1p49U0JxHRdwvRJfFj2Ok/8Q2YpuAHOhHCIIssYxJNRaQd/
	 gins1ZF1k6fb1i6M0b6/vvzLT4Ophoiy+tInb30+D+EMCDfWQ37AHFH715O8/dcq1DyYL
	 1agXS8Quyje/X63cnwNnEMHQE5y1WBr6AgnVcTl+EKFEVeq61/ESOTMu8DeUjQvFVDqeG
	 Eqf8M2FkFDeBCoP5Lm4HAwVJnogt+76Ndb34U8nXXPttjWI2V+/omoD4CcmHBbJHnSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BS23uVnP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3761D606A33B;
	Wed, 18 Nov 2026 21:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BS23uVnP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843E81F000C5;
	Wed, 18 Nov 2026 21:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035885;
	bh=nndUG+BIEWVCu497RK96Lt091MmHV+fHWLwC+9vMNlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BS23uVnP+2qaBNvYJ0JVTfMQeL4HQciX9txHTbj+FxtsR5yA9/FD+08dfeK71QHaB
	 1vRoo2t/ceUrdnXU1PEqjMP/0ecv6/0DPgUxJOYUaXplRlHRyFWERlDjbVZrrt4yCb
	 1CytWRsW9Kbb1BiJUfLzWYOl9VTi1ryPGOMTUv48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0861/3318] iio: imu: inv_icm42600: fix odr change not caught in certain cases
Date: Wed, 18 Nov 2026 15:24:43 +0100
Message-ID: <20261118150345.115670877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f260a4d07b29f..f3010befd2e09 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -768,15 +768,15 @@ int inv_icm42600_accel_parse_fifo(struct iio_dev *indio_dev)
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
index 49d2e18c3a8ec..311419d9788d5 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -780,15 +780,15 @@ int inv_icm42600_gyro_parse_fifo(struct iio_dev *indio_dev)
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



