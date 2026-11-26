Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705758;
	b=Rl8n8urusp7/Im16cKXRZExhRIZp5GlvEQHXlxJLdidoiOv1nceHBpyPoKqF9JMy7PbO
	 t5y/yaUHXLI45Z+IikGuoLYmPra9sGbkwXWLsEyfPI2HaeeTzkzKTpGQWZqkI7tJ3u9AE
	 5UL44WAUnWnB66snM9J15Xl15EStAFlUUkZfoXsH5yRctVxue+rZ+oe01IhPoHJA+KysT
	 dbmCfxHCFWvQB/CzucISujNcQ5ruHnYr2Hw5GAoQZYi5/ytLlVuxiNwl8kyQLXWhxZez1
	 7rHEMd/SOmsbh/RpUkuBo6UqsSImfs3j8iWMAGziFYV6Soa9vZW4Rl8IxsQ+9hUncNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PBH+jNfulQ5xDcfmJPzNBA82vl2XH7OOVmKysonBg/c=;
	b=Nflsp/X2E+40sVDzpbRZb7XphsFZeOSZLODsisrRjl+zq4MzIpUOu9sB/EW2y3Zsedi8
	 ACWhsEsuraLrrhYv6jDJiS1ovh/F5DwsyASFYOw7ZWlEBTtvNVxtq8nQoPGQgTgookOwf
	 MVR/FdVY1PLwE/dL6fTXWmezFKB9lGoFsUpa+P5C0DHzElE7RdviQQ1kPvC1+xs6PhShV
	 RYLIvnFCjYs0YeC43KN0N2LZQFuIzdIOGe0hls8gNKvql+V/DimgIeIthIzfe8tSvTHLH
	 sSBWgHUQCImDZy+9MOClcXKYuJg1GDtkmFkwVhYXObHfsUndOIFXbPa3VJC+rILps8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8Ed04pD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15454606A321;
	Thu, 26 Nov 2026 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8Ed04pD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B381F000D1;
	Thu, 26 Nov 2026 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705757;
	bh=PBH+jNfulQ5xDcfmJPzNBA82vl2XH7OOVmKysonBg/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8Ed04pDVWTFdeFqgxrz6X/+whxXzMXwEBxx7FakrhMeDrissKYPPm7FhvvQXAOr1
	 fGwk0qhGh0EBLNJQf4RpOjYifYFeqV8+F282apOcSwMaictj4lLs5R1kReO9NxwhI+
	 S/LQZok4R7Q5B1PxT5231vxFK119M8wmBENJoAQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 304/319] iio: imu: inv_mpu6050: fix magnetometer scale of Y and Z axes
Date: Thu, 26 Nov 2026 15:41:12 +0100
Message-ID: <20261126144013.619282956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnav Kapoor <kapoorarnav43@gmail.com>

commit e5f7a6684a23d9b20184a81b4ebded3b3504ccdc upstream.

inv_mpu_magn_get_scale() returns st->magn_raw_to_gauss[chan->address],
where magn_raw_to_gauss[] holds one coefficient per axis, computed in
inv_magn_init() from the per-axis factory sensitivity adjustment values
(ASAX, ASAY, ASAZ) of the AK8975/AK8963 magnetometer.

However INV_MPU9X50_MAGN_CHAN() never sets .address, so it is 0 for all
three magnetometer channels. As a result the Y and Z channels report the
scale computed from the X axis adjustment value, and userspace scales
the Y and Z readings with the wrong per-axis calibration.

Set .address to the axis index (0 for X, 1 for Y, 2 for Z) in the
channel macro, matching the order used to fill magn_raw_to_gauss[].

Fixes: b1392de06184 ("iio: imu: inv_mpu6050: add MPU925x magnetometer support")
Signed-off-by: Arnav Kapoor <kapoorarnav43@gmail.com>
Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -1153,6 +1153,8 @@ static const unsigned long inv_mpu_scan_
 		.type = IIO_MAGN,					\
 		.modified = 1,						\
 		.channel2 = _chan2,					\
+		/* index of the axis in magn_raw_to_gauss[] */		\
+		.address = (_chan2) - IIO_MOD_X,			\
 		.info_mask_separate = BIT(IIO_CHAN_INFO_SCALE) |	\
 				      BIT(IIO_CHAN_INFO_RAW),		\
 		.scan_index = _index,					\


