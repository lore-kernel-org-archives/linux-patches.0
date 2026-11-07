Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062892;
	b=qLU4AiYTUh0xcTnQ2+MZy46iS+BZgWtLCO5pPKy4IatyFwNVU7y/yGWjdangEPnog9xs
	 MHR1RnHI/50lnh4gI64pQFPqtn8aqbqBx1MXcD6Lc8MTdmhcDqBOKE7G/OS6OPwZSfLru
	 hTIne1/5OaEdW7o0JgbOp//4Wz7zOaPKfBgPlnHBLHYfv8q3MhR2xBfwkx7UEuTe7/Ire
	 N9d2e6ZIszXl4CRv0KTMbBJknv0NapoCfqvIen6mxHIOSR6/1sC85zX/t6RnPXDFmpRha
	 Ybfma+ohAZulHWpTSN1xyObzgwrv3kv6UNZf0wZwtuEpRm8/i42uMkQXEIwKJPItLBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=69/ERYolXjcUn6T0Dz9Ynfq21yJAh2DCbBheTkGp5tw=;
	b=fG+2O2Gu1xn4+sc+vUY1KTVEiNstNujMt/iEO5Kx6mjvRLu+V5ZEDJ5kgpamVogUhUvh
	 jrJocz4gH3tJltAZsJ9k2XOz5X7LpSFSp16mP3KHHYShzui/CSF13zZD+jnd0e0d4Xp1G
	 43bPNJPg6S05Ge0s+UqWOxSx52mvri3B98TF+pG0gkEDcH15nBlO+ZpogkyyGJ8wB6L1k
	 AvNL0dHsP/tf0yTktqtMJOb6PbK7bvryKc/23oF3GVY2w+XRL6Rxwq4QczQbbKZGiCpAH
	 KSqlsGXGB74hKUmBsWHuK1r2wr/fb9Z9RrK2am93agNeKao2VC4v9A6bdDXzwGA0F/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jERnyxCJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC3F606A326;
	Sat,  7 Nov 2026 14:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jERnyxCJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFC31F0089F;
	Sat,  7 Nov 2026 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062892;
	bh=69/ERYolXjcUn6T0Dz9Ynfq21yJAh2DCbBheTkGp5tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jERnyxCJJ5AcXBb7JXBYiLkEXKssH9Pqn7aQas2SdXGqYp08RVKed/Acux0vnXgDE
	 SWE0VikkRDZ4qRRMOqgtaASDG+0h5W6Trc+a9p9CJuYVD48y7wWEYjLI1FIroQM0Z3
	 xj0p8zFMonPjE4ssQwyiBtuZUhrxiVPgU1Sc2rao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/869] iio: imu: inv_icm42600: force accel odr change when switching power mode
Date: Sat,  7 Nov 2026 08:47:32 -0500
Message-ID: <20261107134857.980485288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit d52047d84963e5cf7c8ad502e0adf003fb0669de ]

When accel must switch from low-power mode to low-noise due to a change in
ODR, there is an hardware bug that sometimes prevent the ODR change flag
to be set in the FIFO header. If this happens, the driver is stuck waiting
for the ODR change flag that is never happening.

Fix this by using accel_force_odr flag set when switching mode for forcing
apply of ODR change. Do the apply after parsing FIFO data to let the flag
do the job if it is here.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        | 1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  | 9 ++++++++-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c | 2 ++
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   | 9 +++++++++
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600.h b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
index c8b48a5c5ed06..a44e4ea746a6d 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -177,6 +177,7 @@ struct inv_icm42600_state {
 	struct {
 		s64 gyro;
 		s64 accel;
+		bool accel_force_odr;
 	} timestamp;
 	struct inv_icm42600_apex apex;
 	struct inv_icm42600_fifo fifo;
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
index d19ff0e76c668..d858acad3bfb6 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -1226,9 +1226,11 @@ int inv_icm42600_accel_parse_fifo(struct iio_dev *indio_dev)
 			return size;
 
 		/* update odr */
-		if (odr & INV_ICM42600_SENSOR_ACCEL)
+		if (odr & INV_ICM42600_SENSOR_ACCEL) {
 			inv_sensors_timestamp_apply_odr(ts, st->fifo.period,
 							st->fifo.nb.total, no);
+			st->timestamp.accel_force_odr = false;
+		}
 
 		/* skip packet if no accel data or data is invalid */
 		if (accel == NULL || !inv_icm42600_fifo_is_data_valid(accel))
@@ -1241,5 +1243,10 @@ int inv_icm42600_accel_parse_fifo(struct iio_dev *indio_dev)
 		iio_push_to_buffers_with_timestamp(indio_dev, &buffer, ts_val);
 	}
 
+	if (st->timestamp.accel_force_odr) {
+		inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
+		st->timestamp.accel_force_odr = false;
+	}
+
 	return 0;
 }
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
index 5c3840acf0857..2c3e41a24b33d 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -396,6 +396,8 @@ static int inv_icm42600_buffer_postdisable(struct iio_dev *indio_dev)
 	mutex_lock(&st->lock);
 
 	inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
+	if (sensor == INV_ICM42600_SENSOR_ACCEL)
+		st->timestamp.accel_force_odr = false;
 
 	ret = inv_icm42600_buffer_set_fifo_en(st, st->fifo.en & ~sensor);
 	if (ret)
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
index 76eb22488e5f3..e37b395dbd90b 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -324,6 +324,15 @@ int inv_icm42600_set_accel_conf(struct inv_icm42600_state *st,
 		break;
 	}
 
+	/*
+	 * If we change mode from low-power to low-noise because of odr,
+	 * we need to force odr change.
+	 */
+	if (oldconf->mode == INV_ICM42600_SENSOR_MODE_LOW_POWER &&
+	    conf->mode == INV_ICM42600_SENSOR_MODE_LOW_NOISE &&
+	    conf->odr != oldconf->odr)
+		st->timestamp.accel_force_odr = true;
+
 	/* set ACCEL_CONFIG0 register (accel fullscale & odr) */
 	if (conf->fs != oldconf->fs || conf->odr != oldconf->odr) {
 		val = INV_ICM42600_ACCEL_CONFIG0_FS(conf->fs) |
-- 
2.53.0



