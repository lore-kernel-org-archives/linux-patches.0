Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620626;
	b=cqTsih9bY7/Jj8mwhZhyTDvXB20N09MjBLxyL+58e1fTNuin9RF4znPmRvxmPIDDdF5T
	 WFvqmkWUk3RI4bUtsR3/wB5kAl5HprVCHBqWAxQXEsD7ZWATKPX0kgn+ePDadDMqGJpF4
	 6RDqdBJds0u4kob2pRZ/sJ1vk9NMT27926coUWpacmM72+sOe4xD7QHMqVJblp+TYcs2l
	 ktniMXQGUTdfQQoczpQkl9EoZAGrgAIo9TIJ/j7oXGZVX4QaOJc3Hc/djJ+curO1rtHsL
	 YzLInMpekyMN4buyOlU9wQBOthuiYfWpMQfpvBKZjkQSUNr2JMft85X+Zaepshjf0hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zM6BdQek21q4XHJIHu/poUwNFZkkI3t4Sx2jos0jTtA=;
	b=qJQFhf/e75PeP1OmSJDpcjqkQID84ZbfBkGt6BXVpNQwByrQD0cIlB1al5X4vhAVGJ+u
	 FuKUnpTJO9SU73SCrmTYxG+XrrxNy8fm0IASsmI8C3L/k5IKIC4G0jRCVjmVX6gI3Dp3w
	 yYEajE/wc6QwyIJ0V8jJOG9MC+/SIx7a30TOqcznykMrSzuQ/oXGDg6DFD/Wa4GtT99kg
	 74e/P9AcZbIXypHJF6XdTgiOmsSRyZbEHzxelBxAVMI8OWX/YJInPrdHi0Mw1JoF2m+sN
	 8wl0H0Li6+36zoTrR44+p2nqwCuVqM25gJYBSF18sJmlBrNNhVegMKRIwrVY1YRvf2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuqYj27U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F1C606A329;
	Wed, 25 Nov 2026 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuqYj27U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0736B1F000C0;
	Wed, 25 Nov 2026 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620625;
	bh=zM6BdQek21q4XHJIHu/poUwNFZkkI3t4Sx2jos0jTtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuqYj27U4WulSA7D7q3eFX28WW5vLTZyZbTljv5i2CweSdVpJ0Ec11PkPQ49Qitdt
	 tOer8fwrvcIZs8VmmoaQXrnI34YwD8PGF1WbhvpzHd4YATg7uypEBKV/P64Nr7/XUx
	 RNVHfIVUByWJUpaWMutb5/8WRhC6decvoC0Ar94I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0978/1005] iio: imu: inv_mpu6050: fix magnetometer scale of Y and Z axes
Date: Wed, 25 Nov 2026 15:38:36 +0100
Message-ID: <20261125143844.572786023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -1574,6 +1574,8 @@ static const unsigned long inv_mpu_scan_
 		.type = IIO_MAGN,					\
 		.modified = 1,						\
 		.channel2 = _chan2,					\
+		/* index of the axis in magn_raw_to_gauss[] */		\
+		.address = (_chan2) - IIO_MOD_X,			\
 		.info_mask_separate = BIT(IIO_CHAN_INFO_SCALE) |	\
 				      BIT(IIO_CHAN_INFO_RAW),		\
 		.scan_index = _index,					\


