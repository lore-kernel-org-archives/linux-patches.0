Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623745;
	b=1DA+lzANsV4TpW5lApgzWyfapiFKaDLUhMm86VlOtZAn1l4rfu7KbVjkpDCTbaqk+nnH
	 iQMeqCDJ1yJGohFoV2E3LYjIV5XjP0+KuBYrMFjcf1BO3mrkxzMtzD8PPZd2QSWJBkmoE
	 8KxnVr44yBnPFMuvNZHvN765jHY7GPt9imGzLeFhiare5eEMo39K4GuLIL8cQU1mOYnGA
	 NpNOOnjGZuHiBxXZaoRM/Y0bN2UPNC3KAPDbcdyDFYGm2VBzJDUymsbYSb/nulp7uotEk
	 vD6iKdfREhs6ceFjNFcYFA/DxesxwgqzesV9/64xJQppShh3rZJhr2J4pXH8+vBwtwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YTvWnqrEISkfGmU+Q+ZyGfe1uTG6Fjtu3gp4LdiCpR0=;
	b=UXF3hkKAiXMTaTOBzliyy2gCD8JqeIT787L8k9kIUfiii+zo05MN9Q/FW3rY7JWlWjoA
	 uoP9ImPbETr5KB5K3Sh/zj/Nr443DKzJBz8ZxVgvk4eMNR7lQqXQVrN//nKmAYla1wLgh
	 kAsjw+Wy7Cut74mwhnvSSlgZkyehd107p6kPbC6vMyPV0wNj/uQgIC/4ajR7PTUvYnHjD
	 XXywwdRyt+GC/SjeMlVr00UCAg/x7DYzR1C0kLfkj6B/wyxZUKgOduCmvhVhb8oKHHHD8
	 NfbHRsFixt2wkH+aQtGGK1r9LNR2j0mUJKtUYYnqJzi88uai6Ob20pfDLibO3DfOaIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMkhHtT6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABCB606A32E;
	Wed, 25 Nov 2026 16:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMkhHtT6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4842F1F000C6;
	Wed, 25 Nov 2026 16:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623744;
	bh=YTvWnqrEISkfGmU+Q+ZyGfe1uTG6Fjtu3gp4LdiCpR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMkhHtT6soR/oCvDLHYinhb+pVldUsnby9+WjaeH5I9kXcy7To6nCrtG3PCHpvM+m
	 IxKEBQkd5K1B0Pxfj74XBmHdlY7FGFlGHoVpZdmVxYpEgkrznYmIhnzy21XcAAmWL0
	 Y2Hu76jGzl5PX/CX74WQH0x4dB+F12L4H6tHZPdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 956/990] iio: imu: inv_mpu6050: fix magnetometer scale of Y and Z axes
Date: Wed, 25 Nov 2026 15:38:43 +0100
Message-ID: <20261125143844.381253369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


