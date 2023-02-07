Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D354B2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4652FC4339B;
	Tue,  7 Feb 2023 13:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775122;
	bh=7Zh6+6uu1xARXr1+iq9wDoel6vMURA8Hu632DijSVJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XU5bswnbW12cWhlRkbpquAmZ/onauo+ndRYckl+cJtzHCvrUEdtAATaNTLP/gmnkj
	 XHFSy5TYV1N5+1xb1yvcrKkvk+cHobGzJM9z/5eQ8pYtDQoD0E8JbNzdKHqxx61PBq
	 Thq3apRWzMQFS3rii2GHnatoRNC2qdNgm/vxLAgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 142/208] iio: imu: fxos8700: fix map label of channel type to MAGN sensor
Date: Tue,  7 Feb 2023 13:56:36 +0100
Message-Id: <20230207125640.854923307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Carlos Song <carlos.song@nxp.com>

commit 429e1e8ec696e0e7a0742904e3dc2f83b7b23dfb upstream.

FXOS8700 is an IMU sensor with ACCEL sensor and MAGN sensor.
Sensor type is indexed by corresponding channel type in a switch.
IIO_ANGL_VEL channel type mapped to MAGN sensor has caused confusion.

Fix the mapping label of "IIO_MAGN" channel type instead of
"IIO_ANGL_VEL" channel type to MAGN sensor.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20221208071911.2405922-2-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -320,7 +320,7 @@ static enum fxos8700_sensor fxos8700_to_
 	switch (iio_type) {
 	case IIO_ACCEL:
 		return FXOS8700_ACCEL;
-	case IIO_ANGL_VEL:
+	case IIO_MAGN:
 		return FXOS8700_MAGN;
 	default:
 		return -EINVAL;


