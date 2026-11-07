Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064091;
	b=grTpFinyi+hlHhjgZdbIoqD8sPzYjZOllRgzfcLXRxq47gZf6iJ73ANMeMhWlrq8Ri+b
	 G9zpFPlgDggO47LclJKpjUcE1CGKUU1Goy0Wf1Xw+6BzAuj23JJuIGfJYkXYsf3DHvp3+
	 sKlzt1RUjzR1m1a9XEvKPv9c0WdB1bCvZE5mT6EgSBqjdvZ5sVgK2i4rpuersn6r7Vt9W
	 TSMTfBcHSUXS8x9DPfL2XUzBv3mx62pDwrdWIdp7Kz0NuDxajPUpssKeKd/C1CgEelLSw
	 kyLxNlG5+K9vDDNlPcx3ryG1o66xF7r7emPWYEvYAZWAtbIrw1NBcVOC5rCEUy84UYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Us3Zp/O7p7PVB/MVUep017+ego2wI3ltuwnJtmPc3f8=;
	b=JuJAy0pbn0WhKfywJiYaJOX+RZgZLYcW8BwapPMzjJUdu63uPXw43PDlmikCSmSOWX3K
	 4hNJYMDLaZ3ldtpwtnALqjq/T2OphkUOqO/NpQKzl6o1VJ3foprVE1nH1qZvE89m8dxB6
	 lGMauFVyf/Kvi2At/WtSCV77w2/RMKVl4lJp+ep3yiZqGpcyeTz95YQoPVUh0hCbqoMPD
	 Ui7JH6Pok87RD0YkUDSkfcScVBdIZ8QzbqljBqSUKpUuBfZhgxJce3ezxHU7y3HubyBuB
	 pkZw/7gs9Dr7mGukSJU0ER6Arj/Dy858i8ziou3UIBl4vDvdFm/djfpFhknGtgcFU/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/C6uR5V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6D4606A9EE;
	Sat,  7 Nov 2026 15:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/C6uR5V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB9E1F0089F;
	Sat,  7 Nov 2026 15:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064090;
	bh=Us3Zp/O7p7PVB/MVUep017+ego2wI3ltuwnJtmPc3f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/C6uR5VxhZWU3vterWdcYzs0j1Zo48lwalqnLY5C4lkUG/LDpJTH8ICOqyImFsct
	 xEGGHUkZQv0eheT9aW76nhR78T01PIeVCnt9mYhdVNHJVEPvRLhr8t/H+uiSuOJzlE
	 3bugTN0Q/gXE0/qfHV0ROruICiyoBQMySgaol1CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0215/1257] iio: imu: inv_icm42600: force accel odr change when switching power mode
Date: Sat,  7 Nov 2026 08:41:51 -0500
Message-ID: <20261107134945.477190585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b55d993f02643..15fc8395da527 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -179,6 +179,7 @@ struct inv_icm42600_state {
 	struct {
 		s64 gyro;
 		s64 accel;
+		bool accel_force_odr;
 	} timestamp;
 	struct inv_icm42600_apex apex;
 	struct inv_icm42600_fifo fifo;
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
index b2ad1bd202b4f..aea9bbc188da2 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -1228,9 +1228,11 @@ int inv_icm42600_accel_parse_fifo(struct iio_dev *indio_dev)
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
@@ -1243,5 +1245,10 @@ int inv_icm42600_accel_parse_fifo(struct iio_dev *indio_dev)
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
index 998d312f7bde3..c871981d2dadd 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -399,6 +399,8 @@ static int inv_icm42600_buffer_postdisable(struct iio_dev *indio_dev)
 	mutex_lock(&st->lock);
 
 	inv_sensors_timestamp_apply_odr(ts, 0, 0, 0);
+	if (sensor == INV_ICM42600_SENSOR_ACCEL)
+		st->timestamp.accel_force_odr = false;
 
 	ret = inv_icm42600_buffer_set_fifo_en(st, st->fifo.en & ~sensor);
 	if (ret)
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
index dc97d8a274e36..e28f012e62b1a 100644
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



