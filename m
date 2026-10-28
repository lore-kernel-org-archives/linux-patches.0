Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214595;
	b=NakVo/29m/9NVUPx13KYQOcVqTXS+zd4dDU0hUdahzqSrPwiX2o00LqK3yTJJGkOyVt9
	 MFWLxGXAPnxO/cvgd3qyXRmKG767o2pHuBi6G52C8U7J+sIRLoXTvxkHzWRwMK03k0cWE
	 RufFe7PPb9/66fvbmDXF/PKFg5Nfc5lBE+HwzGnHlYi0Om9VvXE3D41YkIpmXhYN3KQMK
	 HHtsjN/EREItcyDQYw8qYqSDJxees7igZVXsmP/YcnI8rtE6TaiGfo9dcsj7AHQKtfWcQ
	 HX1ssrkrcxLMCZPKTPLY6iw3OT/oqvUZyjATbGOC0yOb0IZbX1fFbBBsazYPGTdB4/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gi4GNvOhxT2q0hhGr3D+5G3C5Cp9WtxcW7JYrRFMiqY=;
	b=cTG/0gLJQbiP3cWdymiQ11cXWb0qJyxI/xyVWtYw+zBFAjHhL7N1deIzTDhKsfXC9NtM
	 CB5yr8tOtUnlgJieGXymu7CHDEKFELMoYAz3Do+0TGAgfGuJS3L/9FtmROARf8MWBv+52
	 wnzl9VQLwA/OjVFCOkN3pdx9IF01duF52u1OYHciBsvZZQfXl4TACmmN3oGcT/IiN7gHj
	 0IzqEeWYHKaeqEQhAG3EPYXPVQHgu/dT91u4g4q/bEK9hmj2AvrDwLE4mZivXDUoE/Rzv
	 4ZVbzFENupkknyDXAESgSZ7nwhV2gyMyJlb9qqTLmjsCnvj9EZUD52Ar31JCAfVaRhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jr1ALN5b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE2E606AB07;
	Wed, 28 Oct 2026 19:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jr1ALN5b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B164F1F01825;
	Wed, 28 Oct 2026 19:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214595;
	bh=Gi4GNvOhxT2q0hhGr3D+5G3C5Cp9WtxcW7JYrRFMiqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jr1ALN5bDoAUN7iUBmzPmPLUwJTlYHGC8P/YcSr9BXiS2nYLALjQmimCIbbTNDyoN
	 UCYSZrRdKoOa1FKAkzfkJkgIbAp8Gj4U2L2ddjhA0UEdFBsrjXTtX323DTnLU/Nx6A
	 LQKJE71zbxw7rxvLQKUEPSwHq6B7HsqQRMmuuMno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0915/1887] iio: imu: st_lsm6dsx: fix iio_chan_spec for sensors without event detection
Date: Wed, 28 Oct 2026 17:50:11 +0100
Message-ID: <20261028170520.236339269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit c34e2e2d67b3bb8d5a6d09b0d6dac845cdd13fb3 ]

The st_lsm6dsx_acc_channels array of struct iio_chan_spec has a non-NULL
event_spec field, indicating support for IIO events. However, event
detection is not supported for all sensors, and if userspace tries to
configure accelerometer wakeup events on a sensor device that does not
support them (e.g. LSM6DS0), st_lsm6dsx_write_event() dereferences a NULL
pointer when trying to write to the wakeup register.
Define an additional struct iio_chan_spec array whose members have a NULL
event_spec field, and use this array instead of st_lsm6dsx_acc_channels for
sensors without event detection capability.

Fixes: b5969abfa8b8 ("iio: imu: st_lsm6dsx: add motion events")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 6936db2e72f88..3b3a04e5d9497 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -83,6 +83,13 @@ static const struct iio_chan_spec st_lsm6dsx_acc_channels[] = {
 	IIO_CHAN_SOFT_TIMESTAMP(3),
 };
 
+static const struct iio_chan_spec st_lsm6ds0_acc_channels[] = {
+	ST_LSM6DSX_CHANNEL(IIO_ACCEL, 0x28, IIO_MOD_X, 0),
+	ST_LSM6DSX_CHANNEL(IIO_ACCEL, 0x2a, IIO_MOD_Y, 1),
+	ST_LSM6DSX_CHANNEL(IIO_ACCEL, 0x2c, IIO_MOD_Z, 2),
+	IIO_CHAN_SOFT_TIMESTAMP(3),
+};
+
 static const struct iio_chan_spec st_lsm6dsx_gyro_channels[] = {
 	ST_LSM6DSX_CHANNEL(IIO_ANGL_VEL, 0x22, IIO_MOD_X, 0),
 	ST_LSM6DSX_CHANNEL(IIO_ANGL_VEL, 0x24, IIO_MOD_Y, 1),
@@ -124,8 +131,8 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 		},
 		.channels = {
 			[ST_LSM6DSX_ID_ACC] = {
-				.chan = st_lsm6dsx_acc_channels,
-				.len = ARRAY_SIZE(st_lsm6dsx_acc_channels),
+				.chan = st_lsm6ds0_acc_channels,
+				.len = ARRAY_SIZE(st_lsm6ds0_acc_channels),
 			},
 			[ST_LSM6DSX_ID_GYRO] = {
 				.chan = st_lsm6ds0_gyro_channels,
-- 
2.53.0



