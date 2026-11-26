Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704806;
	b=Tjp9raVLHcne7vJNlC3NueSyjo4KPa6VlnNahu5BTNWyv3CQ2Xts+79LTHlTGoDIANWm
	 iYxjbQphlaiHumc9EldBDhDHtzGFmhR/4DkWOkLfce1I4RRPMVGSpmV/PDT3wQclknWvK
	 NFUHzBtQyJxmclGHtUEBmetbcv0eR6C31BacfrdrrqWTiieekCqkGNHCj1TgL3sLzvu8M
	 3DLH4W2FI0JObBq+684P1EEAw/Dkp3cbrqCVQoTDWL0oQgzWECsmkZPEEbr1z4rJbNAlz
	 i3Kjwm90gLUwyh90yd/tBC1C8TMVZkbxnHT/fBwXd+pcG0vG1tRKg5aW+UQ0VRurtXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBEi4xksX3EKdmcjtOcBwngTfUcJm/wooFdLhCMyGp8=;
	b=cy08qHq5kPootPtdUxwhPTfsLPM8z6WXOgRIOjWWTUKSjaJzTPlVHOFABPzPkE8Pn12H
	 rpkeKVY2GaXJTLGYnnzCU7heM9Pv6mmHrzWvwS/eCcXOXO6AaQibSXX0xWzVS98xtx0c1
	 0HwdOI+4mRNz4bn18ABHkZukf3VSra25pydqKQsF2SbBQN0NNBNAC4kzqH5xh1ZOdXvaL
	 2cHS+9173aVaBDZFM1rSA9BaPqRR0iBe1Vmdpccl90eNa7x+E5H+/BbPQkcF3XCtqj5TY
	 Dci+eo/rn8LgVyHRM5rcqUZnPuxHTmSLpsS8emhQJQmHmbacCioYfH/rU4aIqM7vzAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKZVnGDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7512F606A330;
	Thu, 26 Nov 2026 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKZVnGDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23D21F000C6;
	Thu, 26 Nov 2026 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704806;
	bh=HBEi4xksX3EKdmcjtOcBwngTfUcJm/wooFdLhCMyGp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKZVnGDUN8pDiw8o32w4Spj8q9EtSIlNiH224NbrMdi5tI6qxLg3aI/D3D/o32sbp
	 yqV3Jzt9nCLjbkjouiWSt/3cMc0dsavjQGhjRiZrDdJX2TameypGqEf17B3lZ3U+Ph
	 uRdfBcw2h38fZogDoMxQVqdmh4dASSaZnvINGyso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 250/265] iio: imu: inv_mpu6050: fix magnetometer scale of Y and Z axes
Date: Thu, 26 Nov 2026 15:39:40 +0100
Message-ID: <20261126143622.717976710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -1137,6 +1137,8 @@ static const unsigned long inv_mpu_scan_
 		.type = IIO_MAGN,					\
 		.modified = 1,						\
 		.channel2 = _chan2,					\
+		/* index of the axis in magn_raw_to_gauss[] */		\
+		.address = (_chan2) - IIO_MOD_X,			\
 		.info_mask_separate = BIT(IIO_CHAN_INFO_SCALE) |	\
 				      BIT(IIO_CHAN_INFO_RAW),		\
 		.scan_index = _index,					\


